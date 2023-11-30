import pickle
import h5py
import numpy as np
import torch
import copy
import ast




# R-M data
filepath = '../R-M data/final_output.mat'
file = h5py.File(filepath)
dataset = file['final_output']
data = np.array(dataset)
data_flipped = np.transpose(data, (3, 2, 1, 0))
full_data = data_flipped





# PICKLE: STORE AND LOAD

# This is a void function
def save_to_pickle(obj, filename):
    """
    Saves a Python object to a file using the pickle module.

    :param obj: The Python object to be saved
    :param filename: The name of the file where the object will be stored
    """
    with open(filename, 'wb') as file:
        pickle.dump(obj, file)


def load_from_pickle(filename):
    """
    Loads a Python object from a file using the pickle module.

    :param filename: The name of the file where the object is stored
    :return: The loaded Python object
    """
    with open(filename, 'rb') as file:
        obj = pickle.load(file)
    return obj


def get_RM_full_data(filepath):
    file = h5py.File(filepath)
    dataset = file['final_output']
    data = np.array(dataset)
    data_flipped = np.transpose(data, (3, 2, 1, 0))
    full_data = data_flipped
    return full_data



## GETTING THE SIMULATOR DONE
def position_in_five(parameter):
    if abs(parameter - 0.2) < 1e-3:
        return 1
    elif abs(parameter - 0.3) < 1e-3:
        return 2
    elif abs(parameter - 0.4) < 1e-3:
        return 3
    elif abs(parameter - 0.5) < 1e-3:
        return 4
    elif abs(parameter - 0.6) < 1e-3:
        return 5
    else:
        return None

def get_one_sample(array):
    num_rows = array.shape[0]
    random_row_index = np.random.randint(2, num_rows)
    random_row = array[random_row_index]
    return torch.tensor(random_row)



def get_data_reduced(value_0, value_1):
    # For baseline, the region can simply be approximated by h+m <= 0.8
    value_0_round = round(value_0, 1)
    value_1_round = round(value_1, 1)

    save_0 = value_0_round; save_1 = value_1_round

    if value_0_round + value_1_round > 0.8:
        value_0_round = 0.8 - save_1
        value_1_round = 0.8 - save_0

    m_position = position_in_five(value_0_round);
    h_position = position_in_five(value_1_round);

    if m_position == None or h_position == None:
        print("None error")

    m_file_position = (m_position - 1)*5
    h_file_position = (h_position - 1)*5

    return get_one_sample(full_data[m_file_position, h_file_position, :, :])


def round_to_nearest(value, step):
    return round(value / step) * step

def get_data_full(value_0, value_1):
    # For baseline, the region can simply be approximated by h+m <= 0.8
    step = 0.02
    value_0_round = round_to_nearest(value_0, step)
    value_1_round = round_to_nearest(value_1, step)
    save_0 = value_0_round; save_1 = value_1_round
    if value_0_round + value_1_round > 0.8:
        value_0_round = 0.8 - save_1
        value_1_round = 0.8 - save_0


    m_file_position = int(round((value_0_round - 0.2)/0.02))
    h_file_position = int(round((value_1_round - 0.2)/0.02))


    return get_one_sample(full_data[m_file_position, h_file_position, :, :])


def ODE_simulator_reduced(parameter_set):
    numpy_para = parameter_set.numpy()
    m = numpy_para[0]; h = numpy_para[1];
    one_sample_from_the_set = get_data_reduced(m,h)
    return one_sample_from_the_set



def ODE_simulator_on_fine_grids(parameter_set):
    numpy_para = parameter_set.numpy()
    m = numpy_para[0]; h = numpy_para[1];
    one_sample_from_the_set = get_data_full(m,h)
    return one_sample_from_the_set




def get_sample(df_np, number_of_observations):
    """
        Get certain number of samples from [X, Y, T] data

        :param df_np: a 2-d numpy array, usually a [X, Y, T] sheet given some (m,h)
        :param number_of_observations: sample size
    """
    df_copy = copy.deepcopy(df_np)
    np.random.shuffle(df_copy) # void method
    return df_copy[0:number_of_observations,:]


## ======================= Embedded simulation===========================================
def in_parameter_regime(r, k, a, b, m, h):
    """
        parameter regime check
    """
    if h < k * (a * b - m) / (a * b + m) and m < a * b:
        return True
    else:
        return False


def get_xy_simulation(m, h):
    # Initialize parameters
    r = 1;k = 1;a = 2
    b = 0.5  # baseline valeus

    try:
        if in_parameter_regime(r, k, a, b, m, h) == False:
            raise ValueError("Parameter not in regime")
        n = 500000  # number of time-step for ODE simulations
        xy = np.zeros((n, 2))
        xy[0, :] = [0.1, 0.02]  # Initial values for x and y

        # Specify parameter bases
        r_bar = 1;k_bar = 1;a_bar = 2;b_bar = 0.5
        m_bar = m;h_bar = h

        # time step
        dt = 0.01;sqrt_dt = np.sqrt(dt)

        # Noise and other parameters
        gamma = 1;sigma = 0.1

        # Seed and random number generation
        #np.random.seed(1)
        epsilon = np.random.randn(n, 3)

        # Main loop
        for i in range(1, n):
            currx, curry = xy[i - 1]

            dr = gamma * (r_bar - r) * dt + sigma * np.sqrt(r) * epsilon[i, 0] * sqrt_dt
            r += dr
            dh = gamma * (h_bar - h) * dt + sigma * np.sqrt(h) * epsilon[i, 1] * sqrt_dt
            h += dh
            dm = gamma * (m_bar - m) * dt + sigma * np.sqrt(m) * epsilon[i, 2] * sqrt_dt
            m += dm

            xy[i, 0] = (r * currx * (1 - currx / k) - a * currx * curry / (currx + h)) * dt + currx
            xy[i, 1] = (a * b * currx * curry / (currx + h) - m * curry) * dt + curry

        return xy

    except ValueError as ve:
        # Handle ValueError
        return f"Error: {ve}"

    except Exception as e:
        # Handle other exceptions
        return f"An unexpected error occurred: {e}"


# data_test = run_simulation(0.2, 0.2)


# Assuming data_tensor and curr_tensor are already defined as NumPy arrays
# and 'counter' is set to a valid index
def get_xyt(data_test):
    dat = data_test[250:, :]

    # Parameters
    dt = 0.01
    yt = 0.2; xt = 0.2 # Thresholds



    # Convert the string back to a list of lists
    # if (isinstance(dat, str)):
    #     array_list = ast.literal_eval(dat)
    #     dat = np.array(array_list)

    # boolean_array = dat[:, 1] > yt
    # c1 = np.argmax(boolean_array)



    # Initialization
    per, x_max, x_min, y_max, y_min, x_amp, y_amp = [], [], [], [], [], [], []
    j = 0

    while len(dat) > 0:
        yc1 = np.argmax(dat[:, 1] < yt)
        xc1 = np.argmax(dat[yc1:, 0] > xt)
        yc2 = np.argmax(dat[yc1 + xc1:, 1] > yt)
        yc3 = np.argmax(dat[yc1 + xc1 + yc2:, 1] < yt)

        if yc3 > 0:
            curr_period_end_index = yc1 + xc1 + yc2 + yc3 - 1

            per.append((yc3 + yc2 + xc1) * dt)
            x_max.append(np.max(dat[:curr_period_end_index, 0]))
            x_min.append(np.min(dat[:curr_period_end_index, 0]))
            y_max.append(np.max(dat[:curr_period_end_index, 1]))
            y_min.append(np.min(dat[:curr_period_end_index, 1]))
            x_amp.append(x_max[j] - x_min[j])
            y_amp.append(y_max[j] - y_min[j])

            j += 1
            dat = dat[yc1 + xc1 + yc2 + yc3:]
        else:
            break

    return np.column_stack((x_amp, y_amp, per))



def ODE_simulator_embedded(parameter_set):
    numpy_para = parameter_set.numpy()
    m = numpy_para[0]; h = numpy_para[1]
    step = 0.02
    save_m = m
    save_h = h
    if m + h > 0.8:
        m = 0.8 - save_h
        h = 0.8 - save_m

    data_sim = get_xy_simulation(m,h)
    data_xyt = get_xyt(data_sim)

    one_sample_from_the_set = get_one_sample(data_xyt)
    return one_sample_from_the_set


# xy_simulation = get_xy_simulation(0.2,0.2)
# data_final_test = get_xyt(xy_simulation)
# print(data_final_test[0:2, :])

test_parameter_sample = torch.tensor([0.2, 0.2])
test_sim_data = ODE_simulator_embedded(test_parameter_sample)
print(test_sim_data)
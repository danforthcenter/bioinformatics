#!/usr/bin/env python

import sys
sys.path.append("/opt/DIRT")
import os
import scipy
import argparse
from dirtIO import IO
from Preprocessing import Preprocessing
from fixImageOrientation import fix_orientation


def options():
    parser = argparse.ArgumentParser(description='Test a range of thresholds on an image using DIRT.', formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument("-i", "--image", help="Input image.", required=True)
    parser.add_argument("-t", "--thresholds", help="Comma-separated list of threshold multiplier values.", default="1,5,10,15,20")
    args = parser.parse_args()

    return args


def main():
    args = options()
    # IO processing
    io = IO()
    # Set working paths to job directory
    io.setHomePath(os.getcwd())
    io.setServerPath(os.getcwd())
    # We have to make some directories to store DIRT outputs
    if not os.path.exists('Mask'):
        os.mkdir('Mask')
    if not os.path.exists(os.path.join('Crown','Plots')):
        os.makedirs(os.path.join('Crown','Plots'))
    if not os.path.exists(os.path.join('Crown','Result')):
        os.makedirs(os.path.join('Crown','Result'))
    # Set filename
    imgName = os.path.basename(args.image)

    # Parse thresholds
    thrTestValues = args.thresholds.split(",")
    # Open the image
    try:
        fix_orientation(args.image, save_over=True)
        img = scipy.misc.imread(args.image, flatten=True)
    except:
        print('Image not readable')
    # Apply each threshold to the image
    for value in thrTestValues:
        io.setFileName(imgName[:-4] + "_threshold_" + str(value))
        prep = Preprocessing(io)
        _ = prep.prepocess(img, 1, scale=int(value), nrExRoot=1, marker=39.0, stemCorrection=1)


if __name__ == "__main__":
    main()

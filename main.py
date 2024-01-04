import numpy as np
import matplotlib.pyplot as plt

c = 3e8
f = 60e9
g = 0.0046
w = 1.5
Es = 1
lambd = c / f


TR13C_origin = np.array([0,0,0])
TR13C_Tx_pt = np.array([-lambd/2, +lambd/2, 0])
TR13C_R1_pt = np.array([-lambd/2, -lambd/2, 0])
TR13C_R2_pt = np.array([+lambd/2, +lambd/2, 0])
TR13C_R3_pt = np.array([+lambd/2, -lambd/2, 0])

reflector_pt = np.array([0, 1, 0])

azi_start = -70
azi_stop = +70
azi_step = 1

ele_start = -70
ele_stop = +70
ele_step = 1

R = 1

phased_r31 = np.zeros((int((azi_stop-azi_start+1)/azi_step), int((ele_stop-ele_start+1)/ele_step)))
phased_r32 = np.zeros((int((azi_stop-azi_start+1)/azi_step), int((ele_stop-ele_start+1)/ele_step)))

az_idx = 0
for azi_deg in np.linspace(azi_start, azi_stop, int((azi_stop-azi_start+1)/azi_step)):
    azi_rad = azi_deg * np.pi / 180
    el_idx = 0
    for ele_deg in np.linspace(ele_start, ele_stop, int((ele_stop-ele_start+1)/ele_step)):
        ele_rad = ele_deg * np.pi / 180
        reflector_pt = np.array(
            [ R * np.cos(ele_rad) * np.sin(azi_rad),
              R * np.cos(ele_rad) * np.cos(azi_rad),
              R * np.sin(ele_rad) ]
        )
        pathd_tr1 = np.linalg.norm(reflector_pt - TR13C_Tx_pt, 2) + np.linalg.norm(reflector_pt - TR13C_R1_pt, 2)
        pathd_tr2 = np.linalg.norm(reflector_pt - TR13C_Tx_pt, 2) + np.linalg.norm(reflector_pt - TR13C_R2_pt, 2)
        pathd_tr3 = np.linalg.norm(reflector_pt - TR13C_Tx_pt, 2) + np.linalg.norm(reflector_pt - TR13C_R3_pt, 2)
        phased_r31[az_idx, el_idx] = 2*np.pi*(pathd_tr3 - pathd_tr1)/lambd
        phased_r32[az_idx, el_idx] = 2*np.pi*(pathd_tr3 - pathd_tr2)/lambd
        el_idx += 1
    az_idx += 1

_ = plt.pcolor(phased_r31)
_ = plt.show()
        
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 969DD2FC86B;
	Tue,  2 Sep 2025 13:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819435; cv=none; b=EJvT6Wi4RkhYbHPK0N+oB8v90NINkjU2J2KnTurv55uIG4twEIGmaoom30LQiEdpXWIYu4mQg0KQ9gtjIztrB2sJr6v66wC+Sxfi4IgXXhKJ7BKV9lxGTTihLCsAaafkcIXX+ahZk7RlXnM8dZWfSLdoFw+eqqCV3h2k6vHIkW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819435; c=relaxed/simple;
	bh=ACvkJaAwwr9GjeLxuvgyBoiXJbsQ9U9DU+tXPKYIUsc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=h1+n/86sbvnhwWQzKpUf98DI8vvieCbNQfroX9nAV73DDVLhl6LZKf/NHNZITquDUGcF3CHMa/dkL6Im7OeS16CQfkXY4NV+SgCNKwCKQh30sePu+8wMiN7vD9lqJnoDlxR9cPIGI7kyaO4IH+AX0R/BLM2ZoSzrO9PllovBpq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2miLUS/d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2miLUS/d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95F6CC4CEED;
	Tue,  2 Sep 2025 13:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819435;
	bh=ACvkJaAwwr9GjeLxuvgyBoiXJbsQ9U9DU+tXPKYIUsc=;
	h=From:To:Cc:Subject:Date:From;
	b=2miLUS/d9O3l/X4AcNyEDjXmXalxtUcHihbBODcMgRfl5Fsx072F1AcsXvxMdxKrr
	 QuMoVZXVruQt/Ul2chHLhNFwzcNIfXv2rnDXS6wFoXnxko0NuAk0bmF8SAhlM1/Pkt
	 yY4mKwdy2he0WNgZVGz1vlBW/Dy+FN+vQWBWQqug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org,
	akpm@linux-foundation.org,
	linux@roeck-us.net,
	shuah@kernel.org,
	patches@kernelci.org,
	lkft-triage@lists.linaro.org,
	pavel@denx.de,
	jonathanh@nvidia.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org
Subject: [PATCH 6.16 000/142] 6.16.5-rc1 review
Date: Tue,  2 Sep 2025 15:18:22 +0200
Message-ID: <20250902131948.154194162@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.5-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.16.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.16.5-rc1
X-KernelTest-Deadline: 2025-09-04T13:19+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.16.5 release.
There are 142 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 04 Sep 2025 13:19:14 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.5-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.16.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.16.5-rc1

Mason Chang <mason-cw.chang@mediatek.com>
    thermal/drivers/mediatek/lvts_thermal: Add mt7988 lvts commands

Mason Chang <mason-cw.chang@mediatek.com>
    thermal/drivers/mediatek/lvts_thermal: Add lvts commands and their sizes to driver data

Mason Chang <mason-cw.chang@mediatek.com>
    thermal/drivers/mediatek/lvts_thermal: Change lvts commands array to static const

Imre Deak <imre.deak@intel.com>
    Revert "drm/dp: Change AUX DPCD probe address from DPCD_REV to LANE0_1_STATUS"

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    firmware: qcom: scm: request the waitqueue irq *after* initializing SCM

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    firmware: qcom: scm: initialize tzmem before marking SCM as available

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    firmware: qcom: scm: take struct device as argument in SHM bridge enable

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    firmware: qcom: scm: remove unused arguments from SHM bridge routines

Eric Dumazet <edumazet@google.com>
    net: rose: fix a typo in rose_clear_routes()

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gfx12: set MQD as appriopriate for queue types

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gfx11: set MQD as appriopriate for queue types

Jesse.Zhang <Jesse.Zhang@amd.com>
    drm/amdgpu: update firmware version checks for user queue support

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/userq: fix error handling of invalid doorbell

Yang Wang <kevinyang.wang@amd.com>
    drm/amd/amdgpu: disable hwmon power1_cap* for gfx 11.0.3 on vf mode

Ma Ke <make24@iscas.ac.cn>
    drm/mediatek: Fix device/node reference count leaks in mtk_drm_get_all_drm_priv

Nathan Chancellor <nathan@kernel.org>
    drm/msm/dpu: Initialize crtc_state to NULL in dpu_plane_virtual_atomic_check()

Timur Tabi <ttabi@nvidia.com>
    drm/nouveau: fix error path in nvkm_gsp_fwsec_v2

James Jones <jajones@nvidia.com>
    drm/nouveau/disp: Always accept linear modifier

Thomas Hellström <thomas.hellstrom@linux.intel.com>
    drm/xe/vm: Clear the scratch_pt pointer on error

Eric Sandeen <sandeen@redhat.com>
    xfs: do not propagate ENODATA disk errors into xattr code

Steve French <stfrench@microsoft.com>
    smb3 client: fix return code mapping of remap_file_range

Fabio Porcedda <fabio.porcedda@gmail.com>
    net: usb: qmi_wwan: add Telit Cinterion LE910C4-WWX new compositions

Shuhao Fu <sfual@cse.ust.hk>
    fs/smb: Fix inconsistent refcnt update

Shanker Donthineni <sdonthineni@nvidia.com>
    dma/pool: Ensure DMA_DIRECT_REMAP allocations are decrypted

Bart Van Assche <bvanassche@acm.org>
    blk-zoned: Fix a lockdep complaint about recursive locking

Kees Cook <kees@kernel.org>
    arm64: mm: Fix CFI failure due to kpti_ng_pgd_alloc function signature

Alex Deucher <alexander.deucher@amd.com>
    Revert "drm/amdgpu: fix incorrect vm flags to map bo"

Minjong Kim <minbell.kim@samsung.com>
    HID: hid-ntrig: fix unable to handle page fault in ntrig_report_version()

Ping Cheng <pinglinux@gmail.com>
    HID: wacom: Add a new Art Pen 2

Matt Coffin <mcoffin13@gmail.com>
    HID: logitech: Add ids for G PRO 2 LIGHTSPEED

Antheas Kapenekakis <lkml@antheas.dev>
    HID: quirks: add support for Legion Go dual dinput modes

Martin Hilgendorf <martin.hilgendorf@posteo.de>
    HID: elecom: add support for ELECOM M-DT2DRBK

Qasim Ijaz <qasdev00@gmail.com>
    HID: multitouch: fix slab out-of-bounds access in mt_report_fixup()

Qasim Ijaz <qasdev00@gmail.com>
    HID: asus: fix UAF via HID_CLAIMED_INPUT validation

K Prateek Nayak <kprateek.nayak@amd.com>
    x86/cpu/topology: Use initial APIC ID from XTOPOLOGY leaf on AMD/HYGON

Borislav Petkov (AMD) <bp@alien8.de>
    x86/microcode/AMD: Handle the case of no BIOS microcode

Suchit Karunakaran <suchitkarunakaran@gmail.com>
    x86/cpu/intel: Fix the constant_tsc model check for Pentium 4

Radim Krčmář <rkrcmar@ventanamicro.com>
    RISC-V: KVM: fix stack overrun when loading vlenb

Thijs Raymakers <thijs@raymakers.nl>
    KVM: x86: use array_index_nospec with indices that come from guest

Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
    drm/mediatek: mtk_hdmi: Fix inverted parameters in some regmap_update_bits calls

Jens Axboe <axboe@kernel.dk>
    io_uring/kbuf: always use READ_ONCE() to read ring provided buffer lengths

Neil Mandir <neil.mandir@seco.com>
    net: macb: Disable clocks once

Li Nan <linan122@huawei.com>
    efivarfs: Fix slab-out-of-bounds in efivarfs_d_compare

Alexander Duyck <alexanderduyck@fb.com>
    fbnic: Move phylink resume out of service_task and into open/close

Eric Dumazet <edumazet@google.com>
    l2tp: do not use sock_hold() in pppol2tp_session_get_sock()

Eric Dumazet <edumazet@google.com>
    sctp: initialize more fields in sctp_v6_from_sk()

Takamitsu Iwai <takamitz@amazon.co.jp>
    net: rose: include node references in rose_neigh refcount

Takamitsu Iwai <takamitz@amazon.co.jp>
    net: rose: convert 'use' field to refcount_t

Takamitsu Iwai <takamitz@amazon.co.jp>
    net: rose: split remove and free operations in rose_remove_neigh()

Qingyue Zhang <chunzhennn@qq.com>
    io_uring/kbuf: fix signedness in this_len calculation

Dipayaan Roy <dipayanroy@linux.microsoft.com>
    net: hv_netvsc: fix loss of early receive events from host during channel open.

Rohan G Thomas <rohan.g.thomas@altera.com>
    net: stmmac: Set CIC bit only for TX queues with COE

Rohan G Thomas <rohan.g.thomas@altera.com>
    net: stmmac: xgmac: Correct supported speed modes

Rohan G Thomas <rohan.g.thomas@altera.com>
    net: stmmac: xgmac: Do not enable RX FIFO Overflow interrupts

Alexei Lazar <alazar@nvidia.com>
    net/mlx5e: Set local Xoff after FW update

Alexei Lazar <alazar@nvidia.com>
    net/mlx5e: Update and set Xon/Xoff upon port speed set

Alexei Lazar <alazar@nvidia.com>
    net/mlx5e: Update and set Xon/Xoff upon MTU set

Moshe Shemesh <moshe@nvidia.com>
    net/mlx5: Prevent flow steering mode changes in switchdev mode

Moshe Shemesh <moshe@nvidia.com>
    net/mlx5: Nack sync reset when SFs are present

Moshe Shemesh <moshe@nvidia.com>
    net/mlx5: Fix lockdep assertion on sync reset unload event

Moshe Shemesh <moshe@nvidia.com>
    net/mlx5: Reload auxiliary drivers on fw_activate

Lama Kayal <lkayal@nvidia.com>
    net/mlx5: HWS, Fix pattern destruction in mlx5hws_pat_get_pattern error path

Lama Kayal <lkayal@nvidia.com>
    net/mlx5: HWS, Fix uninitialized variables in mlx5hws_pat_calc_nop error flow

Lama Kayal <lkayal@nvidia.com>
    net/mlx5: HWS, Fix memory leak in hws_action_get_shared_stc_nic error flow

Lama Kayal <lkayal@nvidia.com>
    net/mlx5: HWS, Fix memory leak in hws_pool_buddy_init error path

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Fix stats context reservation logic

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Adjust TX rings if reservation is less than requested

Sreekanth Reddy <sreekanth.reddy@broadcom.com>
    bnxt_en: Fix memory corruption when FW resources change during ifdown

Sean Anderson <sean.anderson@linux.dev>
    net: macb: Fix offset error in gem_update_stats

Horatiu Vultur <horatiu.vultur@microchip.com>
    phy: mscc: Fix when PTP clock is register and unregister

Nilay Shroff <nilay@linux.ibm.com>
    block: validate QoS before calling __rq_qos_done_bio()

Matthew Brost <matthew.brost@intel.com>
    drm/xe: Don't trigger rebind on initial dma-buf validation

Thomas Hellström <thomas.hellstrom@linux.intel.com>
    drm/xe/vm: Don't pin the vm_resv during validation

Zbigniew Kempczyński <zbigniew.kempczynski@intel.com>
    drm/xe/xe_sync: avoid race during ufence signaling

Jan Kiszka <jan.kiszka@siemens.com>
    efi: stmm: Fix incorrect buffer allocation method

Yeounsu Moon <yyyynoom@gmail.com>
    net: dlink: fix multicast stats being counted incorrectly

Vladimir Riabchun <ferr.lambarginio@gmail.com>
    mISDN: hfcpci: Fix warning when deleting uninitialized timer

Hariprasad Kelam <hkelam@marvell.com>
    Octeontx2-af: Fix NIX X2P calibration failures

Subbaraya Sundeep <sbhatta@marvell.com>
    octeontx2: Set appropriate PF, VF masks and shifts based on silicon

Chenyuan Yang <chenyuan0y@gmail.com>
    drm/msm/dpu: Add a null ptr check for dpu_encoder_needs_modeset

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    dt-bindings: display/msm: qcom,mdp5: drop lut clock

Jedrzej Jagielski <jedrzej.jagielski@intel.com>
    ixgbe: fix ixgbe_orom_civd_info struct layout

Michal Kubiak <michal.kubiak@intel.com>
    ice: fix incorrect counter for buffer allocation failures

Jacob Keller <jacob.e.keller@intel.com>
    ice: use fixed adapter index for E825C embedded devices

Jacob Keller <jacob.e.keller@intel.com>
    ice: don't leave device non-functional if Tx scheduler config fails

Emil Tantilov <emil.s.tantilov@intel.com>
    ice: fix NULL pointer dereference in ice_unplug_aux_dev() on reset

Timur Tabi <ttabi@nvidia.com>
    drm/nouveau: remove unused memory target test

Timur Tabi <ttabi@nvidia.com>
    drm/nouveau: remove unused increment in gm200_flcn_pio_imem_wr

Kuniyuki Iwashima <kuniyu@google.com>
    atm: atmtcp: Prevent arbitrary write in atmtcp_recv_control().

Hariprasad Kelam <hkelam@marvell.com>
    Octeontx2-vf: Fix max packet length errors

Mina Almasry <almasrymina@google.com>
    page_pool: fix incorrect mp_ops error handling

Pavel Shpakovskiy <pashpakovskii@salutedevices.com>
    Bluetooth: hci_sync: fix set_local_name race condition

Yang Li <yang.li@amlogic.com>
    Bluetooth: hci_event: Disconnect device when BIG sync is lost

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_event: Detect if HCI_EV_NUM_COMP_PKTS is unbalanced

Ludovico de Nittis <ludovico.denittis@collabora.com>
    Bluetooth: hci_event: Mark connection as closed during suspend disconnect

Ludovico de Nittis <ludovico.denittis@collabora.com>
    Bluetooth: hci_event: Treat UNKNOWN_CONN_ID on disconnect as success

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_conn: Make unacked packet handling more robust

luoguangfei <15388634752@163.com>
    net: macb: fix unregister_netdev call order in macb_remove()

Joshua Hay <joshua.a.hay@intel.com>
    idpf: stop Tx if there are insufficient buffer resources

Joshua Hay <joshua.a.hay@intel.com>
    idpf: replace flow scheduling buffer ring with buffer pool

Joshua Hay <joshua.a.hay@intel.com>
    idpf: simplify and fix splitq Tx packet rollback error path

Joshua Hay <joshua.a.hay@intel.com>
    idpf: add support for Tx refillqs in flow scheduling mode

José Expósito <jose.exposito89@gmail.com>
    HID: input: report battery status changes immediately

José Expósito <jose.exposito89@gmail.com>
    HID: input: rename hidinput_set_battery_charge_status()

Madhavan Srinivasan <maddy@linux.ibm.com>
    powerpc/kvm: Fix ifdef to remove build warning

Jason-JH Lin <jason-jh.lin@mediatek.com>
    drm/mediatek: Add error handling for old state CRTC in atomic_disable

Ayushi Makhija <quic_amakhija@quicinc.com>
    drm/msm: update the high bitfield of certain DSI registers

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    drm/msm/dpu: correct dpu_plane_virtual_atomic_check()

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    drm/msm/kms: move snapshot init earlier in KMS init

Even Xu <even.xu@intel.com>
    HID: intel-thc-hid: Intel-quicki2c: Enhance driver re-install flow

Aaron Ma <aaron.ma@canonical.com>
    HID: intel-thc-hid: intel-thc: Fix incorrect pointer arithmetic in I2C regs save

Aaron Ma <aaron.ma@canonical.com>
    HID: intel-thc-hid: intel-quicki2c: Fix ACPI dsd ICRS/ISUB length

Oreoluwa Babatunde <oreoluwa.babatunde@oss.qualcomm.com>
    of: reserved_mem: Restructure call site for dma_contiguous_early_fixup()

Rob Clark <robin.clark@oss.qualcomm.com>
    drm/msm: Defer fd_install in SUBMIT ioctl

Oscar Maes <oscmaes92@gmail.com>
    net: ipv4: fix regression in local-broadcast routes

Nikolay Kuratov <kniv@yandex-team.ru>
    vhost/net: Protect ubufs with rcu read lock in vhost_net_ubuf_put()

Dongcheng Yan <dongcheng.yan@intel.com>
    platform/x86: int3472: add hpd pin support

Fengnan Chang <changfengnan@bytedance.com>
    io_uring/io-wq: add check free worker before create new worker

Junli Liu <liujunli@lixiang.com>
    erofs: fix atomic context detection when !CONFIG_DEBUG_LOCK_ALLOC

Yuezhang Mo <Yuezhang.Mo@sony.com>
    erofs: Fallback to normal access if DAX is not supported on extra device

Shuming Fan <shumingf@realtek.com>
    ASoC: rt1320: fix random cycle mute issue

Shuming Fan <shumingf@realtek.com>
    ASoC: rt721: fix FU33 Boost Volume control not working

Alexey Klimov <alexey.klimov@linaro.org>
    ASoC: codecs: tx-macro: correct tx_macro_component_drv name

Paulo Alcantara <pc@manguebit.org>
    smb: client: fix race with concurrent opens in rename(2)

Paulo Alcantara <pc@manguebit.org>
    smb: client: fix race with concurrent opens in unlink(2)

Damien Le Moal <dlemoal@kernel.org>
    scsi: core: sysfs: Correct sysfs attributes access rights

Namhyung Kim <namhyung@kernel.org>
    vhost: Fix ioctl # for VHOST_[GS]ET_FORK_FROM_OWNER

Igor Torrente <igor.torrente@collabora.com>
    Revert "virtio: reject shm region if length is zero"

Ian Rogers <irogers@google.com>
    perf symbol-minimal: Fix ehdr reading in filename__read_build_id

Tengda Wu <wutengda@huaweicloud.com>
    ftrace: Fix potential warning in trace_printk_seq during ftrace_dump

Steven Rostedt <rostedt@goodmis.org>
    fgraph: Copy args in intermediate storage with entry

Dan Carpenter <dan.carpenter@linaro.org>
    of: dynamic: Fix use after free in of_changeset_add_prop_helper()

Aleksander Jan Bajkowski <olek2@wp.pl>
    mips: lantiq: xway: sysctrl: rename the etop node

Aleksander Jan Bajkowski <olek2@wp.pl>
    mips: dts: lantiq: danube: add missing burst length property

Lorenzo Bianconi <lorenzo@kernel.org>
    pinctrl: airoha: Fix return value in pinconf callbacks

Randy Dunlap <rdunlap@infradead.org>
    pinctrl: STMFX: add missing HAS_IOMEM dependency

Rob Herring (Arm) <robh@kernel.org>
    of: reserved_mem: Add missing IORESOURCE_MEM flag on resources

Lizhi Hou <lizhi.hou@amd.com>
    of: dynamic: Fix memleak when of_pci_add_properties() failed

Ye Weihua <yeweihua4@huawei.com>
    trace/fgraph: Fix the warning caused by missing unregister notifier

Tao Chen <chen.dylane@linux.dev>
    rtla: Check pkg-config install

Tao Chen <chen.dylane@linux.dev>
    tools/latency-collector: Check pkg-config install

Yunseong Kim <ysk@kzalloc.com>
    perf: Avoid undefined behavior from stopping/starting inactive events


-------------

Diffstat:

 .../devicetree/bindings/display/msm/qcom,mdp5.yaml |   1 -
 Makefile                                           |   4 +-
 arch/arm64/include/asm/mmu.h                       |   7 +
 arch/arm64/kernel/cpufeature.c                     |   5 +-
 arch/arm64/mm/mmu.c                                |   7 -
 arch/mips/boot/dts/lantiq/danube_easy50712.dts     |   5 +-
 arch/mips/lantiq/xway/sysctrl.c                    |  10 +-
 arch/powerpc/kernel/kvm.c                          |   8 +-
 arch/riscv/kvm/vcpu_vector.c                       |   2 +
 arch/x86/kernel/cpu/intel.c                        |   2 +-
 arch/x86/kernel/cpu/microcode/amd.c                |  22 +-
 arch/x86/kernel/cpu/topology_amd.c                 |  27 +-
 arch/x86/kvm/lapic.c                               |   2 +
 arch/x86/kvm/x86.c                                 |   7 +-
 block/blk-rq-qos.h                                 |  13 +-
 block/blk-zoned.c                                  |  11 +-
 drivers/atm/atmtcp.c                               |  17 +-
 drivers/crypto/marvell/octeontx2/otx2_cpt_common.h |   5 +-
 drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c |  13 +-
 .../crypto/marvell/octeontx2/otx2_cptpf_ucode.c    |   4 +-
 drivers/crypto/marvell/octeontx2/otx2_cptvf_mbox.c |   6 +-
 drivers/firmware/efi/stmm/tee_stmm_efi.c           |  21 +-
 drivers/firmware/qcom/qcom_scm.c                   |  95 +++--
 drivers/firmware/qcom/qcom_scm.h                   |   1 +
 drivers/firmware/qcom/qcom_tzmem.c                 |  11 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_csa.c            |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c          |   1 +
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c             |  14 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c             |   8 +-
 drivers/gpu/drm/amd/pm/amdgpu_pm.c                 |  18 +-
 drivers/gpu/drm/display/drm_dp_helper.c            |   2 +-
 drivers/gpu/drm/mediatek/mtk_drm_drv.c             |  21 +-
 drivers/gpu/drm/mediatek/mtk_hdmi.c                |   8 +-
 drivers/gpu/drm/mediatek/mtk_plane.c               |   3 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c        |   2 +
 drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c          |   4 +-
 drivers/gpu/drm/msm/msm_gem_submit.c               |  14 +-
 drivers/gpu/drm/msm/msm_kms.c                      |  10 +-
 drivers/gpu/drm/msm/registers/display/dsi.xml      |  28 +-
 drivers/gpu/drm/nouveau/dispnv50/wndw.c            |   4 +
 drivers/gpu/drm/nouveau/nvkm/falcon/gm200.c        |  15 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/gsp/fwsec.c    |   5 +-
 drivers/gpu/drm/xe/xe_bo.c                         |   8 +-
 drivers/gpu/drm/xe/xe_sync.c                       |   2 +-
 drivers/gpu/drm/xe/xe_vm.c                         |   8 +-
 drivers/gpu/drm/xe/xe_vm.h                         |  15 +-
 drivers/hid/hid-asus.c                             |   8 +-
 drivers/hid/hid-elecom.c                           |   2 +
 drivers/hid/hid-ids.h                              |   4 +
 drivers/hid/hid-input-test.c                       |  10 +-
 drivers/hid/hid-input.c                            |  51 ++-
 drivers/hid/hid-logitech-dj.c                      |   4 +
 drivers/hid/hid-logitech-hidpp.c                   |   2 +
 drivers/hid/hid-multitouch.c                       |   8 +
 drivers/hid/hid-ntrig.c                            |   3 +
 drivers/hid/hid-quirks.c                           |   3 +
 .../intel-thc-hid/intel-quicki2c/pci-quicki2c.c    |   1 +
 .../intel-thc-hid/intel-quicki2c/quicki2c-dev.h    |   2 +
 .../hid/intel-thc-hid/intel-thc/intel-thc-dev.c    |   4 +-
 drivers/hid/wacom_wac.c                            |   1 +
 drivers/isdn/hardware/mISDN/hfcpci.c               |  12 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  36 +-
 drivers/net/ethernet/cadence/macb_main.c           |  11 +-
 drivers/net/ethernet/dlink/dl2k.c                  |   2 +-
 drivers/net/ethernet/intel/ice/ice.h               |   1 +
 drivers/net/ethernet/intel/ice/ice_adapter.c       |  49 ++-
 drivers/net/ethernet/intel/ice/ice_adapter.h       |   4 +-
 drivers/net/ethernet/intel/ice/ice_ddp.c           |  44 ++-
 drivers/net/ethernet/intel/ice/ice_idc.c           |  10 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |  16 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c          |   2 +-
 .../net/ethernet/intel/idpf/idpf_singleq_txrx.c    |  61 ++-
 drivers/net/ethernet/intel/idpf/idpf_txrx.c        | 411 ++++++++++++---------
 drivers/net/ethernet/intel/idpf/idpf_txrx.h        |  38 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_e610.c      |   2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_type_e610.h |   2 +-
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    |   7 +
 .../net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c |   6 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |  30 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |  66 +++-
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    |  68 ++--
 .../net/ethernet/marvell/octeontx2/af/rvu_cn10k.c  |   4 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_cpt.c    |   4 +-
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    |  22 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |  54 +--
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    |   8 +-
 .../ethernet/marvell/octeontx2/af/rvu_npc_hash.c   |  16 +-
 .../ethernet/marvell/octeontx2/af/rvu_npc_hash.h   |   4 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_rep.c    |  13 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_sdp.c    |  10 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_switch.c |   8 +-
 .../ethernet/marvell/octeontx2/nic/cn10k_ipsec.c   |   2 +-
 .../ethernet/marvell/octeontx2/nic/cn10k_ipsec.h   |   2 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |   4 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  12 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |  24 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_reg.h  |  30 --
 .../net/ethernet/marvell/octeontx2/nic/otx2_tc.c   |   3 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   |  10 +
 drivers/net/ethernet/marvell/octeontx2/nic/rep.c   |  20 +-
 drivers/net/ethernet/marvell/octeontx2/nic/rep.h   |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |   2 +-
 .../ethernet/mellanox/mlx5/core/en/port_buffer.c   |   3 +-
 .../ethernet/mellanox/mlx5/core/en/port_buffer.h   |  12 +
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  19 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |  15 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c | 132 ++++---
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h |   1 +
 .../net/ethernet/mellanox/mlx5/core/sf/devlink.c   |  10 +
 drivers/net/ethernet/mellanox/mlx5/core/sf/sf.h    |   6 +
 .../mellanox/mlx5/core/steering/hws/action.c       |   2 +-
 .../mellanox/mlx5/core/steering/hws/pat_arg.c      |   6 +-
 .../mellanox/mlx5/core/steering/hws/pool.c         |   1 +
 drivers/net/ethernet/meta/fbnic/fbnic_netdev.c     |   4 +
 drivers/net/ethernet/meta/fbnic/fbnic_pci.c        |   2 -
 .../net/ethernet/stmicro/stmmac/dwxgmac2_core.c    |  13 +-
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c |   9 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   6 +-
 drivers/net/hyperv/netvsc.c                        |  17 +-
 drivers/net/hyperv/rndis_filter.c                  |  23 +-
 drivers/net/phy/mscc/mscc.h                        |   4 +
 drivers/net/phy/mscc/mscc_main.c                   |   4 +-
 drivers/net/phy/mscc/mscc_ptp.c                    |  34 +-
 drivers/net/usb/qmi_wwan.c                         |   3 +
 drivers/of/dynamic.c                               |   9 +-
 drivers/of/of_reserved_mem.c                       |  17 +-
 drivers/pinctrl/Kconfig                            |   1 +
 drivers/pinctrl/mediatek/pinctrl-airoha.c          |   8 +-
 drivers/platform/x86/intel/int3472/discrete.c      |   6 +
 drivers/scsi/scsi_sysfs.c                          |   4 +-
 drivers/thermal/mediatek/lvts_thermal.c            |  74 +++-
 drivers/vhost/net.c                                |   9 +-
 fs/efivarfs/super.c                                |   4 +
 fs/erofs/super.c                                   |  24 +-
 fs/erofs/zdata.c                                   |  13 +-
 fs/smb/client/cifsfs.c                             |  14 +
 fs/smb/client/inode.c                              |  34 +-
 fs/smb/client/smb2inode.c                          |   7 +-
 fs/xfs/libxfs/xfs_attr_remote.c                    |   7 +
 fs/xfs/libxfs/xfs_da_btree.c                       |   6 +
 include/linux/atmdev.h                             |   1 +
 include/linux/dma-map-ops.h                        |   3 +
 include/linux/firmware/qcom/qcom_scm.h             |   5 +-
 include/linux/platform_data/x86/int3472.h          |   1 +
 include/linux/soc/marvell/silicons.h               |  25 ++
 include/linux/virtio_config.h                      |   2 -
 include/net/bluetooth/hci_sync.h                   |   2 +-
 include/net/rose.h                                 |  18 +-
 include/uapi/linux/vhost.h                         |   4 +-
 io_uring/io-wq.c                                   |   8 +
 io_uring/kbuf.c                                    |  20 +-
 kernel/dma/contiguous.c                            |   2 -
 kernel/dma/pool.c                                  |   4 +-
 kernel/events/core.c                               |   6 +
 kernel/trace/fgraph.c                              |   1 +
 kernel/trace/trace.c                               |   4 +-
 kernel/trace/trace_functions_graph.c               |  22 +-
 net/atm/common.c                                   |  15 +-
 net/bluetooth/hci_conn.c                           |  58 ++-
 net/bluetooth/hci_event.c                          |  25 +-
 net/bluetooth/hci_sync.c                           |   6 +-
 net/bluetooth/mgmt.c                               |   9 +-
 net/core/page_pool.c                               |   6 +-
 net/ipv4/route.c                                   |  10 +-
 net/l2tp/l2tp_ppp.c                                |  25 +-
 net/rose/af_rose.c                                 |  13 +-
 net/rose/rose_in.c                                 |  12 +-
 net/rose/rose_route.c                              |  62 ++--
 net/rose/rose_timer.c                              |   2 +-
 net/sctp/ipv6.c                                    |   2 +
 sound/soc/codecs/lpass-tx-macro.c                  |   2 +-
 sound/soc/codecs/rt1320-sdw.c                      |   3 +-
 sound/soc/codecs/rt721-sdca.c                      |   2 +
 sound/soc/codecs/rt721-sdca.h                      |   4 +
 tools/perf/util/symbol-minimal.c                   |  55 ++-
 tools/tracing/latency/Makefile.config              |   8 +
 tools/tracing/rtla/Makefile.config                 |   8 +
 177 files changed, 1765 insertions(+), 987 deletions(-)



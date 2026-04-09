Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEBEF31D367;
	Thu,  9 Apr 2026 09:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775726725; cv=none; b=TCTOvYpWYeNsPuoQuJraiftfWJbndtaUKL9ahzIbA0/KAyYqrgVIl4bAWD7ZnviUHwEC3L4r0u6ihd8cxvaJUY3b/OrGs8DiC1bRNskidExtO+2DaxVKoPYK7Xt+UsZD4lXq95M/YOuDN9xWL+KzRE1c4DzLcnLWzrUg9q8Y0Hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775726725; c=relaxed/simple;
	bh=q1PaaFL3i3iVe1qrEV/T2fozMZjTk2GiJT0FZgvzq78=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Yo4MKPEblXOwyWzPmE55OpqSakW4WX9PvKeStsm3uV76zAXjky6xlw04n9WOLHKdE01gz8DfeZUabEKswC7vP4OjEa8fQQi6OCTWx742C9x+ygBcbGUb3WeIO+p+rCKtK1Dgljh7DAYTTZmAWuHtpKeYNZNCWCut840uimaLiuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J7tsmpCu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J7tsmpCu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71814C4CEF7;
	Thu,  9 Apr 2026 09:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775726725;
	bh=q1PaaFL3i3iVe1qrEV/T2fozMZjTk2GiJT0FZgvzq78=;
	h=From:To:Cc:Subject:Date:From;
	b=J7tsmpCuF93zVeZ9Sx2j+DLtK8b4j3CkqnhYFY0qMWo4YFw5mJfyMRQOJHDxj76/i
	 cSiiGU2zh8imFMWZN6Lr71DFHfR+LRPhUl2Yai+rEXOOlurD20EPQLmqEmesRKr/rB
	 xYUWFk+mrdKlgAhbI0YYIzdNsUhCvGK+cgG64VDw=
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
	pavel@nabladev.com,
	jonathanh@nvidia.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com
Subject: [PATCH 6.12 000/241] 6.12.81-rc2 review
Date: Thu,  9 Apr 2026 11:25:21 +0200
Message-ID: <20260409091733.126574279@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.81-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.12.81-rc2
X-KernelTest-Deadline: 2026-04-11T09:17+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.12.81 release.
There are 241 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 11 Apr 2026 09:16:49 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.81-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.12.81-rc2

Eduard Zingerman <eddyz87@gmail.com>
    selftests/bpf: test refining u32/s32 bounds when ranges cross min/max boundary

Eduard Zingerman <eddyz87@gmail.com>
    bpf: Fix u32/s32 bounds when ranges cross min/max boundary

Paul Chaignon <paul.chaignon@gmail.com>
    bpf: Add third round of bounds deduction

Paul Chaignon <paul.chaignon@gmail.com>
    selftests/bpf: Test invariants on JSLT crossing sign

Paul Chaignon <paul.chaignon@gmail.com>
    selftests/bpf: Test cross-sign 64bits range refinement

Paul Chaignon <paul.chaignon@gmail.com>
    bpf: Improve bounds when s64 crosses sign boundary

Charlene Liu <Charlene.Liu@amd.com>
    drm/amd/display: Correct logic check error for fastboot

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd: Disable ASPM on SI

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Disable scaling on DCE6 for now

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Adjust DCE 8-10 clock, don't overclock by 15%

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Fix DCE 6.0 and 6.4 PLL programming.

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Keep PLL0 running on DCE 6.0 and 6.4

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Reject modes with too high pixel clock on DCE6-10

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Disable fastboot on DCE 6 too

Kenneth Feng <kenneth.feng@amd.com>
    drm/amd/amdgpu: disable ASPM in some situations

Kenneth Feng <kenneth.feng@amd.com>
    drm/amd/amdgpu: decouple ASPM with pcie dpm

Mario Limonciello <mario.limonciello@amd.com>
    x86/CPU/AMD: Add additional fixed RDSEED microcode revisions

Li Xiasong <lixiasong1@huawei.com>
    MPTCP: fix lock class name family in pm_nl_create_listen_socket

Thomas Richter <tmricht@linux.ibm.com>
    s390/cpum_sf: Cap sampling rate to prevent lsctl exception

Heiko Carstens <hca@linux.ibm.com>
    s390/perf_cpum_sf: Convert to use try_cmpxchg128()

Li Chen <me@linux.beauty>
    ext4: publish jinode after initialization

Yang Wang <kevinyang.wang@amd.com>
    drm/amd/pm: disable OD_FAN_CURVE if temp or pwm range invalid for smu v13

David Hildenbrand (Arm) <david@kernel.org>
    mm/memory: fix PMD/PUD checks in follow_pfnmap_start()

Anshuman Khandual <anshuman.khandual@arm.com>
    mm: replace READ_ONCE() with standard page table accessors

Jinjiang Tu <tujinjiang@huawei.com>
    mm/huge_memory: fix folio isn't locked in softleaf_to_folio()

Nikunj A Dadhania <nikunj@amd.com>
    x86/fred: Fix early boot failures on SEV-ES/SNP guests

Josef Bacik <josef@toxicpanda.com>
    scsi: target: tcm_loop: Drain commands in target_reset handler

Guangshuo Li <lgs201920130244@gmail.com>
    net: mana: fix use-after-free in add_adev() error path

Willem de Bruijn <willemb@google.com>
    net: correctly handle tunneled traffic on IPV6_CSUM GSO fallback

Emanuele Ghidoli <emanuele.ghidoli@toradex.com>
    spi: cadence-qspi: Fix exec_mem_op error handling

Alexander Popov <alex.popov@linux.com>
    wifi: virt_wifi: remove SET_NETDEV_DEV to avoid use-after-free

Taegu Ha <hataegu0826@gmail.com>
    usb: gadget: f_uac1_legacy: validate control request size

Michael Zimmermann <sigmaepsilon92@gmail.com>
    usb: gadget: f_hid: move list and spinlock inits from bind to alloc

Kuen-Han Tsai <khtsai@google.com>
    usb: gadget: f_rndis: Fix net_device lifecycle with device_move

Kuen-Han Tsai <khtsai@google.com>
    usb: gadget: f_subset: Fix net_device lifecycle with device_move

Kuen-Han Tsai <khtsai@google.com>
    usb: gadget: f_eem: Fix net_device lifecycle with device_move

Kuen-Han Tsai <khtsai@google.com>
    usb: gadget: f_ecm: Fix net_device lifecycle with device_move

Kuen-Han Tsai <khtsai@google.com>
    usb: gadget: f_rndis: Protect RNDIS options with mutex

Kuen-Han Tsai <khtsai@google.com>
    usb: gadget: f_subset: Fix unbalanced refcnt in geth_free

Jimmy Hu <hhhuuu@google.com>
    usb: gadget: uvc: fix NULL pointer dereference during unbind race

Kuen-Han Tsai <khtsai@google.com>
    usb: gadget: u_ether: Fix NULL pointer deref in eth_get_drvinfo

Kuen-Han Tsai <khtsai@google.com>
    usb: gadget: u_ether: Fix race between gether_disconnect and eth_stop

Filipe Manana <fdmanana@suse.com>
    btrfs: do not free data reservation in fallback from inline due to -ENOSPC

Qu Wenruo <wqu@suse.com>
    btrfs: fix the qgroup data free range for inline data extents

Zilin Guan <zilin@seu.edu.cn>
    ice: Fix memory leak in ice_set_ringparam()

Nathan Rebello <nathan.c.rebello@gmail.com>
    usb: typec: ucsi: validate connector number in ucsi_notify_common()

Sebastian Urban <surban@surban.net>
    usb: gadget: dummy_hcd: fix premature URB completion when ZLP follows partial transfer

Alan Stern <stern@rowland.harvard.edu>
    USB: dummy-hcd: Fix interrupt synchronization error

Alan Stern <stern@rowland.harvard.edu>
    USB: dummy-hcd: Fix locking/synchronization error

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    thunderbolt: Fix property read in nhi_wake_supported()

Xingjing Deng <micro6947@gmail.com>
    misc: fastrpc: possible double-free of cctx->remote_heap

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    thermal: core: Fix thermal zone device registration error path

Shenwei Wang <shenwei.wang@nxp.com>
    gpio: mxc: map Both Edge pad wakeup to Rising Edge

Guangshuo Li <lgs201920130244@gmail.com>
    cpufreq: governor: fix double free in cpufreq_dbs_governor_init() error path

Sven Eckelmann (Plasma Cloud) <se@simonwunderlich.de>
    net: ethernet: mtk_ppe: avoid NULL deref when gmac0 is disabled

Yufan Chen <yufan.chen@linux.dev>
    net: ftgmac100: fix ring allocation unwind on open failure

Yang Yang <n05ec@lzu.edu.cn>
    vxlan: validate ND option lengths in vxlan_na_create

Eric Biggers <ebiggers@kernel.org>
    crypto: tegra - Add missing CRYPTO_ALG_ASYNC

Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>
    counter: rz-mtu3-cnt: do not use struct rz_mtu3_channel's dev member

Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>
    counter: rz-mtu3-cnt: prevent counter from being toggled multiple times

Yifan Wu <yifanwucs@gmail.com>
    netfilter: ipset: drop logically empty buckets in mtype_del

Ivan Vera <ivanverasantos@gmail.com>
    nvmem: zynqmp_nvmem: Fix buffer size in DMA and memcpy

Christian Eggers <ceggers@arri.de>
    nvmem: imx: assign nvmem_cell_info::raw_len

Xu Yang <xu.yang_2@nxp.com>
    dt-bindings: connector: add pd-disable dependency

Conor Dooley <conor.dooley@microchip.com>
    firmware: microchip: fail auto-update probe if no flash found

Ian Abbott <abbotti@mev.co.uk>
    comedi: me4000: Fix potential overrun of firmware buffer

Ian Abbott <abbotti@mev.co.uk>
    comedi: me_daq: Fix potential overrun of firmware buffer

Ian Abbott <abbotti@mev.co.uk>
    comedi: ni_atmio16d: Fix invalid clean-up after failed attach

Ian Abbott <abbotti@mev.co.uk>
    comedi: Reinit dev->spinlock between attachments to low-level drivers

Deepanshu Kartikey <kartikey406@gmail.com>
    comedi: dt2815: add hardware detection to prevent crash

Oliver Neukum <oneukum@suse.com>
    cdc-acm: new quirk for EPSON HMD

Yang Yang <n05ec@lzu.edu.cn>
    bridge: br_nd_send: validate ND option lengths

Sasha Levin <sashal@kernel.org>
    Revert "LoongArch/orc: Use RCU in all users of __module_address()."

Sasha Levin <sashal@kernel.org>
    Revert "LoongArch: Remove unnecessary checks for ORC unwinder"

Sasha Levin <sashal@kernel.org>
    Revert "LoongArch: Handle percpu handler address for ORC unwinder"

Yongchao Wu <yongchao.wu@autochips.com>
    usb: cdns3: gadget: fix state inconsistency on gadget init failure

Yongchao Wu <yongchao.wu@autochips.com>
    usb: cdns3: gadget: fix NULL pointer dereference in ep_queue

Gabor Juhos <j4g8y7@gmail.com>
    usb: core: phy: avoid double use of 'usb3-phy'

Juno Choi <juno.choi@lge.com>
    usb: dwc2: gadget: Fix spin_lock/unlock mismatch in dwc2_hsotg_udc_stop()

Justin Chen <justin.chen@broadcom.com>
    usb: ehci-brcm: fix sleep during atomic

Heitor Alves de Siqueira <halves@igalia.com>
    usb: usbtmc: Flush anchored URBs in usbtmc_release

Guangshuo Li <lgs201920130244@gmail.com>
    usb: ulpi: fix double free in ulpi_register_interface() error path

Miao Li <limiao@kylinos.cn>
    usb: quirks: add DELAY_INIT quirk for another Silicon Motion flash drive

Ethan Tidmore <ethantidmore06@gmail.com>
    iio: gyro: mpu3050: Fix out-of-sequence free_irq()

Ethan Tidmore <ethantidmore06@gmail.com>
    iio: gyro: mpu3050: Move iio_device_register() to correct location

Ethan Tidmore <ethantidmore06@gmail.com>
    iio: gyro: mpu3050: Fix irq resource leak

Ethan Tidmore <ethantidmore06@gmail.com>
    iio: gyro: mpu3050: Fix incorrect free_irq() variable

Francesco Lavra <flavra@baylibre.com>
    iio: imu: st_lsm6dsx: Set FIFO ODR for accelerometer and gyroscope only

Josh Poimboeuf <jpoimboe@kernel.org>
    iio: imu: bmi160: Remove potential undefined behavior in bmi160_config_pin()

David Lechner <dlechner@baylibre.com>
    iio: light: vcnl4035: fix scan buffer on big-endian

Antoniu Miclaus <antoniu.miclaus@analog.com>
    iio: dac: ad5770r: fix error return in ad5770r_read_raw()

Antoniu Miclaus <antoniu.miclaus@analog.com>
    iio: accel: adxl380: fix FIFO watermark bit 8 always written as 0

Valek Andrej <andrej.v@skyrain.eu>
    iio: accel: fix ADXL355 temperature signature value

Billy Tsai <billy_tsai@aspeedtech.com>
    iio: adc: aspeed: clear reference voltage bits before configuring vref

Zoltan Illes <zoliviragh@gmail.com>
    Input: xpad - add support for Razer Wolverine V3 Pro

Shengyu Qu <wiagn233@outlook.com>
    Input: xpad - add support for BETOP BTP-KP50B/C controller's wireless mode

Liam Mitchell <mitchell.liam@gmail.com>
    Input: bcm5974 - recover from failed mode switch

Christoffer Sandberg <cs@tuxedo.de>
    Input: i8042 - add TUXEDO InfinityBook Max 16 Gen10 AMD to i8042 quirk table

Bart Van Assche <bvanassche@acm.org>
    Input: synaptics-rmi4 - fix a locking bug in an error path

JP Hein <jp@jphein.com>
    USB: core: add NO_LPM quirk for Razer Kiyo Pro webcam

Wanquan Zhong <wanquan.zhong@fibocom.com>
    USB: serial: option: add support for Rolling Wireless RW135R-GL

Frej Drejhammar <frej@stacken.kth.se>
    USB: serial: io_edgeport: add support for Blackbox IC135A

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/pm: drop SMU driver if version not matched messages

Donet Tom <donettom@linux.ibm.com>
    drm/amdgpu: Change AMDGPU_VA_RESERVED_TRAP_SIZE to 64KB

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915/dp: Use crtc_state->enhanced_framing properly on ivb/hsw CPU eDP

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915/dsi: Don't do DSC horizontal timing adjustments in command mode

Thomas Zimmermann <tzimmermann@suse.de>
    drm/ast: dp501: Fix initialization of SCU2C

Felix Gu <ustc.gu@gmail.com>
    iio: adc: ti-ads1119: Replace IRQF_ONESHOT with IRQF_NO_THREAD

Felix Gu <ustc.gu@gmail.com>
    iio: adc: ti-ads1119: Reinit completion before wait_for_completion_timeout()

Felix Gu <ustc.gu@gmail.com>
    iio: adc: ti-ads1119: Fix unbalanced pm reference count in ds1119_single_conversion()

David Lechner <dlechner@baylibre.com>
    iio: adc: ti-adc161s626: use DMA-safe memory for spi_read()

David Lechner <dlechner@baylibre.com>
    iio: adc: ti-adc161s626: fix buffer read on big-endian

Prike Liang <Prike.Liang@amd.com>
    drm/amdgpu: fix the idr allocation flags

Stefan Wiehler <stefan.wiehler@nokia.com>
    mips: mm: Allocate tlb_vpn array atomically

Sanman Pradhan <psanman@juniper.net>
    hwmon: (occ) Fix division by zero in occ_show_power_1()

Maciej W. Rozycki <macro@orcam.me.uk>
    MIPS: Fix the GCC version check for `__multi3' workaround

Maciej W. Rozycki <macro@orcam.me.uk>
    MIPS: SiByte: Bring back cache initialisation

Asim Viladi Oglu Manizada <manizada@pm.me>
    ksmbd: fix OOB write in QUERY_INFO for compound requests

hkbinbin <hkbinbinbin@gmail.com>
    Bluetooth: hci_sync: fix stack buffer overflow in hci_le_big_create_sync

Oleh Konko <security@1seal.org>
    Bluetooth: SMP: force responder MITM requirements before building the pairing response

Oleh Konko <security@1seal.org>
    Bluetooth: SMP: derive legacy responder STK authentication from MITM state

Junxi Qian <qjx1298677004@gmail.com>
    io_uring/net: fix slab-out-of-bounds read in io_bundle_nbufs()

Takashi Iwai <tiwai@suse.de>
    ALSA: ctxfi: Fix missing SPDIFI1 index handling

Berk Cem Goksel <berkcgoksel@gmail.com>
    ALSA: caiaq: fix stack out-of-bounds read in init_card

Ernestas Kulik <ernestas.k@iconn-networks.com>
    USB: serial: option: add MeiG Smart SRM825WN

Alexey Velichayshiy <a.velichayshiy@ispras.ru>
    wifi: iwlwifi: mvm: fix potential out-of-bounds read in iwl_mvm_nd_match_info_handler()

Yasuaki Torimaru <yasuakitorimaru@gmail.com>
    wifi: wilc1000: fix u8 overflow in SSID scan buffer size calculation

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    drm/ioc32: stop speculation on the drm_compat_ioctl path

Paul Walmsley <pjw@kernel.org>
    riscv: kgdb: fix several debug register assignment bugs

Peter Zijlstra <peterz@infradead.org>
    sched/fair: Fix zero_vruntime tracking fix

Vincent Guittot <vincent.guittot@linaro.org>
    sched/fair: Use protect_slice() instead of direct comparison

Shiji Yang <yangshiji66@outlook.com>
    mips: ralink: update CPU clock index

Sanman Pradhan <psanman@juniper.net>
    hwmon: (occ) Fix missing newline in occ_show_extended()

Sanman Pradhan <psanman@juniper.net>
    hwmon: (tps53679) Fix device ID comparison and printing in tps53676_identify()

Jamie Gibbons <jamie.gibbons@microchip.com>
    dt-bindings: gpio: fix microchip #interrupt-cells

Sanman Pradhan <psanman@juniper.net>
    hwmon: (ltc4286) Add missing MODULE_IMPORT_NS("PMBUS")

Sanman Pradhan <psanman@juniper.net>
    hwmon: (pxe1610) Check return value of page-select write in probe

Youssef Samir <youssef.abdulrahman@oss.qualcomm.com>
    accel/qaic: Handle DBC deactivation if the owner went away

David Lechner <dlechner@baylibre.com>
    iio: imu: bno055: fix BNO055_SCAN_CH_COUNT off by one

Maarten Lankhorst <dev@lankhorst.se>
    Revert "drm: Fix use-after-free on framebuffers and property blobs when calling drm_dev_unplug"

Qi Tang <tpluszz77@gmail.com>
    bpf: reject direct access to nullable PTR_TO_BUF pointers

Eric Dumazet <edumazet@google.com>
    ipv6: avoid overflows in ip6_datagram_send_ctl()

Luka Gejak <luka.gejak@linux.dev>
    net: hsr: fix VLAN add unwind on slave errors

Xiang Mei <xmei5@asu.edu>
    net/sched: cls_flow: fix NULL pointer dereference on shared blocks

Xiang Mei <xmei5@asu.edu>
    net/sched: cls_fw: fix NULL pointer dereference on shared blocks

Martin Schiller <ms@dev.tdt.de>
    net/x25: Fix overflow when accumulating packets

Martin Schiller <ms@dev.tdt.de>
    net/x25: Fix potential double free of skb

Pavan Chebbi <pavan.chebbi@broadcom.com>
    bnxt_en: Restore default stat ctxs for ULP when resource is available

Saeed Mahameed <saeedm@nvidia.com>
    net/mlx5: Fix switchdev mode rollback in case of failure

Saeed Mahameed <saeedm@nvidia.com>
    net/mlx5: Avoid "No data available" when FW version queries fail

Shay Drory <shayd@nvidia.com>
    net/mlx5: lag: Check for LAG device before creating debugfs

Fedor Pchelkin <pchelkin@ispras.ru>
    net: macb: properly unregister fixed rate clocks

Fedor Pchelkin <pchelkin@ispras.ru>
    net: macb: fix clk handling on PCI glue driver removal

Yucheng Lu <kanolyc@gmail.com>
    net/sched: sch_netem: fix out-of-bounds access in packet corruption

Kuniyuki Iwashima <kuniyu@google.com>
    bpf: sockmap: Fix use-after-free of sk->sk_socket in sk_psock_verdict_data_ready().

Weiming Shi <bestswngs@gmail.com>
    rds: ib: reject FRMR registration before IB connection is established

Keenan Dong <keenanat2000@gmail.com>
    Bluetooth: MGMT: validate mesh send advertising payload length

Pauli Virtanen <pav@iki.fi>
    Bluetooth: hci_event: fix potential UAF in hci_le_remote_conn_param_req_evt

Pauli Virtanen <pav@iki.fi>
    Bluetooth: hci_conn: fix potential UAF in set_cig_params_sync

Keenan Dong <keenanat2000@gmail.com>
    Bluetooth: MGMT: validate LTK enc_size on load

Cen Zhang <zzzccc427@gmail.com>
    Bluetooth: SCO: fix race conditions in sco_sock_connect()

Pauli Virtanen <pav@iki.fi>
    Bluetooth: hci_sync: call destroy in hci_cmd_sync_run if immediate

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: reject immediate NF_QUEUE verdict

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: x_tables: restrict xt_check_match/xt_check_target extensions for NFPROTO_ARP

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: ctnetlink: ignore explicit helper on new expectations

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_conntrack_expect: store netns and zone in expectation

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_conntrack_expect: use expect->helper

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_conntrack_expect: honor expectation helper field

Qi Tang <tpluszz77@gmail.com>
    netfilter: ctnetlink: zero expect NAT fields when CTA_EXPECT_NAT absent

Qi Tang <tpluszz77@gmail.com>
    netfilter: nf_conntrack_helper: pass helper to expect cleanup

Florian Westphal <fw@strlen.de>
    netfilter: ipset: use nla_strcmp for IPSET_ATTR_NAME attr

Florian Westphal <fw@strlen.de>
    netfilter: x_tables: ensure names are nul-terminated

Florian Westphal <fw@strlen.de>
    netfilter: nfnetlink_log: account for netlink header size

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: flowtable: strictly check for maximum number of actions

Zhengchuan Liang <zcliangcn@gmail.com>
    net: ipv6: flowlabel: defer exclusive option free until RCU teardown

Alexei Starovoitov <ast@kernel.org>
    bpf: Fix regsafe() for pointers to packet

Julian Braha <julianbraha@gmail.com>
    ASoC: Intel: boards: fix unmet dependency on PINCTRL

Suraj Gupta <suraj.gupta2@amd.com>
    net: xilinx: axienet: Correct BD length masks to match AXIDMA IP spec

Pengpeng Hou <pengpeng@iscas.ac.cn>
    NFC: pn533: bound the UART receive buffer

Yochai Eisenrich <echelonh@gmail.com>
    net: sched: cls_api: fix tc_chain_fill_node to initialize tcm_info to zero to prevent an info-leak

Guoyu Su <yss2813483011xxl@gmail.com>
    net: use skb_header_pointer() for TCPv4 GSO frag_off check

Paolo Abeni <pabeni@redhat.com>
    net: introduce mangleid_features

Lorenzo Bianconi <lorenzo@kernel.org>
    net: airoha: Add missing cleanup bits in airoha_qdma_cleanup_rx_queue()

Paolo Abeni <pabeni@redhat.com>
    ipv6: prevent possible UaF in addrconf_permanent_addr()

Jihed Chaibi <jihed.chaibi.dev@gmail.com>
    ASoC: ep93xx: Fix unchecked clk_prepare_enable() and add rollback on failure

Wei Fang <wei.fang@nxp.com>
    net: enetc: check whether the RSS algorithm is Toeplitz

Marek Behún <kabel@kernel.org>
    net: sfp: Fix Ubiquiti U-Fiber Instant SFP module on mvneta

Xiang Mei <xmei5@asu.edu>
    net/sched: sch_hfsc: fix divide-by-zero in rtsc_min()

Yang Yang <n05ec@lzu.edu.cn>
    bridge: br_nd_send: linearize skb before parsing ND options

Dimitri Daskalakis <daskald@meta.com>
    eth: fbnic: Account for page fragments when updating BDQ tail

Eric Dumazet <edumazet@google.com>
    ip6_tunnel: clear skb2->cb[] in ip4ip6_err()

Eric Dumazet <edumazet@google.com>
    ipv6: icmp: clear skb2->cb[] in ip6_err_gen_icmpv6_unreach()

Thomas Bogendoerfer <tbogendoerfer@suse.de>
    tg3: Fix race for querying speed/duplex

Pengpeng Hou <pengpeng@iscas.ac.cn>
    net/ipv6: ioam6: prevent schema length wraparound in trace fill

Yochai Eisenrich <echelonh@gmail.com>
    net: ipv6: ndisc: fix ndisc_ra_useropt to initialize nduseropt_padX fields to zero to prevent an info-leak

Jiayuan Chen <jiayuan.chen@shopee.com>
    net: qrtr: replace qrtr_tx_flow radix_tree with xarray to fix memory leak

Buday Csaba <buday.csaba@prolan.hu>
    net: fec: fix the PTP periodic output sysfs interface

Norbert Szetei <norbert@doyensec.com>
    crypto: af-alg - fix NULL pointer dereference in scatterwalk

Horia Geantă <horia.geanta@nxp.com>
    crypto: caam - fix overflow on long hmac keys

Horia Geantă <horia.geanta@nxp.com>
    crypto: caam - fix DMA corruption on long hmac keys

Reshma Immaculate Rajkumar <reshma.rajkumar@oss.qualcomm.com>
    wifi: ath11k: Pass the correct value of each TID during a stop AMPDU session

Frank Li <Frank.Li@nxp.com>
    dt-bindings: auxdisplay: ht16k33: Use unevaluatedProperties to fix common property warning

Praveen Talari <praveen.talari@oss.qualcomm.com>
    spi: geni-qcom: Check DMA interrupts early in ISR

ZhengYuan Huang <gality369@gmail.com>
    btrfs: reject root items with drop_progress and zero drop_level

Mikko Perttunen <mperttunen@nvidia.com>
    i2c: tegra: Don't mark devices with pins as IRQ safe

Filipe Manana <fdmanana@suse.com>
    btrfs: reserve enough transaction items for qgroup ioctls

Lee Jones <lee@kernel.org>
    HID: multitouch: Check to ensure report responses match the request

Lee Jones <lee@kernel.org>
    HID: logitech-hidpp: Prevent use-after-free on force feedback initialisation failure

Josh Poimboeuf <jpoimboe@kernel.org>
    objtool: Fix Clang jump table detection

Paul SAGE <paul.sage@42.fr>
    tg3: replace placeholder MAC address with device property

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    btrfs: don't take device_list_mutex when querying zone info

Deepanshu Kartikey <kartikey406@gmail.com>
    atm: lec: fix use-after-free in sock_def_readable()

Benoît Sevens <bsevens@google.com>
    HID: wacom: fix out-of-bounds read in wacom_intuos_bt_irq

Deepanshu Kartikey <kartikey406@gmail.com>
    wifi: mac80211: check tdls flag in ieee80211_tdls_oper

Adrian Freund <adrian@freund.io>
    HID: logitech-hidpp: Enable MX Master 4 over bluetooth

Pepper Gray <hello@peppergray.xyz>
    arm64/scs: Fix handling of advance_loc4

Jens Axboe <axboe@kernel.dk>
    io_uring/kbuf: propagate BUF_MORE through early buffer commit path

Jens Axboe <axboe@kernel.dk>
    io_uring/kbuf: fix missing BUF_MORE for incremental buffers at EOF

Joanne Koong <joannelkoong@gmail.com>
    io_uring/kbuf: use WRITE_ONCE() for userspace-shared buffer ring fields

Caleb Sander Mateos <csander@purestorage.com>
    io_uring/kbuf: use READ_ONCE() for userspace-mapped memory

Jens Axboe <axboe@kernel.dk>
    io_uring/kbuf: always use READ_ONCE() to read ring provided buffer lengths

Jens Axboe <axboe@kernel.dk>
    io_uring/kbuf: enable bundles for incrementally consumed buffers

Jens Axboe <axboe@kernel.dk>
    io_uring/rw: check for NULL io_br_sel when putting a buffer

Jens Axboe <axboe@kernel.dk>
    io_uring/net: correct type for min_not_zero() cast

Jens Axboe <axboe@kernel.dk>
    io_uring: remove async/poll related provided buffer recycles

Jens Axboe <axboe@kernel.dk>
    io_uring/kbuf: switch to storing struct io_buffer_list locally

Jens Axboe <axboe@kernel.dk>
    io_uring/net: use struct io_br_sel->val as the send finish value

Jens Axboe <axboe@kernel.dk>
    io_uring/net: use struct io_br_sel->val as the recv finish value

Jens Axboe <axboe@kernel.dk>
    io_uring/kbuf: use struct io_br_sel for multiple buffers picking

Jens Axboe <axboe@kernel.dk>
    io_uring/kbuf: introduce struct io_br_sel

Jens Axboe <axboe@kernel.dk>
    io_uring/kbuf: pass in struct io_buffer_list to commit/recycle helpers

Jens Axboe <axboe@kernel.dk>
    io_uring/net: clarify io_recv_buf_select() return value

Jens Axboe <axboe@kernel.dk>
    io_uring/net: don't use io_net_kbuf_recyle() for non-provided cases

Jens Axboe <axboe@kernel.dk>
    io_uring/kbuf: drop 'issue_flags' from io_put_kbuf(s)() arguments

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/kbuf: uninline __io_put_kbufs

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/kbuf: introduce io_kbuf_drop_legacy()

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/kbuf: open code __io_put_kbuf()

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/kbuf: remove legacy kbuf caching

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/kbuf: simplify __io_put_kbuf

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/kbuf: remove legacy kbuf kmem cache

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/kbuf: remove legacy kbuf bulk allocation


-------------

Diffstat:

 .../bindings/auxdisplay/holtek,ht16k33.yaml        |   2 +-
 .../bindings/connector/usb-connector.yaml          |   1 +
 .../bindings/gpio/microchip,mpfs-gpio.yaml         |   4 +-
 Makefile                                           |   4 +-
 arch/arm64/kernel/pi/patch-scs.c                   |   8 +
 arch/loongarch/include/asm/setup.h                 |   3 -
 arch/loongarch/kernel/unwind_orc.c                 |  32 +--
 arch/mips/lib/multi3.c                             |   6 +-
 arch/mips/mm/cache.c                               |   3 +-
 arch/mips/mm/tlb-r4k.c                             |   2 +-
 arch/mips/ralink/clk.c                             |   8 +-
 arch/riscv/kernel/kgdb.c                           |   7 +-
 arch/s390/kernel/perf_cpum_sf.c                    |  30 +--
 arch/x86/coco/sev/core.c                           |   6 +
 arch/x86/entry/entry_fred.c                        |  14 +
 arch/x86/kernel/cpu/amd.c                          |   7 +
 crypto/af_alg.c                                    |   4 +-
 drivers/accel/qaic/qaic_control.c                  |  47 +++-
 drivers/comedi/drivers.c                           |   8 +
 drivers/comedi/drivers/dt2815.c                    |  12 +
 drivers/comedi/drivers/me4000.c                    |  16 +-
 drivers/comedi/drivers/me_daq.c                    |  35 +--
 drivers/comedi/drivers/ni_atmio16d.c               |   3 +-
 drivers/counter/rz-mtu3-cnt.c                      |  67 ++---
 drivers/cpufreq/cpufreq_governor.c                 |   6 +-
 drivers/crypto/caam/caamalg_qi2.c                  |   3 +-
 drivers/crypto/caam/caamhash.c                     |   3 +-
 drivers/crypto/tegra/tegra-se-aes.c                |  11 +-
 drivers/crypto/tegra/tegra-se-hash.c               |  30 ++-
 drivers/firmware/microchip/mpfs-auto-update.c      |  10 +-
 drivers/gpio/gpio-mxc.c                            |  10 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |  39 ++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c            |   5 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h             |   2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h              |   4 +-
 .../amd/display/dc/clk_mgr/dce100/dce_clk_mgr.c    |  20 +-
 .../amd/display/dc/clk_mgr/dce60/dce60_clk_mgr.c   |   5 +
 .../gpu/drm/amd/display/dc/dce60/dce60_resource.c  |  59 +++--
 .../drm/amd/display/dc/hwss/dce110/dce110_hwseq.c  |   6 +-
 .../display/dc/resource/dce100/dce100_resource.c   |  10 +-
 .../amd/display/dc/resource/dce80/dce80_resource.c |  10 +-
 drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c     |   1 -
 drivers/gpu/drm/amd/pm/swsmu/smu12/smu_v12_0.c     |   1 -
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c   |  33 ++-
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c   |  33 ++-
 drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0.c     |   1 -
 drivers/gpu/drm/ast/ast_dp501.c                    |   2 +-
 drivers/gpu/drm/drm_file.c                         |   5 +-
 drivers/gpu/drm/drm_ioc32.c                        |   2 +
 drivers/gpu/drm/drm_mode_config.c                  |   9 +-
 drivers/gpu/drm/i915/display/g4x_dp.c              |   2 +-
 drivers/gpu/drm/i915/display/icl_dsi.c             |   4 +-
 drivers/hid/hid-logitech-hidpp.c                   |   6 +-
 drivers/hid/hid-multitouch.c                       |   7 +
 drivers/hid/wacom_wac.c                            |  10 +
 drivers/hwmon/occ/common.c                         |  19 +-
 drivers/hwmon/pmbus/ltc4286.c                      |   1 +
 drivers/hwmon/pmbus/pxe1610.c                      |   5 +-
 drivers/hwmon/pmbus/tps53679.c                     |   4 +-
 drivers/i2c/busses/Kconfig                         |   2 +
 drivers/i2c/busses/i2c-tegra.c                     |   5 +-
 drivers/iio/accel/adxl355_core.c                   |   2 +-
 drivers/iio/accel/adxl380.c                        |   2 +-
 drivers/iio/adc/aspeed_adc.c                       |   1 +
 drivers/iio/adc/ti-adc161s626.c                    |  41 ++-
 drivers/iio/adc/ti-ads1119.c                       |  11 +-
 drivers/iio/dac/ad5770r.c                          |   2 +-
 drivers/iio/gyro/mpu3050-core.c                    |  32 ++-
 drivers/iio/imu/bmi160/bmi160_core.c               |  15 +-
 drivers/iio/imu/bno055/bno055.c                    |   2 +-
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c     |   4 +
 drivers/iio/light/vcnl4035.c                       |  18 +-
 drivers/input/joystick/xpad.c                      |   5 +
 drivers/input/mouse/bcm5974.c                      |  42 ++-
 drivers/input/rmi4/rmi_f54.c                       |   4 +-
 drivers/input/serio/i8042-acpipnpio.h              |   7 +
 drivers/misc/fastrpc.c                             |   1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   2 +
 drivers/net/ethernet/broadcom/tg3.c                |  13 +-
 drivers/net/ethernet/cadence/macb_pci.c            |  10 +-
 drivers/net/ethernet/faraday/ftgmac100.c           |  28 +-
 .../net/ethernet/freescale/enetc/enetc_ethtool.c   |   4 +
 drivers/net/ethernet/freescale/fec_ptp.c           |   3 -
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |  11 +-
 drivers/net/ethernet/mediatek/airoha_eth.c         |  18 +-
 drivers/net/ethernet/mediatek/mtk_ppe_offload.c    |  21 +-
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |   4 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/fw.c       |  49 ++--
 .../net/ethernet/mellanox/mlx5/core/lag/debugfs.c  |   3 +
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |   4 +-
 drivers/net/ethernet/meta/fbnic/fbnic_txrx.c       |   6 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c      |   6 +-
 drivers/net/ethernet/xilinx/xilinx_axienet.h       |   4 +-
 drivers/net/phy/sfp.c                              |   7 +-
 drivers/net/vxlan/vxlan_core.c                     |   6 +-
 drivers/net/wireless/ath/ath11k/dp_rx.c            |  15 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |   2 +-
 drivers/net/wireless/microchip/wilc1000/hif.c      |   2 +-
 drivers/net/wireless/virtual/virt_wifi.c           |   1 -
 drivers/nfc/pn533/uart.c                           |   3 +
 drivers/nvmem/imx-ocotp-ele.c                      |   1 +
 drivers/nvmem/imx-ocotp.c                          |   1 +
 drivers/nvmem/zynqmp_nvmem.c                       |   8 +-
 drivers/spi/spi-cadence-quadspi.c                  |  13 +-
 drivers/spi/spi-geni-qcom.c                        |   9 +-
 drivers/target/loopback/tcm_loop.c                 |  52 +++-
 drivers/thermal/thermal_core.c                     |   1 +
 drivers/thunderbolt/nhi.c                          |   2 +-
 drivers/usb/cdns3/cdns3-gadget.c                   |   4 +
 drivers/usb/class/cdc-acm.c                        |   9 +
 drivers/usb/class/cdc-acm.h                        |   1 +
 drivers/usb/class/usbtmc.c                         |   3 +
 drivers/usb/common/ulpi.c                          |   5 +-
 drivers/usb/core/phy.c                             |  12 +-
 drivers/usb/core/quirks.c                          |   3 +
 drivers/usb/dwc2/gadget.c                          |   2 +
 drivers/usb/gadget/function/f_ecm.c                |  35 ++-
 drivers/usb/gadget/function/f_eem.c                |  59 +++--
 drivers/usb/gadget/function/f_hid.c                |  19 +-
 drivers/usb/gadget/function/f_rndis.c              |  49 ++--
 drivers/usb/gadget/function/f_subset.c             |  63 +++--
 drivers/usb/gadget/function/f_uac1_legacy.c        |  47 +++-
 drivers/usb/gadget/function/f_uvc.c                |  39 ++-
 drivers/usb/gadget/function/u_ecm.h                |  21 +-
 drivers/usb/gadget/function/u_eem.h                |  21 +-
 drivers/usb/gadget/function/u_ether.c              |  16 +-
 drivers/usb/gadget/function/u_gether.h             |  22 +-
 drivers/usb/gadget/function/u_rndis.h              |  31 ++-
 drivers/usb/gadget/function/uvc.h                  |   3 +
 drivers/usb/gadget/function/uvc_v4l2.c             |   5 +-
 drivers/usb/gadget/udc/dummy_hcd.c                 |  42 +--
 drivers/usb/host/ehci-brcm.c                       |   4 +-
 drivers/usb/serial/io_edgeport.c                   |   3 +
 drivers/usb/serial/io_usbvend.h                    |   1 +
 drivers/usb/serial/option.c                        |   4 +
 drivers/usb/typec/ucsi/ucsi.c                      |   9 +-
 fs/btrfs/inode.c                                   |   6 +-
 fs/btrfs/ioctl.c                                   |  12 +-
 fs/btrfs/tree-checker.c                            |  17 ++
 fs/btrfs/zoned.c                                   |   6 +-
 fs/ext4/fast_commit.c                              |   4 +-
 fs/ext4/inode.c                                    |  15 +-
 fs/smb/server/smb2pdu.c                            | 121 ++++++---
 fs/smb/server/smbacl.c                             |  43 +++
 fs/smb/server/smbacl.h                             |   2 +
 include/linux/io_uring_types.h                     |   9 -
 include/linux/netdevice.h                          |   3 +
 include/linux/netfilter/ipset/ip_set.h             |   2 +-
 include/linux/swapops.h                            |  27 +-
 include/net/netfilter/nf_conntrack_expect.h        |  20 +-
 io_uring/io_uring.c                                |  15 +-
 io_uring/io_uring.h                                |   1 -
 io_uring/kbuf.c                                    | 289 ++++++++++-----------
 io_uring/kbuf.h                                    | 148 +++--------
 io_uring/net.c                                     | 149 ++++++-----
 io_uring/poll.c                                    |   4 -
 io_uring/rw.c                                      |  58 +++--
 kernel/bpf/verifier.c                              |  87 ++++++-
 kernel/sched/fair.c                                |  12 +-
 mm/gup.c                                           |  10 +-
 mm/hmm.c                                           |   2 +-
 mm/memory.c                                        |  22 +-
 mm/mprotect.c                                      |   2 +-
 mm/sparse-vmemmap.c                                |   2 +-
 mm/vmscan.c                                        |   2 +-
 net/atm/lec.c                                      |  72 +++--
 net/atm/lec.h                                      |   2 +-
 net/bluetooth/hci_conn.c                           |   8 +-
 net/bluetooth/hci_event.c                          |  33 ++-
 net/bluetooth/hci_sync.c                           |  14 +-
 net/bluetooth/mgmt.c                               |  17 +-
 net/bluetooth/sco.c                                |  30 ++-
 net/bluetooth/smp.c                                |  11 +-
 net/bridge/br_arp_nd_proxy.c                       |  18 +-
 net/core/dev.c                                     |  38 ++-
 net/core/skmsg.c                                   |  13 +-
 net/hsr/hsr_device.c                               |  32 +--
 net/ipv6/addrconf.c                                |   6 +-
 net/ipv6/datagram.c                                |  10 +
 net/ipv6/icmp.c                                    |   3 +
 net/ipv6/ioam6.c                                   |   4 +-
 net/ipv6/ip6_flowlabel.c                           |   5 -
 net/ipv6/ip6_tunnel.c                              |   5 +
 net/ipv6/ndisc.c                                   |   3 +
 net/mac80211/tdls.c                                |   2 +-
 net/mptcp/pm_netlink.c                             |   2 +-
 net/netfilter/ipset/ip_set_core.c                  |   4 +-
 net/netfilter/ipset/ip_set_hash_gen.h              |   2 +-
 net/netfilter/ipset/ip_set_list_set.c              |   4 +-
 net/netfilter/nf_conntrack_broadcast.c             |   8 +-
 net/netfilter/nf_conntrack_expect.c                |  25 +-
 net/netfilter/nf_conntrack_h323_main.c             |  12 +-
 net/netfilter/nf_conntrack_helper.c                |  13 +-
 net/netfilter/nf_conntrack_netlink.c               |  87 +++----
 net/netfilter/nf_conntrack_sip.c                   |   4 +-
 net/netfilter/nf_flow_table_offload.c              | 196 +++++++++-----
 net/netfilter/nf_tables_api.c                      |   7 +-
 net/netfilter/nfnetlink_log.c                      |   2 +-
 net/netfilter/x_tables.c                           |  23 ++
 net/netfilter/xt_cgroup.c                          |   6 +
 net/netfilter/xt_rateest.c                         |   5 +
 net/qrtr/af_qrtr.c                                 |  31 +--
 net/rds/ib_rdma.c                                  |   7 +-
 net/sched/cls_api.c                                |   1 +
 net/sched/cls_flow.c                               |  10 +-
 net/sched/cls_fw.c                                 |  14 +-
 net/sched/sch_hfsc.c                               |   4 +-
 net/sched/sch_netem.c                              |   5 +-
 net/x25/x25_in.c                                   |   9 +-
 net/x25/x25_subr.c                                 |   1 +
 sound/pci/ctxfi/ctdaio.c                           |   1 +
 sound/soc/cirrus/ep93xx-i2s.c                      |  34 ++-
 sound/soc/intel/boards/Kconfig                     |   2 -
 sound/usb/caiaq/device.c                           |   2 +-
 tools/objtool/check.c                              |   5 +-
 .../testing/selftests/bpf/prog_tests/reg_bounds.c  |  62 ++++-
 .../testing/selftests/bpf/progs/verifier_bounds.c  | 159 +++++++++++-
 218 files changed, 2626 insertions(+), 1283 deletions(-)



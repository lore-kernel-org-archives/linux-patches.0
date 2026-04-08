Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 393E02727F3;
	Wed,  8 Apr 2026 18:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674286; cv=none; b=FhnOHAptF9/3y0YDWmmkkvRh6HqVo5pxgK8MUbskDw5NkHptwLGML8S/9sTxGP8XYLfeAtCHjtwssK6VeFcB3pOU7GAtKRG2qZWMelKcOzNl9r87fxQsKSlZPuA9zeiPzTL2EnbzIpxmX6DedoKmwz97k58lCQTmRdHY8yFqQBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674286; c=relaxed/simple;
	bh=EOVTnq3zQNCzuT2x4tKC3GfzDlW7H8A9ZGl2Vlip7rQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=kYZN2ZV30NKG5YtYejb9GJafmliG3J20+VtoMyc0yRNPu2NpzP1RhwwB/bMZ/LibsRr3yi5NLh2moHFXtwlW/Bbv9o3RTt21g5i2gWuLoXNUDX6mF2qL5eEsLXYC957qTRLAZh6DinMYvF4SE9+kEtexSQwS837eOQQStIeOzg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jw99iz6S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jw99iz6S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7304CC19421;
	Wed,  8 Apr 2026 18:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674286;
	bh=EOVTnq3zQNCzuT2x4tKC3GfzDlW7H8A9ZGl2Vlip7rQ=;
	h=From:To:Cc:Subject:Date:From;
	b=Jw99iz6SaP1oYvxYd1R2fARuaiMP+l1mr01IjCtw7W5Jbjnr9ODTEXFfnSx7F5X2U
	 19MYAkaidFKmqdENZgYYcqi4TI0FUoqqsAZJTTwr+YTYzAIbqVsaavvFrEhbJUNxzZ
	 D3nWgrbAdSJlRaKrxx+9I2s0LPk/cZgIF3c2OJWg=
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
Subject: [PATCH 6.19 000/311] 6.19.12-rc1 review
Date: Wed,  8 Apr 2026 20:00:00 +0200
Message-ID: <20260408175939.393281918@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.19.12-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.19.12-rc1
X-KernelTest-Deadline: 2026-04-10T17:59+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.19.12 release.
There are 311 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 10 Apr 2026 17:58:42 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.19.12-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.19.12-rc1

Alexander Popov <alex.popov@linux.com>
    wifi: virt_wifi: remove SET_NETDEV_DEV to avoid use-after-free

Petr Mladek <pmladek@suse.com>
    kallsyms: prevent module removal when printing module name and buildid

Petr Mladek <pmladek@suse.com>
    kallsyms: cleanup code for appending the module buildid

Petr Mladek <pmladek@suse.com>
    kallsyms: clean up modname and modbuildid initialization in kallsyms_lookup_buildid()

Petr Mladek <pmladek@suse.com>
    kallsyms: clean up @namebuf initialization in kallsyms_lookup_buildid()

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

Aditya Garg <gargaditya08@live.com>
    HID: appletb-kbd: add .resume method in PM

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

Andrei Kuchynski <akuchynski@chromium.org>
    usb: typec: thunderbolt: Set enter_vdo during initialization

Xingjing Deng <micro6947@gmail.com>
    misc: fastrpc: check qcom_scm_assign_mem() return in rpmsg_probe

Xingjing Deng <micro6947@gmail.com>
    misc: fastrpc: possible double-free of cctx->remote_heap

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    thermal: core: Fix thermal zone device registration error path

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    thermal: core: Address thermal zone removal races with resume

Tzung-Bi Shih <tzungbi@kernel.org>
    gpio: Fix resource leaks on errors in gpiochip_add_data_with_key()

Shenwei Wang <shenwei.wang@nxp.com>
    gpio: mxc: map Both Edge pad wakeup to Rising Edge

Andrea Righi <arighi@nvidia.com>
    sched_ext: Fix stale direct dispatch state in ddsp_dsq_id

Changwoo Min <changwoo@igalia.com>
    sched_ext: Fix is_bpf_migration_disabled() false negative on non-PREEMPT_RCU

Guangshuo Li <lgs201920130244@gmail.com>
    cpufreq: governor: fix double free in cpufreq_dbs_governor_init() error path

Srujana Challa <schalla@marvell.com>
    virtio_net: clamp rss_max_key_size to NETDEV_RSS_KEY_LEN

Jason Gunthorpe <jgg@ziepe.ca>
    iommupt: Fix short gather if the unmap goes into a large mapping

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

Nicolas Pitre <nico@fluxnic.net>
    vt: resize saved unicode buffer on alt screen exit after resize

Liav Mordouch <liavmordouch@gmail.com>
    vt: discard stale unicode buffer on alt screen exit after resize

Dave Penkler <dpenkler@gmail.com>
    gpib: Fix fluke driver s390 compile issue

Yifan Wu <yifanwucs@gmail.com>
    netfilter: ipset: drop logically empty buckets in mtype_del

Ivan Vera <ivanverasantos@gmail.com>
    nvmem: zynqmp_nvmem: Fix buffer size in DMA and memcpy

Christian Eggers <ceggers@arri.de>
    nvmem: imx: assign nvmem_cell_info::raw_len

Changwoo Min <changwoo@igalia.com>
    PM: EM: Fix NULL pointer dereference when perf domain ID is not found

Guangshuo Li <lgs201920130244@gmail.com>
    reset: gpio: fix double free in reset_add_gpio_aux_device() error path

Thomas Richter <tmricht@linux.ibm.com>
    s390/cpum_sf: Cap sampling rate to prevent lsctl exception

Harald Freudenberger <freude@linux.ibm.com>
    s390/zcrypt: Fix memory leak with CCA cards used as accelerator

Emanuele Ghidoli <emanuele.ghidoli@toradex.com>
    spi: cadence-qspi: Fix exec_mem_op error handling

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

Edward Adam Davis <eadavis@qq.com>
    comedi: runflags cannot determine whether to reclaim chanlist

Deepanshu Kartikey <kartikey406@gmail.com>
    comedi: dt2815: add hardware detection to prevent crash

Oliver Neukum <oneukum@suse.com>
    cdc-acm: new quirk for EPSON HMD

Yang Yang <n05ec@lzu.edu.cn>
    bridge: br_nd_send: validate ND option lengths

Guangshuo Li <lgs201920130244@gmail.com>
    auxdisplay: line-display: fix NULL dereference in linedisp_release

Jens Axboe <axboe@kernel.dk>
    io_uring: protect remaining lockless ctx->rings accesses with RCU

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    x86/platform/geode: Fix on-stack property data use-after-return bug

Guan-Yu Lin <guanyulin@google.com>
    usb: core: use dedicated spinlock for offload state

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

Guan-Yu Lin <guanyulin@google.com>
    usb: host: xhci-sideband: delegate offload_usage tracking to class drivers

Felix Gu <ustc.gu@gmail.com>
    usb: misc: usbio: Fix URB memory leak on submit failure

Heitor Alves de Siqueira <halves@igalia.com>
    usb: usbtmc: Flush anchored URBs in usbtmc_release

Guangshuo Li <lgs201920130244@gmail.com>
    usb: ulpi: fix double free in ulpi_register_interface() error path

Miao Li <limiao@kylinos.cn>
    usb: quirks: add DELAY_INIT quirk for another Silicon Motion flash drive

Johan Hovold <johan@kernel.org>
    gpib: lpvo_usb: fix memory leak on disconnect

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: me: reduce the scope on unexpected reset

Ethan Tidmore <ethantidmore06@gmail.com>
    iio: gyro: mpu3050: Fix out-of-sequence free_irq()

Ethan Tidmore <ethantidmore06@gmail.com>
    iio: gyro: mpu3050: Move iio_device_register() to correct location

Ethan Tidmore <ethantidmore06@gmail.com>
    iio: gyro: mpu3050: Fix irq resource leak

Ethan Tidmore <ethantidmore06@gmail.com>
    iio: gyro: mpu3050: Fix incorrect free_irq() variable

Francesco Lavra <flavra@baylibre.com>
    iio: imu: st_lsm6dsx: Set buffer sampling frequency for accelerometer only

Francesco Lavra <flavra@baylibre.com>
    iio: imu: st_lsm6dsx: Set FIFO ODR for accelerometer and gyroscope only

Josh Poimboeuf <jpoimboe@kernel.org>
    iio: imu: bmi160: Remove potential undefined behavior in bmi160_config_pin()

Aldo Conte <aldocontelk@gmail.com>
    iio: light: veml6070: fix veml6070_read() return value

David Lechner <dlechner@baylibre.com>
    iio: light: vcnl4035: fix scan buffer on big-endian

Antoniu Miclaus <antoniu.miclaus@analog.com>
    iio: imu: adis16550: fix swapped gyro/accel filter functions

Antoniu Miclaus <antoniu.miclaus@analog.com>
    iio: dac: ad5770r: fix error return in ad5770r_read_raw()

Antoniu Miclaus <antoniu.miclaus@analog.com>
    iio: accel: adxl313: add missing error check in predisable

Antoniu Miclaus <antoniu.miclaus@analog.com>
    iio: accel: adxl380: fix FIFO watermark bit 8 always written as 0

Valek Andrej <andrej.v@skyrain.eu>
    iio: accel: fix ADXL355 temperature signature value

Billy Tsai <billy_tsai@aspeedtech.com>
    iio: adc: aspeed: clear reference voltage bits before configuring vref

Antoniu Miclaus <antoniu.miclaus@analog.com>
    iio: adc: ade9000: move mutex init before IRQ registration

Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>
    iio: adc: ade9000: fix wrong register in CALIBBIAS case for active power

Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>
    iio: adc: ade9000: fix wrong return type in streaming push

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    iio: adc: ti-ads7950: do not clobber gpio state in ti_ads7950_get()

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    iio: adc: ti-ads7950: normalize return value of gpio_get

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

Junrui Luo <moonafterrain@outlook.com>
    drm/amdgpu: validate doorbell_offset in user queue creation

Lijo Lazar <lijo.lazar@amd.com>
    drm/amdgpu: Fix wait after reset sequence in S4

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915/cdclk: Do the full CDCLK dance for min_voltage_level changes

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

David Lechner <dlechner@baylibre.com>
    iio: orientation: hid-sensor-rotation: add timestamp hack to not break userspace

David Lechner <dlechner@baylibre.com>
    iio: orientation: hid-sensor-rotation: fix quaternion alignment

David Lechner <dlechner@baylibre.com>
    iio: add IIO_DECLARE_QUATERNION() macro

Adam Crosser <adam.crosser@praetorian.com>
    gpib: fix use-after-free in IO ioctl handlers

Prike Liang <Prike.Liang@amd.com>
    drm/amdgpu: fix the idr allocation flags

Aleksandr Nogikh <nogikh@google.com>
    x86/kexec: Disable KCOV instrumentation after load_segments()

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

Oleh Konko <security@1seal.org>
    Bluetooth: hci_event: move wake reason storage into validated event handlers

hkbinbin <hkbinbinbin@gmail.com>
    Bluetooth: hci_sync: fix stack buffer overflow in hci_le_big_create_sync

Oleh Konko <security@1seal.org>
    Bluetooth: SMP: force responder MITM requirements before building the pairing response

Oleh Konko <security@1seal.org>
    Bluetooth: SMP: derive legacy responder STK authentication from MITM state

Junxi Qian <qjx1298677004@gmail.com>
    io_uring/net: fix slab-out-of-bounds read in io_bundle_nbufs()

Zhang Heng <zhangheng@kylinos.cn>
    ALSA: hda/realtek: change quirk for HP OmniBook 7 Laptop 16-bh0xxx

Sourav Nayak <nonameblank007@gmail.com>
    ALSA: hda/realtek: add quirk for HP Victus 15-fb0xxx

Zhang Heng <zhangheng@kylinos.cn>
    ALSA: hda/realtek: Add quirk for ASUS ROG Strix SCAR 15

Zhang Heng <zhangheng@kylinos.cn>
    ALSA: hda/realtek: add quirk for Acer Swift SFG14-73

Takashi Iwai <tiwai@suse.de>
    ALSA: ctxfi: Don't enumerate SPDIF1 at DAIO initialization

Takashi Iwai <tiwai@suse.de>
    ALSA: ctxfi: Fix missing SPDIFI1 index handling

Takashi Iwai <tiwai@suse.de>
    ALSA: ctxfi: Check the error for index mapping

Berk Cem Goksel <berkcgoksel@gmail.com>
    ALSA: caiaq: fix stack out-of-bounds read in init_card

Tejun Heo <tj@kernel.org>
    sched_ext: Fix SCX_KICK_WAIT deadlock by deferring wait to balance callback

Eric Biggers <ebiggers@kernel.org>
    lib/crypto: chacha: Zeroize permuted_state before it leaves scope

Cheng-Yang Chou <yphbchou0911@gmail.com>
    sched_ext: Fix inconsistent NUMA node lookup in scx_select_cpu_dfl()

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/display: Fix NULL pointer dereference in dcn401_init_hw()

Ernestas Kulik <ernestas.k@iconn-networks.com>
    USB: serial: option: add MeiG Smart SRM825WN

Alexey Velichayshiy <a.velichayshiy@ispras.ru>
    wifi: iwlwifi: mvm: fix potential out-of-bounds read in iwl_mvm_nd_match_info_handler()

Yasuaki Torimaru <yasuakitorimaru@gmail.com>
    wifi: wilc1000: fix u8 overflow in SSID scan buffer size calculation

Alice Ryhl <aliceryhl@google.com>
    rust_binder: use AssertSync for BINDER_VM_OPS

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    drm/ioc32: stop speculation on the drm_compat_ioctl path

Sunil V L <sunilvl@oss.qualcomm.com>
    ACPI: RIMT: Add dependency between iommu and devices

Zishun Yi <vulab@iscas.ac.cn>
    riscv: Reset pmm when PR_TAGGED_ADDR_ENABLE is not set

Paul Walmsley <pjw@kernel.org>
    riscv: kgdb: fix several debug register assignment bugs

Ian Rogers <irogers@google.com>
    perf/x86: Fix potential bad container_of in intel_pmu_hw_config

Peter Zijlstra <peterz@infradead.org>
    sched/debug: Fix avg_vruntime() usage

Peter Zijlstra <peterz@infradead.org>
    sched/fair: Fix zero_vruntime tracking fix

Shiji Yang <yangshiji66@outlook.com>
    mips: ralink: update CPU clock index

Corey Hickey <bugfood-c@fatooh.org>
    hwmon: (asus-ec-sensors) Fix T_Sensor for PRIME X670E-PRO WIFI

Chen Ni <nichen@iscas.ac.cn>
    drm/sysfb: Fix efidrm error handling and memory type mismatch

Jessica Liu <liu.xuemei1@zte.com.cn>
    irqchip/riscv-aplic: Restrict genpd notifier to device tree only

Sanman Pradhan <psanman@juniper.net>
    hwmon: (occ) Fix missing newline in occ_show_extended()

Felix Gu <ustc.gu@gmail.com>
    spi: amlogic: spifc-a4: unregister ECC engine on probe failure and remove() callback

Sanman Pradhan <psanman@juniper.net>
    hwmon: (tps53679) Fix device ID comparison and printing in tps53676_identify()

Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
    drm/xe/pxp: Clear restart flag in pxp_start after jumping back

Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
    drm/xe/pxp: Remove incorrect handling of impossible state during suspend

Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
    drm/xe/pxp: Clean up termination status on failure

Jonathan Cavitt <jonathan.cavitt@intel.com>
    drm/xe/xe_pagefault: Disallow writes to read-only VMAs

Felix Gu <ustc.gu@gmail.com>
    spi: stm32-ospi: Fix reset control leak on probe error

Felix Gu <ustc.gu@gmail.com>
    spi: stm32-ospi: Fix resource leak in remove() callback

Jamie Gibbons <jamie.gibbons@microchip.com>
    dt-bindings: gpio: fix microchip #interrupt-cells

Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
    gpio: shared: shorten the critical section in gpiochip_setup_shared()

Sanman Pradhan <psanman@juniper.net>
    hwmon: (ltc4286) Add missing MODULE_IMPORT_NS("PMBUS")

Sanman Pradhan <psanman@juniper.net>
    hwmon: (pxe1610) Check return value of page-select write in probe

Sanman Pradhan <psanman@juniper.net>
    hwmon: (tps53679) Fix array access with zero-length block read

Qi Tang <tpluszz77@gmail.com>
    io_uring/rsrc: reject zero-length fixed buffer import

Youssef Samir <youssef.abdulrahman@oss.qualcomm.com>
    accel/qaic: Handle DBC deactivation if the owner went away

Liu Ying <victor.liu@nxp.com>
    drm/bridge: Fix refcount shown via debugfs for encoder_bridges_show()

Felix Gu <ustc.gu@gmail.com>
    gpio: qixis-fpga: Fix error handling for devm_regmap_init_mmio()

Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
    gpio: shared: handle pins shared by child nodes of devices

Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
    gpio: shared: call gpio_chip::of_xlate() if set

Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
    interconnect: qcom: sm8450: Fix NULL pointer dereference in icc_link_nodes()

Barnabás Pőcze <pobrn@protonmail.com>
    gpiolib: clear requested flag if line is invalid

David Lechner <dlechner@baylibre.com>
    iio: imu: bno055: fix BNO055_SCAN_CH_COUNT off by one

Maarten Lankhorst <dev@lankhorst.se>
    Revert "drm: Fix use-after-free on framebuffers and property blobs when calling drm_dev_unplug"

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix incorrect pruning due to atomic fetch precision tracking

Varun R Mallya <varunrmallya@gmail.com>
    bpf: Reject sleepable kprobe_multi programs at attach time

Qi Tang <tpluszz77@gmail.com>
    bpf: reject direct access to nullable PTR_TO_BUF pointers

Dimitri Daskalakis <daskald@meta.com>
    eth: fbnic: Increase FBNIC_QUEUE_SIZE_MIN to 64

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

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Don't assume XDP is never enabled in bnxt_init_dflt_ring_mode()

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Refactor some basic ring setup and adjustment logic

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

Jonathan Rissanen <jonathan.rissanen@axis.com>
    Bluetooth: hci_h4: Fix race during initialization

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_sync: Fix UAF in le_read_features_complete

Pauli Virtanen <pav@iki.fi>
    Bluetooth: hci_sync: fix leaks when hci_cmd_sync_queue_once fails

Pauli Virtanen <pav@iki.fi>
    Bluetooth: hci_sync: hci_cmd_sync_queue_once() return -EEXIST if exists

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Add support for setting BT_PHY

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

Geoffrey D. Bennett <g@b4.vu>
    ALSA: usb-audio: Exclude Scarlett 2i2 1st Gen (8016) from SKIP_IFACE_SETUP

Michal Piekos <michal.piekos@mmpsystems.pl>
    net: stmmac: skip VLAN restore when VLAN hash ops are missing

Li Xiasong <lixiasong1@huawei.com>
    mptcp: fix soft lockup in mptcp_recvmsg()

Geliang Tang <geliang@kernel.org>
    mptcp: add eat_recv_skb helper

Zhengchuan Liang <zcliangcn@gmail.com>
    net: ipv6: flowlabel: defer exclusive option free until RCU teardown

Alexei Starovoitov <ast@kernel.org>
    bpf: Fix regsafe() for pointers to packet

Xiang Mei <xmei5@asu.edu>
    bridge: mrp: reject zero test interval to avoid OOM panic

Julian Braha <julianbraha@gmail.com>
    ASoC: Intel: boards: fix unmet dependency on PINCTRL

Suraj Gupta <suraj.gupta2@amd.com>
    net: xilinx: axienet: Fix BQL accounting for multi-BD TX packets

Suraj Gupta <suraj.gupta2@amd.com>
    net: xilinx: axienet: Correct BD length masks to match AXIDMA IP spec

Pengpeng Hou <pengpeng@iscas.ac.cn>
    NFC: pn533: bound the UART receive buffer

Xiang Mei <xmei5@asu.edu>
    net: bonding: fix use-after-free in bond_xmit_broadcast()

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: authencesn - Do not place hiseq at end of dst for out-of-place decryption

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: algif_aead - Revert to operating out-of-place

Pengpeng Hou <pengpeng@iscas.ac.cn>
    bnxt_en: set backing store type from query type

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

Dag Smedberg <dag@dsmedberg.se>
    ALSA: usb-audio: Exclude Scarlett Solo 1st Gen from SKIP_IFACE_SETUP

Wei Fang <wei.fang@nxp.com>
    net: enetc: do not allow VF to configure the RSS key

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

David Carlier <devnexen@gmail.com>
    net: ti: icssg-prueth: fix missing data copy and wrong recycle in ZC RX dispatch

Thomas Bogendoerfer <tbogendoerfer@suse.de>
    tg3: Fix race for querying speed/duplex

Pengpeng Hou <pengpeng@iscas.ac.cn>
    net/ipv6: ioam6: prevent schema length wraparound in trace fill

Sherry Yang <sherry.yang@oracle.com>
    iommupt/amdv1: mark amdv1pt_install_leaf_entry as __always_inline

Yochai Eisenrich <echelonh@gmail.com>
    net: ipv6: ndisc: fix ndisc_ra_useropt to initialize nduseropt_padX fields to zero to prevent an info-leak

Jiayuan Chen <jiayuan.chen@shopee.com>
    net: qrtr: replace qrtr_tx_flow radix_tree with xarray to fix memory leak

Wei Fang <wei.fang@nxp.com>
    net: enetc: do not access non-existent registers on pseudo MAC

Wei Fang <wei.fang@nxp.com>
    net: enetc: add graceful stop to safely reinitialize the TX Ring

Wei Fang <wei.fang@nxp.com>
    net: enetc: reset PIR and CIR if they are not equal when initializing TX ring

Buday Csaba <buday.csaba@prolan.hu>
    net: fec: fix the PTP periodic output sysfs interface

Qingfang Deng <dqfext@gmail.com>
    netdevsim: fix build if SKB_EXTENSIONS=n

Dipayaan Roy <dipayanroy@linux.microsoft.com>
    net: mana: Fix RX skb truesize accounting

Sabrina Dubroca <sd@queasysnail.net>
    mpls: add seqcount to protect the platform_label{,s} pair

Norbert Szetei <norbert@doyensec.com>
    crypto: af-alg - fix NULL pointer dereference in scatterwalk

Mikulas Patocka <mpatocka@redhat.com>
    crypto: deflate - fix spurious -ENOSPC

Horia Geantă <horia.geanta@nxp.com>
    crypto: caam - fix overflow on long hmac keys

Horia Geantă <horia.geanta@nxp.com>
    crypto: caam - fix DMA corruption on long hmac keys

Tejun Heo <tj@kernel.org>
    cgroup: Fix cgroup_drain_dying() testing the wrong condition

Tejun Heo <tj@kernel.org>
    selftests/cgroup: Don't require synchronous populated update on task exit

Tejun Heo <tj@kernel.org>
    cgroup: Wait for dying tasks to leave on rmdir

Reshma Immaculate Rajkumar <reshma.rajkumar@oss.qualcomm.com>
    wifi: ath11k: Pass the correct value of each TID during a stop AMPDU session

Johannes Berg <johannes.berg@intel.com>
    wifi: iwlwifi: mld: correctly set wifi generation data

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: mvm: don't send a 6E related command when not supported

Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
    wifi: iwlwifi: mld: Fix MLO scan timing

Frank Li <Frank.Li@nxp.com>
    dt-bindings: auxdisplay: ht16k33: Use unevaluatedProperties to fix common property warning

Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
    mshv: Fix error handling in mshv_region_pin

Praveen Talari <praveen.talari@oss.qualcomm.com>
    spi: geni-qcom: Check DMA interrupts early in ISR

Paulo Alcantara <pc@manguebit.org>
    smb: client: fix generic/694 due to wrong ->i_blocks

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Fix gamma 2.2 colorop TFs

ZhengYuan Huang <gality369@gmail.com>
    btrfs: reject root items with drop_progress and zero drop_level

Mikko Perttunen <mperttunen@nvidia.com>
    i2c: tegra: Don't mark devices with pins as IRQ safe

Filipe Manana <fdmanana@suse.com>
    btrfs: reserve enough transaction items for qgroup ioctls

Lee Jones <lee@kernel.org>
    HID: multitouch: Check to ensure report responses match the request

Joe Lawrence <joe.lawrence@redhat.com>
    objtool/klp: fix mkstemp() failure with long paths

Lee Jones <lee@kernel.org>
    HID: core: Mitigate potential OOB by removing bogus memset()

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

Long Li <leo.lilong@huawei.com>
    xfs: close crash window in attr dabtree inactivation

Long Li <leo.lilong@huawei.com>
    xfs: factor out xfs_attr3_leaf_init

Long Li <leo.lilong@huawei.com>
    xfs: factor out xfs_attr3_node_entry_remove

Josef Bacik <josef@toxicpanda.com>
    scsi: target: tcm_loop: Drain commands in target_reset handler

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    scsi: target: file: Use kzalloc_flex for aio_cmd

Guangshuo Li <lgs201920130244@gmail.com>
    net: mana: fix use-after-free in add_adev() error path

Willem de Bruijn <willemb@google.com>
    net: correctly handle tunneled traffic on IPV6_CSUM GSO fallback

Yang Wang <kevinyang.wang@amd.com>
    drm/amd/pm: disable OD_FAN_CURVE if temp or pwm range invalid for smu v13


-------------

Diffstat:

 .../bindings/auxdisplay/holtek,ht16k33.yaml        |   2 +-
 .../bindings/connector/usb-connector.yaml          |   1 +
 .../bindings/gpio/microchip,mpfs-gpio.yaml         |   4 +-
 Makefile                                           |   4 +-
 arch/arm64/kernel/pi/patch-scs.c                   |   8 +
 arch/mips/lib/multi3.c                             |   6 +-
 arch/mips/mm/cache.c                               |   3 +-
 arch/mips/mm/tlb-r4k.c                             |   2 +-
 arch/mips/ralink/clk.c                             |   8 +-
 arch/riscv/kernel/kgdb.c                           |   7 +-
 arch/riscv/kernel/process.c                        |   4 +-
 arch/s390/kernel/perf_cpum_sf.c                    |   6 +-
 arch/x86/events/intel/core.c                       |   6 +-
 arch/x86/kernel/Makefile                           |  14 ++
 arch/x86/mm/Makefile                               |   2 +
 arch/x86/platform/geode/geode-common.c             |  24 ++-
 crypto/af_alg.c                                    |  53 ++----
 crypto/algif_aead.c                                | 100 ++---------
 crypto/algif_skcipher.c                            |   6 +-
 crypto/authencesn.c                                |  50 +++---
 crypto/deflate.c                                   |  11 +-
 drivers/accel/qaic/qaic_control.c                  |  47 ++++-
 drivers/acpi/riscv/rimt.c                          |   7 +
 drivers/android/binder/page_range.rs               |   8 +-
 drivers/android/binder/rust_binder_main.rs         |   2 +-
 drivers/auxdisplay/line-display.c                  |   2 +-
 drivers/bluetooth/hci_h4.c                         |   3 -
 drivers/comedi/comedi_fops.c                       |   8 +-
 drivers/comedi/drivers.c                           |   8 +
 drivers/comedi/drivers/dt2815.c                    |  12 ++
 drivers/comedi/drivers/me4000.c                    |  16 +-
 drivers/comedi/drivers/me_daq.c                    |  35 ++--
 drivers/comedi/drivers/ni_atmio16d.c               |   3 +-
 drivers/counter/rz-mtu3-cnt.c                      |  67 +++----
 drivers/cpufreq/cpufreq_governor.c                 |   6 +-
 drivers/crypto/caam/caamalg_qi2.c                  |   3 +-
 drivers/crypto/caam/caamhash.c                     |   3 +-
 drivers/crypto/tegra/tegra-se-aes.c                |  11 +-
 drivers/crypto/tegra/tegra-se-hash.c               |  30 ++--
 drivers/firmware/microchip/mpfs-auto-update.c      |  10 +-
 drivers/gpib/Kconfig                               |   1 +
 drivers/gpib/common/gpib_os.c                      |  96 +++++++---
 drivers/gpib/include/gpib_types.h                  |   8 +
 drivers/gpib/lpvo_usb_gpib/lpvo_usb_gpib.c         |   4 +-
 drivers/gpio/gpio-mxc.c                            |  10 +-
 drivers/gpio/gpio-qixis-fpga.c                     |   4 +-
 drivers/gpio/gpiolib-shared.c                      |  57 ++++--
 drivers/gpio/gpiolib-shared.h                      |  11 +-
 drivers/gpio/gpiolib.c                             | 135 +++++++-------
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |   8 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c            |   5 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c          |   7 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h             |   2 +-
 drivers/gpu/drm/amd/amdgpu/psp_v11_0.c             |   3 +-
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h              |   4 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_colorop.c  |   6 +-
 .../drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c  |  17 +-
 drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c     |   1 -
 drivers/gpu/drm/amd/pm/swsmu/smu12/smu_v12_0.c     |   1 -
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c   |  33 +++-
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c   |  33 +++-
 drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0.c     |   1 -
 drivers/gpu/drm/ast/ast_dp501.c                    |   2 +-
 drivers/gpu/drm/drm_bridge.c                       |  16 +-
 drivers/gpu/drm/drm_file.c                         |   5 +-
 drivers/gpu/drm/drm_ioc32.c                        |   2 +
 drivers/gpu/drm/drm_mode_config.c                  |   9 +-
 drivers/gpu/drm/i915/display/g4x_dp.c              |   2 +-
 drivers/gpu/drm/i915/display/icl_dsi.c             |   4 +-
 drivers/gpu/drm/i915/display/intel_cdclk.c         |  54 ++++++
 drivers/gpu/drm/sysfb/efidrm.c                     |  46 +++--
 drivers/gpu/drm/xe/xe_pagefault.c                  |   6 +
 drivers/gpu/drm/xe/xe_pxp.c                        |  11 +-
 drivers/hid/hid-appletb-kbd.c                      |   5 +-
 drivers/hid/hid-core.c                             |   7 +-
 drivers/hid/hid-logitech-hidpp.c                   |   6 +-
 drivers/hid/hid-multitouch.c                       |   7 +
 drivers/hid/wacom_wac.c                            |  10 ++
 drivers/hv/mshv_regions.c                          |   6 +-
 drivers/hwmon/asus-ec-sensors.c                    |   7 +-
 drivers/hwmon/occ/common.c                         |  19 +-
 drivers/hwmon/pmbus/ltc4286.c                      |   1 +
 drivers/hwmon/pmbus/pxe1610.c                      |   5 +-
 drivers/hwmon/pmbus/tps53679.c                     |  10 +-
 drivers/i2c/busses/Kconfig                         |   2 +
 drivers/i2c/busses/i2c-tegra.c                     |   5 +-
 drivers/iio/accel/adxl313_core.c                   |   2 +
 drivers/iio/accel/adxl355_core.c                   |   2 +-
 drivers/iio/accel/adxl380.c                        |   2 +-
 drivers/iio/adc/ade9000.c                          |  12 +-
 drivers/iio/adc/aspeed_adc.c                       |   1 +
 drivers/iio/adc/ti-adc161s626.c                    |  41 +++--
 drivers/iio/adc/ti-ads1119.c                       |  11 +-
 drivers/iio/adc/ti-ads7950.c                       |   8 +-
 drivers/iio/dac/ad5770r.c                          |   2 +-
 drivers/iio/gyro/mpu3050-core.c                    |  32 ++--
 drivers/iio/imu/adis16550.c                        |   8 +-
 drivers/iio/imu/bmi160/bmi160_core.c               |  15 +-
 drivers/iio/imu/bno055/bno055.c                    |   2 +-
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c     |  15 +-
 drivers/iio/light/vcnl4035.c                       |  18 +-
 drivers/iio/light/veml6070.c                       |   4 +-
 drivers/iio/orientation/hid-sensor-rotation.c      |  24 ++-
 drivers/input/joystick/xpad.c                      |   5 +
 drivers/input/mouse/bcm5974.c                      |  42 ++++-
 drivers/input/rmi4/rmi_f54.c                       |   4 +-
 drivers/input/serio/i8042-acpipnpio.h              |   7 +
 drivers/interconnect/qcom/sm8450.c                 |   4 +-
 drivers/iommu/generic_pt/fmt/amdv1.h               |   2 +-
 drivers/iommu/generic_pt/iommu_pt.h                |   2 +-
 drivers/irqchip/irq-riscv-aplic-main.c             |   4 +-
 drivers/misc/fastrpc.c                             |   5 +-
 drivers/misc/mei/hw-me.c                           |  14 +-
 drivers/net/bonding/bond_main.c                    |   2 +-
 drivers/net/ethernet/airoha/airoha_eth.c           |  18 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  76 +++++---
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |   5 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c      |   5 +-
 drivers/net/ethernet/broadcom/tg3.c                |  13 +-
 drivers/net/ethernet/cadence/macb_pci.c            |  10 +-
 drivers/net/ethernet/faraday/ftgmac100.c           |  28 ++-
 drivers/net/ethernet/freescale/enetc/enetc.c       |  13 +-
 drivers/net/ethernet/freescale/enetc/enetc4_hw.h   |  11 ++
 drivers/net/ethernet/freescale/enetc/enetc4_pf.c   | 118 +++++++++++--
 .../net/ethernet/freescale/enetc/enetc_ethtool.c   |  10 +-
 drivers/net/ethernet/freescale/fec_ptp.c           |   3 -
 drivers/net/ethernet/mediatek/mtk_ppe_offload.c    |  21 ++-
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |   4 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/fw.c       |  49 ++++--
 .../net/ethernet/mellanox/mlx5/core/lag/debugfs.c  |   3 +
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |   4 +-
 drivers/net/ethernet/meta/fbnic/fbnic_txrx.c       |   6 +-
 drivers/net/ethernet/meta/fbnic/fbnic_txrx.h       |   2 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c      |  13 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  14 +-
 drivers/net/ethernet/ti/icssg/icssg_common.c       |   2 +-
 drivers/net/ethernet/xilinx/xilinx_axienet.h       |   4 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |   9 +-
 drivers/net/phy/sfp.c                              |   7 +-
 drivers/net/virtio_net.c                           |  20 +--
 drivers/net/vxlan/vxlan_core.c                     |   6 +-
 drivers/net/wireless/ath/ath11k/dp_rx.c            |  15 +-
 .../net/wireless/intel/iwlwifi/fw/api/commands.h   |   5 +
 drivers/net/wireless/intel/iwlwifi/fw/api/scan.h   |  10 ++
 drivers/net/wireless/intel/iwlwifi/mld/iface.c     | 101 +++++++----
 drivers/net/wireless/intel/iwlwifi/mld/mac80211.c  |  19 ++
 drivers/net/wireless/intel/iwlwifi/mld/mld.c       |   1 +
 drivers/net/wireless/intel/iwlwifi/mld/mlo.c       |   4 +-
 drivers/net/wireless/intel/iwlwifi/mld/notif.c     |   5 +
 drivers/net/wireless/intel/iwlwifi/mld/scan.c      |  30 +++-
 drivers/net/wireless/intel/iwlwifi/mld/scan.h      |   9 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |   3 +-
 drivers/net/wireless/microchip/wilc1000/hif.c      |   2 +-
 drivers/net/wireless/virtual/virt_wifi.c           |   1 -
 drivers/nfc/pn533/uart.c                           |   3 +
 drivers/nvmem/imx-ocotp-ele.c                      |   1 +
 drivers/nvmem/imx-ocotp.c                          |   1 +
 drivers/nvmem/zynqmp_nvmem.c                       |   8 +-
 drivers/reset/core.c                               |   1 -
 drivers/s390/crypto/zcrypt_msgtype6.c              |  32 ++--
 drivers/spi/spi-amlogic-spifc-a4.c                 |  12 ++
 drivers/spi/spi-cadence-quadspi.c                  |  17 +-
 drivers/spi/spi-geni-qcom.c                        |   9 +-
 drivers/spi/spi-stm32-ospi.c                       |   9 +-
 drivers/target/loopback/tcm_loop.c                 |  52 +++++-
 drivers/target/target_core_file.c                  |   2 +-
 drivers/thermal/thermal_core.c                     |  32 +++-
 drivers/thunderbolt/nhi.c                          |   2 +-
 drivers/tty/vt/vt.c                                |  18 ++
 drivers/usb/cdns3/cdns3-gadget.c                   |   4 +
 drivers/usb/class/cdc-acm.c                        |   9 +
 drivers/usb/class/cdc-acm.h                        |   1 +
 drivers/usb/class/usbtmc.c                         |   3 +
 drivers/usb/common/ulpi.c                          |   5 +-
 drivers/usb/core/driver.c                          |  23 ++-
 drivers/usb/core/offload.c                         | 102 ++++++-----
 drivers/usb/core/phy.c                             |  12 +-
 drivers/usb/core/quirks.c                          |   3 +
 drivers/usb/core/usb.c                             |   1 +
 drivers/usb/dwc2/gadget.c                          |   2 +
 drivers/usb/gadget/function/f_ecm.c                |  35 ++--
 drivers/usb/gadget/function/f_eem.c                |  59 ++++---
 drivers/usb/gadget/function/f_hid.c                |  19 +-
 drivers/usb/gadget/function/f_rndis.c              |  49 ++++--
 drivers/usb/gadget/function/f_subset.c             |  63 ++++---
 drivers/usb/gadget/function/f_uac1_legacy.c        |  47 +++--
 drivers/usb/gadget/function/f_uvc.c                |  39 +++-
 drivers/usb/gadget/function/u_ecm.h                |  21 ++-
 drivers/usb/gadget/function/u_eem.h                |  21 ++-
 drivers/usb/gadget/function/u_ether.c              |  16 +-
 drivers/usb/gadget/function/u_gether.h             |  22 ++-
 drivers/usb/gadget/function/u_rndis.h              |  31 +++-
 drivers/usb/gadget/function/uvc.h                  |   3 +
 drivers/usb/gadget/function/uvc_v4l2.c             |   5 +-
 drivers/usb/gadget/udc/dummy_hcd.c                 |  42 +++--
 drivers/usb/host/ehci-brcm.c                       |   4 +-
 drivers/usb/host/xhci-sideband.c                   |  18 +-
 drivers/usb/misc/usbio.c                           |   7 +-
 drivers/usb/serial/io_edgeport.c                   |   3 +
 drivers/usb/serial/io_usbvend.h                    |   1 +
 drivers/usb/serial/option.c                        |   4 +
 drivers/usb/typec/altmodes/thunderbolt.c           |  44 ++---
 drivers/usb/typec/ucsi/ucsi.c                      |   9 +-
 fs/btrfs/ioctl.c                                   |  12 +-
 fs/btrfs/tree-checker.c                            |  17 ++
 fs/btrfs/zoned.c                                   |   6 +-
 fs/smb/client/cifsglob.h                           |   6 +
 fs/smb/client/file.c                               |   1 -
 fs/smb/client/inode.c                              |  21 +--
 fs/smb/client/smb2ops.c                            |  20 +--
 fs/smb/server/smb2pdu.c                            | 121 +++++++++----
 fs/smb/server/smbacl.c                             |  43 +++++
 fs/smb/server/smbacl.h                             |   2 +
 fs/xfs/libxfs/xfs_attr_leaf.c                      |  22 +++
 fs/xfs/libxfs/xfs_attr_leaf.h                      |   3 +
 fs/xfs/libxfs/xfs_da_btree.c                       |  53 ++++--
 fs/xfs/libxfs/xfs_da_btree.h                       |   2 +
 fs/xfs/xfs_attr_inactive.c                         |  99 ++++++-----
 include/crypto/if_alg.h                            |   5 +-
 include/linux/cgroup-defs.h                        |   3 +
 include/linux/iio/iio.h                            |  12 ++
 include/linux/netdevice.h                          |   3 +
 include/linux/netfilter/ipset/ip_set.h             |   2 +-
 include/linux/skbuff.h                             |   1 +
 include/linux/usb.h                                |  10 +-
 include/net/bluetooth/bluetooth.h                  |  39 ++--
 include/net/bluetooth/hci.h                        |   9 +
 include/net/bluetooth/hci_core.h                   |   1 +
 include/net/bluetooth/hci_sync.h                   |   3 +
 include/net/netfilter/nf_conntrack_expect.h        |  20 ++-
 include/net/netns/mpls.h                           |   1 +
 io_uring/io_uring.c                                |  62 ++++---
 io_uring/io_uring.h                                |  34 +++-
 io_uring/net.c                                     |   4 +
 io_uring/rsrc.c                                    |   4 +
 kernel/bpf/verifier.c                              |  37 +++-
 kernel/cgroup/cgroup.c                             |  88 ++++++++-
 kernel/kallsyms.c                                  |  64 +++++--
 kernel/power/em_netlink.c                          |   2 +
 kernel/sched/debug.c                               |   4 +-
 kernel/sched/ext.c                                 | 144 +++++++++++----
 kernel/sched/ext_idle.c                            |  33 ++--
 kernel/sched/fair.c                                |  10 +-
 kernel/sched/sched.h                               |   3 +
 kernel/trace/bpf_trace.c                           |   4 +
 lib/crypto/chacha-block-generic.c                  |   4 +
 net/atm/lec.c                                      |  72 +++++---
 net/atm/lec.h                                      |   2 +-
 net/bluetooth/hci_conn.c                           | 113 +++++++++++-
 net/bluetooth/hci_event.c                          | 153 ++++++++--------
 net/bluetooth/hci_sync.c                           | 152 +++++++++++++---
 net/bluetooth/l2cap_sock.c                         |  20 ++-
 net/bluetooth/mgmt.c                               |  17 +-
 net/bluetooth/sco.c                                |  30 +++-
 net/bluetooth/smp.c                                |  11 +-
 net/bridge/br_arp_nd_proxy.c                       |  18 +-
 net/bridge/br_mrp_netlink.c                        |   4 +-
 net/core/dev.c                                     |  38 +++-
 net/core/skmsg.c                                   |  13 +-
 net/hsr/hsr_device.c                               |  32 ++--
 net/ipv6/addrconf.c                                |   6 +-
 net/ipv6/datagram.c                                |  10 ++
 net/ipv6/icmp.c                                    |   3 +
 net/ipv6/ioam6.c                                   |   4 +-
 net/ipv6/ip6_flowlabel.c                           |   5 -
 net/ipv6/ip6_tunnel.c                              |   5 +
 net/ipv6/ndisc.c                                   |   3 +
 net/mac80211/tdls.c                                |   2 +-
 net/mpls/af_mpls.c                                 |  29 ++-
 net/mptcp/protocol.c                               |  30 ++--
 net/netfilter/ipset/ip_set_core.c                  |   4 +-
 net/netfilter/ipset/ip_set_hash_gen.h              |   2 +-
 net/netfilter/ipset/ip_set_list_set.c              |   4 +-
 net/netfilter/nf_conntrack_broadcast.c             |   8 +-
 net/netfilter/nf_conntrack_expect.c                |  25 ++-
 net/netfilter/nf_conntrack_h323_main.c             |  12 +-
 net/netfilter/nf_conntrack_helper.c                |  13 +-
 net/netfilter/nf_conntrack_netlink.c               |  87 +++------
 net/netfilter/nf_conntrack_sip.c                   |   4 +-
 net/netfilter/nf_flow_table_offload.c              | 196 ++++++++++++++-------
 net/netfilter/nf_tables_api.c                      |   7 +-
 net/netfilter/nfnetlink_log.c                      |   2 +-
 net/netfilter/x_tables.c                           |  23 +++
 net/netfilter/xt_cgroup.c                          |   6 +
 net/netfilter/xt_rateest.c                         |   5 +
 net/qrtr/af_qrtr.c                                 |  31 ++--
 net/rds/ib_rdma.c                                  |   7 +-
 net/sched/cls_api.c                                |   1 +
 net/sched/cls_flow.c                               |  10 +-
 net/sched/cls_fw.c                                 |  14 +-
 net/sched/sch_hfsc.c                               |   4 +-
 net/sched/sch_netem.c                              |   5 +-
 net/x25/x25_in.c                                   |   9 +-
 net/x25/x25_subr.c                                 |   1 +
 sound/hda/codecs/realtek/alc269.c                  |  12 +-
 sound/pci/ctxfi/ctatc.c                            |  10 +-
 sound/pci/ctxfi/ctdaio.c                           |  82 +++++----
 sound/soc/cirrus/ep93xx-i2s.c                      |  34 ++--
 sound/soc/intel/boards/Kconfig                     |   2 -
 sound/usb/caiaq/device.c                           |   2 +-
 sound/usb/qcom/qc_audio_offload.c                  |  10 +-
 sound/usb/quirks.c                                 |   2 +
 tools/objtool/check.c                              |   5 +-
 tools/objtool/elf.c                                |  23 +--
 tools/testing/selftests/cgroup/lib/cgroup_util.c   |  15 ++
 .../selftests/cgroup/lib/include/cgroup_util.h     |   2 +
 tools/testing/selftests/cgroup/test_core.c         |   3 +-
 tools/testing/selftests/cgroup/test_kill.c         |   7 +-
 311 files changed, 3926 insertions(+), 1765 deletions(-)



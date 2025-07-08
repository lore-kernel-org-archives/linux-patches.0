Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E194C2E4273;
	Tue,  8 Jul 2025 16:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751991807; cv=none; b=Hwh9LdYO/mER8Vl/GFTTfjNdU6M8aBjRP7l3TJIW0Ek+4gfcvs2o7hCE7uWf/X0t29LhBcA4AzXSFCFx1qXY2TY0kk3Ya5BUa6MeNUgHKevj0hcnTdbIyvJ9rSVMyfgXZIEVg4Do6RfIJoKd48etK2vgYNAaRLeSH7s9b7PwGyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751991807; c=relaxed/simple;
	bh=Yi5cpMA+zc6/FGgFSmCKW65Kp9uthPsWq9Aq4SZbeRs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=jpigEA5cOmHMC2axGkOvue1K/I3mGvI6TzE6rIqHqxHJwzVWGff0ApWG3WWozika/T2tM4ohmiy315pYcO0xFbHPjRBDaTMkvWbYmfoVqFcx7JQhZZGUf5fBBDxEmJXL5BClCvSSESoa6rH/m3lFgZcGDgufqlBGltpsRXb4ZLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VGV37dhM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VGV37dhM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02720C4CEED;
	Tue,  8 Jul 2025 16:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751991806;
	bh=Yi5cpMA+zc6/FGgFSmCKW65Kp9uthPsWq9Aq4SZbeRs=;
	h=From:To:Cc:Subject:Date:From;
	b=VGV37dhMhgyfpYAKdhKYwYuvhXFGXZsHlWBG8uJP3vWnhVf8zZF4JuRMEVD+HHqds
	 w7Et7JngU9uRKOZ0Aw7QqbpHk28uk8CrRnrx3a1C0joWJuWCghJ4Axw3mZs5KdJLKG
	 nZw2j/ZnLAeYQTRzL6BSUI4T8p1uLNESbaxUZpS8=
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
	broonie@kernel.org
Subject: [PATCH 5.15 000/160] 5.15.187-rc1 review
Date: Tue,  8 Jul 2025 18:20:37 +0200
Message-ID: <20250708162231.503362020@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.187-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.187-rc1
X-KernelTest-Deadline: 2025-07-10T16:22+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.15.187 release.
There are 160 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 10 Jul 2025 16:22:09 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.187-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.187-rc1

Borislav Petkov (AMD) <bp@alien8.de>
    x86/process: Move the buffer clearing before MONITOR

Borislav Petkov (AMD) <bp@alien8.de>
    KVM: SVM: Advertise TSA CPUID bits to guests

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: add support for CPUID leaf 0x80000021

Borislav Petkov (AMD) <bp@alien8.de>
    x86/bugs: Add a Transient Scheduler Attacks mitigation

Borislav Petkov (AMD) <bp@alien8.de>
    x86/bugs: Rename MDS machinery to something more generic

Andrei Kuchynski <akuchynski@chromium.org>
    usb: typec: displayport: Fix potential deadlock

Kurt Borja <kuurtb@gmail.com>
    platform/x86: think-lmi: Create ksets consecutively

Oliver Neukum <oneukum@suse.com>
    Logitech C-270 even more broken

Michael J. Ruhl <michael.j.ruhl@intel.com>
    i2c/designware: Fix an initialization issue

Peter Chen <peter.chen@cixtech.com>
    usb: cdnsp: do not disable slot for disabled slot

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: dbc: Flush queued requests before stopping dbc

Łukasz Bartosik <ukaszb@chromium.org>
    xhci: dbctty: disable ECHO flag by default

Kurt Borja <kuurtb@gmail.com>
    platform/x86: dell-wmi-sysman: Fix class device unregistration

Kurt Borja <kuurtb@gmail.com>
    platform/x86: think-lmi: Fix class device unregistration

Fushuai Wang <wangfushuai@baidu.com>
    dpaa2-eth: fix xdp_rxq_info leak

Ioana Ciornei <ioana.ciornei@nxp.com>
    net: dpaa2-eth: rearrange variable in dpaa2_eth_get_ethtool_stats

Radu Bulie <radu-andrei.bulie@nxp.com>
    dpaa2-eth: Update SINGLE_STEP register access

Radu Bulie <radu-andrei.bulie@nxp.com>
    dpaa2-eth: Update dpni_get_single_step_cfg command

Thomas Fourier <fourier.thomas@gmail.com>
    ethernet: atl1: Add missing DMA mapping error checks and count errors

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4/flexfiles: Fix handling of NFS level errors in I/O

Maíra Canal <mcanal@igalia.com>
    drm/v3d: Disable interrupts before resetting the GPU

Manivannan Sadhasivam <mani@kernel.org>
    regulator: gpio: Fix the out-of-bounds access to drvdata::gpiods

Jerome Neanne <jneanne@baylibre.com>
    regulator: gpio: Add input_supply support in gpio_regulator_config

Avri Altman <avri.altman@sandisk.com>
    mmc: core: sd: Apply BROKEN_SD_DISCARD quirk earlier

Uladzislau Rezki (Sony) <urezki@gmail.com>
    rcu: Return early if callback is not specified

Pablo Martin-Gomez <pmartin-gomez@freebox.fr>
    mtd: spinand: fix memory leak of ECC engine conf

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPICA: Refuse to evaluate a method if arguments are missing

Johannes Berg <johannes.berg@intel.com>
    wifi: ath6kl: remove WARN on bad firmware input

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: drop invalid source address OCB frames

Maurizio Lombardi <mlombard@redhat.com>
    scsi: target: Fix NULL pointer dereference in core_scsi3_decode_spec_i_port()

Madhavan Srinivasan <maddy@linux.ibm.com>
    powerpc: Fix struct termio related ioctl macros

Johannes Berg <johannes.berg@intel.com>
    ata: pata_cs5536: fix build on 32-bit UML

Takashi Iwai <tiwai@suse.de>
    ALSA: sb: Force to disable DMAs once when DMA mode is changed

Takashi Iwai <tiwai@suse.de>
    ALSA: sb: Don't allow changing the DMA mode during operations

Rob Clark <robdclark@chromium.org>
    drm/msm: Fix a fence leak in submit error path

Lion Ackermann <nnamrec@gmail.com>
    net/sched: Always pass notifications when child class becomes empty

Thomas Fourier <fourier.thomas@gmail.com>
    nui: Fix dma_mapping_error() check

Kohei Enju <enjuk@amazon.com>
    rose: fix dangling neighbour pointers in rose_rt_device_down()

Alok Tiwari <alok.a.tiwari@oracle.com>
    enic: fix incorrect MTU comparison in enic_change_mtu()

Raju Rangoju <Raju.Rangoju@amd.com>
    amd-xgbe: align CL37 AN sequence as per databook

Dan Carpenter <dan.carpenter@linaro.org>
    lib: test_objagg: Set error message in check_expect_hints_stats()

Vitaly Lifshits <vitaly.lifshits@intel.com>
    igc: disable L1.2 PCI-E link substate to avoid performance issue

Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
    drm/i915/gt: Fix timeline left held on VMA alloc error

Kurt Borja <kuurtb@gmail.com>
    platform/x86: dell-wmi-sysman: Fix WMI data block retrieval in sysfs callbacks

Dan Carpenter <dan.carpenter@linaro.org>
    drm/i915/selftests: Change mock_request() to return error pointers

James Clark <james.clark@linaro.org>
    spi: spi-fsl-dspi: Clear completion counter before initiating transfer

Marek Szyprowski <m.szyprowski@samsung.com>
    drm/exynos: fimd: Guard display clock control with runtime PM calls

Filipe Manana <fdmanana@suse.com>
    btrfs: fix missing error handling when searching for inode refs during log replay

Patrisious Haddad <phaddad@nvidia.com>
    RDMA/mlx5: Fix CC counters query for MPV

Bart Van Assche <bvanassche@acm.org>
    scsi: ufs: core: Fix spelling of a sysfs attribute name

Thomas Fourier <fourier.thomas@gmail.com>
    scsi: qla4xxx: Fix missing DMA mapping error in qla4xxx_alloc_pdu()

Thomas Fourier <fourier.thomas@gmail.com>
    scsi: qla2xxx: Fix DMA mapping test in qla24xx_get_port_database()

Benjamin Coddington <bcodding@redhat.com>
    NFSv4/pNFS: Fix a race to wake on NFS_LAYOUT_DRAIN

Kuniyuki Iwashima <kuniyu@google.com>
    nfs: Clean up /proc/net/rpc/nfs when nfs_fs_proc_net_init() fails.

Mark Zhang <markzhang@nvidia.com>
    RDMA/mlx5: Initialize obj_event->obj_sub_list before xa_insert

David Thompson <davthompson@nvidia.com>
    platform/mellanox: mlxbf-tmfifo: fix vring_desc.len assignment

Sergey Senozhatsky <senozhatsky@chromium.org>
    mtk-sd: reset host->mrq on prepare_data() error

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    mtk-sd: Prevent memory corruption from DMA map failure

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    mtk-sd: Fix a pagefault in dma_unmap_sg() for not prepared data

RD Babiera <rdbabiera@google.com>
    usb: typec: altmodes/displayport: do not index invalid pin_assignments

Ulf Hansson <ulf.hansson@linaro.org>
    Revert "mmc: sdhci: Disable SD card clock before changing parameters"

Victor Shih <victor.shih@genesyslogic.com.tw>
    mmc: sdhci: Add a helper function for dump register in dynamic debug mode

HarshaVardhana S A <harshavardhana.sa@broadcom.com>
    vsock/vmci: Clear the vmci transport packet properly when initializing it

Mateusz Jończyk <mat.jonczyk@o2.pl>
    rtc: cmos: use spin_lock_irqsave in cmos_interrupt

Geert Uytterhoeven <geert+renesas@glider.be>
    ARM: 9354/1: ptrace: Use bitfield helpers

Josef Bacik <josef@toxicpanda.com>
    btrfs: don't drop extent_map for free space inode on write error

Dev Jain <dev.jain@arm.com>
    arm64: Restrict pagetable teardown to avoid false warning

Brett A C Sheffield (Librecast) <bacs@librecast.net>
    Revert "ipv6: save dontfrag in cork"

Nathan Chancellor <nathan@kernel.org>
    s390: Add '-std=gnu11' to decompressor and purgatory CFLAGS

Heiko Carstens <hca@linux.ibm.com>
    s390/entry: Fix last breaking event handling in case of stack corruption

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Rollback non processed entities on error

Dexuan Cui <decui@microsoft.com>
    PCI: hv: Do not set PCI_COMMAND_MEMORY to reduce VM boot time

Wentao Liang <vulab@iscas.ac.cn>
    drm/amd/display: Add null pointer check for get_first_active_display()

Aradhya Bhatia <a-bhatia1@ti.com>
    drm/bridge: cdns-dsi: Wait for Clk and Data Lanes to be ready

Aradhya Bhatia <a-bhatia1@ti.com>
    drm/bridge: cdns-dsi: Check return value when getting default PHY config

Aradhya Bhatia <a-bhatia1@ti.com>
    drm/bridge: cdns-dsi: Fix connecting to next bridge

Aradhya Bhatia <a-bhatia1@ti.com>
    drm/bridge: cdns-dsi: Fix the clock variable for mode_valid()

Jay Cornwall <jay.cornwall@amd.com>
    drm/amdkfd: Fix race in GWS queue scheduling

Thomas Zimmermann <tzimmermann@suse.de>
    drm/udl: Unregister device before cleaning up on disconnect

Qiu-ji Chen <chenqiuji666@gmail.com>
    drm/tegra: Fix a possible null pointer dereference

Thierry Reding <treding@nvidia.com>
    drm/tegra: Assign plane type before registration

Qasim Ijaz <qasdev00@gmail.com>
    HID: wacom: fix kobject reference count leak

Qasim Ijaz <qasdev00@gmail.com>
    HID: wacom: fix memory leak on sysfs attribute creation failure

Qasim Ijaz <qasdev00@gmail.com>
    HID: wacom: fix memory leak on kobject creation failure

Mark Harmstone <maharmstone@fb.com>
    btrfs: update superblock's device bytes_used when dropping chunk

Heinz Mauelshagen <heinzm@redhat.com>
    dm-raid: fix variable in journal device check

Frédéric Danis <frederic.danis@collabora.com>
    Bluetooth: L2CAP: Fix L2CAP MTU negotiation

Yao Zi <ziyao@disroot.org>
    dt-bindings: serial: 8250: Make clocks and clock-frequency exclusive

Nathan Chancellor <nathan@kernel.org>
    staging: rtl8723bs: Avoid memset() in aes_cipher() and aes_decipher()

Jakub Kicinski <kuba@kernel.org>
    net: selftests: fix TCP packet checksum

Kuniyuki Iwashima <kuniyu@google.com>
    atm: Release atm_dev_mutex after removing procfs in atm_dev_deregister().

Simon Horman <horms@kernel.org>
    net: enetc: Correct endianness handling in _enetc_rd_reg64

Tiwei Bie <tiwei.btw@antgroup.com>
    um: ubd: Add missing error check in start_io_thread()

Stefano Garzarella <sgarzare@redhat.com>
    vsock/uapi: fix linux/vm_sockets.h userspace compilation errors

Kuniyuki Iwashima <kuniyu@google.com>
    af_unix: Don't set -ECONNRESET for consumed OOB skb.

Lachlan Hodges <lachlan.hodges@morsemicro.com>
    wifi: mac80211: fix beacon interval calculation overflow

Yuan Chen <chenyuan@kylinos.cn>
    libbpf: Fix null pointer dereference in btf_dump__free on allocation failure

Al Viro <viro@zeniv.linux.org.uk>
    attach_recursive_mnt(): do not lock the covering tree when sliding something under it

Youngjun Lee <yjjuny.lee@samsung.com>
    ALSA: usb-audio: Fix out-of-bounds read in snd_usb_get_audioformat_uac3()

Eric Dumazet <edumazet@google.com>
    atm: clip: prevent NULL deref in clip_push()

Fedor Pchelkin <pchelkin@ispras.ru>
    s390/pkey: Prevent overflow in size calculation for memdup_user()

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: robotfuzz-osif: disable zero-length read messages

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: tiny-usb: disable zero-length read messages

Rong Zhang <i@rong.moe>
    platform/x86: ideapad-laptop: use usleep_range() for EC polling

Thomas Zimmermann <tzimmermann@suse.de>
    dummycon: Trigger redraw when switching consoles with deferred takeover

Jiri Slaby (SUSE) <jirislaby@kernel.org>
    tty: vt: make consw::con_switch() return a bool

Jiri Slaby (SUSE) <jirislaby@kernel.org>
    tty: vt: sanitize arguments of consw::con_clear()

Jiri Slaby (SUSE) <jirislaby@kernel.org>
    tty: vt: make init parameter of consw::con_init() a bool

Jiri Slaby (SUSE) <jirislaby@kernel.org>
    vgacon: remove unneeded forward declarations

Jiri Slaby (SUSE) <jirislaby@kernel.org>
    vgacon: switch vgacon_scrolldelta() and vgacon_restore_screen()

Jiri Slaby <jirislaby@kernel.org>
    tty/vt: consolemap: rename and document struct uni_pagedir

Daniel Vetter <daniel.vetter@ffwll.ch>
    fbcon: delete a few unneeded forward decl

Long Li <longli@microsoft.com>
    uio_hv_generic: Align ring size to system page

Saurabh Sengar <ssengar@linux.microsoft.com>
    uio_hv_generic: Query the ringbuffer size for device

Saurabh Sengar <ssengar@linux.microsoft.com>
    Drivers: hv: vmbus: Add utility function for querying ring size

Vitaly Kuznetsov <vkuznets@redhat.com>
    Drivers: hv: Rename 'alloced' to 'allocated'

Murad Masimov <m.masimov@mt-integration.ru>
    fbdev: Fix do_register_framebuffer to prevent null-ptr-deref in fb_videomode_to_var

Daniel Vetter <daniel.vetter@ffwll.ch>
    fbcon: Move console_lock for register/unlink/unregister

Daniel Vetter <daniel.vetter@ffwll.ch>
    fbcon: use lock_fb_info in fbcon_open/release

Daniel Vetter <daniel.vetter@ffwll.ch>
    fbcon: move more common code into fb_open()

Daniel Vetter <daniel.vetter@ffwll.ch>
    fbcon: Extract fbcon_open/release helpers

Daniel Vetter <daniel.vetter@ffwll.ch>
    fbcon: Use delayed work for cursor

Chao Yu <chao@kernel.org>
    f2fs: don't over-report free space or inodes in statvfs

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ASoC: codecs: wcd9335: Fix missing free of regulator supplies

Peng Fan <peng.fan@nxp.com>
    ASoC: codec: wcd9335: Convert to GPIO descriptors

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ASoC: codecs: wcd9335: Handle nicer probe deferral and simplify with dev_err_probe()

Matti Vaittinen <mazziesaccount@gmail.com>
    regulator: Add devm helpers for get and enable

Douglas Anderson <dianders@chromium.org>
    regulator: core: Allow drivers to define their init data as const

Ming Qian <ming.qian@oss.nxp.com>
    media: imx-jpeg: Drop the first error frames

Miquel Raynal <miquel.raynal@bootlin.com>
    clk: ti: am43xx: Add clkctrl data for am43xx ADC1

Marek Szyprowski <m.szyprowski@samsung.com>
    media: omap3isp: use sgtable-based scatterlist wrappers

Dmitry Nikiforov <Dm1tryNk@yandex.ru>
    media: davinci: vpif: Fix memory leak in probe error path

Vasiliy Kovalev <kovalev@altlinux.org>
    jfs: validate AG parameters in dbMount() to prevent crashes

Dave Kleikamp <dave.kleikamp@oracle.com>
    fs/jfs: consolidate sanity checking in dbMount

Kees Cook <kees@kernel.org>
    ovl: Check for NULL d_inode() in ovl_dentry_upper()

Dmitry Kandybka <d.kandybka@gmail.com>
    ceph: fix possible integer overflow in ceph_zero_objects()

Mario Limonciello <mario.limonciello@amd.com>
    ALSA: usb-audio: Add a quirk for Lenovo Thinkpad Thunderbolt 3 dock

Vijendar Mukunda <Vijendar.Mukunda@amd.com>
    ALSA: hda: Add new pci id for AMD GPU display HD audio controller

Cezary Rojewski <cezary.rojewski@intel.com>
    ALSA: hda: Ignore unsol events for cards being shut down

Jos Wang <joswang@lenovo.com>
    usb: typec: displayport: Receive DP Status Update NAK request exit dp altmode

Robert Hodaszi <robert.hodaszi@digi.com>
    usb: cdc-wdm: avoid setting WDM_READ for ZLP-s

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    usb: Add checks for snprintf() calls in usb_alloc_dev()

Chance Yang <chance.yang@kneron.us>
    usb: common: usb-conn-gpio: use a unique name for usb connector device

Jakub Lewalski <jakub.lewalski@nokia.com>
    tty: serial: uartlite: register uart driver in init

Chen Yufeng <chenyufeng@iie.ac.cn>
    usb: potential integer overflow in usbg_make_tpg()

Michael Grzeschik <m.grzeschik@pengutronix.de>
    usb: dwc2: also exit clock_gating when stopping udc while suspended

James Clark <james.clark@linaro.org>
    coresight: Only check bottom two claim bits

Sami Tolvanen <samitolvanen@google.com>
    um: Add cmpxchg8b_emu and checksum functions to asm-prototypes.h

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: pressure: zpa2326: Use aligned_s64 for the timestamp

Linggang Zeng <linggang.zeng@easystack.cn>
    bcache: fix NULL pointer in cache_set_flush()

Yu Kuai <yukuai3@huawei.com>
    md/md-bitmap: fix dm-raid max_write_behind setting

Thomas Gessler <thomas.gessler@brueckmann-gmbh.de>
    dmaengine: xilinx_dma: Set dma_device directions

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: allow a filename to contain special characters on SMB3.1.1 posix extension

Alexis Czezar Torreno <alexisczezar.torreno@analog.com>
    hwmon: (pmbus/max34440) Fix support for max34451

Sven Schwermer <sven.schwermer@disruptive-technologies.com>
    leds: multicolor: Fix intensity setting while SW blinking

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    mfd: max14577: Fix wakeup source leaks on device unbind

Peng Fan <peng.fan@nxp.com>
    mailbox: Not protect module_put with spin_lock_irqsave

Olga Kornievskaia <okorniev@redhat.com>
    NFSv4.2: fix listxattr to return selinux security label

Han Young <hanyang.tony@bytedance.com>
    NFSv4: Always set NLINK even if the server doesn't support it

Pali Rohár <pali@kernel.org>
    cifs: Fix cifs_query_path_info() for Windows NT servers


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-devices-system-cpu |   1 +
 Documentation/ABI/testing/sysfs-driver-ufs         |   2 +-
 .../hw-vuln/processor_mmio_stale_data.rst          |   4 +-
 Documentation/admin-guide/kernel-parameters.txt    |  13 +
 Documentation/devicetree/bindings/serial/8250.yaml |   2 +-
 Makefile                                           |   4 +-
 arch/arm/include/asm/ptrace.h                      |   5 +-
 arch/arm64/mm/mmu.c                                |   3 +-
 arch/powerpc/include/uapi/asm/ioctls.h             |   8 +-
 arch/s390/Makefile                                 |   2 +-
 arch/s390/kernel/entry.S                           |   2 +-
 arch/s390/purgatory/Makefile                       |   2 +-
 arch/um/drivers/ubd_user.c                         |   2 +-
 arch/um/include/asm/asm-prototypes.h               |   5 +
 arch/x86/Kconfig                                   |   9 +
 arch/x86/entry/entry.S                             |   8 +-
 arch/x86/include/asm/cpu.h                         |  13 +
 arch/x86/include/asm/cpufeatures.h                 |   6 +
 arch/x86/include/asm/irqflags.h                    |   4 +-
 arch/x86/include/asm/mwait.h                       |  19 +-
 arch/x86/include/asm/nospec-branch.h               |  39 ++-
 arch/x86/kernel/cpu/amd.c                          |  58 ++++
 arch/x86/kernel/cpu/bugs.c                         | 133 +++++++-
 arch/x86/kernel/cpu/common.c                       |  14 +-
 arch/x86/kernel/cpu/scattered.c                    |   2 +
 arch/x86/kernel/process.c                          |  15 +-
 arch/x86/kvm/cpuid.c                               |  25 +-
 arch/x86/kvm/reverse_cpuid.h                       |   8 +
 arch/x86/kvm/svm/vmenter.S                         |   6 +
 arch/x86/kvm/vmx/vmx.c                             |   2 +-
 arch/x86/um/asm/checksum.h                         |   3 +
 drivers/acpi/acpica/dsmethod.c                     |   7 +
 drivers/ata/pata_cs5536.c                          |   2 +-
 drivers/base/cpu.c                                 |   2 +
 drivers/clk/ti/clk-43xx.c                          |   1 +
 drivers/dma/xilinx/xilinx_dma.c                    |   2 +
 drivers/gpu/drm/amd/amdkfd/kfd_packet_manager_v9.c |   2 +-
 .../gpu/drm/amd/display/modules/hdcp/hdcp_psp.c    |   3 +
 drivers/gpu/drm/bridge/cdns-dsi.c                  |  27 +-
 drivers/gpu/drm/exynos/exynos_drm_fimd.c           |  12 +
 drivers/gpu/drm/i915/gt/intel_ring_submission.c    |   3 +-
 drivers/gpu/drm/i915/selftests/i915_request.c      |  20 +-
 drivers/gpu/drm/i915/selftests/mock_request.c      |   2 +-
 drivers/gpu/drm/msm/msm_gem_submit.c               |   9 +
 drivers/gpu/drm/tegra/dc.c                         |  17 +-
 drivers/gpu/drm/tegra/hub.c                        |   4 +-
 drivers/gpu/drm/tegra/hub.h                        |   3 +-
 drivers/gpu/drm/udl/udl_drv.c                      |   2 +-
 drivers/gpu/drm/v3d/v3d_drv.h                      |   8 +
 drivers/gpu/drm/v3d/v3d_gem.c                      |   2 +
 drivers/gpu/drm/v3d/v3d_irq.c                      |  39 ++-
 drivers/hid/wacom_sys.c                            |   6 +-
 drivers/hv/channel_mgmt.c                          |  33 +-
 drivers/hv/hyperv_vmbus.h                          |  19 +-
 drivers/hv/vmbus_drv.c                             |   2 +-
 drivers/hwmon/pmbus/max34440.c                     |  48 ++-
 drivers/hwtracing/coresight/coresight-core.c       |   3 +-
 drivers/hwtracing/coresight/coresight-priv.h       |   1 +
 drivers/i2c/busses/i2c-designware-master.c         |   1 +
 drivers/i2c/busses/i2c-robotfuzz-osif.c            |   6 +
 drivers/i2c/busses/i2c-tiny-usb.c                  |   6 +
 drivers/iio/pressure/zpa2326.c                     |   2 +-
 drivers/infiniband/hw/mlx5/counters.c              |   2 +-
 drivers/infiniband/hw/mlx5/devx.c                  |   2 +-
 drivers/leds/led-class-multicolor.c                |   3 +-
 drivers/mailbox/mailbox.c                          |   2 +-
 drivers/md/bcache/super.c                          |   7 +-
 drivers/md/dm-raid.c                               |   2 +-
 drivers/md/md-bitmap.c                             |   2 +-
 drivers/media/platform/davinci/vpif.c              |   4 +-
 drivers/media/platform/imx-jpeg/mxc-jpeg.c         |  12 +-
 drivers/media/platform/omap3isp/ispccdc.c          |   8 +-
 drivers/media/platform/omap3isp/ispstat.c          |   6 +-
 drivers/media/usb/uvc/uvc_ctrl.c                   |  42 ++-
 drivers/mfd/max14577.c                             |   1 +
 drivers/mmc/core/quirks.h                          |  16 +-
 drivers/mmc/host/mtk-sd.c                          |  21 +-
 drivers/mmc/host/sdhci.c                           |   9 +-
 drivers/mmc/host/sdhci.h                           |  16 +
 drivers/mtd/nand/spi/core.c                        |   1 +
 drivers/net/ethernet/amd/xgbe/xgbe-common.h        |   2 +
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c          |   9 +
 drivers/net/ethernet/amd/xgbe/xgbe.h               |   4 +-
 drivers/net/ethernet/atheros/atlx/atl1.c           |  78 +++--
 drivers/net/ethernet/cisco/enic/enic_main.c        |   4 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   | 115 ++++++-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h   |  14 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-ethtool.c   |  18 +-
 drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h    |   6 +-
 drivers/net/ethernet/freescale/dpaa2/dpni.c        |   2 +
 drivers/net/ethernet/freescale/dpaa2/dpni.h        |   6 +
 drivers/net/ethernet/freescale/enetc/enetc_hw.h    |   2 +-
 drivers/net/ethernet/intel/igc/igc_main.c          |  10 +
 drivers/net/ethernet/sun/niu.c                     |  31 +-
 drivers/net/ethernet/sun/niu.h                     |   4 +
 drivers/net/wireless/ath/ath6kl/bmi.c              |   4 +-
 drivers/pci/controller/pci-hyperv.c                |  17 +-
 drivers/platform/mellanox/mlxbf-tmfifo.c           |   3 +-
 .../x86/dell/dell-wmi-sysman/dell-wmi-sysman.h     |   5 +
 .../x86/dell/dell-wmi-sysman/enum-attributes.c     |   5 +-
 .../x86/dell/dell-wmi-sysman/int-attributes.c      |   5 +-
 .../x86/dell/dell-wmi-sysman/passobj-attributes.c  |   5 +-
 .../x86/dell/dell-wmi-sysman/string-attributes.c   |   5 +-
 drivers/platform/x86/dell/dell-wmi-sysman/sysman.c |  12 +-
 drivers/platform/x86/ideapad-laptop.c              |  19 +-
 drivers/platform/x86/think-lmi.c                   |  18 +-
 drivers/regulator/devres.c                         | 192 ++++++++++++
 drivers/regulator/gpio-regulator.c                 |  19 +-
 drivers/rtc/rtc-cmos.c                             |  10 +-
 drivers/s390/crypto/pkey_api.c                     |   2 +-
 drivers/scsi/qla2xxx/qla_mbx.c                     |   2 +-
 drivers/scsi/qla4xxx/ql4_os.c                      |   2 +
 drivers/scsi/ufs/ufs-sysfs.c                       |   4 +-
 drivers/spi/spi-fsl-dspi.c                         |  11 +-
 drivers/staging/rtl8723bs/core/rtw_security.c      |  44 +--
 drivers/target/target_core_pr.c                    |   4 +-
 drivers/tty/serial/uartlite.c                      |  25 +-
 drivers/tty/vt/consolemap.c                        |  47 +--
 drivers/tty/vt/vt.c                                |  12 +-
 drivers/uio/uio_hv_generic.c                       |  10 +-
 drivers/usb/cdns3/cdnsp-ring.c                     |   4 +-
 drivers/usb/class/cdc-wdm.c                        |  23 +-
 drivers/usb/common/usb-conn-gpio.c                 |  25 +-
 drivers/usb/core/quirks.c                          |   3 +-
 drivers/usb/core/usb.c                             |  14 +-
 drivers/usb/dwc2/gadget.c                          |   6 +
 drivers/usb/gadget/function/f_tcm.c                |   4 +-
 drivers/usb/host/xhci-dbgcap.c                     |   4 +
 drivers/usb/host/xhci-dbgtty.c                     |   1 +
 drivers/usb/typec/altmodes/displayport.c           |   5 +-
 drivers/video/console/dummycon.c                   |  24 +-
 drivers/video/console/mdacon.c                     |  21 +-
 drivers/video/console/newport_con.c                |  12 +-
 drivers/video/console/sticon.c                     |  14 +-
 drivers/video/console/vgacon.c                     |  38 +--
 drivers/video/fbdev/core/fbcon.c                   | 336 ++++++++++-----------
 drivers/video/fbdev/core/fbcon.h                   |   4 +-
 drivers/video/fbdev/core/fbmem.c                   |  43 +--
 fs/btrfs/inode.c                                   |  19 +-
 fs/btrfs/tree-log.c                                |   4 +-
 fs/btrfs/volumes.c                                 |   6 +
 fs/ceph/file.c                                     |   2 +-
 fs/cifs/misc.c                                     |   8 +
 fs/f2fs/super.c                                    |  30 +-
 fs/jfs/jfs_dmap.c                                  |  41 +--
 fs/ksmbd/smb2pdu.c                                 |  53 ++--
 fs/namespace.c                                     |   8 +-
 fs/nfs/flexfilelayout/flexfilelayout.c             | 121 +++++---
 fs/nfs/inode.c                                     |  19 +-
 fs/nfs/nfs4proc.c                                  |  12 +-
 fs/nfs/pnfs.c                                      |   4 +-
 fs/overlayfs/util.c                                |   4 +-
 include/dt-bindings/clock/am4.h                    |   1 +
 include/linux/console.h                            |  13 +-
 include/linux/console_struct.h                     |   6 +-
 include/linux/cpu.h                                |   1 +
 include/linux/hyperv.h                             |   2 +
 include/linux/ipv6.h                               |   1 -
 include/linux/regulator/consumer.h                 |  31 ++
 include/linux/regulator/gpio-regulator.h           |   2 +
 include/linux/usb/typec_dp.h                       |   1 +
 include/uapi/linux/vm_sockets.h                    |   4 +
 kernel/rcu/tree.c                                  |   4 +
 lib/test_objagg.c                                  |   4 +-
 net/atm/clip.c                                     |  11 +-
 net/atm/resources.c                                |   3 +-
 net/bluetooth/l2cap_core.c                         |   9 +-
 net/core/selftests.c                               |   5 +-
 net/ipv6/ip6_output.c                              |   9 +-
 net/mac80211/rx.c                                  |   4 +
 net/mac80211/util.c                                |   2 +-
 net/rose/rose_route.c                              |  15 +-
 net/sched/sch_api.c                                |  19 +-
 net/unix/af_unix.c                                 |  18 +-
 net/vmw_vsock/vmci_transport.c                     |   4 +-
 sound/isa/sb/sb16_main.c                           |   7 +
 sound/pci/hda/hda_bind.c                           |   2 +-
 sound/pci/hda/hda_intel.c                          |   3 +
 sound/soc/codecs/wcd9335.c                         |  62 ++--
 sound/usb/quirks.c                                 |   2 +
 sound/usb/stream.c                                 |   2 +
 tools/lib/bpf/btf_dump.c                           |   3 +
 182 files changed, 1971 insertions(+), 847 deletions(-)



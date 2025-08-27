Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E496199230;
	Wed, 27 Aug 2025 07:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756280683; cv=none; b=dnvCkXj9Are3TmIH46uw3Pgbqen29e3hXkpiy5kRudlaYlD4IR+emCZ7AwNP401Fm62gtM2fIMpQjI9XJpHYk4jsMdumJjz2vI9gzJlH9+cQPtVJUPYe7RNXSFdEvwdNtzrXJ6cseGOc2xQ/Ch/y/tTjMhg+3roIb9jQA9G3Ikg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756280683; c=relaxed/simple;
	bh=e65lyQBSskTCc7Jw7cWPzOpfRn+xt1EApw302Nn7XgU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=VgnPd2tcis1ErhqMrufECW/7sNS3YPc3xLINGrgPdpGVNIltgIZQEaBfcj2XSXzq3rnvS57LdrBVWbj05Ij1BxR/tY1/8krY6Roc7/suDIKaYDwynpPM5F16H7z91y1RIreYjWM4hrILTXV3UZf5A1OVi7REM5kDh8DAEY3fJNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yMkxxeEB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yMkxxeEB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15006C4CEEB;
	Wed, 27 Aug 2025 07:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756280682;
	bh=e65lyQBSskTCc7Jw7cWPzOpfRn+xt1EApw302Nn7XgU=;
	h=From:To:Cc:Subject:Date:From;
	b=yMkxxeEBsHR6qCtOLYv1qzF6kXq25zXxyV+4n0a8vzPLFDYBiNcK5CNM3e34ULFV8
	 2b7UuYBdtzk6U62x1OIECPjSKWaWRY8rjFz+14vqpTPEL8Ok9OHehW3aoagFvSbHfk
	 OzYPyo+DuHyX+Ot18/wdWqrRH+ApwG5ppQXskYvo=
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
Subject: [PATCH 5.4 000/403] 5.4.297-rc2 review
Date: Wed, 27 Aug 2025 09:44:36 +0200
Message-ID: <20250827073826.377382421@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.297-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.297-rc2
X-KernelTest-Deadline: 2025-08-29T07:38+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.4.297 release.
There are 403 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 29 Aug 2025 07:37:48 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.297-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.297-rc2

Al Viro <viro@zeniv.linux.org.uk>
    alloc_fdtable(): change calling conventions.

Peter Oberparleiter <oberpar@linux.ibm.com>
    s390/hypfs: Enable limited access during lockdown

Peter Oberparleiter <oberpar@linux.ibm.com>
    s390/hypfs: Avoid unnecessary ioctl registration in debugfs

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Use correct sub-type for UAC3 feature unit validation

William Liu <will@willsroot.io>
    net/sched: Remove unnecessary WARNING condition for empty child qdisc in htb_activate

William Liu <will@willsroot.io>
    net/sched: Make cake_enqueue return NET_XMIT_CN when past buffer_limit

Jason Xing <kernelxing@tencent.com>
    ixgbe: xsk: resolve the negative overflow of budget in ixgbe_xmit_zc

Minhong He <heminhong@kylinos.cn>
    ipv6: sr: validate HMAC algorithm ID in seg6_hmac_info_add

Dan Carpenter <dan.carpenter@linaro.org>
    ALSA: usb-audio: Fix size validation in convert_chmap_v3()

Dan Carpenter <dan.carpenter@linaro.org>
    scsi: qla4xxx: Prevent a potential error pointer dereference

Weitao Wang <WeitaoWang-oc@zhaoxin.com>
    usb: xhci: Fix slot_id resource race conflict

Josef Bacik <josef@toxicpanda.com>
    nfs: fix UAF in direct writes

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix up commit deadlocks

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    cifs: Fix UAF in cifs_demultiplex_thread()

Dmitry Antipov <dmantipov@yandex.ru>
    Bluetooth: fix use-after-free in device_for_each_child()

Davide Caratti <dcaratti@redhat.com>
    act_mirred: use the backlog for nested calls to mirred ingress

Davide Caratti <dcaratti@redhat.com>
    net/sched: act_mirred: better wording on protection against excessive stack growth

wenxu <wenxu@ucloud.cn>
    net/sched: act_mirred: refactor the handle of xmit

Jiri Pirko <jiri@mellanox.com>
    selftests: forwarding: tc_actions.sh: add matchall mirror test

Vlad Buslov <vladbu@mellanox.com>
    net: sched: don't expose action qstats to skb_tc_reinsert()

Vlad Buslov <vladbu@mellanox.com>
    net: sched: extract qstats update code into functions

Vlad Buslov <vladbu@mellanox.com>
    net: sched: extract bstats update code into function

Vlad Buslov <vladbu@mellanox.com>
    net: sched: extract common action counters update code into function

Lorenzo Stoakes <lstoakes@gmail.com>
    mm: perform the mapping_map_writable() check after call_mmap()

Lorenzo Stoakes <lstoakes@gmail.com>
    mm: update memfd seal write check to include F_SEAL_WRITE

Lorenzo Stoakes <lstoakes@gmail.com>
    mm: drop the assumption that VM_SHARED always implies writable

Cong Wang <xiyou.wangcong@gmail.com>
    codel: remove sch->q.qlen check before qdisc_tree_reduce_backlog()

Cong Wang <xiyou.wangcong@gmail.com>
    sch_qfq: make qfq_qlen_notify() idempotent

Cong Wang <xiyou.wangcong@gmail.com>
    sch_hfsc: make hfsc_qlen_notify() idempotent

Cong Wang <xiyou.wangcong@gmail.com>
    sch_drr: make drr_qlen_notify() idempotent

Qu Wenruo <wqu@suse.com>
    btrfs: populate otime when logging an inode item

Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>
    media: venus: hfi: explicitly release IRQ during teardown

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid out-of-boundary access in dnode page

Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>
    media: venus: protect against spurious interrupts during probe

Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
    media: qcom: camss: cleanup media device allocated resource on error path

Ricardo Ribalda <ribalda@chromium.org>
    media: venus: vdec: Clamp param smaller than 1fps and bigger than 240.

Imre Deak <imre.deak@intel.com>
    drm/dp: Change AUX DPCD probe address from DPCD_REV to LANE0_1_STATUS

Uwe Kleine-König <u.kleine-koenig@baylibre.com>
    pwm: mediatek: Fix duty and period setting

Uwe Kleine-König <u.kleine-koenig@baylibre.com>
    pwm: mediatek: Handle hardware enable and clock enable separately

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: mediatek: Implement .apply() callback

Gui-Dong Han <hanguidong02@gmail.com>
    media: rainshadow-cec: fix TOCTOU race condition in rain_interrupt()

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: v4l2-ctrls: Don't reset handler's error in v4l2_ctrl_handler_free()

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: v4l2-ctrls: always copy the controls on completion

Damien Le Moal <dlemoal@kernel.org>
    ata: Fix SATA_MOBILE_LPM_POLICY description in Kconfig

Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
    soc: qcom: mdt_loader: Ensure we don't read past the ELF header

Meagan Lloyd <meaganlloyd@linux.microsoft.com>
    rtc: ds1307: handle oscillator stop flag (OSF) for ds1341

Johan Hovold <johan@kernel.org>
    usb: musb: omap2430: fix device leak at unbind

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix the setting of capabilities when automounting a new filesystem

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix up handling of outstanding layoutcommit in nfs_update_inode()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Fix nfs4_bitmap_copy_adjust()

Sebastian Reichel <sebastian.reichel@collabora.com>
    usb: typec: fusb302: cache PD RX state

Oliver Neukum <oneukum@suse.com>
    cdc-acm: fix race between initial clearing halt and open

Johan Hovold <johan@kernel.org>
    USB: cdc-acm: do not log successful probe on later errors

Breno Leitao <leitao@debian.org>
    mm/kmemleak: avoid deadlock by moving pr_warn() outside kmemleak_lock

He Zhe <zhe.he@windriver.com>
    mm/kmemleak: turn kmemleak_lock and object->lock to raw_spinlock_t

Geoffrey D. Bennett <g@b4.vu>
    ALSA: scarlett2: Add retry on -EPROTO from scarlett2_usb_tx()

Dave Hansen <dave.hansen@linux.intel.com>
    x86/fpu: Delay instruction pointer fixup until after warning

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    mm/hmm: move pmd_to_hmm_pfn_flags() to the respective #ifdeffery

Jeff Layton <jlayton@kernel.org>
    nfsd: handle get_client_locked() failure in nfsd4_setclientid_confirm()

Maulik Shah <maulik.shah@oss.qualcomm.com>
    pmdomain: governor: Consider CPU latency tolerance from pm_domain_cpu_gov

Steven Rostedt <rostedt@goodmis.org>
    tracing: Add down_write(trace_event_sem) when adding trace event

Mathias Nyman <mathias.nyman@linux.intel.com>
    usb: hub: Don't try to recover devices lost during warm reset.

Mathias Nyman <mathias.nyman@linux.intel.com>
    usb: hub: avoid warm port reset during USB3 disconnect

Yazen Ghannam <yazen.ghannam@amd.com>
    x86/mce/amd: Add default names for MCA banks and blocks

Zhang Lixu <lixu.zhang@intel.com>
    iio: hid-sensor-prox: Fix incorrect OFFSET calculation

Chao Yu <chao@kernel.org>
    f2fs: fix to do sanity check on ino and xnid

Harry Yoo <harry.yoo@oracle.com>
    mm/zsmalloc: do not pass __GFP_MOVABLE if CONFIG_COMPACTION=n

Miaohe Lin <linmiaohe@huawei.com>
    mm/zsmalloc.c: convert to use kmem_cache_zalloc in cache_alloc_zspage()

Lin.Cao <lincao12@amd.com>
    drm/sched: Remove optimization that causes hang when killing dependent jobs

Haoxiang Li <haoxiang_li2024@163.com>
    ice: Fix a null pointer dereference in ice_copy_and_init_pkg()

Ammar Faizi <ammarfaizi2@gnuweeb.org>
    net: usbnet: Fix the wrong netif_carrier_on() call

John Ernberg <john.ernberg@actia.se>
    net: usbnet: Avoid potential RCU stall on LINK_CHANGE event

Lukas Wunner <lukas@wunner.de>
    PCI/ACPI: Fix runtime PM ref imbalance on Hot-Plug Capable ports

Li Zhong <floridsleeves@gmail.com>
    ACPI: processor: idle: Check acpi_fetch_acpi_dev() return value

Ian Abbott <abbotti@mev.co.uk>
    comedi: Fail COMEDI_INSNLIST ioctl if n_insns is too large

Ian Abbott <abbotti@mev.co.uk>
    comedi: Fix initialization of data for instructions that write to subdevice

Nathan Chancellor <nathan@kernel.org>
    kbuild: Add KBUILD_CPPFLAGS to as-option invocation

Masahiro Yamada <masahiroy@kernel.org>
    kbuild: add $(CLANG_FLAGS) to KBUILD_CPPFLAGS

Nathan Chancellor <nathan@kernel.org>
    kbuild: Add CLANG_FLAGS to as-instr

Nathan Chancellor <nathan@kernel.org>
    mips: Include KBUILD_CPPFLAGS in CHECKFLAGS invocation

Nick Desaulniers <ndesaulniers@google.com>
    kbuild: Update assembler calls to use proper flags and language target

Nathan Chancellor <nathan@kernel.org>
    ARM: 9448/1: Use an absolute path to unified.h in KBUILD_AFLAGS

Kuen-Han Tsai <khtsai@google.com>
    usb: dwc3: Ignore late xferNotReady event to prevent halt timeout

Zenm Chen <zenmchen@gmail.com>
    USB: storage: Ignore driver CD mode for Realtek multi-mode Wi-Fi dongles

Thorsten Blum <thorsten.blum@linux.dev>
    usb: storage: realtek_cr: Use correct byte order for bcs->Residue

Mael GUERIN <mael.guerin@murena.io>
    USB: storage: Add unusual-devs entry for Novatek NTK96550-based camera

Miao Li <limiao@kylinos.cn>
    usb: quirks: Add DELAY_INIT quick for another SanDisk 3.2Gen1 Flash Drive

David Lechner <dlechner@baylibre.com>
    iio: proximity: isl29501: fix buffered read on big-endian systems

Steven Rostedt <rostedt@goodmis.org>
    ftrace: Also allocate and copy hash for reading of filter files

Xu Yilun <yilun.xu@linux.intel.com>
    fpga: zynq_fpga: Fix the wrong usage of dma_map_sgtable()

Al Viro <viro@zeniv.linux.org.uk>
    use uniform permission checks for all mount propagation changes

Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
    move_mount: allow to add a mount into an existing group

Ye Bin <yebin10@huawei.com>
    fs/buffer: fix use-after-free when call bh_read() helper

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Find first CRTC and its line time in dce110_fill_display_configs

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Fix fractional fb divider in set_pixel_clock_v3

Phillip Lougher <phillip@squashfs.org.uk>
    squashfs: fix memory leak in squashfs_fill_super

Jiayi Li <lijiayi@kylinos.cn>
    memstick: Fix deadlock by moving removing flag earlier

Vedang Nagar <quic_vnagar@quicinc.com>
    media: venus: Add a check for packet size after reading from shared memory

Zhang Shurong <zhang_shurong@foxmail.com>
    media: ov2659: Fix memory leaks in ov2659_probe()

Ludwig Disterhof <ludwig@disterhof.eu>
    media: usbtv: Lock resolution while streaming

Haoxiang Li <haoxiang_li2024@163.com>
    media: imx: fix a potential memory leak in imx_media_csc_scaler_device_init()

Dan Carpenter <dan.carpenter@linaro.org>
    media: gspca: Add bounds checking to firmware parser

Jon Hunter <jonathanh@nvidia.com>
    soc/tegra: pmc: Ensure power-domains are in a known state

Baokun Li <libaokun1@huawei.com>
    jbd2: prevent softlockup in jbd2_log_do_checkpoint()

Damien Le Moal <dlemoal@kernel.org>
    PCI: endpoint: Fix configfs group removal on driver teardown

Damien Le Moal <dlemoal@kernel.org>
    PCI: endpoint: Fix configfs group list head handling

Thomas Fourier <fourier.thomas@gmail.com>
    mtd: rawnand: fsmc: Add missing check after DMA map

Laurentiu Mihalcea <laurentiu.mihalcea@nxp.com>
    pwm: imx-tpm: Reset counter if CMOD is 0

Nathan Chancellor <nathan@kernel.org>
    wifi: brcmsmac: Remove const from tbl_ptr parameter in wlc_lcnphy_common_read_table()

Marek Szyprowski <m.szyprowski@samsung.com>
    zynq_fpga: use sgtable-based scatterlist wrappers

Damien Le Moal <dlemoal@kernel.org>
    ata: libata-scsi: Fix ata_to_sense_error() status handling

Ojaswin Mujoo <ojaswin@linux.ibm.com>
    ext4: fix reserved gdt blocks handling in fsmap

Ojaswin Mujoo <ojaswin@linux.ibm.com>
    ext4: fix fsmap end of range reporting with bigalloc

Andreas Dilger <adilger@dilger.ca>
    ext4: check fast symlink for ea_inode correctly

Helge Deller <deller@gmx.de>
    Revert "vgacon: Add check for vc_origin address range in vgacon_scroll()"

Myrrh Periwinkle <myrrhperiwinkle@qtmlabs.xyz>
    vt: defkeymap: Map keycodes above 127 to K_HOLE

Myrrh Periwinkle <myrrhperiwinkle@qtmlabs.xyz>
    vt: keyboard: Don't process Unicode characters in K_OFF mode

Johan Hovold <johan@kernel.org>
    usb: dwc3: meson-g12a: fix device leaks at unbind

Johan Hovold <johan@kernel.org>
    usb: gadget: udc: renesas_usb3: fix device leak at unbind

Nathan Chancellor <nathan@kernel.org>
    usb: atm: cxacru: Merge cxacru_upload_firmware() into cxacru_heavy_init()

Finn Thain <fthain@linux-m68k.org>
    m68k: Fix lost column on framebuffer debug console

Dan Carpenter <dan.carpenter@linaro.org>
    cpufreq: armada-8k: Fix off by one in armada_8k_cpufreq_free_table()

Yunhui Cui <cuiyunhui@bytedance.com>
    serial: 8250: fix panic due to PSLVERR

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Do not mark valid metadata as invalid

Youngjun Lee <yjjuny.lee@samsung.com>
    media: uvcvideo: Fix 1-byte out-of-bounds read in uvc_parse_format()

Waiman Long <longman@redhat.com>
    mm/kmemleak: avoid soft lockup in __kmemleak_do_cleanup()

Randy Dunlap <rdunlap@infradead.org>
    parisc: Makefile: fix a typo in palo.conf

Filipe Manana <fdmanana@suse.com>
    btrfs: fix log tree replay failure due to file with 0 links and extents

Eric Biggers <ebiggers@kernel.org>
    thunderbolt: Fix copy+paste error in match_service_id()

Ian Abbott <abbotti@mev.co.uk>
    comedi: fix race between polling and detaching

Ricky Wu <ricky_wu@realtek.com>
    misc: rtsx: usb: Ensure mmc child device is active when card is present

Jack Xiao <Jack.Xiao@amd.com>
    drm/amdgpu: fix incorrect vm flags to map bo

Jiasheng Jiang <jiashengjiangcool@gmail.com>
    scsi: lpfc: Remove redundant assignment to avoid memory leak

Meagan Lloyd <meaganlloyd@linux.microsoft.com>
    rtc: ds1307: remove clear of oscillator stop flag (OSF) in probe

Sergey Bashirov <sergeybashirov@gmail.com>
    pNFS: Fix uninited ptr deref in block/scsi layout

Sergey Bashirov <sergeybashirov@gmail.com>
    pNFS: Handle RPC size limit for layoutcommits

Sergey Bashirov <sergeybashirov@gmail.com>
    pNFS: Fix disk addr range check in block/scsi layout

Sergey Bashirov <sergeybashirov@gmail.com>
    pNFS: Fix stripe mapping in block/scsi layout

Buday Csaba <buday.csaba@prolan.hu>
    net: phy: smsc: add proper reset flags for LAN8710A

Corey Minyard <corey@minyard.net>
    ipmi: Fix strcpy source and destination the same

Yann E. MORIN <yann.morin.1998@free.fr>
    kconfig: lxdialog: fix 'space' to (de)select options

Masahiro Yamada <masahiroy@kernel.org>
    kconfig: gconf: fix potential memory leak in renderer_edited()

Masahiro Yamada <masahiroy@kernel.org>
    kconfig: gconf: avoid hardcoding model2 in on_treeview2_cursor_changed()

Breno Leitao <leitao@debian.org>
    ipmi: Use dev_warn_ratelimited() for incorrect message warnings

John Garry <john.g.garry@oracle.com>
    scsi: aacraid: Stop using PCI_IRQ_AFFINITY

Ranjan Kumar <ranjan.kumar@broadcom.com>
    scsi: Fix sas_user_scan() to handle wildcard and multi-channel scans

Shankari Anand <shankari.ak0208@gmail.com>
    kconfig: nconf: Ensure null termination where strncpy is used

Suchit Karunakaran <suchitkarunakaran@gmail.com>
    kconfig: lxdialog: replace strcpy() with strncpy() in inputbox.c

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i3c: don't fail if GETHDRCAP is unsupported

Timothy Pearson <tpearson@raptorengineering.com>
    PCI: pnv_php: Work around switches with broken presence detection

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i3c: add missing include to internal header

chenchangcheng <chenchangcheng@kylinos.cn>
    media: uvcvideo: Fix bandwidth issue for Alcor camera

Alex Guo <alexguo1023@gmail.com>
    media: dvb-frontends: w7090p: fix null-ptr-deref in w7090p_tuner_write_serpar and w7090p_tuner_read_serpar

Alex Guo <alexguo1023@gmail.com>
    media: dvb-frontends: dib7090p: fix null-ptr-deref in dib7090p_rw_on_apb()

Wolfram Sang <wsa+renesas@sang-engineering.com>
    media: usb: hdpvr: disable zero-length read messages

Dave Stevenson <dave.stevenson@raspberrypi.com>
    media: tc358743: Increase FIFO trigger level to 374

Dave Stevenson <dave.stevenson@raspberrypi.com>
    media: tc358743: Return an appropriate colorspace from tc358743_set_fmt

Dave Stevenson <dave.stevenson@raspberrypi.com>
    media: tc358743: Check I2C succeeded during probe

Cheick Traore <cheick.traore@foss.st.com>
    pinctrl: stm32: Manage irq affinity settings

Damien Le Moal <dlemoal@kernel.org>
    scsi: mpt3sas: Correctly handle ATA device errors

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Check for hdwq null ptr when cleaning up lpfc_vport structure

Yury Norov [NVIDIA] <yury.norov@gmail.com>
    RDMA: hfi1: fix possible divide-by-zero in find_hw_thread_mask()

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    MIPS: Don't crash in stack_top() for tasks without ABI or vDSO

Arnaud Lecomte <contact@arnaud-lcm.com>
    jfs: upper bound check of tree index in dbAllocAG

Edward Adam Davis <eadavis@qq.com>
    jfs: Regular file corruption check

Lizhi Xu <lizhi.xu@windriver.com>
    jfs: truncate good inode pages when hard link is 0

jackysliu <1972843537@qq.com>
    scsi: bfa: Double-free fix

Shiji Yang <yangshiji66@outlook.com>
    MIPS: vpe-mt: add missing prototypes for vpe_{alloc,start,stop,free}

Sebastian Reichel <sebastian.reichel@collabora.com>
    watchdog: dw_wdt: Fix default timeout

Amir Mohammad Jahangirzad <a.jahangirzad@gmail.com>
    fs/orangefs: use snprintf() instead of sprintf()

Showrya M N <showrya@chelsio.com>
    scsi: libiscsi: Initialize iscsi_conn->dd_data only if memory is allocated

Theodore Ts'o <tytso@mit.edu>
    ext4: do not BUG when INLINE_DATA_FL lacks system.data xattr

Pali Rohár <pali@kernel.org>
    cifs: Fix calling CIFSFindFirst() for root path without msearch

Jason Wang <jasowang@redhat.com>
    vhost: fail early when __vhost_add_used() fails

Álvaro Fernández Rojas <noltari@gmail.com>
    net: dsa: b53: fix IP_MULTICAST_CTRL on BCM5325

Jakub Kicinski <kuba@kernel.org>
    uapi: in6: restore visibility of most IPv6 socket options

Hari Kalavakunta <kalavakunta.hari.prasad@gmail.com>
    net: ncsi: Fix buffer overflow in fetching version id

Álvaro Fernández Rojas <noltari@gmail.com>
    net: dsa: b53: prevent SWITCH_CTRL access on BCM5325

Álvaro Fernández Rojas <noltari@gmail.com>
    net: dsa: b53: fix b53_imp_vlan_setup for BCM5325

Gal Pressman <gal@nvidia.com>
    net: vlan: Replace BUG() with WARN_ON_ONCE() in vlan_dev_* stubs

Stanislaw Gruszka <stf_xl@wp.pl>
    wifi: iwlegacy: Check rate_idx range after addition

Mina Almasry <almasrymina@google.com>
    netmem: fix skb_frag_address_safe with unreadable skbs

Thomas Fourier <fourier.thomas@gmail.com>
    wifi: rtlwifi: fix possible skb memory leak in `_rtl_pci_rx_interrupt()`.

Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
    wifi: iwlwifi: fw: Fix possible memory leak in iwl_fw_dbg_collect

Rand Deeb <rand.sec96@gmail.com>
    wifi: iwlwifi: dvm: fix potential overflow in rs_fill_link_cmd()

Jonas Rebmann <jre@pengutronix.de>
    net: fec: allow disable coalescing

Thomas Fourier <fourier.thomas@gmail.com>
    (powerpc/512) Fix possible `dma_unmap_single()` on uninitialized pointer

Sven Schnelle <svens@linux.ibm.com>
    s390/stp: Remove udelay from stp_sync_clock()

Avraham Stern <avraham.stern@intel.com>
    wifi: iwlwifi: mvm: fix scan request validation

Alok Tiwari <alok.a.tiwari@oracle.com>
    net: thunderx: Fix format-truncation warning in bgx_acpi_match_id()

Oscar Maes <oscmaes92@gmail.com>
    net: ipv4: fix incorrect MTU in broadcast routes

Ilan Peer <ilan.peer@intel.com>
    wifi: cfg80211: Fix interface type validation

Paul E. McKenney <paulmck@kernel.org>
    rcu: Protect ->defer_qs_iw_pending from data race

Thomas Fourier <fourier.thomas@gmail.com>
    net: ag71xx: Add missing check after DMA map

Thomas Fourier <fourier.thomas@gmail.com>
    et131x: Add missing check after DMA map

Alok Tiwari <alok.a.tiwari@oracle.com>
    be2net: Use correct byte order and format string for TCP seq and ack_seq

Sven Schnelle <svens@linux.ibm.com>
    s390/time: Use monotonic clock in get_cycles()

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211: reject HTC bit for management frames

Steven Rostedt <rostedt@goodmis.org>
    ktest.pl: Prevent recursion of default variable options

Xinxin Wan <xinxin.wan@intel.com>
    ASoC: codecs: rt5640: Retry DEVICE_ID verification

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    ALSA: usb-audio: Avoid precedence issues in mixer_quirks macros

Lucy Thrun <lucy.thrun@digital-rabbithole.de>
    ALSA: hda/ca0132: Fix buffer overflow in add_tuning_control

Kees Cook <kees@kernel.org>
    platform/x86: thinkpad_acpi: Handle KCOV __init vs inline mismatches

Gautham R. Shenoy <gautham.shenoy@amd.com>
    pm: cpupower: Fix the snapshot-order of tsc,mperf, clock in mperf_stop()

Oliver Neukum <oneukum@suse.com>
    usb: core: usb_submit_urb: downgrade type check

Alok Tiwari <alok.a.tiwari@oracle.com>
    ALSA: intel8x0: Fix incorrect codec index usage in mixer for ICH4

Mark Brown <broonie@kernel.org>
    ASoC: hdac_hdmi: Rate limit logging on connection and disconnection

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: rtsx_usb_sdmmc: Fix error-path in sd_set_power_mode()

Breno Leitao <leitao@debian.org>
    ACPI: APEI: GHES: add TAINT_MACHINE_CHECK on GHES panic path

Sebastian Ott <sebott@redhat.com>
    ACPI: processor: fix acpi_object initialization

tuhaowen <tuhaowen@uniontech.com>
    PM: sleep: console: Fix the black screen issue

Hsin-Te Yuan <yuanhsinte@chromium.org>
    thermal: sysfs: Return ENODATA instead of EAGAIN for reads

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: runtime: Clear power.needs_force_resume in pm_runtime_reinit()

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    selftests: tracing: Use mutex_unlock for testing glob filter

Aaron Kling <webgeek1234@gmail.com>
    ARM: tegra: Use I/O memcpy to write to IRAM

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    gpio: tps65912: check the return value of regmap_update_bits()

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: soc-dapm: set bias_level if snd_soc_dapm_set_bias_level() was successed

Alexander Kochetkov <al.kochet@gmail.com>
    ARM: rockchip: fix kernel hang during smp initialization

Lifeng Zheng <zhenglifeng1@huawei.com>
    cpufreq: Exit governor when failed to start old governor

Mario Limonciello <mario.limonciello@amd.com>
    usb: xhci: Avoid showing errors during surprise removal

Jay Chen <shawn2000100@gmail.com>
    usb: xhci: Set avg_trb_len = 8 for EP0 during Address Device Command

Mario Limonciello <mario.limonciello@amd.com>
    usb: xhci: Avoid showing warnings for dying controller

Cynthia Huang <cynthia@andestech.com>
    selftests/futex: Define SYS_futex on 32-bit architectures with 64-bit time_t

Su Hui <suhui@nfschina.com>
    usb: xhci: print xhci->xhc_state when queue_command failed

Al Viro <viro@zeniv.linux.org.uk>
    securityfs: don't pin dentries twice, once is enough...

Viacheslav Dubeyko <slava@dubeyko.com>
    hfs: fix not erasing deleted b-tree node issue

Sarah Newman <srn@prgmr.com>
    drbd: add missing kref_get in handle_write_conflicts

Jan Kara <jack@suse.cz>
    udf: Verify partition map count

Kees Cook <kees@kernel.org>
    arm64: Handle KCOV __init vs inline mismatches

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    hfsplus: don't use BUG_ON() in hfsplus_create_attributes_file()

Viacheslav Dubeyko <slava@dubeyko.com>
    hfsplus: fix slab-out-of-bounds read in hfsplus_uni2asc()

Viacheslav Dubeyko <slava@dubeyko.com>
    hfsplus: fix slab-out-of-bounds in hfsplus_bnode_read()

Viacheslav Dubeyko <slava@dubeyko.com>
    hfs: fix slab-out-of-bounds in hfs_bnode_read()

Xin Long <lucien.xin@gmail.com>
    sctp: linearize cloned gso packets in sctp_rcv

Florian Westphal <fw@strlen.de>
    netfilter: ctnetlink: fix refcount leak on table dump

Sabrina Dubroca <sd@queasysnail.net>
    udp: also consider secpath when evaluating ipsec use for checksumming

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: processor: perflib: Move problematic pr->performance check

Jiayi Li <lijiayi@kylinos.cn>
    ACPI: processor: perflib: Fix initial _PPC limit application

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    Documentation: ACPI: Fix parent device references

Sasha Levin <sashal@kernel.org>
    fs: Prevent file descriptor table allocations exceeding INT_MAX

Ma Ke <make24@iscas.ac.cn>
    sunvdc: Balance device refcount in vdc_port_mpgroup_check

Dai Ngo <dai.ngo@oracle.com>
    NFSD: detect mismatch of file handle and delegation stateid in OPEN op

Johan Hovold <johan@kernel.org>
    net: dpaa: fix device leak when querying time stamp info

Johan Hovold <johan@kernel.org>
    net: gianfar: fix device leak when querying time stamp info

Fedor Pchelkin <pchelkin@ispras.ru>
    netlink: avoid infinite retry looping in netlink_unicast()

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Validate UAC3 cluster segment descriptors

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Validate UAC3 power domain descriptors, too

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: don't use int for ABI

Tao Xue <xuetao09@huawei.com>
    usb: gadget : fix use-after-free in composite_dev_cleanup()

Jiaxun Yang <jiaxun.yang@flygoat.com>
    MIPS: mm: tlb-r4k: Uniquify TLB entries on init

Slark Xiao <slark_xiao@163.com>
    USB: serial: option: add Foxconn T99W709

Budimir Markovic <markovicbudimir@gmail.com>
    vsock: Do not allow binding to VMADDR_PORT_ANY

Quang Le <quanglex97@gmail.com>
    net/packet: fix a race in packet_set_ring() and packet_notifier()

Thomas Gleixner <tglx@linutronix.de>
    perf/core: Prevent VMA split of buffer mappings

Thomas Gleixner <tglx@linutronix.de>
    perf/core: Exit early on perf_mmap() fail

Thomas Gleixner <tglx@linutronix.de>
    perf/core: Don't leak AUX buffer refcount on allocation failure

Eric Dumazet <edumazet@google.com>
    pptp: fix pptp_xmit() error path

Stefan Metzmacher <metze@samba.org>
    smb: client: let recv_done() cleanup before notifying the callers.

Michal Schmidt <mschmidt@redhat.com>
    benet: fix BUG when creating VFs

Wang Liang <wangliang74@huawei.com>
    net: drop UFO packets in udp_rcv_segment()

Eric Dumazet <edumazet@google.com>
    ipv6: reject malicious packets in ipv6_gso_segment()

Eric Dumazet <edumazet@google.com>
    pptp: ensure minimal skb length in pptp_xmit()

Jakub Kicinski <kuba@kernel.org>
    netpoll: prevent hanging NAPI when netcons gets enabled

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix filehandle bounds checking in nfs_fh_to_dentry()

Frederic Barrat <fbarrat@linux.ibm.com>
    pci/hotplug/pnv-php: Wrap warnings in macro

Frederic Barrat <fbarrat@linux.ibm.com>
    pci/hotplug/pnv-php: Improve error msg on power state change failure

Peter Chen <peter.chen@nxp.com>
    usb: chipidea: udc: fix sleeping function called from invalid context

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid out-of-boundary access in devs.path

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid panic in f2fs_evict_inode

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid UAF in f2fs_sync_inode_meta()

Brian Masney <bmasney@redhat.com>
    rtc: pcf8563: fix incorrect maximum clock rate handling

Brian Masney <bmasney@redhat.com>
    rtc: hym8563: fix incorrect maximum clock rate handling

Brian Masney <bmasney@redhat.com>
    rtc: ds1307: fix incorrect maximum clock rate handling

Petr Pavlu <petr.pavlu@suse.com>
    module: Restore the moduleparam prefix length check

Paul Chaignon <paul.chaignon@gmail.com>
    bpf: Check flow_dissector ctx accesses are aligned

Balamanikandan Gunasundar <balamanikandan.gunasundar@microchip.com>
    mtd: rawnand: atmel: set pmecc data setup time

Thomas Fourier <fourier.thomas@gmail.com>
    mtd: rawnand: atmel: Fix dma_mapping_error() address

Zheng Yu <zheng.yu@northwestern.edu>
    jfs: fix metapage reference count leak in dbAllocCtl

Chenyuan Yang <chenyuan0y@gmail.com>
    fbdev: imxfb: Check fb_add_videomode to prevent null-ptr-deref

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - fix seq_file position update in adf_ring_next()

Thomas Fourier <fourier.thomas@gmail.com>
    dmaengine: nbpfaxi: Add missing check after DMA map

Thomas Fourier <fourier.thomas@gmail.com>
    dmaengine: mv_xor: Fix missing check after DMA map and missing unmap

Dan Carpenter <dan.carpenter@linaro.org>
    fs/orangefs: Allow 2 more characters in do_c_string()

Bard Liao <yung-chuan.liao@linux.intel.com>
    soundwire: stream: restore params when prepare ports fail

Thomas Fourier <fourier.thomas@gmail.com>
    crypto: img-hash - Fix dma_unmap_sg() nents value

Ovidiu Panait <ovidiu.panait.oss@gmail.com>
    hwrng: mtk - handle devm_pm_runtime_enable errors

Dan Carpenter <dan.carpenter@linaro.org>
    watchdog: ziirave_wdt: check record length in ziirave_firm_verify()

Thomas Fourier <fourier.thomas@gmail.com>
    scsi: isci: Fix dma_unmap_sg() nents value

Thomas Fourier <fourier.thomas@gmail.com>
    scsi: mvsas: Fix dma_unmap_sg() nents value

Thomas Fourier <fourier.thomas@gmail.com>
    scsi: ibmvscsi_tgt: Fix dma_unmap_sg() nents value

Paul Kocialkowski <paulk@sys-base.io>
    clk: sunxi-ng: v3s: Fix de clock definition

Leo Yan <leo.yan@arm.com>
    perf tests bp_account: Fix leaked file descriptor

Mengbiao Xiong <xisme1998@gmail.com>
    crypto: ccp - Fix crash when rebind ccp device for ccp.ko

Yuan Chen <chenyuan@kylinos.cn>
    pinctrl: sunxi: Fix memory leak on krealloc failure

Charles Han <hanchunchao@inspur.com>
    power: supply: max14577: Handle NULL pdata when CONFIG_OF is not set

Henry Martin <bsdhenrymartin@gmail.com>
    clk: davinci: Add NULL check in davinci_lpsc_clk_register()

Ivan Stepchenko <sid@itb.spb.ru>
    mtd: fix possible integer overflow in erase_xfer()

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: marvell/cesa - Fix engine load inaccuracy

Hans Zhang <18255117159@163.com>
    PCI: rockchip-host: Fix "Unexpected Completion" log message

Stanislav Fomichev <sdf@fomichev.me>
    vrf: Drop existing dst reference in vrf_ip6_input_dst

Xiumei Mu <xmu@redhat.com>
    selftests: rtnetlink.sh: remove esp4_offload after test

Florian Westphal <fw@strlen.de>
    netfilter: xt_nfacct: don't assume acct name is null-terminated

Jimmy Assarsson <extja@kvaser.com>
    can: kvaser_usb: Assign netdev.dev_port based on device channel index

Jimmy Assarsson <extja@kvaser.com>
    can: kvaser_pciefd: Store device channel index

Gokul Sivakumar <gokulkumar.sivakumar@infineon.com>
    wifi: brcmfmac: fix P2P discovery failure in P2P peer due to missing P2P IE

Remi Pommarel <repk@triplefau.lt>
    Reapply "wifi: mac80211: Update skb's control block key in ieee80211_tx_dequeue()"

Thomas Fourier <fourier.thomas@gmail.com>
    mwl8k: Add missing check after DMA map

Martin Kaistra <martin.kaistra@linutronix.de>
    wifi: rtl8xxxu: Fix RX skb size for aggregation disabled

William Liu <will@willsroot.io>
    net/sched: Restrict conditions for adding duplicating netems to qdisc tree

Johan Korsnes <johan.korsnes@gmail.com>
    arch: powerpc: defconfig: Drop obsolete CONFIG_NET_CLS_TCINDEX

Fedor Pchelkin <pchelkin@ispras.ru>
    netfilter: nf_tables: adjust lockdep assertions handling

Fedor Pchelkin <pchelkin@ispras.ru>
    drm/amd/pm/powerplay/hwmgr/smu_helper: fix order of mask and value

Finn Thain <fthain@linux-m68k.org>
    m68k: Don't unregister boot console needlessly

xin.guo <guoxin0309@gmail.com>
    tcp: fix tcp_ofo_queue() to avoid including too much DUP SACK range

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    iwlwifi: Add missing check for alloc_ordered_workqueue

Xiu Jianfeng <xiujianfeng@huawei.com>
    wifi: iwlwifi: Fix memory leak in iwl_mvm_init()

Daniil Dulov <d.dulov@aladdin.ru>
    wifi: rtl818x: Kill URBs before clearing tx status queue

Arnd Bergmann <arnd@arndb.de>
    caif: reduce stack size, again

Yuan Chen <chenyuan@kylinos.cn>
    bpftool: Fix memory leak in dump_xx_nlmsg on realloc failure

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf, ktls: Fix data corruption when using bpf_msg_pop_data() in ktls

Alok Tiwari <alok.a.tiwari@oracle.com>
    staging: nvec: Fix incorrect null termination of battery manufacturer

Brahmajit Das <listout@listout.xyz>
    samples: mei: Fix building on musl libc

Lifeng Zheng <zhenglifeng1@huawei.com>
    cpufreq: Init policy->rwsem before it may be possibly used

Annette Kobou <annette.kobou@kontron.de>
    ARM: dts: imx6ul-kontron-bl-common: Fix RTS polarity for RS485 interface

Lucas De Marchi <lucas.demarchi@intel.com>
    usb: early: xhci-dbc: Fix early_ioremap leak

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "vmci: Prevent the dispatching of uninitialized payloads"

Denis OSTERLAND-HEIM <denis.osterland@diehl.com>
    pps: fix poll support

Lizhi Xu <lizhi.xu@windriver.com>
    vmci: Prevent the dispatching of uninitialized payloads

Abdun Nihaal <abdun.nihaal@gmail.com>
    staging: fbtft: fix potential memory leak in fbtft_framebuffer_alloc()

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: vfxxx: Correctly use two tuples for timer address

Arnd Bergmann <arnd@arndb.de>
    ASoC: ops: dynamically allocate struct snd_ctl_elem_value

Yangtao Li <frank.li@vivo.com>
    hfsplus: remove mutex_lock check in hfsplus_free_extents

Arnd Bergmann <arnd@arndb.de>
    ASoC: Intel: fix SND_SOC_SOF dependencies

Arnd Bergmann <arnd@arndb.de>
    ethernet: intel: fix building with large NR_CPUS

Xu Yang <xu.yang_2@nxp.com>
    usb: phy: mxs: disconnect line when USB charger is attached

Xu Yang <xu.yang_2@nxp.com>
    usb: chipidea: add USB PHY event

Peter Chen <peter.chen@nxp.com>
    usb: chipidea: introduce CI_HDRC_CONTROLLER_VBUS_EVENT glue layer use

Jun Li <jun.li@nxp.com>
    usb: chipidea: udc: protect usb interrupt enable

Peter Chen <peter.chen@nxp.com>
    usb: chipidea: udc: add new API ci_hdrc_gadget_connect

Daniel Dadap <ddadap@nvidia.com>
    ALSA: hda: Add missing NVIDIA HDA codec IDs

Ian Abbott <abbotti@mev.co.uk>
    comedi: comedi_test: Fix possible deletion of uninitialized timers

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: reject invalid file types when reading inodes

Yang Xiwen <forbidden405@outlook.com>
    i2c: qup: jump out of the loop in case of timeout

Xiang Mei <xmei5@asu.edu>
    net/sched: sch_qfq: Avoid triggering might_sleep in atomic context in qfq_delete_class

Kito Xu (veritas501) <hxzene@gmail.com>
    net: appletalk: Fix use-after-free in AARP proxy probe

Andrew Lunn <andrew@lunn.ch>
    net: appletalk: fix kerneldoc warnings

Maor Gottlieb <maorg@nvidia.com>
    RDMA/core: Rate limit GID cache warning messages

Alessandro Carminati <acarmina@redhat.com>
    regulator: core: fix NULL dereference on unbind due to stale coupling data

Mathias Nyman <mathias.nyman@linux.intel.com>
    usb: hub: Fix flushing and scheduling of delayed work that tunes runtime pm

Mathias Nyman <mathias.nyman@linux.intel.com>
    usb: hub: fix detection of high tier USB3 devices behind suspended hubs

Eric Dumazet <edumazet@google.com>
    net_sched: sch_sfq: reject invalid perturb period

Octavian Purdila <tavip@google.com>
    net_sched: sch_sfq: move the limit validation

Octavian Purdila <tavip@google.com>
    net_sched: sch_sfq: use a temporary work area for validating configuration

Octavian Purdila <tavip@google.com>
    net_sched: sch_sfq: don't allow 1 packet limit

Eric Dumazet <edumazet@google.com>
    net_sched: sch_sfq: handle bigger packets

Eric Dumazet <edumazet@google.com>
    net_sched: sch_sfq: annotate data-races around q->perturb_period

Zheng Wang <zyytlz.wz@163.com>
    power: supply: bq24190: Fix use after free bug in bq24190_remove due to race condition

Minghao Chi <chi.minghao@zte.com.cn>
    power: supply: bq24190_charger: using pm_runtime_resume_and_get instead of pm_runtime_get_sync

Dinghao Liu <dinghao.liu@zju.edu.cn>
    power: supply: bq24190_charger: Fix runtime PM imbalance on error

Hongyu Xie <xiehongyu1@kylinos.cn>
    xhci: Disable stream for xHC controller with XHCI_BROKEN_STREAMS

Bui Quang Minh <minhquangbui99@gmail.com>
    virtio-net: ensure the received length does not exceed allocated size

Arun Raghavan <arun@asymptotic.io>
    ASoC: fsl_sai: Force a software reset when starting in consumer mode

Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>
    usb: dwc3: qcom: Don't leave BCR asserted

Drew Hamilton <drew.hamilton@zetier.com>
    usb: musb: fix gadget state on disconnect

William Liu <will@willsroot.io>
    net/sched: Return NULL when htb_lookup_leaf encounters an empty rbtree

Dong Chenchen <dongchenchen2@huawei.com>
    net: vlan: fix VLAN 0 refcount imbalance of toggling filtering during runtime

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix attempting to adjust outgoing MTU

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: SMP: Fix using HCI_ERROR_REMOTE_USER_TERM on timeout

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: SMP: If an unallowed command is received consider it a failure

Kuniyuki Iwashima <kuniyu@google.com>
    Bluetooth: Fix null-ptr-deref in l2cap_sock_resume_cb()

Oliver Neukum <oneukum@suse.com>
    usb: net: sierra: check for no status endpoint

Xiang Mei <xmei5@asu.edu>
    net/sched: sch_qfq: Fix race condition on qfq_aggregate

Alok Tiwari <alok.a.tiwari@oracle.com>
    net: emaclite: Fix missing pointer increment in aligned_read()

Ian Abbott <abbotti@mev.co.uk>
    comedi: Fix use of uninitialized data in insn_rw_emulate_bits()

Ian Abbott <abbotti@mev.co.uk>
    comedi: Fix some signed shift left operations

Ian Abbott <abbotti@mev.co.uk>
    comedi: das6402: Fix bit shift out of bounds

Ian Abbott <abbotti@mev.co.uk>
    comedi: das16m1: Fix bit shift out of bounds

Ian Abbott <abbotti@mev.co.uk>
    comedi: aio_iiro_16: Fix bit shift out of bounds

Ian Abbott <abbotti@mev.co.uk>
    comedi: pcl812: Fix bit shift out of bounds

Chen Ni <nichen@iscas.ac.cn>
    iio: adc: stm32-adc: Fix race in installing chained IRQ handler

Fabio Estevam <festevam@denx.de>
    iio: adc: max1363: Reorder mode_list[] entries

Fabio Estevam <festevam@denx.de>
    iio: adc: max1363: Fix MAX1363_4X_CHANS/MAX1363_8X_CHANS[]

Andrew Jeffery <andrew@codeconstruct.com.au>
    soc: aspeed: lpc-snoop: Don't disable channels that aren't enabled

Andrew Jeffery <andrew@codeconstruct.com.au>
    soc: aspeed: lpc-snoop: Cleanup resources in stack-order

Judith Mendez <jm@ti.com>
    mmc: sdhci_am654: Workaround for Errata i2312

Edson Juliano Drosdeck <edson.drosdeck@gmail.com>
    mmc: sdhci-pci: Quirk for broken command queuing on Intel GLK-based Positivo models

Thomas Fourier <fourier.thomas@gmail.com>
    mmc: bcm2835: Fix dma_unmap_sg() nents value

Nathan Chancellor <nathan@kernel.org>
    memstick: core: Zero initialize id_reg in h_memstick_read_dev_id()

Jan Kara <jack@suse.cz>
    isofs: Verify inode mode when loading from disk

Dan Carpenter <dan.carpenter@linaro.org>
    dmaengine: nbpfaxi: Fix memory corruption in probe()

Yun Lu <luyun@kylinos.cn>
    af_packet: fix soft lockup issue caused by tpacket_snd()

Yun Lu <luyun@kylinos.cn>
    af_packet: fix the SO_SNDTIMEO constraint not effective on tpacked_snd()

Nathan Chancellor <nathan@kernel.org>
    phonet/pep: Move call to pn_skb_get_dst_sockaddr() earlier in pep_sock_accept()

Benjamin Tissoires <bentiss@kernel.org>
    HID: core: do not bypass hid_hw_raw_request

Benjamin Tissoires <bentiss@kernel.org>
    HID: core: ensure __hid_request reserves the report ID as the first byte

Benjamin Tissoires <bentiss@kernel.org>
    HID: core: ensure the allocated report buffer can contain the reserved report ID

Thomas Fourier <fourier.thomas@gmail.com>
    pch_uart: Fix dma_sync_sg_for_device() nents value

Nilton Perim Neto <niltonperimneto@gmail.com>
    Input: xpad - set correct controller type for Acer NGR200

Clément Le Goffic <clement.legoffic@foss.st.com>
    i2c: stm32: fix the device used for the DMA map

Xinyu Liu <1171169449@qq.com>
    usb: gadget: configfs: Fix OOB read on empty string write

Ryan Mann (NDI) <rmann@ndigital.com>
    USB: serial: ftdi_sio: add support for NDI EMGUIDE GEMINI

Slark Xiao <slark_xiao@163.com>
    USB: serial: option: add Foxconn T99W640

Fabio Porcedda <fabio.porcedda@gmail.com>
    USB: serial: option: add Telit Cinterion FE910C04 (ECM) composition


-------------

Diffstat:

 Documentation/firmware-guide/acpi/i2c-muxes.rst    |   8 +-
 Makefile                                           |   7 +-
 arch/arm/Makefile                                  |   2 +-
 arch/arm/boot/dts/imx6ul-kontron-n6310-s.dts       |   1 -
 arch/arm/boot/dts/vfxxx.dtsi                       |   2 +-
 arch/arm/mach-rockchip/platsmp.c                   |  15 +-
 arch/arm/mach-tegra/reset.c                        |   2 +-
 arch/arm64/include/asm/acpi.h                      |   2 +-
 arch/m68k/Kconfig.debug                            |   2 +-
 arch/m68k/kernel/early_printk.c                    |  42 +--
 arch/m68k/kernel/head.S                            |  39 ++-
 arch/mips/Makefile                                 |   2 +-
 arch/mips/include/asm/vpe.h                        |   8 +
 arch/mips/kernel/process.c                         |  16 +-
 arch/mips/mm/tlb-r4k.c                             |  56 +++-
 arch/parisc/Makefile                               |   2 +-
 arch/powerpc/configs/ppc6xx_defconfig              |   1 -
 arch/powerpc/platforms/512x/mpc512x_lpbfifo.c      |   6 +-
 arch/s390/hypfs/hypfs_dbfs.c                       |  19 +-
 arch/s390/include/asm/timex.h                      |  13 +-
 arch/s390/kernel/time.c                            |   2 +-
 arch/x86/kernel/cpu/mce/amd.c                      |  13 +-
 arch/x86/mm/extable.c                              |   5 +-
 drivers/acpi/acpi_processor.c                      |   2 +-
 drivers/acpi/apei/ghes.c                           |   2 +
 drivers/acpi/processor_idle.c                      |   4 +-
 drivers/acpi/processor_perflib.c                   |  11 +
 drivers/ata/Kconfig                                |  35 ++-
 drivers/ata/libata-scsi.c                          |  20 +-
 drivers/base/power/domain_governor.c               |  18 +-
 drivers/base/power/runtime.c                       |   5 +
 drivers/block/drbd/drbd_receiver.c                 |   6 +-
 drivers/block/sunvdc.c                             |   4 +-
 drivers/char/hw_random/mtk-rng.c                   |   4 +-
 drivers/char/ipmi/ipmi_msghandler.c                |   8 +-
 drivers/char/ipmi/ipmi_watchdog.c                  |  59 +++--
 drivers/clk/davinci/psc.c                          |   5 +
 drivers/clk/sunxi-ng/ccu-sun8i-v3s.c               |   3 +-
 drivers/cpufreq/armada-8k-cpufreq.c                |   2 +-
 drivers/cpufreq/cpufreq.c                          |  11 +-
 drivers/crypto/ccp/ccp-debugfs.c                   |   3 +
 drivers/crypto/img-hash.c                          |   2 +-
 drivers/crypto/marvell/cipher.c                    |   4 +-
 drivers/crypto/marvell/hash.c                      |   5 +-
 .../crypto/qat/qat_common/adf_transport_debug.c    |   4 +-
 drivers/dma/mv_xor.c                               |  21 +-
 drivers/dma/nbpfaxi.c                              |  24 +-
 drivers/fpga/zynq-fpga.c                           |  10 +-
 drivers/gpio/gpio-tps65912.c                       |   7 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_csa.c            |   4 +-
 .../gpu/drm/amd/display/dc/bios/command_table.c    |   2 +-
 .../amd/display/dc/clk_mgr/dce110/dce110_clk_mgr.c |  30 ++-
 drivers/gpu/drm/amd/powerplay/hwmgr/smu_helper.c   |   2 +-
 drivers/gpu/drm/drm_dp_helper.c                    |   2 +-
 drivers/gpu/drm/scheduler/sched_entity.c           |  23 +-
 drivers/hid/hid-core.c                             |  21 +-
 drivers/i2c/busses/i2c-qup.c                       |   4 +-
 drivers/i2c/busses/i2c-stm32.c                     |   8 +-
 drivers/i2c/busses/i2c-stm32f7.c                   |   4 +-
 drivers/i3c/internals.h                            |   1 +
 drivers/i3c/master.c                               |   2 +-
 drivers/iio/adc/max1363.c                          |  43 ++-
 drivers/iio/adc/stm32-adc-core.c                   |   7 +-
 drivers/iio/light/hid-sensor-prox.c                |   3 +-
 drivers/iio/proximity/isl29501.c                   |  14 +-
 drivers/infiniband/core/cache.c                    |   4 +-
 drivers/infiniband/hw/hfi1/affinity.c              |  44 +--
 drivers/input/joystick/xpad.c                      |   2 +-
 drivers/media/dvb-frontends/dib7000p.c             |   8 +
 drivers/media/i2c/ov2659.c                         |   3 +-
 drivers/media/i2c/tc358743.c                       |  86 +++---
 drivers/media/platform/qcom/camss/camss.c          |   4 +-
 drivers/media/platform/qcom/venus/core.c           |   8 +-
 drivers/media/platform/qcom/venus/core.h           |   2 +
 drivers/media/platform/qcom/venus/hfi_venus.c      |   5 +
 drivers/media/platform/qcom/venus/vdec.c           |   5 +-
 drivers/media/usb/gspca/vicam.c                    |  10 +-
 drivers/media/usb/hdpvr/hdpvr-i2c.c                |   6 +
 drivers/media/usb/rainshadow-cec/rainshadow-cec.c  |   3 +-
 drivers/media/usb/usbtv/usbtv-video.c              |   4 +
 drivers/media/usb/uvc/uvc_driver.c                 |   3 +
 drivers/media/usb/uvc/uvc_video.c                  |  21 +-
 drivers/media/v4l2-core/v4l2-ctrls.c               |  37 ++-
 drivers/memstick/core/memstick.c                   |   3 +-
 drivers/memstick/host/rtsx_usb_ms.c                |   1 +
 drivers/misc/cardreader/rtsx_usb.c                 |  16 +-
 drivers/mmc/host/bcm2835.c                         |   3 +-
 drivers/mmc/host/rtsx_usb_sdmmc.c                  |   4 +-
 drivers/mmc/host/sdhci-pci-core.c                  |   3 +-
 drivers/mmc/host/sdhci_am654.c                     |   9 +-
 drivers/mtd/ftl.c                                  |   2 +-
 drivers/mtd/nand/raw/atmel/nand-controller.c       |   2 +-
 drivers/mtd/nand/raw/atmel/pmecc.c                 |   6 +
 drivers/mtd/nand/raw/fsmc_nand.c                   |   2 +
 drivers/net/can/kvaser_pciefd.c                    |   1 +
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c   |   1 +
 drivers/net/dsa/b53/b53_common.c                   |  31 ++-
 drivers/net/dsa/b53/b53_regs.h                     |   1 +
 drivers/net/ethernet/agere/et131x.c                |  36 +++
 drivers/net/ethernet/atheros/ag71xx.c              |   9 +
 drivers/net/ethernet/cavium/thunder/thunder_bgx.c  |   4 +-
 drivers/net/ethernet/emulex/benet/be_cmds.c        |   2 +-
 drivers/net/ethernet/emulex/benet/be_main.c        |   8 +-
 drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c |   4 +-
 drivers/net/ethernet/freescale/fec_main.c          |  34 ++-
 drivers/net/ethernet/freescale/gianfar_ethtool.c   |   4 +-
 drivers/net/ethernet/intel/fm10k/fm10k.h           |   3 +-
 drivers/net/ethernet/intel/i40e/i40e.h             |   2 +-
 drivers/net/ethernet/intel/ice/ice_flex_pipe.c     |   2 +
 drivers/net/ethernet/intel/ixgbe/ixgbe.h           |   3 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c       |   4 +-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c      |   2 +-
 drivers/net/phy/smsc.c                             |   1 +
 drivers/net/ppp/pptp.c                             |  18 +-
 drivers/net/usb/sierra_net.c                       |   4 +
 drivers/net/usb/usbnet.c                           |  11 +-
 drivers/net/virtio_net.c                           |  38 ++-
 drivers/net/vrf.c                                  |   2 +
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |   8 +-
 .../broadcom/brcm80211/brcmsmac/phy/phy_lcn.c      |   2 +-
 drivers/net/wireless/intel/iwlegacy/4965-mac.c     |   5 +-
 drivers/net/wireless/intel/iwlwifi/dvm/main.c      |  11 +-
 drivers/net/wireless/intel/iwlwifi/dvm/rs.c        |   2 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        |   7 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |   2 +-
 drivers/net/wireless/marvell/mwl8k.c               |   4 +
 drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c |   3 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |   2 +-
 drivers/net/wireless/realtek/rtlwifi/pci.c         |  18 +-
 drivers/pci/controller/pcie-rockchip-host.c        |   2 +-
 drivers/pci/endpoint/pci-ep-cfs.c                  |   1 +
 drivers/pci/endpoint/pci-epf-core.c                |   2 +-
 drivers/pci/hotplug/pnv_php.c                      |  90 +++++--
 drivers/pci/pci-acpi.c                             |   4 +-
 drivers/pci/pci.c                                  |   8 +-
 drivers/pci/probe.c                                |   2 +-
 drivers/pinctrl/stm32/pinctrl-stm32.c              |   1 +
 drivers/pinctrl/sunxi/pinctrl-sunxi.c              |  11 +-
 drivers/platform/x86/thinkpad_acpi.c               |   4 +-
 drivers/power/supply/bq24190_charger.c             |  60 ++---
 drivers/power/supply/max14577_charger.c            |   4 +-
 drivers/pps/pps.c                                  |  11 +-
 drivers/pwm/pwm-imx-tpm.c                          |   9 +
 drivers/pwm/pwm-mediatek.c                         |  78 ++++--
 drivers/regulator/core.c                           |   1 +
 drivers/rtc/rtc-ds1307.c                           |  17 +-
 drivers/rtc/rtc-hym8563.c                          |   2 +-
 drivers/rtc/rtc-pcf8563.c                          |   2 +-
 drivers/scsi/aacraid/comminit.c                    |   3 +-
 drivers/scsi/bfa/bfad_im.c                         |   1 +
 drivers/scsi/ibmvscsi_tgt/libsrp.c                 |   6 +-
 drivers/scsi/isci/request.c                        |   2 +-
 drivers/scsi/libiscsi.c                            |   3 +-
 drivers/scsi/lpfc/lpfc_debugfs.c                   |   1 -
 drivers/scsi/lpfc/lpfc_scsi.c                      |   4 +
 drivers/scsi/mpt3sas/mpt3sas_scsih.c               |  19 ++
 drivers/scsi/mvsas/mv_sas.c                        |   4 +-
 drivers/scsi/qla4xxx/ql4_os.c                      |   2 +
 drivers/scsi/scsi_scan.c                           |   2 +-
 drivers/scsi/scsi_transport_sas.c                  |  62 ++++-
 drivers/soc/aspeed/aspeed-lpc-snoop.c              |  13 +-
 drivers/soc/qcom/mdt_loader.c                      |  41 +++
 drivers/soc/tegra/pmc.c                            |  51 ++--
 drivers/soundwire/stream.c                         |   2 +-
 drivers/staging/comedi/comedi_compat32.c           |   3 +
 drivers/staging/comedi/comedi_fops.c               |  60 ++++-
 drivers/staging/comedi/comedi_internal.h           |   1 +
 drivers/staging/comedi/drivers.c                   |  30 ++-
 drivers/staging/comedi/drivers/aio_iiro_16.c       |   3 +-
 drivers/staging/comedi/drivers/comedi_test.c       |   2 +-
 drivers/staging/comedi/drivers/das16m1.c           |   3 +-
 drivers/staging/comedi/drivers/das6402.c           |   3 +-
 drivers/staging/comedi/drivers/pcl812.c            |   3 +-
 drivers/staging/fbtft/fbtft-core.c                 |   1 +
 drivers/staging/media/imx/imx-media-csc-scaler.c   |   2 +-
 drivers/staging/nvec/nvec_power.c                  |   2 +-
 drivers/thermal/thermal_sysfs.c                    |   9 +-
 drivers/thunderbolt/domain.c                       |   2 +-
 drivers/tty/serial/8250/8250_port.c                |   3 +-
 drivers/tty/serial/pch_uart.c                      |   2 +-
 drivers/tty/vt/defkeymap.c_shipped                 | 112 ++++++++
 drivers/tty/vt/keyboard.c                          |   2 +-
 drivers/usb/atm/cxacru.c                           | 172 ++++++------
 drivers/usb/chipidea/ci.h                          |  18 +-
 drivers/usb/chipidea/udc.c                         |  89 ++++---
 drivers/usb/class/cdc-acm.c                        |  13 +-
 drivers/usb/core/hub.c                             |  67 ++++-
 drivers/usb/core/quirks.c                          |   1 +
 drivers/usb/core/urb.c                             |   2 +-
 drivers/usb/dwc3/dwc3-meson-g12a.c                 |   3 +
 drivers/usb/dwc3/dwc3-qcom.c                       |   8 +-
 drivers/usb/dwc3/gadget.c                          |   9 +
 drivers/usb/early/xhci-dbc.c                       |   4 +
 drivers/usb/gadget/composite.c                     |   5 +
 drivers/usb/gadget/configfs.c                      |   2 +
 drivers/usb/gadget/udc/renesas_usb3.c              |   1 +
 drivers/usb/host/xhci-hub.c                        |   3 +-
 drivers/usb/host/xhci-mem.c                        |  24 +-
 drivers/usb/host/xhci-plat.c                       |   3 +-
 drivers/usb/host/xhci-ring.c                       |  19 +-
 drivers/usb/host/xhci.c                            |  24 +-
 drivers/usb/host/xhci.h                            |   3 +-
 drivers/usb/musb/musb_gadget.c                     |   2 +
 drivers/usb/musb/omap2430.c                        |  10 +-
 drivers/usb/phy/phy-mxs-usb.c                      |   4 +-
 drivers/usb/serial/ftdi_sio.c                      |   2 +
 drivers/usb/serial/ftdi_sio_ids.h                  |   3 +
 drivers/usb/serial/option.c                        |   7 +
 drivers/usb/storage/realtek_cr.c                   |   2 +-
 drivers/usb/storage/unusual_devs.h                 |  29 ++
 drivers/usb/typec/tcpm/fusb302.c                   |   8 +
 drivers/vhost/vhost.c                              |   3 +
 drivers/video/console/vgacon.c                     |   2 +-
 drivers/video/fbdev/imxfb.c                        |   9 +-
 drivers/watchdog/dw_wdt.c                          |   2 +
 drivers/watchdog/ziirave_wdt.c                     |   3 +
 fs/btrfs/tree-log.c                                |  53 ++--
 fs/buffer.c                                        |   2 +-
 fs/cifs/cifsglob.h                                 |   1 +
 fs/cifs/cifssmb.c                                  |  10 +
 fs/cifs/smbdirect.c                                |  14 +-
 fs/cifs/transport.c                                |  34 ++-
 fs/ext4/fsmap.c                                    |  23 +-
 fs/ext4/inline.c                                   |  19 +-
 fs/ext4/inode.c                                    |   2 +-
 fs/f2fs/f2fs.h                                     |   2 +-
 fs/f2fs/inode.c                                    |  28 +-
 fs/f2fs/node.c                                     |  10 +
 fs/file.c                                          |  81 +++---
 fs/hfs/bnode.c                                     |  93 +++++++
 fs/hfsplus/bnode.c                                 |  92 +++++++
 fs/hfsplus/extents.c                               |   3 -
 fs/hfsplus/unicode.c                               |   7 +
 fs/hfsplus/xattr.c                                 |   6 +-
 fs/hugetlbfs/inode.c                               |   2 +-
 fs/isofs/inode.c                                   |   9 +-
 fs/jbd2/checkpoint.c                               |   1 +
 fs/jfs/file.c                                      |   3 +
 fs/jfs/inode.c                                     |   2 +-
 fs/jfs/jfs_dmap.c                                  |  10 +-
 fs/namespace.c                                     |  89 ++++++-
 fs/nfs/blocklayout/blocklayout.c                   |   4 +-
 fs/nfs/blocklayout/dev.c                           |   5 +-
 fs/nfs/blocklayout/extent_tree.c                   |  20 +-
 fs/nfs/client.c                                    |  44 ++-
 fs/nfs/direct.c                                    |  13 +-
 fs/nfs/export.c                                    |  11 +-
 fs/nfs/inode.c                                     |   6 +-
 fs/nfs/internal.h                                  |   1 +
 fs/nfs/nfs4client.c                                |  13 +-
 fs/nfs/nfs4proc.c                                  |  35 +--
 fs/nfs/pnfs.c                                      |  11 +-
 fs/nfs/write.c                                     |  11 +-
 fs/nfsd/nfs4state.c                                |  34 ++-
 fs/nilfs2/inode.c                                  |   9 +-
 fs/orangefs/orangefs-debugfs.c                     |   8 +-
 fs/squashfs/super.c                                |  14 +-
 fs/udf/super.c                                     |  13 +-
 include/linux/fs.h                                 |   4 +-
 include/linux/if_vlan.h                            |   6 +-
 include/linux/mm.h                                 |  26 +-
 include/linux/moduleparam.h                        |   5 +-
 include/linux/nfs_fs.h                             |   2 +
 include/linux/pci.h                                |   1 +
 include/linux/pps_kernel.h                         |   1 +
 include/linux/skbuff.h                             |  31 ++-
 include/linux/usb/chipidea.h                       |   1 +
 include/linux/usb/usbnet.h                         |   1 +
 include/net/act_api.h                              |  25 ++
 include/net/cfg80211.h                             |   2 +-
 include/net/sch_generic.h                          |  13 -
 include/net/udp.h                                  |  24 +-
 include/uapi/linux/in6.h                           |   4 +-
 include/uapi/linux/io_uring.h                      |   2 +-
 include/uapi/linux/mount.h                         |   3 +-
 kernel/events/core.c                               |  20 +-
 kernel/fork.c                                      |   2 +-
 kernel/power/console.c                             |   7 +-
 kernel/rcu/tree_plugin.h                           |   3 +
 kernel/trace/ftrace.c                              |  19 +-
 kernel/trace/trace_events.c                        |   5 +
 mm/filemap.c                                       |   2 +-
 mm/hmm.c                                           |   2 +-
 mm/kmemleak.c                                      | 120 +++++----
 mm/madvise.c                                       |   2 +-
 mm/mmap.c                                          |  26 +-
 mm/shmem.c                                         |   2 +-
 mm/zsmalloc.c                                      |   6 +-
 net/8021q/vlan.c                                   |  42 ++-
 net/8021q/vlan.h                                   |   1 +
 net/appletalk/aarp.c                               |  42 ++-
 net/appletalk/ddp.c                                |   7 +-
 net/bluetooth/hci_sysfs.c                          |  15 +-
 net/bluetooth/l2cap_core.c                         |  26 +-
 net/bluetooth/l2cap_sock.c                         |   3 +
 net/bluetooth/smp.c                                |  21 +-
 net/bluetooth/smp.h                                |   1 +
 net/caif/cfctrl.c                                  | 294 ++++++++++-----------
 net/core/filter.c                                  |   3 +
 net/core/netpoll.c                                 |   7 +
 net/ipv4/route.c                                   |   1 -
 net/ipv4/tcp_input.c                               |   3 +-
 net/ipv4/udp_offload.c                             |   2 +-
 net/ipv6/ip6_offload.c                             |   4 +-
 net/ipv6/seg6_hmac.c                               |   3 +
 net/mac80211/tx.c                                  |   1 +
 net/ncsi/internal.h                                |   2 +-
 net/ncsi/ncsi-rsp.c                                |   1 +
 net/netfilter/nf_conntrack_netlink.c               |  24 +-
 net/netfilter/nf_tables_api.c                      |   4 +-
 net/netfilter/xt_nfacct.c                          |   4 +-
 net/netlink/af_netlink.c                           |   2 +-
 net/packet/af_packet.c                             |  39 ++-
 net/phonet/pep.c                                   |   2 +-
 net/sched/act_api.c                                |  14 +
 net/sched/act_csum.c                               |   4 +-
 net/sched/act_ct.c                                 |  10 +-
 net/sched/act_gact.c                               |  14 +-
 net/sched/act_mirred.c                             |  55 ++--
 net/sched/act_police.c                             |   5 +-
 net/sched/act_tunnel_key.c                         |   2 +-
 net/sched/act_vlan.c                               |   9 +-
 net/sched/sch_cake.c                               |  14 +-
 net/sched/sch_codel.c                              |   5 +-
 net/sched/sch_drr.c                                |   7 +-
 net/sched/sch_fq_codel.c                           |   6 +-
 net/sched/sch_hfsc.c                               |   8 +-
 net/sched/sch_htb.c                                |   6 +-
 net/sched/sch_netem.c                              |  40 +++
 net/sched/sch_qfq.c                                |  40 ++-
 net/sched/sch_sfq.c                                | 116 +++++---
 net/sctp/input.c                                   |   2 +-
 net/tls/tls_sw.c                                   |  13 +
 net/vmw_vsock/af_vsock.c                           |   3 +-
 net/wireless/mlme.c                                |   3 +-
 samples/mei/mei-amt-version.c                      |   2 +-
 scripts/Kbuild.include                             |   8 +-
 scripts/kconfig/gconf.c                            |   8 +-
 scripts/kconfig/lxdialog/inputbox.c                |   6 +-
 scripts/kconfig/lxdialog/menubox.c                 |   2 +-
 scripts/kconfig/nconf.c                            |   2 +
 scripts/kconfig/nconf.gui.c                        |   1 +
 security/inode.c                                   |   2 -
 sound/pci/hda/patch_ca0132.c                       |   2 +-
 sound/pci/hda/patch_hdmi.c                         |  19 ++
 sound/pci/intel8x0.c                               |   2 +-
 sound/soc/codecs/hdac_hdmi.c                       |  10 +-
 sound/soc/codecs/rt5640.c                          |   5 +
 sound/soc/fsl/fsl_sai.c                            |  14 +-
 sound/soc/intel/boards/Kconfig                     |   2 +-
 sound/soc/soc-dapm.c                               |   4 +
 sound/soc/soc-ops.c                                |  28 +-
 sound/usb/mixer_quirks.c                           |  14 +-
 sound/usb/mixer_scarlett_gen2.c                    |   9 +
 sound/usb/stream.c                                 |  25 +-
 sound/usb/validate.c                               |  14 +-
 tools/bpf/bpftool/net.c                            |  15 +-
 tools/perf/tests/bp_account.c                      |   1 +
 .../cpupower/utils/idle_monitor/mperf_monitor.c    |   4 +-
 tools/testing/ktest/ktest.pl                       |   5 +-
 .../ftrace/test.d/ftrace/func-filter-glob.tc       |   2 +-
 tools/testing/selftests/futex/include/futextest.h  |  11 +
 .../testing/selftests/net/forwarding/tc_actions.sh |  72 ++++-
 tools/testing/selftests/net/rtnetlink.sh           |   6 +
 365 files changed, 3553 insertions(+), 1524 deletions(-)



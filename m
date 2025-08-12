Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E352F5E;
	Tue, 12 Aug 2025 18:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022035; cv=none; b=cz1QiFsC/iqwabt1b1Unj1Cb1XUi512q4v/nLYcmF5oxYX331lyIFeXAX8t4ZgjQfGH+I5Dv3CsiJOr/OWqVwiG3DkFaO8tQXvvySIxs9BbqE3w/62UxsGl+jtVJa6Hjh6zQhxxDRfdlJMAec9js9L/bZNC4S3Gxs1HPlgruaX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022035; c=relaxed/simple;
	bh=l5UyGzDTUk+lhKb4egtRuORgIqRGyswb8Bke0A+eBiI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=B6kZDcXEkSn8ozOXpek2ZgJx5+hTrYRC5GPZK+aHNaOR2a0OApNu6rVx5O8fQn4BebO1Vnv8fFDlMSpABpmYQK5tyRHlEDbFE1P47R1H8MQmMu2sB4L596qFzW3RCk0DF32lp7dUeJIK92j9WHrFiOoo/G88Q3Hmmw5cISyUbIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=py0TbZtJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="py0TbZtJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95846C4CEF0;
	Tue, 12 Aug 2025 18:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022035;
	bh=l5UyGzDTUk+lhKb4egtRuORgIqRGyswb8Bke0A+eBiI=;
	h=From:To:Cc:Subject:Date:From;
	b=py0TbZtJpuT9mAeQmYPbfSrjbgSVZrD9yC4kXqa7W7fekbwYREGfnr8OG1V6AMAVV
	 xDlhGbruLmaJzQpV28L0ET/1ojgBtC+FgVmjLaJZ4By/xwSh+YqsqBi1gyzaf2KYeR
	 opJnRd2AOCE3V4GipBXaP+KdG/glkYcZcVHqw7Iw=
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
Subject: [PATCH 6.12 000/369] 6.12.42-rc1 review
Date: Tue, 12 Aug 2025 19:24:57 +0200
Message-ID: <20250812173014.736537091@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.42-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.12.42-rc1
X-KernelTest-Deadline: 2025-08-14T17:30+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.12.42 release.
There are 369 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 14 Aug 2025 17:27:11 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.42-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.12.42-rc1

Tao Xue <xuetao09@huawei.com>
    usb: gadget : fix use-after-free in composite_dev_cleanup()

Yuhao Jiang <danisjiang@gmail.com>
    USB: gadget: f_hid: Fix memory leak in hidg_bind error path

Qasim Ijaz <qasdev00@gmail.com>
    HID: apple: validate feature-report field count to prevent NULL pointer dereference

Julien Massot <julien.massot@collabora.com>
    media: ti: j721e-csi2rx: fix list_del corruption

Robin Murphy <robin.murphy@arm.com>
    perf/arm-ni: Set initial IRQ affinity

Kemeng Shi <shikemeng@huaweicloud.com>
    mm: swap: fix potential buffer overflow in setup_clusters()

Kemeng Shi <shikemeng@huaweicloud.com>
    mm: swap: correctly use maxpages in swapon syscall to avoid potential deadloop

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    mm/hmm: move pmd_to_hmm_pfn_flags() to the respective #ifdeffery

Jiaxun Yang <jiaxun.yang@flygoat.com>
    MIPS: mm: tlb-r4k: Uniquify TLB entries on init

Gerald Schaefer <gerald.schaefer@linux.ibm.com>
    s390/mm: Remove possible false-positive warning in pte_free_defer()

Dave Hansen <dave.hansen@linux.intel.com>
    x86/fpu: Delay instruction pointer fixup until after warning

Michael J. Ruhl <michael.j.ruhl@intel.com>
    platform/x86/intel/pmt: fix a crashlog NULL pointer access

Edip Hazuri <edip@medip.dev>
    ALSA: hda/realtek - Fix mute LED for HP Victus 16-d1xxx (MB 8A26)

Edip Hazuri <edip@medip.dev>
    ALSA: hda/realtek - Fix mute LED for HP Victus 16-s0xxx

Edip Hazuri <edip@medip.dev>
    ALSA: hda/realtek - Fix mute LED for HP Victus 16-r1xxx

Geoffrey D. Bennett <g@b4.vu>
    ALSA: scarlett2: Add retry on -EPROTO from scarlett2_usb_tx()

Thorsten Blum <thorsten.blum@linux.dev>
    ALSA: intel_hdmi: Fix off-by-one error in __hdmi_lpe_audio_probe()

Tom Lendacky <thomas.lendacky@amd.com>
    x86/sev: Evict cache lines during SNP memory validation

Ammar Faizi <ammarfaizi2@gnuweeb.org>
    net: usbnet: Fix the wrong netif_carrier_on() call

John Ernberg <john.ernberg@actia.se>
    net: usbnet: Avoid potential RCU stall on LINK_CHANGE event

Zenm Chen <zenmchen@gmail.com>
    Bluetooth: btusb: Add USB ID 3625:010b for TP-LINK Archer TX10UB Nano

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    PCI/ASPM: Fix L1SS saving

Jian-Hong Pan <jhp@endlessos.org>
    PCI/ASPM: Save parent L1SS config in pci_save_aspm_l1ss_state()

Slark Xiao <slark_xiao@163.com>
    USB: serial: option: add Foxconn T99W709

Thorsten Blum <thorsten.blum@linux.dev>
    smb: server: Fix extension string in ksmbd_extract_shortname()

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: limit repeated connections from clients with the same IP

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix corrupted mtime and ctime in smb2_open

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix Preauh_HashValue race condition

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix null pointer dereference error in generate_encryptionkey

Jani Nikula <jani.nikula@intel.com>
    drm/i915/ddi: only call shutdown hooks for valid encoders

Jani Nikula <jani.nikula@intel.com>
    drm/i915/display: add intel_encoder_is_hdmi()

Jani Nikula <jani.nikula@intel.com>
    drm/i915/ddi: gracefully handle errors from intel_ddi_init_hdmi_connector()

Jani Nikula <jani.nikula@intel.com>
    drm/i915/hdmi: add error handling in g4x_hdmi_init()

Jani Nikula <jani.nikula@intel.com>
    drm/i915/hdmi: propagate errors from intel_hdmi_init_connector()

Jani Nikula <jani.nikula@intel.com>
    drm/i915/ddi: change intel_ddi_init_{dp, hdmi}_connector() return type

Alexei Starovoitov <ast@kernel.org>
    selftests/bpf: Fix build error with llvm 19

Alexei Starovoitov <ast@kernel.org>
    selftests/bpf: Add a test for arena range tree algorithm

Anton Nadezhdin <anton.nadezhdin@intel.com>
    ice/ptp: fix crosstimestamp reporting

Kuan-Wei Chiu <visitorckw@gmail.com>
    Revert "bcache: remove heap-related macros and switch to generic min_heap"

Andrzej Kacprowski <Andrzej.Kacprowski@intel.com>
    accel/ivpu: Fix reset_engine debugfs file logic

Budimir Markovic <markovicbudimir@gmail.com>
    vsock: Do not allow binding to VMADDR_PORT_ANY

Quang Le <quanglex97@gmail.com>
    net/packet: fix a race in packet_set_ring() and packet_notifier()

Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
    selftests/perf_events: Add a mmap() correctness test

Thomas Gleixner <tglx@linutronix.de>
    perf/core: Prevent VMA split of buffer mappings

Thomas Gleixner <tglx@linutronix.de>
    perf/core: Exit early on perf_mmap() fail

Thomas Gleixner <tglx@linutronix.de>
    perf/core: Don't leak AUX buffer refcount on allocation failure

Olga Kornievskaia <okorniev@redhat.com>
    sunrpc: fix handling of server side tls alerts

Stefan Metzmacher <metze@samba.org>
    smb: client: return an error if rdma_connect does not return within 5 seconds

Eric Dumazet <edumazet@google.com>
    pptp: fix pptp_xmit() error path

Mohamed Khalfella <mkhalfella@purestorage.com>
    nvmet: exit debugfs after discovery subsystem exits

Stefan Metzmacher <metze@samba.org>
    smb: client: let recv_done() avoid touching data_transfer after cleanup/move

Stefan Metzmacher <metze@samba.org>
    smb: client: let recv_done() cleanup before notifying the callers.

Stefan Metzmacher <metze@samba.org>
    smb: client: make sure we call ib_dma_unmap_single() only if we called ib_dma_map_single already

Stefan Metzmacher <metze@samba.org>
    smb: client: remove separate empty_packet_queue

Stefan Metzmacher <metze@samba.org>
    smb: client: let send_done() cleanup before calling smbd_disconnect_rdma_connection()

Stefan Metzmacher <metze@samba.org>
    smb: server: let recv_done() avoid touching data_transfer after cleanup/move

Stefan Metzmacher <metze@samba.org>
    smb: server: let recv_done() consistently call put_recvmsg/smb_direct_disconnect_rdma_connection

Stefan Metzmacher <metze@samba.org>
    smb: server: make sure we call ib_dma_unmap_single() only if we called ib_dma_map_single already

Stefan Metzmacher <metze@samba.org>
    smb: server: remove separate empty_recvmsg_queue

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/ca0132: Fix missing error handling in ca0132_alt_select_out()

Arnd Bergmann <arnd@arndb.de>
    irqchip: Build IMX_MU_MSI only on ARM

Jakub Kicinski <kuba@kernel.org>
    eth: fbnic: remove the debugging trick of super high page bias

Sumanth Korikkar <sumanthk@linux.ibm.com>
    s390/mm: Allocate page table with PAGE_SIZE granularity

Maher Azzouzi <maherazz04@gmail.com>
    net/sched: mqprio: fix stack out-of-bounds write in tc entry parsing

Michal Schmidt <mschmidt@redhat.com>
    benet: fix BUG when creating VFs

Thomas Gleixner <tglx@linutronix.de>
    x86/irq: Plug vector setup race

Olga Kornievskaia <okorniev@redhat.com>
    sunrpc: fix client side handling of tls alerts

Takamitsu Iwai <takamitz@amazon.co.jp>
    net/sched: taprio: enforce minimum value for picos_per_byte

Wang Liang <wangliang74@huawei.com>
    net: drop UFO packets in udp_rcv_segment()

Florian Fainelli <florian.fainelli@broadcom.com>
    net: mdio: mdio-bcm-unimac: Correct rate fallback logic

Eric Dumazet <edumazet@google.com>
    ipv6: reject malicious packets in ipv6_gso_segment()

Christoph Paasch <cpaasch@openai.com>
    net/mlx5: Correctly set gso_segs when LRO is used

Simon Trimmer <simont@opensource.cirrus.com>
    spi: cs42l43: Property entry should be a null-terminated array

Baojun Xu <baojun.xu@ti.com>
    ASoC: tas2781: Fix the wrong step for TLV on tas2781

Christoph Hellwig <hch@lst.de>
    block: ensure discard_granularity is zero when discard is not supported

Guenter Roeck <linux@roeck-us.net>
    block: Fix default IO priority if there is no IO context

Jakub Kicinski <kuba@kernel.org>
    netlink: specs: ethtool: fix module EEPROM input/output arguments

Harald Freudenberger <freude@linux.ibm.com>
    s390/ap: Unmask SLCF bit in card and queue ap functions sysfs

Mohamed Khalfella <mkhalfella@purestorage.com>
    nvmet: initialize discovery subsys after debugfs is initialized

Eric Dumazet <edumazet@google.com>
    pptp: ensure minimal skb length in pptp_xmit()

Luca Weiss <luca.weiss@fairphone.com>
    net: ipa: add IPA v5.1 and v5.5 to ipa_version_string()

Horatiu Vultur <horatiu.vultur@microchip.com>
    phy: mscc: Fix parsing of unicast frames

Jakub Kicinski <kuba@kernel.org>
    netpoll: prevent hanging NAPI when netcons gets enabled

Heming Zhao <heming.zhao@suse.com>
    md/md-cluster: handle REMOVE message earlier

Benjamin Coddington <bcodding@redhat.com>
    NFS: Fixup allocation flags for nfsiod's __GFP_NORETRY

Olga Kornievskaia <okorniev@redhat.com>
    NFSv4.2: another fix for listxattr

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix filehandle bounds checking in nfs_fh_to_dentry()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix wakeup of __nfs_lookup_revalidate() in unblock_revalidate()

NeilBrown <neilb@suse.de>
    sched: Add test_and_clear_wake_up_bit() and atomic_dec_and_wake_up()

Tigran Mkrtchyan <tigran.mkrtchyan@desy.de>
    pNFS/flexfiles: don't attempt pnfs on fatal DS errors

Timothy Pearson <tpearson@raptorengineering.com>
    PCI: pnv_php: Fix surprise plug detection and recovery

Timothy Pearson <tpearson@raptorengineering.com>
    powerpc/eeh: Make EEH driver device hotplug safe

Timothy Pearson <tpearson@raptorengineering.com>
    powerpc/eeh: Export eeh_unfreeze_pe()

Timothy Pearson <tpearson@raptorengineering.com>
    PCI: pnv_php: Work around switches with broken presence detection

Timothy Pearson <tpearson@raptorengineering.com>
    PCI: pnv_php: Clean up allocated IRQs on unplug

Peter Zijlstra <peterz@infradead.org>
    sched/psi: Fix psi_seq initialization

Masahiro Yamada <masahiroy@kernel.org>
    kconfig: qconf: fix ConfigList::updateListAllforAll()

Salomon Dushimirimana <salomondush@google.com>
    scsi: sd: Make sd shutdown issue START STOP UNIT appropriately

Seunghui Lee <sh043.lee@samsung.com>
    scsi: ufs: core: Use link recovery when h8 exit fails during runtime resume

Li Lingfeng <lilingfeng3@huawei.com>
    scsi: Revert "scsi: iscsi: Fix HW conn removal use after free"

Tomas Henzl <thenzl@redhat.com>
    scsi: mpt3sas: Fix a fw_event memory leak

Alex Williamson <alex.williamson@redhat.com>
    vfio/pci: Separate SR-IOV VF dev_set

Brett Creeley <brett.creeley@amd.com>
    vfio/pds: Fix missing detach_ioas op

Jacob Pan <jacob.pan@linux.microsoft.com>
    vfio: Prevent open_count decrement to negative

Jacob Pan <jacob.pan@linux.microsoft.com>
    vfio: Fix unbalanced vfio_df_close call in no-iommu mode

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    i2c: muxes: mule: Fix an error handling path in mule_i2c_mux_probe()

Zhengxu Zhang <zhengxu.zhang@unisoc.com>
    exfat: fdatasync flag should be same like generic_write_sync()

Chao Yu <chao@kernel.org>
    f2fs: fix to trigger foreground gc during f2fs_map_blocks() in lfs mode

Chao Yu <chao@kernel.org>
    f2fs: fix to calculate dirty data during has_not_enough_free_secs()

Chao Yu <chao@kernel.org>
    f2fs: fix to update upper_p in __get_secs_required() correctly

Jan Prusakowski <jprusakowski@google.com>
    f2fs: vm_unmap_ram() may be called from an invalid context

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid out-of-boundary access in devs.path

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid panic in f2fs_evict_inode

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid UAF in f2fs_sync_inode_meta()

Chao Yu <chao@kernel.org>
    f2fs: doc: fix wrong quota mount option description

Chao Yu <chao@kernel.org>
    f2fs: fix to check upper boundary for gc_no_zoned_gc_percent

Chao Yu <chao@kernel.org>
    f2fs: fix to check upper boundary for gc_valid_thresh_ratio

yohan.joung <yohan.joung@sk.com>
    f2fs: fix to check upper boundary for value of gc_boost_zoned_gc_percent

Abinash Singh <abinashlalotra@gmail.com>
    f2fs: fix KMSAN uninit-value in extent_info usage

Sheng Yong <shengyong1@xiaomi.com>
    f2fs: fix bio memleak when committing super block

Daeho Jeong <daehojeong@google.com>
    f2fs: turn off one_time when forcibly set to foreground GC

Brian Masney <bmasney@redhat.com>
    rtc: rv3028: fix incorrect maximum clock rate handling

Brian Masney <bmasney@redhat.com>
    rtc: pcf8563: fix incorrect maximum clock rate handling

Brian Masney <bmasney@redhat.com>
    rtc: pcf85063: fix incorrect maximum clock rate handling

Brian Masney <bmasney@redhat.com>
    rtc: nct3018y: fix incorrect maximum clock rate handling

Brian Masney <bmasney@redhat.com>
    rtc: hym8563: fix incorrect maximum clock rate handling

Brian Masney <bmasney@redhat.com>
    rtc: ds1307: fix incorrect maximum clock rate handling

Uros Bizjak <ubizjak@gmail.com>
    ucount: fix atomic_long_inc_below() argument type

Petr Pavlu <petr.pavlu@suse.com>
    module: Restore the moduleparam prefix length check

Helge Deller <deller@gmx.de>
    apparmor: Fix unaligned memory accesses in KUnit test

Ryan Lee <ryan.lee@canonical.com>
    apparmor: fix loop detection used in conflicting attachment resolution

Ryan Lee <ryan.lee@canonical.com>
    apparmor: ensure WB_HISTORY_SIZE value is a power of 2

Paul Chaignon <paul.chaignon@gmail.com>
    bpf: Check netfilter ctx accesses are aligned

Paul Chaignon <paul.chaignon@gmail.com>
    bpf: Check flow_dissector ctx accesses are aligned

Cindy Lu <lulu@redhat.com>
    vhost: Reintroduce kthread API and add mode selection

Anders Roxell <anders.roxell@linaro.org>
    vdpa: Fix IDR memory leak in VDUSE module exit

Dragos Tatulea <dtatulea@nvidia.com>
    vdpa/mlx5: Fix release of uninitialized resources on error path

Mike Christie <michael.christie@oracle.com>
    vhost-scsi: Fix log flooding with target does not exist errors

Dragos Tatulea <dtatulea@nvidia.com>
    vdpa/mlx5: Fix needs_teardown flag calculation

Namhyung Kim <namhyung@kernel.org>
    perf record: Cache build-ID of hit DSOs only

WangYuli <wangyuli@uniontech.com>
    selftests: ALSA: fix memory leak in utimer test

Lukasz Laguna <lukasz.laguna@intel.com>
    drm/xe/vf: Disable CSC support on VF

Balamanikandan Gunasundar <balamanikandan.gunasundar@microchip.com>
    mtd: rawnand: atmel: set pmecc data setup time

Thomas Fourier <fourier.thomas@gmail.com>
    mtd: rawnand: rockchip: Add missing check after DMA map

Thomas Fourier <fourier.thomas@gmail.com>
    mtd: rawnand: atmel: Fix dma_mapping_error() address

Zheng Yu <zheng.yu@northwestern.edu>
    jfs: fix metapage reference count leak in dbAllocCtl

Chenyuan Yang <chenyuan0y@gmail.com>
    fbdev: imxfb: Check fb_add_videomode to prevent null-ptr-deref

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - fix seq_file position update in adf_ring_next()

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - fix DMA direction for compression on GEN2 devices

Chen Pei <cp0613@linux.alibaba.com>
    perf tools: Remove libtraceevent in .gitignore

Ben Hutchings <benh@debian.org>
    sh: Do not use hyphen in exported variable name

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_xcvr: get channel status data when PHY is not exists

Thomas Fourier <fourier.thomas@gmail.com>
    dmaengine: nbpfaxi: Add missing check after DMA map

Thomas Fourier <fourier.thomas@gmail.com>
    dmaengine: mv_xor: Fix missing check after DMA map and missing unmap

Dan Carpenter <dan.carpenter@linaro.org>
    fs/orangefs: Allow 2 more characters in do_c_string()

Tanmay Shah <tanmay.shah@amd.com>
    remoteproc: xlnx: Disable unsupported features

Laurentiu Palcu <laurentiu.palcu@oss.nxp.com>
    clk: imx95-blk-ctl: Fix synchronous abort

Manivannan Sadhasivam <mani@kernel.org>
    PCI: endpoint: pci-epf-vntb: Fix the incorrect usage of __iomem attribute

Bard Liao <yung-chuan.liao@linux.intel.com>
    soundwire: stream: restore params when prepare ports fail

Bairavi Alagappan <bairavix.alagappan@intel.com>
    crypto: qat - disable ZUC-256 capability for QAT GEN5

Thomas Fourier <fourier.thomas@gmail.com>
    crypto: img-hash - Fix dma_unmap_sg() nents value

Thomas Fourier <fourier.thomas@gmail.com>
    crypto: keembay - Fix dma_unmap_sg() nents value

Ovidiu Panait <ovidiu.panait.oss@gmail.com>
    hwrng: mtk - handle devm_pm_runtime_enable errors

Varshini Rajendran <varshini.rajendran@microchip.com>
    clk: at91: sam9x7: update pll clk ranges

Jan Kara <jack@suse.cz>
    ext4: Make sure BH_New bit is cleared in ->write_end handler

Dan Carpenter <dan.carpenter@linaro.org>
    watchdog: ziirave_wdt: check record length in ziirave_firm_verify()

Thomas Fourier <fourier.thomas@gmail.com>
    scsi: isci: Fix dma_unmap_sg() nents value

Thomas Fourier <fourier.thomas@gmail.com>
    scsi: mvsas: Fix dma_unmap_sg() nents value

Thomas Fourier <fourier.thomas@gmail.com>
    scsi: elx: efct: Fix dma_unmap_sg() nents value

Thomas Fourier <fourier.thomas@gmail.com>
    scsi: ibmvscsi_tgt: Fix dma_unmap_sg() nents value

Paul Kocialkowski <paulk@sys-base.io>
    clk: sunxi-ng: v3s: Fix de clock definition

Yao Zi <ziyao@disroot.org>
    clk: thead: th1520-ap: Correctly refer the parent of osc_12m

Shiraz Saleem <shirazsaleem@microsoft.com>
    RDMA/mana_ib: Fix DSCP value in modify QP

Leo Yan <leo.yan@arm.com>
    perf tests bp_account: Fix leaked file descriptor

Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
    pinmux: fix race causing mux_owner NULL with active mux_usecount

wangzijie <wangzijie1@honor.com>
    proc: use the same treatment to check proc_lseek as ones for proc_read_iter et.al

Arnd Bergmann <arnd@arndb.de>
    kernel: trace: preemptirq_delay_test: use offstack cpu mask

Junxian Huang <huangjunxian6@hisilicon.com>
    RDMA/hns: Fix -Wframe-larger-than issue

Junxian Huang <huangjunxian6@hisilicon.com>
    RDMA/hns: Drop GFP_NOWARN

Junxian Huang <huangjunxian6@hisilicon.com>
    RDMA/hns: Fix accessing uninitialized resources

Junxian Huang <huangjunxian6@hisilicon.com>
    RDMA/hns: Get message length of ack_req from FW

Mengbiao Xiong <xisme1998@gmail.com>
    crypto: ccp - Fix crash when rebind ccp device for ccp.ko

Thomas Fourier <fourier.thomas@gmail.com>
    crypto: inside-secure - Fix `dma_unmap_sg()` nents value

Alexey Kardashevskiy <aik@amd.com>
    crypto: ccp - Fix locking on alloc failure handling

wenglianfa <wenglianfa@huawei.com>
    RDMA/hns: Fix HW configurations not cleared in error flow

wenglianfa <wenglianfa@huawei.com>
    RDMA/hns: Fix double destruction of rsv_qp

Namhyung Kim <namhyung@kernel.org>
    perf sched: Fix memory leaks in 'perf sched latency'

Namhyung Kim <namhyung@kernel.org>
    perf sched: Use RC_CHK_EQUAL() to compare pointers

Namhyung Kim <namhyung@kernel.org>
    perf sched: Fix memory leaks for evsel->priv in timehist

Namhyung Kim <namhyung@kernel.org>
    perf sched: Fix memory leaks in 'perf sched map'

Namhyung Kim <namhyung@kernel.org>
    perf sched: Free thread->priv using priv_destructor

Namhyung Kim <namhyung@kernel.org>
    perf sched: Make sure it frees the usage string

Takahiro Kuwano <Takahiro.Kuwano@infineon.com>
    mtd: spi-nor: spansion: Fixup params->set_4byte_addr_mode for SEMPER

Ian Rogers <irogers@google.com>
    perf dso: Add missed dso__put to dso__load_kcore

Namhyung Kim <namhyung@kernel.org>
    perf tools: Fix use-after-free in help_unknown_cmd()

Thomas Fourier <fourier.thomas@gmail.com>
    Fix dma_unmap_sg() nents value

Nuno Sá <nuno.sa@analog.com>
    clk: clk-axi-clkgen: fix fpfd_max frequency for zynq

Amir Goldstein <amir73il@gmail.com>
    fanotify: sanitize handle_type values when reporting fid

Luca Weiss <luca.weiss@fairphone.com>
    phy: qualcomm: phy-qcom-eusb2-repeater: Don't zero-out registers

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    dmaengine: mmp: Fix again Wvoid-pointer-to-enum-cast warning

Yuan Chen <chenyuan@kylinos.cn>
    pinctrl: berlin: fix memory leak in berlin_pinctrl_build_state()

Yuan Chen <chenyuan@kylinos.cn>
    pinctrl: sunxi: Fix memory leak on krealloc failure

Jerome Brunet <jbrunet@baylibre.com>
    PCI: endpoint: pci-epf-vntb: Return -ENOENT if pci_epc_get_next_free_bar() fails

Arnd Bergmann <arnd@arndb.de>
    crypto: arm/aes-neonbs - work around gcc-15 warning

Charles Han <hanchunchao@inspur.com>
    power: supply: max14577: Handle NULL pdata when CONFIG_OF is not set

Charles Han <hanchunchao@inspur.com>
    power: supply: cpcap-charger: Fix null check for power_supply_get_by_name

Rohit Visavalia <rohit.visavalia@amd.com>
    clk: xilinx: vcu: unregister pll_post only if registered correctly

James Cowgill <james.cowgill@blaize.com>
    media: v4l2-ctrls: Fix H264 SEPARATE_COLOUR_PLANE check

Henry Martin <bsdhenrymartin@gmail.com>
    clk: davinci: Add NULL check in davinci_lpsc_clk_register()

Ivan Stepchenko <sid@itb.spb.ru>
    mtd: fix possible integer overflow in erase_xfer()

Svyatoslav Pankratov <svyatoslav.pankratov@intel.com>
    crypto: qat - fix state restore for banks with exceptions

Ahsan Atta <ahsan.atta@intel.com>
    crypto: qat - allow enabling VFs in the absence of IOMMU

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: marvell/cesa - Fix engine load inaccuracy

Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
    crypto: qat - use unmanaged allocation for dc_data

Ovidiu Panait <ovidiu.panait.oss@gmail.com>
    crypto: sun8i-ce - fix nents passed to dma_unmap_sg()

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    clk: renesas: rzv2h: Fix missing CLK_SET_RATE_PARENT flag for ddiv clocks

Hans Zhang <18255117159@163.com>
    PCI: rockchip-host: Fix "Unexpected Completion" log message

Kees Cook <kees@kernel.org>
    fortify: Fix incorrect reporting of read buffer size

Kees Cook <kees@kernel.org>
    staging: media: atomisp: Fix stack buffer overflow in gmin_get_var_int()

Puranjay Mohan <puranjay@kernel.org>
    bpf, arm64: Fix fp initialization for exception boundary

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    bpf/preload: Don't select USERMODE_DRIVER

Eric Dumazet <edumazet@google.com>
    ipv6: annotate data-races around rt->fib6_nsiblings

Eric Dumazet <edumazet@google.com>
    ipv6: fix possible infinite loop in fib6_info_uses_dev()

Eric Dumazet <edumazet@google.com>
    ipv6: prevent infinite loop in rt6_nlmsg_size()

Stanislav Fomichev <sdf@fomichev.me>
    vrf: Drop existing dst reference in vrf_ip6_input_dst

Xiumei Mu <xmu@redhat.com>
    selftests: rtnetlink.sh: remove esp4_offload after test

Jason Xing <kernelxing@tencent.com>
    stmmac: xsk: fix negative overflow of budget in zerocopy mode

Tristram Ha <tristram.ha@microchip.com>
    net: dsa: microchip: Fix wrong rx drop MIB counter for KSZ8863

Jianbo Liu <jianbol@nvidia.com>
    net/mlx5e: Remove skb secpath if xfrm state is not found

Alexei Lazar <alazar@nvidia.com>
    net/mlx5e: Clear Read-Only port buffer size in PBMC before update

Florian Westphal <fw@strlen.de>
    netfilter: xt_nfacct: don't assume acct name is null-terminated

Jimmy Assarsson <extja@kvaser.com>
    can: kvaser_usb: Assign netdev.dev_port based on device channel index

Jimmy Assarsson <extja@kvaser.com>
    can: kvaser_pciefd: Store device channel index

Stephane Grosjean <stephane.grosjean@hms-networks.com>
    can: peak_usb: fix USB FD devices potential malfunction

Gal Pressman <gal@nvidia.com>
    selftests: drv-net: Fix remote command checking in require_cmd()

Gabriele Monaco <gmonaco@redhat.com>
    tools/rv: Do not skip idle in trace

Kuniyuki Iwashima <kuniyu@google.com>
    bpf: Disable migration in nf_hook_run_bpf().

Chris Down <chris@chrisdown.name>
    Bluetooth: hci_event: Mask data status from LE ext adv reports

Arseniy Krasnov <avkrasnov@salutedevices.com>
    Bluetooth: hci_sync: fix double free in 'hci_discovery_filter_clear()'

Matthew Wilcox (Oracle) <willy@infradead.org>
    memcg_slabinfo: Fix use of PG_slab

Marco Elver <elver@google.com>
    kcsan: test: Initialize dummy variable

Steven Rostedt <rostedt@goodmis.org>
    ring-buffer: Remove ring_buffer_read_prepare_sync()

Kees Cook <kees@kernel.org>
    wifi: nl80211: Set num_sub_specs before looping through sub_specs

Kees Cook <kees@kernel.org>
    wifi: mac80211: Write cnt before copying in ieee80211_copy_rnr_beacon()

Gokul Sivakumar <gokulkumar.sivakumar@infineon.com>
    wifi: brcmfmac: fix P2P discovery failure in P2P peer due to missing P2P IE

Tamizh Chelvam Raja <tamizh.raja@oss.qualcomm.com>
    wifi: ath12k: fix endianness handling while accessing wmi service bit

Remi Pommarel <repk@triplefau.lt>
    Reapply "wifi: mac80211: Update skb's control block key in ieee80211_tx_dequeue()"

Remi Pommarel <repk@triplefau.lt>
    wifi: mac80211: Check 802.11 encaps offloading in ieee80211_tx_h_select_key()

Alexander Wetzel <Alexander@wetzel-home.de>
    wifi: mac80211: Don't call fq_flow_idx() for management frames

Alexander Wetzel <Alexander@wetzel-home.de>
    wifi: mac80211: Do not schedule stopped TXQs

Murad Masimov <m.masimov@mt-integration.ru>
    wifi: plfxlc: Fix error handling in usb driver probe

Moon Hee Lee <moonhee.lee.ca@gmail.com>
    wifi: mac80211: reject TDLS operations when station is not associated

Tze-nan Wu <Tze-nan.Wu@mediatek.com>
    rcu: Fix delayed execution of hurry callbacks

Jason Gunthorpe <jgg@ziepe.ca>
    iommu/amd: Fix geometry.aperture_end for V2 tables

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gfx10: fix kiq locking in KCQ reset

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gfx9.4.3: fix kiq locking in KCQ reset

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gfx9: fix kiq locking in KCQ reset

Baochen Qiang <quic_bqiang@quicinc.com>
    wifi: ath11k: fix sleeping-in-atomic in ath11k_mac_op_set_bitrate_mask()

Thomas Fourier <fourier.thomas@gmail.com>
    mwl8k: Add missing check after DMA map

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtw88: Fix macid assigned to TDLS station

Martin Kaistra <martin.kaistra@linutronix.de>
    wifi: rtl8xxxu: Fix RX skb size for aggregation disabled

Eric Dumazet <edumazet@google.com>
    tcp: call tcp_measure_rcv_mss() for ooo packets

Juergen Gross <jgross@suse.com>
    xen/gntdev: remove struct gntdev_copy_batch from stack

Al Viro <viro@zeniv.linux.org.uk>
    xen: fix UAF in dmabuf_exp_from_pages()

Edward Srouji <edwards@nvidia.com>
    RDMA/mlx5: Fix UMR modifying of mkey page size

Eric Dumazet <edumazet@google.com>
    net_sched: act_ctinfo: use atomic64_t for three counters

William Liu <will@willsroot.io>
    net/sched: Restrict conditions for adding duplicating netems to qdisc tree

Easwar Hariharan <eahariha@linux.microsoft.com>
    iommu/amd: Enable PASID and ATS capabilities in the correct order

Tiwei Bie <tiwei.btw@antgroup.com>
    um: rtc: Avoid shadowing err in uml_rtc_start()

Johan Korsnes <johan.korsnes@gmail.com>
    arch: powerpc: defconfig: Drop obsolete CONFIG_NET_CLS_TCINDEX

Fedor Pchelkin <pchelkin@ispras.ru>
    netfilter: nf_tables: adjust lockdep assertions handling

Phil Sutter <phil@nwl.cc>
    netfilter: nf_tables: Drop dead code from fill_*_info routines

Shixiong Ou <oushixiong@kylinos.cn>
    fbcon: Fix outdated registered_fb reference in comment

Peter Zijlstra <peterz@infradead.org>
    sched/psi: Optimize psi_group_change() cpu_clock() usage

Fedor Pchelkin <pchelkin@ispras.ru>
    drm/amd/pm/powerplay/hwmgr/smu_helper: fix order of mask and value

Artem Sadovnikov <a.sadovnikov@ispras.ru>
    refscale: Check that nreaders and loops multiplication doesn't overflow

Finn Thain <fthain@linux-m68k.org>
    m68k: Don't unregister boot console needlessly

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    drm/msm/dpu: Fill in min_prefill_lines for SC8180X

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Ensure RCU lock is held around bpf_prog_ksym_find

Mark Brown <broonie@kernel.org>
    kselftest/arm64: Fix check for setting new VLs in sve-ptrace

Eric Dumazet <edumazet@google.com>
    net: dst: annotate data-races around dst->output

Eric Dumazet <edumazet@google.com>
    net: dst: annotate data-races around dst->input

Stav Aviram <saviram@nvidia.com>
    net/mlx5: Check device memory pointer before usage

xin.guo <guoxin0309@gmail.com>
    tcp: fix tcp_ofo_queue() to avoid including too much DUP SACK range

Sergey Senozhatsky <senozhatsky@chromium.org>
    wifi: ath11k: clear initialized flag for deinit-ed srng lists

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    iwlwifi: Add missing check for alloc_ordered_workqueue

Xiu Jianfeng <xiujianfeng@huawei.com>
    wifi: iwlwifi: Fix memory leak in iwl_mvm_init()

Daniil Dulov <d.dulov@aladdin.ru>
    wifi: rtl818x: Kill URBs before clearing tx status queue

Zong-Zhe Yang <kevin_yang@realtek.com>
    wifi: rtw89: avoid NULL dereference when RX problematic packet on unsupported 6 GHz band

Arnd Bergmann <arnd@arndb.de>
    caif: reduce stack size, again

Haren Myneni <haren@linux.ibm.com>
    powerpc/pseries/dlpar: Search DRC index from ibm,drc-indexes for IO add

Yuan Chen <chenyuan@kylinos.cn>
    bpftool: Fix memory leak in dump_xx_nlmsg on realloc failure

Lijo Lazar <lijo.lazar@amd.com>
    drm/amdgpu: Remove nbiov7.9 replay count reporting

Ian Forbes <ian.forbes@broadcom.com>
    drm/vmwgfx: Fix Host-Backed userspace on Guest-Backed kernel

Petr Machata <petrm@nvidia.com>
    net: ipv6: ip6mr: Fix in/out netdev to pass to the FORWARD chain

Mykyta Yatsenko <yatsenko@meta.com>
    selftests/bpf: Fix unintentional switch case fall through

Fushuai Wang <wangfushuai@baidu.com>
    selftests/bpf: fix signedness bug in redir_partial()

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf, ktls: Fix data corruption when using bpf_msg_pop_data() in ktls

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf, sockmap: Fix psock incorrectly pointing to sk

Boris Brezillon <boris.brezillon@collabora.com>
    drm/panthor: Add missing explicit padding in drm_panthor_gpu_info

Adrián Larumbe <adrian.larumbe@collabora.com>
    drm/panfrost: Fix panfrost device variable name in devfreq

Andy Yan <andy.yan@rock-chips.com>
    drm/rockchip: cleanup fb when drm_gem_fb_afbc_init failed

Steven Rostedt <rostedt@goodmis.org>
    selftests/tracing: Fix false failure of subsystem event test

Alok Tiwari <alok.a.tiwari@oracle.com>
    staging: nvec: Fix incorrect null termination of battery manufacturer

Slark Xiao <slark_xiao@163.com>
    bus: mhi: host: pci_generic: Fix the modem name of Foxconn T99W640

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    interconnect: qcom: sc8180x: specify num_nodes

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    interconnect: qcom: sc8280xp: specify num_links for qnm_a1noc_cfg

Johan Hovold <johan@kernel.org>
    soc: qcom: pmic_glink: fix OF node leak

Brahmajit Das <listout@listout.xyz>
    samples: mei: Fix building on musl libc

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    staging: greybus: gbphy: fix up const issue with the match callback

Lifeng Zheng <zhenglifeng1@huawei.com>
    cpufreq: Init policy->rwsem before it may be possibly used

Lifeng Zheng <zhenglifeng1@huawei.com>
    cpufreq: Initialize cpufreq-based frequency-invariance later

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: intel_pstate: Always use HWP_DESIRED_PERF in passive mode

Chanwoo Choi <cw00.choi@samsung.com>
    PM / devfreq: Fix a index typo in trans_stat

Lifeng Zheng <zhenglifeng1@huawei.com>
    PM / devfreq: Check governor before using governor->name

Adam Ford <aford173@gmail.com>
    arm64: dts: imx8mn-beacon: Fix HS400 USDHC clock speed

Adam Ford <aford173@gmail.com>
    arm64: dts: imx8mm-beacon: Fix HS400 USDHC clock speed

Annette Kobou <annette.kobou@kontron.de>
    ARM: dts: imx6ul-kontron-bl-common: Fix RTS polarity for RS485 interface

Moon Hee Lee <moonhee.lee.ca@gmail.com>
    selftests: breakpoints: use suspend_stats to reliably check suspend success

Patrick Delaunay <patrick.delaunay@foss.st.com>
    arm64: dts: st: fix timer used for ticks

Sumit Gupta <sumitg@nvidia.com>
    soc/tegra: cbb: Clear ERR_FORCE register with ERR_STATUS

Albin Törnqvist <albin.tornqvist@codiax.se>
    arm: dts: ti: omap: Fixup pinheader typo

Lucas De Marchi <lucas.demarchi@intel.com>
    usb: early: xhci-dbc: Fix early_ioremap leak

Sivan Zohar-Kotzer <sivany32@gmail.com>
    powercap: dtpm_cpu: Fix NULL pointer dereference in get_pd_power_uw()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "vmci: Prevent the dispatching of uninitialized payloads"

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    selftests: vDSO: chacha: Correctly skip test if necessary

Denis OSTERLAND-HEIM <denis.osterland@diehl.com>
    pps: fix poll support

Lizhi Xu <lizhi.xu@windriver.com>
    vmci: Prevent the dispatching of uninitialized payloads

Abdun Nihaal <abdun.nihaal@gmail.com>
    staging: fbtft: fix potential memory leak in fbtft_framebuffer_alloc()

Clément Le Goffic <clement.legoffic@foss.st.com>
    spi: stm32: Check for cfg availability in stm32_spi_probe

Hans de Goede <hansg@kernel.org>
    mei: vsc: Unset the event callback on remove and probe errors

Hans de Goede <hansg@kernel.org>
    mei: vsc: Event notifier fixes

Hans de Goede <hansg@kernel.org>
    mei: vsc: Destroy mutex after freeing the IRQ

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    usb: typec: ucsi: yoga-c630: fix error and remove paths

Sibi Sankar <quic_sibis@quicinc.com>
    firmware: arm_scmi: Fix up turbo frequencies selection

Arnd Bergmann <arnd@arndb.de>
    cpufreq: armada-8k: make both cpu masks static

Michael Walle <mwalle@kernel.org>
    arm64: dts: ti: k3-am62p-j722s: fix pinctrl-single size

Wadim Egorov <w.egorov@phytec.de>
    arm64: dts: ti: k3-am642-phyboard-electra: Fix PRU-ICSSG Ethernet ports

Charalampos Mitrodimas <charmitro@posteo.net>
    usb: misc: apple-mfi-fastcharge: Make power supply names unique

Seungjin Bae <eeodqql09@gmail.com>
    usb: host: xhci-plat: fix incorrect type for of_match variable in xhci_plat_probe()

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: vfxxx: Correctly use two tuples for timer address

André Apitzsch <git@apitzsch.eu>
    arm64: dts: qcom: msm8976: Make blsp_dma controlled-remotely

Lijuan Gao <lijuan.gao@oss.qualcomm.com>
    arm64: dts: qcom: sa8775p: Correct the interrupt for remoteproc

Will Deacon <willdeacon@google.com>
    arm64: dts: exynos: gs101: Add 'local-timer-stop' to cpuidle nodes

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    arm64: dts: qcom: sc7180: Expand IMEM region

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    arm64: dts: qcom: sdm845: Expand IMEM region

Alexander Wilhelm <alexander.wilhelm@westermo.com>
    soc: qcom: QMI encoding/decoding for big endian

Dmitry Vyukov <dvyukov@google.com>
    selftests: Fix errno checking in syscall_user_dispatch test

Alexander Stein <alexander.stein@ew.tq-group.com>
    arm64: dts: freescale: imx93-tqma9352: Limit BUCK2 to 600mV

Chen-Yu Tsai <wenst@chromium.org>
    ASoC: mediatek: use reserved memory or enable buffer pre-allocation

Arnd Bergmann <arnd@arndb.de>
    ASoC: ops: dynamically allocate struct snd_ctl_elem_value

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: soc-dai: tidyup return value of snd_soc_xlate_tdm_slot_mask()

Randy Dunlap <rdunlap@infradead.org>
    io_uring: fix breakage in EXPERT menu

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: No more self recovery

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    Revert "fs/ntfs3: Replace inode_trylock with inode_lock"

Yangtao Li <frank.li@vivo.com>
    hfsplus: remove mutex_lock check in hfsplus_free_extents

Yangtao Li <frank.li@vivo.com>
    hfs: make splice write available again

Yangtao Li <frank.li@vivo.com>
    hfsplus: make splice write available again

Caleb Sander Mateos <csander@purestorage.com>
    ublk: use vmalloc for ublk_device's __queues

Edward Adam Davis <eadavis@qq.com>
    fs/ntfs3: cancle set bad inode after removing name fails

RubenKelevra <rubenkelevra@gmail.com>
    fs_context: fix parameter name in infofc() macro

Al Viro <viro@zeniv.linux.org.uk>
    parse_longname(): strrchr() expects NUL-terminated string

Richard Guy Briggs <rgb@redhat.com>
    audit,module: restore audit logging in load failure case

Alexandru Andries <alex.andries.aa@gmail.com>
    ASoC: amd: yc: add DMI quirk for ASUS M6501RM

Arnd Bergmann <arnd@arndb.de>
    ASoC: Intel: fix SND_SOC_SOF dependencies

Richard Fitzgerald <rf@opensource.cirrus.com>
    ALSA: hda/cs35l56: Workaround bad dev-index on Lenovo Yoga Book 9i GenX

Adam Queler <queler@gmail.com>
    ASoC: amd: yc: Add DMI entries to support HP 15-fb1xxx

Arnd Bergmann <arnd@arndb.de>
    ethernet: intel: fix building with large NR_CPUS

Lane Odenbach <laodenbach@gmail.com>
    ASoC: amd: yc: Add DMI quirk for HP Laptop 17 cp-2033dx


-------------

Diffstat:

 Documentation/filesystems/f2fs.rst                 |   6 +-
 Documentation/netlink/specs/ethtool.yaml           |   6 +-
 Makefile                                           |   4 +-
 .../boot/dts/nxp/imx/imx6ul-kontron-bl-common.dtsi |   1 -
 arch/arm/boot/dts/nxp/vf/vfxxx.dtsi                |   2 +-
 arch/arm/boot/dts/ti/omap/am335x-boneblack.dts     |   2 +-
 arch/arm/crypto/aes-neonbs-glue.c                  |   2 +-
 arch/arm64/boot/dts/exynos/google/gs101.dtsi       |   3 +
 .../boot/dts/freescale/imx8mm-beacon-som.dtsi      |   2 +
 .../boot/dts/freescale/imx8mn-beacon-som.dtsi      |   2 +
 arch/arm64/boot/dts/freescale/imx93-tqma9352.dtsi  |   6 +-
 arch/arm64/boot/dts/qcom/msm8976.dtsi              |   2 +
 arch/arm64/boot/dts/qcom/sa8775p.dtsi              |  10 +-
 arch/arm64/boot/dts/qcom/sc7180.dtsi               |  10 +-
 arch/arm64/boot/dts/qcom/sdm845.dtsi               |  10 +-
 arch/arm64/boot/dts/st/stm32mp251.dtsi             |   2 +-
 .../boot/dts/ti/k3-am62p-j722s-common-main.dtsi    |   2 +-
 .../boot/dts/ti/k3-am642-phyboard-electra-rdk.dts  |   2 +
 arch/arm64/net/bpf_jit_comp.c                      |   1 +
 arch/m68k/Kconfig.debug                            |   2 +-
 arch/m68k/kernel/early_printk.c                    |  42 +--
 arch/m68k/kernel/head.S                            |   8 +-
 arch/mips/mm/tlb-r4k.c                             |  56 +++-
 arch/powerpc/configs/ppc6xx_defconfig              |   1 -
 arch/powerpc/kernel/eeh.c                          |   1 +
 arch/powerpc/kernel/eeh_driver.c                   |  48 ++--
 arch/powerpc/kernel/eeh_pe.c                       |  10 +-
 arch/powerpc/kernel/pci-hotplug.c                  |   3 +
 arch/powerpc/platforms/pseries/dlpar.c             |  52 +++-
 arch/s390/include/asm/ap.h                         |   2 +-
 arch/s390/mm/pgalloc.c                             |   5 -
 arch/s390/mm/vmem.c                                |   5 +-
 arch/sh/Makefile                                   |  10 +-
 arch/sh/boot/compressed/Makefile                   |   4 +-
 arch/sh/boot/romimage/Makefile                     |   4 +-
 arch/um/drivers/rtc_user.c                         |   2 +-
 arch/x86/boot/cpuflags.c                           |  13 +
 arch/x86/coco/sev/shared.c                         |  46 ++++
 arch/x86/include/asm/cpufeatures.h                 |   1 +
 arch/x86/include/asm/hw_irq.h                      |  12 +-
 arch/x86/kernel/cpu/scattered.c                    |   1 +
 arch/x86/kernel/irq.c                              |  63 +++--
 arch/x86/mm/extable.c                              |   5 +-
 block/blk-settings.c                               |  13 +-
 drivers/accel/ivpu/ivpu_debugfs.c                  |  42 +--
 drivers/block/ublk_drv.c                           |   4 +-
 drivers/bluetooth/btusb.c                          |   4 +
 drivers/bus/mhi/host/pci_generic.c                 |   8 +-
 drivers/char/hw_random/mtk-rng.c                   |   4 +-
 drivers/clk/at91/sam9x7.c                          |  20 +-
 drivers/clk/clk-axi-clkgen.c                       |   2 +-
 drivers/clk/davinci/psc.c                          |   5 +
 drivers/clk/imx/clk-imx95-blk-ctl.c                |  13 +-
 drivers/clk/renesas/rzv2h-cpg.c                    |   1 +
 drivers/clk/sunxi-ng/ccu-sun8i-v3s.c               |   3 +-
 drivers/clk/thead/clk-th1520-ap.c                  |   9 +-
 drivers/clk/xilinx/xlnx_vcu.c                      |   4 +-
 drivers/cpufreq/armada-8k-cpufreq.c                |   3 +-
 drivers/cpufreq/cpufreq.c                          |  21 +-
 drivers/cpufreq/intel_pstate.c                     |   4 +-
 .../crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c    |   4 +-
 drivers/crypto/ccp/ccp-debugfs.c                   |   3 +
 drivers/crypto/ccp/sev-dev.c                       |   8 +-
 drivers/crypto/img-hash.c                          |   2 +-
 drivers/crypto/inside-secure/safexcel_hash.c       |   8 +-
 .../crypto/intel/keembay/keembay-ocs-hcu-core.c    |   8 +-
 .../crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c |   9 +-
 .../crypto/intel/qat/qat_common/adf_gen4_hw_data.c |  29 +-
 drivers/crypto/intel/qat/qat_common/adf_sriov.c    |   1 -
 .../intel/qat/qat_common/adf_transport_debug.c     |   4 +-
 drivers/crypto/intel/qat/qat_common/qat_bl.c       |   6 +-
 .../crypto/intel/qat/qat_common/qat_compression.c  |   8 +-
 drivers/crypto/marvell/cesa/cipher.c               |   4 +-
 drivers/crypto/marvell/cesa/hash.c                 |   5 +-
 drivers/devfreq/devfreq.c                          |  12 +-
 drivers/dma/mmp_tdma.c                             |   2 +-
 drivers/dma/mv_xor.c                               |  21 +-
 drivers/dma/nbpfaxi.c                              |  13 +
 drivers/firmware/arm_scmi/perf.c                   |   2 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c             |   6 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c              |   2 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c            |   3 +-
 drivers/gpu/drm/amd/amdgpu/nbio_v7_9.c             |  20 --
 .../gpu/drm/amd/pm/powerplay/hwmgr/smu_helper.c    |   2 +-
 drivers/gpu/drm/i915/display/g4x_hdmi.c            |  35 ++-
 drivers/gpu/drm/i915/display/g4x_hdmi.h            |   5 +-
 drivers/gpu/drm/i915/display/intel_ddi.c           |  37 ++-
 drivers/gpu/drm/i915/display/intel_display_types.h |  13 +
 drivers/gpu/drm/i915/display/intel_hdmi.c          |  10 +-
 drivers/gpu/drm/i915/display/intel_hdmi.h          |   2 +-
 .../drm/msm/disp/dpu1/catalog/dpu_5_1_sc8180x.h    |   1 +
 drivers/gpu/drm/panfrost/panfrost_devfreq.c        |   4 +-
 drivers/gpu/drm/rockchip/rockchip_drm_fb.c         |   9 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_shader.c             |   2 +-
 drivers/gpu/drm/xe/xe_device.c                     |   1 +
 drivers/hid/hid-apple.c                            |   3 +-
 drivers/i2c/muxes/i2c-mux-mule.c                   |   3 +-
 drivers/infiniband/hw/erdma/erdma_verbs.c          |   3 +-
 drivers/infiniband/hw/hns/hns_roce_device.h        |   1 +
 drivers/infiniband/hw/hns/hns_roce_hem.c           |  18 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |  87 ++++--
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h         |   8 +-
 drivers/infiniband/hw/hns/hns_roce_main.c          |  22 +-
 drivers/infiniband/hw/mana/qp.c                    |   2 +-
 drivers/infiniband/hw/mlx5/dm.c                    |   2 +-
 drivers/infiniband/hw/mlx5/umr.c                   |   6 +-
 drivers/interconnect/qcom/sc8180x.c                |   6 +
 drivers/interconnect/qcom/sc8280xp.c               |   1 +
 drivers/iommu/amd/iommu.c                          |  19 +-
 drivers/irqchip/Kconfig                            |   1 +
 drivers/md/bcache/alloc.c                          |  64 ++---
 drivers/md/bcache/bcache.h                         |   2 +-
 drivers/md/bcache/bset.c                           | 124 ++++-----
 drivers/md/bcache/bset.h                           |  40 +--
 drivers/md/bcache/btree.c                          |  69 ++---
 drivers/md/bcache/extents.c                        |  51 ++--
 drivers/md/bcache/movinggc.c                       |  41 +--
 drivers/md/bcache/super.c                          |   3 +-
 drivers/md/bcache/sysfs.c                          |   4 +-
 drivers/md/bcache/util.h                           |  67 ++++-
 drivers/md/bcache/writeback.c                      |  13 +-
 drivers/md/md.c                                    |   9 +-
 .../media/platform/ti/j721e-csi2rx/j721e-csi2rx.c  |   1 +
 drivers/media/v4l2-core/v4l2-ctrls-core.c          |   8 +-
 drivers/misc/mei/platform-vsc.c                    |   5 +
 drivers/misc/mei/vsc-tp.c                          |  20 +-
 drivers/mtd/ftl.c                                  |   2 +-
 drivers/mtd/nand/raw/atmel/nand-controller.c       |   2 +-
 drivers/mtd/nand/raw/atmel/pmecc.c                 |   6 +
 drivers/mtd/nand/raw/rockchip-nand-controller.c    |  15 ++
 drivers/mtd/spi-nor/spansion.c                     |  31 +++
 drivers/net/can/kvaser_pciefd.c                    |   1 +
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c   |   1 +
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c         |  17 +-
 drivers/net/dsa/microchip/ksz8.c                   |   3 +
 drivers/net/dsa/microchip/ksz8_reg.h               |   4 +-
 drivers/net/ethernet/emulex/benet/be_cmds.c        |   2 +-
 drivers/net/ethernet/intel/fm10k/fm10k.h           |   3 +-
 drivers/net/ethernet/intel/i40e/i40e.h             |   2 +-
 drivers/net/ethernet/intel/ice/ice_ptp.c           |   1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe.h           |   3 +-
 .../ethernet/mellanox/mlx5/core/en/port_buffer.c   |   3 +
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.c       |   4 +
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/lib/dm.c   |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   3 -
 drivers/net/ethernet/meta/fbnic/fbnic_txrx.c       |   4 +-
 drivers/net/ethernet/meta/fbnic/fbnic_txrx.h       |   6 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   2 +-
 drivers/net/ipa/ipa_sysfs.c                        |   6 +-
 drivers/net/mdio/mdio-bcm-unimac.c                 |   5 +-
 drivers/net/phy/mscc/mscc_ptp.c                    |   1 +
 drivers/net/phy/mscc/mscc_ptp.h                    |   1 +
 drivers/net/ppp/pptp.c                             |  18 +-
 drivers/net/usb/usbnet.c                           |  11 +-
 drivers/net/vrf.c                                  |   2 +
 drivers/net/wireless/ath/ath11k/hal.c              |   4 +
 drivers/net/wireless/ath/ath11k/mac.c              |  12 +-
 drivers/net/wireless/ath/ath12k/wmi.c              |  12 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |   8 +-
 drivers/net/wireless/intel/iwlwifi/dvm/main.c      |  11 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   4 +-
 drivers/net/wireless/marvell/mwl8k.c               |   4 +
 drivers/net/wireless/purelifi/plfxlc/mac.c         |  11 +-
 drivers/net/wireless/purelifi/plfxlc/mac.h         |   2 +-
 drivers/net/wireless/purelifi/plfxlc/usb.c         |  29 +-
 drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c |   3 +-
 drivers/net/wireless/realtek/rtl8xxxu/core.c       |   2 +-
 drivers/net/wireless/realtek/rtw88/main.c          |   4 +-
 drivers/net/wireless/realtek/rtw89/core.c          |   5 +
 drivers/nvme/target/core.c                         |  18 +-
 drivers/pci/controller/pcie-rockchip-host.c        |   2 +-
 drivers/pci/endpoint/functions/pci-epf-vntb.c      |   4 +-
 drivers/pci/hotplug/pnv_php.c                      | 235 ++++++++++++++--
 drivers/pci/pcie/aspm.c                            |  32 ++-
 drivers/perf/arm-ni.c                              |   2 +
 drivers/phy/qualcomm/phy-qcom-eusb2-repeater.c     |  83 +++---
 drivers/pinctrl/berlin/berlin.c                    |   8 +-
 drivers/pinctrl/pinmux.c                           |  20 +-
 drivers/pinctrl/sunxi/pinctrl-sunxi.c              |  11 +-
 drivers/platform/x86/intel/pmt/class.c             |   3 +-
 drivers/platform/x86/intel/pmt/class.h             |   1 +
 drivers/power/supply/cpcap-charger.c               |   5 +-
 drivers/power/supply/max14577_charger.c            |   4 +-
 drivers/powercap/dtpm_cpu.c                        |   2 +
 drivers/pps/pps.c                                  |  11 +-
 drivers/remoteproc/xlnx_r5_remoteproc.c            |   2 +
 drivers/rtc/rtc-ds1307.c                           |   2 +-
 drivers/rtc/rtc-hym8563.c                          |   2 +-
 drivers/rtc/rtc-nct3018y.c                         |   2 +-
 drivers/rtc/rtc-pcf85063.c                         |   2 +-
 drivers/rtc/rtc-pcf8563.c                          |   2 +-
 drivers/rtc/rtc-rv3028.c                           |   2 +-
 drivers/s390/crypto/ap_bus.h                       |   2 +-
 drivers/scsi/elx/efct/efct_lio.c                   |   2 +-
 drivers/scsi/ibmvscsi_tgt/libsrp.c                 |   6 +-
 drivers/scsi/isci/request.c                        |   2 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c               |   3 +-
 drivers/scsi/mvsas/mv_sas.c                        |   4 +-
 drivers/scsi/scsi_transport_iscsi.c                |   2 +
 drivers/scsi/sd.c                                  |   4 +-
 drivers/soc/qcom/pmic_glink.c                      |   9 +-
 drivers/soc/qcom/qmi_encdec.c                      |  46 +++-
 drivers/soc/tegra/cbb/tegra234-cbb.c               |   2 +
 drivers/soundwire/stream.c                         |   2 +-
 drivers/spi/spi-cs42l43.c                          |   2 +-
 drivers/spi/spi-stm32.c                            |   8 +-
 drivers/staging/fbtft/fbtft-core.c                 |   1 +
 drivers/staging/greybus/gbphy.c                    |   6 +-
 .../media/atomisp/pci/atomisp_gmin_platform.c      |   9 +-
 drivers/staging/nvec/nvec_power.c                  |   2 +-
 drivers/ufs/core/ufshcd.c                          |  10 +-
 drivers/usb/early/xhci-dbc.c                       |   4 +
 drivers/usb/gadget/composite.c                     |   5 +
 drivers/usb/gadget/function/f_hid.c                |   7 +-
 drivers/usb/host/xhci-plat.c                       |   2 +-
 drivers/usb/misc/apple-mfi-fastcharge.c            |  24 +-
 drivers/usb/serial/option.c                        |   2 +
 drivers/usb/typec/ucsi/ucsi_yoga_c630.c            |  19 +-
 drivers/vdpa/mlx5/core/mr.c                        |   3 +
 drivers/vdpa/mlx5/net/mlx5_vnet.c                  |  12 +-
 drivers/vdpa/vdpa_user/vduse_dev.c                 |   1 +
 drivers/vfio/group.c                               |   7 +-
 drivers/vfio/iommufd.c                             |   4 +
 drivers/vfio/pci/pds/vfio_dev.c                    |   1 +
 drivers/vfio/pci/vfio_pci_core.c                   |   2 +-
 drivers/vfio/vfio_main.c                           |   3 +-
 drivers/vhost/Kconfig                              |  18 ++
 drivers/vhost/scsi.c                               |   4 +-
 drivers/vhost/vhost.c                              | 244 +++++++++++++++--
 drivers/vhost/vhost.h                              |  22 ++
 drivers/video/fbdev/core/fbcon.c                   |   4 +-
 drivers/video/fbdev/imxfb.c                        |   9 +-
 drivers/watchdog/ziirave_wdt.c                     |   3 +
 drivers/xen/gntdev-common.h                        |   4 +
 drivers/xen/gntdev-dmabuf.c                        |  28 +-
 drivers/xen/gntdev.c                               |  71 +++--
 fs/ceph/crypto.c                                   |  31 +--
 fs/exfat/file.c                                    |   5 +-
 fs/ext4/inline.c                                   |   2 +
 fs/ext4/inode.c                                    |   3 +-
 fs/f2fs/data.c                                     |   7 +-
 fs/f2fs/extent_cache.c                             |   2 +-
 fs/f2fs/f2fs.h                                     |   2 +-
 fs/f2fs/gc.c                                       |   1 +
 fs/f2fs/inode.c                                    |  21 +-
 fs/f2fs/segment.h                                  |   5 +-
 fs/f2fs/super.c                                    |   1 +
 fs/f2fs/sysfs.c                                    |  21 ++
 fs/gfs2/util.c                                     |  37 +--
 fs/hfs/inode.c                                     |   1 +
 fs/hfsplus/extents.c                               |   3 -
 fs/hfsplus/inode.c                                 |   1 +
 fs/jfs/jfs_dmap.c                                  |   4 +-
 fs/nfs/dir.c                                       |   4 +-
 fs/nfs/export.c                                    |  11 +-
 fs/nfs/flexfilelayout/flexfilelayout.c             |  26 +-
 fs/nfs/flexfilelayout/flexfilelayoutdev.c          |   6 +-
 fs/nfs/internal.h                                  |   9 +-
 fs/nfs/nfs4proc.c                                  |  10 +-
 fs/notify/fanotify/fanotify.c                      |   8 +-
 fs/ntfs3/file.c                                    |   5 +-
 fs/ntfs3/frecord.c                                 |   7 +-
 fs/ntfs3/namei.c                                   |  10 +-
 fs/ntfs3/ntfs_fs.h                                 |   3 +-
 fs/orangefs/orangefs-debugfs.c                     |   6 +-
 fs/proc/generic.c                                  |   2 +
 fs/proc/inode.c                                    |   2 +-
 fs/proc/internal.h                                 |   5 +
 fs/smb/client/cifs_debug.c                         |   6 +-
 fs/smb/client/smbdirect.c                          | 130 +++------
 fs/smb/client/smbdirect.h                          |   4 -
 fs/smb/server/connection.h                         |   1 +
 fs/smb/server/smb2pdu.c                            |  22 +-
 fs/smb/server/smb_common.c                         |   2 +-
 fs/smb/server/transport_rdma.c                     |  97 +++----
 fs/smb/server/transport_tcp.c                      |  17 ++
 fs/smb/server/vfs.c                                |   3 +-
 include/linux/audit.h                              |   9 +-
 include/linux/fortify-string.h                     |   2 +-
 include/linux/fs_context.h                         |   2 +-
 include/linux/ioprio.h                             |   3 +-
 include/linux/mlx5/device.h                        |   1 +
 include/linux/moduleparam.h                        |   5 +-
 include/linux/pps_kernel.h                         |   1 +
 include/linux/proc_fs.h                            |   1 +
 include/linux/psi_types.h                          |   6 +-
 include/linux/ring_buffer.h                        |   4 +-
 include/linux/skbuff.h                             |  23 ++
 include/linux/usb/usbnet.h                         |   1 +
 include/linux/wait_bit.h                           |  60 +++++
 include/net/bluetooth/hci.h                        |   1 +
 include/net/bluetooth/hci_core.h                   |   6 +
 include/net/dst.h                                  |   4 +-
 include/net/lwtunnel.h                             |   8 +-
 include/net/tc_act/tc_ctinfo.h                     |   6 +-
 include/net/udp.h                                  |  24 +-
 include/sound/tas2781-tlv.h                        |   2 +-
 include/uapi/drm/panthor_drm.h                     |   3 +
 include/uapi/linux/vhost.h                         |  29 ++
 init/Kconfig                                       |   2 +-
 kernel/audit.h                                     |   2 +-
 kernel/auditsc.c                                   |   2 +-
 kernel/bpf/core.c                                  |   5 +-
 kernel/bpf/helpers.c                               |  11 +-
 kernel/bpf/preload/Kconfig                         |   1 -
 kernel/events/core.c                               |  20 +-
 kernel/kcsan/kcsan_test.c                          |   2 +-
 kernel/module/main.c                               |   6 +-
 kernel/rcu/refscale.c                              |  10 +-
 kernel/rcu/tree_nocb.h                             |   2 +-
 kernel/sched/psi.c                                 | 123 +++++----
 kernel/trace/preemptirq_delay_test.c               |  13 +-
 kernel/trace/ring_buffer.c                         |  63 +----
 kernel/trace/trace.c                               |  14 +-
 kernel/trace/trace_kdb.c                           |   8 +-
 kernel/ucount.c                                    |   2 +-
 mm/hmm.c                                           |   2 +-
 mm/swapfile.c                                      |  63 ++---
 net/bluetooth/hci_event.c                          |   8 +-
 net/caif/cfctrl.c                                  | 294 ++++++++++-----------
 net/core/dst.c                                     |   4 +-
 net/core/filter.c                                  |   3 +
 net/core/netpoll.c                                 |   7 +
 net/core/skmsg.c                                   |   7 +
 net/ipv4/route.c                                   |   4 +-
 net/ipv4/tcp_input.c                               |   4 +-
 net/ipv6/ip6_fib.c                                 |  24 +-
 net/ipv6/ip6_offload.c                             |   4 +-
 net/ipv6/ip6mr.c                                   |   3 +-
 net/ipv6/route.c                                   |  60 +++--
 net/mac80211/cfg.c                                 |   2 +-
 net/mac80211/tdls.c                                |   2 +-
 net/mac80211/tx.c                                  |  14 +-
 net/netfilter/nf_bpf_link.c                        |   5 +-
 net/netfilter/nf_tables_api.c                      |  29 +-
 net/netfilter/xt_nfacct.c                          |   4 +-
 net/packet/af_packet.c                             |  12 +-
 net/sched/act_ctinfo.c                             |  19 +-
 net/sched/sch_mqprio.c                             |   2 +-
 net/sched/sch_netem.c                              |  40 +++
 net/sched/sch_taprio.c                             |  21 +-
 net/sunrpc/svcsock.c                               |  43 ++-
 net/sunrpc/xprtsock.c                              |  40 ++-
 net/tls/tls_sw.c                                   |  13 +
 net/vmw_vsock/af_vsock.c                           |   3 +-
 net/wireless/nl80211.c                             |   1 +
 samples/mei/mei-amt-version.c                      |   2 +-
 scripts/kconfig/qconf.cc                           |   2 +-
 security/apparmor/include/match.h                  |   8 +-
 security/apparmor/match.c                          |  23 +-
 security/apparmor/policy_unpack_test.c             |   6 +-
 sound/pci/hda/cs35l56_hda.c                        | 114 +++++---
 sound/pci/hda/patch_ca0132.c                       |   5 +-
 sound/pci/hda/patch_realtek.c                      |   3 +
 sound/soc/amd/yc/acp6x-mach.c                      |  21 ++
 sound/soc/fsl/fsl_xcvr.c                           |  20 ++
 sound/soc/intel/boards/Kconfig                     |   2 +-
 .../soc/mediatek/common/mtk-afe-platform-driver.c  |   4 +-
 sound/soc/mediatek/common/mtk-base-afe.h           |   1 +
 sound/soc/mediatek/mt8173/mt8173-afe-pcm.c         |   7 +
 sound/soc/mediatek/mt8183/mt8183-afe-pcm.c         |   7 +
 sound/soc/mediatek/mt8186/mt8186-afe-pcm.c         |   7 +
 sound/soc/mediatek/mt8192/mt8192-afe-pcm.c         |   7 +
 sound/soc/soc-dai.c                                |  16 +-
 sound/soc/soc-ops.c                                |  28 +-
 sound/usb/mixer_scarlett2.c                        |   7 +
 sound/x86/intel_hdmi_audio.c                       |   2 +-
 tools/bpf/bpftool/net.c                            |  15 +-
 tools/cgroup/memcg_slabinfo.py                     |   4 +-
 tools/lib/subcmd/help.c                            |  12 +-
 tools/perf/.gitignore                              |   2 -
 tools/perf/builtin-sched.c                         |  99 +++++--
 tools/perf/tests/bp_account.c                      |   1 +
 tools/perf/util/build-id.c                         |   2 +-
 tools/perf/util/evsel.c                            |  11 +
 tools/perf/util/evsel.h                            |   2 +
 tools/perf/util/symbol.c                           |   1 +
 tools/testing/selftests/alsa/utimer-test.c         |   1 +
 tools/testing/selftests/arm64/fp/sve-ptrace.c      |   2 +-
 .../selftests/bpf/prog_tests/sockmap_listen.c      |   2 +
 .../selftests/bpf/progs/verifier_arena_large.c     | 110 +++++++-
 tools/testing/selftests/bpf/veristat.c             |   1 +
 .../breakpoints/step_after_suspend_test.c          |  41 ++-
 tools/testing/selftests/drivers/net/lib/py/env.py  |   2 +-
 .../ftrace/test.d/event/subsystem-enable.tc        |  28 +-
 tools/testing/selftests/net/rtnetlink.sh           |   6 +
 tools/testing/selftests/perf_events/.gitignore     |   1 +
 tools/testing/selftests/perf_events/Makefile       |   2 +-
 tools/testing/selftests/perf_events/mmap.c         | 236 +++++++++++++++++
 .../selftests/syscall_user_dispatch/sud_test.c     |  50 ++--
 tools/testing/selftests/vDSO/vdso_test_chacha.c    |   3 +-
 tools/verification/rv/src/in_kernel.c              |   4 +-
 393 files changed, 3781 insertions(+), 1906 deletions(-)



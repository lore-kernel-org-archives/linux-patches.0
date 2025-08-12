Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E91A6BB5B;
	Tue, 12 Aug 2025 18:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023270; cv=none; b=W3hxGFknSNh6pTINWpvUuoO2/NSq2e2CbTi+olB4Bz5maQ/ft/KxvZLXNNBaKN/UrScBWxe/2KvxvcY/6GZQpR6YEfWlk8wb2gNyA4xccktmd32KRChNLxXEfwhWdiJkDaj052drv9h6MJDDd7rwa3BuNatPYTlfo8vdWHYceLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023270; c=relaxed/simple;
	bh=6Fuxvlwz76VEeyJeXpTNojn8NSSt3BHevEv8vRyUBAM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=KefqpZWglbcSARqei3b1AYu/stkq+CRtKP4x8ZyBYL86G1GQNH7G36C5iZeg4XpJdH+TotFIs4tmmovbjUSmir/yQNcoUaoeufFTQOY93C0rv/qKP0kVABNJ4xcIFWxkzj+65qeC94XAXWe78FiWAClvvkXTpNAWEFozKpS9g44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ycwrcry4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ycwrcry4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06397C4CEF0;
	Tue, 12 Aug 2025 18:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023269;
	bh=6Fuxvlwz76VEeyJeXpTNojn8NSSt3BHevEv8vRyUBAM=;
	h=From:To:Cc:Subject:Date:From;
	b=ycwrcry4PeHh0B+wohjo8qbcc0O+BHaI2Dd7pO42VDQN2y7tDrJU25a2zxxGS0BWU
	 JVYnmSEjVIFvQqgsP8RSj//4WVbtRSyhbbIFCTW3pG/hlSf6/7DGLEFtJ4wZIMGmsa
	 szZjUGTfu5P/0gp3EM03yA77igQxL61g68aaxCcE=
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
Subject: [PATCH 6.16 000/627] 6.16.1-rc1 review
Date: Tue, 12 Aug 2025 19:24:55 +0200
Message-ID: <20250812173419.303046420@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.1-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.16.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.16.1-rc1
X-KernelTest-Deadline: 2025-08-14T17:34+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.16.1 release.
There are 627 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 14 Aug 2025 17:32:40 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.1-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.16.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.16.1-rc1

Suren Baghdasaryan <surenb@google.com>
    mm: fix a UAF when vma->mm is freed after vma->vm_refcnt got dropped

Baochen Qiang <quic_bqiang@quicinc.com>
    wifi: ath12k: install pairwise key first

Tao Xue <xuetao09@huawei.com>
    usb: gadget : fix use-after-free in composite_dev_cleanup()

Aditya Garg <gargaditya08@live.com>
    HID: apple: avoid setting up battery timer for devices without battery

Aditya Garg <gargaditya08@live.com>
    HID: magicmouse: avoid setting up battery timer when not needed

Alan Stern <stern@rowland.harvard.edu>
    HID: core: Harden s32ton() against conversion to 0 bits

Yuhao Jiang <danisjiang@gmail.com>
    USB: gadget: f_hid: Fix memory leak in hidg_bind error path

Qasim Ijaz <qasdev00@gmail.com>
    HID: apple: validate feature-report field count to prevent NULL pointer dereference

Julien Massot <julien.massot@collabora.com>
    media: ti: j721e-csi2rx: fix list_del corruption

Robin Murphy <robin.murphy@arm.com>
    perf/arm-ni: Set initial IRQ affinity

Akash Kumar <quic_akakum@quicinc.com>
    usb: gadget: uvc: Initialize frame-based format color matching descriptor

Baolin Wang <baolin.wang@linux.alibaba.com>
    mm: shmem: fix the shmem large folio allocation for the i915 driver

Kemeng Shi <shikemeng@huaweicloud.com>
    mm: swap: move nr_swap_pages counter decrement from folio_alloc_swap() to swap_range_alloc()

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

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    zloop: fix KASAN use-after-free of tag set

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Filter out HCR_EL2 bits when running in hypervisor context

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Check for SYSREGS_ON_CPU before accessing the CPU state

Sean Christopherson <seanjc@google.com>
    KVM: VMX: Allow guest to set DEBUGCTL.RTM_DEBUG if RTM is supported

Sean Christopherson <seanjc@google.com>
    KVM: x86: Drop kvm_x86_ops.set_dr6() in favor of a new KVM_RUN flag

Sean Christopherson <seanjc@google.com>
    KVM: x86: Convert vcpu_run()'s immediate exit param into a generic bitmap

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

Slark Xiao <slark_xiao@163.com>
    USB: serial: option: add Foxconn T99W709

Thorsten Blum <thorsten.blum@linux.dev>
    smb: server: Fix extension string in ksmbd_extract_shortname()

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: limit repeated connections from clients with the same IP

Paulo Alcantara <pc@manguebit.org>
    smb: client: default to nonativesocket under POSIX mounts

Paulo Alcantara <pc@manguebit.org>
    smb: client: set symlink type as native for POSIX mounts

Wang Zhaolong <wangzhaolong@huaweicloud.com>
    smb: client: fix netns refcount leak after net_passive changes

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix corrupted mtime and ctime in smb2_open

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix Preauh_HashValue race condition

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix null pointer dereference error in generate_encryptionkey

Budimir Markovic <markovicbudimir@gmail.com>
    vsock: Do not allow binding to VMADDR_PORT_ANY

Quang Le <quanglex97@gmail.com>
    net/packet: fix a race in packet_set_ring() and packet_notifier()

Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
    selftests/perf_events: Add a mmap() correctness test

Thomas Gleixner <tglx@linutronix.de>
    perf/core: Prevent VMA split of buffer mappings

Thomas Gleixner <tglx@linutronix.de>
    perf/core: Handle buffer mapping fail correctly in perf_mmap()

Thomas Gleixner <tglx@linutronix.de>
    perf/core: Exit early on perf_mmap() fail

Thomas Gleixner <tglx@linutronix.de>
    perf/core: Don't leak AUX buffer refcount on allocation failure

Thomas Gleixner <tglx@linutronix.de>
    perf/core: Preserve AUX buffer allocation failure result

Olga Kornievskaia <okorniev@redhat.com>
    sunrpc: fix handling of server side tls alerts

NeilBrown <neil@brown.name>
    nfsd: avoid ref leak in nfsd_open_local_fh()

Jeff Layton <jlayton@kernel.org>
    nfsd: don't set the ctime on delegated atime updates

Zhang Rui <rui.zhang@intel.com>
    tools/power turbostat: Fix DMR support

Zhang Rui <rui.zhang@intel.com>
    tools/power turbostat: Fix bogus SysWatt for forked program

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

Mikhail Zaslonko <zaslonko@linux.ibm.com>
    s390/boot: Fix startup debugging log

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/ca0132: Fix missing error handling in ca0132_alt_select_out()

Arnd Bergmann <arnd@arndb.de>
    ASoC: SOF: Intel: hda-sdw-bpt: fix SND_SOF_SOF_HDA_SDW_BPT dependencies

Arnd Bergmann <arnd@arndb.de>
    irqchip: Build IMX_MU_MSI only on ARM

Meghana Malladi <m-malladi@ti.com>
    net: ti: icssg-prueth: Fix skb handling for XDP_PASS

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS/localio: nfs_uuid_put() fix the wake up after unlinking the file

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS/localio: nfs_uuid_put() fix races with nfs_open/close_local_fh()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS/localio: nfs_close_local_fh() fix check for file closed

Mohsin Bashir <mohsin.bashr@gmail.com>
    eth: fbnic: Lock the tx_dropped update

Mohsin Bashir <mohsin.bashr@gmail.com>
    eth: fbnic: Fix tx_dropped reporting

Jakub Kicinski <kuba@kernel.org>
    eth: fbnic: remove the debugging trick of super high page bias

Sumanth Korikkar <sumanthk@linux.ibm.com>
    s390/mm: Allocate page table with PAGE_SIZE granularity

Maher Azzouzi <maherazz04@gmail.com>
    net/sched: mqprio: fix stack out-of-bounds write in tc entry parsing

Jakub Kicinski <kuba@kernel.org>
    Revert "net: mdio_bus: Use devm for getting reset GPIO"

Michal Schmidt <mschmidt@redhat.com>
    benet: fix BUG when creating VFs

Lorenzo Bianconi <lorenzo@kernel.org>
    net: airoha: npu: Add missing MODULE_FIRMWARE macros

Jakub Kicinski <kuba@kernel.org>
    net: devmem: fix DMA direction on unmapping

Arnd Bergmann <arnd@arndb.de>
    ipa: fix compile-testing with qcom-mdt=m

Jakub Kicinski <kuba@kernel.org>
    eth: fbnic: unlink NAPIs from queues on error to open

Thomas Gleixner <tglx@linutronix.de>
    x86/irq: Plug vector setup race

Michal Wajdeczko <michal.wajdeczko@intel.com>
    drm/xe/pf: Disable PF restart worker on device removal

Olga Kornievskaia <okorniev@redhat.com>
    sunrpc: fix client side handling of tls alerts

Yang Erkun <yangerkun@huawei.com>
    md: make rdev_addable usable for rcu mode

Takamitsu Iwai <takamitz@amazon.co.jp>
    net/sched: taprio: enforce minimum value for picos_per_byte

Wang Liang <wangliang74@huawei.com>
    net: drop UFO packets in udp_rcv_segment()

Florian Fainelli <florian.fainelli@broadcom.com>
    net: mdio: mdio-bcm-unimac: Correct rate fallback logic

Eric Dumazet <edumazet@google.com>
    ipv6: reject malicious packets in ipv6_gso_segment()

Eric Dumazet <edumazet@google.com>
    selftests: avoid using ifconfig

Christoph Paasch <cpaasch@openai.com>
    net/mlx5: Correctly set gso_segs when LRO is used

Lorenzo Bianconi <lorenzo@kernel.org>
    net: airoha: Fix PPE table access in airoha_ppe_debugfs_foe_show()

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

Alexander Gordeev <agordeev@linux.ibm.com>
    s390/mm: Set high_memory at the end of the identity mapping

Harald Freudenberger <freude@linux.ibm.com>
    s390/ap: Unmask SLCF bit in card and queue ap functions sysfs

Mohamed Khalfella <mkhalfella@purestorage.com>
    nvmet: initialize discovery subsys after debugfs is initialized

Eric Dumazet <edumazet@google.com>
    pptp: ensure minimal skb length in pptp_xmit()

Bence Csókás <csokas.bence@prolan.hu>
    net: mdio_bus: Use devm for getting reset GPIO

Luca Weiss <luca.weiss@fairphone.com>
    net: ipa: add IPA v5.1 and v5.5 to ipa_version_string()

Horatiu Vultur <horatiu.vultur@microchip.com>
    phy: mscc: Fix parsing of unicast frames

Jakub Kicinski <kuba@kernel.org>
    netpoll: prevent hanging NAPI when netcons gets enabled

Michal Luczaj <mhal@rbox.co>
    kcm: Fix splice support

Heming Zhao <heming.zhao@suse.com>
    md/md-cluster: handle REMOVE message earlier

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    ARM: s3c/gpio: complete the conversion to new GPIO value setters

Benjamin Coddington <bcodding@redhat.com>
    NFS: Fixup allocation flags for nfsiod's __GFP_NORETRY

Olga Kornievskaia <okorniev@redhat.com>
    NFSv4.2: another fix for listxattr

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix filehandle bounds checking in nfs_fh_to_dentry()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix wakeup of __nfs_lookup_revalidate() in unblock_revalidate()

Tigran Mkrtchyan <tigran.mkrtchyan@desy.de>
    pNFS/flexfiles: don't attempt pnfs on fatal DS errors

Len Brown <len.brown@intel.com>
    tools/power turbostat: regression fix: --show C1E%

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

Herbert Xu <herbert@gondor.apana.org.au>
    padata: Remove comment for reorder_work

Peter Zijlstra <peterz@infradead.org>
    sched/psi: Fix psi_seq initialization

Jason Gunthorpe <jgg@ziepe.ca>
    vfio/pci: Do vf_token checks for VFIO_DEVICE_BIND_IOMMUFD

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

Zhiguo Niu <zhiguo.niu@unisoc.com>
    f2fs: compress: fix UAF of f2fs_inode_info in f2fs_free_dic

Zhiguo Niu <zhiguo.niu@unisoc.com>
    f2fs: compress: change the first parameter of page_array_{alloc,free} to sbi

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid invalid wait context issue

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

Stanley Chu <yschu@nuvoton.com>
    i3c: master: svc: Fix npcm845 FIFO_EMPTY quirk

Arnd Bergmann <arnd@arndb.de>
    i3c: fix module_i3c_i2c_driver() with I3C=n

Helge Deller <deller@gmx.de>
    apparmor: Fix unaligned memory accesses in KUnit test

Colin Ian King <colin.i.king@gmail.com>
    squashfs: fix incorrect argument to sizeof in kmalloc_array call

Matthew Wilcox (Oracle) <willy@infradead.org>
    squashfs: use folios in squashfs_bio_read_cached()

Johannes Berg <johannes.berg@intel.com>
    scripts: gdb: move MNT_* constants to gdb-parsed

Jiri Olsa <olsajiri@gmail.com>
    uprobes: revert ref_ctr_offset in uprobe_unregister error path

Kent Overstreet <kent.overstreet@linux.dev>
    dm-flakey: Fix corrupt_bio_byte setup checks

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

Alok Tiwari <alok.a.tiwari@oracle.com>
    vhost-scsi: Fix check for inline_sg_cnt exceeding preallocated limit

Mike Christie <michael.christie@oracle.com>
    vhost-scsi: Fix log flooding with target does not exist errors

Dragos Tatulea <dtatulea@nvidia.com>
    vdpa/mlx5: Fix needs_teardown flag calculation

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix oob access in cgroup local storage

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Move cgroup iterator helpers to bpf.h

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Move bpf map owner out of common struct

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Add cookie object to bpf maps

Namhyung Kim <namhyung@kernel.org>
    perf record: Cache build-ID of hit DSOs only

Takashi Iwai <tiwai@suse.de>
    ALSA: usb: scarlett2: Fix missing NULL check

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

Michal Wajdeczko <michal.wajdeczko@intel.com>
    drm/xe/configfs: Fix pci_dev reference leak

Paulo Alcantara <pc@manguebit.org>
    smb: client: allow parsing zero-length AV pairs

Chenyuan Yang <chenyuan0y@gmail.com>
    fbdev: imxfb: Check fb_add_videomode to prevent null-ptr-deref

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - fix seq_file position update in adf_ring_next()

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - fix DMA direction for compression on GEN2 devices

Shubhrajyoti Datta <shubhrajyoti.datta@amd.com>
    clk: clocking-wizard: Fix the round rate handling for versal

Chen Pei <cp0613@linux.alibaba.com>
    perf tools: Remove libtraceevent in .gitignore

Ben Hutchings <benh@debian.org>
    sh: Do not use hyphen in exported variable name

Akhilesh Patil <akhilesh@ee.iitb.ac.in>
    clk: spacemit: ccu_pll: fix error return value in recalc_rate callback

Ian Rogers <irogers@google.com>
    perf topdown: Use attribute to see an event is a topdown metic or slots

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_xcvr: get channel status data with firmware exists

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_xcvr: get channel status data when PHY is not exists

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: SDCA: Fix some holes in the regmap readable/writeable helpers

Shree Ramamoorthy <s-ramamoorthy@ti.com>
    mfd: tps65219: Update TPS65214 MFD cell's GPIO compatible string

Thomas Fourier <fourier.thomas@gmail.com>
    dmaengine: nbpfaxi: Add missing check after DMA map

Thomas Fourier <fourier.thomas@gmail.com>
    dmaengine: mv_xor: Fix missing check after DMA map and missing unmap

Ian Rogers <irogers@google.com>
    perf pmu: Switch FILENAME_MAX to NAME_MAX

Ian Rogers <irogers@google.com>
    tools subcmd: Tighten the filename size in check_if_command_finished

Yao Zi <ziyao@disroot.org>
    clk: thead: th1520-ap: Describe mux clocks with clk_mux

Dan Carpenter <dan.carpenter@linaro.org>
    fs/orangefs: Allow 2 more characters in do_c_string()

Tanmay Shah <tanmay.shah@amd.com>
    remoteproc: xlnx: Disable unsupported features

Luca Weiss <luca.weiss@fairphone.com>
    phy: qcom: phy-qcom-snps-eusb2: Add missing write from init sequence

Laurentiu Palcu <laurentiu.palcu@oss.nxp.com>
    clk: imx95-blk-ctl: Fix synchronous abort

Manivannan Sadhasivam <mani@kernel.org>
    PCI: endpoint: pci-epf-vntb: Fix the incorrect usage of __iomem attribute

Bard Liao <yung-chuan.liao@linux.intel.com>
    soundwire: stream: restore params when prepare ports fail

Michal Koutný <mkoutny@suse.com>
    cgroup: Add compatibility option for content of /proc/cgroups

Eric Biggers <ebiggers@kernel.org>
    crypto: krb5 - Fix memory leak in krb5_test_one_prf()

Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
    crypto: qat - fix virtual channel configuration for GEN6 devices

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

Baokun Li <libaokun1@huawei.com>
    ext4: fix inode use after free in ext4_end_io_rsv_work()

Shashank Balaji <shashank.mahadasyam@sony.com>
    selftests/cgroup: fix cpu.max tests

Dan Carpenter <dan.carpenter@linaro.org>
    watchdog: ziirave_wdt: check record length in ziirave_firm_verify()

Robin Murphy <robin.murphy@arm.com>
    PCI: Fix driver_managed_dma check

Thomas Fourier <fourier.thomas@gmail.com>
    scsi: isci: Fix dma_unmap_sg() nents value

Thomas Fourier <fourier.thomas@gmail.com>
    scsi: mvsas: Fix dma_unmap_sg() nents value

Thomas Fourier <fourier.thomas@gmail.com>
    scsi: elx: efct: Fix dma_unmap_sg() nents value

Bagas Sanjaya <bagasdotme@gmail.com>
    scsi: core: Fix kernel doc for scsi_track_queue_full()

Thomas Fourier <fourier.thomas@gmail.com>
    scsi: ibmvscsi_tgt: Fix dma_unmap_sg() nents value

Paul Kocialkowski <paulk@sys-base.io>
    clk: sunxi-ng: v3s: Fix de clock definition

Zhang Yi <yi.zhang@huawei.com>
    ext4: fix insufficient credits calculation in ext4_meta_trans_blocks()

Zhang Yi <yi.zhang@huawei.com>
    ext4: correct the reserved credits for extent conversion

Yao Zi <ziyao@disroot.org>
    clk: thead: th1520-ap: Correctly refer the parent of osc_12m

Shiraz Saleem <shirazsaleem@microsoft.com>
    RDMA/mana_ib: Fix DSCP value in modify QP

Ian Rogers <irogers@google.com>
    perf python: Correct pyrf_evsel__read for tool PMUs

Ian Rogers <irogers@google.com>
    perf python: Fix thread check in pyrf_evsel__read

Ian Rogers <irogers@google.com>
    perf hwmon_pmu: Avoid shortening hwmon PMU name

Leo Yan <leo.yan@arm.com>
    perf tests bp_account: Fix leaked file descriptor

Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
    pinmux: fix race causing mux_owner NULL with active mux_usecount

Li Ming <ming.li@zohomail.com>
    cxl/edac: Fix wrong dpa checking for PPR operation

Li Ming <ming.li@zohomail.com>
    cxl/core: Introduce a new helper cxl_resource_contains_addr()

wangzijie <wangzijie1@honor.com>
    proc: use the same treatment to check proc_lseek as ones for proc_read_iter et.al

Leon Romanovsky <leon@kernel.org>
    RDMA/uverbs: Add empty rdma_uattrs_has_raw_cap() declaration

Arnd Bergmann <arnd@arndb.de>
    kernel: trace: preemptirq_delay_test: use offstack cpu mask

Steven Rostedt <rostedt@goodmis.org>
    tracing: Use queue_rcu_work() to free filters

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

Alex Elder <elder@riscstar.com>
    clk: spacemit: mark K1 pll1_d8 as critical

Namhyung Kim <namhyung@kernel.org>
    perf sched: Fix memory leaks in 'perf sched latency'

Namhyung Kim <namhyung@kernel.org>
    perf sched: Use RC_CHK_EQUAL() to compare pointers

Namhyung Kim <namhyung@kernel.org>
    perf sched: Fix memory leaks for evsel->priv in timehist

Namhyung Kim <namhyung@kernel.org>
    perf sched: Fix thread leaks in 'perf sched timehist'

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

WangYuli <wangyuli@uniontech.com>
    gitignore: allow .pylintrc to be tracked

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    leds: pca955x: Avoid potential overflow when filling default_label (take 2)

Thomas Fourier <fourier.thomas@gmail.com>
    Fix dma_unmap_sg() nents value

Parav Pandit <parav@nvidia.com>
    RDMA/counter: Check CAP_NET_RAW check in user namespace for RDMA counters

Parav Pandit <parav@nvidia.com>
    RDMA/nldev: Check CAP_NET_RAW in user namespace for QP modify

Parav Pandit <parav@nvidia.com>
    RDMA/mlx5: Check CAP_NET_RAW in user namespace for devx create

Arnd Bergmann <arnd@arndb.de>
    leds: tps6131x: Add V4L2_FLASH_LED_CLASS dependency

Parav Pandit <parav@nvidia.com>
    RDMA/uverbs: Check CAP_NET_RAW in user namespace for RAW QP create

Parav Pandit <parav@nvidia.com>
    RDMA/uverbs: Check CAP_NET_RAW in user namespace for QP create

Parav Pandit <parav@nvidia.com>
    RDMA/mlx5: Check CAP_NET_RAW in user namespace for anchor create

Parav Pandit <parav@nvidia.com>
    RDMA/mlx5: Check CAP_NET_RAW in user namespace for flow create

Parav Pandit <parav@nvidia.com>
    RDMA/uverbs: Check CAP_NET_RAW in user namespace for flow create

Mark Bloch <mbloch@nvidia.com>
    RDMA/ipoib: Use parent rdma device net namespace

Nuno Sá <nuno.sa@analog.com>
    clk: clk-axi-clkgen: fix fpfd_max frequency for zynq

Amir Goldstein <amir73il@gmail.com>
    fanotify: sanitize handle_type values when reporting fid

Luca Weiss <luca.weiss@fairphone.com>
    phy: qualcomm: phy-qcom-eusb2-repeater: Don't zero-out registers

Rodrigo Gobbi <rodrigo.gobbi.7@gmail.com>
    soundwire: debugfs: move debug statement outside of error handling

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    dmaengine: mmp: Fix again Wvoid-pointer-to-enum-cast warning

Charles Keepax <ckeepax@opensource.cirrus.com>
    soundwire: Correct some property names

Niklas Cassel <cassel@kernel.org>
    PCI: qcom: Wait PCIE_RESET_CONFIG_WAIT_MS after link-up IRQ

Niklas Cassel <cassel@kernel.org>
    PCI: dw-rockchip: Wait PCIE_RESET_CONFIG_WAIT_MS after link-up IRQ

Niklas Cassel <cassel@kernel.org>
    PCI: Rename PCIE_RESET_CONFIG_DEVICE_WAIT_MS to PCIE_RESET_CONFIG_WAIT_MS

Jiwei Sun <sunjw10@lenovo.com>
    PCI: Adjust the position of reading the Link Control 2 register

Ze Huang <huangze@whut.edu.cn>
    pinctrl: canaan: k230: Fix order of DT parse and pinctrl register

Ze Huang <huangze@whut.edu.cn>
    pinctrl: canaan: k230: add NULL check in DT parse

Yuan Chen <chenyuan@kylinos.cn>
    pinctrl: berlin: fix memory leak in berlin_pinctrl_build_state()

Yuan Chen <chenyuan@kylinos.cn>
    pinctrl: sunxi: Fix memory leak on krealloc failure

Jerome Brunet <jbrunet@baylibre.com>
    PCI: endpoint: pci-epf-vntb: Return -ENOENT if pci_epc_get_next_free_bar() fails

Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
    crypto: qat - restore ASYM service support for GEN6 devices

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: ahash - Stop legacy tfms from using the set_virt fallback path

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: ahash - Add support for drivers with no fallback

Arnd Bergmann <arnd@arndb.de>
    crypto: arm/aes-neonbs - work around gcc-15 warning

Thomas Antoine <t.antoine@uclouvain.be>
    power: supply: max1720x correct capacity computation

Casey Connolly <casey.connolly@linaro.org>
    power: supply: qcom_pmi8998_charger: fix wakeirq

Charles Han <hanchunchao@inspur.com>
    power: supply: max14577: Handle NULL pdata when CONFIG_OF is not set

Geert Uytterhoeven <geert+renesas@glider.be>
    power: reset: POWER_RESET_TORADEX_EC should depend on ARCH_MXC

Charles Han <hanchunchao@inspur.com>
    power: supply: cpcap-charger: Fix null check for power_supply_get_by_name

Rohit Visavalia <rohit.visavalia@amd.com>
    clk: xilinx: vcu: unregister pll_post only if registered correctly

Namhyung Kim <namhyung@kernel.org>
    perf parse-events: Set default GH modifier properly

James Cowgill <james.cowgill@blaize.com>
    media: v4l2-ctrls: Fix H264 SEPARATE_COLOUR_PLANE check

Ming Qian <ming.qian@oss.nxp.com>
    media: imx-jpeg: Account for data_offset when getting image address

Henry Martin <bsdhenrymartin@gmail.com>
    clk: davinci: Add NULL check in davinci_lpsc_clk_register()

Ivan Stepchenko <sid@itb.spb.ru>
    mtd: fix possible integer overflow in erase_xfer()

Svyatoslav Pankratov <svyatoslav.pankratov@intel.com>
    crypto: qat - fix state restore for banks with exceptions

Ahsan Atta <ahsan.atta@intel.com>
    crypto: qat - allow enabling VFs in the absence of IOMMU

Ashish Kalra <ashish.kalra@amd.com>
    crypto: ccp - Fix dereferencing uninitialized error pointer

Herbert Xu <herbert@gondor.apana.org.au>
    padata: Fix pd UAF once and for all

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: s390/sha3 - Use cpu byte-order when exporting

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: s390/hmac - Fix counter in export state

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

Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
    remoteproc: qcom: pas: Conclude the rename from adsp

Thomas Richard <thomas.richard@bootlin.com>
    pinctrl: cirrus: madera-core: Use devm_pinctrl_register_mappings()

Kees Cook <kees@kernel.org>
    fortify: Fix incorrect reporting of read buffer size

Kees Cook <kees@kernel.org>
    staging: media: atomisp: Fix stack buffer overflow in gmin_get_var_int()

Gabriele Monaco <gmonaco@redhat.com>
    rv: Adjust monitor dependencies

Gabriele Monaco <gmonaco@redhat.com>
    rv: Use strings in da monitors tracepoints

Gabriele Monaco <gmonaco@redhat.com>
    rv: Remove trailing whitespace from tracepoint string

Samuel Holland <samuel.holland@sifive.com>
    RISC-V: KVM: Fix inclusion of Smnpm in the guest ISA bitmap

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

Eric Dumazet <edumazet@google.com>
    ipv6: add a retry logic in net6_rt_notify()

Stanislav Fomichev <sdf@fomichev.me>
    vrf: Drop existing dst reference in vrf_ip6_input_dst

Xiumei Mu <xmu@redhat.com>
    selftests: rtnetlink.sh: remove esp4_offload after test

Jason Xing <kernelxing@tencent.com>
    igb: xsk: solve negative overflow of nb_pkts in zerocopy mode

Jason Xing <kernelxing@tencent.com>
    stmmac: xsk: fix negative overflow of budget in zerocopy mode

Kuniyuki Iwashima <kuniyu@google.com>
    neighbour: Fix null-ptr-deref in neigh_flush_dev().

Tristram Ha <tristram.ha@microchip.com>
    net: dsa: microchip: Fix wrong rx drop MIB counter for KSZ8863

Stanislav Fomichev <sdf@fomichev.me>
    macsec: set IFF_UNICAST_FLT priv flag

Shahar Shitrit <shshitrit@nvidia.com>
    net/mlx5e: Fix potential deadlock by deferring RX timeout recovery

Jianbo Liu <jianbol@nvidia.com>
    net/mlx5e: Remove skb secpath if xfrm state is not found

Alexei Lazar <alazar@nvidia.com>
    net/mlx5e: Clear Read-Only port buffer size in PBMC before update

Yi Chen <yiche@redhat.com>
    selftests: netfilter: ipvs.sh: Explicity disable rp_filter on interface tunl0

Phil Sutter <phil@nwl.cc>
    selftests: netfilter: Ignore tainted kernels in interface stress test

Florian Westphal <fw@strlen.de>
    netfilter: xt_nfacct: don't assume acct name is null-terminated

Jimmy Assarsson <extja@kvaser.com>
    can: kvaser_usb: Assign netdev.dev_port based on device channel index

Jimmy Assarsson <extja@kvaser.com>
    can: kvaser_pciefd: Store device channel index

Randy Dunlap <rdunlap@infradead.org>
    can: tscan1: CAN_TSCAN1 can depend on PC104

Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    can: tscan1: Kconfig: add COMPILE_TEST

Stephane Grosjean <stephane.grosjean@hms-networks.com>
    can: peak_usb: fix USB FD devices potential malfunction

Daniel Zahka <daniel.zahka@gmail.com>
    selftests: drv-net: tso: fix non-tunneled tso6 test case name

Daniel Zahka <daniel.zahka@gmail.com>
    selftests: drv-net: tso: fix vxlan tunnel flags to get correct gso_type

Daniel Zahka <daniel.zahka@gmail.com>
    selftests: drv-net: tso: enable test cases based on hw_features

Gal Pressman <gal@nvidia.com>
    selftests: drv-net: Fix remote command checking in require_cmd()

Gabriele Monaco <gmonaco@redhat.com>
    tools/rv: Do not skip idle in trace

Paul Chaignon <paul.chaignon@gmail.com>
    bpf: Reject narrower access to pointer ctx fields

Kuniyuki Iwashima <kuniyu@google.com>
    bpf: Disable migration in nf_hook_run_bpf().

Chris Down <chris@chrisdown.name>
    Bluetooth: hci_event: Mask data status from LE ext adv reports

Kiran K <kiran.k@intel.com>
    Bluetooth: btintel_pcie: Make driver wait for alive interrupt

Kiran K <kiran.k@intel.com>
    Bluetooth: btintel: Define a macro for Intel Reset vendor command

Ivan Pravdin <ipravdin.official@gmail.com>
    Bluetooth: hci_devcd_dump: fix out-of-bounds via dev_coredumpv

Arseniy Krasnov <avkrasnov@salutedevices.com>
    Bluetooth: hci_sync: fix double free in 'hci_discovery_filter_clear()'

Zhongqiu Han <quic_zhonhan@quicinc.com>
    Bluetooth: btusb: Fix potential NULL dereference on kmalloc failure

Ting-Ying Li <tingying.li@cypress.com>
    wifi: brcmfmac: fix EXTSAE WPA3 connection failure due to AUTH TX failure

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Fix UAF on sva unbind with pending IOPFs

Benjamin Berg <benjamin.berg@intel.com>
    wifi: iwlwifi: mld: decode EOF bit for AMPDUs

Jeremy Linton <jeremy.linton@arm.com>
    arm64/gcs: task_gcs_el0_enable() should use passed task

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: fix WARN_ON for monitor mode on some devices

Kees Cook <kees@kernel.org>
    wifi: brcmfmac: cyw: Fix __counted_by to be LE variant

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

Steven Rostedt <rostedt@goodmis.org>
    PM: cpufreq: powernv/tracing: Move powernv_throttle trace event

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

Alexander Wetzel <Alexander@wetzel-home.de>
    wifi: cfg80211: Add missing lock in cfg80211_check_and_end_cac()

Murad Masimov <m.masimov@mt-integration.ru>
    wifi: plfxlc: Fix error handling in usb driver probe

Moon Hee Lee <moonhee.lee.ca@gmail.com>
    wifi: mac80211: reject TDLS operations when station is not associated

Tze-nan Wu <Tze-nan.Wu@mediatek.com>
    rcu: Fix delayed execution of hurry callbacks

Jason Gunthorpe <jgg@ziepe.ca>
    iommu/amd: Fix geometry.aperture_end for V2 tables

Puranjay Mohan <puranjay@kernel.org>
    selftests/bpf: fix implementation of smp_mb()

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gfx10: fix kiq locking in KCQ reset

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gfx9.4.3: fix kiq locking in KCQ reset

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gfx9: fix kiq locking in KCQ reset

Baochen Qiang <quic_bqiang@quicinc.com>
    wifi: ath11k: fix sleeping-in-atomic in ath11k_mac_op_set_bitrate_mask()

Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
    wifi: ath12k: Use HTT_TCL_METADATA_VER_V1 in FTM mode

Maharaja Kennadyrajan <maharaja.kennadyrajan@oss.qualcomm.com>
    wifi: mac80211: use RCU-safe iteration in ieee80211_csa_finish

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

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    iommu/arm-smmu: disable PRR on SM8250

Ethan Milon <ethan.milon@eviden.com>
    iommu/vt-d: Fix missing PASID in dev TLB flush with cache_tag_flush_all

Jason Gunthorpe <jgg@ziepe.ca>
    iommu/vt-d: Do not wipe out the page table NID when devices detach

Juri Lelli <juri.lelli@redhat.com>
    sched/deadline: Reset extra_bw to max_bw when clearing root domains

Juri Lelli <juri.lelli@redhat.com>
    sched/deadline: Initialize dl_servers after SMP

Al Viro <viro@zeniv.linux.org.uk>
    xen: fix UAF in dmabuf_exp_from_pages()

Edward Srouji <edwards@nvidia.com>
    RDMA/mlx5: Fix UMR modifying of mkey page size

Eric Dumazet <edumazet@google.com>
    net_sched: act_ctinfo: use atomic64_t for three counters

William Liu <will@willsroot.io>
    net/sched: Restrict conditions for adding duplicating netems to qdisc tree

Thomas Weißschuh <linux@weissschuh.net>
    leds: lp8860: Check return value of devm_mutex_init()

Thomas Weißschuh <linux@weissschuh.net>
    spi: spi-nxp-fspi: Check return value of devm_mutex_init()

Easwar Hariharan <eahariha@linux.microsoft.com>
    iommu/amd: Enable PASID and ATS capabilities in the correct order

Tiwei Bie <tiwei.btw@antgroup.com>
    um: rtc: Avoid shadowing err in uml_rtc_start()

Johan Korsnes <johan.korsnes@gmail.com>
    arch: powerpc: defconfig: Drop obsolete CONFIG_NET_CLS_TCINDEX

Jeff Johnson <jeff.johnson@oss.qualcomm.com>
    wifi: ath12k: pack HTT pdev rate stats structs

Harshitha Prem <quic_hprem@quicinc.com>
    wifi: ath12k: update unsupported bandwidth flags in reg rules

Simona Vetter <simona.vetter@ffwll.ch>
    drm/panthor: Fix UAF in panthor_gem_create_with_handle() debugfs code

Fedor Pchelkin <pchelkin@ispras.ru>
    netfilter: nf_tables: adjust lockdep assertions handling

Phil Sutter <phil@nwl.cc>
    netfilter: nf_tables: Drop dead code from fill_*_info routines

Shixiong Ou <oushixiong@kylinos.cn>
    fbcon: Fix outdated registered_fb reference in comment

Peter Zijlstra <peterz@infradead.org>
    sched/deadline: Less agressive dl_server handling

Peter Zijlstra <peterz@infradead.org>
    sched/psi: Optimize psi_group_change() cpu_clock() usage

Andy Yan <andy.yan@rock-chips.com>
    drm/rockchip: vop2: Fix the update of LAYER/PORT select registers when there are multi display output on rk3588/rk3568

Heiko Stuebner <heiko@sntech.de>
    drm/rockchip: vop2: fail cleanly if missing a primary plane for a video-port

Masahiro Yamada <masahiroy@kernel.org>
    arm64: fix unnecessary rebuilding when CONFIG_DEBUG_EFI=y

Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
    wifi: ath12k: Block radio bring-up in FTM mode

Vitaly Prosyak <vitaly.prosyak@amd.com>
    drm/amdgpu: fix use-after-free in amdgpu_userq_suspend+0x51a/0x5a0

Vitaly Prosyak <vitaly.prosyak@amd.com>
    Revert "drm/amdgpu: fix slab-use-after-free in amdgpu_userq_mgr_fini"

Fedor Pchelkin <pchelkin@ispras.ru>
    drm/amd/pm/powerplay/hwmgr/smu_helper: fix order of mask and value

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gfx10: fix KGQ reset sequence

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: move force completion into ring resets

Christian König <ckoenig.leichtzumerken@gmail.com>
    drm/amdgpu: rework queue reset scheduler interaction

Emily Deng <Emily.Deng@amd.com>
    drm/amdkfd: Move the process suspend and resume out of full access

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mt76: mt7996: Fix valid_links bitmask in mt7996_mac_sta_{add,remove}

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mt76: mt7996: Fix possible OOB access in mt7996_tx()

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mt76: mt7996: Fix secondary link lookup in mt7996_mcu_sta_mld_setup_tlv()

Artem Sadovnikov <a.sadovnikov@ispras.ru>
    refscale: Check that nreaders and loops multiplication doesn't overflow

Finn Thain <fthain@linux-m68k.org>
    m68k: Don't unregister boot console needlessly

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    drm/msm/dpu: Fill in min_prefill_lines for SC8180X

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Ensure RCU lock is held around bpf_prog_ksym_find

Dan Carpenter <dan.carpenter@linaro.org>
    wifi: mt76: mt7925: fix off by one in mt7925_mcu_hw_scan()

Mark Brown <broonie@kernel.org>
    kselftest/arm64: Fix check for setting new VLs in sve-ptrace

Dan Carpenter <dan.carpenter@linaro.org>
    wifi: iwlwifi: Fix error code in iwl_op_mode_dvm_start()

Eric Dumazet <edumazet@google.com>
    net: dst: add four helpers to annotate data-races around dst->dev

Eric Dumazet <edumazet@google.com>
    net: dst: annotate data-races around dst->output

Eric Dumazet <edumazet@google.com>
    net: dst: annotate data-races around dst->input

Stav Aviram <saviram@nvidia.com>
    net/mlx5: Check device memory pointer before usage

xin.guo <guoxin0309@gmail.com>
    tcp: fix tcp_ofo_queue() to avoid including too much DUP SACK range

Thiraviyam Mariyappan <thiraviyam.mariyappan@oss.qualcomm.com>
    wifi: ath12k: Clear auth flag only for actual association in security mode

Sergey Senozhatsky <senozhatsky@chromium.org>
    wifi: ath11k: clear initialized flag for deinit-ed srng lists

Stanislav Fomichev <sdf@fomichev.me>
    team: replace team lock with rtnl lock

Shuicheng Lin <shuicheng.lin@intel.com>
    drm/xe/uapi: Correct sync type definition in comments

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    iwlwifi: Add missing check for alloc_ordered_workqueue

Xiu Jianfeng <xiujianfeng@huawei.com>
    wifi: iwlwifi: Fix memory leak in iwl_mvm_init()

Vitaly Prosyak <vitaly.prosyak@amd.com>
    drm/amdgpu: fix slab-use-after-free in amdgpu_userq_mgr_fini+0x70c

Daniil Dulov <d.dulov@aladdin.ru>
    wifi: rtl818x: Kill URBs before clearing tx status queue

Zong-Zhe Yang <kevin_yang@realtek.com>
    wifi: rtw89: avoid NULL dereference when RX problematic packet on unsupported 6 GHz band

Eric Dumazet <edumazet@google.com>
    net: annotate races around sk->sk_uid

Arnd Bergmann <arnd@arndb.de>
    caif: reduce stack size, again

Tamizh Chelvam Raja <tamizh.raja@oss.qualcomm.com>
    wifi: ath12k: Pass ab pointer directly to ath12k_dp_tx_get_encap_type()

P Praneesh <praneesh.p@oss.qualcomm.com>
    wifi: ath12k: Fix double budget decrement while reaping monitor ring

Kang Yang <kang.yang@oss.qualcomm.com>
    wifi: ath12k: update channel list in worker when wait flag is set

Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
    wifi: ath12k: Avoid accessing uninitialized arvif->ar during beacon miss

Haren Myneni <haren@linux.ibm.com>
    powerpc/pseries/dlpar: Search DRC index from ibm,drc-indexes for IO add

Yuan Chen <chenyuan@kylinos.cn>
    bpftool: Fix memory leak in dump_xx_nlmsg on realloc failure

Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
    wifi: mac80211: Fix bssid_indicator for MBSSID in AP mode

Erni Sri Satya Vennela <ernis@linux.microsoft.com>
    net: mana: Fix potential deadlocks in mana napi ops

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/sdma: handle paging queues in amdgpu_sdma_reset_engine()

Lijo Lazar <lijo.lazar@amd.com>
    drm/amdgpu: Remove nbiov7.9 replay count reporting

Jonathan Corbet <corbet@lwn.net>
    slub: Fix a documentation build error for krealloc()

Ian Forbes <ian.forbes@broadcom.com>
    drm/vmwgfx: Fix Host-Backed userspace on Guest-Backed kernel

Petr Machata <petrm@nvidia.com>
    net: ipv6: ip6mr: Fix in/out netdev to pass to the FORWARD chain

Mykyta Yatsenko <yatsenko@meta.com>
    selftests/bpf: Fix unintentional switch case fall through

Eduard Zingerman <eddyz87@gmail.com>
    bpf: handle jset (if a & b ...) as a jump in CFG computation

Fushuai Wang <wangfushuai@baidu.com>
    selftests/bpf: fix signedness bug in redir_partial()

Charalampos Mitrodimas <charmitro@posteo.net>
    net, bpf: Fix RCU usage in task_cls_state() for BPF programs

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf, ktls: Fix data corruption when using bpf_msg_pop_data() in ktls

Breno Leitao <leitao@debian.org>
    netconsole: Only register console drivers when targets are configured

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf, sockmap: Fix psock incorrectly pointing to sk

Kuan-Chung Chen <damon.chen@realtek.com>
    wifi: rtw89: fix EHT 20MHz TX rate for non-AP STA

Fedor Pchelkin <pchelkin@ispras.ru>
    wifi: rtw89: sar: do not assert wiphy lock held until probing is done

Fedor Pchelkin <pchelkin@ispras.ru>
    wifi: rtw89: sar: drop lockdep assertion in rtw89_set_sar_from_acpi

Dan Carpenter <dan.carpenter@linaro.org>
    wifi: rtw89: mcc: prevent shift wrapping in rtw89_core_mlsr_switch()

Boris Brezillon <boris.brezillon@collabora.com>
    drm/panthor: Add missing explicit padding in drm_panthor_gpu_info

Adrián Larumbe <adrian.larumbe@collabora.com>
    drm/panfrost: Fix panfrost device variable name in devfreq

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    drm/connector: hdmi: Evaluate limited range after computing format

Geert Uytterhoeven <geert+renesas@glider.be>
    drm/sitronix: Remove broken backwards-compatibility layer

Andy Yan <andy.yan@rock-chips.com>
    drm/rockchip: cleanup fb when drm_gem_fb_afbc_init failed

Huan Yang <link@vivo.com>
    udmabuf: fix vmap missed offset page

Huan Yang <link@vivo.com>
    Revert "udmabuf: fix vmap_udmabuf error page set"

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    MIPS: alchemy: gpio: use new GPIO line value setter callbacks for the remaining chips

Steven Rostedt <rostedt@goodmis.org>
    selftests/tracing: Fix false failure of subsystem event test

Alok Tiwari <alok.a.tiwari@oracle.com>
    staging: nvec: Fix incorrect null termination of battery manufacturer

Inochi Amaoto <inochiama@gmail.com>
    riscv: dts: sophgo: sg2044: Add missing riscv,cbop-block-size property

Antheas Kapenekakis <lkml@antheas.dev>
    platform/x86: oxpec: Fix turbo register for G1 AMD

Michael J. Ruhl <michael.j.ruhl@intel.com>
    drm/xe: Correct BMG VSEC header sizing

Michael J. Ruhl <michael.j.ruhl@intel.com>
    drm/xe: Correct the rev value for the DVSEC entries

Slark Xiao <slark_xiao@163.com>
    bus: mhi: host: pci_generic: Fix the modem name of Foxconn T99W640

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    interconnect: qcom: qcs615: Drop IP0 interconnects

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    interconnect: qcom: sc8180x: specify num_nodes

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    interconnect: qcom: sc8280xp: specify num_links for qnm_a1noc_cfg

Johan Hovold <johan@kernel.org>
    soc: qcom: pmic_glink: fix OF node leak

Brahmajit Das <listout@listout.xyz>
    samples: mei: Fix building on musl libc

Johan Hovold <johan@kernel.org>
    driver core: auxiliary bus: fix OF node leak

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    staging: greybus: gbphy: fix up const issue with the match callback

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: SDCA: Allow read-only controls to be deferrable

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: SDCA: Update memory allocations to zero initialise

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    kexec_core: Fix error code path in the KEXEC_JUMP flow

Jonas Karlman <jonas@kwiboo.se>
    arm64: dts: rockchip: Fix UART DMA support for RK3528

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

Jonas Karlman <jonas@kwiboo.se>
    arm64: dts: rockchip: Fix pinctrl node names for RK3528

Max Krummenacher <max.krummenacher@toradex.com>
    arm64: dts: freescale: imx8mp-toradex-smarc: fix lvds dsi mux gpio

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

Sebastian Reichel <sebastian.reichel@collabora.com>
    arm64: dts: rockchip: fix PHY handling for ROCK 4D

Sumit Gupta <sumitg@nvidia.com>
    soc/tegra: cbb: Clear ERR_FORCE register with ERR_STATUS

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    staging: gpib: Fix error handling paths in cb_gpib_probe()

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    staging: gpib: Fix error code in board_type_ioctl()

Parth Pancholi <parth.pancholi@toradex.com>
    arm64: dts: ti: k3-am62p-verdin: fix PWM_3_DSI GPIO direction

Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
    arm64: dts: renesas: r8a779g3-sparrow-hawk-fan-pwm: Add missing install target

Albin Törnqvist <albin.tornqvist@codiax.se>
    arm: dts: ti: omap: Fixup pinheader typo

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    tools/nolibc: avoid false-positive -Wmaybe-uninitialized through waitpid()

Lucas De Marchi <lucas.demarchi@intel.com>
    usb: early: xhci-dbc: Fix early_ioremap leak

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    selftests/nolibc: correctly report errors from printf() and friends

Francesco Dolcini <francesco.dolcini@toradex.com>
    arm64: dts: ti: k3-am62p-verdin: add SD_1 CD pull-up

Sivan Zohar-Kotzer <sivany32@gmail.com>
    powercap: dtpm_cpu: Fix NULL pointer dereference in get_pd_power_uw()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "vmci: Prevent the dispatching of uninitialized payloads"

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    selftests: vDSO: chacha: Correctly skip test if necessary

Tim Harvey <tharvey@gateworks.com>
    arm64: dts: imx8mp-venice-gw74xx: update name of M2SKT_WDIS2# gpio

Denis OSTERLAND-HEIM <denis.osterland@diehl.com>
    pps: fix poll support

Lizhi Xu <lizhi.xu@windriver.com>
    vmci: Prevent the dispatching of uninitialized payloads

Shankari Anand <shankari.ak0208@gmail.com>
    rust: miscdevice: clarify invariant for `MiscDeviceRegistration`

Abdun Nihaal <abdun.nihaal@gmail.com>
    staging: fbtft: fix potential memory leak in fbtft_framebuffer_alloc()

Colin Ian King <colin.i.king@gmail.com>
    staging: gpib: fix unset padding field copy back to userspace

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: SDCA: Add missing default in switch in entity_pde_event()

Jonas Karlman <jonas@kwiboo.se>
    arm64: dts: rockchip: Enable eMMC HS200 mode on Radxa E20C

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    power: sequencing: qcom-wcn: fix bluetooth-wifi copypasta for WCN6855

Danilo Krummrich <dakr@kernel.org>
    rust: devres: require T: Send for Devres

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    drivers: misc: sram: fix up some const issues with recent attribute changes

Clément Le Goffic <clement.legoffic@foss.st.com>
    spi: stm32: Check for cfg availability in stm32_spi_probe

Hans de Goede <hansg@kernel.org>
    mei: vsc: Fix "BUG: Invalid wait context" lockdep error

Hans de Goede <hansg@kernel.org>
    mei: vsc: Run event callback from a workqueue

Hans de Goede <hansg@kernel.org>
    mei: vsc: Drop unused vsc_tp_request_irq() and vsc_tp_free_irq()

Hans de Goede <hansg@kernel.org>
    mei: vsc: Unset the event callback on remove and probe errors

Hans de Goede <hansg@kernel.org>
    mei: vsc: Event notifier fixes

Hans de Goede <hansg@kernel.org>
    mei: vsc: Destroy mutex after freeing the IRQ

Hans de Goede <hansg@kernel.org>
    mei: vsc: Don't re-init VSC from mei_vsc_hw_reset() on stop

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    usb: typec: ucsi: yoga-c630: fix error and remove paths

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/bugs: Allow ITS stuffing in eIBRS+retpoline mode also

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/bugs: Introduce cdt_possible()

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/bugs: Simplify the retbleed=stuff checks

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/bugs: Avoid AUTO after the select step in the retbleed mitigation

Sibi Sankar <quic_sibis@quicinc.com>
    firmware: arm_scmi: Fix up turbo frequencies selection

Arnd Bergmann <arnd@arndb.de>
    cpufreq: armada-8k: make both cpu masks static

Ryan Wanner <Ryan.Wanner@microchip.com>
    ARM: dts: microchip: sam9x7: Add clock name property

Ryan Wanner <Ryan.Wanner@microchip.com>
    ARM: dts: microchip: sama7d65: Add clock name property

Michael Walle <mwalle@kernel.org>
    arm64: dts: ti: k3-am62p-j722s: fix pinctrl-single size

Emanuele Ghidoli <emanuele.ghidoli@toradex.com>
    arm64: dts: ti: k3-am62p-verdin: Enable pull-ups on I2C_3_HDMI

Wadim Egorov <w.egorov@phytec.de>
    arm64: dts: ti: k3-am642-phyboard-electra: Fix PRU-ICSSG Ethernet ports

Quentin Schulz <quentin.schulz@cherry.de>
    arm64: dts: rockchip: fix endpoint dtc warning for PX30 ISP

Charalampos Mitrodimas <charmitro@posteo.net>
    usb: misc: apple-mfi-fastcharge: Make power supply names unique

Seungjin Bae <eeodqql09@gmail.com>
    usb: host: xhci-plat: fix incorrect type for of_match variable in xhci_plat_probe()

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: vfxxx: Correctly use two tuples for timer address

Gautham R. Shenoy <gautham.shenoy@amd.com>
    pm: cpupower: Fix printing of CORE, CPU fields in cpupower-monitor

André Apitzsch <git@apitzsch.eu>
    arm64: dts: qcom: msm8976: Make blsp_dma controlled-remotely

Lijuan Gao <lijuan.gao@oss.qualcomm.com>
    arm64: dts: qcom: sa8775p: Correct the interrupt for remoteproc

Will Deacon <willdeacon@google.com>
    arm64: dts: exynos: gs101: Add 'local-timer-stop' to cpuidle nodes

Jie Gan <jie.gan@oss.qualcomm.com>
    arm64: dts: qcom: qcs615: disable the CTI device of the camera block

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    arm64: dts: qcom: sc7180: Expand IMEM region

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    arm64: dts: qcom: sdm845: Expand IMEM region

Jie Gan <jie.gan@oss.qualcomm.com>
    arm64: dts: qcom: qcs615: fix a crash issue caused by infinite loop for Coresight

Alexander Wilhelm <alexander.wilhelm@westermo.com>
    soc: qcom: fix endianness for QMI header

Alexander Wilhelm <alexander.wilhelm@westermo.com>
    soc: qcom: QMI encoding/decoding for big endian

Dmitry Vyukov <dvyukov@google.com>
    selftests: Fix errno checking in syscall_user_dispatch test

Alexander Stein <alexander.stein@ew.tq-group.com>
    arm64: dts: freescale: imx93-tqma9352: Limit BUCK2 to 600mV

Chen-Yu Tsai <wenst@chromium.org>
    ASoC: mediatek: mt8183-afe-pcm: Support >32 bit DMA addresses

Chen-Yu Tsai <wenst@chromium.org>
    ASoC: mediatek: use reserved memory or enable buffer pre-allocation

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    arm64: dts: qcom: x1p42100: Fix thermal sensor configuration

Arnd Bergmann <arnd@arndb.de>
    ASoC: ops: dynamically allocate struct snd_ctl_elem_value

Venkata Prasad Potturu <venkataprasad.potturu@amd.com>
    ASoC: amd: acp: Fix pointer assignments for snd_soc_acpi_mach structures

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: soc-dai: tidyup return value of snd_soc_xlate_tdm_slot_mask()

Pei Xiao <xiaopei01@kylinos.cn>
    ASOC: rockchip: fix capture stream handling in rockchip_sai_xfer_stop

Kees Cook <kees@kernel.org>
    sched/task_stack: Add missing const qualifier to end_of_stack()

Nilay Shroff <nilay@linux.ibm.com>
    block: restore two stage elevator switch while running nr_hw_queue update

Bo Liu (OpenAnolis) <liubo03@inspur.com>
    erofs: fix build error with CONFIG_EROFS_FS_ZIP_ACCEL=y

Jann Horn <jannh@google.com>
    eventpoll: fix sphinx documentation build warning

Jann Horn <jannh@google.com>
    eventpoll: Fix semi-unbounded recursion

Sun YangKai <sunk67188@gmail.com>
    btrfs: remove partial support for lowest level from btrfs_search_forward()

Randy Dunlap <rdunlap@infradead.org>
    io_uring: fix breakage in EXPERT menu

John Garry <john.g.garry@oracle.com>
    block: sanitize chunk_sectors for atomic write limits

Rick Wertenbroek <rick.wertenbroek@gmail.com>
    nvmet: pci-epf: Do not complete commands twice if nvmet_req_init() fails

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: No more self recovery

John Garry <john.g.garry@oracle.com>
    md/raid10: fix set but not used variable in sync_request_write()

Ming Lei <ming.lei@redhat.com>
    ublk: validate ublk server pid

Uday Shankar <ushankar@purestorage.com>
    ublk: speed up ublk server exit handling

Kees Cook <kees@kernel.org>
    kunit/fortify: Add back "volatile" for sizeof() constants

Zheng Qixing <zhengqixing@huawei.com>
    md: allow removing faulty rdev during resync

Ming Lei <ming.lei@redhat.com>
    nbd: fix lockdep deadlock warning

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Minor do_xmote cancelation fix

Thomas Fourier <fourier.thomas@gmail.com>
    block: mtip32xx: Fix usage of dma_map_sg()

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

Tingmao Wang <m@maowtm.org>
    landlock: Fix warning from KUnit tests

Edward Adam Davis <eadavis@qq.com>
    fs/ntfs3: cancle set bad inode after removing name fails

Song Liu <song@kernel.org>
    selftests/landlock: Fix build of audit_test

Mickaël Salaün <mic@digikod.net>
    selftests/landlock: Fix readlink check

RubenKelevra <rubenkelevra@gmail.com>
    fs_context: fix parameter name in infofc() macro

Al Viro <viro@zeniv.linux.org.uk>
    parse_longname(): strrchr() expects NUL-terminated string

Richard Guy Briggs <rgb@redhat.com>
    audit,module: restore audit logging in load failure case


-------------

Diffstat:

 .gitignore                                         |   1 +
 Documentation/admin-guide/kernel-parameters.txt    |   8 +
 Documentation/filesystems/f2fs.rst                 |   6 +-
 Documentation/netlink/specs/ethtool.yaml           |   6 +-
 Makefile                                           |   4 +-
 arch/arm/boot/dts/microchip/sam9x7.dtsi            |   2 +
 arch/arm/boot/dts/microchip/sama7d65.dtsi          |   2 +
 .../boot/dts/nxp/imx/imx6ul-kontron-bl-common.dtsi |   1 -
 arch/arm/boot/dts/nxp/vf/vfxxx.dtsi                |   2 +-
 arch/arm/boot/dts/ti/omap/am335x-boneblack.dts     |   2 +-
 arch/arm/crypto/aes-neonbs-glue.c                  |   2 +-
 arch/arm/mach-s3c/gpio-samsung.c                   |   2 +-
 arch/arm64/boot/dts/exynos/google/gs101.dtsi       |   3 +
 .../boot/dts/freescale/imx8mm-beacon-som.dtsi      |   2 +
 .../boot/dts/freescale/imx8mn-beacon-som.dtsi      |   2 +
 .../dts/freescale/imx8mp-toradex-smarc-dev.dts     |   5 -
 .../boot/dts/freescale/imx8mp-toradex-smarc.dtsi   |   2 +
 .../boot/dts/freescale/imx8mp-venice-gw74xx.dts    |   8 +-
 arch/arm64/boot/dts/freescale/imx93-tqma9352.dtsi  |   6 +-
 arch/arm64/boot/dts/qcom/msm8976.dtsi              |   2 +
 arch/arm64/boot/dts/qcom/qcs615.dtsi               |   4 +
 arch/arm64/boot/dts/qcom/sa8775p.dtsi              |  10 +-
 arch/arm64/boot/dts/qcom/sc7180.dtsi               |  10 +-
 arch/arm64/boot/dts/qcom/sdm845.dtsi               |  10 +-
 arch/arm64/boot/dts/qcom/x1e80100.dtsi             |   2 +-
 arch/arm64/boot/dts/qcom/x1p42100.dtsi             | 556 +++++++++++++++++++
 arch/arm64/boot/dts/renesas/Makefile               |   1 +
 arch/arm64/boot/dts/rockchip/px30-evb.dts          |   3 +-
 arch/arm64/boot/dts/rockchip/px30-pp1516.dtsi      |   3 +-
 arch/arm64/boot/dts/rockchip/px30.dtsi             |   2 -
 arch/arm64/boot/dts/rockchip/rk3528-pinctrl.dtsi   |  20 +-
 arch/arm64/boot/dts/rockchip/rk3528-radxa-e20c.dts |   1 +
 arch/arm64/boot/dts/rockchip/rk3528.dtsi           |  16 +-
 arch/arm64/boot/dts/rockchip/rk3576-rock-4d.dts    |   6 +-
 arch/arm64/boot/dts/st/stm32mp251.dtsi             |   2 +-
 .../boot/dts/ti/k3-am62p-j722s-common-main.dtsi    |   2 +-
 arch/arm64/boot/dts/ti/k3-am62p-verdin.dtsi        |   8 +-
 .../boot/dts/ti/k3-am642-phyboard-electra-rdk.dts  |   2 +
 arch/arm64/include/asm/gcs.h                       |   2 +-
 arch/arm64/include/asm/kvm_host.h                  |   4 +
 arch/arm64/kernel/Makefile                         |   2 +-
 arch/arm64/kernel/process.c                        |   6 +-
 arch/arm64/kvm/hyp/exception.c                     |   6 +-
 arch/arm64/kvm/hyp/vhe/switch.c                    |  14 +-
 arch/arm64/net/bpf_jit_comp.c                      |   1 +
 arch/m68k/Kconfig.debug                            |   2 +-
 arch/m68k/kernel/early_printk.c                    |  42 +-
 arch/m68k/kernel/head.S                            |   8 +-
 arch/mips/alchemy/common/gpiolib.c                 |  12 +-
 arch/mips/mm/tlb-r4k.c                             |  56 +-
 arch/powerpc/configs/ppc6xx_defconfig              |   1 -
 arch/powerpc/kernel/eeh.c                          |   1 +
 arch/powerpc/kernel/eeh_driver.c                   |  48 +-
 arch/powerpc/kernel/eeh_pe.c                       |  10 +-
 arch/powerpc/kernel/pci-hotplug.c                  |   3 +
 arch/powerpc/platforms/pseries/dlpar.c             |  52 +-
 arch/riscv/boot/dts/sophgo/sg2044-cpus.dtsi        |  64 +++
 arch/riscv/kvm/vcpu_onereg.c                       |  83 ++-
 arch/s390/boot/startup.c                           |   2 +-
 arch/s390/crypto/hmac_s390.c                       |  12 +-
 arch/s390/crypto/sha.h                             |   3 +
 arch/s390/crypto/sha3_256_s390.c                   |  22 +-
 arch/s390/crypto/sha3_512_s390.c                   |  23 +-
 arch/s390/include/asm/ap.h                         |   2 +-
 arch/s390/kernel/setup.c                           |   6 +
 arch/s390/mm/pgalloc.c                             |   5 -
 arch/s390/mm/vmem.c                                |   5 +-
 arch/sh/Makefile                                   |  10 +-
 arch/sh/boot/compressed/Makefile                   |   4 +-
 arch/sh/boot/romimage/Makefile                     |   4 +-
 arch/um/drivers/rtc_user.c                         |   2 +-
 arch/x86/boot/cpuflags.c                           |  13 +
 arch/x86/boot/startup/sev-shared.c                 |   7 +
 arch/x86/coco/sev/core.c                           |  21 +
 arch/x86/include/asm/cpufeatures.h                 |   1 +
 arch/x86/include/asm/hw_irq.h                      |  12 +-
 arch/x86/include/asm/kvm-x86-ops.h                 |   1 -
 arch/x86/include/asm/kvm_host.h                    |   8 +-
 arch/x86/include/asm/msr-index.h                   |   1 +
 arch/x86/include/asm/sev.h                         |  19 +
 arch/x86/kernel/cpu/bugs.c                         |  56 +-
 arch/x86/kernel/cpu/scattered.c                    |   1 +
 arch/x86/kernel/irq.c                              |  63 ++-
 arch/x86/kvm/svm/svm.c                             |  14 +-
 arch/x86/kvm/vmx/main.c                            |  15 +-
 arch/x86/kvm/vmx/tdx.c                             |  18 +-
 arch/x86/kvm/vmx/vmx.c                             |  16 +-
 arch/x86/kvm/vmx/x86_ops.h                         |   4 +-
 arch/x86/kvm/x86.c                                 |  13 +-
 arch/x86/mm/extable.c                              |   5 +-
 block/blk-mq.c                                     |  84 ++-
 block/blk-settings.c                               |  19 +-
 block/blk.h                                        |   2 +-
 block/elevator.c                                   |  10 +-
 crypto/ahash.c                                     |  13 +-
 crypto/krb5/selftest.c                             |   1 +
 drivers/base/auxiliary.c                           |   2 +
 drivers/block/mtip32xx/mtip32xx.c                  |  27 +-
 drivers/block/nbd.c                                |  12 +-
 drivers/block/ublk_drv.c                           |  49 +-
 drivers/block/zloop.c                              |   3 +-
 drivers/bluetooth/btintel.c                        |   4 +-
 drivers/bluetooth/btintel.h                        |   2 +
 drivers/bluetooth/btintel_pcie.c                   |  42 +-
 drivers/bluetooth/btusb.c                          |  14 +-
 drivers/bluetooth/hci_intel.c                      |  10 +-
 drivers/bus/mhi/host/pci_generic.c                 |   8 +-
 drivers/char/hw_random/mtk-rng.c                   |   4 +-
 drivers/clk/at91/sam9x7.c                          |  20 +-
 drivers/clk/clk-axi-clkgen.c                       |   2 +-
 drivers/clk/davinci/psc.c                          |   5 +
 drivers/clk/imx/clk-imx95-blk-ctl.c                |  13 +-
 drivers/clk/renesas/rzv2h-cpg.c                    |   1 +
 drivers/clk/spacemit/ccu-k1.c                      |   3 +-
 drivers/clk/spacemit/ccu_mix.h                     |  11 +-
 drivers/clk/spacemit/ccu_pll.c                     |   2 +-
 drivers/clk/sunxi-ng/ccu-sun8i-v3s.c               |   3 +-
 drivers/clk/thead/clk-th1520-ap.c                  | 102 ++--
 drivers/clk/xilinx/clk-xlnx-clock-wizard.c         |   2 +-
 drivers/clk/xilinx/xlnx_vcu.c                      |   4 +-
 drivers/cpufreq/Makefile                           |   1 +
 drivers/cpufreq/armada-8k-cpufreq.c                |   3 +-
 drivers/cpufreq/cpufreq.c                          |  21 +-
 drivers/cpufreq/intel_pstate.c                     |   4 +-
 drivers/cpufreq/powernv-cpufreq.c                  |   4 +-
 drivers/cpufreq/powernv-trace.h                    |  44 ++
 .../crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c    |   4 +-
 drivers/crypto/ccp/ccp-debugfs.c                   |   3 +
 drivers/crypto/ccp/sev-dev.c                       |  16 +-
 drivers/crypto/img-hash.c                          |   2 +-
 drivers/crypto/inside-secure/safexcel_hash.c       |   8 +-
 .../crypto/intel/keembay/keembay-ocs-hcu-core.c    |   8 +-
 .../crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c |   9 +-
 .../crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c   |  20 +-
 .../crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.h   |   2 +-
 .../crypto/intel/qat/qat_common/adf_gen4_hw_data.c |  29 +-
 drivers/crypto/intel/qat/qat_common/adf_sriov.c    |   1 -
 .../intel/qat/qat_common/adf_transport_debug.c     |   4 +-
 drivers/crypto/intel/qat/qat_common/qat_bl.c       |   6 +-
 .../crypto/intel/qat/qat_common/qat_compression.c  |   8 +-
 drivers/crypto/marvell/cesa/cipher.c               |   4 +-
 drivers/crypto/marvell/cesa/hash.c                 |   5 +-
 drivers/cxl/core/core.h                            |   1 +
 drivers/cxl/core/edac.c                            |   5 +-
 drivers/cxl/core/hdm.c                             |   7 +
 drivers/devfreq/devfreq.c                          |  12 +-
 drivers/dma-buf/Kconfig                            |   1 -
 drivers/dma-buf/udmabuf.c                          |  23 +-
 drivers/dma/mmp_tdma.c                             |   2 +-
 drivers/dma/mv_xor.c                               |  21 +-
 drivers/dma/nbpfaxi.c                              |  13 +
 drivers/firmware/arm_scmi/perf.c                   |   2 +-
 drivers/firmware/efi/libstub/Makefile.zboot        |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c         |  24 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h         |  25 +-
 .../gpu/drm/amd/amdgpu/amdgpu_amdkfd_arcturus.c    |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |  11 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_job.c            |  39 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_sdma.c           |  10 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c          |   2 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c             |  38 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c             |  12 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c             |  12 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c              |   9 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c            |  10 +-
 drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c             |   8 +-
 drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c             |   8 +-
 drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c             |   8 +-
 drivers/gpu/drm/amd/amdgpu/jpeg_v4_0.c             |   8 +-
 drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c           |   8 +-
 drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c           |   8 +-
 drivers/gpu/drm/amd/amdgpu/nbio_v7_9.c             |  20 -
 drivers/gpu/drm/amd/amdgpu/sdma_v4_4_2.c           |  35 +-
 drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c             |   5 +-
 drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c             |   5 +-
 drivers/gpu/drm/amd/amdgpu/sdma_v6_0.c             |   6 +-
 drivers/gpu/drm/amd/amdgpu/sdma_v7_0.c             |   6 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c              |   7 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c            |   6 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c            |   7 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v5_0_0.c            |   7 +-
 drivers/gpu/drm/amd/amdkfd/kfd_device.c            |  54 +-
 .../gpu/drm/amd/pm/powerplay/hwmgr/smu_helper.c    |   2 +-
 drivers/gpu/drm/display/drm_hdmi_state_helper.c    |   4 +-
 .../drm/msm/disp/dpu1/catalog/dpu_5_1_sc8180x.h    |   1 +
 drivers/gpu/drm/panfrost/panfrost_devfreq.c        |   4 +-
 drivers/gpu/drm/panthor/panthor_gem.c              |  31 +-
 drivers/gpu/drm/panthor/panthor_gem.h              |   3 -
 drivers/gpu/drm/rockchip/rockchip_drm_fb.c         |   9 +-
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.c       |  29 +-
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.h       |  33 ++
 drivers/gpu/drm/rockchip/rockchip_vop2_reg.c       |  89 ++-
 drivers/gpu/drm/sitronix/Kconfig                   |  10 -
 drivers/gpu/drm/vmwgfx/vmwgfx_shader.c             |   2 +-
 drivers/gpu/drm/xe/xe_configfs.c                   |   3 +-
 drivers/gpu/drm/xe/xe_device.c                     |   1 +
 drivers/gpu/drm/xe/xe_gt_sriov_pf.c                |  32 +-
 drivers/gpu/drm/xe/xe_vsec.c                       |  20 +-
 drivers/hid/hid-apple.c                            |  20 +-
 drivers/hid/hid-core.c                             |   6 +-
 drivers/hid/hid-magicmouse.c                       |  60 +-
 drivers/i2c/muxes/i2c-mux-mule.c                   |   3 +-
 drivers/i3c/master/svc-i3c-master.c                |  20 +-
 drivers/infiniband/core/counters.c                 |   2 +-
 drivers/infiniband/core/device.c                   |  27 +
 drivers/infiniband/core/nldev.c                    |   2 +-
 drivers/infiniband/core/rdma_core.c                |  29 +
 drivers/infiniband/core/uverbs_cmd.c               |   7 +-
 drivers/infiniband/core/uverbs_std_types_qp.c      |   2 +-
 drivers/infiniband/hw/erdma/erdma_verbs.c          |   3 +-
 drivers/infiniband/hw/hns/hns_roce_device.h        |   1 +
 drivers/infiniband/hw/hns/hns_roce_hem.c           |  18 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |  87 ++-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h         |   8 +-
 drivers/infiniband/hw/hns/hns_roce_main.c          |  22 +-
 drivers/infiniband/hw/mana/qp.c                    |   2 +-
 drivers/infiniband/hw/mlx5/devx.c                  |   2 +-
 drivers/infiniband/hw/mlx5/dm.c                    |   2 +-
 drivers/infiniband/hw/mlx5/fs.c                    |   4 +-
 drivers/infiniband/hw/mlx5/umr.c                   |   6 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c          |   2 +
 drivers/interconnect/qcom/qcs615.c                 |  42 --
 drivers/interconnect/qcom/sc8180x.c                |   6 +
 drivers/interconnect/qcom/sc8280xp.c               |   1 +
 drivers/iommu/amd/iommu.c                          |  19 +-
 drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c         |   3 +-
 drivers/iommu/intel/cache.c                        |  18 +-
 drivers/iommu/intel/iommu.c                        |   3 +-
 drivers/irqchip/Kconfig                            |   1 +
 drivers/leds/flash/Kconfig                         |   1 +
 drivers/leds/leds-lp8860.c                         |   4 +-
 drivers/leds/leds-pca955x.c                        |   4 +-
 drivers/md/dm-flakey.c                             |   9 +-
 drivers/md/md.c                                    |  41 +-
 drivers/md/raid10.c                                |   3 -
 drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c     |  47 +-
 drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.h     |   1 +
 .../media/platform/ti/j721e-csi2rx/j721e-csi2rx.c  |   1 +
 drivers/media/v4l2-core/v4l2-ctrls-core.c          |   8 +-
 drivers/mfd/tps65219.c                             |   2 +-
 drivers/misc/mei/platform-vsc.c                    |   8 +
 drivers/misc/mei/vsc-tp.c                          |  68 +--
 drivers/misc/mei/vsc-tp.h                          |   3 -
 drivers/misc/sram.c                                |  10 +-
 drivers/mtd/ftl.c                                  |   2 +-
 drivers/mtd/nand/raw/atmel/nand-controller.c       |   2 +-
 drivers/mtd/nand/raw/atmel/pmecc.c                 |   6 +
 drivers/mtd/nand/raw/rockchip-nand-controller.c    |  15 +
 drivers/mtd/spi-nor/spansion.c                     |  31 ++
 drivers/net/can/kvaser_pciefd.c                    |   1 +
 drivers/net/can/sja1000/Kconfig                    |   2 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c   |   1 +
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c         |  17 +-
 drivers/net/dsa/microchip/ksz8.c                   |   3 +
 drivers/net/dsa/microchip/ksz8_reg.h               |   4 +-
 drivers/net/ethernet/airoha/airoha_npu.c           |   2 +
 drivers/net/ethernet/airoha/airoha_ppe.c           |  26 +-
 drivers/net/ethernet/emulex/benet/be_cmds.c        |   2 +-
 drivers/net/ethernet/intel/igb/igb_xsk.c           |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   1 +
 .../ethernet/mellanox/mlx5/core/en/port_buffer.c   |   3 +
 .../ethernet/mellanox/mlx5/core/en/reporter_rx.c   |   7 +
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.c       |   4 +
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  26 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/lib/dm.c   |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   3 -
 drivers/net/ethernet/meta/fbnic/fbnic_netdev.c     |  14 +-
 drivers/net/ethernet/meta/fbnic/fbnic_txrx.c       |   4 +-
 drivers/net/ethernet/meta/fbnic/fbnic_txrx.h       |   6 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c      |  28 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   2 +-
 drivers/net/ethernet/ti/icssg/icssg_common.c       |  15 +-
 drivers/net/ipa/Kconfig                            |   2 +-
 drivers/net/ipa/ipa_sysfs.c                        |   6 +-
 drivers/net/macsec.c                               |   2 +-
 drivers/net/mdio/mdio-bcm-unimac.c                 |   5 +-
 drivers/net/netconsole.c                           |  30 +-
 drivers/net/phy/mscc/mscc_ptp.c                    |   1 +
 drivers/net/phy/mscc/mscc_ptp.h                    |   1 +
 drivers/net/ppp/pptp.c                             |  18 +-
 drivers/net/team/team_core.c                       |  96 ++--
 drivers/net/team/team_mode_activebackup.c          |   3 +-
 drivers/net/team/team_mode_loadbalance.c           |  13 +-
 drivers/net/usb/usbnet.c                           |  11 +-
 drivers/net/vrf.c                                  |   2 +
 drivers/net/wireless/ath/ath11k/hal.c              |   4 +
 drivers/net/wireless/ath/ath11k/mac.c              |  12 +-
 drivers/net/wireless/ath/ath12k/core.c             |   1 +
 drivers/net/wireless/ath/ath12k/core.h             |   8 +-
 .../net/wireless/ath/ath12k/debugfs_htt_stats.h    |   6 +-
 drivers/net/wireless/ath/ath12k/dp.h               |   1 +
 drivers/net/wireless/ath/ath12k/dp_mon.c           |   1 -
 drivers/net/wireless/ath/ath12k/dp_tx.c            |  10 +-
 drivers/net/wireless/ath/ath12k/mac.c              | 120 +++-
 drivers/net/wireless/ath/ath12k/p2p.c              |   3 +-
 drivers/net/wireless/ath/ath12k/reg.c              | 116 +++-
 drivers/net/wireless/ath/ath12k/reg.h              |   1 +
 drivers/net/wireless/ath/ath12k/wmi.c              |  14 +-
 drivers/net/wireless/ath/ath12k/wmi.h              |   2 +
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |  38 +-
 .../broadcom/brcm80211/brcmfmac/cyw/core.c         |  26 +-
 .../broadcom/brcm80211/brcmfmac/cyw/fwil_types.h   |   2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/main.c      |  12 +-
 drivers/net/wireless/intel/iwlwifi/mld/rx.c        |   9 +
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   4 +-
 drivers/net/wireless/marvell/mwl8k.c               |   4 +
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c    |   4 +-
 drivers/net/wireless/mediatek/mt76/mt7996/main.c   |  21 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c    |   3 +-
 drivers/net/wireless/purelifi/plfxlc/mac.c         |  11 +-
 drivers/net/wireless/purelifi/plfxlc/mac.h         |   2 +-
 drivers/net/wireless/purelifi/plfxlc/usb.c         |  29 +-
 drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c |   3 +-
 drivers/net/wireless/realtek/rtl8xxxu/core.c       |   2 +-
 drivers/net/wireless/realtek/rtw88/main.c          |   4 +-
 drivers/net/wireless/realtek/rtw89/core.c          |   8 +-
 drivers/net/wireless/realtek/rtw89/phy.c           |  12 +-
 drivers/net/wireless/realtek/rtw89/sar.c           |   5 +-
 drivers/nvme/target/core.c                         |  18 +-
 drivers/nvme/target/pci-epf.c                      |  23 +-
 drivers/pci/controller/dwc/pcie-dw-rockchip.c      |   1 +
 drivers/pci/controller/dwc/pcie-qcom.c             |   1 +
 drivers/pci/controller/pcie-rockchip-host.c        |   2 +-
 drivers/pci/controller/plda/pcie-starfive.c        |   2 +-
 drivers/pci/endpoint/functions/pci-epf-vntb.c      |   4 +-
 drivers/pci/hotplug/pnv_php.c                      | 235 +++++++-
 drivers/pci/pci-driver.c                           |   6 +-
 drivers/pci/pci.h                                  |   2 +-
 drivers/pci/quirks.c                               |   6 +-
 drivers/perf/arm-ni.c                              |   2 +
 drivers/phy/phy-snps-eusb2.c                       |   3 +
 drivers/phy/qualcomm/phy-qcom-eusb2-repeater.c     |  83 +--
 drivers/pinctrl/berlin/berlin.c                    |   8 +-
 drivers/pinctrl/cirrus/pinctrl-madera-core.c       |  14 +-
 drivers/pinctrl/pinctrl-k230.c                     |  13 +-
 drivers/pinctrl/pinmux.c                           |  20 +-
 drivers/pinctrl/sunxi/pinctrl-sunxi.c              |  11 +-
 drivers/platform/x86/intel/pmt/class.c             |   3 +-
 drivers/platform/x86/intel/pmt/class.h             |   1 +
 drivers/platform/x86/oxpec.c                       |  37 +-
 drivers/power/reset/Kconfig                        |   1 +
 drivers/power/sequencing/pwrseq-qcom-wcn.c         |   2 +-
 drivers/power/supply/cpcap-charger.c               |   5 +-
 drivers/power/supply/max14577_charger.c            |   4 +-
 drivers/power/supply/max1720x_battery.c            |  11 +-
 drivers/power/supply/qcom_pmi8998_charger.c        |   4 +-
 drivers/powercap/dtpm_cpu.c                        |   2 +
 drivers/pps/pps.c                                  |  11 +-
 drivers/remoteproc/Kconfig                         |  11 +-
 drivers/remoteproc/qcom_q6v5_pas.c                 | 615 ++++++++++-----------
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
 drivers/scsi/scsi.c                                |   8 +-
 drivers/scsi/scsi_transport_iscsi.c                |   2 +
 drivers/scsi/sd.c                                  |   4 +-
 drivers/soc/qcom/pmic_glink.c                      |   9 +-
 drivers/soc/qcom/qmi_encdec.c                      |  52 +-
 drivers/soc/qcom/qmi_interface.c                   |   6 +-
 drivers/soc/tegra/cbb/tegra234-cbb.c               |   2 +
 drivers/soundwire/debugfs.c                        |   6 +-
 drivers/soundwire/mipi_disco.c                     |   4 +-
 drivers/soundwire/stream.c                         |   2 +-
 drivers/spi/spi-cs42l43.c                          |   2 +-
 drivers/spi/spi-nxp-fspi.c                         |   4 +-
 drivers/spi/spi-stm32.c                            |   8 +-
 drivers/staging/fbtft/fbtft-core.c                 |   1 +
 drivers/staging/gpib/cb7210/cb7210.c               |  15 +-
 drivers/staging/gpib/common/gpib_os.c              |   4 +-
 drivers/staging/greybus/gbphy.c                    |   6 +-
 .../media/atomisp/pci/atomisp_gmin_platform.c      |   9 +-
 drivers/staging/nvec/nvec_power.c                  |   2 +-
 drivers/ufs/core/ufshcd.c                          |  10 +-
 drivers/usb/early/xhci-dbc.c                       |   4 +
 drivers/usb/gadget/composite.c                     |   5 +
 drivers/usb/gadget/function/f_hid.c                |   7 +-
 drivers/usb/gadget/function/uvc_configfs.c         |  10 +
 drivers/usb/host/xhci-plat.c                       |   2 +-
 drivers/usb/misc/apple-mfi-fastcharge.c            |  24 +-
 drivers/usb/serial/option.c                        |   2 +
 drivers/usb/typec/ucsi/ucsi_yoga_c630.c            |  19 +-
 drivers/vdpa/mlx5/core/mr.c                        |   3 +
 drivers/vdpa/mlx5/net/mlx5_vnet.c                  |  12 +-
 drivers/vdpa/vdpa_user/vduse_dev.c                 |   1 +
 drivers/vfio/device_cdev.c                         |  38 +-
 drivers/vfio/group.c                               |   7 +-
 drivers/vfio/iommufd.c                             |   4 +
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c     |   1 +
 drivers/vfio/pci/mlx5/main.c                       |   1 +
 drivers/vfio/pci/nvgrace-gpu/main.c                |   2 +
 drivers/vfio/pci/pds/vfio_dev.c                    |   2 +
 drivers/vfio/pci/qat/main.c                        |   1 +
 drivers/vfio/pci/vfio_pci.c                        |   1 +
 drivers/vfio/pci/vfio_pci_core.c                   |  24 +-
 drivers/vfio/pci/virtio/main.c                     |   3 +
 drivers/vfio/vfio_main.c                           |   3 +-
 drivers/vhost/Kconfig                              |  18 +
 drivers/vhost/scsi.c                               |   6 +-
 drivers/vhost/vhost.c                              | 244 +++++++-
 drivers/vhost/vhost.h                              |  22 +
 drivers/video/fbdev/core/fbcon.c                   |   4 +-
 drivers/video/fbdev/imxfb.c                        |   9 +-
 drivers/watchdog/ziirave_wdt.c                     |   3 +
 drivers/xen/gntdev-common.h                        |   4 +
 drivers/xen/gntdev-dmabuf.c                        |  28 +-
 drivers/xen/gntdev.c                               |  71 ++-
 fs/btrfs/ctree.c                                   |  18 +-
 fs/ceph/crypto.c                                   |  31 +-
 fs/erofs/Kconfig                                   |   2 +
 fs/eventpoll.c                                     |  58 +-
 fs/exfat/file.c                                    |   5 +-
 fs/ext4/inline.c                                   |   2 +
 fs/ext4/inode.c                                    |  13 +-
 fs/ext4/page-io.c                                  |  16 +-
 fs/f2fs/compress.c                                 |  76 +--
 fs/f2fs/data.c                                     |   7 +-
 fs/f2fs/debug.c                                    |  17 +-
 fs/f2fs/extent_cache.c                             |   2 +-
 fs/f2fs/f2fs.h                                     |   4 +-
 fs/f2fs/gc.c                                       |   1 +
 fs/f2fs/inode.c                                    |  21 +-
 fs/f2fs/segment.h                                  |   5 +-
 fs/f2fs/super.c                                    |   1 +
 fs/f2fs/sysfs.c                                    |  21 +
 fs/gfs2/glock.c                                    |   3 +-
 fs/gfs2/util.c                                     |  37 +-
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
 fs/nfs_common/nfslocalio.c                         |  28 +-
 fs/nfsd/localio.c                                  |   5 +-
 fs/nfsd/vfs.c                                      |  10 +-
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
 fs/smb/client/cifsencrypt.c                        |   4 +-
 fs/smb/client/cifsfs.c                             |   2 +-
 fs/smb/client/connect.c                            |   9 +-
 fs/smb/client/fs_context.c                         |  19 +-
 fs/smb/client/fs_context.h                         |  18 +-
 fs/smb/client/link.c                               |  11 +-
 fs/smb/client/reparse.c                            |   2 +-
 fs/smb/client/smbdirect.c                          | 130 ++---
 fs/smb/client/smbdirect.h                          |   4 -
 fs/smb/server/connection.h                         |   1 +
 fs/smb/server/smb2pdu.c                            |  22 +-
 fs/smb/server/smb_common.c                         |   2 +-
 fs/smb/server/transport_rdma.c                     |  97 ++--
 fs/smb/server/transport_tcp.c                      |  17 +
 fs/smb/server/vfs.c                                |   3 +-
 fs/squashfs/block.c                                |  47 +-
 include/crypto/internal/hash.h                     |   6 +
 include/linux/audit.h                              |   9 +-
 include/linux/bpf-cgroup.h                         |   5 -
 include/linux/bpf.h                                |  60 +-
 include/linux/crypto.h                             |   3 +
 include/linux/fortify-string.h                     |   2 +-
 include/linux/fs_context.h                         |   2 +-
 include/linux/i3c/device.h                         |   4 +-
 include/linux/if_team.h                            |   3 -
 include/linux/ioprio.h                             |   3 +-
 include/linux/mlx5/device.h                        |   1 +
 include/linux/mmap_lock.h                          |  30 +
 include/linux/moduleparam.h                        |   5 +-
 include/linux/padata.h                             |   4 -
 include/linux/pps_kernel.h                         |   1 +
 include/linux/proc_fs.h                            |   1 +
 include/linux/psi_types.h                          |   6 +-
 include/linux/ring_buffer.h                        |   4 +-
 include/linux/sched.h                              |   1 +
 include/linux/sched/task_stack.h                   |   2 +-
 include/linux/skbuff.h                             |  23 +
 include/linux/soc/qcom/qmi.h                       |   6 +-
 include/linux/usb/usbnet.h                         |   1 +
 include/linux/vfio.h                               |   4 +
 include/linux/vfio_pci_core.h                      |   2 +
 include/net/bluetooth/hci.h                        |   1 +
 include/net/bluetooth/hci_core.h                   |   6 +
 include/net/dst.h                                  |  24 +-
 include/net/lwtunnel.h                             |   8 +-
 include/net/route.h                                |   4 +-
 include/net/sock.h                                 |  12 +-
 include/net/tc_act/tc_ctinfo.h                     |   6 +-
 include/net/udp.h                                  |  24 +-
 include/rdma/ib_verbs.h                            |  12 +
 include/sound/tas2781-tlv.h                        |   2 +-
 include/trace/events/power.h                       |  22 -
 include/uapi/drm/panthor_drm.h                     |   3 +
 include/uapi/drm/xe_drm.h                          |   8 +-
 include/uapi/linux/vfio.h                          |  12 +-
 include/uapi/linux/vhost.h                         |  29 +
 init/Kconfig                                       |   2 +-
 kernel/audit.h                                     |   2 +-
 kernel/auditsc.c                                   |   2 +-
 kernel/bpf/cgroup.c                                |   8 +-
 kernel/bpf/core.c                                  |  55 +-
 kernel/bpf/helpers.c                               |  11 +-
 kernel/bpf/preload/Kconfig                         |   1 -
 kernel/bpf/syscall.c                               |  19 +-
 kernel/bpf/verifier.c                              |   1 +
 kernel/cgroup/cgroup-v1.c                          |  14 +-
 kernel/events/core.c                               |  36 +-
 kernel/events/uprobes.c                            |   4 +-
 kernel/kcsan/kcsan_test.c                          |   2 +-
 kernel/kexec_core.c                                |   3 +-
 kernel/module/main.c                               |   6 +-
 kernel/padata.c                                    | 132 ++---
 kernel/rcu/refscale.c                              |  10 +-
 kernel/rcu/tree_nocb.h                             |   2 +-
 kernel/sched/core.c                                |   2 +
 kernel/sched/deadline.c                            |  78 ++-
 kernel/sched/fair.c                                |   9 -
 kernel/sched/psi.c                                 | 123 +++--
 kernel/sched/sched.h                               |   1 +
 kernel/trace/power-traces.c                        |   1 -
 kernel/trace/preemptirq_delay_test.c               |  13 +-
 kernel/trace/ring_buffer.c                         |  63 +--
 kernel/trace/rv/monitors/scpd/Kconfig              |   2 +-
 kernel/trace/rv/monitors/sncid/Kconfig             |   2 +-
 kernel/trace/rv/monitors/snep/Kconfig              |   2 +-
 kernel/trace/rv/monitors/wip/Kconfig               |   2 +-
 kernel/trace/rv/rv_trace.h                         |  84 +--
 kernel/trace/trace.c                               |  14 +-
 kernel/trace/trace_events_filter.c                 |  28 +-
 kernel/trace/trace_kdb.c                           |   8 +-
 kernel/ucount.c                                    |   2 +-
 lib/tests/fortify_kunit.c                          |   4 +-
 mm/hmm.c                                           |   2 +-
 mm/mmap_lock.c                                     |   3 +-
 mm/shmem.c                                         |   4 +-
 mm/slub.c                                          |  10 +-
 mm/swapfile.c                                      |  65 +--
 net/bluetooth/coredump.c                           |   6 +-
 net/bluetooth/hci_event.c                          |   8 +-
 net/caif/cfctrl.c                                  | 294 +++++-----
 net/core/devmem.c                                  |   6 +-
 net/core/devmem.h                                  |   7 +-
 net/core/dst.c                                     |   8 +-
 net/core/filter.c                                  |  23 +-
 net/core/neighbour.c                               |  88 ++-
 net/core/netclassid_cgroup.c                       |   4 +-
 net/core/netpoll.c                                 |   7 +
 net/core/skmsg.c                                   |   7 +
 net/core/sock.c                                    |   8 +-
 net/ipv4/inet_connection_sock.c                    |   4 +-
 net/ipv4/ping.c                                    |   2 +-
 net/ipv4/raw.c                                     |   2 +-
 net/ipv4/route.c                                   |   7 +-
 net/ipv4/syncookies.c                              |   3 +-
 net/ipv4/tcp_input.c                               |   4 +-
 net/ipv4/udp.c                                     |   3 +-
 net/ipv6/af_inet6.c                                |   2 +-
 net/ipv6/datagram.c                                |   2 +-
 net/ipv6/inet6_connection_sock.c                   |   4 +-
 net/ipv6/ip6_fib.c                                 |  24 +-
 net/ipv6/ip6_offload.c                             |   4 +-
 net/ipv6/ip6mr.c                                   |   3 +-
 net/ipv6/ping.c                                    |   2 +-
 net/ipv6/raw.c                                     |   2 +-
 net/ipv6/route.c                                   |  79 +--
 net/ipv6/syncookies.c                              |   2 +-
 net/ipv6/tcp_ipv6.c                                |   2 +-
 net/ipv6/udp.c                                     |   5 +-
 net/kcm/kcmsock.c                                  |   6 +
 net/l2tp/l2tp_ip6.c                                |   2 +-
 net/mac80211/cfg.c                                 |  12 +-
 net/mac80211/ieee80211_i.h                         |  15 +
 net/mac80211/main.c                                |  13 +-
 net/mac80211/tdls.c                                |   2 +-
 net/mac80211/tx.c                                  |  14 +-
 net/mptcp/protocol.c                               |   2 +-
 net/netfilter/nf_bpf_link.c                        |   5 +-
 net/netfilter/nf_tables_api.c                      |  29 +-
 net/netfilter/xt_nfacct.c                          |   4 +-
 net/packet/af_packet.c                             |  12 +-
 net/sched/act_ctinfo.c                             |  19 +-
 net/sched/sch_mqprio.c                             |   2 +-
 net/sched/sch_netem.c                              |  40 ++
 net/sched/sch_taprio.c                             |  21 +-
 net/socket.c                                       |   8 +-
 net/sunrpc/svcsock.c                               |  43 +-
 net/sunrpc/xprtsock.c                              |  40 +-
 net/tls/tls_sw.c                                   |  13 +
 net/vmw_vsock/af_vsock.c                           |   3 +-
 net/wireless/nl80211.c                             |   1 +
 net/wireless/reg.c                                 |   2 +
 rust/kernel/devres.rs                              |  10 +-
 rust/kernel/miscdevice.rs                          |   8 +-
 samples/mei/mei-amt-version.c                      |   2 +-
 scripts/gdb/linux/constants.py.in                  |  12 +-
 scripts/kconfig/qconf.cc                           |   2 +-
 security/apparmor/include/match.h                  |   8 +-
 security/apparmor/match.c                          |  23 +-
 security/apparmor/policy_unpack_test.c             |   6 +-
 security/landlock/id.c                             |  69 ++-
 sound/pci/hda/patch_ca0132.c                       |   5 +-
 sound/pci/hda/patch_realtek.c                      |   3 +
 sound/soc/amd/acp/acp-pci.c                        |   8 +-
 sound/soc/amd/acp/amd-acpi-mach.c                  |   4 +-
 sound/soc/amd/acp/amd.h                            |   8 +-
 sound/soc/fsl/fsl_xcvr.c                           |  25 +-
 .../soc/mediatek/common/mtk-afe-platform-driver.c  |   4 +-
 sound/soc/mediatek/common/mtk-base-afe.h           |   1 +
 sound/soc/mediatek/mt8173/mt8173-afe-pcm.c         |   7 +
 sound/soc/mediatek/mt8183/mt8183-afe-pcm.c         |  21 +
 sound/soc/mediatek/mt8186/mt8186-afe-pcm.c         |   7 +
 sound/soc/mediatek/mt8192/mt8192-afe-pcm.c         |   7 +
 sound/soc/rockchip/rockchip_sai.c                  |  16 +-
 sound/soc/sdca/sdca_asoc.c                         |  14 +-
 sound/soc/sdca/sdca_functions.c                    |   3 +-
 sound/soc/sdca/sdca_regmap.c                       |  16 +-
 sound/soc/soc-dai.c                                |  16 +-
 sound/soc/soc-ops.c                                |  28 +-
 sound/soc/sof/intel/Kconfig                        |   3 +-
 sound/usb/mixer_scarlett2.c                        |  14 +-
 sound/x86/intel_hdmi_audio.c                       |   2 +-
 tools/bpf/bpftool/net.c                            |  15 +-
 tools/cgroup/memcg_slabinfo.py                     |   4 +-
 tools/include/nolibc/stdio.h                       |   4 +-
 tools/include/nolibc/sys/wait.h                    |   2 +-
 tools/lib/subcmd/help.c                            |  12 +-
 tools/lib/subcmd/run-command.c                     |  15 +-
 tools/perf/.gitignore                              |   2 -
 tools/perf/arch/x86/include/arch-tests.h           |   4 +
 tools/perf/arch/x86/tests/Build                    |   1 +
 tools/perf/arch/x86/tests/arch-tests.c             |   1 +
 tools/perf/arch/x86/tests/topdown.c                |  76 +++
 tools/perf/arch/x86/util/evsel.c                   |  46 +-
 tools/perf/arch/x86/util/topdown.c                 |  31 +-
 tools/perf/arch/x86/util/topdown.h                 |   4 +
 tools/perf/builtin-sched.c                         | 147 +++--
 tools/perf/tests/bp_account.c                      |   1 +
 tools/perf/util/build-id.c                         |   2 +-
 tools/perf/util/evsel.c                            |  11 +
 tools/perf/util/evsel.h                            |   2 +
 tools/perf/util/hwmon_pmu.c                        |   2 +-
 tools/perf/util/parse-events.c                     |  11 +-
 tools/perf/util/pmu.c                              |   4 +-
 tools/perf/util/python.c                           |  49 +-
 tools/perf/util/symbol.c                           |   1 +
 .../cpupower/utils/idle_monitor/cpupower-monitor.c |   4 -
 tools/power/x86/turbostat/turbostat.c              |  34 +-
 tools/testing/selftests/alsa/utimer-test.c         |   1 +
 tools/testing/selftests/arm64/fp/sve-ptrace.c      |   2 +-
 tools/testing/selftests/bpf/bpf_atomic.h           |   2 +-
 .../selftests/bpf/prog_tests/sockmap_listen.c      |   2 +
 tools/testing/selftests/bpf/veristat.c             |   1 +
 .../breakpoints/step_after_suspend_test.c          |  41 +-
 tools/testing/selftests/cgroup/test_cpu.c          |  63 ++-
 tools/testing/selftests/drivers/net/hw/tso.py      |  99 ++--
 tools/testing/selftests/drivers/net/lib/py/env.py  |   2 +-
 .../ftrace/test.d/event/subsystem-enable.tc        |  28 +-
 tools/testing/selftests/landlock/audit.h           |   7 +-
 tools/testing/selftests/landlock/audit_test.c      |   1 +
 tools/testing/selftests/net/netfilter/ipvs.sh      |   4 +-
 .../net/netfilter/nft_interface_stress.sh          |   5 +-
 tools/testing/selftests/net/rtnetlink.sh           |   6 +
 tools/testing/selftests/net/vlan_hw_filter.sh      |  16 +-
 tools/testing/selftests/nolibc/nolibc-test.c       |  23 +
 tools/testing/selftests/perf_events/.gitignore     |   1 +
 tools/testing/selftests/perf_events/Makefile       |   2 +-
 tools/testing/selftests/perf_events/mmap.c         | 236 ++++++++
 .../selftests/syscall_user_dispatch/sud_test.c     |  50 +-
 tools/testing/selftests/vDSO/vdso_test_chacha.c    |   3 +-
 tools/verification/rv/src/in_kernel.c              |   4 +-
 690 files changed, 7316 insertions(+), 3614 deletions(-)



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 935862C11F3;
	Tue, 19 Aug 2025 12:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755606701; cv=none; b=azk+2gl/2Wvyk1LfXIihwecdb7CzvBULSnSvWlK3yMAQ8xsF6M6uc6jxhdCVHOMtOgHx8TwB4vpA2znRZT33SPlgF/TyfTUKPUdynUTxeaKt8QzrOS9V7F08PxjlsmChN2bGJHPo0JCMfKKo06RO0f1w5LLVNVSv9mk6n4g5tF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755606701; c=relaxed/simple;
	bh=QeBmq/Rm1w1c0eM7/UaXj082So4LBsKb2sWyTlM9ij4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=XnwzTvLXq9uak9jctmc2Rup0TXh8BxdwASxYSxOGX2wIm/0z+OBt73uBTVRo/dOvEOFHDXcEndfLj6n9BtbKwZDeJfCJU+xgHC4lwWpX3IWJyhlsHERyTw51GePW9PZJXmnyd3fo5nDQIOeRo0/hAyDm4RVqedC953/97BMJOcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J/XN26p3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J/XN26p3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF406C4CEF1;
	Tue, 19 Aug 2025 12:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755606701;
	bh=QeBmq/Rm1w1c0eM7/UaXj082So4LBsKb2sWyTlM9ij4=;
	h=From:To:Cc:Subject:Date:From;
	b=J/XN26p3PDUa8ch0z/phouFyNDGxRO0tMDjqNsqmTTLdIBLN+1Nhx88iEycx9ocZs
	 /ZxYiR2XBUxo69W8HqwuntJ1TXmZsYA7sjDuYrPwXwcxo3riySnHWe7kd8A17lyqq6
	 PPYLJ9L8a9V9dDskW4jvsL5bgcc4yZ62ZjzGmR3E=
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
Subject: [PATCH 6.15 000/509] 6.15.11-rc2 review
Date: Tue, 19 Aug 2025 14:31:36 +0200
Message-ID: <20250819122834.836683687@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.11-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.15.11-rc2
X-KernelTest-Deadline: 2025-08-21T12:28+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.15.11 release.
There are 509 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 21 Aug 2025 12:27:20 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.11-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.15.11-rc2

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    dm: split write BIOs on zone boundaries when zone append is not emulated

Frederic Weisbecker <frederic@kernel.org>
    rcu: Fix racy re-initialization of irq_work causing hangs

Ivan Lipski <ivan.lipski@amd.com>
    drm/amd/display: Allow DCN301 to clear update flags

Arnd Bergmann <arnd@arndb.de>
    firmware: arm_scmi: Convert to SYSTEM_SLEEP_PM_OPS

Jens Axboe <axboe@kernel.dk>
    io_uring/rw: cast rw->flags assignment to rwf_t

Damien Le Moal <dlemoal@kernel.org>
    ata: libata-sata: Add link_power_management_supported sysfs attribute

Baochen Qiang <quic_bqiang@quicinc.com>
    wifi: ath12k: install pairwise key first

Aditya Garg <gargaditya08@live.com>
    HID: magicmouse: avoid setting up battery timer when not needed

Sean Christopherson <seanjc@google.com>
    KVM: x86: Convert vcpu_run()'s immediate exit param into a generic bitmap

Maxim Levitsky <mlevitsk@redhat.com>
    KVM: VMX: Wrap all accesses to IA32_DEBUGCTL with getter/setter APIs

Maxim Levitsky <mlevitsk@redhat.com>
    KVM: nVMX: Check vmcs12->guest_ia32_debugctl on nested VM-Enter

Sean Christopherson <seanjc@google.com>
    KVM: VMX: Extract checking of guest's DEBUGCTL into helper

Pedro Falcato <pfalcato@suse.de>
    RDMA/siw: Fix the sendmsg byte count in siw_tcp_sendpages

Willy Tarreau <w@1wt.eu>
    tools/nolibc: fix spelling of FD_SETBITMASK in FD_* macros

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing: fprobe: Fix infinite recursion using preempt_*_notrace()

Marek Szyprowski <m.szyprowski@samsung.com>
    media: v4l2: Add support for NV12M tiled variants to v4l2_format_info()

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Do not mark valid metadata as invalid

Vedang Nagar <quic_vnagar@quicinc.com>
    media: venus: Fix OOB read due to missing payload bound check

Youngjun Lee <yjjuny.lee@samsung.com>
    media: uvcvideo: Fix 1-byte out-of-bounds read in uvc_parse_format()

Breno Leitao <leitao@debian.org>
    mm/kmemleak: avoid deadlock by moving pr_warn() outside kmemleak_lock

Waiman Long <longman@redhat.com>
    mm/kmemleak: avoid soft lockup in __kmemleak_do_cleanup()

Kairui Song <kasong@tencent.com>
    mm/shmem, swap: improve cached mTHP handling and fix potential hang

Anshuman Khandual <anshuman.khandual@arm.com>
    mm/ptdump: take the memory hotplug lock inside ptdump_walk_pgd()

David Hildenbrand <david@redhat.com>
    mm/huge_memory: don't ignore queried cachemode in vmf_insert_pfn_pud()

Vlastimil Babka <vbabka@suse.cz>
    mm, slab: restore NUMA policy support for large kmalloc

Randy Dunlap <rdunlap@infradead.org>
    parisc: Makefile: fix a typo in palo.conf

Haiyang Zhang <haiyangz@microsoft.com>
    hv_netvsc: Fix panic during namespace deletion with VF

Davide Caratti <dcaratti@redhat.com>
    net/sched: ets: use old 'nbands' while purging unused classes

Lizhi Xu <lizhi.xu@windriver.com>
    ocfs2: reset folio to NULL when get folio fails

Randy Dunlap <rdunlap@infradead.org>
    fbdev: nvidiafb: add depends on HAS_IOPORT

Sravan Kumar Gundu <sravankumarlpu@gmail.com>
    fbdev: Fix vmalloc out-of-bounds write in fast_imageblit

Suren Baghdasaryan <surenb@google.com>
    userfaultfd: fix a crash in UFFDIO_MOVE when PMD is a migration entry

Andrey Albershteyn <aalbersh@redhat.com>
    xfs: fix scrub trace with null pointer in quotacheck

Qu Wenruo <wqu@suse.com>
    btrfs: do not allow relocation of partially dropped subvolumes

Boris Burkov <boris@bur.io>
    btrfs: fix iteration bug in __qgroup_excl_accounting()

Qu Wenruo <wqu@suse.com>
    btrfs: fix wrong length parameter for btrfs_cleanup_ordered_extents()

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: zoned: do not select metadata BG as finish target

Filipe Manana <fdmanana@suse.com>
    btrfs: error on missing block group when unaccounting log tree extent buffers

Filipe Manana <fdmanana@suse.com>
    btrfs: fix log tree replay failure due to file with 0 links and extents

Filipe Manana <fdmanana@suse.com>
    btrfs: send: use fallocate for hole punching with send stream v2

Filipe Manana <fdmanana@suse.com>
    btrfs: clear dirty status from extent buffer on error at insert_new_root()

Filipe Manana <fdmanana@suse.com>
    btrfs: don't skip remaining extrefs if dir not found during log replay

Filipe Manana <fdmanana@suse.com>
    btrfs: qgroup: fix qgroup create ioctl returning success after quotas disabled

Caleb Sander Mateos <csander@purestorage.com>
    btrfs: don't skip accounting in early ENOTTY return in btrfs_uring_encoded_read()

Qu Wenruo <wqu@suse.com>
    btrfs: populate otime when logging an inode item

Filipe Manana <fdmanana@suse.com>
    btrfs: qgroup: fix race between quota disable and quota rescan ioctl

Boris Burkov <boris@bur.io>
    btrfs: fix ssd_spread overallocation

Filipe Manana <fdmanana@suse.com>
    btrfs: don't ignore inode missing when replaying log tree

Filipe Manana <fdmanana@suse.com>
    btrfs: qgroup: set quota enabled bit if quota disable fails flushing reservations

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: zoned: do not remove unwritten non-data block group

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: zoned: requeue to unused block group list if zone finish failed

Filipe Manana <fdmanana@suse.com>
    btrfs: abort transaction during log replay if walk_log_tree() failed

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    btrfs: zoned: use filesystem size not disk size for reclaim decision

Oliver Neukum <oneukum@suse.com>
    cdc-acm: fix race between initial clearing halt and open

Sebastian Reichel <sebastian.reichel@collabora.com>
    usb: typec: fusb302: cache PD RX state

Eric Biggers <ebiggers@kernel.org>
    thunderbolt: Fix copy+paste error in match_service_id()

Ian Abbott <abbotti@mev.co.uk>
    comedi: fix race between polling and detaching

Myrrh Periwinkle <myrrhperiwinkle@qtmlabs.xyz>
    usb: typec: ucsi: Update power_supply on power role change

Ricky Wu <ricky_wu@realtek.com>
    misc: rtsx: usb: Ensure mmc child device is active when card is present

Xinyu Liu <katieeliu@tencent.com>
    usb: core: config: Prevent OOB read in SS endpoint companion parsing

Zhang Yi <yi.zhang@huawei.com>
    ext4: initialize superblock fields in the kballoc-test.c kunit tests

Baokun Li <libaokun1@huawei.com>
    ext4: fix largest free orders lists corruption on mb_optimize_scan switch

Baokun Li <libaokun1@huawei.com>
    ext4: fix zombie groups in average fragment size lists

Jason Gunthorpe <jgg@ziepe.ca>
    iommufd: Prevent ALIGN() overflow

Nicolin Chen <nicolinc@nvidia.com>
    iommufd: Report unmapped bytes in the error path of iopt_unmap_iova_range

Alexey Klimov <alexey.klimov@linaro.org>
    iommu/arm-smmu-qcom: Add SM6115 MDSS compatible

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Optimize iotlb_sync_map for non-caching/non-RWBF modes

Shyam Prasad N <sprasad@microsoft.com>
    cifs: reset iface weights when we cannot find a candidate

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    clk: qcom: dispcc-sm8750: Fix setting rate byte and pixel clocks

Christian Marangi <ansuelsmth@gmail.com>
    clk: qcom: gcc-ipq8074: fix broken freq table for nss_port6_tx_clk_src

Damien Le Moal <dlemoal@kernel.org>
    dm: Always split write BIOs to zoned device limits

Damien Le Moal <dlemoal@kernel.org>
    block: Introduce bio_needs_zone_write_plugging()

Bijan Tabatabai <bijantabatab@micron.com>
    mm/damon/core: commit damos->target_nid

SeongJae Park <sj@kernel.org>
    samples/damon/wsse: fix boot time enable handling

Miguel Ojeda <ojeda@kernel.org>
    rust: workaround `rustdoc` target modifiers bug

Miguel Ojeda <ojeda@kernel.org>
    rust: kbuild: clean output before running `rustdoc`

Jack Xiao <Jack.Xiao@amd.com>
    drm/amdgpu: fix incorrect vm flags to map bo

YiPeng Chai <YiPeng.Chai@amd.com>
    drm/amdgpu: fix vram reservation issue

Jouni Högander <jouni.hogander@intel.com>
    drm/i915/psr: Do not trigger Frame Change events from frontbuffer flush

David Howells <dhowells@redhat.com>
    cifs: Fix collect_sample() to handle any iterator type

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_sai: replace regmap_write with regmap_update_bits

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

John Garry <john.g.garry@oracle.com>
    block: avoid possible overflow for chunk_sectors check in blk_stack_limits()

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: avs: Fix uninitialized pointer error in probe()

Buday Csaba <buday.csaba@prolan.hu>
    net: phy: smsc: add proper reset flags for LAN8710A

Peter Jakubek <peterjakubek@gmail.com>
    ASoC: Intel: sof_sdw: Add quirk for Alienware Area 51 (2025) 0CCC SKU

Thomas Croft <thomasmcft@gmail.com>
    ALSA: hda/realtek: add LG gram 16Z90R-A to alc269 fixup table

Yu Kuai <yukuai3@huawei.com>
    lib/sbitmap: convert shallow_depth from one word to the whole sbitmap

Stefan Metzmacher <metze@samba.org>
    smb: client: don't call init_waitqueue_head(&info->conn_wait) twice in _smbd_get_connection

Calvin Owens <calvin@wbinvd.org>
    tools/power turbostat: Handle cap_get_proc() ENOSYS

Calvin Owens <calvin@wbinvd.org>
    tools/power turbostat: Fix build with musl

Len Brown <len.brown@intel.com>
    tools/power turbostat: Handle non-root legacy-uncore sysfs permissions

Corey Minyard <corey@minyard.net>
    ipmi: Fix strcpy source and destination the same

Yann E. MORIN <yann.morin.1998@free.fr>
    kconfig: lxdialog: fix 'space' to (de)select options

Masahiro Yamada <masahiroy@kernel.org>
    kheaders: rebuild kheaders_data.tar.xz when a file is modified within a minute

Masahiro Yamada <masahiroy@kernel.org>
    kconfig: gconf: fix potential memory leak in renderer_edited()

Masahiro Yamada <masahiroy@kernel.org>
    kconfig: gconf: avoid hardcoding model2 in on_treeview2_cursor_changed()

Breno Leitao <leitao@debian.org>
    ipmi: Use dev_warn_ratelimited() for incorrect message warnings

Artem Sadovnikov <a.sadovnikov@ispras.ru>
    vfio/mlx5: fix possible overflow in tracking max message size

John Garry <john.g.garry@oracle.com>
    scsi: aacraid: Stop using PCI_IRQ_AFFINITY

Maurizio Lombardi <mlombard@redhat.com>
    scsi: target: core: Generate correct identifiers for PR OUT transport IDs

Ranjan Kumar <ranjan.kumar@broadcom.com>
    scsi: Fix sas_user_scan() to handle wildcard and multi-channel scans

Shankari Anand <shankari.ak0208@gmail.com>
    kconfig: nconf: Ensure null termination where strncpy is used

Keith Busch <kbusch@kernel.org>
    vfio/type1: conditional rescheduling while pinning

Suchit Karunakaran <suchitkarunakaran@gmail.com>
    kconfig: lxdialog: replace strcpy() with strncpy() in inputbox.c

John Ogness <john.ogness@linutronix.de>
    printk: nbcon: Allow reacquire during panic

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: check the generic conditions first

Yuezhang Mo <Yuezhang.Mo@sony.com>
    exfat: add cluster chain loop check for dir

fangzhong.zhou <myth5@myth5.com>
    i2c: Force DLL0945 touchpad i2c freq to 100khz

John Johansen <john.johansen@canonical.com>
    apparmor: fix x_table_lookup when stacking is not the first entry

Mateusz Guzik <mjguzik@gmail.com>
    apparmor: use the condition in AA_BUG_FMT even with debug disabled

Benjamin Marzinski <bmarzins@redhat.com>
    dm-table: fix checking for rq stackable devices

Mikulas Patocka <mpatocka@redhat.com>
    dm-mpath: don't print the "loaded" message if registering fails

Jorge Marques <jorge.marques@analog.com>
    i3c: master: Initialize ret in i3c_i2c_notifier_call()

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i3c: don't fail if GETHDRCAP is unsupported

Gabriel Totev <gabriel.totev@zetier.com>
    apparmor: shift ouid when mediating hard links in userns

Meagan Lloyd <meaganlloyd@linux.microsoft.com>
    rtc: ds1307: handle oscillator stop flag (OSF) for ds1341

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i3c: add missing include to internal header

Petr Pavlu <petr.pavlu@suse.com>
    module: Prevent silent truncation of module name in delete_module(2)

Purva Yeshi <purvayeshi550@gmail.com>
    md: dm-zoned-target: Initialize return variable r to avoid uninitialized use

Charles Keepax <ckeepax@opensource.cirrus.com>
    soundwire: Move handle_nested_irq outside of sdw_dev_lock

Vijendar Mukunda <Vijendar.Mukunda@amd.com>
    soundwire: amd: cancel pending slave status handling workqueue during remove sequence

Vijendar Mukunda <Vijendar.Mukunda@amd.com>
    soundwire: amd: serialize amd manager resume sequence during pm_prepare

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    clk: renesas: rzg2l: Postpone updating priv->clks[]

Mario Limonciello <mario.limonciello@amd.com>
    crypto: ccp - Add missing bootloader info reg for pspv6

Bharat Bhushan <bbhushan2@marvell.com>
    crypto: octeontx2 - add timeout for load_fvc completion poll

chenchangcheng <chenchangcheng@kylinos.cn>
    media: uvcvideo: Fix bandwidth issue for Alcor camera

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Set V4L2_CTRL_FLAG_DISABLED during queryctrl errors

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Add quirk for HP Webcam HD 2300

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

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    media: raspberrypi: cfe: Fix min_reqbufs_allocation

Cheick Traore <cheick.traore@foss.st.com>
    pinctrl: stm32: Manage irq affinity settings

Damien Le Moal <dlemoal@kernel.org>
    scsi: mpi3mr: Correctly handle ATA device errors

Francisco Gutierrez <frankramirez@google.com>
    scsi: pm80xx: Free allocated tags after failure

Damien Le Moal <dlemoal@kernel.org>
    scsi: mpt3sas: Correctly handle ATA device errors

Li Chen <chenl311@chinatelecom.cn>
    HID: rate-limit hid_warn to prevent log flooding

Abel Vesa <abel.vesa@linaro.org>
    power: supply: qcom_battmgr: Add lithium-polymer entry

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Check for hdwq null ptr when cleaning up lpfc_vport structure

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Ensure HBA_SETUP flag is used only for SLI4 in dev_loss_tmo_callbk

Arnd Bergmann <arnd@arndb.de>
    RDMA/core: reduce stack using in nldev_stat_get_doit()

Yury Norov [NVIDIA] <yury.norov@gmail.com>
    RDMA: hfi1: fix possible divide-by-zero in find_hw_thread_mask()

Amelie Delaunay <amelie.delaunay@foss.st.com>
    dmaengine: stm32-dma: configure next sg only if there are more than 2 sgs

Johan Adolfsson <johan.adolfsson@axis.com>
    leds: leds-lp50xx: Handle reg to get correct multi_index

Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
    media: v4l2-common: Reduce warnings about missing V4L2_CID_LINK_FREQ control

Daniel Scally <dan.scally@ideasonboard.com>
    media: ipu-bridge: Add _HID for OV5670

Michal Wilczynski <m.wilczynski@samsung.com>
    clk: thead: Mark essential bus clocks as CLK_IGNORE_UNUSED

Dikshita Agarwal <quic_dikshita@quicinc.com>
    media: iris: Add handling for corrupt and drop frames

Shiji Yang <yangshiji66@outlook.com>
    MIPS: lantiq: falcon: sysctrl: fix request memory check logic

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    MIPS: Don't crash in stack_top() for tasks without ABI or vDSO

Markus Theil <theil.markus@gmail.com>
    crypto: jitter - fix intermediary handling

Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
    RDMA/bnxt_re: Fix size of uverbs_copy_to() in BNXT_RE_METHOD_GET_TOGGLE_MEM

Hans de Goede <hdegoede@redhat.com>
    media: hi556: Fix reset GPIO timings

Arnaud Lecomte <contact@arnaud-lcm.com>
    jfs: upper bound check of tree index in dbAllocAG

Edward Adam Davis <eadavis@qq.com>
    jfs: Regular file corruption check

Lizhi Xu <lizhi.xu@windriver.com>
    jfs: truncate good inode pages when hard link is 0

jackysliu <1972843537@qq.com>
    scsi: bfa: Double-free fix

Ziyan Fu <fuzy5@lenovo.com>
    watchdog: iTCO_wdt: Report error if timeout configuration fails

Shiji Yang <yangshiji66@outlook.com>
    MIPS: vpe-mt: add missing prototypes for vpe_{alloc,start,stop,free}

George Moussalem <george.moussalem@outlook.com>
    clk: qcom: ipq5018: keep XO clock always on

Florin Leotescu <florin.leotescu@nxp.com>
    hwmon: (emc2305) Set initial PWM minimum value during probe based on thermal state

Sebastian Reichel <sebastian.reichel@collabora.com>
    watchdog: dw_wdt: Fix default timeout

Amir Mohammad Jahangirzad <a.jahangirzad@gmail.com>
    fs/orangefs: use snprintf() instead of sprintf()

Showrya M N <showrya@chelsio.com>
    scsi: libiscsi: Initialize iscsi_conn->dd_data only if memory is allocated

Valmantas Paliksa <walmis@gmail.com>
    phy: rockchip-pcie: Enable all four lanes if required

Geraldo Nascimento <geraldogabriel@gmail.com>
    phy: rockchip-pcie: Properly disable TEST_WRITE strobe signal

Chen-Yu Tsai <wens@csie.org>
    mfd: axp20x: Set explicit ID for AXP313 regulator

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    sphinx: kernel_abi: fix performance regression with O=<dir>

Pei Xiao <xiaopei01@kylinos.cn>
    clk: tegra: periph: Fix error handling and resolve unsigned compare warning

Theodore Ts'o <tytso@mit.edu>
    ext4: do not BUG when INLINE_DATA_FL lacks system.data xattr

Zhiqi Song <songzhiqi1@huawei.com>
    crypto: hisilicon/hpre - fix dma unmap sequence

Yongzhen Zhang <zhangyongzhen@kylinos.cn>
    fbdev: fix potential buffer overflow in do_register_framebuffer()

Paulo Alcantara <pc@manguebit.org>
    smb: client: fix session setup against servers that require SPN

Pali Rohár <pali@kernel.org>
    cifs: Fix calling CIFSFindFirst() for root path without msearch

Aaron Plattner <aplattner@nvidia.com>
    watchdog: sbsa: Adjust keepalive timeout to avoid MediaTek WS0 race condition

Roman Li <Roman.Li@amd.com>
    drm/amd/display: Disable dsc_power_gate for dcn314 by default

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd/display: Avoid configuring PSR granularity if PSR-SU not supported

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd/display: Only finalize atomic_obj if it was initialized

Jason Wang <jasowang@redhat.com>
    vhost: fail early when __vhost_add_used() fails

Will Deacon <will@kernel.org>
    vsock/virtio: Resize receive buffers so that each SKB fits in a 4K page

Álvaro Fernández Rojas <noltari@gmail.com>
    net: dsa: b53: fix IP_MULTICAST_CTRL on BCM5325

Joel Fernandes <joelagnelf@nvidia.com>
    rcu: Fix rcu_read_unlock() deadloop due to IRQ work

Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
    drm/ttm: Respect the shrinker core free target

Wayne Lin <Wayne.Lin@amd.com>
    drm/amd/display: Avoid trying AUX transactions on disconnected ports

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Update DMCUB loading sequence for DCN3.5

Yonghong Song <yonghong.song@linux.dev>
    selftests/bpf: Fix a user_ringbuf failure with arm64 64KB page size

Yonghong Song <yonghong.song@linux.dev>
    selftests/bpf: Fix ringbuf/ringbuf_write test failure with arm64 64KB page size

Ihor Solodrai <isolodrai@meta.com>
    bpf: Make reg_not_null() true for CONST_PTR_TO_MAP

Jakub Kicinski <kuba@kernel.org>
    uapi: in6: restore visibility of most IPv6 socket options

Emily Deng <Emily.Deng@amd.com>
    drm/ttm: Should to return the evict error

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    drm: renesas: rz-du: mipi_dsi: Add min check for VCLK range

Hari Kalavakunta <kalavakunta.hari.prasad@gmail.com>
    net: ncsi: Fix buffer overflow in fetching version id

Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
    drm/xe: Make dma-fences compliant with the safe access rules

Shannon Nelson <shannon.nelson@amd.com>
    ionic: clean dbpage in de-init

Thomas Fourier <fourier.thomas@gmail.com>
    wifi: rtlwifi: fix possible skb memory leak in _rtl_pci_init_one_rxdesc()

Chih-Kang Chang <gary.chang@realtek.com>
    wifi: rtw89: scan abort when assign/unassign_vif

Breno Leitao <leitao@debian.org>
    ptp: Use ratelimite for freerun error message

Yuan Chen <chenyuan@kylinos.cn>
    bpftool: Fix JSON writer resource leak in version command

Álvaro Fernández Rojas <noltari@gmail.com>
    net: dsa: b53: prevent SWITCH_CTRL access on BCM5325

Álvaro Fernández Rojas <noltari@gmail.com>
    net: dsa: b53: prevent DIS_LEARNING access on BCM5325

Álvaro Fernández Rojas <noltari@gmail.com>
    net: dsa: b53: prevent GMII_PORT_OVERRIDE_CTRL access on BCM5325

Álvaro Fernández Rojas <noltari@gmail.com>
    net: dsa: b53: fix b53_imp_vlan_setup for BCM5325

Álvaro Fernández Rojas <noltari@gmail.com>
    net: dsa: b53: ensure BCM5325 PHYs are enabled

Alok Tiwari <alok.a.tiwari@oracle.com>
    gve: Return error for unknown admin queue command

Gal Pressman <gal@nvidia.com>
    net: vlan: Replace BUG() with WARN_ON_ONCE() in vlan_dev_* stubs

Gal Pressman <gal@nvidia.com>
    net: vlan: Make is_vlan_dev() a stub when VLAN is not configured

ganglxie <ganglxie@amd.com>
    drm/amdgpu: clear pa and mca record counter when resetting eeprom

Lijo Lazar <lijo.lazar@amd.com>
    drm/amdgpu: Suspend IH during mode-2 reset

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd/display: Stop storing failures into adev->dm.cached_state

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd: Allow printing VanGogh OD SCLK levels without setting dpm to manual

Heiner Kallweit <hkallweit1@gmail.com>
    dpaa_eth: don't use fixed_phy_change_carrier

Stanislaw Gruszka <stf_xl@wp.pl>
    wifi: iwlegacy: Check rate_idx range after addition

Mark Rutland <mark.rutland@arm.com>
    arm64: stacktrace: Check kretprobe_find_ret_addr() return value

Mina Almasry <almasrymina@google.com>
    netmem: fix skb_frag_address_safe with unreadable skbs

Thomas Fourier <fourier.thomas@gmail.com>
    powerpc: floppy: Add missing checks after DMA map

Karthikeyan Kathirvel <quic_kathirve@quicinc.com>
    wifi: ath12k: Decrement TID on RX peer frag setup error handling

Raj Kumar Bhagat <quic_rajkbhag@quicinc.com>
    wifi: ath12k: Enable REO queue lookup table feature on QCN9274 hw2.0

Ching-Te Ku <ku920601@realtek.com>
    wifi: rtw89: coex: Not to set slot duration to zero to avoid firmware issue

Thomas Fourier <fourier.thomas@gmail.com>
    wifi: rtlwifi: fix possible skb memory leak in `_rtl_pci_rx_interrupt()`.

Ramya Gnanasekar <ramya.gnanasekar@oss.qualcomm.com>
    wifi: mac80211: update radar_required in channel context after channel switch

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Initialize mode_select to 0

Wen Chen <Wen.Chen3@amd.com>
    drm/amd/display: Fix 'failed to blank crtc!'

Zqiang <qiang.zhang1211@gmail.com>
    rcutorture: Fix rcutorture_one_extend_check() splat in RT kernels

Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
    wifi: iwlwifi: fw: Fix possible memory leak in iwl_fw_dbg_collect

Johannes Berg <johannes.berg@intel.com>
    wifi: iwlwifi: mld: fix last_mlo_scan_time type

Miri Korenblit <miriam.rachel.korenblit@intel.com>
    wifi: iwlwifi: mld: don't exit EMLSR when we shouldn't

Rand Deeb <rand.sec96@gmail.com>
    wifi: iwlwifi: dvm: fix potential overflow in rs_fill_link_cmd()

Nathan Lynch <nathan.lynch@amd.com>
    lib: packing: Include necessary headers

Hari Chandrakanthan <quic_haric@quicinc.com>
    wifi: ath12k: Fix station association with MBSSID Non-TX BSS

Sarika Sharma <quic_sarishar@quicinc.com>
    wifi: ath12k: Add memset and update default rate value in wmi tx completion

Andy Yan <andy.yan@rock-chips.com>
    drm/panel: raydium-rm67200: Move initialization from enable() to prepare stage

Kang Yang <kang.yang@oss.qualcomm.com>
    wifi: ath10k: shutdown driver when hardware is unreliable

Peichen Huang <PeiChen.Huang@amd.com>
    drm/amd/display: add null check

Ilya Bakoulin <Ilya.Bakoulin@amd.com>
    drm/amd/display: Separate set_gsl from set_gsl_source_select

Xiang Liu <xiang.liu@amd.com>
    drm/amdgpu: Use correct severity for BP threshold exceed event

Jonas Rebmann <jre@pengutronix.de>
    net: fec: allow disable coalescing

RubenKelevra <rubenkelevra@gmail.com>
    net: ieee8021q: fix insufficient table-size assertion

Li Chen <chenl311@chinatelecom.cn>
    ACPI: Suppress misleading SPCR console message when SPCR table is absent

Eric Work <work.eric@gmail.com>
    net: atlantic: add set_power to fw_ops for atl2 to fix wol

Aakash Kumar S <saakashkumar@marvell.com>
    xfrm: Duplicate SPI Handling

zhangjianrong <zhangjianrong5@huawei.com>
    net: thunderbolt: Fix the parameter passing of tb_xdomain_enable_paths()/tb_xdomain_disable_paths()

zhangjianrong <zhangjianrong5@huawei.com>
    net: thunderbolt: Enable end-to-end flow control also in transmit

Matt Roper <matthew.d.roper@intel.com>
    drm/xe/xe_query: Use separate iterator while filling GT list

Mark Brown <broonie@kernel.org>
    kselftest/arm64: Specify SVE data when testing VL set in sve-ptrace

David Bauer <mail@david-bauer.net>
    wifi: mt76: mt7915: mcu: increase eeprom command timeout

David Bauer <mail@david-bauer.net>
    wifi: mt76: mt7915: mcu: re-init MCU before loading FW patch

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtw89: Disable deep power saving for USB/SDIO

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtw89: Fix rtw89_mac_power_switch() for USB

Alessio Belle <alessio.belle@imgtec.com>
    drm/imagination: Clear runtime PM errors while resetting the GPU

Robin Murphy <robin.murphy@arm.com>
    perf/arm: Add missing .suppress_bind_attrs

Yuan Chen <chenyuan@kylinos.cn>
    drm/msm: Add error handling for krealloc in metadata setup

Rob Clark <robdclark@chromium.org>
    drm/msm: use trylock for debugfs

Rob Clark <robin.clark@oss.qualcomm.com>
    drm/msm: Update register xml

Thierry Reding <treding@nvidia.com>
    drm/fbdev-client: Skip DRM clients if modesetting is absent

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: fix vif link allocation

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mt76: mt7996: Fix mlink lookup in mt7996_tx_prepare_skb

Hari Chandrakanthan <quic_haric@quicinc.com>
    wifi: mac80211: fix rx link assignment for non-MLO stations

Zqiang <qiang.zhang1211@gmail.com>
    rcu/nocb: Fix possible invalid rdp's->nocb_cb_kthread pointer access

Kuniyuki Iwashima <kuniyu@google.com>
    ipv6: mcast: Check inet6_dev->dead under idev->mc_lock in __ipv6_dev_mc_inc().

Thomas Fourier <fourier.thomas@gmail.com>
    (powerpc/512) Fix possible `dma_unmap_single()` on uninitialized pointer

Heiko Carstens <hca@linux.ibm.com>
    s390/early: Copy last breaking event address to pt_regs

Miri Korenblit <miriam.rachel.korenblit@intel.com>
    wifi: mac80211: avoid weird state in error path

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: don't complete management TX on SAE commit

Chris Mason <clm@fb.com>
    sched/fair: Bump sd->max_newidle_lb_cost when newidle balance fails

Nam Cao <namcao@linutronix.de>
    rv: Add #undef TRACE_INCLUDE_FILE

Kamil Horák - 2N <kamilh@axis.com>
    net: phy: bcm54811: PHY initialization

Sven Schnelle <svens@linux.ibm.com>
    s390/stp: Remove udelay from stp_sync_clock()

Philipp Stanner <phasta@kernel.org>
    drm/sched: Avoid memory leaks with cancel_job() callback

Avraham Stern <avraham.stern@intel.com>
    wifi: iwlwifi: mvm: fix scan request validation

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    um: Re-evaluate thread flags repeatedly

Avraham Stern <avraham.stern@intel.com>
    wifi: iwlwifi: mld: fix scan request validation

Miri Korenblit <miriam.rachel.korenblit@intel.com>
    wifi: iwlwifi: mvm: set gtk id also in older FWs

Paul Chaignon <paul.chaignon@gmail.com>
    bpf: Forget ranges when refining tnum after JSET

Juri Lelli <juri.lelli@redhat.com>
    sched/deadline: Fix accounting after global limits change

Alok Tiwari <alok.a.tiwari@oracle.com>
    perf/cxlpmu: Remove unintended newline from IRQ name format string

Biju Das <biju.das.jz@bp.renesas.com>
    net: phy: micrel: Add ksz9131_resume()

Alok Tiwari <alok.a.tiwari@oracle.com>
    net: thunderx: Fix format-truncation warning in bgx_acpi_match_id()

Oscar Maes <oscmaes92@gmail.com>
    net: ipv4: fix incorrect MTU in broadcast routes

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: don't unreserve never reserved chanctx

Ilan Peer <ilan.peer@intel.com>
    wifi: cfg80211: Fix interface type validation

Miri Korenblit <miriam.rachel.korenblit@intel.com>
    wifi: mac80211: handle WLAN_HT_ACTION_NOTIFY_CHANWIDTH async

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: don't use TPE data from assoc response

Matt Johnston <matt@codeconstruct.com.au>
    net: mctp: Prevent duplicate binds

Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    can: ti_hecc: fix -Woverflow compiler warning

Charlene Liu <Charlene.Liu@amd.com>
    drm/amd/display: limit clear_update_flags to dcn32 and above

Paul E. McKenney <paulmck@kernel.org>
    rcu: Protect ->defer_qs_iw_pending from data race

Umio Yasuno <coelacanth_dream@protonmail.com>
    drm/amd/pm: fix null pointer access

Breno Leitao <leitao@debian.org>
    arm64: Mark kernel as tainted on SAE and SError panic

Jack Ping CHNG <jchng@maxlinear.com>
    net: pcs: xpcs: mask readl() return value to 16 bits

Leon Romanovsky <leon@kernel.org>
    net/mlx5e: Properly access RCU protected qdisc_sleeping variable

Thomas Fourier <fourier.thomas@gmail.com>
    net: ag71xx: Add missing check after DMA map

Thomas Fourier <fourier.thomas@gmail.com>
    et131x: Add missing check after DMA map

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtw89: Lower the timeout in rtw89_fw_read_c2h_reg() for USB

Chin-Yen Lee <timlee@realtek.com>
    wifi: rtw89: wow: Add Basic Rate IE to probe request in scheduled scan mode

Matteo Croce <teknoraver@meta.com>
    libbpf: Fix warning in calloc() usage

Ahmed Zaki <ahmed.zaki@intel.com>
    idpf: preserve coalescing settings across resets

Eduard Zingerman <eddyz87@gmail.com>
    libbpf: Verify that arena map exists when adding arena relocations

Alok Tiwari <alok.a.tiwari@oracle.com>
    be2net: Use correct byte order and format string for TCP seq and ack_seq

Sven Schnelle <svens@linux.ibm.com>
    s390/time: Use monotonic clock in get_cycles()

Sven Schnelle <svens@linux.ibm.com>
    s390/sclp: Use monotonic clock in sclp_sync_wait()

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211: reject HTC bit for management frames

Steven Rostedt <rostedt@goodmis.org>
    ktest.pl: Prevent recursion of default variable options

Sarika Sharma <quic_sarishar@quicinc.com>
    wifi: ath12k: Correct tid cleanup when tid setup fails

Oliver Neukum <oneukum@suse.com>
    net: usb: cdc-ncm: check for filtering capability

Avraham Stern <avraham.stern@intel.com>
    wifi: iwlwifi: mvm: avoid outdated reorder buffer head_sn

Avraham Stern <avraham.stern@intel.com>
    wifi: iwlwifi: mld: avoid outdated reorder buffer head_sn

Miri Korenblit <miriam.rachel.korenblit@intel.com>
    wifi: iwlwifi: mld: use spec link id and not FW link id

Anthoine Bourgeois <anthoine.bourgeois@vates.tech>
    xen/netfront: Fix TX response spurious interrupts

Uwe Kleine-König <ukleinek@debian.org>
    Bluetooth: btusb: Add support for variant of RTL8851BE (USB ID 13d3:3601)

Zijun Hu <zijun.hu@oss.qualcomm.com>
    Bluetooth: hci_sock: Reset cookie to zero in hci_sock_free_cookie()

Yang Li <yang.li@amlogic.com>
    Bluetooth: hci_event: Add support for handling LE BIG Sync Lost event

En-Wei Wu <en-wei.wu@canonical.com>
    Bluetooth: btusb: Add new VID/PID 0489/e14e for MT7925

Nam Cao <namcao@linutronix.de>
    verification/dot2k: Make a separate dot2k_templates/Kconfig_container

Steven Rostedt <rostedt@goodmis.org>
    powerpc/thp: tracing: Hide hugepage events under CONFIG_PPC_BOOK3S_64

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    selftests: netfilter: Enable CONFIG_INET_SCTP_DIAG

Florian Westphal <fw@strlen.de>
    netfilter: nft_set_pipapo: prefer kvmalloc for scratch maps

Srinivas Kandagatla <srini@kernel.org>
    ASoC: qcom: use drvdata instead of component to keep id

Xinxin Wan <xinxin.wan@intel.com>
    ASoC: codecs: rt5640: Retry DEVICE_ID verification

Jonathan Santos <Jonathan.Santos@analog.com>
    iio: adc: ad7768-1: Ensure SYNC_IN pulse minimum timing requirement

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    ALSA: usb-audio: Avoid precedence issues in mixer_quirks macros

Christophe Leroy <christophe.leroy@csgroup.eu>
    ALSA: pcm: Rewrite recalculate_boundary() to avoid costly loop

Lucy Thrun <lucy.thrun@digital-rabbithole.de>
    ALSA: hda/ca0132: Fix buffer overflow in add_tuning_control

Tomasz Michalec <tmichalec@google.com>
    platform/chrome: cros_ec_typec: Defer probe on missing EC parent

Kees Cook <kees@kernel.org>
    platform/x86: thinkpad_acpi: Handle KCOV __init vs inline mismatches

Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
    soc: qcom: mdt_loader: Actually use the e_phoff

Krzysztof Hałasa <khalasa@piap.pl>
    imx8m-blk-ctrl: set ISI panic write hurry level

Gautham R. Shenoy <gautham.shenoy@amd.com>
    pm: cpupower: Fix the snapshot-order of tsc,mperf, clock in mperf_stop()

Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
    usb: dwc3: xilinx: add shutdown callback

Oliver Neukum <oneukum@suse.com>
    usb: core: usb_submit_urb: downgrade type check

Tomasz Michalec <tmichalec@google.com>
    usb: typec: intel_pmc_mux: Defer probe if SCU IPC isn't present

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: core: Check for rtd == NULL in snd_soc_remove_pcm_runtime()

Joseph Tilahun <jtilahun@astranis.com>
    tty: serial: fix print format specifiers

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: topology: Parse the dapm_widget_tokens in case of DSPless mode

Markus Stockhausen <markus.stockhausen@gmx.de>
    irqchip/mips-gic: Allow forced affinity

Alok Tiwari <alok.a.tiwari@oracle.com>
    ALSA: intel8x0: Fix incorrect codec index usage in mixer for ICH4

Mark Brown <broonie@kernel.org>
    ASoC: hdac_hdmi: Rate limit logging on connection and disconnection

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/bugs: Avoid warning when overriding return thunk

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Disable jack polling at shutdown

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Handle the jack polling always via a work

Gwendal Grignou <gwendal@chromium.org>
    platform/chrome: cros_ec_sensorhub: Retries when a sensor is not ready

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: rtsx_usb_sdmmc: Fix error-path in sd_set_power_mode()

Hans de Goede <hansg@kernel.org>
    mei: bus: Check for still connected devices in mei_cl_bus_dev_release()

Zijun Hu <zijun.hu@oss.qualcomm.com>
    char: misc: Fix improper and inaccurate error code returned by misc_init()

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: SDCA: Add flag for unused IRQs

Peter Robinson <pbrobinson@gmail.com>
    reset: brcmstb: Enable reset drivers for ARCH_BCM2835

Eliav Farber <farbere@amazon.com>
    pps: clients: gpio: fix interrupt handling order in remove path

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    selftests: vDSO: vdso_test_getrandom: Always print TAP header

Biju Das <biju.das.jz@bp.renesas.com>
    irqchip/renesas-rzv2h: Enable SKIP_SET_WAKE and MASK_ON_SUSPEND

Breno Leitao <leitao@debian.org>
    ACPI: APEI: GHES: add TAINT_MACHINE_CHECK on GHES panic path

Sarthak Garg <quic_sartgarg@quicinc.com>
    mmc: sdhci-msm: Ensure SD card power isn't ON when card removed

Sebastian Ott <sebott@redhat.com>
    ACPI: processor: fix acpi_object initialization

tuhaowen <tuhaowen@uniontech.com>
    PM: sleep: console: Fix the black screen issue

Hsin-Te Yuan <yuanhsinte@chromium.org>
    thermal: sysfs: Return ENODATA instead of EAGAIN for reads

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: runtime: Clear power.needs_force_resume in pm_runtime_reinit()

GalaxySnail <me@glxys.nl>
    ALSA: hda: add MODULE_FIRMWARE for cs35l41/cs35l56

Thierry Reding <treding@nvidia.com>
    firmware: tegra: Fix IVC dependency problems

Peng Fan <peng.fan@nxp.com>
    firmware: arm_scmi: power_control: Ensure SCMI_SYSPOWER_IDLE is set early during resume

Zhu Qiyu <qiyuzhu2@amd.com>
    ACPI: PRM: Reduce unnecessary printing to avoid user confusion

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    selftests: tracing: Use mutex_unlock for testing glob filter

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    tools/build: Fix s390(x) cross-compilation with clang

Aaron Kling <webgeek1234@gmail.com>
    ARM: tegra: Use I/O memcpy to write to IRAM

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    gpio: tps65912: check the return value of regmap_update_bits()

David Lechner <dlechner@baylibre.com>
    iio: adc: ad_sigma_delta: don't overallocate scan buffer

Thomas Weißschuh <linux@weissschuh.net>
    tools/nolibc: define time_t in terms of __kernel_old_time_t

David Collins <david.collins@oss.qualcomm.com>
    thermal/drivers/qcom-spmi-temp-alarm: Enable stage 2 shutdown when required

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: soc-dapm: set bias_level if snd_soc_dapm_set_bias_level() was successed

Shubhrajyoti Datta <shubhrajyoti.datta@amd.com>
    EDAC/synopsys: Clear the ECC counters on init

Lifeng Zheng <zhenglifeng1@huawei.com>
    PM / devfreq: governor: Replace sscanf() with kstrtoul() in set_freq_store()

Alexander Kochetkov <al.kochet@gmail.com>
    ARM: rockchip: fix kernel hang during smp initialization

Li RongQing <lirongqing@baidu.com>
    cpufreq: intel_pstate: Add Granite Rapids support in no-HWP mode

Lifeng Zheng <zhenglifeng1@huawei.com>
    cpufreq: Exit governor when failed to start old governor

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    gpio: wcd934x: check the return value of regmap_update_bits()

Guillaume La Roque <glaroque@baylibre.com>
    pmdomain: ti: Select PM_GENERIC_DOMAINS

André Draszik <andre.draszik@linaro.org>
    usb: typec: tcpm/tcpci_maxim: fix irq wake usage

Jameson Thies <jthies@google.com>
    usb: typec: ucsi: Add poll_cci operation to cros_ec_ucsi

Binbin Zhou <zhoubinbin@loongson.cn>
    gpio: loongson-64bit: Extend GPIO irq support

Tiffany Yang <ynaffit@google.com>
    binder: Fix selftest page indexing

Hiago De Franco <hiago.franco@toradex.com>
    remoteproc: imx_rproc: skip clock enable when M-core is managed by the SCU

Shuai Xue <xueshuai@linux.alibaba.com>
    ACPI: APEI: send SIGBUS to current task if synchronous memory error not recovered

Maulik Shah <maulik.shah@oss.qualcomm.com>
    soc: qcom: rpmh-rsc: Add RSC version 4 support

Mario Limonciello <mario.limonciello@amd.com>
    usb: xhci: Avoid showing errors during surprise removal

Jay Chen <shawn2000100@gmail.com>
    usb: xhci: Set avg_trb_len = 8 for EP0 during Address Device Command

Mario Limonciello <mario.limonciello@amd.com>
    usb: xhci: Avoid showing warnings for dying controller

Vivek Pernamitta <quic_vpernami@quicinc.com>
    bus: mhi: host: pci_generic: Disable runtime PM for QDU100

Daniele Palmas <dnlplm@gmail.com>
    bus: mhi: host: pci_generic: Add Telit FN990B40 modem support

Benson Leung <bleung@chromium.org>
    usb: typec: ucsi: psy: Set current max to 100mA for BC 1.2 and Default

Cynthia Huang <cynthia@andestech.com>
    selftests/futex: Define SYS_futex on 32-bit architectures with 64-bit time_t

Prashant Malani <pmalani@google.com>
    cpufreq: CPPC: Mark driver with NEED_UPDATE_LIMITS flag

Mario Limonciello <mario.limonciello@amd.com>
    platform/x86/amd: pmc: Add Lenovo Yoga 6 13ALC6 to pmc quirk list

Dave Penkler <dpenkler@gmail.com>
    staging: gpib: Add init response codes for new ni-usb-hs+

Su Hui <suhui@nfschina.com>
    usb: xhci: print xhci->xhc_state when queue_command failed

Steven Rostedt <rostedt@goodmis.org>
    tracefs: Add d_delete to remove negative dentries

Al Viro <viro@zeniv.linux.org.uk>
    securityfs: don't pin dentries twice, once is enough...

Al Viro <viro@zeniv.linux.org.uk>
    fix locking in efi_secret_unlink()

Wei Gao <wegao@suse.com>
    ext2: Handle fiemap on empty files to prevent EINVAL

Al Viro <viro@zeniv.linux.org.uk>
    landlock: opened file never has a negative dentry

Christian Brauner <brauner@kernel.org>
    pidfs: raise SB_I_NODEV and SB_I_NOEXEC

Rong Zhang <ulin0208@gmail.com>
    fs/ntfs3: correctly create symlink for relative path

Lizhi Xu <lizhi.xu@windriver.com>
    fs/ntfs3: Add sanity check for file name

Damien Le Moal <dlemoal@kernel.org>
    ata: libata-sata: Disallow changing LPM state if not supported

Damien Le Moal <dlemoal@kernel.org>
    ata: ahci: Disable DIPM if host lacks support

Damien Le Moal <dlemoal@kernel.org>
    ata: ahci: Disallow LPM policy control if not supported

Al Viro <viro@zeniv.linux.org.uk>
    better lockdep annotations for simple_recursive_removal()

Viacheslav Dubeyko <slava@dubeyko.com>
    hfs: fix not erasing deleted b-tree node issue

Sarah Newman <srn@prgmr.com>
    drbd: add missing kref_get in handle_write_conflicts

Jan Kara <jack@suse.cz>
    udf: Verify partition map count

Jan Kara <jack@suse.cz>
    loop: Avoid updating block size under exclusive owner

Andrew Price <anprice@redhat.com>
    gfs2: Set .migrate_folio in gfs2_{rgrp,meta}_aops

Andrew Price <anprice@redhat.com>
    gfs2: Validate i_depth for exhash directories

Maurizio Lombardi <mlombard@redhat.com>
    nvme-tcp: log TLS handshake failures at error level

John Garry <john.g.garry@oracle.com>
    md/raid10: set chunk_sectors limit

John Garry <john.g.garry@oracle.com>
    dm-stripe: limit chunk_sectors to the stripe size

Keith Busch <kbusch@kernel.org>
    nvme-pci: try function level reset on init failure

NeilBrown <neil@brown.name>
    smb/server: avoid deadlock when linking with ReplaceIfExists

Yeoreum Yun <yeoreum.yun@arm.com>
    firmware: arm_ffa: Change initcall level of ffa_init() to rootfs_initcall

Yeoreum Yun <yeoreum.yun@arm.com>
    tpm: tpm_crb_ffa: try to probe tpm_crb_ffa when it's built-in

Jarkko Sakkinen <jarkko@kernel.org>
    tpm: Check for completion after timeout

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

Viacheslav Dubeyko <slava@dubeyko.com>
    hfs: fix general protection fault in hfs_find_init()

Sven Stegemann <sven@stegemann.de>
    net: kcm: Fix race condition in kcm_unattach()

Frederic Weisbecker <frederic@kernel.org>
    ipvs: Fix estimator kthreads preferred affinity

Jakub Kicinski <kuba@kernel.org>
    tls: handle data disappearing from under the TLS ULP

Jeongjun Park <aha310510@gmail.com>
    ptp: prevent possible ABBA deadlock in ptp_clock_freerun()

Yao Zi <ziyao@disroot.org>
    riscv: dts: thead: Add APB clocks for TH1520 GMACs

Yao Zi <ziyao@disroot.org>
    net: stmmac: thead: Get and enable APB clock on initialization

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpuidle: governors: menu: Avoid using invalid recent intervals data

Len Brown <len.brown@intel.com>
    intel_idle: Allow loading ACPI tables for any family

Gao Xiang <xiang@kernel.org>
    erofs: fix block count report when 48-bit layout is on

Stanislav Fomichev <sdf@fomichev.me>
    hamradio: ignore ops-locked netdevs

Stanislav Fomichev <sdf@fomichev.me>
    net: lapbether: ignore ops-locked netdevs

Xin Long <lucien.xin@gmail.com>
    sctp: linearize cloned gso packets in sctp_rcv

Alok Tiwari <alok.a.tiwari@oracle.com>
    net: ti: icss-iep: Fix incorrect type for return value in extts_enable()

Jakub Kicinski <kuba@kernel.org>
    net: page_pool: allow enabling recycling late, fix false positive warning

MD Danish Anwar <danishanwar@ti.com>
    net: ti: icssg-prueth: Fix emac link speed handling

Jijie Shao <shaojijie@huawei.com>
    net: hibmcge: fix the np_link_fail error reporting issue

Jijie Shao <shaojijie@huawei.com>
    net: hibmcge: fix the division by zero issue

Jijie Shao <shaojijie@huawei.com>
    net: hibmcge: fix rtnl deadlock issue

Florian Westphal <fw@strlen.de>
    netfilter: ctnetlink: fix refcount leak on table dump

Sabrina Dubroca <sd@queasysnail.net>
    udp: also consider secpath when evaluating ipsec use for checksumming

Sabrina Dubroca <sd@queasysnail.net>
    xfrm: restore GSO for SW crypto

Jinjiang Tu <tujinjiang@huawei.com>
    mm/smaps: fix race between smaps_hugetlb_range and migration

Al Viro <viro@zeniv.linux.org.uk>
    habanalabs: fix UAF in export_dmabuf()

Stefan Metzmacher <metze@samba.org>
    smb: client: don't wait for info->send_pending == 0 on error

Stefan Metzmacher <metze@samba.org>
    smb: client: let send_done() cleanup before calling smbd_disconnect_rdma_connection()

Thomas Weißschuh <linux@weissschuh.net>
    mfd: cros_ec: Separate charge-control probing from USB-PD

Li Zhijian <lizhijian@fujitsu.com>
    mm/memory-tier: fix abstract distance calculation overflow

Damien Le Moal <dlemoal@kernel.org>
    block: Make REQ_OP_ZONE_FINISH a write operation

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: processor: perflib: Move problematic pr->performance check

Lukas Wunner <lukas@wunner.de>
    PCI/ACPI: Fix runtime PM ref imbalance on Hot-Plug Capable ports

Jiayi Li <lijiayi@kylinos.cn>
    ACPI: processor: perflib: Fix initial _PPC limit application

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    Documentation: ACPI: Fix parent device references

Jann Horn <jannh@google.com>
    eventpoll: Fix semi-unbounded recursion

Sasha Levin <sashal@kernel.org>
    fs: Prevent file descriptor table allocations exceeding INT_MAX

Eric Biggers <ebiggers@kernel.org>
    fscrypt: Don't use problematic non-inline crypto engines

André Draszik <andre.draszik@linaro.org>
    clk: samsung: gs101: fix alternate mout_hsi0_usb20_ref parent clock

André Draszik <andre.draszik@linaro.org>
    clk: samsung: gs101: fix CLK_DOUT_CMU_G3D_BUSD

André Draszik <andre.draszik@linaro.org>
    clk: samsung: exynos850: fix a comment

Ma Ke <make24@iscas.ac.cn>
    sunvdc: Balance device refcount in vdc_port_mpgroup_check

Wentao Guan <guanwentao@uniontech.com>
    LoongArch: vDSO: Remove -nostdlib complier flag

Yao Zi <ziyao@disroot.org>
    LoongArch: Avoid in-place string operation on FDT content

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Make relocate_new_kernel_size be a .quad value

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    LoongArch: Don't use %pK through printk() in unwinder

Haoran Jiang <jianghaoran@kylinos.cn>
    LoongArch: BPF: Fix jump offset calculation in tailcall

Huacai Chen <chenhuacai@kernel.org>
    PCI: Extend isolated function probing to LoongArch

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix the setting of capabilities when automounting a new filesystem

Dai Ngo <dai.ngo@oracle.com>
    NFSD: detect mismatch of file handle and delegation stateid in OPEN op

Jeff Layton <jlayton@kernel.org>
    nfsd: handle get_client_locked() failure in nfsd4_setclientid_confirm()

Christian Brauner <brauner@kernel.org>
    fhandle: raise FILEID_IS_DIR in handle_type

Fabio Porcedda <fabio.porcedda@gmail.com>
    net: usb: qmi_wwan: add Telit Cinterion FN990A w/audio composition

Xu Yang <xu.yang_2@nxp.com>
    net: usb: asix_devices: add phy_mask for ax88772 mdio bus

Johan Hovold <johan@kernel.org>
    net: dpaa: fix device leak when querying time stamp info

Johan Hovold <johan@kernel.org>
    net: ti: icss-iep: fix device and OF node leaks at probe

Johan Hovold <johan@kernel.org>
    net: mtk_eth_soc: fix device leak at probe

Johan Hovold <johan@kernel.org>
    net: enetc: fix device and OF node leak at probe

Johan Hovold <johan@kernel.org>
    net: gianfar: fix device leak when querying time stamp info

Heiner Kallweit <hkallweit1@gmail.com>
    net: ftgmac100: fix potential NULL pointer access in ftgmac100_phy_disconnect

Florian Larysch <fl@n621.de>
    net: phy: micrel: fix KSZ8081/KSZ8091 cable test

Fedor Pchelkin <pchelkin@ispras.ru>
    netlink: avoid infinite retry looping in netlink_unicast()

Daniel Golle <daniel@makrotopia.org>
    Revert "leds: trigger: netdev: Configure LED blink interval for HW offload"

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    leds: flash: leds-qcom-flash: Fix registry access after re-bind

David Thompson <davthompson@nvidia.com>
    gpio: mlxbf3: use platform_get_irq_optional()

David Thompson <davthompson@nvidia.com>
    Revert "gpio: mlxbf3: only get IRQ for device instance 0"

David Thompson <davthompson@nvidia.com>
    gpio: mlxbf2: use platform_get_irq_optional()

Dongcheng Yan <dongcheng.yan@intel.com>
    media: i2c: set lt6911uxe's reset_gpio to GPIOD_OUT_LOW

Siddharth Vadapalli <s-vadapalli@ti.com>
    arm64: dts: ti: k3-j722s-evm: Fix USB gpio-hog level for Type-C

Harald Mommer <harald.mommer@oss.qualcomm.com>
    gpio: virtio: Fix config space reading.

Wang Zhaolong <wangzhaolong@huaweicloud.com>
    smb: client: remove redundant lstrp update in negotiate protocol

Steve French <stfrench@microsoft.com>
    smb3: fix for slab out of bounds on mount to ksmbd

Christopher Eby <kreed@kreed.org>
    ALSA: hda/realtek: Add Framework Laptop 13 (AMD Ryzen AI 300) to quirks

Vasiliy Kovalev <kovalev@altlinux.org>
    ALSA: hda/realtek: Fix headset mic on HONOR BRB-X

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Validate UAC3 cluster segment descriptors

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Validate UAC3 power domain descriptors, too

Jens Axboe <axboe@kernel.dk>
    io_uring/net: commit partial buffers on retry

Jens Axboe <axboe@kernel.dk>
    io_uring/memmap: cast nr_pages to size_t before shifting

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: export io_[un]account_mem

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: don't use int for ABI


-------------

Diffstat:

 Documentation/filesystems/fscrypt.rst              |   37 +-
 Documentation/firmware-guide/acpi/i2c-muxes.rst    |    8 +-
 Documentation/sphinx/kernel_abi.py                 |    6 +-
 Makefile                                           |    4 +-
 arch/arm/mach-rockchip/platsmp.c                   |   15 +-
 arch/arm/mach-tegra/reset.c                        |    2 +-
 arch/arm64/boot/dts/ti/k3-j722s-evm.dts            |    2 +-
 arch/arm64/include/asm/acpi.h                      |    2 +-
 arch/arm64/kernel/acpi.c                           |   10 +-
 arch/arm64/kernel/stacktrace.c                     |    2 +
 arch/arm64/kernel/traps.c                          |    1 +
 arch/arm64/mm/fault.c                              |    1 +
 arch/arm64/mm/ptdump_debugfs.c                     |    3 -
 arch/loongarch/kernel/env.c                        |   13 +-
 arch/loongarch/kernel/relocate_kernel.S            |    2 +-
 arch/loongarch/kernel/unwind_orc.c                 |    2 +-
 arch/loongarch/net/bpf_jit.c                       |   21 +-
 arch/loongarch/vdso/Makefile                       |    2 +-
 arch/mips/include/asm/vpe.h                        |    8 +
 arch/mips/kernel/process.c                         |   16 +-
 arch/mips/lantiq/falcon/sysctrl.c                  |   23 +-
 arch/parisc/Makefile                               |    2 +-
 arch/powerpc/include/asm/floppy.h                  |    5 +-
 arch/powerpc/platforms/512x/mpc512x_lpbfifo.c      |    6 +-
 arch/riscv/boot/dts/thead/th1520.dtsi              |   10 +-
 arch/riscv/mm/ptdump.c                             |    3 -
 arch/s390/include/asm/timex.h                      |   13 +-
 arch/s390/kernel/early.c                           |    1 +
 arch/s390/kernel/time.c                            |    2 +-
 arch/s390/mm/dump_pagetables.c                     |    2 -
 arch/um/include/asm/thread_info.h                  |    4 +
 arch/um/kernel/process.c                           |   18 +-
 arch/x86/include/asm/kvm_host.h                    |    6 +-
 arch/x86/kernel/cpu/bugs.c                         |    5 +-
 arch/x86/kvm/svm/svm.c                             |    4 +-
 arch/x86/kvm/vmx/nested.c                          |   18 +-
 arch/x86/kvm/vmx/pmu_intel.c                       |    8 +-
 arch/x86/kvm/vmx/vmx.c                             |   41 +-
 arch/x86/kvm/vmx/vmx.h                             |   13 +
 arch/x86/kvm/vmx/x86_ops.h                         |    2 +-
 arch/x86/kvm/x86.c                                 |   11 +-
 block/bfq-iosched.c                                |   35 +-
 block/bfq-iosched.h                                |    3 +-
 block/blk-mq.c                                     |    6 +-
 block/blk-settings.c                               |    2 +-
 block/blk-zoned.c                                  |   20 +-
 block/kyber-iosched.c                              |    9 +-
 block/mq-deadline.c                                |   16 +-
 crypto/jitterentropy-kcapi.c                       |    9 +-
 drivers/accel/habanalabs/common/memory.c           |   23 +-
 drivers/acpi/acpi_processor.c                      |    2 +-
 drivers/acpi/apei/ghes.c                           |   13 +
 drivers/acpi/prmt.c                                |   26 +-
 drivers/acpi/processor_perflib.c                   |   11 +
 drivers/android/binder_alloc_selftest.c            |    2 +-
 drivers/ata/ahci.c                                 |   12 +-
 drivers/ata/ata_piix.c                             |    1 +
 drivers/ata/libahci.c                              |    1 +
 drivers/ata/libata-sata.c                          |   52 +-
 drivers/base/power/runtime.c                       |    5 +
 drivers/block/drbd/drbd_receiver.c                 |    6 +-
 drivers/block/loop.c                               |   38 +-
 drivers/block/sunvdc.c                             |    4 +-
 drivers/bluetooth/btusb.c                          |    3 +
 drivers/bus/mhi/host/pci_generic.c                 |   20 +-
 drivers/char/ipmi/ipmi_msghandler.c                |    8 +-
 drivers/char/ipmi/ipmi_watchdog.c                  |   59 +-
 drivers/char/misc.c                                |    4 +-
 drivers/char/tpm/tpm-interface.c                   |   17 +-
 drivers/char/tpm/tpm_crb_ffa.c                     |   19 +-
 drivers/clk/qcom/dispcc-sm8750.c                   |   10 +-
 drivers/clk/qcom/gcc-ipq5018.c                     |    2 +-
 drivers/clk/qcom/gcc-ipq8074.c                     |    6 +-
 drivers/clk/renesas/rzg2l-cpg.c                    |    8 +-
 drivers/clk/samsung/clk-exynos850.c                |    2 +-
 drivers/clk/samsung/clk-gs101.c                    |    4 +-
 drivers/clk/tegra/clk-periph.c                     |    4 +-
 drivers/clk/thead/clk-th1520-ap.c                  |    5 +-
 drivers/comedi/comedi_fops.c                       |   33 +-
 drivers/comedi/comedi_internal.h                   |    1 +
 drivers/comedi/drivers.c                           |   13 +-
 drivers/cpufreq/cppc_cpufreq.c                     |    2 +-
 drivers/cpufreq/cpufreq.c                          |    8 +-
 drivers/cpufreq/intel_pstate.c                     |    2 +
 drivers/cpuidle/governors/menu.c                   |   21 +-
 drivers/crypto/ccp/sp-pci.c                        |    1 +
 drivers/crypto/hisilicon/hpre/hpre_crypto.c        |    8 +-
 .../crypto/marvell/octeontx2/otx2_cptpf_ucode.c    |   16 +-
 drivers/devfreq/governor_userspace.c               |    6 +-
 drivers/dma/stm32/stm32-dma.c                      |    2 +-
 drivers/edac/synopsys_edac.c                       |   93 +-
 drivers/firmware/arm_ffa/driver.c                  |    2 +-
 drivers/firmware/arm_scmi/scmi_power_control.c     |   22 +-
 drivers/firmware/tegra/Kconfig                     |    5 +-
 drivers/gpio/gpio-loongson-64bit.c                 |    6 +
 drivers/gpio/gpio-mlxbf2.c                         |    2 +-
 drivers/gpio/gpio-mlxbf3.c                         |   52 +-
 drivers/gpio/gpio-tps65912.c                       |    7 +-
 drivers/gpio/gpio-virtio.c                         |    9 +-
 drivers/gpio/gpio-wcd934x.c                        |    7 +-
 drivers/gpu/drm/amd/amdgpu/aldebaran.c             |   33 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_cper.c           |    6 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_csa.c            |    4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c     |    2 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c       |    3 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   28 +-
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c  |    6 +-
 drivers/gpu/drm/amd/display/dc/core/dc.c           |   12 +-
 .../drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c    |   11 +-
 drivers/gpu/drm/amd/display/dc/link/link_dpms.c    |    3 +-
 .../gpu/drm/amd/display/dc/mpc/dcn401/dcn401_mpc.c |    2 +-
 .../display/dc/resource/dcn314/dcn314_resource.c   |    1 +
 drivers/gpu/drm/amd/display/dmub/src/dmub_dcn35.c  |   16 +-
 drivers/gpu/drm/amd/pm/amdgpu_pm.c                 |    5 +
 drivers/gpu/drm/amd/pm/swsmu/smu11/vangogh_ppt.c   |   37 +-
 drivers/gpu/drm/clients/drm_client_setup.c         |    5 +
 drivers/gpu/drm/i915/display/intel_psr.c           |   14 +-
 drivers/gpu/drm/imagination/pvr_power.c            |   59 +-
 drivers/gpu/drm/msm/Makefile                       |    5 +
 drivers/gpu/drm/msm/adreno/a6xx_catalog.c          |    2 +-
 drivers/gpu/drm/msm/adreno/a6xx_gpu.h              |    4 +
 drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c        |    2 +-
 drivers/gpu/drm/msm/adreno/a6xx_gpu_state.h        |    2 +-
 drivers/gpu/drm/msm/adreno/a6xx_preempt.c          |    2 +-
 .../gpu/drm/msm/adreno/adreno_gen7_9_0_snapshot.h  |    4 +-
 drivers/gpu/drm/msm/msm_drv.c                      |    9 +-
 drivers/gpu/drm/msm/msm_gem.c                      |    3 +-
 drivers/gpu/drm/msm/msm_gem.h                      |    6 +
 drivers/gpu/drm/msm/registers/adreno/a6xx.xml      | 3576 ++++----------------
 .../drm/msm/registers/adreno/a6xx_descriptors.xml  |  198 ++
 .../gpu/drm/msm/registers/adreno/a6xx_enums.xml    |  383 +++
 .../drm/msm/registers/adreno/a6xx_perfcntrs.xml    |  600 ++++
 .../gpu/drm/msm/registers/adreno/a7xx_enums.xml    |  223 ++
 .../drm/msm/registers/adreno/a7xx_perfcntrs.xml    | 1030 ++++++
 .../gpu/drm/msm/registers/adreno/adreno_pm4.xml    |  302 +-
 drivers/gpu/drm/panel/panel-raydium-rm67200.c      |   22 +-
 drivers/gpu/drm/renesas/rz-du/rzg2l_mipi_dsi.c     |    3 +
 drivers/gpu/drm/scheduler/sched_main.c             |   34 +-
 drivers/gpu/drm/ttm/ttm_pool.c                     |    8 +-
 drivers/gpu/drm/ttm/ttm_resource.c                 |    3 +
 drivers/gpu/drm/xe/xe_guc_exec_queue_types.h       |    2 +
 drivers/gpu/drm/xe/xe_guc_submit.c                 |    7 +-
 drivers/gpu/drm/xe/xe_hw_fence.c                   |    3 +
 drivers/gpu/drm/xe/xe_query.c                      |   27 +-
 drivers/hid/hid-core.c                             |    4 +-
 drivers/hid/hid-magicmouse.c                       |   56 +-
 drivers/hwmon/emc2305.c                            |   10 +-
 drivers/i2c/i2c-core-acpi.c                        |    1 +
 drivers/i3c/internals.h                            |    1 +
 drivers/i3c/master.c                               |    4 +-
 drivers/idle/intel_idle.c                          |    2 +-
 drivers/iio/adc/ad7768-1.c                         |   23 +-
 drivers/iio/adc/ad_sigma_delta.c                   |    2 +-
 drivers/infiniband/core/nldev.c                    |   22 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c           |    2 +-
 drivers/infiniband/hw/hfi1/affinity.c              |   44 +-
 drivers/infiniband/sw/siw/siw_qp_tx.c              |    5 +-
 drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c         |    1 +
 drivers/iommu/intel/iommu.c                        |   19 +-
 drivers/iommu/intel/iommu.h                        |    3 +
 drivers/iommu/iommufd/io_pagetable.c               |   48 +-
 drivers/irqchip/irq-mips-gic.c                     |    8 +-
 drivers/irqchip/irq-renesas-rzv2h.c                |    4 +-
 drivers/leds/flash/leds-qcom-flash.c               |   15 +-
 drivers/leds/leds-lp50xx.c                         |   11 +-
 drivers/leds/trigger/ledtrig-netdev.c              |   16 +-
 drivers/md/dm-ps-historical-service-time.c         |    4 +-
 drivers/md/dm-ps-queue-length.c                    |    4 +-
 drivers/md/dm-ps-round-robin.c                     |    4 +-
 drivers/md/dm-ps-service-time.c                    |    4 +-
 drivers/md/dm-stripe.c                             |    1 +
 drivers/md/dm-table.c                              |   10 +-
 drivers/md/dm-zoned-target.c                       |    2 +-
 drivers/md/dm.c                                    |   37 +-
 drivers/md/raid10.c                                |    1 +
 drivers/media/dvb-frontends/dib7000p.c             |    8 +
 drivers/media/i2c/hi556.c                          |    7 +-
 drivers/media/i2c/lt6911uxe.c                      |    2 +-
 drivers/media/i2c/tc358743.c                       |   86 +-
 drivers/media/pci/intel/ipu-bridge.c               |    2 +
 drivers/media/platform/qcom/iris/iris_buffer.c     |   11 +-
 .../platform/qcom/iris/iris_hfi_gen1_defines.h     |    2 +
 .../platform/qcom/iris/iris_hfi_gen1_response.c    |    6 +
 drivers/media/platform/qcom/venus/hfi_msgs.c       |   83 +-
 drivers/media/platform/raspberrypi/rp1-cfe/cfe.c   |    4 +-
 drivers/media/usb/hdpvr/hdpvr-i2c.c                |    6 +
 drivers/media/usb/uvc/uvc_ctrl.c                   |   55 +-
 drivers/media/usb/uvc/uvc_driver.c                 |   12 +
 drivers/media/usb/uvc/uvc_video.c                  |   21 +-
 drivers/media/usb/uvc/uvcvideo.h                   |    2 +
 drivers/media/v4l2-core/v4l2-common.c              |   14 +-
 drivers/mfd/axp20x.c                               |    3 +-
 drivers/mfd/cros_ec_dev.c                          |   10 +-
 drivers/misc/cardreader/rtsx_usb.c                 |   16 +-
 drivers/misc/mei/bus.c                             |    6 +
 drivers/mmc/host/rtsx_usb_sdmmc.c                  |    4 +-
 drivers/mmc/host/sdhci-msm.c                       |   14 +
 drivers/net/can/ti_hecc.c                          |    2 +-
 drivers/net/dsa/b53/b53_common.c                   |   76 +-
 drivers/net/dsa/b53/b53_regs.h                     |    7 +-
 drivers/net/ethernet/agere/et131x.c                |   36 +
 drivers/net/ethernet/aquantia/atlantic/aq_hw.h     |    2 +
 .../aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c   |   39 +
 drivers/net/ethernet/atheros/ag71xx.c              |    9 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |    9 +-
 drivers/net/ethernet/cavium/thunder/thunder_bgx.c  |    4 +-
 drivers/net/ethernet/emulex/benet/be_main.c        |    8 +-
 drivers/net/ethernet/faraday/ftgmac100.c           |    7 +-
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c     |    2 -
 drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c |    4 +-
 drivers/net/ethernet/freescale/enetc/enetc_pf.c    |   14 +-
 drivers/net/ethernet/freescale/fec_main.c          |   34 +-
 drivers/net/ethernet/freescale/gianfar_ethtool.c   |    4 +-
 drivers/net/ethernet/google/gve/gve_adminq.c       |    1 +
 drivers/net/ethernet/hisilicon/hibmcge/hbg_err.c   |   14 +-
 drivers/net/ethernet/hisilicon/hibmcge/hbg_hw.c    |   15 +-
 drivers/net/ethernet/hisilicon/hibmcge/hbg_txrx.h  |    7 +-
 drivers/net/ethernet/intel/idpf/idpf.h             |   19 +
 drivers/net/ethernet/intel/idpf/idpf_ethtool.c     |   36 +-
 drivers/net/ethernet/intel/idpf/idpf_lib.c         |   18 +-
 drivers/net/ethernet/intel/idpf/idpf_main.c        |    1 +
 drivers/net/ethernet/intel/idpf/idpf_txrx.c        |   13 +-
 drivers/net/ethernet/mediatek/mtk_wed.c            |    1 -
 drivers/net/ethernet/mellanox/mlx5/core/en/qos.c   |    2 +-
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    |    7 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-thead.c  |   14 +
 drivers/net/ethernet/ti/icssg/icss_iep.c           |   26 +-
 drivers/net/ethernet/ti/icssg/icssg_prueth.c       |    6 +
 drivers/net/hamradio/bpqether.c                    |    2 +-
 drivers/net/hyperv/hyperv_net.h                    |    3 +
 drivers/net/hyperv/netvsc_drv.c                    |   29 +-
 drivers/net/pcs/pcs-xpcs-plat.c                    |    4 +-
 drivers/net/phy/broadcom.c                         |   25 +-
 drivers/net/phy/micrel.c                           |   12 +-
 drivers/net/phy/smsc.c                             |    1 +
 drivers/net/thunderbolt/main.c                     |   21 +-
 drivers/net/usb/asix_devices.c                     |    1 +
 drivers/net/usb/cdc_ncm.c                          |   20 +-
 drivers/net/usb/qmi_wwan.c                         |    1 +
 drivers/net/wan/lapbether.c                        |    2 +-
 drivers/net/wireless/ath/ath10k/core.c             |   48 +-
 drivers/net/wireless/ath/ath10k/core.h             |   11 +-
 drivers/net/wireless/ath/ath10k/mac.c              |    7 +-
 drivers/net/wireless/ath/ath10k/wmi.c              |    6 +
 drivers/net/wireless/ath/ath12k/core.h             |    4 +
 drivers/net/wireless/ath/ath12k/dp.c               |    3 +-
 drivers/net/wireless/ath/ath12k/hw.c               |    2 +-
 drivers/net/wireless/ath/ath12k/mac.c              |   79 +-
 drivers/net/wireless/ath/ath12k/wmi.c              |    5 +
 drivers/net/wireless/ath/ath12k/wmi.h              |    1 +
 drivers/net/wireless/intel/iwlegacy/4965-mac.c     |    5 +-
 drivers/net/wireless/intel/iwlwifi/dvm/rs.c        |    2 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        |    7 +-
 drivers/net/wireless/intel/iwlwifi/mld/agg.c       |    5 +
 drivers/net/wireless/intel/iwlwifi/mld/iface.h     |    3 +
 drivers/net/wireless/intel/iwlwifi/mld/link.c      |    8 +-
 drivers/net/wireless/intel/iwlwifi/mld/mac80211.c  |    1 +
 drivers/net/wireless/intel/iwlwifi/mld/mlo.c       |    8 +-
 drivers/net/wireless/intel/iwlwifi/mld/scan.c      |    2 +-
 drivers/net/wireless/intel/iwlwifi/mld/scan.h      |    2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |    2 +
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |    5 +
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |    2 +-
 drivers/net/wireless/mediatek/mt76/channel.c       |    4 +-
 drivers/net/wireless/mediatek/mt76/mt76.h          |    5 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |   28 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c    |    4 +-
 drivers/net/wireless/realtek/rtlwifi/pci.c         |   23 +-
 drivers/net/wireless/realtek/rtw89/chan.c          |    6 +
 drivers/net/wireless/realtek/rtw89/coex.c          |   12 +-
 drivers/net/wireless/realtek/rtw89/core.c          |    3 +
 drivers/net/wireless/realtek/rtw89/fw.c            |    9 +-
 drivers/net/wireless/realtek/rtw89/fw.h            |    2 +
 drivers/net/wireless/realtek/rtw89/mac.c           |   19 +
 drivers/net/wireless/realtek/rtw89/reg.h           |    1 +
 drivers/net/wireless/realtek/rtw89/wow.c           |    5 +-
 drivers/net/xen-netfront.c                         |    5 -
 drivers/nvme/host/pci.c                            |   24 +-
 drivers/nvme/host/tcp.c                            |   11 +-
 drivers/pci/pci-acpi.c                             |    4 +-
 drivers/pci/pci.c                                  |    6 +-
 drivers/pci/probe.c                                |    2 +-
 drivers/perf/arm-cmn.c                             |    1 +
 drivers/perf/arm-ni.c                              |    1 +
 drivers/perf/cxl_pmu.c                             |    2 +-
 drivers/phy/rockchip/phy-rockchip-pcie.c           |   15 +-
 drivers/pinctrl/stm32/pinctrl-stm32.c              |    1 +
 drivers/platform/chrome/cros_ec_sensorhub.c        |   23 +-
 drivers/platform/chrome/cros_ec_typec.c            |    4 +-
 drivers/platform/x86/amd/pmc/pmc-quirks.c          |    9 +
 drivers/platform/x86/thinkpad_acpi.c               |    4 +-
 drivers/pmdomain/imx/imx8m-blk-ctrl.c              |   10 +
 drivers/pmdomain/ti/Kconfig                        |    2 +-
 drivers/power/supply/qcom_battmgr.c                |    2 +
 drivers/pps/clients/pps-gpio.c                     |    5 +-
 drivers/ptp/ptp_clock.c                            |    2 +-
 drivers/ptp/ptp_private.h                          |    5 +
 drivers/ptp/ptp_vclock.c                           |    7 +
 drivers/remoteproc/imx_rproc.c                     |    4 +-
 drivers/reset/Kconfig                              |   10 +-
 drivers/rtc/rtc-ds1307.c                           |   15 +-
 drivers/s390/char/sclp.c                           |    4 +-
 drivers/scsi/aacraid/comminit.c                    |    3 +-
 drivers/scsi/bfa/bfad_im.c                         |    1 +
 drivers/scsi/libiscsi.c                            |    3 +-
 drivers/scsi/lpfc/lpfc_debugfs.c                   |    1 -
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |    3 +-
 drivers/scsi/lpfc/lpfc_scsi.c                      |    4 +
 drivers/scsi/mpi3mr/mpi3mr_os.c                    |   20 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c               |   19 +
 drivers/scsi/pm8001/pm80xx_hwi.c                   |   12 +-
 drivers/scsi/scsi_scan.c                           |    2 +-
 drivers/scsi/scsi_transport_sas.c                  |   62 +-
 drivers/soc/qcom/mdt_loader.c                      |   10 +-
 drivers/soc/qcom/rpmh-rsc.c                        |    2 +-
 drivers/soundwire/amd_manager.c                    |    7 +-
 drivers/soundwire/bus.c                            |    6 +-
 drivers/staging/gpib/ni_usb/ni_usb_gpib.c          |   14 +-
 drivers/target/target_core_fabric_lib.c            |   65 +-
 drivers/target/target_core_internal.h              |    4 +-
 drivers/target/target_core_pr.c                    |   18 +-
 drivers/thermal/qcom/qcom-spmi-temp-alarm.c        |   43 +-
 drivers/thermal/thermal_sysfs.c                    |    9 +-
 drivers/thunderbolt/domain.c                       |    2 +-
 drivers/tty/serial/serial_core.c                   |   44 +-
 drivers/usb/class/cdc-acm.c                        |   11 +-
 drivers/usb/core/config.c                          |   10 +-
 drivers/usb/core/urb.c                             |    2 +-
 drivers/usb/dwc3/dwc3-xilinx.c                     |    1 +
 drivers/usb/host/xhci-mem.c                        |    2 +
 drivers/usb/host/xhci-ring.c                       |   10 +-
 drivers/usb/host/xhci.c                            |    6 +-
 drivers/usb/typec/mux/intel_pmc_mux.c              |    2 +-
 drivers/usb/typec/tcpm/fusb302.c                   |    8 +
 drivers/usb/typec/tcpm/tcpci_maxim_core.c          |   46 +-
 drivers/usb/typec/ucsi/cros_ec_ucsi.c              |    1 +
 drivers/usb/typec/ucsi/psy.c                       |    2 +-
 drivers/usb/typec/ucsi/ucsi.c                      |    1 +
 drivers/usb/typec/ucsi/ucsi.h                      |    7 +-
 drivers/vfio/pci/mlx5/cmd.c                        |    4 +-
 drivers/vfio/vfio_iommu_type1.c                    |    7 +
 drivers/vhost/vhost.c                              |    3 +
 drivers/video/fbdev/Kconfig                        |    2 +-
 drivers/video/fbdev/core/fbcon.c                   |    9 +-
 drivers/video/fbdev/core/fbmem.c                   |    3 +
 drivers/virt/coco/efi_secret/efi_secret.c          |   10 +-
 drivers/watchdog/dw_wdt.c                          |    2 +
 drivers/watchdog/iTCO_wdt.c                        |    6 +-
 drivers/watchdog/sbsa_gwdt.c                       |   50 +-
 fs/btrfs/block-group.c                             |   31 +-
 fs/btrfs/ctree.c                                   |    1 +
 fs/btrfs/extent-tree.c                             |   33 +-
 fs/btrfs/inode.c                                   |    2 +-
 fs/btrfs/ioctl.c                                   |    3 +-
 fs/btrfs/qgroup.c                                  |   44 +-
 fs/btrfs/relocation.c                              |   19 +
 fs/btrfs/send.c                                    |   33 +
 fs/btrfs/transaction.c                             |    6 +-
 fs/btrfs/tree-log.c                                |  107 +-
 fs/btrfs/zoned.c                                   |    5 +-
 fs/crypto/fscrypt_private.h                        |   17 +
 fs/crypto/hkdf.c                                   |    2 +-
 fs/crypto/keysetup.c                               |    3 +-
 fs/crypto/keysetup_v1.c                            |    3 +-
 fs/erofs/super.c                                   |    4 +-
 fs/eventpoll.c                                     |   60 +-
 fs/exfat/dir.c                                     |   12 +
 fs/exfat/fatent.c                                  |   10 +
 fs/exfat/namei.c                                   |    5 +
 fs/exfat/super.c                                   |   32 +-
 fs/ext2/inode.c                                    |   12 +-
 fs/ext4/inline.c                                   |   19 +-
 fs/ext4/mballoc-test.c                             |    9 +
 fs/ext4/mballoc.c                                  |   69 +-
 fs/f2fs/file.c                                     |   24 +-
 fs/fhandle.c                                       |    2 +-
 fs/file.c                                          |   15 +
 fs/gfs2/dir.c                                      |    6 +-
 fs/gfs2/glops.c                                    |    6 +
 fs/gfs2/meta_io.c                                  |    2 +
 fs/hfs/bfind.c                                     |    3 +
 fs/hfs/bnode.c                                     |   93 +
 fs/hfs/btree.c                                     |   57 +-
 fs/hfs/extent.c                                    |    2 +-
 fs/hfs/hfs_fs.h                                    |    1 +
 fs/hfsplus/bnode.c                                 |   92 +
 fs/hfsplus/unicode.c                               |    7 +
 fs/hfsplus/xattr.c                                 |    6 +-
 fs/jfs/file.c                                      |    3 +
 fs/jfs/inode.c                                     |    2 +-
 fs/jfs/jfs_dmap.c                                  |    6 +
 fs/libfs.c                                         |    4 +-
 fs/nfs/blocklayout/blocklayout.c                   |    4 +-
 fs/nfs/blocklayout/dev.c                           |    5 +-
 fs/nfs/blocklayout/extent_tree.c                   |   20 +-
 fs/nfs/client.c                                    |   44 +-
 fs/nfs/internal.h                                  |    2 +-
 fs/nfs/nfs4client.c                                |   20 +-
 fs/nfs/nfs4proc.c                                  |    2 +-
 fs/nfs/pnfs.c                                      |   11 +-
 fs/nfsd/nfs4state.c                                |   34 +-
 fs/ntfs3/dir.c                                     |    3 +
 fs/ntfs3/inode.c                                   |   31 +-
 fs/ocfs2/aops.c                                    |    1 +
 fs/orangefs/orangefs-debugfs.c                     |    2 +-
 fs/pidfs.c                                         |    2 +
 fs/proc/task_mmu.c                                 |    6 +-
 fs/smb/client/cifsencrypt.c                        |   79 +-
 fs/smb/client/cifssmb.c                            |   10 +
 fs/smb/client/compress.c                           |   61 +-
 fs/smb/client/connect.c                            |    1 -
 fs/smb/client/sess.c                               |    9 +
 fs/smb/client/smb2ops.c                            |   11 +-
 fs/smb/client/smbdirect.c                          |   25 +-
 fs/smb/server/smb2pdu.c                            |   16 +-
 fs/tracefs/inode.c                                 |   11 +
 fs/udf/super.c                                     |   13 +-
 fs/xfs/scrub/trace.h                               |    2 +-
 include/drm/gpu_scheduler.h                        |   18 +
 include/linux/blk_types.h                          |    6 +-
 include/linux/blkdev.h                             |   55 +
 include/linux/hid.h                                |    2 +
 include/linux/hypervisor.h                         |    3 +
 include/linux/if_vlan.h                            |   21 +-
 include/linux/libata.h                             |    1 +
 include/linux/memory-tiers.h                       |    2 +-
 include/linux/packing.h                            |    6 +-
 include/linux/pci.h                                |    6 +
 include/linux/sbitmap.h                            |    6 +-
 include/linux/skbuff.h                             |    8 +-
 include/linux/usb/cdc_ncm.h                        |    1 +
 include/linux/virtio_vsock.h                       |    7 +-
 include/net/bluetooth/hci.h                        |    6 +
 include/net/bluetooth/hci_core.h                   |    5 +-
 include/net/cfg80211.h                             |    2 +-
 include/net/ip_vs.h                                |   13 +
 include/net/kcm.h                                  |    1 -
 include/net/mac80211.h                             |    4 +
 include/net/page_pool/types.h                      |    2 +
 include/sound/sdca_function.h                      |    2 +
 include/trace/events/thp.h                         |    2 +
 include/uapi/linux/in6.h                           |    4 +-
 include/uapi/linux/io_uring.h                      |    2 +-
 io_uring/memmap.c                                  |    2 +-
 io_uring/net.c                                     |   27 +-
 io_uring/rsrc.c                                    |    4 +-
 io_uring/rsrc.h                                    |    2 +
 io_uring/rw.c                                      |    2 +-
 kernel/.gitignore                                  |    2 +
 kernel/Makefile                                    |   47 +-
 kernel/bpf/verifier.c                              |    7 +-
 kernel/gen_kheaders.sh                             |   88 +-
 kernel/kthread.c                                   |    1 +
 kernel/module/main.c                               |   10 +-
 kernel/power/console.c                             |    7 +-
 kernel/printk/nbcon.c                              |   63 +-
 kernel/rcu/rcutorture.c                            |    9 +-
 kernel/rcu/tree.c                                  |    2 +
 kernel/rcu/tree.h                                  |   14 +-
 kernel/rcu/tree_nocb.h                             |    5 +-
 kernel/rcu/tree_plugin.h                           |   44 +-
 kernel/sched/deadline.c                            |    4 +-
 kernel/sched/fair.c                                |   19 +-
 kernel/sched/rt.c                                  |    6 +
 kernel/trace/fprobe.c                              |    4 +-
 kernel/trace/rv/rv_trace.h                         |    3 +-
 lib/sbitmap.c                                      |   56 +-
 mm/damon/core.c                                    |    1 +
 mm/huge_memory.c                                   |    7 +-
 mm/kmemleak.c                                      |   10 +-
 mm/ptdump.c                                        |    2 +
 mm/shmem.c                                         |   39 +-
 mm/slub.c                                          |    7 +-
 mm/userfaultfd.c                                   |   15 +-
 net/bluetooth/hci_conn.c                           |    3 +-
 net/bluetooth/hci_event.c                          |   39 +-
 net/bluetooth/hci_sock.c                           |    2 +-
 net/core/ieee8021q_helpers.c                       |   44 +-
 net/core/page_pool.c                               |   29 +
 net/ipv4/route.c                                   |    1 -
 net/ipv4/udp_offload.c                             |    2 +-
 net/ipv6/addrconf.c                                |    7 +-
 net/ipv6/mcast.c                                   |   11 +-
 net/kcm/kcmsock.c                                  |   10 +-
 net/mac80211/chan.c                                |    1 +
 net/mac80211/ht.c                                  |   40 +-
 net/mac80211/ieee80211_i.h                         |    6 +
 net/mac80211/iface.c                               |   29 +
 net/mac80211/link.c                                |    9 +-
 net/mac80211/mlme.c                                |   45 +-
 net/mac80211/rx.c                                  |   47 +-
 net/mctp/af_mctp.c                                 |   28 +-
 net/ncsi/internal.h                                |    2 +-
 net/ncsi/ncsi-rsp.c                                |    1 +
 net/netfilter/ipvs/ip_vs_est.c                     |    3 +-
 net/netfilter/nf_conntrack_netlink.c               |   24 +-
 net/netfilter/nft_set_pipapo.c                     |    9 +-
 net/netlink/af_netlink.c                           |    2 +-
 net/sched/sch_ets.c                                |   11 +-
 net/sctp/input.c                                   |    2 +-
 net/tls/tls.h                                      |    2 +-
 net/tls/tls_strp.c                                 |   11 +-
 net/tls/tls_sw.c                                   |    3 +-
 net/vmw_vsock/virtio_transport.c                   |    2 +-
 net/wireless/mlme.c                                |    3 +-
 net/xfrm/xfrm_device.c                             |    9 +-
 net/xfrm/xfrm_state.c                              |   74 +-
 rust/Makefile                                      |   16 +-
 samples/damon/wsse.c                               |   12 +-
 scripts/kconfig/gconf.c                            |    8 +-
 scripts/kconfig/lxdialog/inputbox.c                |    6 +-
 scripts/kconfig/lxdialog/menubox.c                 |    2 +-
 scripts/kconfig/nconf.c                            |    2 +
 scripts/kconfig/nconf.gui.c                        |    1 +
 security/apparmor/domain.c                         |   52 +-
 security/apparmor/file.c                           |    6 +-
 security/apparmor/include/lib.h                    |    6 +-
 security/inode.c                                   |    2 -
 security/landlock/syscalls.c                       |    1 -
 sound/core/pcm_native.c                            |   19 +-
 sound/pci/hda/cs35l41_hda.c                        |    2 +
 sound/pci/hda/cs35l56_hda.c                        |    4 +
 sound/pci/hda/hda_codec.c                          |   44 +-
 sound/pci/hda/patch_ca0132.c                       |    2 +-
 sound/pci/hda/patch_realtek.c                      |    3 +
 sound/pci/intel8x0.c                               |    2 +-
 sound/soc/codecs/hdac_hdmi.c                       |   10 +-
 sound/soc/codecs/rt5640.c                          |    5 +
 sound/soc/fsl/fsl_sai.c                            |   20 +-
 sound/soc/intel/avs/core.c                         |    3 +-
 sound/soc/intel/boards/sof_sdw.c                   |    8 +
 sound/soc/qcom/lpass-platform.c                    |   27 +-
 sound/soc/sdca/sdca_functions.c                    |    2 +
 sound/soc/soc-core.c                               |    3 +
 sound/soc/soc-dapm.c                               |    4 +
 sound/soc/sof/topology.c                           |   15 +-
 sound/usb/mixer_quirks.c                           |   14 +-
 sound/usb/stream.c                                 |   25 +-
 sound/usb/validate.c                               |   12 +
 tools/bpf/bpftool/main.c                           |    6 +-
 tools/include/nolibc/std.h                         |    4 +-
 tools/include/nolibc/types.h                       |    4 +-
 tools/lib/bpf/libbpf.c                             |    7 +-
 .../cpupower/utils/idle_monitor/mperf_monitor.c    |    4 +-
 tools/power/x86/turbostat/turbostat.c              |   14 +-
 tools/scripts/Makefile.include                     |    4 +-
 tools/testing/ktest/ktest.pl                       |    5 +-
 tools/testing/selftests/arm64/fp/sve-ptrace.c      |    3 +-
 tools/testing/selftests/bpf/prog_tests/ringbuf.c   |    4 +-
 .../selftests/bpf/prog_tests/user_ringbuf.c        |   10 +-
 .../selftests/bpf/progs/test_ringbuf_write.c       |    4 +-
 .../testing/selftests/bpf/progs/verifier_unpriv.c  |    2 +-
 .../ftrace/test.d/ftrace/func-filter-glob.tc       |    2 +-
 tools/testing/selftests/futex/include/futextest.h  |   11 +
 tools/testing/selftests/net/netfilter/config       |    2 +-
 tools/testing/selftests/vDSO/vdso_test_getrandom.c |    6 +-
 tools/verification/dot2/dot2k.py                   |    3 +-
 .../dot2/dot2k_templates/Kconfig_container         |    5 +
 558 files changed, 8133 insertions(+), 5029 deletions(-)



Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585222;
	b=hZ7Lf1Ktij21k4LVO9q+50YQpRZmYy23HfjJk5H37MVr/G7AWOl2n1XYVYwqMcCs9ZOK
	 3pGd/GBZqU9vwitMZ8vC7muogJDOMCEyF1LkifRFVhANg3NJMAiKq0qiO/KXMXvYUXERw
	 JtXd/arS0KAAw0mbflFlVy/UqUhhUSmjxtdyRdyoQ/8qdtmGlWu4IF2jEntAgaaPQW+I6
	 YLqialSfLdxApxZNLFQDukkw/IKsMHRDXCmBic6A9PM2/XhvbxcPFn1U3uCfvgu5mpFPx
	 TFziy/pI/dZkAnEwKEC0aBZ/zc94UbPszMPMeaR2LDCcR/Zg4TVsOqhWJvv2c00e1QQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585222;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:User-Agent:X-stable:X-Patchwork-Hint:X-KernelTest-Patch:
	 X-KernelTest-Tree:X-KernelTest-Branch:X-KernelTest-Patches:
	 X-KernelTest-Version:X-KernelTest-Deadline:Content-Type:
	 Content-Transfer-Encoding;
	bh=YZkx2EK3xC28KZ2xUfXTRNaYB8wIUy4kQoW7pVGQS8M=;
	b=WBCC9zsfHvOU7r6Q2yjirDk/mdt4JQwxUU5FJ44f75hSUNeEZmKq/Y/wgby20F/D3LHA
	 O05TWXr6I5zGtP8tc9y2+9AxHSnH1+dBcHCPcA8xPJih2cYqXr4EzHjRyFy++e+Q14169
	 BLMXcAFzMin/fyWwlHAG9WQd0K83HajgF6UhWfH55bCJEke+y8fVcJpHy7LPIYnkw9gx6
	 bXWQZMw0K154QHhLQ1z6KL92eljqLjK1IhdqeC+xpozSArVQhRw9JluNqTYxoTAkP0Eb2
	 S/O6mZ3j1SsKmfk0ZDIxCt5iUN25J5kjjNpUVJjHELF0lN1xmDdRRNcRjwg6BURUosQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r+5lNgv0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6811A606A32D;
	Fri, 13 Nov 2026 15:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r+5lNgv0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 858D61F000C4;
	Fri, 13 Nov 2026 15:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585222;
	bh=YZkx2EK3xC28KZ2xUfXTRNaYB8wIUy4kQoW7pVGQS8M=;
	h=From:To:Cc:Subject:Date;
	b=r+5lNgv0j0Hu3/cOsTKHphVbo8QVCJmb972Ax1kQhTVQUI6bwSiVkYAud0BoZpJmz
	 BsBSQ9XSxdxW7rYCXhSAAdQ010bd/wBxtwzc9g2NY3Lw6BxEl51zTaNbuMdPLegIpZ
	 oP4Rfyt7aJwfn960KDehu5HhrObyKQwdy6FzdKCw=
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
Subject: [PATCH 7.3 000/507] 7.3.5-rc1 review
Date: Fri, 13 Nov 2026 10:45:04 -0500
Message-ID: <20261113153753.358973689@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.3.5-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-7.3.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 7.3.5-rc1
X-KernelTest-Deadline: 2026-11-15T15:38+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 7.3.5 release.
There are 507 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 15 Nov 2026 15:36:17 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.3.5-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.3.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 7.3.5-rc1

Gianluca Balboni <gianluca.balboni06@gmail.com>
    ASoC: amd: yc: Add DMI quirk for HP OmniBook 3 Laptop 16-by0xxx

Chao Yu <chao@kernel.org>
    f2fs: fix to use bio_in_atomic() in f2fs_write_end_io()

Arnd Bergmann <arnd@arndb.de>
    mm/vmscan: avoid false-positive -Wuninitialized warning, again

Kairui Song <kasong@tencent.com>
    mm/mglru: use explicit tier range in read_ctrl_pos()

Daeho Jeong <daehojeong@google.com>
    f2fs: expose resizable_tail feature via sysfs

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    intel_idle: Adjust state names and descriptions for _LPI states

Andy Shevchenko <andy.shevchenko@gmail.com>
    intel_idle: Use 2-argument strscpy()

Ali Ahmet Memiş <aliamemis@disroot.org>
    thermal: intel: int340x: Evaluate _TMP exclusively

Andrea Parri <parri.andrea@gmail.com>
    iommufd/iova_bitmap: Ensure that iova_bitmap_set() handles the full IOVA

David Carlier <devnexen@gmail.com>
    media: ipu6: Fix firmware config leak on stream start

Antti Laakso <antti.laakso@linux.intel.com>
    media: ipu6: Rename pointer to firmware context

Daeho Jeong <daehojeong@google.com>
    f2fs: release a removed xattr node in roll-forward recovery

Miquel Raynal <miquel.raynal@bootlin.com>
    clk: nuvoton: ma35d1: Add missing WDT/WWDT parent clocks

Miquel Raynal <miquel.raynal@bootlin.com>
    dt-bindings: clock: ma35d1: Add missing WDT/WWDT parent clocks

Miquel Raynal <miquel.raynal@bootlin.com>
    dt-bindings: clock: ma35d1: Drop CLK_MAX_IDX define

Miquel Raynal <miquel.raynal@bootlin.com>
    clk: nuvoton: ma35d1: Keep the clock count in the driver

Sumit Kumar <sumit.kumar@oss.qualcomm.com>
    PCI: dwc: Set DMA_BYPASS bit in outbound IATU CTRL2 register

Ali Ahmet Memiş <aliamemis@disroot.org>
    ACPI: battery: Evaluate battery methods exclusively

Ali Ahmet Memiş <aliamemis@disroot.org>
    ACPI: utils: Add exclusive AML evaluation helpers

Chao Yu <chao@kernel.org>
    f2fs: fix to invalidate curseg if change_curseg() fails

Vladimir Oltean <vladimir.oltean@nxp.com>
    PCI: cadence: Preserve all error codes in cdns_plat_pcie_probe()

Linmao Li <lilinmao@kylinos.cn>
    PCI: cadence: Store the core controller in platform drvdata

vladimir.oltean@nxp.com <vladimir.oltean@nxp.com>
    PCI: cadence: Remove device links to PHY

Hengyu Liang <hengyul@cs.unc.edu>
    erofs: fix metadata reads at the end of file-backed images

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: hdac_hda: Restore the codec device type on unbind

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: hdac_hda: Allocate the private data at codec driver bind

Guixin Liu <kanie@linux.alibaba.com>
    nvme-tcp: Validate the queue state under the queue lock in the address attribute

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid potential reference count leak in do_garbage_collect()

Marc Zyngier <maz@kernel.org>
    KVM: arm64: vgic: Stop the target vcpu when disabling LPIs

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf evsel: Close the fds opened so far when disabling missing features

Hui Su <sh_def@163.com>
    perf evsel: Restrict incremental open error unwind

Kaixuan Li <kaixuanli0131@gmail.com>
    f2fs: bound the SIT/NAT bitmaps by the checkpoint pack

Daeho Jeong <daehojeong@google.com>
    f2fs: return -EIO for a lost inode block after cp_error

Chao Yu <chao@kernel.org>
    f2fs: zone: fix to avoid bio split on sequential zone

Vincent Donnefort <vdonnefort@google.com>
    KVM: arm64: Use kvm_s2_fault_vma_info in pkvm_mem_abort()

Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
    dmaengine: qcom: bam_dma: free interrupt before the clock in error path

Vishnu Santhosh <vishnu.santhosh@oss.qualcomm.com>
    dmaengine: qcom: bam_dma: Defer IRQ trigger type to device tree

Salvatore Dipietro <dipiets@amazon.it>
    mm/page_alloc: avoid direct reclaim and compaction for costly __GFP_NORETRY allocations

Mehmet Fide <mehmet.fide@screeningeagle.com>
    wifi: rtw88: widen the ATIM window while an AP interface is up

Mehmet Fide <mehmet.fide@screeningeagle.com>
    wifi: rtw88: usb: only let the frames a dozing station needs use the after-DTIM queue

Mehmet Fide <mehmet.fide@screeningeagle.com>
    wifi: rtw88: usb: bound what the driver feeds the after-DTIM queue

Mehmet Fide <mehmet.fide@screeningeagle.com>
    wifi: rtw88: usb: route bmc frames via the high queue only for DTIM delivery

Martin Belanger <martin.belanger@dell.com>
    nvme-tcp: skip TLS control records while waiting for the ICResp

Chris Mason <mason@kernel.org>
    mm/shmem: honour F_SEAL_EXEC when an ACL is set

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    mm/vma: avoid spurious write locks when mm->mm_lock_seq overflows

Dave Hansen <dave.hansen@linux.intel.com>
    mm: add RCU-based VMA lookup helper that waits for writers

David Hildenbrand (Arm) <david@kernel.org>
    mm/userfaultfd: only allocate anon_vma in CoW mappings

James Fairweather <james.a.fairweather@gmail.com>
    platform/chrome: cros_usbpd_notify: Only use drvdata when parent is GOOG0004

Hemanth Selam <hemanth.selam@gmail.com>
    platform/chrome: Fix typos in comments

Yuejie Shi <syjcnss@gmail.com>
    fs/ntfs3: validate the EA value length in ntfs_read_ea()

Jun Yang <junvyyang@tencent.com>
    sctp: re-point retained control chunks on association migration

David Lee <david.lee@trailofbits.com>
    sctp: hold shkey across socket migration

Jared Wuerzburger <jwuerz@gmail.com>
    ALSA: hda/realtek: Fix internal mic on Minisforum V3 and V3 SE

Saim Masood <s.m.saim074@gmail.com>
    ALSA: hda/realtek: Fix speakers on ASUS ExpertBook PM3606CHA

Chao Yu <chao@kernel.org>
    f2fs: fix to check continuousness in f2fs_sync_meta_pages() correctly

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid folio->mapping dereference in is_{meta, node}_folio()

Runyu Xiao <runyu.xiao@seu.edu.cn>
    ALSA: usb-audio: Protect Roland control activation

Nicholas Hobson <nicholas.hobson@outlook.com>
    ALSA: usb-audio: keep MIDI input running for Roland TD-11

Balakrishnan Sambath <balakrishnan.s@microchip.com>
    media: microchip-isc: fix SBGGR10 Bayer pattern

Balakrishnan Sambath <balakrishnan.s@microchip.com>
    media: microchip-isc: fix ISC_PFG_CFG0_BPS macro name typo

Fuad Tabba <fuad.tabba@linux.dev>
    KVM: arm64: Use kvm_s2_fault_vma_info in gmem_abort()

Vincent Donnefort <vdonnefort@google.com>
    KVM: arm64: Pass kvm_s2_fault_desc to fault_supports_stage2_huge_mapping()

Balakrishnan Sambath <balakrishnan.s@microchip.com>
    media: microchip-isc: fix WB offset and gain register field masking

Balakrishnan Sambath <balakrishnan.s@microchip.com>
    media: microchip-isc: store the unshifted PFE_CFG0 BPS value

Cheng Ming Lin <chengminglin@mxic.com.tw>
    mtd: spi-nor: macronix: Restore fallback parameters for MX25L12805D

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: cs35l56: Wait for firmware timer expiry before system suspend

Jason Gunthorpe <jgg@ziepe.ca>
    iommu/arm-smmu-v3: Handle ARM erratum for CONT under invalidation with SVA

Zhao Gongyi <zhaogongyi@bytedance.com>
    ata: libata-scsi: reject data-in commands with a data-out buffer

Sven Eckelmann <sven@narfation.org>
    batman-adv: tt: only update flags for TT events

Sven Eckelmann <sven@narfation.org>
    batman-adv: tt: send ROAM_ADV on each roamed back client

Sven Eckelmann <sven@narfation.org>
    batman-adv: tt: clear ROAM flag when re-adding a pending local client

Sven Eckelmann <sven@narfation.org>
    batman-adv: tt: only transmit local ROAM flag together with DEL

Ido Schimmel <idosch@nvidia.com>
    vxlan: Stop rejecting dynamic FDB entries with a nexthop ID

Guanglei Zhu <zhugl3@xiaopeng.com>
    ceph: clamp the inline data length in ceph_fill_inline_data()

Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
    iommu/amd: Force device table to maximum size

Chris Mason <mason@kernel.org>
    x86/mm: Fix global ASID handed out to two processes

Marco Ziliani <rylos78@gmail.com>
    ata: libata-pmp: disable the SEMB port on Marvell 88SM9705

Kiryl Shutsemau (Meta) <kas@kernel.org>
    arm64: sdei: Preserve the interrupted context's exception registers

Kiryl Shutsemau (Meta) <kas@kernel.org>
    arm64: sdei: Run the event handler on the kernel vectors

Thorsten Blum <blum@kernel.org>
    x86/boot: Fix off-by-one error in sme_clear_pgd()

Jinjie Ruan <ruanjinjie@huawei.com>
    arm64: kexec_file: Fix elf_headers memory leak in retry loop

Kevin Mitchell <kevmitch@arista.com>
    iommu/amd: remove obsolete domain pointer warning on release

Akshay Jindal <Akshay.Jindal@amd.com>
    iommu/amd: Skip non-IVMD entries when parsing IVRS memory definitions

Breno Leitao <leitao@debian.org>
    x86/nmi: Ignore negative NMI handler durations

Daehyeon Ko <4ncienth@gmail.com>
    sched/fair: Clear throttle state when leaving the fair class

Danish Khateeb <danishkhateeb03@gmail.com>
    perf/core: Don't send SIGTRAP after exec removed the event

Shao Mingyin <shao.mingyin@zte.com.cn>
    nvmet: bound the traddr and trsvcid configfs writes

Qiliang Yuan <odys.yuan@gmail.com>
    nvme: wait for SRCU readers before splicing the namespace list

Qiliang Yuan <odys.yuan@gmail.com>
    srcu: Add list_splice_init_srcu()

Imre Kaloz <kaloz@kernel.org>
    MIPS: sgi-ip32: Leave MACE PCI control alone in config accesses

Imre Kaloz <kaloz@kernel.org>
    MIPS: sgi-ip32: Mask MACE PCI interrupts in CRIME only

Imre Kaloz <kaloz@kernel.org>
    MIPS: mm: Fix the cache error vector jump for XKPHYS kernels

Matthias Goergens <matthias.goergens@gmail.com>
    udf: don't use eloc after the end of the unallocated space table

Matthias Goergens <matthias.goergens@gmail.com>
    udf: fix preallocation discarding before an empty allocation extent

Matthias Goergens <matthias.goergens@gmail.com>
    udf: check the unallocated space table when it is loaded

Matthias Goergens <matthias.goergens@gmail.com>
    udf: don't let the extent type hide an exhausted free-space table extent

Kyle Zeng <kylebot@openai.com>
    mptcp: pm: kernel: use RCU to free endpoint listeners

Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
    drm/sched: Adjust run-queue when changing priority at runtime

Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
    drm/sched: Fix out of bounds entity priority check

Christian Gmeiner <cgmeiner@igalia.com>
    drm/etnaviv: Flush the tile status cache through both the PE and BLT

Christian Gmeiner <cgmeiner@igalia.com>
    drm/etnaviv: Fix NULL dereference on unbind without PPU flop reset

James Clark <jjc@jclark.com>
    net: ethernet: ti: am65-cpsw-nuss: Enable timestamping of unicast PTP packets

Ray Zhang <sgzhang@google.com>
    net: count last skb of each sk_backlog pass in __release_sock()

Bryam Vargas <hexlabsecurity@proton.me>
    net/smc: don't spin in smc_rx_recvmsg() while a pipe holds spliced data

Hungyu Lin <dennylin0707@gmail.com>
    ext2: preserve IOMAP_F_DIRTY for extending direct writes

Sinan Turunc <enscrpt@pm.me>
    ALSA: usx2y: Guard the playback copy

Sinan Turunc <enscrpt@pm.me>
    ALSA: usx2y: Require a buffer of two URBs

Wentao Liang <vulab@iscas.ac.cn>
    ALSA: caiaq: free the EP4 URB when input setup fails

Sinan Turunc <enscrpt@pm.me>
    ALSA: line6: Reject capture buffers smaller than two packets

Mohamed Yassine Jebabli <med.jebabli@gmail.com>
    ALSA: hda/tas2781: Only accept CRC-less V1 data if all entries are valid

Alexandr <youdoit@mail.ru>
    ALSA: hda/realtek: Enable mute and mic-mute LEDs on HP ENVY 17-cr0xxx

Yuqiang Sun <izaiahsun@gmail.com>
    ALSA: usb-audio: qcom: Check the return value of qmi_handle_init()

YuanZhe Liu <25031212351@stu.xidian.edu.cn>
    ALSA: usx2y: Refuse a retried DSP load after a failure

YuanZhe Liu <25031212351@stu.xidian.edu.cn>
    ALSA: bcd2000: Fix use-after-free of MIDI URBs on file close

Alex Kazinsky <a.kazinsky@ideco.ru>
    ALSA: cs46xx: Handle SCB creation failures before dereferencing

Chris Simpson <chris@nilk.net>
    ALSA: hda/realtek: Enable bass speakers on Alienware m17 R3

HyeongJun An <sammiee5311@gmail.com>
    ALSA: ump: Fix dropped data bytes at UMP System message conversion

Ilia Mirkin <imirkin@alum.mit.edu>
    drm/nouveau/devinit/gf100-: try to avoid double-running vbios scripts

Finn Zeruhn <fzeruhn@icloud.com>
    drm/dp: keep MOT set between messages when no_zero_sized is set

Rosen Penev <rosenp@gmail.com>
    drm/nouveau/nvkm: clear use.enabled when subdev init fails

Hengyu Liang <hengyul@cs.unc.edu>
    l2tp: only return sessions of the given tunnel in l2tp_session_get()

Amir Goldstein <amir73il@gmail.com>
    selftests/fscontext_ns: expect EINVAL for overlay descendant userns create

Chris Mason <mason@kernel.org>
    ovl: look up the index by the decoded origin

Sasha Levin <sashal@kernel.org>
    nvme-pci: add NVME_QUIRK_DMAPOOL_ALIGN_512 for KIOXIA XG10d

Zhao Gongyi <zhaogongyi@bytedance.com>
    arm64: mm: validate /dev/mem mmap ranges without overflow

Wei Wang <wvw@google.com>
    arm64: suspend: Save and restore TPIDR2_EL0 across CPU suspend

Ewan D. Milne <emilne@redhat.com>
    nvmet: don't return memory contents beyond valid data when reading ANA log page

Jesse Zhang <Jesse.Zhang@amd.com>
    drm/amdgpu: don't drop the gang dependency fence twice

renpanpan <renpanpan@kylinos.cn>
    drm/amdgpu: Only enable HDMI audio if display supports it

Jesse Zhang <Jesse.Zhang@amd.com>
    drm/amdgpu: don't walk the CS chunks when allocating them failed

Jesse Zhang <Jesse.Zhang@amd.com>
    drm/amdgpu: rewrite all PTEs of the BOs after a VM reset

Jesse Zhang <Jesse.Zhang@amd.com>
    drm/amdgpu: unlock the VM and BO when attaching a KFD BO fails

Jesse Zhang <Jesse.Zhang@amd.com>
    drm/amdgpu: drop the dma-buf reference when a KFD import fails

Hugo Sales <hugo@hsal.es>
    drm/amdgpu: Clamp the ATIF backlight curve to its 99 points

Erhan Bilgili <erhan.bilgili@gmail.com>
    drm/amdgpu: Report MES ring wait timeouts.

Erhan Bilgili <erhan.bilgili@gmail.com>
    drm/amdgpu: Fix duplicate dependency fence releases

Kevin Wang <kevin.wang@amd.com>
    drm/amd/pm: populate unique ID for smu 13.0.7

Melissa Wen <mwen@igalia.com>
    drm/amd/display: Signal PQ EOTF in FreeSync infopacket for DP HDR

Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
    drm/amd/display: set allow_freesync before validating a new stream

Kylie C <kyliepc@proton.me>
    drm/amd/display: Don't select zero V_TOTAL_MIN/MAX on seamless boot

Matthew Schwartz <matthew.schwartz@linux.dev>
    drm/amd/display: Keep the nominal vtotal while VRR is inactive

Misha Nasledov <misha@nasledov.com>
    drm/amd/display: Drop clock requirements on DCN32 when no displays are active

Roman Demidov <roman.demidov.nn@gmail.com>
    drm/amd/display: Fix NULL deref in dcn401_update_clocks_update_dtb_dto

Jesse Zhang <Jesse.Zhang@amd.com>
    drm/amdgpu/gfx12: disallow GFXOFF while updating the SPM VMID

Roman Li <Roman.Li@amd.com>
    drm/amd/display: Reset DET of HUBPs without a plane before outstanding updates

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Avoid closing unowned DDC pins

Milan Milicevic <Milan.Milicevic@amd.com>
    drm/amdgpu: publish IH enabled before PSP programs IH_RB_CNTL

Kent Russell <kent.russell@amd.com>
    drm/amdgpu: Ensure that harvest information gets set

Prike Liang <Prike.Liang@amd.com>
    drm/amdgpu: stop the schedulers before preparing the GPU reset

Milan Milicevic <Milan.Milicevic@amd.com>
    drm/amdgpu: clear RB_OVERFLOW bit when enabling interrupts for navi10_ih

Prike Liang <Prike.Liang@amd.com>
    drm/amdgpu: finish GPU recovery callbacks before restarting schedulers

Wayne Lin <Wayne.Lin@amd.com>
    drm/amd/display: add missing CRC engine 1 registers

Jesse Zhang <Jesse.Zhang@amd.com>
    drm/amdgpu/userq: validate the moved individual BOs on restore

Dariusz Marcinkiewicz <darekm@google.com>
    drm/amdgpu: check amdgpu_vm_ready() in dma-buf move notify

Prike Liang <Prike.Liang@amd.com>
    drm/amdgpu/userq: wait for GPU reset before mapping or unmapping queues

Jesse Zhang <Jesse.Zhang@amd.com>
    drm/amdkfd: use the queue's process info for the WPTR BO eviction fence

Jesse Zhang <Jesse.Zhang@amd.com>
    drm/amdgpu: keep the CS user fence BO in GTT

Jesse Zhang <Jesse.Zhang@amd.com>
    drm/amdgpu: parse CS IBs at the BO offset their VA mapping starts at

Jesse Zhang <Jesse.Zhang@amd.com>
    drm/amdgpu: sign extend the addresses GEM_OP(GET_MAPPING_INFO) returns

Ce Sun <cesun102@amd.com>
    drm/amdgpu: skip RAS error count reset in debug mode

Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
    drm/amdgpu: Check cs flags.

Jarkko Sakkinen <jarkko@kernel.org>
    nvme-keyring: Add a missing key_put() call to nvme_tls_key_lookup()

Yitang Yang <yi1tang.yang@gmail.com>
    ublk: add missing DEL_DEV_ASYNC to unprivileged permission check

Yilin Zhang <yilinzhang@moonshot.ai>
    mptcp: do not use Fast Open on MP_JOIN subflows

Daehyeon Ko <4ncienth@gmail.com>
    vhost/vsock: size receive SKBs from declared payload

Alexei Starovoitov <ast@kernel.org>
    net: reject a negative TCP header offset in qdisc_pkt_len_segs_init()

Amir Goldstein <amir73il@gmail.com>
    ovl: inherit FMODE_NONOTIFY when opening directory realfiles

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: clamp skb->queue_mapping before indexing the tx queue

Chris Mason <mason@kernel.org>
    ovl: fix whiteout creation in casefolded directories

Chris Mason <mason@kernel.org>
    ovl: do not let chattr change the casefold flag

Chris Mason <mason@kernel.org>
    ovl: fail the mount if the casefold flag has changed

Xia Yan <yanxia@cmss.chinamobile.com>
    ipv6: fix device binding after failed datagram connect

Thomas Gleixner <tglx@kernel.org>
    x86/entry: Fix ptrace regression

Samiullah Khawaja <skhawaja@google.com>
    mm/gup: check folio->mapping under folio lock in memfd_pin_folios()

Lance Yang <lance.yang@linux.dev>
    khugepaged: fix readahead lock inversion in collapse_file()

Ritesh Harjani (IBM) <ritesh.list@gmail.com>
    mm/huge_memory: set the mmu_gather page size in zap_huge_pud()

David Hildenbrand (Arm) <david@kernel.org>
    mm/memory-tiers: unregister empty tiers outside memory_tier_lock

Rik van Riel <riel@surriel.com>
    mm/cma: don't release CMA pages still in use

David Hildenbrand (Arm) <david@kernel.org>
    mm/vma: don't leak the charge for stack growth

David Hildenbrand (Arm) <david@kernel.org>
    mm/huge_memory: split huge PUDs when adjusting VMA boundaries

Chris Mason <mason@kernel.org>
    mm/vma: call ->may_split() before a partial merge

Chris Mason <mason@kernel.org>
    mm/ksm: check large swap-cache folios before mapping them

David Hildenbrand (Arm) <david@kernel.org>
    mm/ksm: fix use of a freed anon_vma at swap-in

David Hildenbrand (Arm) <david@kernel.org>
    mm/ksm: reset the unstable trees of all nodes

Chris Mason <mason@kernel.org>
    mm: fix deadlock of mremap() against UFFDIO_MOVE

Chris Mason <mason@kernel.org>
    mm: fix unkillable fault loop on MAP_DROPPABLE memory

Josef Bacik <josef@toxicpanda.com>
    mm: fix unmap_mapping_range() beyond 4 GiB on 32-bit

Chris Mason <mason@kernel.org>
    mm/memory: reject remote COW faults on PFN mappings

David Hildenbrand (Arm) <david@kernel.org>
    mm/madvise: fix data loss from MADV_FREE on a KSM page

Josef Bacik <josef@toxicpanda.com>
    mm/mremap: fix moving PUD leaves

David Hildenbrand (Arm) <david@kernel.org>
    mm/mremap: recheck PUDs under the page table lock

David Hildenbrand (Arm) <david@kernel.org>
    mm/mremap: use pudp_huge_get_and_clear() when moving huge PUDs

Chris Mason <mason@kernel.org>
    mm/mmu_notifier: set ->mm only after mmgrab()

Josef Bacik <josef@toxicpanda.com>
    mm/mmu_notifier: finish non-blocking interval invalidation on error

Josef Bacik <josef@toxicpanda.com>
    mm/mmu_gather: fix flushing ranges with 4 GiB or larger

Josef Bacik <josef@toxicpanda.com>
    mm/userfaultfd: wake all waiters on unregister

David Hildenbrand (Arm) <david@kernel.org>
    mm/userfaultfd: write-lock the VMA before waking waiters when unregistering

David Hildenbrand (Arm) <david@kernel.org>
    mm/gup: check for overflow when converting nr_pages to bytes in GUP-fast

Chris Mason <mason@kernel.org>
    mm/gup: fix out-of-bounds write for nr_pages == 0 in GUP-fast

Chris Mason <mason@kernel.org>
    mm/gup: fix clearing folios in memfd_pin_folios()

David Hildenbrand (Arm) <david@kernel.org>
    mm/gup: recheck the PUD under PTL in follow_pud_mask()

Chris Mason <mason@kernel.org>
    mm/khugepaged: preserve dirty bits when collapsing PTE-mapped THPs

Josef Bacik <josef@toxicpanda.com>
    mm/khugepaged: fix PMD table lock leak in try_collapse_pte_mapped_thp()

Josef Bacik <josef@toxicpanda.com>
    mm/khugepaged: always recheck the pmd in try_collapse_pte_mapped_thp()

Chris Mason <mason@kernel.org>
    mm/huge_memory: fix zapping migration entries for device-private THPs

Chris Mason <mason@kernel.org>
    mm/huge_memory: fix truncate racing with PMD zapping

Liu Changjie <liucj1228@outlook.com>
    can: peak_usb: pcan_usb_fd_decode_buf(): accept short uCAN end-of-list records

ChunYuZhiQiang <chunyuzhiqiang@yinhe.ht>
    can: dev: can_fill_info(): don't wake up controller if interface is down

Oliver Hartkopp <socketcan@hartkopp.net>
    can: proc: skip stats calculation after reset in can_stat_update()

Runyu Xiao <runyu.xiao@seu.edu.cn>
    can: proc: reset pkg_stats atomics individually

Oliver Hartkopp <socketcan@hartkopp.net>
    can: raw, isotp: copy socket options outside of lock_sock()

Oliver Hartkopp <socketcan@hartkopp.net>
    can: protect the receive lists with a per-device lock

Oliver Hartkopp <socketcan@hartkopp.net>
    can: isotp: check the return values of can_rx_register() in isotp_bind()

Oliver Hartkopp <socketcan@hartkopp.net>
    can: replace ARPHRD_CAN type checks with can_get_ml_priv()

Cunhao Lu <1579567540@qq.com>
    can: dev: can_put_echo_skb(): free skb on invalid echo index

Cunhao Lu <1579567540@qq.com>
    can: skb: make echo skb freeing safe in any IRQ context

Kaixuan Li <kaixuanli0131@gmail.com>
    can: isotp: check the frame type, not just the length

Vincent Mailhol <mailhol@kernel.org>
    can: dev: can_dropped_invalid_skb: drop CAN XL frames on non-CAN XL devices

Yingjie Wang <1075151112@qq.com>
    nvmet: reject keep-alive timeouts that would overflow

Christoph Hellwig <hch@lst.de>
    xfs: fix recovery of partial attr removals

Hyunwoo Kim <imv4bel@gmail.com>
    net: restore refcount ordering for lockless socket access

Daejun Park <daejun7.park@samsung.com>
    xfs: clamp the pNFS layout range to the maximum file size

Daejun Park <daejun7.park@samsung.com>
    xfs: cap the block count of xfs_iomap_write_direct() at one extent

Daejun Park <daejun7.park@samsung.com>
    xfs: clamp a pNFS LAYOUTCOMMIT extent before computing its end

Daejun Park <daejun7.park@samsung.com>
    xfs: refuse a pNFS LAYOUTCOMMIT of a range without blocks

Daejun Park <daejun7.park@samsung.com>
    xfs: add a flag to convert unwritten extents without allocating blocks

Daejun Park <daejun7.park@samsung.com>
    xfs: mark the inode preallocated for pNFS write layouts past EOF

Zhe Liu <liuzhe1@kylinos.cn>
    blk-iocost: account flush sequence latency only once

Krystian Kaniewski <krystianmkaniewski@gmail.com>
    blk-mq: fix out-of-bounds read in blk_mq_free_rqs

Laveesh Bansal <laveeshb@laveeshbansal.com>
    block: only serialize elevator switches of the same queue

Reid Downing <skibletz@gmail.com>
    xfs: fix wrong compat fields in xfs_ioctl32_bstat_copyin()

Hungyu Lin <dennylin0707@gmail.com>
    block: Return the soft block size for compat BLKBSZGET

Cong Zhang <cong.zhang@oss.qualcomm.com>
    virtio_blk: use synchronous quiesce in virtblk_freeze_priv()

Josef Bacik <josef@toxicpanda.com>
    blk-mq: end the request if getting a keyslot fails

Hungyu Lin <dennylin0707@gmail.com>
    inotify: do not coalesce rename events

chenglong.ma <longpareto@gmail.com>
    vduse: fix VA/PA confusion in the coherent page fault path

Thorsten Blum <blum@kernel.org>
    hwrng: virtio - prevent use-after-free after a failed restore

Esben Haabendal <esben@geanix.com>
    drm/bridge: nwl-dsi: Limit LCDIF specific sync override

Esben Haabendal <esben@geanix.com>
    drm/bridge: nwl-dsi: Cleanup endpoint mux control selection

Yuho Choi <oss.patchbox@gmail.com>
    vdpa/snet: Don't discard the DPU error in snet_send_ctrl_msg()

Yuho Choi <oss.patchbox@gmail.com>
    iommu/virtio: Reset device before deleting virtqueues on probe failure

Fang Xieyan <fangxy@xiaopeng.com>
    vhost: fix used ring index wrap in vhost_add_used_n_in_order

Shubham Antil <shubham@octane.security>
    vhost-scsi: zero misaligned I/O bounce pages

Kyle Zeng <kylebot@openai.com>
    net/sched: sch_qfq: prevent aggregate self-replacement

Jianyun Gao <jianyungao89@gmail.com>
    xfs: fix temporary cursor leak in btree shift corruption paths

Naman Jain <namjain@linux.microsoft.com>
    x86/init: Initialize wall clock in get_rtc_noop()

Cen Zhang <zzzccc427@gmail.com>
    ocfs2: cache the mount context for dentry lock callbacks

Cen Zhang <zzzccc427@gmail.com>
    ocfs2: wait for filecheck kobject release after a failed add

Cen Zhang <zzzccc427@gmail.com>
    ocfs2/cluster: unlink socket containers before releasing resources

Cen Zhang <zzzccc427@gmail.com>
    ocfs2: stop recovery before shutting down local allocators

Cen Zhang <zzzccc427@gmail.com>
    ocfs2/dlm: serialize migration MLE cleanup on failure

Nickolai Zeldovich <nickolai@csail.mit.edu>
    panic: zero the dynamically allocated taint buffer

Cen Zhang <zzzccc427@gmail.com>
    ocfs2: keep locking_state within the cluster connection lifetime

Cen Zhang <zzzccc427@gmail.com>
    ocfs2: validate move extents against a stable EOF

Matheus Alves de Almeida <matheus.aalmeida@inf.ufrgs.br>
    fat: hold truncate_lock in fat_write_failed()

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: do not read the entry array of an empty xattr block

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: do not index before the entry array when dividing an empty bucket

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: do not read the entry array of an empty xattr bucket

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: find the xattr entry again after converting a block to a bucket

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: find the xattr entry again after defragmenting a bucket

Andrew Morton <akpm@linux-foundation.org>
    openrisc: export __mulsi3 for modules

Nathan Chancellor <nathan@kernel.org>
    lib/base64: silence clang-24 -Wconstant-conversion with diag pragmas

T.J. Mercier <tjmercier@google.com>
    mm: memcontrol: fix NULL pointer deref and UAF from high_work_func() on dying memcg

Mike Rapoport (Microsoft) <rppt@kernel.org>
    mm/cma: accept memory of CMA areas reserved at a fixed address

Mike Rapoport (Microsoft) <rppt@kernel.org>
    mm/cma: accept memory of multi-range CMA areas

Johannes Weiner <hannes@cmpxchg.org>
    mm: page_alloc: remove ALLOC_NON_BLOCK from ALLOC_RESERVES

Johannes Weiner <hannes@cmpxchg.org>
    mm: page_alloc: do not give all non-blocking requests reserve access

Kiryl Shutsemau (Meta) <kas@kernel.org>
    mm/hugetlb_vmemmap: map the shared tail page writable

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    mm/vma: update VMA iterator state on error in new VMA merge

Yafang Shao <laoar.shao@gmail.com>
    mm/migrate: snapshot the source nid before the misplaced migration

Lance Yang <lance.yang@linux.dev>
    mm/ksm: fix userfaultfd protection during merge and unmerge

Hungyu Lin <dennylin0707@gmail.com>
    mm/migrate: untag addresses when querying page nodes

Chris Down <chris@chrisdown.name>
    mm: make swapoff interruptible when unusing mms/shmem

SJ Park <sj@kernel.org>
    mm/damon/core: move static variable rotation to damon_ctx

SJ Park <sj@kernel.org>
    mm/damon/core: move static variable last_nr_regions to damon_ctx

SJ Park <sj@kernel.org>
    mm/damon/sysfs-schemes: hold damon_sysfs_lock in target_metric_store()

Hengyu Liang <hengyul@cs.unc.edu>
    fs/proc/task_mmu: return -ENOTTY for unknown pagemap ioctls

Samarth Narang <samarth.colleges@gmail.com>
    mm/ksm: keep soft-dirty when merging a page

David Hildenbrand (Arm) <david@kernel.org>
    mm/vma: write lock source VMA before duplicating it in __split_vma()

Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
    mm/page_alloc: mark pages freed by __free_pages_core() as not tagged

Li Zhe <lizhe.67@bytedance.com>
    mm/hugetlb: fix mremap deadlock when PMD sharing is possible

Li Zhe <lizhe.67@bytedance.com>
    mm/hugetlb: fix mremap move length truncation

Gregory Price (Meta) <gourry@gourry.net>
    mm/page_alloc: let the highest memory node recover from hopeless state

Hungyu Lin <dennylin0707@gmail.com>
    mm/page-writeback: avoid 32-bit overflow in dirty threshold shares

Baolin Wang <baolin.wang@linux.alibaba.com>
    mm: memory: fix truncation removing mapped folios

David Hildenbrand (Arm) <david@kernel.org>
    mm: fix address wraparound when scanning large folio PTEs

Kyle Zeng <kylebot@openai.com>
    mm/khugepaged: flush deferred unmaps before dropping a failed folio

Babu Moger <babu.moger@amd.com>
    x86,fs/resctrl: Keep mbm_assign_mode in default mode at boot

Babu Moger <babu.moger@amd.com>
    x86/resctrl: Correct ABMC counter ID field width

Mohit Sharma <mohit.sharma@oss.qualcomm.com>
    ASoC: qcom: q6apm: Guard callbacks until probe data is ready

Michael McAllister <me@michaelmcallister.org>
    Bluetooth: qca: Fix the WCN3950 NVM baud rate offset

Valentin Kindschi <valentin.kindschi@fiveco.ch>
    Bluetooth: hci_sync: pause advertising for the scan address update

Valentin Kindschi <valentin.kindschi@fiveco.ch>
    Bluetooth: hci_sync: re-enable legacy advertising on resume

Zack Rusin <zack.rusin@broadcom.com>
    x86/vmware: Fix i386 high-bandwidth hypercall arguments

Yingjie Wang <1075151112@qq.com>
    ipv6: reject wrapped temporary address preferred lifetimes

Eric Dumazet <edumazet@kernel.org>
    inet: frags: limit the truesize of a reassembly queue

James Calligeros <jcalligeros99@gmail.com>
    ASoC: tas2770: Fix error detection in tas2770_set_dai_tdm_idle

Sean Christopherson <seanjc@google.com>
    KVM: x86: Unconditionally reset MMU context when emulating INIT

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Cap number of parent PTEs per SP at 1000 (the arbitrary rmap limit)

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Process each host MSR entry at most once when unwinding failed VM-Entry

Sean Christopherson <seanjc@google.com>
    KVM: x86: Conditionally resched when restarting REP string emulation

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Conditionally resched when retrying gPTE walk on A/D update failure

Yuqiang Sun <izaiahsun@gmail.com>
    nvme: Do not drop the cdev reference twice when cdev_device_add() fails

Daejun Park <daejun7.park@samsung.com>
    nvme: unregister when pr_register() is given a zero new key

Christian Aurich Zanettini Martins <christian.aurichzm@gmail.com>
    nvme-rdma: fix NULL queue->ctrl dereference on reconnect

Joonhoe Kim <26rote@gmail.com>
    net: qrtr: announce local services again once our HELLO is sent

Vas Zayarskiy <contact@vasily.cc>
    hwmon: (aquacomputer_d5next) Avoid truncating scaled sensor readings

Guenter Roeck <linux@roeck-us.net>
    hwmon: (sht4x) Convert update_interval to jiffies in pending data check

Guenter Roeck <linux@roeck-us.net>
    hwmon: (coretemp) Set nr_cores only after core_data allocation succeeds

Guenter Roeck <linux@roeck-us.net>
    hwmon: (coretemp) Check for NULL platform device in hotplug callbacks

Baek Kyu, Kim <pocj8ur4in@gmail.com>
    hwmon: (gpio-fan) Update the speed cache before dropping the PM reference

Guenter Roeck <linux@roeck-us.net>
    hwmon: (tmp108) Fix initial conversion delay and wait until ready

Guenter Roeck <linux@roeck-us.net>
    hwmon: (lm75) Fix setting polarity mask for chips with 16-bit config register

Guenter Roeck <linux@roeck-us.net>
    hwmon: (pmbus) Fix return value check from thermal zone registration

Guenter Roeck <linux@roeck-us.net>
    hwmon: (pmbus) Release devres allocated memory after devm_thermal_of_zone_register error

Guenter Roeck <linux@roeck-us.net>
    hwmon: (pmbus) Check return value from pmbus_thermal_add_sensor()

Guenter Roeck <linux@roeck-us.net>
    hwmon: (pmbus/q54sj108a2) Add missing NULL pointer check

Guenter Roeck <linux@roeck-us.net>
    hwmon: (peci/dimmtemp) Fix devres leak and UAF on concurrent unbind

Guenter Roeck <linux@roeck-us.net>
    hwmon: (nct6683) Fix incorrect struct cast in show_pwm() and store_pwm()

Guenter Roeck <linux@roeck-us.net>
    hwmon: (lm87) Fix drvdata type confusion in vrm_show() and vrm_store()

Guenter Roeck <linux@roeck-us.net>
    hwmon: (hp-wmi-sensors) Fix unbounded loops in scale_numeric_sensor()

Guenter Roeck <linux@roeck-us.net>
    hwmon: (hp-wmi-sensors) Avoid global struct mutation

Guenter Roeck <linux@roeck-us.net>
    hwmon: (asus_wmi_sensors) Avoid global struct mutation

Guenter Roeck <linux@roeck-us.net>
    hwmon: (aquacomputer_d5next) Check maxcollection when probing AQUAERO devices

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    hwmon: chipcap2: synchronize ready IRQ state

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    hwmon: chipcap2: serialize access to the alarm indicators

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    hwmon: chipcap2: do not discard pending alarms on disable

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    hwmon: chipcap2: balance regulator state

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    hwmon: chipcap2: enable IRQ processing when regulator is already enabled

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    hwmon: chipcap2: disable device after hwmon teardown

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    hwmon: chipcap2: fix IRQ teardown ordering

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    hwmon: chipcap2: defer probe when IRQs are unavailable

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    hwmon: chipcap2: fix be16 handling

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    hwmon: chipcap2: fix off-by-one in command mode retry loop

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    hwmon: chipcap2: fix command error diagnostics

Alexei Solcanu <alexei.solcanu@pm.me>
    hwmon: (gpd-fan) Reset both fans to automatic on duo boards

Zac Lanzon <lanzonza@gmail.com>
    hwmon: (asus_rog_ryujin) Fix pump control source on the Ryujin III

Jiale Yao <yaojiale02@163.com>
    hwmon: (aquacomputer_d5next) reject short status reports

Baek Kyu, Kim <pocj8ur4in@gmail.com>
    hwmon: (corsair-cpro) Cache fan target only after a successful command

Myeonghun Pak <mhun512@gmail.com>
    hwmon: (sht15) Stop deferred work before releasing its resources

Xia Yan <yana06070@163.com>
    veth: keep carrier off when resizing channels with a down peer

Fang Xieyan <fangxy@xiaopeng.com>
    vringh: reject empty / undersized indirect descriptor tables

Fang Xieyan <fangxy@xiaopeng.com>
    vringh: bound top-level re-entry into indirect tables

Tal Zussman <tz2294@columbia.edu>
    vhost-vdpa: fix pinned page leak in vhost_vdpa_pa_map() error path

Zhan Xusheng <zhanxusheng@xiaomi.com>
    ntfs: don't allow compression on volumes with clusters larger than 4K

Qihang <q.h.hack.winter@gmail.com>
    cipso: fix optlen corruption in cipso_v4_delopt()

Maíra Canal <mcanal@igalia.com>
    drm/v3d: Widen cache_clean_lock over the whole L2TCACTL sequence

Jose Maria Casanova Crespo <jmcasanova@igalia.com>
    drm/v3d: Initialize timedout_batches when running a CSD job

Daejun Park <daejun7.park@samsung.com>
    xfs: don't skip free extents of the longest length in a whole-AG FITRIM

Daejun Park <daejun7.park@samsung.com>
    xfs: don't skip free extents in later batches of a whole-AG FITRIM

Binbin Deng <18983559317@163.com>
    xfs: set healthmon mount cookie before publishing it

Hungyu Lin <dennylin0707@gmail.com>
    ext2: preserve completed DIO bytes when buffered fallback fails

David Hildenbrand (Arm) <david@kernel.org>
    mm/huge_memory: properly handle refcounted PUD mappings on fork

David Hildenbrand (Arm) <david@kernel.org>
    mm/huge_memory: fix list corruption when deferred_split_scan() races with deferred_split_folio()

David Hildenbrand (Arm) <david@kernel.org>
    mm/rmap: handle device-exclusive entries in folio_referenced_one()

David Hildenbrand (Arm) <david@kernel.org>
    mm/filemap: finish fault cleanup before dropping the fault lock

Josef Bacik <josef@toxicpanda.com>
    mm/filemap: don't lose a folio lock wakeup to a signal

Josef Bacik <josef@toxicpanda.com>
    mm/filemap: read mapping->a_ops->free_folio under i_lock

David Hildenbrand (Arm) <david@kernel.org>
    mm/truncate: look again if a folio left the mapping

Josef Bacik <josef@toxicpanda.com>
    mm/memfd: make f_pos accesses atomic

David Hildenbrand (Arm) <david@kernel.org>
    mm/shmem: make shmem_file() check the file's inode

David Hildenbrand (Arm) <david@kernel.org>
    fork: take mmap_lock before copying mm_struct

Josef Bacik <josef@toxicpanda.com>
    mm/mglru: don't use stack pointers when walking PUD and PMD tables

David Hildenbrand (Arm) <david@kernel.org>
    mm/shmem: fix truncation of files containing only swapin-error markers

David Hildenbrand (Arm) <david@kernel.org>
    mm/shmem: fix accounting of swapin-error markers

David Hildenbrand (Arm) <david@kernel.org>
    mm/shmem: fix truncate loop after boundary swapin failure

David Hildenbrand (Arm) <david@kernel.org>
    mm/shmem: preserve allocation errors when swapping in large entries

David Hildenbrand (Arm) <david@kernel.org>
    mm/shmem: fix truncate hang in large swap entry

David Hildenbrand (Arm) <david@kernel.org>
    mm/shmem: rescan after nonuniform folio splitting

David Hildenbrand (Arm) <david@kernel.org>
    mm/shmem: discard whole new large folios on fallocate rollback

Chris Mason <mason@kernel.org>
    mm/shmem: preserve data in clean folios when splitting fails

Chris Mason <mason@kernel.org>
    mm/shmem: stop retrying folios that cannot be split

Josef Bacik <josef@toxicpanda.com>
    tmpfs: preserve explicitly disabled quota limits

Josef Bacik <josef@toxicpanda.com>
    tmpfs: keep the quota soft limits of an unused id

Chris Mason <mason@kernel.org>
    mm/mempolicy: charge shared policy nodes

Ian Bridges <icb@fastmail.org>
    ksmbd: let the owner read and change the DACL when no ACE names it

Ian Bridges <icb@fastmail.org>
    ksmbd: grant a POSIX ACL group entry only to the group's members

Ian Bridges <icb@fastmail.org>
    ksmbd: do not read past the DACL in the access denied debug message

Federico Musto <federico@rimpianto.com>
    net: atl1c: drop oversized RX frames instead of panicking

Mitul Golani <mitulkumar.ajitkumar.golani@intel.com>
    drm/i915/display: Allow port sync on PTL

Vidya Srinivas <vidya.srinivas@intel.com>
    drm/i915/display: Disable pipe joiner on WCL

Vidya Srinivas <vidya.srinivas@intel.com>
    drm/i915/display: Single scaler per pipe on WCL

Lu Yao <yaolu@kylinos.cn>
    drm/i915/gem: Reset err for each fence entry

Werner Sembach <wse@tuxedocomputers.com>
    drm/i915/display: Add quirk to force backlight type on some TUXEDO devices

Jouni Högander <jouni.hogander@intel.com>
    drm/i915/psr: Don't clip plane state destination rectangle

Jouni Högander <jouni.hogander@intel.com>
    drm/i915/psr: Fix SFF and CFF CTL register bit definitions

Jouni Högander <jouni.hogander@intel.com>
    drm/i915/psr: Disable linked plane sel fetch as well

Jouni Högander <jouni.hogander@intel.com>
    drm/i915/display: Add enabled pipe planes into state for selective fetch

Jouni Högander <jouni.hogander@intel.com>
    drm/i915/psr: Clear selective fetch area when duplicating plane state

Rosen Penev <rosenp@gmail.com>
    x86/csum: Relax the len and proto constraints in 32-bit csum_ipv6_magic()

Breno Leitao <leitao@debian.org>
    x86/bugs: Select the BHI mitigation based on the attack vector properly

Lee Jones <lee@kernel.org>
    ASoC: SOF: Intel: hda-sdw-bpt: Stop active DMA before closing BPT streams

Miguel Ojeda <ojeda@kernel.org>
    rust: cpufreq: fix `undocumented_unsafe_blocks` in `PolicyCpu::from_cpu()`

Jack Blessed Kimani <jackblessed191@gmail.com>
    ksmbd: fix NULL pointer dereference in session_user_name() and session_account_type()

Ian Bridges <icb@fastmail.org>
    ksmbd: revert fsids on durable reconnect and replay failure

Ian Bridges <icb@fastmail.org>
    ksmbd: enforce the read-only share flag when creating a stream

Ian Bridges <icb@fastmail.org>
    ksmbd: require DELETE access for delete-on-close opens

Jamal Hadi Salim <jhs@mojatatu.com>
    bpf: Fix skb_pull() BUG in __bpf_redirect_neigh()

YuanZhe Liu <25031212351@stu.xidian.edu.cn>
    ALSA: hwdep: Serialize DSP load requests

YuanZhe Liu <25031212351@stu.xidian.edu.cn>
    ALSA: usx2y: Initialize idle URBs before submitting streams

YuanZhe Liu <25031212351@stu.xidian.edu.cn>
    ALSA: us122l: Fix NULL dereference at hwdep open and release

YuanZhe Liu <25031212351@stu.xidian.edu.cn>
    ALSA: us122l: Add missing NULL check in usb_stream_hwdep_mmap()

Evanshenf <archwse@gmail.com>
    drm/loongson: Handle buffer mapping failures when clearing a BO

Evanshenf <archwse@gmail.com>
    drm/loongson: Fix double free on BO initialization failure

Evanshenf <archwse@gmail.com>
    drm/loongson: Fix framebuffer selection in async cursor updates

Shao Mingyin <shao.mingyin@zte.com.cn>
    scsi: target: tcmu: Fix divide-by-zero in data_pages_per_blk store

Yuanhe Shu <xiangzao@linux.alibaba.com>
    scsi: target: Verify the iSCSI ISID is null-terminated

Yingjie Wang <x-professor@outlook.com>
    scsi: bsg: Report io_uring data copyback failures

Yingjie Wang <x-professor@outlook.com>
    scsi: bsg: Report synchronous data copyback failures

Yu Zhang <yuz08559@gmail.com>
    ptp: fix use-after-free in extts_fifo_show() reading tsevqs unlocked

guolingxing <guolingxing@tju.edu.cn>
    btrfs: prevent deleting the wrong subvolume by ID

guolingxing <guolingxing@tju.edu.cn>
    btrfs: sysfs: restore NOFS context on early return in btrfs_sysfs_add_block_group_type()

Hengyu Liang <hengyul@cs.unc.edu>
    btrfs: fix chattr failing on nodatasum files that have the compress flag

Masafumi Suzuki <shengshilingmu97@gmail.com>
    sctp: account for chunk padding in sctp_init_cause()

Lucas Tanure <lucas.tanure@neat.no>
    drm/vc4: hdmi: enable scrambling before the TMDS clock starts

Lucas Tanure <lucas.tanure@neat.no>
    drm/vc4: hdmi: always cancel the scrambling work synchronously

Dom Cobley <popcornmix@gmail.com>
    drm/vc4: hdmi: power down the BCM2712 PHY when the output is disabled

Zhou Qiuyue <n0ps1edzz@gmail.com>
    ipv6: raw: fix use-after-free in rawv6_send_hdrinc()

Franck Baur <franck.baur.67@gmail.com>
    net: jme: keep RX MAC clock enabled for WoL

Sven Eckelmann <sven@narfation.org>
    batman-adv: tt: don't drop local events queued during TVLV update

Sven Eckelmann <sven@narfation.org>
    batman-adv: tt: ignore ROAM flag of received ADD changes

Sven Eckelmann <sven@narfation.org>
    batman-adv: stop originator purge worker before freeing TT

Sven Eckelmann <sven@narfation.org>
    batman-adv: fix skb leak when hard_iface is being released

Sven Eckelmann <sven@narfation.org>
    batman-adv: dat: initialize orig_node of unfilled candidate slots

Sven Eckelmann <sven@narfation.org>
    batman-adv: tpmeter: fix u32 truncation of reported bytes

Kyle Zeng <kylebot@openai.com>
    batman-adv: mcast: validate tracker padding before forwarding

Eric Biggers <ebiggers@kernel.org>
    lib/crypto: mldsa: Add __must_check to mldsa_verify()

Eric Biggers <ebiggers@kernel.org>
    lib/crypto: mldsa: Explicitly check that 'alg' is a valid value

Eric Biggers <ebiggers@kernel.org>
    lib/crypto: mldsa: Check pk_len before doing pointer arithmetic

Chengfeng Ye <nicoyip.dev@gmail.com>
    batman-adv: Close OGM aggregation before transmission

Yuanfu Xie <yuanfuxie@stu.pku.edu.cn>
    9p: don't decrement a server-owned zero nlink

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    9p/xen: validate the response size from the backend

Yu Zhang <yuz08559@gmail.com>
    scsi: target: Fix demo-mode dynamic ACL dev-entry UAF vs LUN teardown

Andrew Luebke <andrew.luebke@gmail.com>
    scsi: aic79xx: Fix NULL pointer dereference in device reset

Imre Kaloz <kaloz@kernel.org>
    scsi: aic7xxx: Use default settings on the SGI O2 onboard controllers

Fourie Zhang <fouriezhang@tencent.com>
    xfrm4: use a full socket for local errors

Toke Høiland-Jørgensen <toke@toke.dk>
    wifi: mac80211: reinstate IEEE80211_TX_CTL_AMPDU flag in ieee80211_tx_prep_agg()

Eric Biggers <ebiggers@kernel.org>
    lib/crypto: mips: Disable Octeon SHA code on little-endian kernels

Maíra Canal <mcanal@igalia.com>
    drm/vc4: Drop the BO reservations outside of job_lock

Maíra Canal <mcanal@igalia.com>
    drm/vc4: Publish the output fence outside of job_lock

Zijing Yin <yzjaurora@gmail.com>
    wifi: cfg80211: fix out-of-bounds read in valid_rule()

Alex Kazinsky <a.kazinsky@ideco.ru>
    wifi: rsi: Skip TX aggregation setup for non-QoS frames

Jason Perlow <jperlow@gmail.com>
    wifi: brcmfmac: map msgbuf RX packet IDs bidirectional

Weigang He <geoffreyhe2@gmail.com>
    wifi: mac80211: reload TDLS header pointer after skb_linearize()

Yili Zhang <zhangyili01@baidu.com>
    dma-buf: Fix IOVA offset when linking phys vecs to sgt

André Draszik <andre.draszik@linaro.org>
    drm/drm_crtc: fix race with dma_fence_signal() in ::get_driver_name()

André Draszik <andre.draszik@linaro.org>
    drm/drm_crtc: ensure dma_fence_ops remain valid during device unbind

Devin Wittmayer <lucid_duck@justthetip.ca>
    drm/panic: Fix kmsg screen hang on a long log line

Sabrina Dubroca <sd@queasysnail.net>
    xfrm: espintcp: reorder operations within espintcp_init_sk

Qihang <q.h.hack.winter@gmail.com>
    xfrm: interface: validate the IP header on xmit

Hyungjung Joo <jhj140711@gmail.com>
    net/9p/usbg: clear stale client pointer on close

Michael Grzeschik <mgr@kernel.org>
    net/9p/usbg: remove bogus context initialization in alloc_requests

Michael Grzeschik <mgr@kernel.org>
    net/9p/usbg: fix out_req buffer leak in disable_usb9pfs

Michael Grzeschik <mgr@kernel.org>
    net/9p/usbg: call disable_usb9pfs() from usb9pfs_disable()

Michael Grzeschik <mgr@kernel.org>
    net/9p/usbg: always reset completion when disconnecting

Michael Grzeschik <mgr@kernel.org>
    net/9p/usbg: set client to Disconnected on usb9pfs_disable

Michael Grzeschik <mgr@kernel.org>
    net/9p/usbg: also disable endpoints on p9_usbg_close

Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
    net/9p/usbg: Fix use-after-free in disable_usb9pfs()

Zhao Zhang <zzhan461@ucr.edu>
    9p: fix caches_show() out-of-bounds write

Yifei Gao <gyf161023@gmail.com>
    9p/xen: fix refcount leak in p9_xen_response() on wrong tag

Michael Bommarito <michael.bommarito@gmail.com>
    9p/trans_virtio: reject mount tags longer than NAME_MAX at probe

Chengfeng Ye <nicoyip.dev@gmail.com>
    net/9p/usbg: clear stale request context after abort

Chengfeng Ye <nicoyip.dev@gmail.com>
    xfrm: retry inexact policy lookup after node reinsertion

Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
    net/9p/usbg: fix prefix matching in device lookup

Stefano Garzarella <sgarzare@redhat.com>
    9p: fix privport option setting wrong RDMA field

SJ Park <sj@kernel.org>
    mm/damon/sysfs-schemes: read sysfs_filter->sz_range only once

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Force UVC version for Avermedia GC515

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Add autosuspend quirk for AVerMedia Live Gamer HD 2

Christian Loehle <christian.loehle@arm.com>
    cpufreq: CPPC: Select the frequency-invariance callback per CPU

Jeff Layton <jlayton@kernel.org>
    nfsd: shorten extack string returned with dodgy listener

Darrick J. Wong <djwong@kernel.org>
    xfs: forcibly reset quota timers when upgrading to bigtime during repair

Darrick J. Wong <djwong@kernel.org>
    xfs: reinitialize dquot block if non-first dquot can't load

Christian Loehle <christian.loehle@arm.com>
    ACPI: CPPC: Accept requests to retain immutable autonomous selection

Christian Loehle <christian.loehle@arm.com>
    ACPI: CPPC: Validate FFH register fields before hardware access

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtw88: TX report with long timeout for non-PCIE devices

Andrew Morton <akpm@linux-foundation.org>
    block: restore the iterator when rejecting a misaligned bio

SJ Park <sj@kernel.org>
    mm/damon/core: remove unreachable damos charge_{target,addr}_from

Yuansheng Yang <0xbeac@gmail.com>
    io_uring/rsrc: hold uring_lock across index-alloc put_user

Jens Axboe <axboe@kernel.dk>
    io_uring/poll: don't poll a writer for urgent data

Jens Axboe <axboe@kernel.dk>
    io_uring/poll: don't poll a writer for a read side hangup

Shang En Sim <sim@shangen.org>
    io_uring/poll: cancel all matching requests in one pass

Shang En Sim <sim@shangen.org>
    io_uring/cancel: count all requests that a CANCEL_ALL cancels

Shakeel Butt <shakeel.butt@linux.dev>
    io_uring/sqpoll: do the return-to-userspace work in the SQPOLL thread

Shuai Liu <847807867@qq.com>
    io_uring/sqpoll: don't set IO_SQ_THREAD_SHOULD_STOP on thread exit

Jens Axboe <axboe@kernel.dk>
    io_uring/sqpoll: don't attach to a thread that is canceling

Chris Mason <mason@kernel.org>
    io_uring/cancel: drop sqd->lock while SQPOLL waits

Janne Grunau <j@jannau.net>
    wifi: brcmfmac: cfg80211: Report port_authorized for 4-way HS offload

Gael Blivet <gael.blivet@gmail.com>
    ksmbd: look up stream size by exact xattr name

Chuck Lever <cel@kernel.org>
    NFSD: Complete a cld upcall when copying its reply fails

Chuck Lever <cel@kernel.org>
    NFSD: Complete a cld upcall when the daemon closes the pipe

Chuck Lever <cel@kernel.org>
    NFSD: Move the cld upcall message out of the caller's stack frame

Chuck Lever <cel@kernel.org>
    NFSD: Send a meaningful CB_RECALL_ANY keep count

Jeff Layton <jlayton@kernel.org>
    NFSD: stop registering with rpcbind after a failure in listener_set

Jeff Layton <jlayton@kernel.org>
    SUNRPC: report local rpcbind calls that get no answer

Jeff Layton <jlayton@kernel.org>
    NFSD: report listener creation failures through extack

Chuck Lever <cel@kernel.org>
    NFSD: map fh_verify() status codes for NFS_ACLv2 replies

Chuck Lever <cel@kernel.org>
    NFSD: Move version-specific ACCESS maps into per-version code

Chuck Lever <cel@kernel.org>
    NFSD: Replace nfsd_write()'s "stable" argument with "iocb_flags"

Darrick J. Wong <djwong@kernel.org>
    xfs: improve dirent bounds checking in scrub and repair

Darrick J. Wong <djwong@kernel.org>
    xfs: refactor directory data block walking loops in scrub

Darrick J. Wong <djwong@kernel.org>
    xfs: check for buffer overruns when examining local/remote xattr entries

Darrick J. Wong <djwong@kernel.org>
    xfs: break out xattr entry checks into separate functions

Weiming Shi <bestswngs@gmail.com>
    smb/server: prevent file publication after tree disconnect

Jinwang Li <jinwang.li@oss.qualcomm.com>
    Bluetooth: L2CAP: Ignore connection responses with wrong ident

Siwei Zhang <oss@fourdim.xyz>
    Bluetooth: L2CAP: Only accept connection responses to outstanding requests

Siwei Zhang <oss@fourdim.xyz>
    Bluetooth: L2CAP: Reject signalling responses in invalid states

Ashok Raj <ashok.raj@oss.qualcomm.com>
    cxl/features: Ensure that count is set before access to ent[] __counted_by()


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-fs-f2fs            |   2 +-
 Documentation/admin-guide/pm/intel_idle.rst        |  12 +-
 Documentation/arch/arm64/silicon-errata.rst        |   3 +-
 Documentation/filesystems/overlayfs.rst            |   3 +-
 Documentation/filesystems/resctrl.rst              |  87 ++++---
 Documentation/hwmon/asus_rog_ryujin.rst            |   6 +
 Documentation/mm/process_addrs.rst                 |  14 +-
 Documentation/mm/vmemmap_dedup.rst                 |  15 +-
 Makefile                                           |   4 +-
 arch/arm64/include/asm/sdei.h                      |   3 +-
 arch/arm64/include/asm/suspend.h                   |   2 +-
 arch/arm64/kernel/entry-common.c                   |  40 ++-
 arch/arm64/kernel/machine_kexec_file.c             |   2 +
 arch/arm64/kernel/sdei.c                           |  59 ++++-
 arch/arm64/kernel/topology.c                       |  12 +-
 arch/arm64/kvm/mmu.c                               | 129 +++++-----
 arch/arm64/kvm/pkvm.c                              |   3 +
 arch/arm64/kvm/vgic/vgic-mmio-v3.c                 |  10 +
 arch/arm64/mm/mmap.c                               |   4 +-
 arch/arm64/mm/proc.S                               |   8 +
 arch/mips/mm/cex-gen.S                             |  16 ++
 arch/mips/pci/ops-mace.c                           |  26 +-
 arch/mips/pci/pci-ip32.c                           |   9 +-
 arch/mips/sgi-ip32/ip32-irq.c                      |  45 +---
 arch/openrisc/kernel/or32_ksyms.c                  |   1 +
 arch/x86/boot/startup/sme.c                        |   2 +-
 arch/x86/entry/syscall_32.c                        |   4 +
 arch/x86/entry/syscall_64.c                        |  26 +-
 arch/x86/include/asm/checksum_32.h                 |   2 +-
 arch/x86/include/asm/vmware.h                      |  24 +-
 arch/x86/kernel/acpi/cppc.c                        |  15 ++
 arch/x86/kernel/cpu/bugs.c                         |  12 +-
 arch/x86/kernel/cpu/resctrl/internal.h             |   4 +-
 arch/x86/kernel/cpu/resctrl/monitor.c              |   4 +-
 arch/x86/kernel/nmi.c                              |   8 +
 arch/x86/kernel/x86_init.c                         |   2 +-
 arch/x86/kvm/mmu/mmu.c                             |  10 +
 arch/x86/kvm/mmu/paging_tmpl.h                     |  11 +-
 arch/x86/kvm/vmx/nested.c                          |   1 +
 arch/x86/kvm/x86.c                                 |  33 ++-
 arch/x86/mm/tlb.c                                  |  16 +-
 block/bio.c                                        |   3 +
 block/blk-iocost.c                                 |   3 +
 block/blk-mq.c                                     |  17 +-
 block/elevator.c                                   |  32 +--
 block/ioctl.c                                      |   4 +-
 drivers/acpi/battery.c                             |  12 +-
 drivers/acpi/cppc_acpi.c                           |  61 ++++-
 drivers/acpi/utils.c                               |  41 +++
 drivers/ata/libata-pmp.c                           |  14 ++
 drivers/ata/libata-scsi.c                          |  25 ++
 drivers/block/ublk_drv.c                           |   1 +
 drivers/block/virtio_blk.c                         |   2 +-
 drivers/bluetooth/btqca.c                          |   3 +-
 drivers/char/hw_random/virtio-rng.c                |   7 +
 drivers/clk/nuvoton/clk-ma35d1.c                   |   7 +-
 drivers/cpufreq/amd-pstate.c                       |  25 +-
 drivers/cpufreq/cppc_cpufreq.c                     |  26 +-
 drivers/cxl/core/features.c                        |   2 +-
 drivers/dma-buf/dma-buf-mapping.c                  |   2 +-
 drivers/dma/qcom/bam_dma.c                         |  10 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c           |   6 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h         |   3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   |  17 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c             |  21 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |  41 +--
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c      |  44 +++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c        |   5 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c            |   7 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c            |   3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_sync.c           |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c          |  19 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |  16 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c        |   1 -
 drivers/gpu/drm/amd/amdgpu/dce_v10_0.c             |   5 +-
 drivers/gpu/drm/amd/amdgpu/dce_v6_0.c              |   5 +-
 drivers/gpu/drm/amd/amdgpu/dce_v8_0.c              |   5 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c             |   2 +
 drivers/gpu/drm/amd/amdgpu/ih_v6_0.c               |  13 +-
 drivers/gpu/drm/amd/amdgpu/mes_v11_0.c             |   4 +-
 drivers/gpu/drm/amd/amdgpu/mes_v12_0.c             |   4 +-
 drivers/gpu/drm/amd/amdgpu/navi10_ih.c             |  41 ++-
 .../gpu/drm/amd/amdkfd/kfd_process_queue_manager.c |   3 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_freesync.c |  27 +-
 .../amd/display/dc/clk_mgr/dcn401/dcn401_clk_mgr.c |   3 +
 drivers/gpu/drm/amd/display/dc/core/dc.c           |   6 +-
 .../gpu/drm/amd/display/dc/core/dc_hw_sequencer.c  |  31 +++
 drivers/gpu/drm/amd/display/dc/hwss/hw_sequencer.h |   3 +
 .../display/dc/link/protocols/link_dp_capability.c |   6 +-
 .../gpu/drm/amd/display/dc/optc/dcn20/dcn20_optc.c |   7 +
 .../gpu/drm/amd/display/dc/optc/dcn30/dcn30_optc.h |  18 ++
 .../gpu/drm/amd/display/dc/optc/dcn31/dcn31_optc.h |  22 +-
 .../drm/amd/display/dc/optc/dcn314/dcn314_optc.h   |  18 ++
 .../gpu/drm/amd/display/dc/optc/dcn32/dcn32_optc.h |  11 +
 .../gpu/drm/amd/display/dc/optc/dcn35/dcn35_optc.h |  11 -
 .../drm/amd/display/dc/optc/dcn401/dcn401_optc.h   |  12 +
 .../gpu/drm/amd/display/dc/optc/dcn42/dcn42_optc.h |   2 +
 .../gpu/drm/amd/display/dc/optc/dcn60/dcn60_optc.h |   2 +
 .../amd/display/dc/resource/dcn32/dcn32_resource.c |  15 +-
 .../amd/display/dc/resource/dcn32/dcn32_resource.h |   6 +
 .../display/dc/resource/dcn401/dcn401_resource.h   |   6 +
 .../drm/amd/display/modules/freesync/freesync.c    |   6 +-
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c   |  20 ++
 drivers/gpu/drm/bridge/nwl-dsi.c                   |  17 +-
 drivers/gpu/drm/display/drm_dp_helper.c            |   3 +-
 drivers/gpu/drm/drm_crtc.c                         |  18 +-
 drivers/gpu/drm/drm_panic.c                        |   7 +-
 drivers/gpu/drm/etnaviv/etnaviv_buffer.c           |  40 ++-
 drivers/gpu/drm/etnaviv/etnaviv_drv.c              |   6 +-
 drivers/gpu/drm/i915/display/intel_ddi.c           |   2 +-
 .../gpu/drm/i915/display/intel_display_device.c    |   5 +-
 drivers/gpu/drm/i915/display/intel_dp.c            |   4 +-
 .../gpu/drm/i915/display/intel_dp_aux_backlight.c  |  22 +-
 drivers/gpu/drm/i915/display/intel_plane.c         |  11 +
 drivers/gpu/drm/i915/display/intel_psr.c           |  96 ++++----
 drivers/gpu/drm/i915/display/intel_psr_regs.h      |   4 +-
 drivers/gpu/drm/i915/display/intel_quirks.c        |  24 ++
 drivers/gpu/drm/i915/display/intel_quirks.h        |   1 +
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c     |   2 +-
 drivers/gpu/drm/loongson/lsdc_gem.c                |  14 +-
 drivers/gpu/drm/loongson/lsdc_plane.c              |   2 +-
 drivers/gpu/drm/loongson/lsdc_ttm.c                |  14 +-
 drivers/gpu/drm/loongson/lsdc_ttm.h                |   2 +-
 drivers/gpu/drm/nouveau/nvkm/core/subdev.c         |   1 +
 .../gpu/drm/nouveau/nvkm/subdev/devinit/gf100.c    |  20 ++
 drivers/gpu/drm/scheduler/sched_entity.c           |  29 ++-
 drivers/gpu/drm/v3d/v3d_gem.c                      |   5 +-
 drivers/gpu/drm/v3d/v3d_sched.c                    |   2 +
 drivers/gpu/drm/vc4/vc4_gem.c                      |  14 +-
 drivers/gpu/drm/vc4/vc4_hdmi.c                     |  10 +-
 drivers/gpu/drm/vc4/vc4_hdmi_phy.c                 |   5 +
 drivers/hwmon/aquacomputer_d5next.c                |  58 ++++-
 drivers/hwmon/asus_rog_ryujin.c                    |  54 +++-
 drivers/hwmon/asus_wmi_sensors.c                   |  13 +-
 drivers/hwmon/chipcap2.c                           | 196 ++++++++++-----
 drivers/hwmon/coretemp.c                           |  13 +-
 drivers/hwmon/corsair-cpro.c                       |   3 +-
 drivers/hwmon/gpd-fan.c                            |   1 +
 drivers/hwmon/gpio-fan.c                           |   7 +-
 drivers/hwmon/hp-wmi-sensors.c                     |  29 ++-
 drivers/hwmon/lm75.c                               |   9 +-
 drivers/hwmon/lm87.c                               |   7 +-
 drivers/hwmon/nct6683.c                            |   4 +-
 drivers/hwmon/peci/dimmtemp.c                      |  21 +-
 drivers/hwmon/pmbus/pmbus_core.c                   |  51 ++--
 drivers/hwmon/pmbus/q54sj108a2.c                   |   2 +
 drivers/hwmon/sht15.c                              |  22 +-
 drivers/hwmon/sht4x.c                              |   4 +-
 drivers/hwmon/tmp108.c                             |  26 +-
 drivers/idle/intel_idle.c                          |  11 +-
 drivers/iommu/amd/init.c                           |  41 ++-
 drivers/iommu/amd/iommu.c                          |  17 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c    |   7 +
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c        |  91 +++++--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h        |   5 +
 drivers/iommu/iommufd/io_pagetable.c               |   2 +-
 drivers/iommu/iommufd/iova_bitmap.c                |  19 +-
 drivers/iommu/virtio-iommu.c                       |   6 +-
 drivers/media/pci/intel/ipu6/ipu6-fw-isys.c        |  88 ++++---
 drivers/media/pci/intel/ipu6/ipu6-isys-video.c     |   4 +-
 drivers/media/pci/intel/ipu6/ipu6-isys.c           |   6 +-
 drivers/media/pci/intel/ipu6/ipu6-isys.h           |   5 +-
 .../media/platform/microchip/microchip-isc-base.c  |  20 +-
 .../media/platform/microchip/microchip-isc-regs.h  |  16 +-
 drivers/media/platform/microchip/microchip-isc.h   |   4 +-
 .../platform/microchip/microchip-sama5d2-isc.c     |  20 +-
 .../platform/microchip/microchip-sama7g5-isc.c     |  20 +-
 drivers/media/usb/uvc/uvc_driver.c                 |  20 ++
 drivers/mtd/spi-nor/macronix.c                     |   2 +
 drivers/net/can/dev/netlink.c                      |   4 +-
 drivers/net/can/dev/skb.c                          |  10 +-
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c         |   7 +-
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c    |  33 +++
 drivers/net/ethernet/jme.c                         |  37 ++-
 drivers/net/ethernet/jme.h                         |   1 +
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |   4 +-
 drivers/net/veth.c                                 |   5 +-
 drivers/net/vxlan/vxlan_core.c                     |  14 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |   7 +
 .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  |   2 +-
 drivers/net/wireless/realtek/rtw88/mac80211.c      |   2 +
 drivers/net/wireless/realtek/rtw88/reg.h           |   2 +
 drivers/net/wireless/realtek/rtw88/tx.c            |   9 +-
 drivers/net/wireless/realtek/rtw88/tx.h            |   3 +-
 drivers/net/wireless/realtek/rtw88/usb.c           |  68 ++++-
 drivers/net/wireless/realtek/rtw88/usb.h           |   5 +
 drivers/net/wireless/rsi/rsi_91x_core.c            |   2 +-
 drivers/nvme/common/keyring.c                      |   1 +
 drivers/nvme/host/core.c                           |  21 +-
 drivers/nvme/host/multipath.c                      |   2 -
 drivers/nvme/host/pci.c                            |   2 +
 drivers/nvme/host/pr.c                             |   8 +-
 drivers/nvme/host/rdma.c                           |   7 +-
 drivers/nvme/host/tcp.c                            | 213 +++++++++++++---
 drivers/nvme/target/admin-cmd.c                    |  16 +-
 drivers/nvme/target/configfs.c                     |   4 +-
 drivers/nvme/target/core.c                         |   8 +-
 drivers/nvme/target/nvmet.h                        |   8 +
 drivers/pci/controller/cadence/pcie-cadence-plat.c |  33 +--
 drivers/pci/controller/cadence/pcie-cadence.c      |  16 +-
 drivers/pci/controller/cadence/pcie-cadence.h      |   2 -
 drivers/pci/controller/dwc/pcie-designware.c       |   2 +
 drivers/pci/controller/dwc/pcie-designware.h       |   1 +
 drivers/platform/chrome/cros_ec_ishtp.c            |   2 +-
 drivers/platform/chrome/cros_usbpd_notify.c        |  41 +--
 drivers/ptp/ptp_sysfs.c                            |   6 +-
 drivers/scsi/aic7xxx/aic79xx_core.c                |   4 +-
 drivers/scsi/aic7xxx/aic79xx_osm.h                 |  26 +-
 drivers/scsi/aic7xxx/aic7xxx_core.c                |   8 +-
 drivers/scsi/aic7xxx/aic7xxx_pci.c                 |  20 +-
 drivers/scsi/scsi_bsg.c                            |   8 +-
 drivers/target/target_core_device.c                |  18 +-
 drivers/target/target_core_fabric_lib.c            |  10 +
 drivers/target/target_core_tpg.c                   |  10 +-
 drivers/target/target_core_user.c                  |   5 +
 .../intel/int340x_thermal/int3403_thermal.c        |   3 +-
 .../intel/int340x_thermal/int340x_thermal_zone.c   |   6 +-
 .../int340x_thermal/processor_thermal_device.c     |   2 +-
 drivers/vdpa/solidrun/snet_ctrl.c                  |   3 +-
 drivers/vdpa/vdpa_user/iova_domain.c               |  11 +-
 drivers/vhost/scsi.c                               |   7 +-
 drivers/vhost/vdpa.c                               |   8 +-
 drivers/vhost/vhost.c                              |   3 +-
 drivers/vhost/vringh.c                             |  27 +-
 drivers/vhost/vsock.c                              |  34 ++-
 fs/9p/v9fs.c                                       |  18 +-
 fs/9p/vfs_inode.c                                  |   8 +
 fs/btrfs/ioctl.c                                   |  24 ++
 fs/btrfs/sysfs.c                                   |   1 +
 fs/ceph/addr.c                                     |   6 +
 fs/erofs/fileio.c                                  |  18 +-
 fs/ext2/file.c                                     |   3 +-
 fs/ext2/inode.c                                    |  13 +-
 fs/f2fs/checkpoint.c                               |  13 +-
 fs/f2fs/data.c                                     |  28 ++-
 fs/f2fs/f2fs.h                                     |  10 +-
 fs/f2fs/gc.c                                       |  11 +-
 fs/f2fs/node.c                                     |  75 +++++-
 fs/f2fs/segment.c                                  |   3 +-
 fs/f2fs/super.c                                    |  24 ++
 fs/f2fs/sysfs.c                                    |   2 +
 fs/fat/inode.c                                     |   2 +
 fs/nfsd/nfs2acl.c                                  |  64 ++++-
 fs/nfsd/nfs3proc.c                                 |  58 ++++-
 fs/nfsd/nfs3xdr.c                                  |   2 +
 fs/nfsd/nfs4proc.c                                 |  60 ++++-
 fs/nfsd/nfs4recover.c                              |  49 +++-
 fs/nfsd/nfs4state.c                                |  24 +-
 fs/nfsd/nfs4xdr.c                                  |   2 +-
 fs/nfsd/nfsctl.c                                   |  56 ++++-
 fs/nfsd/nfsproc.c                                  |   2 +-
 fs/nfsd/state.h                                    |   2 +
 fs/nfsd/vfs.c                                      | 108 ++------
 fs/nfsd/vfs.h                                      |  21 +-
 fs/nfsd/xdr3.h                                     |   2 +-
 fs/notify/inotify/inotify_fsnotify.c               |   2 +-
 fs/ntfs/ea.c                                       |   5 +
 fs/ntfs3/xattr.c                                   |  25 +-
 fs/ocfs2/cluster/tcp.c                             |   5 +-
 fs/ocfs2/dcache.h                                  |   5 +-
 fs/ocfs2/dlm/dlmmaster.c                           |  70 +++++-
 fs/ocfs2/dlmglue.c                                 |  34 +--
 fs/ocfs2/filecheck.c                               |   2 +
 fs/ocfs2/journal.c                                 |  15 +-
 fs/ocfs2/journal.h                                 |   1 +
 fs/ocfs2/move_extents.c                            |  70 +++---
 fs/ocfs2/super.c                                   |   3 +
 fs/ocfs2/xattr.c                                   | 120 ++++++++-
 fs/open.c                                          |   1 +
 fs/overlayfs/dir.c                                 |  46 ++--
 fs/overlayfs/export.c                              |   4 +-
 fs/overlayfs/inode.c                               |   8 +
 fs/overlayfs/namei.c                               |  13 +-
 fs/overlayfs/overlayfs.h                           |  21 +-
 fs/overlayfs/readdir.c                             |   6 +-
 fs/overlayfs/super.c                               |  12 +-
 fs/overlayfs/util.c                                |  13 +-
 fs/proc/task_mmu.c                                 |   2 +-
 fs/smb/server/mgmt/user_session.c                  |   4 +
 fs/smb/server/smb2pdu.c                            |  65 +++--
 fs/smb/server/smbacl.c                             |  43 +++-
 fs/smb/server/vfs.c                                |   4 +-
 fs/smb/server/vfs.h                                |   2 +
 fs/smb/server/vfs_cache.c                          |  58 +++--
 fs/udf/balloc.c                                    |  11 +-
 fs/udf/super.c                                     |  80 +++++-
 fs/udf/truncate.c                                  |   7 +-
 fs/xfs/libxfs/xfs_attr_leaf.c                      |   9 +-
 fs/xfs/libxfs/xfs_bmap.c                           |  14 +-
 fs/xfs/libxfs/xfs_bmap.h                           |  10 +-
 fs/xfs/libxfs/xfs_btree.c                          |   4 +-
 fs/xfs/scrub/attr.c                                | 102 ++++++--
 fs/xfs/scrub/attr_repair.c                         |  18 +-
 fs/xfs/scrub/dir.c                                 | 110 ++++++++-
 fs/xfs/scrub/dir_repair.c                          | 100 ++++++--
 fs/xfs/scrub/quota_repair.c                        |  33 ++-
 fs/xfs/xfs_discard.c                               |  26 +-
 fs/xfs/xfs_file.c                                  |   2 +-
 fs/xfs/xfs_healthmon.c                             |   2 +-
 fs/xfs/xfs_ioctl32.c                               |   4 +-
 fs/xfs/xfs_ioend.c                                 |   2 +-
 fs/xfs/xfs_iomap.c                                 |  28 ++-
 fs/xfs/xfs_iomap.h                                 |   3 +-
 fs/xfs/xfs_pnfs.c                                  |  60 +++--
 include/acpi/acpi_bus.h                            |   7 +
 include/acpi/cppc_acpi.h                           |   6 +
 include/asm-generic/tlb.h                          |   3 +-
 include/crypto/mldsa.h                             |   6 +-
 include/dt-bindings/clock/nuvoton,ma35d1-clk.h     |   3 +-
 include/linux/blkdev.h                             |   4 +-
 include/linux/can/can-ml.h                         |   3 +
 include/linux/can/dev.h                            |   2 +-
 include/linux/can/skb.h                            |   4 +-
 include/linux/damon.h                              |  10 +
 include/linux/huge_mm.h                            |   5 +-
 include/linux/hugetlb.h                            |  15 +-
 include/linux/ksm.h                                |   6 +-
 include/linux/memfd.h                              |   9 +
 include/linux/mm_types.h                           |  12 +-
 include/linux/mmap_lock.h                          |  39 ++-
 include/linux/mmu_notifier.h                       |   3 +-
 include/linux/mmzone.h                             |   2 +
 include/linux/nfs4.h                               |   6 +
 include/linux/shmem_fs.h                           |  15 +-
 include/linux/srcu.h                               |  36 +++
 include/linux/sunrpc/clnt.h                        |   3 +-
 include/linux/sunrpc/svc.h                         |   7 +-
 include/linux/userfaultfd_k.h                      |   2 -
 include/net/espintcp.h                             |   5 +-
 include/net/inet_frag.h                            |   9 +
 include/net/netns/can.h                            |   2 +-
 include/net/sctp/sm.h                              |   1 +
 include/sound/cs35l56.h                            |   4 +
 include/sound/hwdep.h                              |   1 +
 include/uapi/linux/iommufd.h                       |   6 +
 io_uring/cancel.c                                  |  26 +-
 io_uring/poll.c                                    |  62 ++++-
 io_uring/rsrc.c                                    |  21 +-
 io_uring/sqpoll.c                                  |  26 +-
 kernel/events/core.c                               |   9 +
 kernel/fork.c                                      |  20 +-
 kernel/panic.c                                     |   2 +-
 kernel/sched/fair.c                                |   4 +-
 lib/base64.c                                       |   3 +
 lib/crypto/Kconfig                                 |   6 +-
 lib/crypto/mldsa.c                                 |  15 +-
 lib/crypto/tests/mldsa_kunit.c                     |   9 +
 mm/cma.c                                           |  14 +-
 mm/damon/core.c                                    |  32 ++-
 mm/damon/sysfs-schemes.c                           |   8 +-
 mm/filemap.c                                       |  84 +++----
 mm/gup.c                                           |  68 +++--
 mm/huge_memory.c                                   | 146 ++++++++---
 mm/hugetlb.c                                       |  92 ++++---
 mm/hugetlb_vmemmap.c                               |   8 +-
 mm/internal.h                                      |  38 ++-
 mm/khugepaged.c                                    |  75 ++++--
 mm/ksm.c                                           |  66 +++--
 mm/madvise.c                                       |   9 +
 mm/memcontrol.c                                    |   5 +
 mm/memfd.c                                         |   2 +
 mm/memory-tiers.c                                  |  29 +--
 mm/memory.c                                        | 133 ++++++----
 mm/mempolicy.c                                     |   4 +-
 mm/migrate.c                                       |   5 +-
 mm/mm_init.c                                       |   2 -
 mm/mmap.c                                          |   8 +-
 mm/mmap_lock.c                                     | 124 +++++++++-
 mm/mmu_notifier.c                                  |  24 +-
 mm/mremap.c                                        | 103 ++++----
 mm/nommu.c                                         |   2 +-
 mm/page-writeback.c                                |   8 +-
 mm/page_alloc.c                                    |  30 ++-
 mm/page_alloc.h                                    |  14 +-
 mm/rmap.c                                          |  23 +-
 mm/shmem.c                                         | 141 +++++++----
 mm/shmem_quota.c                                   |  28 ++-
 mm/swapfile.c                                      |   7 +-
 mm/truncate.c                                      |  13 +-
 mm/userfaultfd.c                                   |  63 ++---
 mm/util.c                                          |  13 +
 mm/vma.c                                           |  54 ++--
 mm/vma_init.c                                      |   3 +
 mm/vmscan.c                                        |  29 ++-
 net/9p/trans_usbg.c                                |  91 +++++--
 net/9p/trans_virtio.c                              |   5 +
 net/9p/trans_xen.c                                 |  10 +
 net/batman-adv/bat_iv_ogm.c                        |   5 +
 net/batman-adv/distributed-arp-table.c             |   1 +
 net/batman-adv/main.c                              |  12 +-
 net/batman-adv/multicast_forw.c                    |   5 +-
 net/batman-adv/tp_meter.c                          |   2 +-
 net/batman-adv/translation-table.c                 | 133 ++++++----
 net/batman-adv/types.h                             |   8 +-
 net/bluetooth/hci_sync.c                           |  25 +-
 net/bluetooth/l2cap_core.c                         |  47 +++-
 net/can/af_can.c                                   |  56 +++--
 net/can/bcm.c                                      |  50 ++--
 net/can/gw.c                                       |   7 +-
 net/can/isotp.c                                    | 236 +++++++++++-------
 net/can/proc.c                                     |  69 +++---
 net/can/raw.c                                      | 274 ++++++++++++---------
 net/core/dev.c                                     |   4 +-
 net/core/filter.c                                  |  23 +-
 net/core/sock.c                                    |   6 +-
 net/ipv4/cipso_ipv4.c                              |   9 +-
 net/ipv4/inet_connection_sock.c                    |   6 +-
 net/ipv4/inet_fragment.c                           |   5 +
 net/ipv4/inet_hashtables.c                         |   2 +-
 net/ipv4/inet_timewait_sock.c                      |   4 +-
 net/ipv4/syncookies.c                              |   2 +-
 net/ipv4/tcp_fastopen.c                            |   2 +-
 net/ipv4/xfrm4_output.c                            |   7 +-
 net/ipv6/addrconf.c                                |   3 +-
 net/ipv6/datagram.c                                |   4 +
 net/ipv6/inet6_hashtables.c                        |   2 +-
 net/ipv6/raw.c                                     |   3 +
 net/l2tp/l2tp_core.c                               |  13 +-
 net/mac80211/tdls.c                                |   3 +-
 net/mac80211/tx.c                                  |   2 +
 net/mptcp/pm_kernel.c                              |   1 +
 net/mptcp/subflow.c                                |  11 +
 net/qrtr/af_qrtr.c                                 |  53 +++-
 net/sched/sch_generic.c                            |  41 ++-
 net/sched/sch_qfq.c                                |   3 +
 net/sched/sch_taprio.c                             |   5 +
 net/sctp/sm_make_chunk.c                           |  14 +-
 net/sctp/socket.c                                  |  57 ++++-
 net/smc/smc_rx.c                                   |  39 ++-
 net/sunrpc/rpcb_clnt.c                             |  22 +-
 net/sunrpc/svc.c                                   |  42 +++-
 net/wireless/reg.c                                 |   3 +
 net/xfrm/espintcp.c                                |  43 ++--
 net/xfrm/xfrm_interface_core.c                     |   8 +
 net/xfrm/xfrm_policy.c                             |  11 +-
 rust/kernel/cpufreq.rs                             |   4 +-
 sound/core/hwdep.c                                 |   2 +
 sound/core/ump_convert.c                           |   2 +-
 sound/hda/codecs/realtek/alc269.c                  |  45 +++-
 sound/hda/codecs/side-codecs/tas2781_hda.c         |  27 +-
 sound/pci/cs46xx/dsp_spos.c                        |   2 +
 sound/pci/cs46xx/dsp_spos_scb_lib.c                |   3 +-
 sound/soc/amd/yc/acp6x-mach.c                      |   7 +
 sound/soc/codecs/cs35l56-sdw.c                     |  27 +-
 sound/soc/codecs/cs35l56-shared.c                  |  38 +++
 sound/soc/codecs/cs35l56.c                         |  17 ++
 sound/soc/codecs/cs35l56.h                         |   1 +
 sound/soc/codecs/hdac_hda.c                        |  25 +-
 sound/soc/codecs/tas2770.c                         |  14 +-
 sound/soc/qcom/qdsp6/q6apm.c                       |   6 +-
 sound/soc/qcom/qdsp6/q6prm.c                       |   3 +
 sound/soc/sof/intel/hda-codec.c                    |  23 +-
 sound/soc/sof/intel/hda-sdw-bpt.c                  |   6 +
 sound/usb/bcd2000/bcd2000.c                        |  20 +-
 sound/usb/caiaq/input.c                            |   2 +
 sound/usb/line6/capture.c                          |  29 +++
 sound/usb/midi.c                                   |  64 +++--
 sound/usb/qcom/qc_audio_offload.c                  |   7 +
 sound/usb/usx2y/us122l.c                           |  27 +-
 sound/usb/usx2y/usX2Yhwdep.c                       |   5 +
 sound/usb/usx2y/usb_stream.c                       |   9 +-
 sound/usb/usx2y/usbusx2yaudio.c                    |  43 +++-
 tools/perf/tests/tool_pmu.c                        |  79 ++++++
 tools/perf/util/evsel.c                            |  30 ++-
 tools/perf/util/hwmon_pmu.c                        |   2 +-
 tools/perf/util/tool_pmu.c                         |   2 +-
 .../filesystems/fscontext_ns/fscontext_ns_test.c   |   2 +-
 tools/testing/selftests/net/fib_nexthops.sh        |  40 ++-
 tools/testing/vma/include/dup.h                    |   2 +-
 tools/testing/vma/shared.c                         |   8 +-
 470 files changed, 7038 insertions(+), 2625 deletions(-)



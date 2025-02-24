Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D469D7F7FC;
	Mon, 24 Feb 2025 14:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740407871; cv=none; b=JA2JYmDQW9/wgMZ4F1TzJO+THqCwnNc60WyByi9/l7FmHMyEz4hE+pYj1Pch1n++3wvrvMrRQfArXs7OtwW6/G2T/2HcDlItKsAAisrcDTSyFxtRLAD/TB+QuVl5V/A7WaELCoquyu1rJ4Kjm1xUlELetZ7RBN9m78E+uPUHCbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740407871; c=relaxed/simple;
	bh=yBFiwKBLIZo2P/5ce+arK8ml6Mig/cud6czCqXQ8bx8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=VzUx/pORC/Yq1s57PJRl0Pnj9nOKd/RubtK4KYbeNkTs0QPvbbidJ5/UzD2d90xaFnG80V6E1tBGjWml8LfIiNINHwNTNQ+EkQMhsTiNlNXXdIa584EcnGPSYN/NCXvaNhHRSBU+3vuDlQEPBo6Mm6EfXMFEjS8WVivGny7kfqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fk2E3Qoj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fk2E3Qoj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C877BC4CED6;
	Mon, 24 Feb 2025 14:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740407871;
	bh=yBFiwKBLIZo2P/5ce+arK8ml6Mig/cud6czCqXQ8bx8=;
	h=From:To:Cc:Subject:Date:From;
	b=fk2E3QojLyWiwghpUUBWF/EmSWJtCsWSLJKN4ycf6faYWkB4Mus909JO+TyLLT0uh
	 ueXNup2M6FSe5hyMn/wqWkoHJq6hwF2uD5Dbe733gqyk0vb8d7zwyOZuY/x1FmSZ1r
	 Ikf0LiNhTRZhcEvHIc6f1u03zCp64yGHzut44A5o=
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
Subject: [PATCH 6.6 000/140] 6.6.80-rc1 review
Date: Mon, 24 Feb 2025 15:33:19 +0100
Message-ID: <20250224142602.998423469@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.80-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.80-rc1
X-KernelTest-Deadline: 2025-02-26T14:26+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.80 release.
There are 140 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 26 Feb 2025 14:25:29 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.80-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.80-rc1

Patrick Bellasi <derkling@google.com>
    x86/cpu/kvm: SRSO: Fix possible missing IBPB on VM-Exit

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: handle errors that nilfs_prepare_chunk() may return

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: eliminate staggered calls to kunmap in nilfs_rename

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: move page release outside of nilfs_delete_entry and nilfs_set_link

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel: Fix ARCH_PERFMON_NUM_COUNTER_LEAF

Tianling Shen <cnsztl@gmail.com>
    arm64: dts: rockchip: change eth phy mode to rgmii-id for orangepi r1 plus lts

Yu Kuai <yukuai3@huawei.com>
    md: Fix md_seq_ops() regressions

Yu Kuai <yukuai3@huawei.com>
    md: fix missing flush of sync_work

Cosmin Ratiu <cratiu@nvidia.com>
    net/mlx5e: Don't call cleanup on profile rollback failure

Steven Rostedt <rostedt@goodmis.org>
    ftrace: Do not add duplicate entries in subops manager ops

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    ftrace: Correct preemption accounting for function tracing.

Komal Bajaj <quic_kbajaj@quicinc.com>
    EDAC/qcom: Correct interrupt enable register configuration

Haoxiang Li <haoxiang_li2024@163.com>
    smb: client: Add check for next_buffer in receive_encrypted_standard()

Niravkumar L Rabara <niravkumar.l.rabara@intel.com>
    mtd: rawnand: cadence: fix incorrect device in dma_unmap_single

Niravkumar L Rabara <niravkumar.l.rabara@intel.com>
    mtd: rawnand: cadence: use dma_map_resource for sdma address

Niravkumar L Rabara <niravkumar.l.rabara@intel.com>
    mtd: rawnand: cadence: fix error code in cadence_nand_init()

Ricardo Cañuelo Navarro <rcn@igalia.com>
    mm,madvise,hugetlb: check for 0-length range after end address adjustment

Christian Brauner <brauner@kernel.org>
    acct: block access to kernel internal filesystems

Christian Brauner <brauner@kernel.org>
    acct: perform last write from workqueue

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: pcm: Clear the susbstream pointer to NULL on close

John Veness <john-linux@pelago.org.uk>
    ALSA: hda/conexant: Add quirk for HP ProBook 450 G4 mute LED

Wentao Liang <vulab@iscas.ac.cn>
    ALSA: hda: Add error check for snd_ctl_rename_id() in snd_hda_create_dig_out_ctls()

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    ASoC: fsl_micfil: Enable default case in micfil_set_quality()

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: stream-ipc: Check for cstream nullity in sof_ipc_msg_data()

Haoxiang Li <haoxiang_li2024@163.com>
    nfp: bpf: Add check for nfp_app_ctrl_msg_alloc()

Pavel Begunkov <asml.silence@gmail.com>
    lib/iov_iter: fix import_iovec_ubuf iovec management

Haoxiang Li <haoxiang_li2024@163.com>
    soc: loongson: loongson2_guts: Add check for devm_kstrdup()

Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
    drop_monitor: fix incorrect initialization order

Sumit Garg <sumit.garg@linaro.org>
    tee: optee: Fix supplicant wait loop

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: prevent opcode speculation

Imre Deak <imre.deak@intel.com>
    drm/i915/dp: Fix error handling during 128b/132b link training

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Make sure all planes in use by the joiner have their crtc included

Jessica Zhang <quic_jesszhan@quicinc.com>
    drm/msm/dpu: Disable dither in phys encoder cleanup

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mediatek: mt8183: Disable DSI display output by default

Aaron Kling <webgeek1234@gmail.com>
    drm/nouveau/pmu: Fix gp10b firmware guard

Yan Zhai <yan@cloudflare.com>
    bpf: skip non exist keys in generic_map_lookup_batch

Caleb Sander Mateos <csander@purestorage.com>
    nvme/ioctl: add missing space in err message

Rob Clark <robdclark@chromium.org>
    drm/msm: Avoid rounding up to one jiffy

David Hildenbrand <david@redhat.com>
    nouveau/svm: fix missing folio unlock + put after make_device_exclusive_range()

Andrey Vatoropin <a.vatoropin@crpt.ru>
    power: supply: da9150-fg: fix potential overflow

Abel Wu <wuyun.abel@bytedance.com>
    bpf: Fix deadlock when freeing cgroup storage

Jiayuan Chen <mrpre@163.com>
    bpf: Disable non stream socket for strparser

Jiayuan Chen <mrpre@163.com>
    bpf: Fix wrong copied_seq calculation

Jiayuan Chen <mrpre@163.com>
    strparser: Add read_sock callback

Andrii Nakryiko <andrii@kernel.org>
    bpf: avoid holding freeze_mutex during mmap operation

Andrii Nakryiko <andrii@kernel.org>
    bpf: unify VM_WRITE vs VM_MAYWRITE use in BPF map mmaping logic

Shigeru Yoshida <syoshida@redhat.com>
    bpf, test_run: Fix use-after-free issue in eth_skb_pkt_type()

Dan Carpenter <dan.carpenter@linaro.org>
    drm/msm/gem: prevent integer overflow in msm_ioctl_gem_submit()

Rob Clark <robdclark@chromium.org>
    drm/msm/gem: Demote userspace errors to DRM_UT_DRIVER

Devarsh Thakkar <devarsht@ti.com>
    drm/tidss: Fix race condition while handling interrupt registers

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    drm/tidss: Add simple K2G manual reset

Sabrina Dubroca <sd@queasysnail.net>
    tcp: drop secpath at the same time as we currently drop dst

Nick Hu <nick.hu@sifive.com>
    net: axienet: Set mac_managed_pm

Breno Leitao <leitao@debian.org>
    arp: switch to dev_getbyhwaddr() in arp_req_set_public()

Breno Leitao <leitao@debian.org>
    net: Add non-RCU dev_getbyhwaddr() helper

Cong Wang <xiyou.wangcong@gmail.com>
    flow_dissector: Fix port range key handling in BPF conversion

Cong Wang <xiyou.wangcong@gmail.com>
    flow_dissector: Fix handling of mixed port and port-range keys

Kuniyuki Iwashima <kuniyu@amazon.com>
    geneve: Suppress list corruption splat in geneve_destroy_tunnels().

Kuniyuki Iwashima <kuniyu@amazon.com>
    gtp: Suppress list corruption splat in gtp_net_exit_batch_rtnl().

Jakub Kicinski <kuba@kernel.org>
    tcp: adjust rcvq_space after updating scaling ratio

Michal Luczaj <mhal@rbox.co>
    vsock/bpf: Warn on socket without transport

Michal Luczaj <mhal@rbox.co>
    sockmap, vsock: For connectible sockets allow only connected

Nick Child <nnac123@linux.ibm.com>
    ibmvnic: Don't reference skb after sending to VIOS

Nick Child <nnac123@linux.ibm.com>
    ibmvnic: Add stat for tx direct vs tx batched

Nick Child <nnac123@linux.ibm.com>
    ibmvnic: Introduce send sub-crq direct

Nick Child <nnac123@linux.ibm.com>
    ibmvnic: Return error code on TX scrq flush fail

Julian Ruess <julianr@linux.ibm.com>
    s390/ism: add release function for struct device

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Drop UMP events when no UMP-conversion is set

Pierre Riteau <pierre@stackhpc.com>
    net/sched: cls_api: fix error handling causing NULL dereference

Vitaly Rodionov <vitalyr@opensource.cirrus.com>
    ALSA: hda/cirrus: Correct the full scale volume set logic

Kuniyuki Iwashima <kuniyu@amazon.com>
    geneve: Fix use-after-free in geneve_find_dev().

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/code-patching: Fix KASAN hit by not flagging text patching area as VM_ALLOC

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek: Fixup ALC225 depop procedure

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/64s: Rewrite __real_pte() and __rpte_to_hidx() as static inline

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/64s/mm: Move __real_pte stubs into hash-4k.h

John Keeping <jkeeping@inmusicbrands.com>
    ASoC: rockchip: i2s-tdm: fix shift config for SND_SOC_DAIFMT_DSP_[AB]

Jill Donahue <jilliandonahue58@gmail.com>
    USB: gadget: f_midi: f_midi_complete to call queue_work

Roy Luo <royluo@google.com>
    usb: gadget: core: flush gadget workqueue after device removal

Roy Luo <royluo@google.com>
    USB: gadget: core: create sysfs link between udc and gadget

Sascha Hauer <s.hauer@pengutronix.de>
    nvmem: imx-ocotp-ele: fix MAC address byte order

Miquel Raynal <miquel.raynal@bootlin.com>
    nvmem: Move and rename ->fixup_cell_info()

Miquel Raynal <miquel.raynal@bootlin.com>
    nvmem: Simplify the ->add_cells() hook

Miquel Raynal <miquel.raynal@bootlin.com>
    nvmem: Create a header for internal sharing

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Remove dangling pointers

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Only save async fh if success

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Refactor iterators

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    soc: mediatek: mtk-devapc: Fix leaking IO map on driver remove

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    soc/mediatek: mtk-devapc: Convert to platform remove callback returning void

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sm8550: Fix ADSP memory base and length

Neil Armstrong <neil.armstrong@linaro.org>
    arm64: dts: qcom: sm8550: add missing qcom,non-secure-domain property

Ling Xu <quic_lxu5@quicinc.com>
    arm64: dts: qcom: sm8550: Add dma-coherent property

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sm8450: Fix ADSP memory base and length

Neil Armstrong <neil.armstrong@linaro.org>
    arm64: dts: qcom: sm8450: add missing qcom,non-secure-domain property

Igor Pylypiv <ipylypiv@google.com>
    scsi: core: Do not retry I/Os during depopulation

Douglas Gilbert <dgilbert@interlog.com>
    scsi: core: Handle depopulation and restoration in progress

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    firmware: qcom: scm: Fix missing read barrier in qcom_scm_is_available()

Dan Carpenter <dan.carpenter@linaro.org>
    ASoC: renesas: rz-ssi: Add a check for negative sample_space

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: synaptics - fix crash when enabling pass-through port

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: serio - define serio_pause_rx guard to pause and resume serio ports

Zijun Hu <quic_zijuhu@quicinc.com>
    Bluetooth: qca: Fix poor RF performance for WCN6855

Cheng Jiang <quic_chejiang@quicinc.com>
    Bluetooth: qca: Update firmware-name to support board specific nvm

Zijun Hu <quic_zijuhu@quicinc.com>
    Bluetooth: qca: Support downloading board id specific NVM for WCN7850

Andreas Kemnade <andreas@kemnade.info>
    cpufreq: fix using cpufreq-dt as module

Jeff Johnson <quic_jjohnson@quicinc.com>
    cpufreq: dt-platdev: add missing MODULE_DESCRIPTION() macro

Chen Ridong <chenridong@huawei.com>
    memcg: fix soft lockup in the OOM process

Carlos Galo <carlosgalo@google.com>
    mm: update mark_victim tracepoints fields

Yu Kuai <yukuai3@huawei.com>
    md/md-bitmap: Synchronize bitmap_get_stats() with bitmap lifetime

Yu Kuai <yukuai3@huawei.com>
    md/md-bitmap: add 'sync_size' into struct md_bitmap_stats

Yu Kuai <yukuai3@huawei.com>
    md/md-cluster: fix spares warnings for __le64

Yu Kuai <yukuai3@huawei.com>
    md/md-bitmap: replace md_bitmap_status() with a new helper md_bitmap_get_stats()

Yu Kuai <yukuai3@huawei.com>
    md: simplify md_seq_ops

Yu Kuai <yukuai3@huawei.com>
    md: factor out a helper from mddev_put()

Yu Kuai <yukuai3@huawei.com>
    md: use separate work_struct for md_start_sync()

Darrick J. Wong <djwong@kernel.org>
    xfs: don't over-report free space or inodes in statvfs

Darrick J. Wong <djwong@kernel.org>
    xfs: report realtime block quota limits on realtime directories

Ojaswin Mujoo <ojaswin@linux.ibm.com>
    xfs: Check for delayed allocations before setting extsize

Christoph Hellwig <hch@lst.de>
    xfs: streamline xfs_filestream_pick_ag

Chi Zhiling <chizhiling@kylinos.cn>
    xfs: Reduce unnecessary searches when searching for the best extents

Christoph Hellwig <hch@lst.de>
    xfs: update the pag for the last AG at recovery time

Christoph Hellwig <hch@lst.de>
    xfs: don't use __GFP_RETRY_MAYFAIL in xfs_initialize_perag

Christoph Hellwig <hch@lst.de>
    xfs: error out when a superblock buffer update reduces the agcount

Christoph Hellwig <hch@lst.de>
    xfs: update the file system geometry after recoverying superblock buffers

Christoph Hellwig <hch@lst.de>
    xfs: pass the exact range to initialize to xfs_initialize_perag

Zhang Zekun <zhangzekun11@huawei.com>
    xfs: Remove empty declartion in header file

Uros Bizjak <ubizjak@gmail.com>
    xfs: Use try_cmpxchg() in xlog_cil_insert_pcp_aggregate()

Christoph Hellwig <hch@lst.de>
    xfs: support lowmode allocations in xfs_bmap_exact_minlen_extent_alloc

Christoph Hellwig <hch@lst.de>
    xfs: call xfs_bmap_exact_minlen_extent_alloc from xfs_bmap_btalloc

Christoph Hellwig <hch@lst.de>
    xfs: don't ifdef around the exact minlen allocations

Christoph Hellwig <hch@lst.de>
    xfs: fold xfs_bmap_alloc_userdata into xfs_bmapi_allocate

Christoph Hellwig <hch@lst.de>
    xfs: distinguish extra split from real ENOSPC from xfs_attr_node_try_addname

Christoph Hellwig <hch@lst.de>
    xfs: distinguish extra split from real ENOSPC from xfs_attr3_leaf_split

Christoph Hellwig <hch@lst.de>
    xfs: return bool from xfs_attr3_leaf_add

Christoph Hellwig <hch@lst.de>
    xfs: merge xfs_attr_leaf_try_add into xfs_attr_leaf_addname

Brian Foster <bfoster@redhat.com>
    xfs: don't free cowblocks from under dirty pagecache on unshare

Brian Foster <bfoster@redhat.com>
    xfs: skip background cowblock trims on inodes open for write

Andrew Kreimer <algonell@gmail.com>
    xfs: fix a typo

Darrick J. Wong <djwong@kernel.org>
    xfs: fix a sloppy memory handling bug in xfs_iroot_realloc

Darrick J. Wong <djwong@kernel.org>
    xfs: validate inumber in xfs_iget

Christoph Hellwig <hch@lst.de>
    xfs: assert a valid limit in xfs_rtfind_forw

Catalin Marinas <catalin.marinas@arm.com>
    arm64: mte: Do not allow PROT_MTE on MAP_HUGETLB user mappings


-------------

Diffstat:

 Documentation/networking/strparser.rst             |   9 +-
 Makefile                                           |   4 +-
 arch/arm64/boot/dts/mediatek/mt8183.dtsi           |   1 +
 arch/arm64/boot/dts/qcom/sm8450.dtsi               | 213 +++++++++--------
 arch/arm64/boot/dts/qcom/sm8550.dtsi               | 265 +++++++++++----------
 .../dts/rockchip/rk3328-orangepi-r1-plus-lts.dts   |   6 +-
 arch/arm64/include/asm/mman.h                      |   9 +-
 arch/powerpc/include/asm/book3s/64/hash-4k.h       |  28 +++
 arch/powerpc/include/asm/book3s/64/pgtable.h       |  26 --
 arch/powerpc/lib/code-patching.c                   |   2 +-
 arch/x86/Kconfig                                   |   3 +-
 arch/x86/events/intel/core.c                       |  17 +-
 arch/x86/include/asm/perf_event.h                  |  26 +-
 arch/x86/kernel/cpu/bugs.c                         |  21 +-
 drivers/bluetooth/btqca.c                          | 110 +++++++--
 drivers/cpufreq/Kconfig                            |   2 +-
 drivers/cpufreq/cpufreq-dt-platdev.c               |   1 -
 drivers/edac/qcom_edac.c                           |   4 +-
 drivers/firmware/qcom_scm.c                        |   5 +-
 drivers/gpu/drm/i915/display/intel_display.c       |  18 ++
 .../gpu/drm/i915/display/intel_dp_link_training.c  |  15 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c        |   3 +
 drivers/gpu/drm/msm/msm_drv.h                      |  11 +-
 drivers/gpu/drm/msm/msm_gem.c                      |   6 +-
 drivers/gpu/drm/msm/msm_gem_submit.c               |  39 +--
 drivers/gpu/drm/nouveau/nouveau_svm.c              |   9 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gp10b.c    |   2 +-
 drivers/gpu/drm/tidss/tidss_dispc.c                |  22 +-
 drivers/gpu/drm/tidss/tidss_irq.c                  |   2 +
 drivers/input/mouse/synaptics.c                    |  56 +++--
 drivers/input/mouse/synaptics.h                    |   1 +
 drivers/md/md-bitmap.c                             |  34 ++-
 drivers/md/md-bitmap.h                             |   9 +-
 drivers/md/md-cluster.c                            |  34 +--
 drivers/md/md.c                                    | 191 ++++++++-------
 drivers/md/md.h                                    |   5 +-
 drivers/media/usb/uvc/uvc_ctrl.c                   |  99 ++++++--
 drivers/media/usb/uvc/uvc_v4l2.c                   |   2 +
 drivers/media/usb/uvc/uvcvideo.h                   |   9 +-
 drivers/mtd/nand/raw/cadence-nand-controller.c     |  42 +++-
 drivers/net/ethernet/ibm/ibmvnic.c                 |  85 +++++--
 drivers/net/ethernet/ibm/ibmvnic.h                 |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   4 +-
 drivers/net/ethernet/netronome/nfp/bpf/cmsg.c      |   2 +
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |   1 +
 drivers/net/geneve.c                               |  16 +-
 drivers/net/gtp.c                                  |   5 -
 drivers/nvme/host/ioctl.c                          |   3 +-
 drivers/nvmem/core.c                               |  32 +--
 drivers/nvmem/imx-ocotp-ele.c                      |  22 ++
 drivers/nvmem/imx-ocotp.c                          |  11 +-
 drivers/nvmem/internals.h                          |  37 +++
 drivers/nvmem/layouts/onie-tlv.c                   |   3 +-
 drivers/nvmem/layouts/sl28vpd.c                    |   3 +-
 drivers/nvmem/mtk-efuse.c                          |  11 +-
 drivers/power/supply/da9150-fg.c                   |   4 +-
 drivers/s390/net/ism_drv.c                         |  14 +-
 drivers/scsi/scsi_lib.c                            |   8 +-
 drivers/scsi/sd.c                                  |   4 +
 drivers/soc/loongson/loongson2_guts.c              |   5 +-
 drivers/soc/mediatek/mtk-devapc.c                  |   7 +-
 drivers/tee/optee/supp.c                           |  35 +--
 drivers/usb/gadget/function/f_midi.c               |   2 +-
 drivers/usb/gadget/udc/core.c                      |  11 +-
 fs/nilfs2/dir.c                                    |  24 +-
 fs/nilfs2/namei.c                                  |  37 +--
 fs/nilfs2/nilfs.h                                  |  10 +-
 fs/smb/client/smb2ops.c                            |   4 +
 fs/xfs/libxfs/xfs_ag.c                             |  47 ++--
 fs/xfs/libxfs/xfs_ag.h                             |   6 +-
 fs/xfs/libxfs/xfs_alloc.c                          |   9 +-
 fs/xfs/libxfs/xfs_alloc.h                          |   4 +-
 fs/xfs/libxfs/xfs_attr.c                           | 198 +++++++--------
 fs/xfs/libxfs/xfs_attr_leaf.c                      |  40 ++--
 fs/xfs/libxfs/xfs_attr_leaf.h                      |   2 +-
 fs/xfs/libxfs/xfs_bmap.c                           | 140 ++++-------
 fs/xfs/libxfs/xfs_da_btree.c                       |   5 +-
 fs/xfs/libxfs/xfs_inode_fork.c                     |  10 +-
 fs/xfs/libxfs/xfs_rtbitmap.c                       |   2 +
 fs/xfs/xfs_buf_item_recover.c                      |  70 ++++++
 fs/xfs/xfs_filestream.c                            | 102 ++++----
 fs/xfs/xfs_fsops.c                                 |  18 +-
 fs/xfs/xfs_icache.c                                |  39 +--
 fs/xfs/xfs_inode.c                                 |   2 +-
 fs/xfs/xfs_inode.h                                 |   5 +
 fs/xfs/xfs_ioctl.c                                 |   4 +-
 fs/xfs/xfs_log.h                                   |   1 -
 fs/xfs/xfs_log_cil.c                               |  11 +-
 fs/xfs/xfs_log_recover.c                           |   9 +-
 fs/xfs/xfs_mount.c                                 |   4 +-
 fs/xfs/xfs_qm_bhv.c                                |  41 ++--
 fs/xfs/xfs_reflink.c                               |   3 +
 fs/xfs/xfs_reflink.h                               |  19 ++
 fs/xfs/xfs_super.c                                 |  11 +-
 include/linux/netdevice.h                          |   2 +
 include/linux/nvmem-provider.h                     |  17 +-
 include/linux/serio.h                              |   3 +
 include/linux/skmsg.h                              |   2 +
 include/net/strparser.h                            |   2 +
 include/net/tcp.h                                  |  22 ++
 include/trace/events/oom.h                         |  36 ++-
 io_uring/io_uring.c                                |   2 +
 kernel/acct.c                                      | 134 +++++++----
 kernel/bpf/bpf_cgrp_storage.c                      |   2 +-
 kernel/bpf/ringbuf.c                               |   4 -
 kernel/bpf/syscall.c                               |  43 ++--
 kernel/trace/ftrace.c                              |   3 +
 kernel/trace/trace_functions.c                     |   6 +-
 lib/iov_iter.c                                     |   3 +-
 mm/madvise.c                                       |  11 +-
 mm/memcontrol.c                                    |   7 +-
 mm/oom_kill.c                                      |  14 +-
 net/bpf/test_run.c                                 |   5 +-
 net/core/dev.c                                     |  37 ++-
 net/core/drop_monitor.c                            |  39 ++-
 net/core/flow_dissector.c                          |  49 ++--
 net/core/skmsg.c                                   |   7 +
 net/core/sock_map.c                                |   8 +-
 net/ipv4/arp.c                                     |   2 +-
 net/ipv4/tcp.c                                     |  29 ++-
 net/ipv4/tcp_bpf.c                                 |  36 +++
 net/ipv4/tcp_fastopen.c                            |   4 +-
 net/ipv4/tcp_input.c                               |  20 +-
 net/ipv4/tcp_ipv4.c                                |   2 +-
 net/sched/cls_api.c                                |   2 +-
 net/strparser/strparser.c                          |  11 +-
 net/vmw_vsock/af_vsock.c                           |   3 +
 net/vmw_vsock/vsock_bpf.c                          |   2 +-
 sound/core/seq/seq_clientmgr.c                     |  12 +-
 sound/pci/hda/hda_codec.c                          |   4 +-
 sound/pci/hda/patch_conexant.c                     |   1 +
 sound/pci/hda/patch_cs8409-tables.c                |   6 +-
 sound/pci/hda/patch_cs8409.c                       |  20 +-
 sound/pci/hda/patch_cs8409.h                       |   5 +-
 sound/pci/hda/patch_realtek.c                      |   1 +
 sound/soc/fsl/fsl_micfil.c                         |   2 +
 sound/soc/rockchip/rockchip_i2s_tdm.c              |   4 +-
 sound/soc/sh/rz-ssi.c                              |   2 +
 sound/soc/sof/pcm.c                                |   2 +
 sound/soc/sof/stream-ipc.c                         |   6 +-
 140 files changed, 1951 insertions(+), 1249 deletions(-)



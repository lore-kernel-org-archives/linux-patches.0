Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B1E2E54A0;
	Tue,  8 Jul 2025 16:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751991834; cv=none; b=cKVKrQsZJUkBu4WVEgFOMtBthLBzuxRJU2mXnkH/BkoxGM8yxdxEDUzu557Z1J5E2peIg9/e/z/25wIPwGyJDpxhhLXuZGJe90p8PnjCNKl8Bfygy4O+KXaqiJ6RU7YOf5Ftyq4AtJeK8GiaysnBym46IDsC0dIbtHGMmhCBt0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751991834; c=relaxed/simple;
	bh=w7tr3EvUTzGk9zC2K5jwM6BmYpAPbqwLnynnYZEc2JY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=jTmMF6kuSK5TZuVVsjAacx7wQnbVsdjw9V4sOFylpbZMsY8d4OspBS8Ycqg7ZTGz83KdRZ3qa3Gh/7pl9xRR2Q/ecenN55+uaprmCswvnsDPRFWwHmbMdQ9UaoGioAUcdx00pG0dG78WS4rPmSC0kbBt3m5W7HAy4tYwQDGSru4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QsZIyYLH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QsZIyYLH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E51A9C4AF09;
	Tue,  8 Jul 2025 16:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751991833;
	bh=w7tr3EvUTzGk9zC2K5jwM6BmYpAPbqwLnynnYZEc2JY=;
	h=From:To:Cc:Subject:Date:From;
	b=QsZIyYLHGPdtNyMq3D5o9Z366IEOu5snrkS6YKsq41BpcHox3GZN7NHl7Ixcwrlkv
	 623GIqou0dtnlKd4w2sJauAqieLkEfYe3SOltIatKSnU7dMyo2P6Ff+QAHKmMWkEFk
	 yO3qn5gifECouXhiPhHrCvYY8+mvzsOy2JyCVPUY=
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
Subject: [PATCH 6.12 000/232] 6.12.37-rc1 review
Date: Tue,  8 Jul 2025 18:19:56 +0200
Message-ID: <20250708162241.426806072@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.37-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.12.37-rc1
X-KernelTest-Deadline: 2025-07-10T16:22+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.12.37 release.
There are 232 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 10 Jul 2025 16:22:09 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.37-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.12.37-rc1

Borislav Petkov (AMD) <bp@alien8.de>
    x86/process: Move the buffer clearing before MONITOR

Borislav Petkov (AMD) <bp@alien8.de>
    x86/microcode/AMD: Add TSA microcode SHAs

Borislav Petkov (AMD) <bp@alien8.de>
    KVM: SVM: Advertise TSA CPUID bits to guests

Borislav Petkov (AMD) <bp@alien8.de>
    x86/bugs: Add a Transient Scheduler Attacks mitigation

Borislav Petkov (AMD) <bp@alien8.de>
    x86/bugs: Rename MDS machinery to something more generic

Kairui Song <kasong@tencent.com>
    mm: userfaultfd: fix race of userfaultfd_move and swap cache

Jeongjun Park <aha310510@gmail.com>
    mm/vmalloc: fix data race in show_numa_info()

Madhavan Srinivasan <maddy@linux.ibm.com>
    powerpc/kernel: Fix ppc_save_regs inclusion in build

Andrei Kuchynski <akuchynski@chromium.org>
    usb: typec: displayport: Fix potential deadlock

Kurt Borja <kuurtb@gmail.com>
    platform/x86: think-lmi: Fix sysfs group cleanup

Kurt Borja <kuurtb@gmail.com>
    platform/x86: think-lmi: Fix kobject cleanup

Kurt Borja <kuurtb@gmail.com>
    platform/x86: think-lmi: Create ksets consecutively

Vivian Wang <wangruikang@iscas.ac.cn>
    riscv: cpu_ops_sbi: Use static array for boot_data

Zhang Rui <rui.zhang@intel.com>
    powercap: intel_rapl: Do not change CLAMPING bit if ENABLE bit cannot be changed

Simon Xue <xxm@rock-chips.com>
    iommu/rockchip: prevent iommus dead loop when two masters share one IOMMU

Jens Wiklander <jens.wiklander@linaro.org>
    optee: ffa: fix sleep in atomic context

Oliver Neukum <oneukum@suse.com>
    Logitech C-270 even more broken

Michael J. Ruhl <michael.j.ruhl@intel.com>
    i2c/designware: Fix an initialization issue

Christian König <christian.koenig@amd.com>
    dma-buf: fix timeout handling in dma_resv_wait_timeout v2

Shyam Prasad N <sprasad@microsoft.com>
    cifs: all initializations for tcon should happen in tcon_info_alloc

Philipp Kerling <pkerling@casix.org>
    smb: client: fix readdir returning wrong type with POSIX extensions

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    usb: acpi: fix device link removal

Xu Yang <xu.yang_2@nxp.com>
    usb: chipidea: udc: disconnect/reconnect from host when do suspend/resume

Kuen-Han Tsai <khtsai@google.com>
    usb: dwc3: Abort suspend on soft disconnect failure

Pawel Laszczak <pawell@cadence.com>
    usb: cdnsp: Fix issue with CV Bad Descriptor test

Peter Chen <peter.chen@cixtech.com>
    usb: cdnsp: do not disable slot for disabled slot

Jeff LaBundy <jeff@labundy.com>
    Input: iqs7222 - explicitly define number of external channels

Nilton Perim Neto <niltonperimneto@gmail.com>
    Input: xpad - support Acer NGR 200 Controller

Hongyu Xie <xiehongyu1@kylinos.cn>
    xhci: Disable stream for xHC controller with XHCI_BROKEN_STREAMS

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: dbc: Flush queued requests before stopping dbc

Łukasz Bartosik <ukaszb@chromium.org>
    xhci: dbctty: disable ECHO flag by default

Raju Rangoju <Raju.Rangoju@amd.com>
    usb: xhci: quirk for data loss in ISOC transfers

Roy Luo <royluo@google.com>
    Revert "usb: xhci: Implement xhci_handshake_check_state() helper"

Roy Luo <royluo@google.com>
    usb: xhci: Skip xhci_reset in xhci_resume if xhci is being removed

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4/flexfiles: Fix handling of NFS level errors in I/O

Harry Austen <hpausten@protonmail.com>
    drm/xe: Allow dropping kunit dependency as built-in

Vinay Belgaumkar <vinay.belgaumkar@intel.com>
    drm/xe/bmg: Update Wa_22019338487

Or Har-Toov <ohartoov@nvidia.com>
    IB/mlx5: Fix potential deadlock in MR deregistration

Michael Guralnik <michaelgur@nvidia.com>
    RDMA/mlx5: Fix cache entry update on dereg error

Shivank Garg <shivankg@amd.com>
    fs: export anon_inode_make_secure_inode() and fix secretmem LSM bypass

Peter Zijlstra <peterz@infradead.org>
    module: Provide EXPORT_SYMBOL_GPL_FOR_MODULES() helper

Al Viro <viro@zeniv.linux.org.uk>
    add a string-to-qstr constructor

Sudeep Holla <sudeep.holla@arm.com>
    firmware: arm_ffa: Replace mutex with rwlock to avoid sleep in atomic context

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

Justin Sanders <jsanders.devel@gmail.com>
    aoe: defer rexmit timer downdev work to workqueue

Maurizio Lombardi <mlombard@redhat.com>
    scsi: target: Fix NULL pointer dereference in core_scsi3_decode_spec_i_port()

Heiko Stuebner <heiko@sntech.de>
    regulator: fan53555: add enable_time support and soft-start times

Raven Black <ravenblack@gmail.com>
    ASoC: amd: yc: update quirk data for HP Victus

Madhavan Srinivasan <maddy@linux.ibm.com>
    powerpc: Fix struct termio related ioctl macros

Gyeyoung Baek <gye976@gmail.com>
    genirq/irq_sim: Initialize work context pointers properly

Mario Limonciello <mario.limonciello@amd.com>
    platform/x86/amd/pmc: Add PCSpecialist Lafite Pro V 14M to 8042 quirks list

Gabriel Santese <santesegabriel@gmail.com>
    ASoC: amd: yc: Add quirk for MSI Bravo 17 D7VF internal mic

Johannes Berg <johannes.berg@intel.com>
    ata: pata_cs5536: fix build on 32-bit UML

Tasos Sahanidis <tasos@tasossah.com>
    ata: libata-acpi: Do not assume 40 wire cable if no devices are enabled

Takashi Iwai <tiwai@suse.de>
    ALSA: sb: Force to disable DMAs once when DMA mode is changed

Takashi Iwai <tiwai@suse.de>
    ALSA: sb: Don't allow changing the DMA mode during operations

Rob Clark <robdclark@chromium.org>
    drm/msm: Fix another leak in the submit error path

Rob Clark <robdclark@chromium.org>
    drm/msm: Fix a fence leak in submit error path

Ewan D. Milne <emilne@redhat.com>
    scsi: lpfc: Restore clearing of NLP_UNREG_INP in ndlp->nlp_flag

Tejun Heo <tj@kernel.org>
    sched_ext: Make scx_group_set_weight() always update tg->scx.weight

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/mes: add missing locking in helper functions

Johan Hovold <johan+linaro@kernel.org>
    arm64: dts: qcom: x1e80100-crd: mark l12b and l15b always-on

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Add more checks for DSC / HUBP ONO guarantees

Frank Min <Frank.Min@amd.com>
    drm/amdgpu: add kicker fws loading for gfx11/smu13/psp13

Imre Deak <imre.deak@intel.com>
    drm/i915/dp_mst: Work around Thunderbolt sink disconnect after SINK_COUNT_ESI read

Sonny Jiang <sonny.jiang@amd.com>
    drm/amdgpu: VCN v5_0_1 to prevent FW checking RB during DPG pause

Thomas Zimmermann <tzimmermann@suse.de>
    drm/simpledrm: Do not upcast in release helpers

Stephen Smalley <stephen.smalley.work@gmail.com>
    selinux: change security_compute_sid to return the ssid or tsid on match

Michal Wajdeczko <michal.wajdeczko@intel.com>
    drm/xe/guc: Explicitly exit CT safe mode on unwind

John Harrison <John.C.Harrison@Intel.com>
    drm/xe/guc: Dead CT helper

Nitin Gote <nitin.r.gote@intel.com>
    drm/xe: Replace double space with single space after comma

Matthew Auld <matthew.auld@intel.com>
    drm/xe: move DPT l2 flush to a more sensible place

Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>
    drm/xe: Allow bo mapping on multiple ggtts

Juha-Pekka Heikkila <juhapekka.heikkila@gmail.com>
    drm/xe: add interface to request physical alignment for buffer objects

Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
    drm/xe: Move DSB l2 flush to a more sensible place

Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
    drm/xe: Fix DSB buffer coherency

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mfd: exynos-lpass: Fix another error handling path in exynos_lpass_probe()

David Howells <dhowells@redhat.com>
    netfs: Fix oops in write-retry from mis-resetting the subreq iterator

Beleswar Padhi <b-padhi@ti.com>
    remoteproc: k3-r5: Refactor sequential core power up/down operations

Beleswar Padhi <b-padhi@ti.com>
    remoteproc: k3-r5: Use devm_rproc_add() helper

Beleswar Padhi <b-padhi@ti.com>
    remoteproc: k3-r5: Use devm_ioremap_wc() helper

Beleswar Padhi <b-padhi@ti.com>
    remoteproc: k3-r5: Use devm_kcalloc() helper

Beleswar Padhi <b-padhi@ti.com>
    remoteproc: k3-r5: Add devm action to release reserved memory

Markus Elfring <elfring@users.sourceforge.net>
    remoteproc: k3: Call of_node_put(rmem_np) only once in three functions

Kees Cook <kees@kernel.org>
    ubsan: integer-overflow: depend on BROKEN to keep this out of CI

Pengyu Luo <mitltlatltl@gmail.com>
    arm64: dts: qcom: sm8650: add the missing l2 cache node

Geert Uytterhoeven <geert+renesas@glider.be>
    arm64: dts: renesas: white-hawk-single: Improve Ethernet TSN description

Geert Uytterhoeven <geert+renesas@glider.be>
    arm64: dts: renesas: Factor out White Hawk Single board support

Geert Uytterhoeven <geert+renesas@glider.be>
    arm64: dts: renesas: Use interrupts-extended for Ethernet PHYs

Luca Weiss <luca.weiss@fairphone.com>
    arm64: dts: qcom: sm8650: Fix domain-idle-state for CPU2

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sm8650: change labels to lower-case

Yonghong Song <yonghong.song@linux.dev>
    bpf: Do not include stack ptr register in precision backtracking bookkeeping

Andrii Nakryiko <andrii@kernel.org>
    bpf: use common instruction history across all states

Longfang Liu <liulongfang@huawei.com>
    hisi_acc_vfio_pci: bugfix the problem of uninstalling driver

Longfang Liu <liulongfang@huawei.com>
    hisi_acc_vfio_pci: bugfix cache write-back issue

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Avoid potential ndlp use-after-free in dev_loss_tmo_callbk

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Change lpfc_nodelist nlp_flag member into a bitmask

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Remove NLP_RELEASE_RPI flag from nodelist structure

Chao Yu <chao@kernel.org>
    f2fs: zone: fix to calculate first_zoned_segno correctly

Chao Yu <chao@kernel.org>
    f2fs: zone: introduce first_zoned_segno in f2fs_sb_info

Daeho Jeong <daehojeong@google.com>
    f2fs: decrease spare area for pinned files for zoned devices

Arnd Bergmann <arnd@arndb.de>
    iommu: ipmmu-vmsa: avoid Wformat-security warning

Zhu Yanjun <yanjun.zhu@linux.dev>
    RDMA/rxe: Fix "trying to register non-static key in rxe_qp_do_cleanup" bug

Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
    wifi: ath12k: fix wrong handling of CCMP256 and GCMP ciphers

P Praneesh <praneesh.p@oss.qualcomm.com>
    wifi: ath12k: Handle error cases during extended skb allocation

Nicolas Escande <nico.escande@gmail.com>
    wifi: ath12k: fix skb_ext_desc leak in ath12k_dp_tx() error path

Cosmin Ratiu <cratiu@nvidia.com>
    bonding: Mark active offloaded xfrm_states

Armin Wolf <W_Armin@gmx.de>
    ACPI: thermal: Execute _SCP before reading trip points

xueqin Luo <luoxueqin@kylinos.cn>
    ACPI: thermal: Fix stale comment regarding trip points

Martin Povišer <povik+lin@cutebit.org>
    ASoC: tas2764: Reinit cache on part reset

Martin Povišer <povik+lin@cutebit.org>
    ASoC: tas2764: Extend driver to SN012776

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Don't start unnecessary transactions during log flush

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Move gfs2_trans_add_databufs

Xuewen Yan <xuewen.yan@unisoc.com>
    sched/fair: Fixup wake_up_sync() vs DELAYED_DEQUEUE

Vincent Guittot <vincent.guittot@linaro.org>
    sched/fair: Add new cfs_rq.h_nr_runnable

Vincent Guittot <vincent.guittot@linaro.org>
    sched/fair: Rename h_nr_running into h_nr_queued

Filipe Manana <fdmanana@suse.com>
    btrfs: fix wrong start offset for delalloc space release during mmap write

Qu Wenruo <wqu@suse.com>
    btrfs: prepare btrfs_page_mkwrite() for large folios

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: deallocate inodes in gfs2_create_inode

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Move GIF_ALLOC_FAILED check out of gfs2_ea_dealloc

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Move gfs2_dinode_dealloc

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Replace GIF_DEFER_DELETE with GLF_DEFER_DELETE

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Add GLF_PENDING_REPLY flag

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Decode missing glock flags in tracepoints

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Prevent inode creation race

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Rename dinode_demise to evict_behavior

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Rename GIF_{DEFERRED -> DEFER}_DELETE

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Initialize gl_no_formal_ino earlier

David Gow <davidgow@google.com>
    kunit: qemu_configs: Disable faulting tests on 32-bit SPARC

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    kunit: qemu_configs: sparc: Explicitly enable CONFIG_SPARC32=y

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    kunit: qemu_configs: sparc: use Zilog console

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: zynqmp-sha - Add locking

Christian Marangi <ansuelsmth@gmail.com>
    spinlock: extend guard with spinlock_bh variants

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: iaa - Do not clobber req->base.data

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: iaa - Remove dst_null support

Lukasz Czechowski <lukasz.czechowski@thaumatec.com>
    arm64: dts: rockchip: fix internal USB hub instability on RK3399 Puma

Wang Zhaolong <wangzhaolong@huaweicloud.com>
    smb: client: fix race condition in negotiate timeout by using more precise timing

Raju Rangoju <Raju.Rangoju@amd.com>
    amd-xgbe: do not double read link status

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

David Howells <dhowells@redhat.com>
    netfs: Fix i_size updating

Paulo Alcantara <pc@manguebit.org>
    smb: client: set missing retry flag in cifs_writev_callback()

Paulo Alcantara <pc@manguebit.org>
    smb: client: set missing retry flag in cifs_readv_callback()

Paulo Alcantara <pc@manguebit.org>
    smb: client: set missing retry flag in smb2_writev_callback()

Vitaly Lifshits <vitaly.lifshits@intel.com>
    igc: disable L1.2 PCI-E link substate to avoid performance issue

Ahmed Zaki <ahmed.zaki@intel.com>
    idpf: convert control queue mutex to a spinlock

Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
    idpf: return 0 size for RSS key if not supported

Junxiao Chang <junxiao.chang@intel.com>
    drm/i915/gsc: mei interrupt top half should be in irq disabled context

Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
    drm/i915/gt: Fix timeline left held on VMA alloc error

Oleksij Rempel <o.rempel@pengutronix.de>
    net: usb: lan78xx: fix WARN in __netif_napi_del_locked on disconnect

Paulo Alcantara <pc@manguebit.org>
    smb: client: fix warning when reconnecting channel

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    drm/bridge: aux-hpd-bridge: fix assignment of the of_node

Alok Tiwari <alok.a.tiwari@oracle.com>
    platform/mellanox: mlxreg-lc: Fix logic error in power state check

Kurt Borja <kuurtb@gmail.com>
    platform/x86: dell-wmi-sysman: Fix class device unregistration

Thomas Weißschuh <linux@weissschuh.net>
    platform/x86: dell-sysman: Directly use firmware_attributes_class

Kurt Borja <kuurtb@gmail.com>
    platform/x86: think-lmi: Fix class device unregistration

Thomas Weißschuh <linux@weissschuh.net>
    platform/x86: think-lmi: Directly use firmware_attributes_class

Thomas Weißschuh <linux@weissschuh.net>
    platform/x86: firmware_attributes_class: Simplify API

Thomas Weißschuh <linux@weissschuh.net>
    platform/x86: firmware_attributes_class: Move include linux/device/class.h

Kurt Borja <kuurtb@gmail.com>
    platform/x86: hp-bioscfg: Fix class device unregistration

Thomas Weißschuh <linux@weissschuh.net>
    platform/x86: hp-bioscfg: Directly use firmware_attributes_class

Kurt Borja <kuurtb@gmail.com>
    platform/x86: dell-wmi-sysman: Fix WMI data block retrieval in sysfs callbacks

Dmitry Bogdanov <d.bogdanov@yadro.com>
    nvmet: fix memory leak of bio integrity

Alok Tiwari <alok.a.tiwari@oracle.com>
    nvme: Fix incorrect cdw15 value in passthru error logging

Dan Carpenter <dan.carpenter@linaro.org>
    drm/i915/selftests: Change mock_request() to return error pointers

James Clark <james.clark@linaro.org>
    spi: spi-fsl-dspi: Clear completion counter before initiating transfer

Marek Szyprowski <m.szyprowski@samsung.com>
    drm/exynos: fimd: Guard display clock control with runtime PM calls

Fushuai Wang <wangfushuai@baidu.com>
    dpaa2-eth: fix xdp_rxq_info leak

Thomas Fourier <fourier.thomas@gmail.com>
    ethernet: atl1: Add missing DMA mapping error checks and count errors

Filipe Manana <fdmanana@suse.com>
    btrfs: use btrfs_record_snapshot_destroy() during rmdir

Filipe Manana <fdmanana@suse.com>
    btrfs: propagate last_unlink_trans earlier when doing a rmdir

Filipe Manana <fdmanana@suse.com>
    btrfs: record new subvolume in parent dir earlier to avoid dir logging races

Filipe Manana <fdmanana@suse.com>
    btrfs: fix inode lookup error handling during log replay

Filipe Manana <fdmanana@suse.com>
    btrfs: fix invalid inode pointer dereferences during log replay

Filipe Manana <fdmanana@suse.com>
    btrfs: return a btrfs_inode from read_one_inode()

Filipe Manana <fdmanana@suse.com>
    btrfs: return a btrfs_inode from btrfs_iget_logging()

Filipe Manana <fdmanana@suse.com>
    btrfs: fix iteration of extrefs during log replay

Filipe Manana <fdmanana@suse.com>
    btrfs: fix missing error handling when searching for inode refs during log replay

Yang Li <yang.li@amlogic.com>
    Bluetooth: Prevent unintended pause by checking if advertising is active

Alok Tiwari <alok.a.tiwari@oracle.com>
    platform/mellanox: nvsw-sn2201: Fix bus number in adapter error message

Alok Tiwari <alok.a.tiwari@oracle.com>
    platform/mellanox: mlxbf-pmc: Fix duplicate event ID for CACHE_DATA1

Patrisious Haddad <phaddad@nvidia.com>
    RDMA/mlx5: Fix vport loopback for MPV device

Patrisious Haddad <phaddad@nvidia.com>
    RDMA/mlx5: Fix CC counters query for MPV

Patrisious Haddad <phaddad@nvidia.com>
    RDMA/mlx5: Fix HW counters query for non-representor devices

Bart Van Assche <bvanassche@acm.org>
    scsi: ufs: core: Fix spelling of a sysfs attribute name

jackysliu <1972843537@qq.com>
    scsi: sd: Fix VPD page 0xb7 length check

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

Or Har-Toov <ohartoov@nvidia.com>
    RDMA/mlx5: Fix unsafe xarray access in implicit ODP handling

David Thompson <davthompson@nvidia.com>
    platform/mellanox: mlxbf-tmfifo: fix vring_desc.len assignment

Janne Grunau <j@jannau.net>
    arm64: dts: apple: t8103: Fix PCIe BCM4377 nodename

Sudeep Holla <sudeep.holla@arm.com>
    firmware: arm_ffa: Move memory allocation outside the mutex locking

Sudeep Holla <sudeep.holla@arm.com>
    firmware: arm_ffa: Add support for {un,}registration of framework notifications

Sudeep Holla <sudeep.holla@arm.com>
    firmware: arm_ffa: Stash ffa_device instead of notify_type in notifier_cb_info

Sudeep Holla <sudeep.holla@arm.com>
    firmware: arm_ffa: Refactoring to prepare for framework notification support

Sudeep Holla <sudeep.holla@arm.com>
    firmware: arm_ffa: Fix memory leak by freeing notifier callback node

Maíra Canal <mcanal@igalia.com>
    drm/v3d: Disable interrupts before resetting the GPU

Sergey Senozhatsky <senozhatsky@chromium.org>
    mtk-sd: reset host->mrq on prepare_data() error

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    mtk-sd: Prevent memory corruption from DMA map failure

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    mtk-sd: Fix a pagefault in dma_unmap_sg() for not prepared data

RD Babiera <rdbabiera@google.com>
    usb: typec: altmodes/displayport: do not index invalid pin_assignments

Yunshui Jiang <jiangyunshui@kylinos.cn>
    Input: cs40l50-vibra - fix potential NULL dereference in cs40l50_upload_owt()

Manivannan Sadhasivam <mani@kernel.org>
    regulator: gpio: Fix the out-of-bounds access to drvdata::gpiods

Nicolin Chen <nicolinc@nvidia.com>
    iommufd/selftest: Fix iommufd_dirty_tracking with large hugepage sizes

Christian Eggers <ceggers@arri.de>
    Bluetooth: MGMT: mesh_send: check instances prior disabling advertising

Christian Eggers <ceggers@arri.de>
    Bluetooth: MGMT: set_mesh: update LE scan interval and window

Christian Eggers <ceggers@arri.de>
    Bluetooth: hci_sync: revert some mesh modifications

Christian Eggers <ceggers@arri.de>
    Bluetooth: HCI: Set extended advertising data synchronously

Avri Altman <avri.altman@sandisk.com>
    mmc: core: sd: Apply BROKEN_SD_DISCARD quirk earlier

Ulf Hansson <ulf.hansson@linaro.org>
    Revert "mmc: sdhci: Disable SD card clock before changing parameters"

Victor Shih <victor.shih@genesyslogic.com.tw>
    mmc: sdhci: Add a helper function for dump register in dynamic debug mode

Jiawen Wu <jiawenwu@trustnetic.com>
    net: libwx: fix the incorrect display of the queue number

HarshaVardhana S A <harshavardhana.sa@broadcom.com>
    vsock/vmci: Clear the vmci transport packet properly when initializing it

Jiawen Wu <jiawenwu@trustnetic.com>
    net: txgbe: request MISC IRQ in ndo_open

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/pci: Do not try re-enabling load/store if device is disabled

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/pci: Fix stale function handles in error handling

Bui Quang Minh <minhquangbui99@gmail.com>
    virtio-net: ensure the received length does not exceed allocated size

Bui Quang Minh <minhquangbui99@gmail.com>
    virtio-net: xsk: rx: fix the frame's length check

Mateusz Jończyk <mat.jonczyk@o2.pl>
    rtc: cmos: use spin_lock_irqsave in cmos_interrupt

Elena Popa <elena.popa@nxp.com>
    rtc: pcf2127: fix SPI command byte for PCF2131

Hugo Villeneuve <hvilleneuve@dimonoff.com>
    rtc: pcf2127: add missing semicolon after statement


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-devices-system-cpu |    1 +
 Documentation/ABI/testing/sysfs-driver-ufs         |    2 +-
 .../hw-vuln/processor_mmio_stale_data.rst          |    4 +-
 Documentation/admin-guide/kernel-parameters.txt    |   13 +
 Documentation/arch/x86/mds.rst                     |    8 +-
 Documentation/core-api/symbol-namespaces.rst       |   22 +
 Makefile                                           |    4 +-
 arch/arm64/boot/dts/apple/t8103-jxxx.dtsi          |    2 +-
 arch/arm64/boot/dts/qcom/sm8650.dtsi               |  163 +-
 arch/arm64/boot/dts/qcom/x1e80100-crd.dts          |    2 +
 .../arm64/boot/dts/renesas/beacon-renesom-som.dtsi |    3 +-
 arch/arm64/boot/dts/renesas/cat875.dtsi            |    3 +-
 arch/arm64/boot/dts/renesas/condor-common.dtsi     |    3 +-
 arch/arm64/boot/dts/renesas/draak.dtsi             |    3 +-
 arch/arm64/boot/dts/renesas/ebisu.dtsi             |    3 +-
 arch/arm64/boot/dts/renesas/hihope-rzg2-ex.dtsi    |    3 +-
 arch/arm64/boot/dts/renesas/r8a77970-eagle.dts     |    3 +-
 arch/arm64/boot/dts/renesas/r8a77970-v3msk.dts     |    3 +-
 arch/arm64/boot/dts/renesas/r8a77980-v3hsk.dts     |    3 +-
 arch/arm64/boot/dts/renesas/r8a779a0-falcon.dts    |    3 +-
 .../boot/dts/renesas/r8a779f0-spider-ethernet.dtsi |    9 +-
 arch/arm64/boot/dts/renesas/r8a779f4-s4sk.dts      |    6 +-
 .../dts/renesas/r8a779g2-white-hawk-single.dts     |   63 +-
 .../boot/dts/renesas/r8a779h0-gray-hawk-single.dts |    3 +-
 arch/arm64/boot/dts/renesas/rzg2l-smarc-som.dtsi   |    6 +-
 arch/arm64/boot/dts/renesas/rzg2lc-smarc-som.dtsi  |    3 +-
 arch/arm64/boot/dts/renesas/rzg2ul-smarc-som.dtsi  |    6 +-
 arch/arm64/boot/dts/renesas/rzg3s-smarc-som.dtsi   |    6 +-
 arch/arm64/boot/dts/renesas/salvator-common.dtsi   |    3 +-
 arch/arm64/boot/dts/renesas/ulcb.dtsi              |    3 +-
 .../boot/dts/renesas/white-hawk-cpu-common.dtsi    |    3 +-
 .../boot/dts/renesas/white-hawk-ethernet.dtsi      |    6 +-
 arch/arm64/boot/dts/renesas/white-hawk-single.dtsi |   77 +
 arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi      |   42 +-
 arch/powerpc/include/uapi/asm/ioctls.h             |    8 +-
 arch/powerpc/kernel/Makefile                       |    2 -
 arch/riscv/kernel/cpu_ops_sbi.c                    |    6 +-
 arch/s390/pci/pci_event.c                          |   15 +
 arch/x86/Kconfig                                   |    9 +
 arch/x86/entry/entry.S                             |    8 +-
 arch/x86/include/asm/cpu.h                         |   12 +
 arch/x86/include/asm/cpufeatures.h                 |    6 +
 arch/x86/include/asm/irqflags.h                    |    4 +-
 arch/x86/include/asm/mwait.h                       |   28 +-
 arch/x86/include/asm/nospec-branch.h               |   37 +-
 arch/x86/kernel/cpu/amd.c                          |   60 +
 arch/x86/kernel/cpu/bugs.c                         |  133 +-
 arch/x86/kernel/cpu/common.c                       |   14 +-
 arch/x86/kernel/cpu/microcode/amd.c                |   12 -
 arch/x86/kernel/cpu/microcode/amd_shas.c           |  112 ++
 arch/x86/kernel/cpu/scattered.c                    |    2 +
 arch/x86/kernel/process.c                          |   16 +-
 arch/x86/kvm/cpuid.c                               |    8 +-
 arch/x86/kvm/reverse_cpuid.h                       |    8 +
 arch/x86/kvm/svm/vmenter.S                         |    6 +
 arch/x86/kvm/vmx/vmx.c                             |    2 +-
 drivers/acpi/acpica/dsmethod.c                     |    7 +
 drivers/acpi/thermal.c                             |   12 +-
 drivers/ata/libata-acpi.c                          |   24 +-
 drivers/ata/pata_cs5536.c                          |    2 +-
 drivers/ata/pata_via.c                             |    6 +-
 drivers/base/cpu.c                                 |    3 +
 drivers/block/aoe/aoe.h                            |    1 +
 drivers/block/aoe/aoecmd.c                         |    8 +-
 drivers/block/aoe/aoedev.c                         |    5 +-
 drivers/crypto/intel/iaa/iaa_crypto_main.c         |  140 +-
 drivers/crypto/xilinx/zynqmp-sha.c                 |   18 +-
 drivers/dma-buf/dma-resv.c                         |   12 +-
 drivers/firmware/arm_ffa/driver.c                  |  284 ++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c            |   14 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c            |   10 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c             |    4 +
 drivers/gpu/drm/amd/amdgpu/imu_v11_0.c             |    6 +-
 drivers/gpu/drm/amd/amdgpu/psp_v13_0.c             |    2 +
 drivers/gpu/drm/amd/amdgpu/vcn_v5_0_1.c            | 1624 ++++++++++++++++++++
 .../drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c    |   35 +-
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c     |    8 +-
 drivers/gpu/drm/bridge/aux-hpd-bridge.c            |    3 +-
 drivers/gpu/drm/exynos/exynos_drm_fimd.c           |   12 +
 drivers/gpu/drm/i915/display/intel_dp.c            |   18 +
 drivers/gpu/drm/i915/gt/intel_gsc.c                |    2 +-
 drivers/gpu/drm/i915/gt/intel_ring_submission.c    |    3 +-
 drivers/gpu/drm/i915/selftests/i915_request.c      |   20 +-
 drivers/gpu/drm/i915/selftests/mock_request.c      |    2 +-
 drivers/gpu/drm/msm/msm_gem_submit.c               |   17 +-
 drivers/gpu/drm/tiny/simpledrm.c                   |    4 +-
 drivers/gpu/drm/v3d/v3d_drv.h                      |    8 +
 drivers/gpu/drm/v3d/v3d_gem.c                      |    2 +
 drivers/gpu/drm/v3d/v3d_irq.c                      |   37 +-
 drivers/gpu/drm/xe/Kconfig                         |    3 +-
 drivers/gpu/drm/xe/abi/guc_communication_ctb_abi.h |    1 +
 .../xe/compat-i915-headers/gem/i915_gem_stolen.h   |    2 +-
 drivers/gpu/drm/xe/display/xe_dsb_buffer.c         |   18 +-
 drivers/gpu/drm/xe/display/xe_fb_pin.c             |   17 +-
 drivers/gpu/drm/xe/regs/xe_reg_defs.h              |    2 +-
 drivers/gpu/drm/xe/xe_bo.c                         |   78 +-
 drivers/gpu/drm/xe/xe_bo.h                         |   40 +-
 drivers/gpu/drm/xe/xe_bo_evict.c                   |   14 +-
 drivers/gpu/drm/xe/xe_bo_types.h                   |   10 +-
 drivers/gpu/drm/xe/xe_device.c                     |   49 +-
 drivers/gpu/drm/xe/xe_ggtt.c                       |   35 +-
 drivers/gpu/drm/xe/xe_guc.c                        |    4 +-
 drivers/gpu/drm/xe/xe_guc_ct.c                     |  350 ++++-
 drivers/gpu/drm/xe/xe_guc_ct.h                     |    2 +-
 drivers/gpu/drm/xe/xe_guc_ct_types.h               |   23 +
 drivers/gpu/drm/xe/xe_guc_pc.c                     |  144 ++
 drivers/gpu/drm/xe/xe_guc_pc.h                     |    2 +
 drivers/gpu/drm/xe/xe_guc_pc_types.h               |    2 +
 drivers/gpu/drm/xe/xe_irq.c                        |    4 +-
 drivers/gpu/drm/xe/xe_trace_bo.h                   |    2 +-
 drivers/i2c/busses/i2c-designware-master.c         |    1 +
 drivers/infiniband/hw/mlx5/counters.c              |    4 +-
 drivers/infiniband/hw/mlx5/devx.c                  |    2 +-
 drivers/infiniband/hw/mlx5/main.c                  |   33 +
 drivers/infiniband/hw/mlx5/mr.c                    |   95 +-
 drivers/infiniband/hw/mlx5/odp.c                   |    8 +-
 drivers/infiniband/sw/rxe/rxe_qp.c                 |    7 +-
 drivers/input/joystick/xpad.c                      |    2 +
 drivers/input/misc/cs40l50-vibra.c                 |    2 +
 drivers/input/misc/iqs7222.c                       |    7 +-
 drivers/iommu/ipmmu-vmsa.c                         |    2 +-
 drivers/iommu/rockchip-iommu.c                     |    3 +-
 drivers/mfd/exynos-lpass.c                         |   25 +-
 drivers/mmc/core/quirks.h                          |   12 +-
 drivers/mmc/host/mtk-sd.c                          |   21 +-
 drivers/mmc/host/sdhci.c                           |    9 +-
 drivers/mmc/host/sdhci.h                           |   16 +
 drivers/mtd/nand/spi/core.c                        |    1 +
 drivers/net/bonding/bond_main.c                    |    8 +-
 drivers/net/ethernet/amd/xgbe/xgbe-common.h        |    2 +
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c          |   13 +
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c        |   24 +-
 drivers/net/ethernet/amd/xgbe/xgbe.h               |    4 +-
 drivers/net/ethernet/atheros/atlx/atl1.c           |   79 +-
 drivers/net/ethernet/cisco/enic/enic_main.c        |    4 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |   26 +-
 drivers/net/ethernet/intel/idpf/idpf_controlq.c    |   23 +-
 .../net/ethernet/intel/idpf/idpf_controlq_api.h    |    2 +-
 drivers/net/ethernet/intel/idpf/idpf_ethtool.c     |    4 +-
 drivers/net/ethernet/intel/idpf/idpf_lib.c         |   12 +-
 drivers/net/ethernet/intel/igc/igc_main.c          |   10 +
 drivers/net/ethernet/sun/niu.c                     |   31 +-
 drivers/net/ethernet/sun/niu.h                     |    4 +
 drivers/net/ethernet/wangxun/libwx/wx_lib.c        |    1 +
 drivers/net/ethernet/wangxun/txgbe/txgbe_irq.c     |    2 +-
 drivers/net/ethernet/wangxun/txgbe/txgbe_main.c    |   22 +-
 drivers/net/usb/lan78xx.c                          |    2 -
 drivers/net/virtio_net.c                           |   60 +-
 drivers/net/wireless/ath/ath12k/dp_rx.c            |    3 +-
 drivers/net/wireless/ath/ath12k/dp_rx.h            |    3 +
 drivers/net/wireless/ath/ath12k/dp_tx.c            |   21 +-
 drivers/net/wireless/ath/ath12k/mac.c              |   16 +-
 drivers/net/wireless/ath/ath6kl/bmi.c              |    4 +-
 drivers/nvme/host/core.c                           |    2 +-
 drivers/nvme/target/nvmet.h                        |    2 +
 drivers/platform/mellanox/mlxbf-pmc.c              |    2 +-
 drivers/platform/mellanox/mlxbf-tmfifo.c           |    3 +-
 drivers/platform/mellanox/mlxreg-lc.c              |    2 +-
 drivers/platform/mellanox/nvsw-sn2201.c            |    2 +-
 drivers/platform/x86/amd/pmc/pmc-quirks.c          |    9 +
 .../x86/dell/dell-wmi-sysman/dell-wmi-sysman.h     |    5 +
 .../x86/dell/dell-wmi-sysman/enum-attributes.c     |    5 +-
 .../x86/dell/dell-wmi-sysman/int-attributes.c      |    5 +-
 .../x86/dell/dell-wmi-sysman/passobj-attributes.c  |    5 +-
 .../x86/dell/dell-wmi-sysman/string-attributes.c   |    5 +-
 drivers/platform/x86/dell/dell-wmi-sysman/sysman.c |   25 +-
 drivers/platform/x86/firmware_attributes_class.c   |   41 +-
 drivers/platform/x86/firmware_attributes_class.h   |    3 +
 drivers/platform/x86/hp/hp-bioscfg/bioscfg.c       |   14 +-
 drivers/platform/x86/think-lmi.c                   |  103 +-
 drivers/powercap/intel_rapl_common.c               |   18 +-
 drivers/regulator/fan53555.c                       |   14 +
 drivers/regulator/gpio-regulator.c                 |    8 +-
 drivers/remoteproc/ti_k3_dsp_remoteproc.c          |    6 +-
 drivers/remoteproc/ti_k3_m4_remoteproc.c           |    6 +-
 drivers/remoteproc/ti_k3_r5_remoteproc.c           |  180 ++-
 drivers/rtc/rtc-cmos.c                             |   10 +-
 drivers/rtc/rtc-pcf2127.c                          |    7 +-
 drivers/scsi/lpfc/lpfc_bsg.c                       |    6 +-
 drivers/scsi/lpfc/lpfc_crtn.h                      |    2 +-
 drivers/scsi/lpfc/lpfc_ct.c                        |   18 +-
 drivers/scsi/lpfc/lpfc_debugfs.c                   |    4 +-
 drivers/scsi/lpfc/lpfc_disc.h                      |   60 +-
 drivers/scsi/lpfc/lpfc_els.c                       |  441 +++---
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |  305 ++--
 drivers/scsi/lpfc/lpfc_init.c                      |   58 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c                 |  329 ++--
 drivers/scsi/lpfc/lpfc_nvme.c                      |    9 +-
 drivers/scsi/lpfc/lpfc_nvmet.c                     |    2 +-
 drivers/scsi/lpfc/lpfc_scsi.c                      |    8 +-
 drivers/scsi/lpfc/lpfc_sli.c                       |   78 +-
 drivers/scsi/lpfc/lpfc_vport.c                     |    6 +-
 drivers/scsi/qla2xxx/qla_mbx.c                     |    2 +-
 drivers/scsi/qla4xxx/ql4_os.c                      |    2 +
 drivers/scsi/sd.c                                  |    2 +-
 drivers/spi/spi-fsl-dspi.c                         |   11 +-
 drivers/target/target_core_pr.c                    |    4 +-
 drivers/tee/optee/ffa_abi.c                        |   41 +-
 drivers/tee/optee/optee_private.h                  |    2 +
 drivers/ufs/core/ufs-sysfs.c                       |    4 +-
 drivers/usb/cdns3/cdnsp-debug.h                    |    5 +-
 drivers/usb/cdns3/cdnsp-ep0.c                      |   18 +-
 drivers/usb/cdns3/cdnsp-gadget.h                   |    6 +
 drivers/usb/cdns3/cdnsp-ring.c                     |    7 +-
 drivers/usb/chipidea/udc.c                         |    7 +
 drivers/usb/core/hub.c                             |    3 +
 drivers/usb/core/quirks.c                          |    3 +-
 drivers/usb/core/usb-acpi.c                        |    4 +-
 drivers/usb/dwc3/core.c                            |    9 +-
 drivers/usb/dwc3/gadget.c                          |   22 +-
 drivers/usb/host/xhci-dbgcap.c                     |    4 +
 drivers/usb/host/xhci-dbgtty.c                     |    1 +
 drivers/usb/host/xhci-mem.c                        |    4 +
 drivers/usb/host/xhci-pci.c                        |   25 +
 drivers/usb/host/xhci-plat.c                       |    3 +-
 drivers/usb/host/xhci-ring.c                       |    5 +-
 drivers/usb/host/xhci.c                            |   31 +-
 drivers/usb/host/xhci.h                            |    3 +-
 drivers/usb/typec/altmodes/displayport.c           |    5 +-
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c     |   14 +-
 fs/anon_inodes.c                                   |   27 +-
 fs/bcachefs/fsck.c                                 |    2 +-
 fs/bcachefs/recovery.c                             |    2 -
 fs/bcachefs/util.h                                 |    2 -
 fs/btrfs/file.c                                    |   21 +-
 fs/btrfs/inode.c                                   |   36 +-
 fs/btrfs/ioctl.c                                   |    4 +-
 fs/btrfs/tree-log.c                                |  377 +++--
 fs/erofs/xattr.c                                   |    2 +-
 fs/f2fs/data.c                                     |    2 +-
 fs/f2fs/f2fs.h                                     |   35 +-
 fs/f2fs/file.c                                     |    3 +-
 fs/f2fs/gc.h                                       |    1 +
 fs/f2fs/segment.c                                  |   11 +-
 fs/f2fs/segment.h                                  |   10 -
 fs/f2fs/super.c                                    |   42 +
 fs/file_table.c                                    |    4 +-
 fs/gfs2/aops.c                                     |   54 +-
 fs/gfs2/aops.h                                     |    3 +-
 fs/gfs2/bmap.c                                     |    3 +-
 fs/gfs2/glock.c                                    |   19 +-
 fs/gfs2/glops.c                                    |    9 +-
 fs/gfs2/incore.h                                   |    3 +-
 fs/gfs2/inode.c                                    |   96 +-
 fs/gfs2/inode.h                                    |    1 +
 fs/gfs2/log.c                                      |    7 +-
 fs/gfs2/super.c                                    |  114 +-
 fs/gfs2/trace_gfs2.h                               |    9 +-
 fs/gfs2/trans.c                                    |   21 +
 fs/gfs2/trans.h                                    |    2 +
 fs/gfs2/xattr.c                                    |   11 +-
 fs/gfs2/xattr.h                                    |    2 +-
 fs/kernfs/file.c                                   |    2 +-
 fs/netfs/buffered_write.c                          |    2 +
 fs/netfs/direct_write.c                            |    8 +-
 fs/netfs/write_collect.c                           |    5 +-
 fs/nfs/flexfilelayout/flexfilelayout.c             |  121 +-
 fs/nfs/inode.c                                     |   17 +-
 fs/nfs/pnfs.c                                      |    4 +-
 fs/smb/client/cifsglob.h                           |    2 +
 fs/smb/client/cifsproto.h                          |    1 +
 fs/smb/client/cifssmb.c                            |    2 +
 fs/smb/client/connect.c                            |   15 +-
 fs/smb/client/misc.c                               |    6 +
 fs/smb/client/readdir.c                            |    2 +-
 fs/smb/client/smb2pdu.c                            |   11 +-
 include/linux/arm_ffa.h                            |    5 +
 include/linux/bpf_verifier.h                       |   31 +-
 include/linux/cpu.h                                |    1 +
 include/linux/dcache.h                             |    1 +
 include/linux/export.h                             |   12 +-
 include/linux/fs.h                                 |    2 +
 include/linux/libata.h                             |    7 +-
 include/linux/spinlock.h                           |   13 +
 include/linux/usb.h                                |    2 +
 include/linux/usb/typec_dp.h                       |    1 +
 kernel/bpf/verifier.c                              |  125 +-
 kernel/irq/irq_sim.c                               |    2 +-
 kernel/rcu/tree.c                                  |    4 +
 kernel/sched/core.c                                |    4 +-
 kernel/sched/debug.c                               |    7 +-
 kernel/sched/ext.c                                 |   12 +-
 kernel/sched/fair.c                                |  117 +-
 kernel/sched/pelt.c                                |    4 +-
 kernel/sched/sched.h                               |    5 +-
 lib/Kconfig.ubsan                                  |    2 +
 lib/test_objagg.c                                  |    4 +-
 mm/secretmem.c                                     |   10 +-
 mm/userfaultfd.c                                   |   33 +-
 mm/vmalloc.c                                       |   63 +-
 net/bluetooth/hci_event.c                          |   36 -
 net/bluetooth/hci_sync.c                           |  227 +--
 net/bluetooth/mgmt.c                               |   25 +-
 net/mac80211/rx.c                                  |    4 +
 net/rose/rose_route.c                              |   15 +-
 net/sched/sch_api.c                                |   19 +-
 net/sunrpc/rpc_pipe.c                              |   14 +-
 net/vmw_vsock/vmci_transport.c                     |    4 +-
 security/selinux/ss/services.c                     |   16 +-
 sound/isa/sb/sb16_main.c                           |    7 +
 sound/soc/amd/yc/acp6x-mach.c                      |   14 +
 sound/soc/codecs/tas2764.c                         |   46 +-
 sound/soc/codecs/tas2764.h                         |    3 +
 tools/testing/kunit/qemu_configs/sparc.py          |    7 +-
 tools/testing/selftests/iommu/iommufd.c            |   30 +-
 305 files changed, 6076 insertions(+), 2826 deletions(-)



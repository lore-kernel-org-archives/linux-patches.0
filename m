Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A90F26CE33;
	Fri, 21 Nov 2025 13:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731607; cv=none; b=gD/V4ElivSL3TP8EdfYr8vJMQln2LqwybWM8bl45y1hCA2Cqm7H1tEv+Pg7znz8wP1L4ATW4Jd5Lz8lWL34OhMzC/Wnid5aCxFmPn6Khi4MwP3H0GbwBXDPgedxuw/qIebATgqiIp27Q/xPAI6W+V+ZqdIxVvnqoOd/vbwjEhwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731607; c=relaxed/simple;
	bh=A359TKvUbPxtcjXkjI6E4edj/WjPVVxykeE4SoU0ohs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=VsnWrzwoXw1BZmJlbAHgYmlPqYRVtrJV+bJ1SLjPLMWY+WwGJw3BtFxjskL5jQYqOe/oyyvYLuTK0d6P0WlC1zlGEeUDCYCenZ3/V7Syx2L5bWkzsP1+KFTF/+9GCz9ESxl9yWw8CrT3ILhIJTCH6C4jiXhh30p8aZMr8v0tHK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CJszlfOy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CJszlfOy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43AC4C4CEF1;
	Fri, 21 Nov 2025 13:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731607;
	bh=A359TKvUbPxtcjXkjI6E4edj/WjPVVxykeE4SoU0ohs=;
	h=From:To:Cc:Subject:Date:From;
	b=CJszlfOyTgt2hBfejdovjuQBBqyreh1naFtwsP9UTWzbu36esRBaZkZ/IakG2lAMA
	 CErg37zSApSsWl+7gq+vkE4hcKaQ5CSMtNL0udpt//WuVOKZojp4fkU4WRyMHS7WAq
	 lr1eNHvrRGo9u9rA7zwd2oBKP45hBUJfaC2DNi94=
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
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com
Subject: [PATCH 6.12 000/185] 6.12.59-rc1 review
Date: Fri, 21 Nov 2025 14:10:27 +0100
Message-ID: <20251121130143.857798067@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.59-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.12.59-rc1
X-KernelTest-Deadline: 2025-11-23T13:01+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.12.59 release.
There are 185 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 23 Nov 2025 13:01:08 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.59-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.12.59-rc1

Pauli Virtanen <pav@iki.fi>
    Bluetooth: MGMT: fix crash in set_mesh_sync and set_mesh_complete

Jialin Wang <wjl.linux@gmail.com>
    proc: proc_maps_open allow proc_mem_open to return NULL

John Sperbeck <jsperbeck@google.com>
    net: netpoll: ensure skb_pool list is always initialized

Horatiu Vultur <horatiu.vultur@microchip.com>
    net: phy: micrel: Fix lan8814_config_init

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    isdn: mISDN: hfcsusb: fix memory leak in hfcsusb_probe()

Zi Yan <ziy@nvidia.com>
    mm/huge_memory: preserve PG_has_hwpoisoned if a folio is split to >0 order

Zi Yan <ziy@nvidia.com>
    mm/huge_memory: do not change split_huge_page*() target order silently

Lance Yang <lance.yang@linux.dev>
    mm/secretmem: fix use-after-free race in fault handler

Kiryl Shutsemau <kas@kernel.org>
    mm/truncate: unmap large folio on split failure

Kiryl Shutsemau <kas@kernel.org>
    mm/memory: do not populate page table entries beyond i_size

Long Li <longli@microsoft.com>
    uio_hv_generic: Set event for all channels on the device

Miguel Ojeda <ojeda@kernel.org>
    rust: kbuild: workaround `rustdoc` doctests modifier bug

Miguel Ojeda <ojeda@kernel.org>
    rust: kbuild: treat `build_error` and `rustdoc` as kernel objects

Olivier Langlois <olivier@trillion01.com>
    io_uring/napi: fix io_napi_entry RCU accesses

Denis Arefev <arefev@swemel.ru>
    ALSA: hda: Fix missing pointer check in hda_component_manager_init function

Sukrit Bhatnagar <Sukrit.Bhatnagar@sony.com>
    KVM: VMX: Fix check for valid GVA on an EPT violation

Sean Christopherson <seanjc@google.com>
    KVM: VMX: Split out guts of EPT violation to common/exposed function

Breno Leitao <leitao@debian.org>
    net: netpoll: fix incorrect refcount handling causing incorrect cleanup

Breno Leitao <leitao@debian.org>
    net: netpoll: flush skb pool during cleanup

Breno Leitao <leitao@debian.org>
    net: netpoll: Individualize the skb pool

Sean Christopherson <seanjc@google.com>
    KVM: guest_memfd: Remove bindings on memslot deletion when gmem is dying

Yan Zhao <yan.y.zhao@intel.com>
    KVM: guest_memfd: Remove RCU-protected attribute from slot->gmem.file

Sean Christopherson <seanjc@google.com>
    KVM: guest_memfd: Pass index, not gfn, to __kvm_gmem_get_pfn()

Michal Hocko <mhocko@suse.com>
    mm, percpu: do not consider sleepable allocations atomic

Benjamin Berg <benjamin.berg@intel.com>
    wifi: mac80211: use wiphy_hrtimer_work for csa.switch_work

Benjamin Berg <benjamin.berg@intel.com>
    wifi: cfg80211: add an hrtimer based delayed work item

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix MSG_PEEK stream corruption

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: properly kill background tasks

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: userspace: longer transfer

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: connect: trunc: read all recv data

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: endpoints: longer transfer

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: rm: set backup flag

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: connect: fix fallback note due to OoO

André Draszik <andre.draszik@linaro.org>
    pmdomain: samsung: plug potential memleak during probe

Miaoqian Lin <linmq006@gmail.com>
    pmdomain: imx: Fix reference count leak in imx_gpc_remove

Sudeep Holla <sudeep.holla@arm.com>
    pmdomain: arm: scmi: Fix genpd leak on provider registration failure

Vitaly Prosyak <vitaly.prosyak@amd.com>
    drm/amdgpu: disable peer-to-peer access for DCC-enabled GC12 VRAM surfaces

Jonathan Kim <jonathan.kim@amd.com>
    drm/amdkfd: relax checks for over allocation of save area

Zilin Guan <zilin@seu.edu.cn>
    btrfs: release root after error in data_reloc_print_warning_inode()

Filipe Manana <fdmanana@suse.com>
    btrfs: do not update last_log_commit when logging inode due to a new name

Zilin Guan <zilin@seu.edu.cn>
    btrfs: scrub: put bio after errors in scrub_raid56_parity_stripe()

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: zoned: fix conventional zone capacity calculation

Mario Limonciello (AMD) <superm1@kernel.org>
    PM: hibernate: Use atomic64_t for compressed_size variable

Mario Limonciello (AMD) <superm1@kernel.org>
    PM: hibernate: Emit an error when image writing fails

Niravkumar L Rabara <niravkumarlaxmidas.rabara@altera.com>
    EDAC/altera: Use INTTEST register for Ethernet and USB SBE injection

Niravkumar L Rabara <niravkumarlaxmidas.rabara@altera.com>
    EDAC/altera: Handle OCRAM ECC enable after warm reset

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Use physical addresses for CSR_MERRENTRY/CSR_TLBRENTRY

Song Liu <song@kernel.org>
    ftrace: Fix BPF fexit with livepatch

Ankit Khushwaha <ankitkhushwaha.linux@gmail.com>
    selftests/user_events: fix type cast for write_index packed member in perf_test

Borislav Petkov (AMD) <bp@alien8.de>
    x86/microcode/AMD: Add Zen5 model 0x44, stepping 0x1 minrev

Hans de Goede <hansg@kernel.org>
    spi: Try to get ACPI GPIO IRQ earlier

Henrique Carvalho <henrique.carvalho@suse.com>
    smb: client: fix cifs_pick_channel when channel needs reconnect

Miaoqian Lin <linmq006@gmail.com>
    crypto: hisilicon/qm - Fix device reference leak in qm_get_qos_value

Sourabh Jain <sourabhjain@linux.ibm.com>
    crash: fix crashkernel resource shrink

Hao Ge <gehao@kylinos.cn>
    codetag: debug: handle existing CODETAG_EMPTY in mark_objexts_empty for slabobj_ext

Edward Adam Davis <eadavis@qq.com>
    cifs: client: fix memory leak in smb3_fs_context_parse_param

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix potential overflow of PCM transfer buffer

Shawn Lin <shawn.lin@rock-chips.com>
    mmc: dw_mmc-rockchip: Fix wrong internal phase calculate

Shawn Lin <shawn.lin@rock-chips.com>
    mmc: sdhci-of-dwcmshc: Change DLL_STRBIN_TAPNUM_DEFAULT to 0x4

Kairui Song <kasong@tencent.com>
    mm/shmem: fix THP allocation and fallback loop

Isaac J. Manjarres <isaacmanjarres@google.com>
    mm/mm_init: fix hash table order logging in alloc_large_system_hash()

Wei Yang <albinwyang@tencent.com>
    fs/proc: fix uaf in proc_readdir_de()

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: reject address change while connecting

Steven Rostedt <rostedt@goodmis.org>
    selftests/tracing: Run sample events to clear page cache events

Edward Adam Davis <eadavis@qq.com>
    nilfs2: avoid having an active sc_timer before freeing sci

Chuang Wang <nashuiliang@gmail.com>
    ipv4: route: Prevent rt_bind_exception() from rebinding stale fnhe

Tianyang Zhang <zhangtianyang@loongson.cn>
    LoongArch: Let {pte,pmd}_modify() record the status of _PAGE_DIRTY

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Use correct accessor to read FWPC/MWPC

Qinxin Xia <xiaqinxin@huawei.com>
    dma-mapping: benchmark: Restore padding to ensure uABI remained consistent

Nate Karstens <nate.karstens@garmin.com>
    strparser: Fix signed/unsigned mismatch bug

Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
    ksm: use range-walk function to jump over holes in scan_get_next_rmap_item

Joshua Rogers <linux@joshua.hu>
    ksmbd: close accepted socket when per-IP limit rejects connection

Peter Oberparleiter <oberpar@linux.ibm.com>
    gcov: add support for GCC 15

Olga Kornievskaia <okorniev@redhat.com>
    NFSD: free copynotify stateid in nfs4_free_ol_stateid()

Olga Kornievskaia <okorniev@redhat.com>
    nfsd: add missing FATTR4_WORD2_CLONE_BLKSIZE from supported attributes

NeilBrown <neil@brown.name>
    nfsd: fix refcount leak in nfsd_set_fh_dentry()

Yosry Ahmed <yosry.ahmed@linux.dev>
    KVM: SVM: Mark VMCB_LBR dirty when MSR_IA32_DEBUGCTLMSR is updated

Bibo Mao <maobibo@loongson.cn>
    LoongArch: KVM: Add delay until timer interrupt injected

Bibo Mao <maobibo@loongson.cn>
    LoongArch: KVM: Restore guest PMU if it is enabled

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: sja1105: fix kasan out-of-bounds warning in sja1105_table_delete_entry()

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    HID: uclogic: Fix potential memory leak in error path

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    HID: playstation: Fix memory leak in dualshock4_get_calibration_data()

Rafał Miłecki <rafal@milecki.pl>
    ARM: dts: BCM53573: Fix address of Luxul XAP-1440's Ethernet PHY

Masami Ichikawa <masami256@gmail.com>
    HID: hid-ntrig: Prevent memory leak in ntrig_report_version()

Jihed Chaibi <jihed.chaibi.dev@gmail.com>
    ARM: dts: imx51-zii-rdu1: Fix audmux node names

Dragan Simic <dsimic@manjaro.org>
    arm64: dts: rockchip: Make RK3588 GPU OPP table naming less generic

Anand Moon <linux.amoon@gmail.com>
    arm64: dts: rockchip: Set correct pinctrl for I2S1 8ch TX on odroid-m1

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: reject duplicate device on updates

Pablo Neira Ayuso <pablo@netfilter.org>
    Revert "netfilter: nf_tables: Reintroduce shortened deletion notifications"

Zqiang <qiang.zhang@linux.dev>
    sched_ext: Fix unsafe locking in the scx_dump_state()

Andrei Vagin <avagin@google.com>
    fs/namespace: correctly handle errors returned by grab_requested_mnt_ns

Alok Tiwari <alok.a.tiwari@oracle.com>
    virtio-fs: fix incorrect check for fsvq->kobj

Dan Carpenter <dan.carpenter@linaro.org>
    mtd: onenand: Pass correct pointer to IRQ handler

Hongbo Li <lihongbo22@huawei.com>
    hostfs: Fix only passing host root in boot stage with new mount

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid overflow while left shift operation

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: MGMT: Fix possible UAFs

Ye Bin <yebin10@huawei.com>
    ext4: fix out-of-bound read in ext4_xattr_inode_dec_ref_all()

Eric Biggers <ebiggers@kernel.org>
    lib/crypto: arm/curve25519: Disable on CPU_BIG_ENDIAN

Ye Bin <yebin10@huawei.com>
    ext4: introduce ITAIL helper

Penglei Jiang <superman.xpt@gmail.com>
    proc: fix the issue of proc_mem_open returning NULL

Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
    wifi: ath11k: Clear affinity hint before calling ath11k_pcic_free_irq() in error path

Nick Hu <nick.hu@sifive.com>
    irqchip/riscv-intc: Add missing free() callback in riscv_intc_domain_ops

Eduard Zingerman <eddyz87@gmail.com>
    bpf: account for current allocated stack depth in widen_imprecise_scalars()

Eric Dumazet <edumazet@google.com>
    bpf: Add bpf_prog_run_data_pointers()

Dave Jiang <dave.jiang@intel.com>
    acpi/hmat: Fix lockdep warning for hmem_register_resource()

Haein Lee <lhi0729@kaist.ac.kr>
    ALSA: usb-audio: Fix NULL pointer dereference in snd_usb_mixer_controls_badd

Dai Ngo <dai.ngo@oracle.com>
    NFS: Fix LTP test failures when timestamps are delegated

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Fix an incorrect parameter when calling nfs4_call_sync()

Yang Xiuwei <yangxiuwei@kylinos.cn>
    NFS: sysfs: fix leak when nfs_client kobject add fails

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv2/v3: Fix error handling in nfs_atomic_open_v23()

Al Viro <viro@zeniv.linux.org.uk>
    simplify nfs_atomic_open_v23()

Trond Myklebust <trond.myklebust@hammerspace.com>
    pnfs: Set transport security policy to RPC_XPRTSEC_NONE unless using TLS

Trond Myklebust <trond.myklebust@hammerspace.com>
    pnfs: Fix TLS logic in _nfs4_pnfs_v4_ds_connect()

Shenghao Ding <shenghao-ding@ti.com>
    ASoC: tas2781: fix getting the wrong device number

Ian Forbes <ian.forbes@broadcom.com>
    drm/vmwgfx: Validate command header size against SVGA_CMD_MAX_DATASIZE

Haotian Zhang <vulab@iscas.ac.cn>
    ASoC: codecs: va-macro: fix resource leak in probe error path

Haotian Zhang <vulab@iscas.ac.cn>
    ASoC: cs4271: Fix regulator leak on probe failure

Haotian Zhang <vulab@iscas.ac.cn>
    regulator: fixed: fix GPIO descriptor leak on register failure

Shuai Xue <xueshuai@linux.alibaba.com>
    acpi,srat: Fix incorrect device handle check for Generic Initiator

Pauli Virtanen <pav@iki.fi>
    Bluetooth: L2CAP: export l2cap_chan_hold for modules

Gautham R. Shenoy <gautham.shenoy@amd.com>
    ACPI: CPPC: Limit perf ctrs in PCC check only to online CPUs

Gautham R. Shenoy <gautham.shenoy@amd.com>
    ACPI: CPPC: Perform fast check switch only for online CPUs

Gautham R. Shenoy <gautham.shenoy@amd.com>
    ACPI: CPPC: Check _CPC validity for only the online CPUs

Gautham R. Shenoy <gautham.shenoy@amd.com>
    ACPI: CPPC: Detect preferred core availability on online CPUs

Felix Maurer <fmaurer@redhat.com>
    hsr: Fix supervision frame sending on HSRv0

Xuan Zhuo <xuanzhuo@linux.alibaba.com>
    virtio-net: fix incorrect flags recording in big mode

Eric Dumazet <edumazet@google.com>
    net_sched: limit try_bulk_dequeue_skb() batches

Gal Pressman <gal@nvidia.com>
    net/mlx5e: Fix potentially misleading debug message

Gal Pressman <gal@nvidia.com>
    net/mlx5e: Fix wraparound in rate limiting for values above 255 Gbps

Gal Pressman <gal@nvidia.com>
    net/mlx5e: Fix maxrate wraparound in threshold between units

Ranganath V N <vnranganath.20@gmail.com>
    net: sched: act_ife: initialize struct tc_ife to fix KMSAN kernel-infoleak

Ranganath V N <vnranganath.20@gmail.com>
    net: sched: act_connmark: initialize struct tc_ife to fix kernel leak

Eric Dumazet <edumazet@google.com>
    net_sched: act_connmark: use RCU in tcf_connmark_dump()

Kuniyuki Iwashima <kuniyu@google.com>
    af_unix: Initialise scc_index in unix_add_edge().

Benjamin Berg <benjamin.berg@intel.com>
    wifi: mac80211: skip rate verification for not captured PSDUs

Buday Csaba <buday.csaba@prolan.hu>
    net: mdio: fix resource leak in mdiobus_register_device()

Kuniyuki Iwashima <kuniyu@google.com>
    tipc: Fix use-after-free in tipc_mon_reinit_self().

Aksh Garg <a-garg7@ti.com>
    net: ethernet: ti: am65-cpsw-qos: fix IET verify retry mechanism

Aksh Garg <a-garg7@ti.com>
    net: ethernet: ti: am65-cpsw-qos: fix IET verify/response timeout

Zilin Guan <zilin@seu.edu.cn>
    net/handshake: Fix memory leak in tls_handshake_accept()

D. Wythe <alibuda@linux.alibaba.com>
    net/smc: fix mismatch between CLC header and proposal

Eric Dumazet <edumazet@google.com>
    sctp: prevent possible shift-out-of-bounds in sctp_transport_update_rto

Pauli Virtanen <pav@iki.fi>
    Bluetooth: 6lowpan: Don't hold spin lock over sleeping functions

Pauli Virtanen <pav@iki.fi>
    Bluetooth: 6lowpan: fix BDADDR_LE vs ADDR_LE_DEV address type confusion

Pauli Virtanen <pav@iki.fi>
    Bluetooth: 6lowpan: reset link-local header on ipv6 recv path

Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>
    Bluetooth: btusb: reorder cleanup in btusb_disconnect to avoid UAF

Pauli Virtanen <pav@iki.fi>
    Bluetooth: MGMT: cancel mesh send timer when hdev removed

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Skip close replay processing if XDR encoding fails

Xi Ruoyao <xry111@xry111.site>
    rust: Add -fno-isolate-erroneous-paths-dereference to bindgen_skip_c_flags

Horatiu Vultur <horatiu.vultur@microchip.com>
    net: phy: micrel: lan8814 fix reset of the QSGMII interface

Horatiu Vultur <horatiu.vultur@microchip.com>
    net: phy: micrel: Replace hardcoded pages with defines

Horatiu Vultur <horatiu.vultur@microchip.com>
    net: phy: micrel: Introduce lanphy_modify_page_reg

Wei Fang <wei.fang@nxp.com>
    net: fec: correct rx_bytes statistic for the case SHIFT16 is set

Alexander Sverdlin <alexander.sverdlin@siemens.com>
    selftests: net: local_termination: Wait for interfaces to come up

Gao Xiang <xiang@kernel.org>
    erofs: avoid infinite loop due to incomplete zstd-compressed data

Nicolas Escande <nico.escande@gmail.com>
    wifi: ath11k: zero init info->status in wmi_process_mgmt_tx_comp()

Sharique Mohammad <sharq0406@gmail.com>
    ASoC: max98090/91: fixed max98091 ALSA widget powering up/down

Stuart Hayhurst <stuart.a.hayhurst@gmail.com>
    HID: logitech-hidpp: Add HIDPP_QUIRK_RESET_HI_RES_SCROLL

ZhangGuoDong <zhangguodong@kylinos.cn>
    smb/server: fix possible refcount leak in smb2_sess_setup()

ZhangGuoDong <zhangguodong@kylinos.cn>
    smb/server: fix possible memory leak in smb2_read()

Jaehun Gou <p22gone@gmail.com>
    exfat: fix improper check of dentry.stream.valid_size

Oleg Makarenko <oleg@makarenk.ooo>
    HID: quirks: Add ALWAYS_POLL quirk for VRS R295 steering wheel

Scott Mayhew <smayhew@redhat.com>
    NFS: check if suid/sgid was cleared after a write as needed

Vicki Pfau <vi@endrift.com>
    HID: nintendo: Wait longer for initial probe

Tristan Lobb <tristan.lobb@it-lobb.de>
    HID: quirks: avoid Cooler Master MM712 dongle wakeup bug

Joshua Watt <jpewhacker@gmail.com>
    NFS4: Apply delay_retrans to async operations

Joshua Watt <jpewhacker@gmail.com>
    NFS4: Fix state renewals missing after boot

Jesse.Zhang <Jesse.Zhang@amd.com>
    drm/amdgpu: Fix NULL pointer dereference in VRAM logic for APU devices

Christian König <christian.koenig@amd.com>
    drm/amdgpu: hide VRAM sysfs attributes on GPUs without VRAM

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/pm: Disable MCLK switching on SI at high pixel clocks

Christian König <christian.koenig@amd.com>
    drm/amdgpu: remove two invalid BUG_ON()s

Han Gao <rabenda.cn@gmail.com>
    riscv: acpi: avoid errors caused by probing DT devices when ACPI is used

Danil Skrebenkov <danil.skrebenkov@cloudbear.ru>
    RISC-V: clear hot-unplugged cores from all task mm_cpumasks to avoid rfence errors

Feng Jiang <jiangfeng@kylinos.cn>
    riscv: Build loader.bin exclusively for Canaan K210

Peter Zijlstra <peterz@infradead.org>
    compiler_types: Move unused static inline functions warning to W=2

Yang Shi <yang@os.amperecomputing.com>
    arm64: kprobes: check the return value of set_memory_rox()

Jouni Högander <jouni.hogander@intel.com>
    drm/xe: Do clean shutdown also when using flr

Tejas Upadhyay <tejas.upadhyay@intel.com>
    drm/xe: Move declarations under conditional branch

Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>
    drm/xe/guc: Synchronize Dead CT worker with unbind

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd: Fix suspend failure with secure display TA

Jason Gunthorpe <jgg@ziepe.ca>
    iommufd: Make vfio_compat's unmap succeed if the range is already empty

Shuhao Fu <sfual@cse.ust.hk>
    smb: client: fix refcount leak in smb2_set_path_attr

Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
    drm/i915: Fix conversion between clock ticks and nanoseconds

Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
    drm/i915: Avoid lock inversion when pinning to GGTT on CHV/BXT+VTD

Jason-JH Lin <jason-jh.lin@mediatek.com>
    drm/mediatek: Add pm_runtime support for GCE power control


-------------

Diffstat:

 Makefile                                           |   4 +-
 .../boot/dts/broadcom/bcm47189-luxul-xap-1440.dts  |   4 +-
 arch/arm/boot/dts/nxp/imx/imx51-zii-rdu1.dts       |   4 +-
 arch/arm/crypto/Kconfig                            |   2 +-
 arch/arm64/boot/dts/rockchip/rk3568-odroid-m1.dts  |   2 +
 arch/arm64/boot/dts/rockchip/rk3588-opp.dtsi       |   2 +-
 arch/arm64/boot/dts/rockchip/rk3588j.dtsi          |   2 +-
 arch/arm64/kernel/probes/kprobes.c                 |   5 +-
 arch/loongarch/include/asm/hw_breakpoint.h         |   4 +-
 arch/loongarch/include/asm/pgtable.h               |  11 +-
 arch/loongarch/kernel/traps.c                      |   4 +-
 arch/loongarch/kvm/timer.c                         |   2 +
 arch/loongarch/kvm/vcpu.c                          |   5 +
 arch/riscv/Makefile                                |   2 +-
 arch/riscv/kernel/cpu-hotplug.c                    |   1 +
 arch/riscv/kernel/setup.c                          |   7 +-
 arch/x86/kernel/acpi/cppc.c                        |   2 +-
 arch/x86/kernel/cpu/microcode/amd.c                |   1 +
 arch/x86/kvm/svm/svm.c                             |   4 +
 arch/x86/kvm/vmx/common.h                          |  34 ++
 arch/x86/kvm/vmx/vmx.c                             |  25 +-
 drivers/acpi/cppc_acpi.c                           |   6 +-
 drivers/acpi/numa/hmat.c                           |  46 +-
 drivers/acpi/numa/srat.c                           |   2 +-
 drivers/bluetooth/btusb.c                          |  13 +-
 drivers/crypto/hisilicon/qm.c                      |   2 +
 drivers/edac/altera_edac.c                         |  22 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c             |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c        |  12 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c            |   7 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c            |   5 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c           |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c       |   3 +
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c             |   2 -
 drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c             |   2 -
 drivers/gpu/drm/amd/amdkfd/kfd_queue.c             |  12 +-
 drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c         |   5 +
 drivers/gpu/drm/i915/gt/intel_gt_clock_utils.c     |   4 +-
 drivers/gpu/drm/i915/i915_vma.c                    |  16 +-
 drivers/gpu/drm/mediatek/mtk_crtc.c                |   7 +
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c            |   5 +
 drivers/gpu/drm/xe/xe_device.c                     |  14 +-
 drivers/gpu/drm/xe/xe_guc_ct.c                     |   3 +
 drivers/hid/hid-ids.h                              |   4 +
 drivers/hid/hid-logitech-hidpp.c                   |  21 +
 drivers/hid/hid-nintendo.c                         |   2 +-
 drivers/hid/hid-ntrig.c                            |   7 +-
 drivers/hid/hid-playstation.c                      |   2 +
 drivers/hid/hid-quirks.c                           |   2 +
 drivers/hid/hid-uclogic-params.c                   |   4 +-
 drivers/iommu/iommufd/io_pagetable.c               |  12 +-
 drivers/iommu/iommufd/ioas.c                       |   4 +
 drivers/irqchip/irq-riscv-intc.c                   |   3 +-
 drivers/isdn/hardware/mISDN/hfcsusb.c              |  18 +-
 drivers/mmc/host/dw_mmc-rockchip.c                 |   4 +-
 drivers/mmc/host/sdhci-of-dwcmshc.c                |   2 +-
 drivers/mtd/nand/onenand/onenand_samsung.c         |   2 +-
 drivers/net/dsa/sja1105/sja1105_static_config.c    |   6 +-
 drivers/net/ethernet/freescale/fec_main.c          |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c |  33 +-
 drivers/net/ethernet/ti/am65-cpsw-qos.c            |  53 ++-
 drivers/net/phy/mdio_bus.c                         |   5 +-
 drivers/net/phy/micrel.c                           | 515 +++++++++++++--------
 drivers/net/virtio_net.c                           |  16 +-
 drivers/net/wireless/ath/ath11k/pci.c              |   2 +
 drivers/net/wireless/ath/ath11k/wmi.c              |   3 +
 drivers/pmdomain/arm/scmi_pm_domain.c              |  13 +-
 drivers/pmdomain/imx/gpc.c                         |   2 +
 drivers/pmdomain/samsung/exynos-pm-domains.c       |  11 +-
 drivers/regulator/fixed.c                          |   1 +
 drivers/spi/spi.c                                  |  10 +
 drivers/uio/uio_hv_generic.c                       |  32 +-
 fs/btrfs/inode.c                                   |   4 +-
 fs/btrfs/scrub.c                                   |   2 +
 fs/btrfs/tree-log.c                                |   2 +-
 fs/btrfs/zoned.c                                   |   4 +-
 fs/erofs/decompressor_zstd.c                       |  11 +-
 fs/exfat/namei.c                                   |   6 +-
 fs/ext4/inode.c                                    |   5 +
 fs/ext4/xattr.c                                    |  32 +-
 fs/ext4/xattr.h                                    |  10 +
 fs/f2fs/compress.c                                 |   2 +-
 fs/fuse/virtio_fs.c                                |   2 +-
 fs/hostfs/hostfs_kern.c                            |  29 +-
 fs/namespace.c                                     |  32 +-
 fs/nfs/dir.c                                       |  23 +-
 fs/nfs/inode.c                                     |  18 +-
 fs/nfs/nfs3client.c                                |  14 +-
 fs/nfs/nfs4client.c                                |  15 +-
 fs/nfs/nfs4proc.c                                  |  22 +-
 fs/nfs/pnfs_nfs.c                                  |  34 +-
 fs/nfs/sysfs.c                                     |   1 +
 fs/nfs/write.c                                     |   3 +-
 fs/nfsd/nfs4state.c                                |   3 +-
 fs/nfsd/nfs4xdr.c                                  |   3 +-
 fs/nfsd/nfsd.h                                     |   1 +
 fs/nfsd/nfsfh.c                                    |   6 +-
 fs/nilfs2/segment.c                                |   7 +-
 fs/proc/base.c                                     |  12 +-
 fs/proc/generic.c                                  |  12 +-
 fs/proc/task_mmu.c                                 |   8 +-
 fs/proc/task_nommu.c                               |   4 +-
 fs/smb/client/fs_context.c                         |   2 +
 fs/smb/client/smb2inode.c                          |   2 +
 fs/smb/client/transport.c                          |   2 +-
 fs/smb/server/smb2pdu.c                            |   2 +
 fs/smb/server/transport_tcp.c                      |   5 +-
 include/linux/compiler_types.h                     |   5 +-
 include/linux/filter.h                             |  20 +
 include/linux/huge_mm.h                            |  21 +-
 include/linux/kvm_host.h                           |   7 +-
 include/linux/map_benchmark.h                      |   1 +
 include/linux/netpoll.h                            |   1 +
 include/linux/nfs_xdr.h                            |   1 +
 include/net/bluetooth/mgmt.h                       |   2 +-
 include/net/cfg80211.h                             |  78 ++++
 include/net/tc_act/tc_connmark.h                   |   1 +
 include/uapi/linux/mount.h                         |   2 +-
 io_uring/napi.c                                    |  19 +-
 kernel/bpf/trampoline.c                            |   5 -
 kernel/bpf/verifier.c                              |   6 +-
 kernel/crash_core.c                                |   2 +-
 kernel/gcov/gcc_4_7.c                              |   4 +-
 kernel/power/swap.c                                |  17 +-
 kernel/sched/ext.c                                 |   4 +-
 kernel/trace/ftrace.c                              |  20 +-
 mm/filemap.c                                       |  20 +-
 mm/huge_memory.c                                   |  32 +-
 mm/ksm.c                                           | 113 ++++-
 mm/memory.c                                        |  23 +-
 mm/mm_init.c                                       |   2 +-
 mm/percpu.c                                        |   8 +-
 mm/secretmem.c                                     |   2 +-
 mm/shmem.c                                         |   9 +-
 mm/slub.c                                          |   6 +-
 mm/truncate.c                                      |  27 +-
 net/bluetooth/6lowpan.c                            | 103 +++--
 net/bluetooth/l2cap_core.c                         |   1 +
 net/bluetooth/mgmt.c                               | 260 ++++++++---
 net/bluetooth/mgmt_util.c                          |  46 ++
 net/bluetooth/mgmt_util.h                          |   3 +
 net/core/netpoll.c                                 |  56 ++-
 net/handshake/tlshd.c                              |   1 +
 net/hsr/hsr_device.c                               |   3 +
 net/ipv4/route.c                                   |   5 +
 net/mac80211/chan.c                                |   2 +-
 net/mac80211/ieee80211_i.h                         |   4 +-
 net/mac80211/iface.c                               |  14 +-
 net/mac80211/link.c                                |   4 +-
 net/mac80211/mlme.c                                |  18 +-
 net/mac80211/rx.c                                  |  10 +-
 net/mptcp/protocol.c                               |  36 +-
 net/netfilter/nf_tables_api.c                      |  66 ++-
 net/sched/act_bpf.c                                |   6 +-
 net/sched/act_connmark.c                           |  30 +-
 net/sched/act_ife.c                                |  12 +-
 net/sched/cls_bpf.c                                |   6 +-
 net/sched/sch_generic.c                            |  17 +-
 net/sctp/transport.c                               |  13 +-
 net/smc/smc_clc.c                                  |   1 +
 net/strparser/strparser.c                          |   2 +-
 net/tipc/net.c                                     |   2 +
 net/unix/garbage.c                                 |  14 +-
 net/wireless/core.c                                |  56 +++
 net/wireless/trace.h                               |  21 +
 rust/Makefile                                      |  16 +-
 sound/pci/hda/hda_component.c                      |   4 +
 sound/soc/codecs/cs4271.c                          |  10 +-
 sound/soc/codecs/lpass-va-macro.c                  |   2 +-
 sound/soc/codecs/max98090.c                        |   6 +-
 sound/soc/codecs/tas2781-i2c.c                     |   9 +-
 sound/usb/endpoint.c                               |   5 +
 sound/usb/mixer.c                                  |   2 +
 .../ftrace/test.d/filter/event-filter-function.tc  |   4 +
 tools/testing/selftests/iommu/iommufd.c            |   2 +
 .../selftests/net/forwarding/local_termination.sh  |   2 +
 tools/testing/selftests/net/mptcp/mptcp_connect.c  |  18 +-
 tools/testing/selftests/net/mptcp/mptcp_connect.sh |   2 +-
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |  90 ++--
 tools/testing/selftests/net/mptcp/mptcp_lib.sh     |  21 +
 tools/testing/selftests/user_events/perf_test.c    |   2 +-
 virt/kvm/guest_memfd.c                             |  89 ++--
 182 files changed, 2094 insertions(+), 912 deletions(-)



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F6234DCEB;
	Fri, 21 Nov 2025 13:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732175; cv=none; b=GN/eDHaYMGEHg02FasP0CR02Gbd50+VHxndkz1oL/yS6xvoYB74Dy0tUD8I8gCkulfT2W17NYuJHORJbK3t78fuPNd/E9BTHfYP2mYYTqK5UimEutjE+adwOzUh1Yp9cGuD2akEQrlFiHTJysl1m/MUL2WfOox6lH7LvfCgcH1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732175; c=relaxed/simple;
	bh=oO/Lv4NueiF0LRH+dRU0WyROMogZqfnGnIgWiGkEDOY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Vk8Q6UUYJVLnyhD4tfUG5JSh1SIhqG2uYs0ne9cwZDU3kPn2zURZiYhy0bhHYk5nAV4dK7i6S/oK82D2/Y+AjYV+Q/7mVi32BhYzGx4njBf8anmOcuRTHzn97Vs+YpcR+pp/OL9FX1Xoy30u2sPYmoOuURf4PzzWf93lR7df2yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y1EgPiV3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y1EgPiV3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA9A9C4CEFB;
	Fri, 21 Nov 2025 13:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732175;
	bh=oO/Lv4NueiF0LRH+dRU0WyROMogZqfnGnIgWiGkEDOY=;
	h=From:To:Cc:Subject:Date:From;
	b=Y1EgPiV3hCVJgmfmAYcNGmXc4gI5ikjI2s74pFDo5DMy1qIvRSj6bBS0Drt/j7TmE
	 hZ4Sv16pgr+dE8UX1aUrjpjNea7dnnwhDRYqJnEc18Sgg1tHCGQ5fktZhUleYImHxM
	 HVSkjqzxUout5RnyIWiTXu8dt3rBmqSEldzK8ryA=
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
Subject: [PATCH 6.6 000/529] 6.6.117-rc1 review
Date: Fri, 21 Nov 2025 14:04:59 +0100
Message-ID: <20251121130230.985163914@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.117-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.117-rc1
X-KernelTest-Deadline: 2025-11-23T13:02+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.117 release.
There are 529 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 23 Nov 2025 13:01:08 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.117-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.117-rc1

Breno Leitao <leitao@debian.org>
    memcg: fix data-race KCSAN bug in rstats

Dave Jiang <dave.jiang@intel.com>
    ACPI: HMAT: Remove register of memory node for generic target

Yosry Ahmed <yosryahmed@google.com>
    mm: memcg: optimize parent iteration in memcg_rstat_updated()

Li Zhijian <lizhijian@fujitsu.com>
    mm/memory-tier: fix abstract distance calculation overflow

Ying Huang <ying.huang@intel.com>
    memory tiers: use default_dram_perf_ref_source in log message

Nhat Pham <nphamcs@gmail.com>
    cachestat: do not flush stats in recency check

John Sperbeck <jsperbeck@google.com>
    net: netpoll: ensure skb_pool list is always initialized

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    isdn: mISDN: hfcsusb: fix memory leak in hfcsusb_probe()

Lance Yang <lance.yang@linux.dev>
    mm/secretmem: fix use-after-free race in fault handler

Kiryl Shutsemau <kas@kernel.org>
    mm/truncate: unmap large folio on split failure

Kiryl Shutsemau <kas@kernel.org>
    mm/memory: do not populate page table entries beyond i_size

Pankaj Raghav <p.raghav@samsung.com>
    filemap: cap PTE range to be created to allowed zero fill in folio_map_range()

Yosry Ahmed <yosryahmed@google.com>
    mm: memcg: restore subtree stats flushing

Yosry Ahmed <yosryahmed@google.com>
    mm: workingset: move the stats flush into workingset_test_recent()

Yosry Ahmed <yosryahmed@google.com>
    mm: memcg: make stats flushing threshold per-memcg

Yosry Ahmed <yosryahmed@google.com>
    mm: memcg: move vmstats structs definition above flushing code

Yosry Ahmed <yosryahmed@google.com>
    mm: memcg: change flush_next_time to flush_last_time

Domenico Cerasuolo <cerasuolodomenico@gmail.com>
    mm: memcg: add per-memcg zswap writeback stat

Xin Hao <vernhao@tencent.com>
    mm: memcg: add THP swap out info for anonymous reclaim

Adrian Hunter <adrian.hunter@intel.com>
    scsi: ufs: ufs-pci: Set UFSHCD_QUIRK_PERFORM_LINK_STARTUP_ONCE for Intel ADL

Adrian Hunter <adrian.hunter@intel.com>
    scsi: ufs: core: Add a quirk to suppress link_startup_again

Manivannan Sadhasivam <mani@kernel.org>
    scsi: ufs: core: Add a quirk for handling broken LSDBS field in controller capabilities register

Eric Biggers <ebiggers@google.com>
    scsi: ufs: core: Add UFSHCD_QUIRK_KEYS_IN_PRDT

Eric Biggers <ebiggers@google.com>
    scsi: ufs: core: Add fill_crypto_prdt variant op

Eric Biggers <ebiggers@google.com>
    scsi: ufs: core: Add UFSHCD_QUIRK_BROKEN_CRYPTO_ENABLE

Eric Biggers <ebiggers@google.com>
    scsi: ufs: core: fold ufshcd_clear_keyslot() into its caller

Eric Biggers <ebiggers@google.com>
    scsi: ufs: core: Add UFSHCD_QUIRK_CUSTOM_CRYPTO_PROFILE

Qingfang Deng <dqfext@gmail.com>
    net: stmmac: Fix accessing freed irq affinity_hint

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid overflow while left shift operation

Breno Leitao <leitao@debian.org>
    net: netpoll: fix incorrect refcount handling causing incorrect cleanup

Breno Leitao <leitao@debian.org>
    net: netpoll: flush skb pool during cleanup

Breno Leitao <leitao@debian.org>
    net: netpoll: Individualize the skb pool

Eric Dumazet <edumazet@google.com>
    netpoll: remove netpoll_srcu

Michal Hocko <mhocko@suse.com>
    mm, percpu: do not consider sleepable allocations atomic

Jason Gunthorpe <jgg@ziepe.ca>
    iommufd: Don't overflow during division for dirty tracking

Qu Wenruo <wqu@suse.com>
    btrfs: ensure no dirty metadata is written back for an fs with errors

Ariel D'Alessandro <ariel.dalessandro@collabora.com>
    drm/mediatek: Disable AFBC support on Mediatek DRM driver

jingxian.li <jingxian.li@shopee.com>
    Revert "perf dso: Add missed dso__put to dso__load_kcore"

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: connect: trunc: read all recv data

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: rm: set backup flag

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: connect: fix fallback note due to OoO

André Draszik <andre.draszik@linaro.org>
    pmdomain: samsung: plug potential memleak during probe

Filipe Manana <fdmanana@suse.com>
    btrfs: do not update last_log_commit when logging inode due to a new name

Zilin Guan <zilin@seu.edu.cn>
    btrfs: scrub: put bio after errors in scrub_raid56_parity_stripe()

Niravkumar L Rabara <niravkumarlaxmidas.rabara@altera.com>
    EDAC/altera: Use INTTEST register for Ethernet and USB SBE injection

Niravkumar L Rabara <niravkumarlaxmidas.rabara@altera.com>
    EDAC/altera: Handle OCRAM ECC enable after warm reset

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Use physical addresses for CSR_MERRENTRY/CSR_TLBRENTRY

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

Edward Adam Davis <eadavis@qq.com>
    cifs: client: fix memory leak in smb3_fs_context_parse_param

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix potential overflow of PCM transfer buffer

Shawn Lin <shawn.lin@rock-chips.com>
    mmc: sdhci-of-dwcmshc: Change DLL_STRBIN_TAPNUM_DEFAULT to 0x4

Isaac J. Manjarres <isaacmanjarres@google.com>
    mm/mm_init: fix hash table order logging in alloc_large_system_hash()

Wei Yang <albinwyang@tencent.com>
    fs/proc: fix uaf in proc_readdir_de()

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: reject address change while connecting

Steven Rostedt <rostedt@goodmis.org>
    selftests/tracing: Run sample events to clear page cache events

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

Joshua Rogers <linux@joshua.hu>
    ksmbd: close accepted socket when per-IP limit rejects connection

Peter Oberparleiter <oberpar@linux.ibm.com>
    gcov: add support for GCC 15

Olga Kornievskaia <okorniev@redhat.com>
    NFSD: free copynotify stateid in nfs4_free_ol_stateid()

Yosry Ahmed <yosry.ahmed@linux.dev>
    KVM: SVM: Mark VMCB_LBR dirty when MSR_IA32_DEBUGCTLMSR is updated

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    HID: uclogic: Fix potential memory leak in error path

Rafał Miłecki <rafal@milecki.pl>
    ARM: dts: BCM53573: Fix address of Luxul XAP-1440's Ethernet PHY

Masami Ichikawa <masami256@gmail.com>
    HID: hid-ntrig: Prevent memory leak in ntrig_report_version()

Jihed Chaibi <jihed.chaibi.dev@gmail.com>
    ARM: dts: imx51-zii-rdu1: Fix audmux node names

Anand Moon <linux.amoon@gmail.com>
    arm64: dts: rockchip: Set correct pinctrl for I2S1 8ch TX on odroid-m1

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: reject duplicate device on updates

Dan Carpenter <dan.carpenter@linaro.org>
    mtd: onenand: Pass correct pointer to IRQ handler

Arseniy Krasnov <avkrasnov@salutedevices.com>
    Bluetooth: hci_sync: fix double free in 'hci_discovery_filter_clear()'

Eric Biggers <ebiggers@kernel.org>
    lib/crypto: arm/curve25519: Disable on CPU_BIG_ENDIAN

Sabrina Dubroca <sd@queasysnail.net>
    espintcp: fix skb leaks

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: improve shutdown sequence

Paolo Abeni <pabeni@redhat.com>
    net: allow small head cache usage with large MAX_SKB_FRAGS values

Wang Liang <wangliang74@huawei.com>
    net: fix NULL pointer dereference in l3mdev_l3_rcv

Nick Hu <nick.hu@sifive.com>
    irqchip/riscv-intc: Add missing free() callback in riscv_intc_domain_ops

Eduard Zingerman <eddyz87@gmail.com>
    bpf: account for current allocated stack depth in widen_imprecise_scalars()

Eric Dumazet <edumazet@google.com>
    bpf: Add bpf_prog_run_data_pointers()

Dave Jiang <dave.jiang@intel.com>
    acpi/hmat: Fix lockdep warning for hmem_register_resource()

Dave Jiang <dave.jiang@intel.com>
    base/node / ACPI: Enumerate node access class for 'struct access_coordinate'

Dave Jiang <dave.jiang@intel.com>
    acpi: numa: Add setting of generic port system locality attributes

Dave Jiang <dave.jiang@intel.com>
    acpi: Break out nesting for hmat_parse_locality()

Dave Jiang <dave.jiang@intel.com>
    acpi: numa: Add genport target allocation to the HMAT parsing

Dave Jiang <dave.jiang@intel.com>
    acpi: numa: Create enum for memory_target access coordinates indexing

Dave Jiang <dave.jiang@intel.com>
    base/node / acpi: Change 'node_hmem_attrs' to 'access_coordinates'

Huang Ying <ying.huang@intel.com>
    acpi, hmat: calculate abstract distance with HMAT

Huang Ying <ying.huang@intel.com>
    acpi, hmat: refactor hmat_register_target_initiators()

Huang Ying <ying.huang@intel.com>
    memory tiering: add abstract distance calculation algorithms management

Haein Lee <lhi0729@kaist.ac.kr>
    ALSA: usb-audio: Fix NULL pointer dereference in snd_usb_mixer_controls_badd

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Fix an incorrect parameter when calling nfs4_call_sync()

Yang Xiuwei <yangxiuwei@kylinos.cn>
    NFS: sysfs: fix leak when nfs_client kobject add fails

Trond Myklebust <trond.myklebust@hammerspace.com>
    pnfs: Set transport security policy to RPC_XPRTSEC_NONE unless using TLS

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: enable nconnect for RDMA

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

David Howells <dhowells@redhat.com>
    cifs: Fix uncached read into ITER_KVEC iterator

Shyam Prasad N <sprasad@microsoft.com>
    cifs: stop writeback extension when change of size is detected

Pauli Virtanen <pav@iki.fi>
    Bluetooth: L2CAP: export l2cap_chan_hold for modules

Gautham R. Shenoy <gautham.shenoy@amd.com>
    ACPI: CPPC: Limit perf ctrs in PCC check only to online CPUs

Gautham R. Shenoy <gautham.shenoy@amd.com>
    ACPI: CPPC: Perform fast check switch only for online CPUs

Gautham R. Shenoy <gautham.shenoy@amd.com>
    ACPI: CPPC: Check _CPC validity for only the online CPUs

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

Wei Fang <wei.fang@nxp.com>
    net: fec: correct rx_bytes statistic for the case SHIFT16 is set

Alexander Sverdlin <alexander.sverdlin@siemens.com>
    selftests: net: local_termination: Wait for interfaces to come up

Nicolas Escande <nico.escande@gmail.com>
    wifi: ath11k: zero init info->status in wmi_process_mgmt_tx_comp()

Sharique Mohammad <sharq0406@gmail.com>
    ASoC: max98090/91: fixed max98091 ALSA widget powering up/down

ZhangGuoDong <zhangguodong@kylinos.cn>
    smb/server: fix possible refcount leak in smb2_sess_setup()

ZhangGuoDong <zhangguodong@kylinos.cn>
    smb/server: fix possible memory leak in smb2_read()

Oleg Makarenko <oleg@makarenk.ooo>
    HID: quirks: Add ALWAYS_POLL quirk for VRS R295 steering wheel

Scott Mayhew <smayhew@redhat.com>
    NFS: check if suid/sgid was cleared after a write as needed

Tristan Lobb <tristan.lobb@it-lobb.de>
    HID: quirks: avoid Cooler Master MM712 dongle wakeup bug

Joshua Watt <jpewhacker@gmail.com>
    NFS4: Fix state renewals missing after boot

Jesse.Zhang <Jesse.Zhang@amd.com>
    drm/amdgpu: Fix NULL pointer dereference in VRAM logic for APU devices

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/pm: Disable MCLK switching on SI at high pixel clocks

Han Gao <rabenda.cn@gmail.com>
    riscv: acpi: avoid errors caused by probing DT devices when ACPI is used

Danil Skrebenkov <danil.skrebenkov@cloudbear.ru>
    RISC-V: clear hot-unplugged cores from all task mm_cpumasks to avoid rfence errors

Peter Zijlstra <peterz@infradead.org>
    compiler_types: Move unused static inline functions warning to W=2

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

Jakub Kicinski <kuba@kernel.org>
    selftests: netdevsim: set test timeout to 10 minutes

Clément Léger <cleger@rivosinc.com>
    riscv: stacktrace: fix backtracing through exceptions

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Fix black screen with HDMI outputs

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amdgpu: Fix function header names in amdgpu_connectors.c

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    extcon: adc-jack: Cleanup wakeup source only if it was enabled

Adrian Hunter <adrian.hunter@intel.com>
    scsi: ufs: ufs-pci: Fix S0ix/S3 for Intel controllers

Nathan Chancellor <nathan@kernel.org>
    lib/crypto: curve25519-hacl64: Fix older clang KASAN workaround for GCC

Bui Quang Minh <minhquangbui99@gmail.com>
    virtio-net: fix received length check in big packets

Henrique Carvalho <henrique.carvalho@suse.com>
    smb: client: fix potential UAF in smb2_close_cached_fid()

Joshua Rogers <linux@joshua.hu>
    smb: client: validate change notify buffer before copy

Mario Limonciello (AMD) <superm1@kernel.org>
    x86/microcode/AMD: Add more known models to entry sign checking

Yuta Hayama <hayama@lineo.co.jp>
    rtc: rx8025: fix incorrect register reference

Ilia Gavrilov <Ilia.Gavrilov@infotecs.ru>
    Bluetooth: MGMT: Fix OOB access in parse_adv_monitor_pattern()

Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>
    drm/sched: Fix deadlock in drm_sched_entity_kill_jobs_cb

Wayne Lin <Wayne.Lin@amd.com>
    drm/amd/display: Enable mst when it's detected but yet to be initialized

Zilin Guan <zilin@seu.edu.cn>
    tracing: Fix memory leaks in create_field_var()

Nikolay Aleksandrov <razor@blackwall.org>
    net: bridge: fix MST static key usage

Nikolay Aleksandrov <razor@blackwall.org>
    net: bridge: fix use-after-free due to MST port state bypass

Horatiu Vultur <horatiu.vultur@microchip.com>
    lan966x: Fix sleeping in atomic context

Tristram Ha <tristram.ha@microchip.com>
    net: dsa: microchip: Fix reserved multicast address table programming

Dragos Tatulea <dtatulea@nvidia.com>
    net/mlx5e: SHAMPO, Fix skb size check for 64K pages

Gal Pressman <gal@nvidia.com>
    net/mlx5e: Fix return value in case of module EEPROM read error

Gal Pressman <gal@nvidia.com>
    net/mlx5e: Use extack in get module eeprom by page callback

Martin Willi <martin@strongswan.org>
    wifi: mac80211_hwsim: Limit destroy_on_close radio removal to netgroup

Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
    bnxt_en: Fix a possible memory leak in bnxt_ptp_init

Qendrim Maxhuni <qendrim.maxhuni@garderos.com>
    net: usb: qmi_wwan: initialize MAC header offset in qmimux_rx_fixup

Stefan Wiehler <stefan.wiehler@nokia.com>
    sctp: Hold sock lock while iterating over address list

Stefan Wiehler <stefan.wiehler@nokia.com>
    sctp: Prevent TOCTOU out-of-bounds write

Stefan Wiehler <stefan.wiehler@nokia.com>
    sctp: Hold RCU read lock while iterating over address list

Jonas Gorski <jonas.gorski@gmail.com>
    net: dsa: b53: stop reading ARL entries if search is done

Jonas Gorski <jonas.gorski@gmail.com>
    net: dsa: b53: fix enabling ip multicast

Jonas Gorski <jonas.gorski@gmail.com>
    net: dsa: b53: fix resetting speed and pause on forced link

Hangbin Liu <liuhangbin@gmail.com>
    net: vlan: sync VLAN features with lower device

Wang Liang <wangliang74@huawei.com>
    selftests: netdevsim: Fix ethtool-coalesce.sh fail by installing ethtool-common.sh

David Wei <dw@davidwei.uk>
    netdevsim: add Makefile for selftests

Anubhav Singh <anubhavsinggh@google.com>
    selftests/net: use destination options instead of hop-by-hop

Richard Gobert <richardbgobert@gmail.com>
    selftests/net: fix GRO coalesce test and add ext header coalesce tests

Anubhav Singh <anubhavsinggh@google.com>
    selftests/net: fix out-of-order delivery of FIN in gro:tcp test

Jonas Gorski <jonas.gorski@gmail.com>
    net: dsa: tag_brcm: legacy: fix untagged rx on unbridged ports for bcm63xx

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    Bluetooth: btrtl: Fix memory leak in rtlbt_parse_firmware_v2()

Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>
    Bluetooth: hci_event: validate skb length for unknown CC opcode

Josephine Pfeiffer <hi@josie.lol>
    riscv: ptdump: use seq_puts() in pt_dump_seq_puts() macro

Chunyan Zhang <zhangchunyan@iscas.ac.cn>
    riscv: stacktrace: Disable KASAN checks for non-current tasks

Anton Blanchard <antonb@tenstorrent.com>
    riscv: Improve exception and system call latency

Jiawen Wu <jiawenwu@trustnetic.com>
    net: libwx: fix device bus LAN ID

Baochen Qiang <baochen.qiang@oss.qualcomm.com>
    Revert "wifi: ath10k: avoid unnecessary wait for service ready message"

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Use heuristic to find stream entity

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek: Audio disappears on HP 15-fc000 after warm boot again

Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
    ceph: refactor wake_up_bit() pattern of calling

Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
    ceph: add checking of wait_for_completion_killable() return value

Valerio Setti <vsetti@baylibre.com>
    ASoC: meson: aiu-encoder-i2s: fix bit clock polarity

Geert Uytterhoeven <geert@linux-m68k.org>
    kbuild: uapi: Strip comments before size type check

Bruno Thomsen <bruno.thomsen@gmail.com>
    rtc: pcf2127: fix watchdog interrupt mask on pcf2131

Albin Babu Varghese <albinbabuvarghese20@gmail.com>
    fbdev: Add bounds checking in bit_putcs to fix vmalloc-out-of-bounds

Sascha Hauer <s.hauer@pengutronix.de>
    tools: lib: thermal: use pkg-config to locate libnl3

Emil Dahl Juhl <juhl.emildahl@gmail.com>
    tools: lib: thermal: don't preserve owner in install

Ian Rogers <irogers@google.com>
    tools bitmap: Add missing asm-generic/bitsperlong.h include

Sakari Ailus <sakari.ailus@linux.intel.com>
    ACPI: property: Return present device nodes only on fwnode interface

Hoyoung Seo <hy50.seo@samsung.com>
    scsi: ufs: core: Include UTP error in INT_FATAL_ERRORS

Randall P. Embry <rpembry@gmail.com>
    9p: sysfs_init: don't hardcode error to ENOMEM

Aaron Kling <webgeek1234@gmail.com>
    cpufreq: tegra186: Initialize all cores to max frequencies

Randall P. Embry <rpembry@gmail.com>
    9p: fix /sys/fs/9p/caches overwriting itself

Jerome Brunet <jbrunet@baylibre.com>
    NTB: epf: Allow arbitrary BAR mapping

Matthias Schiffer <matthias.schiffer@tq-group.com>
    clk: ti: am33xx: keep WKUP_DEBUGSS_CLKCTRL enabled

Nicolas Ferre <nicolas.ferre@microchip.com>
    clk: at91: clk-sam9x60-pll: force write to PLL_UPDT register

Ryan Wanner <Ryan.Wanner@microchip.com>
    clk: at91: clk-master: Add check for divide by 3

Nicolas Ferre <nicolas.ferre@microchip.com>
    ARM: at91: pm: save and restore ACR during PLL disable/enable

Josua Mayer <josua@solid-run.com>
    rtc: pcf2127: clear minute/second interrupt

Chen-Yu Tsai <wens@csie.org>
    clk: sunxi-ng: sun6i-rtc: Add A523 specifics

Tiwei Bie <tiwei.btw@antgroup.com>
    um: Fix help message for ssl-non-raw

Yikang Yue <yikangy2@illinois.edu>
    fs/hpfs: Fix error code for new_inode() failure in mkdir/create/mknod/symlink

austinchang <austinchang@synology.com>
    btrfs: mark dirty extent range for out of bound prealloc extents

Junxian Huang <huangjunxian6@hisilicon.com>
    RDMA/hns: Fix wrong WQE data when QP wraps around

wenglianfa <wenglianfa@huawei.com>
    RDMA/hns: Fix the modification of max_send_sge

Jacob Moroni <jmoroni@google.com>
    RDMA/irdma: Set irdma_cq cq_num field during CQ create

Jacob Moroni <jmoroni@google.com>
    RDMA/irdma: Remove unused struct irdma_cq fields

Jacob Moroni <jmoroni@google.com>
    RDMA/irdma: Fix SD index calculation

Saket Dumbre <saket.dumbre@intel.com>
    ACPICA: Update dsmethod.c to get rid of unused variable warning

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    char: misc: restrict the dynamic range to exclude reserved minors

Coiby Xu <coxu@redhat.com>
    ima: don't clear IMA_DIGSIG flag when setting or removing non-IMA xattr

Fiona Ebner <f.ebner@proxmox.com>
    smb: client: transport: avoid reconnects triggered by pending task work

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: use sock_create_kern interface to create kernel socket

Vladimir Riabchun <ferr.lambarginio@gmail.com>
    ftrace: Fix softlockup in ftrace_module_enable

Mike Marshall <hubcap@omnibond.com>
    orangefs: fix xattr related buffer overflow...

Dragos Tatulea <dtatulea@nvidia.com>
    page_pool: Clamp pool size to max 16K pages

Qingfang Deng <dqfext@gmail.com>
    6pack: drop redundant locking and refcounting

Chi Zhiling <chizhiling@kylinos.cn>
    exfat: limit log print for IO error

Roy Vegard Ovesen <roy.vegard.ovesen@gmail.com>
    ALSA: usb-audio: add mono main switch to Presonus S1824c

Ivan Pravdin <ipravdin.official@gmail.com>
    Bluetooth: bcsp: receive data only if registered

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: SCO: Fix UAF on sco_conn_free

Arkadiusz Bokowy <arkadiusz.bokowy@gmail.com>
    Bluetooth: btusb: Check for unexpected bytes when defragmenting HCI frames

Théo Lebrun <theo.lebrun@bootlin.com>
    net: macb: avoid dealing with endianness in macb_set_hwaddr()

Carolina Jubran <cjubran@nvidia.com>
    net/mlx5e: Don't query FEC statistics when FEC is disabled

Primoz Fiser <primoz.fiser@norik.com>
    ASoC: tlv320aic3x: Fix class-D initialization for tlv320aic3007

Olivier Moysan <olivier.moysan@foss.st.com>
    ASoC: stm32: sai: manage context in set_sysclk callback

Yifan Zhang <yifan1.zhang@amd.com>
    amd/amdkfd: resolve a race in amdgpu_amdkfd_device_fini_sw

Julian Sun <sunjunchao@bytedance.com>
    ext4: increase IO priority of fastcommit

chuguangqing <chuguangqing@inspur.com>
    fs: ext4: change GFP_KERNEL to GFP_NOFS to avoid deadlock

Moti Haimovski <moti.haimovski@intel.com>
    accel/habanalabs: support mapping cb with vmalloc-backed coherent memory

Konstantin Sinyuk <konstantin.sinyuk@intel.com>
    accel/habanalabs/gaudi2: read preboot status after recovering from dirty state

Tomer Tayar <tomer.tayar@intel.com>
    accel/habanalabs: return ENOMEM if less than requested pages were pinned

Ranjan Kumar <ranjan.kumar@broadcom.com>
    scsi: mpt3sas: Add support for 22.5 Gbps SAS link rate

Vered Yavniely <vered.yavniely@intel.com>
    accel/habanalabs/gaudi2: fix BMON disable configuration

Alok Tiwari <alok.a.tiwari@oracle.com>
    scsi: libfc: Fix potential buffer overflow in fc_ct_ms_fill()

Petr Machata <petrm@nvidia.com>
    net: bridge: Install FDB for bridge MAC on VLAN 0

Al Viro <viro@zeniv.linux.org.uk>
    nfs4_setup_readdir(): insufficient locking for ->d_parent->d_inode dereferencing

Anthony Iliopoulos <ailiop@suse.com>
    NFSv4.1: fix mount hang after CREATE_SESSION failure

Olga Kornievskaia <okorniev@redhat.com>
    NFSv4: handle ERR_GRACE on delegation recalls

Karthi Kandasamy <karthi.kandasamy@amd.com>
    drm/amd/display: Add AVI infoframe copy in copy_stream_update_to_stream

Nithyanantham Paramasivam <nithyanantham.paramasivam@oss.qualcomm.com>
    wifi: ath12k: Increase DP_REO_CMD_RING_SIZE to 256

Stephan Gerhold <stephan.gerhold@linaro.org>
    remoteproc: qcom: q6v5: Avoid handling handover twice

Mario Limonciello <mario.limonciello@amd.com>
    PCI/PM: Skip resuming to D0 if device is disconnected

Alex Mastro <amastro@fb.com>
    vfio: return -ENOTTY for unsupported device feature

Al Viro <viro@zeniv.linux.org.uk>
    sparc64: fix prototypes of reads[bwl]()

Koakuma <koachan@protonmail.com>
    sparc/module: Add R_SPARC_UA64 relocation handling

Chen Wang <unicorn_wang@outlook.com>
    PCI: cadence: Check for the existence of cdns_pcie::ops before using it

ChunHao Lin <hau@realtek.com>
    r8169: set EEE speed down ratio to 1

Brahmajit Das <listout@listout.xyz>
    net: intel: fm10k: Fix parameter idx set but not used

Loic Poulain <loic.poulain@oss.qualcomm.com>
    wifi: ath10k: Fix connection after GTK rekeying

Seyediman Seyedarab <ImanDevel@gmail.com>
    iommu/vt-d: Replace snprintf with scnprintf in dmar_latency_snapshot()

Robert Marko <robert.marko@sartura.hr>
    net: ethernet: microchip: sparx5: make it selectable for ARCH_LAN969X

Oleksij Rempel <o.rempel@pengutronix.de>
    net: phy: clear link parameters on admin link down

Alexey Klimov <alexey.klimov@linaro.org>
    ASoC: qcom: sc8280xp: explicitly set S16LE format in sc8280xp_be_hw_params_fixup()

Shaurya Rane <ssrane_b23@ee.vjti.ac.in>
    jfs: fix uninitialized waitqueue in transaction manager

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    jfs: Verify inode mode when loading from disk

Tatyana Nikolova <tatyana.e.nikolova@intel.com>
    RDMA/irdma: Update Kconfig

Eric Dumazet <edumazet@google.com>
    ipv6: np->rxpmtu race annotation

wangzijie <wangzijie1@honor.com>
    f2fs: fix infinite loop in __insert_extent_tree()

Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>
    usb: xhci: plat: Facilitate using autosuspend for xhci plat devices

Forest Crossman <cyrozap@gmail.com>
    usb: mon: Increase BUFF_MAX to 64 MiB to support multi-MB URBs

Al Viro <viro@zeniv.linux.org.uk>
    allow finish_no_open(file, ERR_PTR(-E...))

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Define size of debugfs entry for xri rebalancing

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Remove ndlp kref decrement clause for F_Port_Ctrl in lpfc_cleanup

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Check return status of lpfc_reset_flush_io_context during TGT_RESET

Bart Van Assche <bvanassche@acm.org>
    scsi: ufs: core: Disable timestamp functionality if not supported

Nai-Chen Cheng <bleach1827@gmail.com>
    selftests/Makefile: include $(INSTALL_DEP_TARGETS) in clean target to clean net/lib dependency

Christian König <christian.koenig@amd.com>
    drm/amdgpu: reject gang submissions under SRIOV

Mario Limonciello (AMD) <superm1@kernel.org>
    HID: i2c-hid: Resolve touchpad issues on Dell systems during S4

Stefan Wahren <wahrenst@gmx.net>
    ethernet: Extend device_get_mac_address() to use NVMEM

Jakub Kicinski <kuba@kernel.org>
    page_pool: always add GFP_NOWARN for ATOMIC allocations

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Disable VRR on DCE 6

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Fix DVI-D/HDMI adapters

Mario Limonciello (AMD) <superm1@kernel.org>
    drm/amd: Avoid evicting resources at S5

Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
    drm/amdgpu: Use memdup_array_user in amdgpu_cs_wait_fences_ioctl

John Keeping <jkeeping@inmusicbrands.com>
    ALSA: serial-generic: remove shared static buffer

Benjamin Lin <benjamin-jw.lin@mediatek.com>
    wifi: mt76: mt7996: Temporarily disable EPCS

Quan Zhou <quan.zhou@mediatek.com>
    wifi: mt76: mt7921: Add 160MHz beamformee capability for mt7922 device

Yafang Shao <laoar.shao@gmail.com>
    net/cls_cgroup: Fix task_get_classid() during qdisc run

Gaurav Jain <gaurav.jain@nxp.com>
    crypto: caam - double the entropy delay interval for retry

Niklas Cassel <cassel@kernel.org>
    PCI: dwc: Verify the single eDMA IRQ in dw_pcie_edma_irq_verify()

Ovidiu Panait <ovidiu.panait.oss@gmail.com>
    crypto: sun8i-ce - remove channel timeout field

Sangwook Shin <sw617.shin@samsung.com>
    watchdog: s3c2410_wdt: Fix max_timeout being calculated larger

Antheas Kapenekakis <lkml@antheas.dev>
    HID: asus: add Z13 folio to generic group for multitouch to work

Alok Tiwari <alok.a.tiwari@oracle.com>
    udp_tunnel: use netdev_warn() instead of netdev_WARN()

David Ahern <dsahern@kernel.org>
    selftests: Replace sleep with slowwait

Daniel Palmer <daniel@thingy.jp>
    eth: 8139too: Make 8139TOO_PIO depend on !NO_IOPORT_MAP

David Ahern <dsahern@kernel.org>
    selftests: Disable dad for ipv6 in fcnal-test.sh

Li RongQing <lirongqing@baidu.com>
    x86/kvm: Prefer native qspinlock for dedicated vCPUs irrespective of PV_UNHALT

Florian Westphal <fw@strlen.de>
    netfilter: nf_reject: don't reply to icmp error messages

Ido Schimmel <idosch@nvidia.com>
    selftests: traceroute: Use require_command()

Qianfeng Rong <rongqianfeng@vivo.com>
    media: redrat3: use int type to store negative error codes

Jakub Kicinski <kuba@kernel.org>
    selftests: net: replace sleeps in fcnal-test with waits

Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
    net: sh_eth: Disable WoL if system can not suspend

Michael Riesch <michael.riesch@collabora.com>
    phy: rockchip: phy-rockchip-inno-csidphy: allow writes to grf register 0

Michael Dege <michael.dege@renesas.com>
    phy: renesas: r8a779f0-ether-serdes: add new step added to latest datasheet

Harikrishna Shenoy <h-shenoy@ti.com>
    phy: cadence: cdns-dphy: Enable lower resolutions in dphy

Ilan Peer <ilan.peer@intel.com>
    wifi: mac80211: Fix HE capabilities element check

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    ntfs3: pretend $Extend records as regular files

Peter Wang <peter.wang@mediatek.com>
    scsi: ufs: host: mediatek: Disable auto-hibern8 during power mode changes

Rohan G Thomas <rohan.g.thomas@altera.com>
    net: phy: marvell: Fix 88e1510 downshift counter errata

Peter Wang <peter.wang@mediatek.com>
    scsi: ufs: host: mediatek: Enhance recovery on hibernation exit failure

Peter Wang <peter.wang@mediatek.com>
    scsi: ufs: host: mediatek: Enhance recovery on resume failure

Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
    media: i2c: og01a1b: Specify monochrome media bus format instead of Bayer

Hao Yao <hao.yao@intel.com>
    media: ov08x40: Fix the horizontal flip control

Xion Wang <xion.wang@mediatek.com>
    char: Use list_del_init() in misc_deregister() to reinitialize list pointer

Antonino Maniscalco <antomani103@gmail.com>
    drm/msm: make sure to not queue up recovery more than once

Chen Yufeng <chenyufeng@iie.ac.cn>
    usb: cdns3: gadget: Use-after-free during failed initialization and exit of cdnsp gadget

William Wu <william.wu@rock-chips.com>
    usb: gadget: f_hid: Fix zero length packet transfer

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: add support for cyan skillfish gpu_info

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: don't enable SMU on cyan skillfish

Alex Deucher <alexander.deucher@amd.com>
    drm/amd: add more cyan skillfish PCI ids

Hector Martin <marcan@marcan.st>
    iommu/apple-dart: Clear stream error indicator bits for T8110 DARTs

Ashish Kalra <ashish.kalra@amd.com>
    iommu/amd: Skip enabling command/event buffers for kdump

Colin Foster <colin.foster@in-advantage.com>
    smsc911x: add second read of EEPROM mac when possible corruption seen

Eric Dumazet <edumazet@google.com>
    net: call cond_resched() less often in __release_sock()

Cryolitia PukNgae <cryolitia@uniontech.com>
    ALSA: usb-audio: apply quirk for MOONDROP Quark2

Paul Kocialkowski <paulk@sys-base.io>
    media: verisilicon: Explicitly disable selection api ioctls for decoders

Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
    media: adv7180: Only validate format in querystd

Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
    media: adv7180: Do not write format to device in set_fmt

Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
    media: adv7180: Add missing lock in suspend callback

Juraj Šarinay <juraj@sarinay.com>
    net: nfc: nci: Increase NCI_DATA_TIMEOUT to 3000 ms

Yue Haibing <yuehaibing@huawei.com>
    ipv6: Add sanity checks on ipv6_devconf.rpl_seg_enabled

David Francis <David.Francis@amd.com>
    drm/amdgpu: Allow kfd CRIU with no buffer objects

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    drm/msm/dsi/phy_7nm: Fix missing initial VCO rate

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    drm/msm/dsi/phy: Toggle back buffer resync after preparing PLL

Devendra K Verma <devverma@amd.com>
    dmaengine: dw-edma: Set status for callback_result

Rosen Penev <rosenp@gmail.com>
    dmaengine: mv_xor: match alloc_wc and free_wc

Thomas Andreatta <thomasandreatta2000@gmail.com>
    dmaengine: sh: setup_xref error handling

Miroslav Lichvar <mlichvar@redhat.com>
    ptp: Limit time setting of PTP clocks

Qianfeng Rong <rongqianfeng@vivo.com>
    scsi: pm8001: Use int instead of u32 to store error codes

Qianfeng Rong <rongqianfeng@vivo.com>
    crypto: qat - use kcalloc() in qat_uclo_map_objs_from_mof()

Aleksander Jan Bajkowski <olek2@wp.pl>
    mips: lantiq: danube: rename stp node on EASY50712 reference board

Aleksander Jan Bajkowski <olek2@wp.pl>
    mips: lantiq: xway: sysctrl: rename stp clock

Aleksander Jan Bajkowski <olek2@wp.pl>
    mips: lantiq: danube: add missing device_type in pci node

Aleksander Jan Bajkowski <olek2@wp.pl>
    mips: lantiq: danube: add model to EASY50712 dts

Aleksander Jan Bajkowski <olek2@wp.pl>
    mips: lantiq: danube: add missing properties to cpu node

Timur Kristóf <timur.kristof@gmail.com>
    drm/amdgpu: Respect max pixel clock for HDMI and DVI-D (v2)

Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
    media: fix uninitialized symbol warnings

Amber Lin <Amber.Lin@amd.com>
    drm/amdkfd: Tie UNMAP_LATENCY to queue_preemption

Eric Huang <jinhuieric.huang@amd.com>
    drm/amdkfd: fix vram allocation failure for a special case

Miklos Szeredi <mszeredi@redhat.com>
    fuse: zero initialize inode private data

Heiner Kallweit <hkallweit1@gmail.com>
    net: phy: fixed_phy: let fixed_phy_unregister free the phy_device

Andrew Davis <afd@ti.com>
    remoteproc: wkup_m3: Use devm_pm_runtime_enable() helper

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    extcon: adc-jack: Fix wakeup source leaks on device unbind

Francisco Gutierrez <frankramirez@google.com>
    scsi: pm80xx: Fix race condition caused by static variables

Chandrakanth Patil <chandrakanth.patil@broadcom.com>
    scsi: mpi3mr: Fix controller init failure on fault during queue creation

Ujwal Kundur <ujwal.kundur@gmail.com>
    rds: Fix endianness annotation for RDS_MPATH_HASH

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Add validation of UAC2/UAC3 effect units

Sungho Kim <sungho.kim@furiosa.ai>
    PCI/P2PDMA: Fix incorrect pointer usage in devm_kfree() call

Kuniyuki Iwashima <kuniyu@google.com>
    net: Call trace_sock_exceed_buf_limit() for memcg failure with SK_MEM_RECV.

Oleksij Rempel <o.rempel@pengutronix.de>
    net: stmmac: Correctly handle Rx checksum offload errors

Christoph Paasch <cpaasch@openai.com>
    net: When removing nexthops, don't call synchronize_net if it is not necessary

Zijun Hu <zijun.hu@oss.qualcomm.com>
    char: misc: Does not request module for miscdevice with dynamic minor

Zijun Hu <zijun.hu@oss.qualcomm.com>
    char: misc: Make misc_register() reentry for miscdevice who wants dynamic minor

raub camaioni <raubcameo@gmail.com>
    usb: gadget: f_ncm: Fix MAC assignment NCM ethernet

Haibo Chen <haibo.chen@nxp.com>
    iio: adc: imx93_adc: load calibrated values even calibration failed

Rodrigo Gobbi <rodrigo.gobbi.7@gmail.com>
    iio: adc: spear_adc: mask SPEAR_ADC_STATUS channel and avg sample before setting register

Kent Russell <kent.russell@amd.com>
    drm/amdkfd: Handle lack of READ permissions in SVM mapping

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    drm/bridge: display-connector: don't set OP_DETECT for DisplayPorts

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    media: imon: make send_packet() more robust

Charalampos Mitrodimas <charmitro@posteo.net>
    net: ipv6: fix field-spanning memcpy warning in AH output

Alice Chao <alice.chao@mediatek.com>
    scsi: ufs: host: mediatek: Fix invalid access in vccqx handling

Peter Wang <peter.wang@mediatek.com>
    scsi: ufs: host: mediatek: Change reset sequence for improved stability

Alice Chao <alice.chao@mediatek.com>
    scsi: ufs: host: mediatek: Assign power mode userdata before FASTAUTO mode change

Peter Wang <peter.wang@mediatek.com>
    scsi: ufs: host: mediatek: Fix auto-hibern8 timer configuration

Ido Schimmel <idosch@nvidia.com>
    bridge: Redirect to backup port when port is administratively down

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/pci: Use pci_uevent_ers() in PCI recovery

Niklas Schnelle <schnelle@linux.ibm.com>
    powerpc/eeh: Use result of error_detected() in uevent

Lukas Wunner <lukas@wunner.de>
    thunderbolt: Use is_pciehp instead of is_hotplug_bridge

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    ice: Don't use %pK through printk or tracepoints

Tiezhu Yang <yangtiezhu@loongson.cn>
    net: stmmac: Check stmmac_hw_setup() in stmmac_resume()

Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
    x86/vsyscall: Do not require X86_PF_INSTR to emulate vsyscall

Mehdi Djait <mehdi.djait@linux.intel.com>
    media: i2c: Kconfig: Ensure a dependency on HAVE_CLK for VIDEO_CAMERA_SENSOR

Jayesh Choudhary <j-choudhary@ti.com>
    drm/tidss: Set crtc modesetting parameters with adjusted mode

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    drm/bridge: cdns-dsi: Don't fail on MIPI_DSI_MODE_VIDEO_BURST

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    drm/bridge: cdns-dsi: Fix REG_WAKEUP_TIME value

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    drm/tidss: Use the crtc_* timings when programming the HW

Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
    media: amphion: Delete v4l2_fh synchronously in .release()

Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
    media: pci: ivtv: Don't create fake v4l2_fh

Geoffrey McRae <geoffrey.mcrae@amd.com>
    drm/amdkfd: return -ENOTTY for unsupported IOCTLs

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtw88: sdio: use indirect IO for device registers before power-on

Wake Liu <wakel@google.com>
    selftests/net: Ensure assert() triggers in psock_tpacket.c

Wake Liu <wakel@google.com>
    selftests/net: Replace non-standard __WORDSIZE with sizeof(long) * 8

Marcos Del Sol Vives <marcos@orca.pet>
    PCI: Disable MSI on RDC PCI to PCIe bridges

Seyediman Seyedarab <imandevel@gmail.com>
    drm/nouveau: replace snprintf() with scnprintf() in nvkm_snprintbf()

Sathishkumar S <sathishkumar.sundararaju@amd.com>
    drm/amdgpu/jpeg: Hold pg_lock before jpeg poweroff

Lijo Lazar <lijo.lazar@amd.com>
    drm/amd/pm: Use cached metrics data on arcturus

Lijo Lazar <lijo.lazar@amd.com>
    drm/amd/pm: Use cached metrics data on aldebaran

Paul Hsieh <Paul.Hsieh@amd.com>
    drm/amd/display: update dpp/disp clock from smu clock table

Alex Deucher <alexander.deucher@amd.com>
    drm/amd/display: add more cyan skillfish devices

Michael Strauss <michael.strauss@amd.com>
    drm/amd/display: Increase AUX Intra-Hop Done Max Wait Duration

Clay King <clayking@amd.com>
    drm/amd/display: ensure committing streams is seamless

Jens Kehne <jens.kehne@agilent.com>
    mfd: da9063: Split chip variant reading in two bus transactions

Arnd Bergmann <arnd@arndb.de>
    mfd: madera: Work around false-positive -Wininitialized warning

Alexander Stein <alexander.stein@ew.tq-group.com>
    mfd: stmpe-i2c: Add missing MODULE_LICENSE

Alexander Stein <alexander.stein@ew.tq-group.com>
    mfd: stmpe: Remove IRQ domain upon removal

Len Brown <len.brown@intel.com>
    tools/power x86_energy_perf_policy: Prefer driver HWP limits

Len Brown <len.brown@intel.com>
    tools/power x86_energy_perf_policy: Enhance HWP enable

Kaushlendra Kumar <kaushlendra.kumar@intel.com>
    tools/power x86_energy_perf_policy: Fix incorrect fopen mode usage

Kaushlendra Kumar <kaushlendra.kumar@intel.com>
    tools/cpupower: Fix incorrect size in cpuidle_state_disable()

Armin Wolf <W_Armin@gmx.de>
    hwmon: (dell-smm) Add support for Dell OptiPlex 7040

Ben Copeland <ben.copeland@linaro.org>
    hwmon: (asus-ec-sensors) increase timeout for locking ACPI mutex

Jiri Olsa <jolsa@kernel.org>
    uprobe: Do not emulate/sstep original instruction when ip is changed

Alistair Francis <alistair.francis@wdc.com>
    nvme: Use non zero KATO for persistent discovery connections

Amery Hung <ameryhung@gmail.com>
    bpf: Clear pfmemalloc flag when freeing all fragments

Chenghao Duan <duanchenghao@kylinos.cn>
    riscv: bpf: Fix uninitialized symbol 'retval_off'

Yu Kuai <yukuai3@huawei.com>
    blk-cgroup: fix possible deadlock while configuring policy

Daniel Lezcano <daniel.lezcano@linaro.org>
    clocksource/drivers/vf-pit: Replace raw_readl/writel to readl/writel

Biju Das <biju.das.jz@bp.renesas.com>
    spi: rpc-if: Add resume support for RZ/G3E

Pranav Tyagi <pranav.tyagi03@gmail.com>
    futex: Don't leak robust_list pointer on exec race

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpuidle: Fail cpuidle device registration if there is one already

Tom Stellard <tstellar@redhat.com>
    bpftool: Fix -Wuninitialized-const-pointer warnings with clang >= 21

Fenglin Wu <fenglin.wu@oss.qualcomm.com>
    power: supply: qcom_battmgr: handle charging state change notifications

Janne Grunau <j@jannau.net>
    pmdomain: apple: Add "apple,t8103-pmgr-pwrstate"

Kaushlendra Kumar <kaushlendra.kumar@intel.com>
    tools/cpupower: fix error return value in cpupower_write_sysfs()

Svyatoslav Ryhel <clamor95@gmail.com>
    video: backlight: lp855x_bl: Set correct EPROM start for LP8556

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Do not limit bpf_cgroup_from_id to current's namespace

Daniel Wagner <wagi@kernel.org>
    nvme-fc: use lock accessing port_state and rport state

Daniel Wagner <wagi@kernel.org>
    nvmet-fc: avoid scheduling association deletion twice

Amirreza Zarrabi <amirreza.zarrabi@oss.qualcomm.com>
    tee: allow a driver to allocate a tee_device without a pool

Hans de Goede <hansg@kernel.org>
    ACPICA: dispatcher: Use acpi_ds_clear_operands() in acpi_ds_call_control_method()

Sarthak Garg <quic_sartgarg@quicinc.com>
    mmc: sdhci-msm: Enable tuning for SDR50 mode for SD card

Svyatoslav Ryhel <clamor95@gmail.com>
    ARM: tegra: transformer-20: fix audio-codec interrupt

Svyatoslav Ryhel <clamor95@gmail.com>
    ARM: tegra: transformer-20: add missing magnetometer interrupt

Svyatoslav Ryhel <clamor95@gmail.com>
    soc/tegra: fuse: Add Tegra114 nvmem cells and fuse lookups

Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
    arm64: zynqmp: Revert usb node drive strength and slew rate for zcu106

Ming Wang <wangming01@loongson.cn>
    irqchip/loongson-pch-lpc: Use legacy domain for PCH-LPC IRQ controller

Andreas Kemnade <andreas@kemnade.info>
    hwmon: sy7636a: add alias

Fabien Proriol <fabien.proriol@viavisolutions.com>
    power: supply: sbs-charger: Support multiple devices

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    pinctrl: keembay: release allocated memory in detach path

Chuande Chen <chuachen@cisco.com>
    hwmon: (sbtsi_temp) AMD CPU extended temperature range support

Rong Zhang <i@rong.moe>
    hwmon: (k10temp) Add device ID for Strix Halo

Avadhut Naik <avadhut.naik@amd.com>
    hwmon: (k10temp) Add thermal support for AMD Family 1Ah-based models

Christopher Ruehl <chris.ruehl@gtsys.com.hk>
    power: supply: qcom_battmgr: add OOI chemistry

Hans de Goede <hansg@kernel.org>
    ACPI: scan: Add Intel CVS ACPI HIDs to acpi_ignore_dep_ids[]

Shang song (Lenovo) <shangsong2@foxmail.com>
    ACPI: PRM: Skip handlers with NULL handler_address or NULL VA

Christian Bruel <christian.bruel@foss.st.com>
    irqchip/gic-v2m: Handle Multiple MSI base IRQ Alignment

Ricardo B. Marlière <rbm@suse.com>
    selftests/bpf: Upon failures, exit with code 1 in test_xsk.sh

Kees Cook <kees@kernel.org>
    arc: Fix __fls() const-foldability via __builtin_clzl()

Dennis Beier <nanovim@gmail.com>
    cpufreq/longhaul: handle NULL policy in longhaul_exit

Ricardo B. Marlière <rbm@suse.com>
    selftests/bpf: Fix bpf_prog_detach2 usage in test_lirc_mode2

Inochi Amaoto <inochiama@gmail.com>
    irqchip/sifive-plic: Respect mask state when setting affinity

Jiayi Li <lijiayi@kylinos.cn>
    memstick: Add timeout to prevent indefinite waiting

Biju Das <biju.das.jz@bp.renesas.com>
    mmc: host: renesas_sdhi: Fix the actual clock

Chi Zhang <chizhang@asrmicro.com>
    pinctrl: single: fix bias pull up/down handling in pin_config_set

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    bpf: Don't use %pK through printk

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    spi: loopback-test: Don't use %pK through printk

Jens Reidel <adrian@mainlining.org>
    soc: qcom: smem: Fix endian-unaware access of num_entries

Ryan Chen <ryan_chen@aspeedtech.com>
    soc: aspeed: socinfo: Add AST27xx silicon IDs

Owen Gu <guhuinan@xiaomi.com>
    usb: gadget: f_fs: Fix epfile null pointer access after ep enable.

Gerd Bayer <gbayer@linux.ibm.com>
    s390/pci: Avoid deadlock between PCI error recovery and mlx5 crdump

Thomas Zimmermann <tzimmermann@suse.de>
    drm/sysfb: Do not dereference NULL pointer in plane reset

Philipp Stanner <phasta@kernel.org>
    drm/sched: Fix race in drm_sched_entity_select_rq()

Heiko Carstens <hca@linux.ibm.com>
    s390: Disable ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP

Pierre Gondois <pierre.gondois@arm.com>
    sched/fair: Use all little CPUs for CPU-bound workloads

Vincent Guittot <vincent.guittot@linaro.org>
    sched/pelt: Avoid underestimation of task utilization

Emanuele Ghidoli <emanuele.ghidoli@toradex.com>
    net: phy: dp83867: Disable EEE support as not implemented

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpuidle: governors: menu: Select polling state in some more cases

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpuidle: governors: menu: Rearrange main loop in menu_select()

Farhan Ali <alifm@linux.ibm.com>
    s390/pci: Restore IRQ unconditionally for the zPCI device

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix MSG_PEEK stream corruption

Johan Hovold <johan@kernel.org>
    drm/mediatek: Fix device use-after-free on unbind

Alexey Klimov <alexey.klimov@linaro.org>
    regmap: slimbus: fix bus_context pointer in regmap init calls

Damien Le Moal <dlemoal@kernel.org>
    block: make REQ_OP_ZONE_OPEN a write operation

Damien Le Moal <dlemoal@kernel.org>
    block: fix op_is_zone_mgmt() to handle REQ_OP_ZONE_RESET_ALL

John Smith <itistotalbotnet@gmail.com>
    drm/amd/pm/powerplay/smumgr: Fix PCIeBootLinkLevel value on Iceland

John Smith <itistotalbotnet@gmail.com>
    drm/amd/pm/powerplay/smumgr: Fix PCIeBootLinkLevel value on Fiji

Yang Wang <kevinyang.wang@amd.com>
    drm/amd/pm: fix smu table id bound check issue in smu_cmn_update_table()

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    sfc: fix potential memory leak in efx_mae_process_mport()

Jijie Shao <shaojijie@huawei.com>
    net: hns3: return error code when function fails

Tomeu Vizoso <tomeu@tomeuvizoso.net>
    drm/etnaviv: fix flush sequence logic

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_core: Fix tracking of periodic advertisement

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: ISO: Fix another instance of dst_type handling

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: HCI: Fix tracking of advertisement set/instance 0x00

Chris Lu <chris.lu@mediatek.com>
    Bluetooth: btmtksdio: Add pmctrl handling for BT closed state during reset

Cen Zhang <zzzccc427@163.com>
    Bluetooth: hci_sync: fix race in hci_cmd_sync_dequeue_once

Lizhi Xu <lizhi.xu@windriver.com>
    usbnet: Prevents free active kevent

Andrii Nakryiko <andrii@kernel.org>
    libbpf: Fix powerpc's stack register definition in bpf_tracing.h

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_sai: fix bit order for DSD format

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: avs: Unprepare a stream when XRUN occurs

Haotian Zhang <vulab@iscas.ac.cn>
    crypto: aspeed - fix double free caused by devm

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    crypto: aspeed-acry - Convert to platform remove callback returning void

Ondrej Mosnacek <omosnace@redhat.com>
    bpf: Do not audit capability check in do_jit()

Wonkon Kim <wkon.kim@samsung.com>
    scsi: ufs: core: Initialize value of an attribute returned by uic cmd

Noorain Eqbal <nooraineqbal@gmail.com>
    bpf: Sync pending IRQ work before freeing ring buffer

Roy Vegard Ovesen <roy.vegard.ovesen@gmail.com>
    ALSA: usb-audio: fix control pipe direction

Akhil P Oommen <akhilpo@oss.qualcomm.com>
    drm/msm/a6xx: Fix GMU firmware parser

Karthik M <quic_karm@quicinc.com>
    wifi: ath12k: free skb during idr cleanup callback

Mark Pearson <mpearson-lenovo@squebb.ca>
    wifi: ath11k: Add missing platform IDs for quirk table

Loic Poulain <loic.poulain@oss.qualcomm.com>
    wifi: ath10k: Fix memory leak on unsupported WMI command

Chang S. Bae <chang.seok.bae@intel.com>
    x86/fpu: Ensure XFD state on signal delivery

Henrique Carvalho <henrique.carvalho@suse.com>
    smb: client: fix potential cfid UAF in smb2_query_info_compound

Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
    ASoC: qdsp6: q6asm: do not sleep while atomic

Paolo Abeni <pabeni@redhat.com>
    mptcp: restore window probe

Paolo Abeni <pabeni@redhat.com>
    mptcp: drop bogus optimization in __mptcp_check_push()

Miaoqian Lin <linmq006@gmail.com>
    fbdev: valkyriefb: Fix reference count leak in valkyriefb_init

Florian Fuchs <fuchsfl@gmail.com>
    fbdev: pvr2fb: Fix leftover reference to ONCHIP_NR_DMA_CHANNELS

Gokul Sivakumar <gokulkumar.sivakumar@infineon.com>
    wifi: brcmfmac: fix crash while sending Action Frames in standalone AP Mode

Johan Hovold <johan@kernel.org>
    Bluetooth: rfcomm: fix modem control handling

Junjie Cao <junjie.cao@intel.com>
    fbdev: bitblit: bound-check glyph index in bit_putcs*

Kaushlendra Kumar <kaushlendra.kumar@intel.com>
    ACPI: button: Call input_free_device() on failing input device registration

Yuhao Jiang <danisjiang@gmail.com>
    ACPI: video: Fix use-after-free in acpi_video_switch_brightness()

Daniel Palmer <daniel@0x0f.com>
    fbdev: atyfb: Check if pll_ops->init_pll failed

Quanmin Yan <yanquanmin1@huawei.com>
    fbcon: Set fb_display[i]->mode to NULL when the mode is released

Miaoqian Lin <linmq006@gmail.com>
    net: usb: asix_devices: Check return value of usbnet_get_endpoints

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Fix crash in nfsd4_read_release()


-------------

Diffstat:

 Documentation/admin-guide/cgroup-v2.rst            |   9 +
 MAINTAINERS                                        |   1 +
 Makefile                                           |   4 +-
 arch/arc/include/asm/bitops.h                      |   2 +
 .../boot/dts/broadcom/bcm47189-luxul-xap-1440.dts  |   4 +-
 arch/arm/boot/dts/nvidia/tegra20-asus-tf101.dts    |   5 +-
 arch/arm/boot/dts/nxp/imx/imx51-zii-rdu1.dts       |   4 +-
 arch/arm/crypto/Kconfig                            |   2 +-
 arch/arm/mach-at91/pm_suspend.S                    |   8 +-
 arch/arm64/boot/dts/rockchip/rk3568-odroid-m1.dts  |   2 +
 arch/arm64/boot/dts/xilinx/zynqmp-zcu106-revA.dts  |   4 +-
 arch/loongarch/include/asm/hw_breakpoint.h         |   4 +-
 arch/loongarch/include/asm/pgtable.h               |  11 +-
 arch/loongarch/kernel/traps.c                      |   4 +-
 arch/mips/boot/dts/lantiq/danube.dtsi              |   6 +
 arch/mips/boot/dts/lantiq/danube_easy50712.dts     |   4 +-
 arch/mips/lantiq/xway/sysctrl.c                    |   2 +-
 arch/powerpc/kernel/eeh_driver.c                   |   2 +-
 arch/riscv/kernel/cpu-hotplug.c                    |   1 +
 arch/riscv/kernel/entry.S                          |  18 +-
 arch/riscv/kernel/setup.c                          |   7 +-
 arch/riscv/kernel/stacktrace.c                     |  27 +-
 arch/riscv/mm/ptdump.c                             |   2 +-
 arch/riscv/net/bpf_jit_comp64.c                    |   5 +-
 arch/s390/Kconfig                                  |   1 -
 arch/s390/include/asm/pci.h                        |   1 -
 arch/s390/pci/pci_event.c                          |   7 +-
 arch/s390/pci/pci_irq.c                            |   9 +-
 arch/sparc/include/asm/elf_64.h                    |   1 +
 arch/sparc/include/asm/io_64.h                     |   6 +-
 arch/sparc/kernel/module.c                         |   1 +
 arch/um/drivers/ssl.c                              |   5 +-
 arch/x86/entry/vsyscall/vsyscall_64.c              |  17 +-
 arch/x86/kernel/cpu/microcode/amd.c                |   3 +
 arch/x86/kernel/fpu/core.c                         |   3 +
 arch/x86/kernel/kvm.c                              |  20 +-
 arch/x86/kvm/svm/svm.c                             |   4 +
 arch/x86/net/bpf_jit_comp.c                        |   2 +-
 block/blk-cgroup.c                                 |  23 +-
 drivers/accel/habanalabs/common/memory.c           |   2 +-
 drivers/accel/habanalabs/gaudi/gaudi.c             |  19 +
 drivers/accel/habanalabs/gaudi2/gaudi2.c           |  15 +-
 drivers/accel/habanalabs/gaudi2/gaudi2_coresight.c |   2 +-
 drivers/acpi/acpi_video.c                          |   4 +-
 drivers/acpi/acpica/dsmethod.c                     |  10 +-
 drivers/acpi/button.c                              |   4 +-
 drivers/acpi/cppc_acpi.c                           |   6 +-
 drivers/acpi/numa/hmat.c                           | 322 ++++++++++-----
 drivers/acpi/numa/srat.c                           |   2 +-
 drivers/acpi/prmt.c                                |  19 +-
 drivers/acpi/property.c                            |  24 +-
 drivers/acpi/scan.c                                |   2 +
 drivers/base/node.c                                |  18 +-
 drivers/base/regmap/regmap-slimbus.c               |   6 +-
 drivers/bluetooth/btmtksdio.c                      |  12 +
 drivers/bluetooth/btrtl.c                          |   4 +-
 drivers/bluetooth/btusb.c                          |  30 +-
 drivers/bluetooth/hci_bcsp.c                       |   3 +
 drivers/char/misc.c                                |  40 +-
 drivers/clk/at91/clk-master.c                      |   3 +
 drivers/clk/at91/clk-sam9x60-pll.c                 |  75 ++--
 drivers/clk/sunxi-ng/ccu-sun6i-rtc.c               |  11 +
 drivers/clk/ti/clk-33xx.c                          |   2 +
 drivers/clocksource/timer-vf-pit.c                 |  22 +-
 drivers/cpufreq/longhaul.c                         |   3 +
 drivers/cpufreq/tegra186-cpufreq.c                 |  27 +-
 drivers/cpuidle/cpuidle.c                          |   8 +-
 drivers/cpuidle/governors/menu.c                   |  79 ++--
 .../crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c    |   1 -
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c  |   5 +-
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c  |   2 -
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c  |   1 -
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-trng.c  |   1 -
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h       |   2 +-
 drivers/crypto/aspeed/aspeed-acry.c                |   8 +-
 drivers/crypto/caam/ctrl.c                         |   4 +-
 drivers/crypto/hisilicon/qm.c                      |   2 +
 drivers/crypto/intel/qat/qat_common/qat_uclo.c     |   2 +-
 drivers/dma/dw-edma/dw-edma-core.c                 |  22 ++
 drivers/dma/mv_xor.c                               |   4 +-
 drivers/dma/sh/shdma-base.c                        |  25 +-
 drivers/dma/sh/shdmac.c                            |  17 +-
 drivers/edac/altera_edac.c                         |  22 +-
 drivers/extcon/extcon-adc-jack.c                   |   2 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c     |  66 +++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c             |  23 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   8 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c      |   5 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |   5 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_jpeg.c           |   6 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c            |   7 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c            |   5 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c           |   4 +-
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c           |  19 +-
 drivers/gpu/drm/amd/amdkfd/kfd_device.c            |  10 +-
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h              |   9 +-
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c               |  23 ++
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  14 +-
 .../drm/amd/display/dc/clk_mgr/dcn301/vg_clk_mgr.c |  16 +
 drivers/gpu/drm/amd/display/dc/core/dc.c           |  19 +-
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c  |  14 +-
 drivers/gpu/drm/amd/display/dc/dc_helper.c         |   5 +
 drivers/gpu/drm/amd/display/dc/dc_stream.h         |   3 +
 drivers/gpu/drm/amd/display/dc/dm_services.h       |   2 +
 .../gpu/drm/amd/display/dc/dml/dcn301/dcn301_fpu.c |  20 +-
 .../gpu/drm/amd/display/dc/link/link_detection.c   |   5 +
 .../display/dc/link/protocols/link_dp_training.c   |   9 +-
 drivers/gpu/drm/amd/display/include/dal_asic_id.h  |   5 +
 drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c         |   5 +
 .../gpu/drm/amd/pm/powerplay/smumgr/fiji_smumgr.c  |   2 +-
 .../drm/amd/pm/powerplay/smumgr/iceland_smumgr.c   |   2 +-
 drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c  |   2 +-
 drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c |   2 +-
 drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c             |   2 +-
 drivers/gpu/drm/bridge/cadence/cdns-dsi-core.c     |  12 +-
 drivers/gpu/drm/bridge/display-connector.c         |   3 +-
 drivers/gpu/drm/drm_gem_atomic_helper.c            |   6 +-
 drivers/gpu/drm/etnaviv/etnaviv_buffer.c           |   2 +-
 drivers/gpu/drm/i915/gt/intel_gt_clock_utils.c     |   4 +-
 drivers/gpu/drm/i915/i915_vma.c                    |  16 +-
 drivers/gpu/drm/mediatek/mtk_drm_drv.c             |  10 -
 drivers/gpu/drm/mediatek/mtk_drm_plane.c           |  24 +-
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c              |   5 +-
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c              |   3 +
 drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c          |  10 +
 drivers/gpu/drm/nouveau/nvkm/core/enum.c           |   2 +-
 drivers/gpu/drm/scheduler/sched_entity.c           |  37 +-
 drivers/gpu/drm/tidss/tidss_crtc.c                 |   7 +-
 drivers/gpu/drm/tidss/tidss_dispc.c                |  16 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c            |   5 +
 drivers/hid/hid-asus.c                             |   6 +-
 drivers/hid/hid-ids.h                              |   6 +-
 drivers/hid/hid-ntrig.c                            |   7 +-
 drivers/hid/hid-quirks.c                           |   2 +
 drivers/hid/hid-uclogic-params.c                   |   4 +-
 drivers/hid/i2c-hid/i2c-hid-acpi.c                 |   8 +
 drivers/hid/i2c-hid/i2c-hid-core.c                 |  28 +-
 drivers/hid/i2c-hid/i2c-hid.h                      |   2 +
 drivers/hwmon/asus-ec-sensors.c                    |   2 +-
 drivers/hwmon/dell-smm-hwmon.c                     |   7 +
 drivers/hwmon/k10temp.c                            |  10 +
 drivers/hwmon/sbtsi_temp.c                         |  46 ++-
 drivers/hwmon/sy7636a-hwmon.c                      |   1 +
 drivers/iio/adc/imx93_adc.c                        |  18 +-
 drivers/iio/adc/spear_adc.c                        |   9 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |  11 +-
 drivers/infiniband/hw/hns/hns_roce_qp.c            |   2 -
 drivers/infiniband/hw/irdma/Kconfig                |   7 +-
 drivers/infiniband/hw/irdma/pble.c                 |   2 +-
 drivers/infiniband/hw/irdma/verbs.c                |   4 +-
 drivers/infiniband/hw/irdma/verbs.h                |   8 +-
 drivers/iommu/amd/init.c                           |  28 +-
 drivers/iommu/apple-dart.c                         |   5 +
 drivers/iommu/intel/debugfs.c                      |  10 +-
 drivers/iommu/intel/perf.c                         |  10 +-
 drivers/iommu/intel/perf.h                         |   5 +-
 drivers/iommu/iommufd/io_pagetable.c               |  12 +-
 drivers/iommu/iommufd/ioas.c                       |   4 +
 drivers/irqchip/irq-gic-v2m.c                      |  13 +-
 drivers/irqchip/irq-loongson-pch-lpc.c             |   9 +-
 drivers/irqchip/irq-riscv-intc.c                   |   3 +-
 drivers/irqchip/irq-sifive-plic.c                  |   6 +-
 drivers/isdn/hardware/mISDN/hfcsusb.c              |  18 +-
 drivers/media/i2c/Kconfig                          |   2 +-
 drivers/media/i2c/adv7180.c                        |  48 +--
 drivers/media/i2c/ir-kbd-i2c.c                     |   6 +-
 drivers/media/i2c/og01a1b.c                        |   6 +-
 drivers/media/i2c/ov08x40.c                        |   2 +-
 drivers/media/pci/ivtv/ivtv-alsa-pcm.c             |   2 -
 drivers/media/pci/ivtv/ivtv-driver.h               |   3 +-
 drivers/media/pci/ivtv/ivtv-fileops.c              |  18 +-
 drivers/media/pci/ivtv/ivtv-irq.c                  |   4 +-
 drivers/media/platform/amphion/vpu_v4l2.c          |   7 +-
 drivers/media/platform/verisilicon/hantro_drv.c    |   2 +
 drivers/media/platform/verisilicon/hantro_v4l2.c   |   6 +-
 drivers/media/rc/imon.c                            |  61 +--
 drivers/media/rc/redrat3.c                         |   2 +-
 drivers/media/tuners/xc4000.c                      |   8 +-
 drivers/media/tuners/xc5000.c                      |  12 +-
 drivers/media/usb/uvc/uvc_driver.c                 |  15 +-
 drivers/memstick/core/memstick.c                   |   8 +-
 drivers/mfd/da9063-i2c.c                           |  27 +-
 drivers/mfd/madera-core.c                          |   4 +-
 drivers/mfd/stmpe-i2c.c                            |   1 +
 drivers/mfd/stmpe.c                                |   3 +
 drivers/mmc/host/renesas_sdhi_core.c               |   6 +-
 drivers/mmc/host/sdhci-msm.c                       |  15 +
 drivers/mmc/host/sdhci-of-dwcmshc.c                |   2 +-
 drivers/mtd/nand/onenand/onenand_samsung.c         |   2 +-
 drivers/net/dsa/b53/b53_common.c                   |  15 +-
 drivers/net/dsa/b53/b53_regs.h                     |   3 +-
 drivers/net/dsa/dsa_loop.c                         |   9 +-
 drivers/net/dsa/microchip/ksz9477.c                |  98 ++++-
 drivers/net/dsa/microchip/ksz9477_reg.h            |   3 +-
 drivers/net/dsa/microchip/ksz_common.c             |   4 +
 drivers/net/dsa/microchip/ksz_common.h             |   2 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c      |   4 +-
 drivers/net/ethernet/cadence/macb_main.c           |   4 +-
 drivers/net/ethernet/freescale/fec_main.c          |   2 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |   3 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c    |   9 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_mdio.h    |   2 +-
 drivers/net/ethernet/intel/fm10k/fm10k_common.c    |   5 +-
 drivers/net/ethernet/intel/fm10k/fm10k_common.h    |   2 +-
 drivers/net/ethernet/intel/fm10k/fm10k_pf.c        |   2 +-
 drivers/net/ethernet/intel/fm10k/fm10k_vf.c        |   2 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |   2 +-
 drivers/net/ethernet/intel/ice/ice_trace.h         |  10 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c |  33 +-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  10 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |  12 +-
 .../ethernet/microchip/lan966x/lan966x_ethtool.c   |  18 +-
 .../net/ethernet/microchip/lan966x/lan966x_main.c  |   2 -
 .../net/ethernet/microchip/lan966x/lan966x_main.h  |   4 +-
 .../ethernet/microchip/lan966x/lan966x_vcap_impl.c |   8 +-
 drivers/net/ethernet/microchip/sparx5/Kconfig      |   2 +-
 drivers/net/ethernet/realtek/Kconfig               |   2 +-
 drivers/net/ethernet/realtek/r8169_main.c          |   6 +-
 drivers/net/ethernet/renesas/sh_eth.c              |   4 +
 drivers/net/ethernet/sfc/mae.c                     |   4 +
 drivers/net/ethernet/smsc/smsc911x.c               |  14 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  23 +-
 drivers/net/ethernet/wangxun/libwx/wx_hw.c         |   3 +-
 drivers/net/ethernet/wangxun/libwx/wx_type.h       |   4 +-
 drivers/net/hamradio/6pack.c                       |  57 +--
 drivers/net/ipvlan/ipvlan_l3s.c                    |   1 -
 drivers/net/mdio/of_mdio.c                         |   1 -
 drivers/net/phy/dp83867.c                          |   8 +
 drivers/net/phy/fixed_phy.c                        |   1 +
 drivers/net/phy/marvell.c                          |  39 +-
 drivers/net/phy/mdio_bus.c                         |   5 +-
 drivers/net/phy/phy.c                              |  13 +
 drivers/net/usb/asix_devices.c                     |  12 +-
 drivers/net/usb/qmi_wwan.c                         |   6 +
 drivers/net/usb/usbnet.c                           |   2 +
 drivers/net/virtio_net.c                           |  41 +-
 drivers/net/wireless/ath/ath10k/mac.c              |  12 +-
 drivers/net/wireless/ath/ath10k/wmi.c              |  40 +-
 drivers/net/wireless/ath/ath11k/core.c             |  54 ++-
 drivers/net/wireless/ath/ath11k/wmi.c              |   3 +
 drivers/net/wireless/ath/ath12k/dp.h               |   2 +-
 drivers/net/wireless/ath/ath12k/mac.c              |  34 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |   3 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.c |  28 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.h |   3 +-
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |   2 +
 drivers/net/wireless/mediatek/mt76/mt7996/init.c   |   1 -
 drivers/net/wireless/realtek/rtw88/sdio.c          |   4 +
 drivers/net/wireless/virtual/mac80211_hwsim.c      |   7 +-
 drivers/ntb/hw/epf/ntb_hw_epf.c                    | 103 ++---
 drivers/nvme/host/core.c                           |   8 +-
 drivers/nvme/host/fc.c                             |  10 +-
 drivers/nvme/target/fc.c                           |  16 +-
 drivers/pci/controller/cadence/pcie-cadence-host.c |   2 +-
 drivers/pci/controller/cadence/pcie-cadence.c      |   4 +-
 drivers/pci/controller/cadence/pcie-cadence.h      |   6 +-
 drivers/pci/controller/dwc/pcie-designware.c       |   4 +-
 drivers/pci/p2pdma.c                               |   2 +-
 drivers/pci/pci-driver.c                           |   2 +-
 drivers/pci/pci.c                                  |   5 +
 drivers/pci/quirks.c                               |   3 +-
 drivers/phy/cadence/cdns-dphy.c                    |   4 +-
 drivers/phy/renesas/r8a779f0-ether-serdes.c        |  28 ++
 drivers/phy/rockchip/phy-rockchip-inno-csidphy.c   |   5 +-
 drivers/pinctrl/pinctrl-keembay.c                  |   7 +-
 drivers/pinctrl/pinctrl-single.c                   |   4 +-
 drivers/pmdomain/apple/pmgr-pwrstate.c             |   1 +
 drivers/pmdomain/samsung/exynos-pm-domains.c       |  11 +-
 drivers/power/supply/qcom_battmgr.c                |   8 +-
 drivers/power/supply/sbs-charger.c                 |  16 +-
 drivers/ptp/ptp_clock.c                            |  13 +-
 drivers/regulator/fixed.c                          |   1 +
 drivers/remoteproc/qcom_q6v5.c                     |   5 +
 drivers/remoteproc/wkup_m3_rproc.c                 |   6 +-
 drivers/rtc/rtc-pcf2127.c                          |  19 +-
 drivers/rtc/rtc-rx8025.c                           |   2 +-
 drivers/scsi/libfc/fc_encode.h                     |   2 +-
 drivers/scsi/lpfc/lpfc_debugfs.h                   |   3 +
 drivers/scsi/lpfc/lpfc_els.c                       |   6 +-
 drivers/scsi/lpfc/lpfc_init.c                      |   7 -
 drivers/scsi/lpfc/lpfc_scsi.c                      |  14 +-
 drivers/scsi/mpi3mr/mpi3mr_fw.c                    |  10 +
 drivers/scsi/mpt3sas/mpt3sas_transport.c           |   3 +
 drivers/scsi/pm8001/pm8001_ctl.c                   |  24 +-
 drivers/scsi/pm8001/pm8001_init.c                  |   1 +
 drivers/scsi/pm8001/pm8001_sas.h                   |   4 +
 drivers/soc/aspeed/aspeed-socinfo.c                |   4 +
 drivers/soc/qcom/smem.c                            |   2 +-
 drivers/soc/tegra/fuse/fuse-tegra30.c              | 122 ++++++
 drivers/spi/spi-loopback-test.c                    |  12 +-
 drivers/spi/spi-rpc-if.c                           |   2 +
 drivers/spi/spi.c                                  |  10 +
 drivers/tee/tee_core.c                             |   2 +-
 drivers/thunderbolt/tb.c                           |   2 +-
 drivers/ufs/core/ufshcd-crypto.c                   |  34 +-
 drivers/ufs/core/ufshcd-crypto.h                   |  36 ++
 drivers/ufs/core/ufshcd.c                          |  25 +-
 drivers/ufs/host/ufs-mediatek.c                    | 179 +++++++--
 drivers/ufs/host/ufshcd-pci.c                      |  70 +++-
 drivers/usb/cdns3/cdnsp-gadget.c                   |   8 +-
 drivers/usb/gadget/function/f_fs.c                 |   8 +-
 drivers/usb/gadget/function/f_hid.c                |   4 +-
 drivers/usb/gadget/function/f_ncm.c                |   3 +-
 drivers/usb/host/xhci-plat.c                       |   1 +
 drivers/usb/mon/mon_bin.c                          |  14 +-
 drivers/vfio/iova_bitmap.c                         |   5 +-
 drivers/vfio/vfio_main.c                           |   2 +-
 drivers/video/backlight/lp855x_bl.c                |   2 +-
 drivers/video/fbdev/aty/atyfb_base.c               |   8 +-
 drivers/video/fbdev/core/bitblit.c                 |  33 +-
 drivers/video/fbdev/core/fbcon.c                   |  19 +
 drivers/video/fbdev/core/fbmem.c                   |   1 +
 drivers/video/fbdev/pvr2fb.c                       |   2 +-
 drivers/video/fbdev/valkyriefb.c                   |   2 +
 drivers/watchdog/s3c2410_wdt.c                     |  10 +-
 fs/9p/v9fs.c                                       |   9 +-
 fs/btrfs/extent_io.c                               |   8 +
 fs/btrfs/file.c                                    |  10 +
 fs/btrfs/scrub.c                                   |   2 +
 fs/btrfs/tree-log.c                                |   2 +-
 fs/ceph/dir.c                                      |   3 +-
 fs/ceph/file.c                                     |   6 +-
 fs/ceph/locks.c                                    |   5 +-
 fs/exfat/fatent.c                                  |  11 +-
 fs/ext4/fast_commit.c                              |   2 +-
 fs/ext4/xattr.c                                    |   2 +-
 fs/f2fs/compress.c                                 |   2 +-
 fs/f2fs/extent_cache.c                             |   6 +
 fs/fuse/inode.c                                    |  11 +-
 fs/hpfs/namei.c                                    |  18 +-
 fs/jfs/inode.c                                     |   8 +-
 fs/jfs/jfs_txnmgr.c                                |   9 +-
 fs/nfs/nfs3client.c                                |  15 +-
 fs/nfs/nfs4client.c                                |  17 +-
 fs/nfs/nfs4proc.c                                  |  15 +-
 fs/nfs/nfs4state.c                                 |   3 +
 fs/nfs/pnfs_nfs.c                                  |  34 +-
 fs/nfs/sysfs.c                                     |   1 +
 fs/nfs/write.c                                     |   3 +-
 fs/nfsd/nfs4proc.c                                 |   7 +-
 fs/nfsd/nfs4state.c                                |   3 +-
 fs/ntfs3/inode.c                                   |   1 +
 fs/open.c                                          |  10 +-
 fs/orangefs/xattr.c                                |  12 +-
 fs/proc/generic.c                                  |  12 +-
 fs/smb/client/cached_dir.c                         |  16 +-
 fs/smb/client/file.c                               | 115 +++++-
 fs/smb/client/fs_context.c                         |   2 +
 fs/smb/client/smb2inode.c                          |   2 +
 fs/smb/client/smb2ops.c                            |   3 +-
 fs/smb/client/smb2pdu.c                            |   7 +-
 fs/smb/client/transport.c                          |  12 +-
 fs/smb/server/smb2pdu.c                            |   2 +
 fs/smb/server/transport_tcp.c                      |  12 +-
 include/linux/blk_types.h                          |  11 +-
 include/linux/cgroup.h                             |   1 +
 include/linux/compiler_types.h                     |   5 +-
 include/linux/fbcon.h                              |   2 +
 include/linux/filter.h                             |  22 +-
 include/linux/map_benchmark.h                      |   1 +
 include/linux/memcontrol.h                         |   8 +-
 include/linux/memory-tiers.h                       |  39 +-
 include/linux/netpoll.h                            |   1 +
 include/linux/node.h                               |  26 +-
 include/linux/pci.h                                |   2 +-
 include/linux/shdma-base.h                         |   2 +-
 include/linux/swap.h                               |   3 +-
 include/linux/vm_event_item.h                      |   1 +
 include/net/bluetooth/hci.h                        |   1 +
 include/net/bluetooth/hci_core.h                   |   8 +
 include/net/bluetooth/mgmt.h                       |   2 +-
 include/net/cls_cgroup.h                           |   2 +-
 include/net/gro.h                                  |   3 +
 include/net/nfc/nci_core.h                         |   2 +-
 include/net/tc_act/tc_connmark.h                   |   1 +
 include/net/xdp.h                                  |   5 +
 include/ufs/ufs_quirks.h                           |   3 +
 include/ufs/ufshcd.h                               |  44 +++
 include/ufs/ufshci.h                               |   4 +-
 kernel/bpf/helpers.c                               |   2 +-
 kernel/bpf/ringbuf.c                               |   2 +
 kernel/bpf/verifier.c                              |   6 +-
 kernel/cgroup/cgroup.c                             |  24 +-
 kernel/events/uprobes.c                            |   7 +
 kernel/futex/syscalls.c                            | 106 ++---
 kernel/gcov/gcc_4_7.c                              |   4 +-
 kernel/sched/fair.c                                |  15 +-
 kernel/trace/ftrace.c                              |   2 +
 kernel/trace/trace_events_hist.c                   |   6 +-
 lib/crypto/Makefile                                |   2 +-
 mm/filemap.c                                       |  24 +-
 mm/memcontrol.c                                    | 292 ++++++++------
 mm/memory-tiers.c                                  | 162 +++++++-
 mm/memory.c                                        |  24 +-
 mm/mm_init.c                                       |   2 +-
 mm/page_io.c                                       |   8 +-
 mm/percpu.c                                        |   8 +-
 mm/secretmem.c                                     |   2 +-
 mm/truncate.c                                      |  27 +-
 mm/vmscan.c                                        |   3 +-
 mm/vmstat.c                                        |   1 +
 mm/workingset.c                                    |  54 ++-
 mm/zswap.c                                         |   4 +
 net/8021q/vlan.c                                   |   2 +
 net/bluetooth/6lowpan.c                            | 103 +++--
 net/bluetooth/hci_event.c                          |  18 +-
 net/bluetooth/hci_sync.c                           |  23 +-
 net/bluetooth/iso.c                                |   8 +-
 net/bluetooth/l2cap_core.c                         |   1 +
 net/bluetooth/mgmt.c                               |   7 +-
 net/bluetooth/rfcomm/tty.c                         |  26 +-
 net/bluetooth/sco.c                                |   7 +
 net/bridge/br.c                                    |   5 +
 net/bridge/br_forward.c                            |   5 +-
 net/bridge/br_if.c                                 |   1 +
 net/bridge/br_input.c                              |   4 +-
 net/bridge/br_mst.c                                |  10 +-
 net/bridge/br_private.h                            |  13 +-
 net/core/filter.c                                  |   1 +
 net/core/gro.c                                     |   3 -
 net/core/netpoll.c                                 |  71 ++--
 net/core/page_pool.c                               |  12 +-
 net/core/skbuff.c                                  |  10 +-
 net/core/sock.c                                    |  15 +-
 net/dsa/dsa.c                                      |   7 +
 net/dsa/tag_brcm.c                                 |  10 +-
 net/ethernet/eth.c                                 |   5 +-
 net/handshake/tlshd.c                              |   1 +
 net/hsr/hsr_device.c                               |   3 +
 net/ipv4/esp4.c                                    |   4 +-
 net/ipv4/netfilter/nf_reject_ipv4.c                |  25 ++
 net/ipv4/nexthop.c                                 |   6 +
 net/ipv4/route.c                                   |   5 +
 net/ipv4/udp_tunnel_nic.c                          |   2 +-
 net/ipv6/addrconf.c                                |   4 +-
 net/ipv6/ah6.c                                     |  50 ++-
 net/ipv6/esp6.c                                    |   4 +-
 net/ipv6/netfilter/nf_reject_ipv6.c                |  30 ++
 net/ipv6/raw.c                                     |   2 +-
 net/ipv6/udp.c                                     |   2 +-
 net/mac80211/iface.c                               |  14 +-
 net/mac80211/mlme.c                                |   2 +-
 net/mac80211/rx.c                                  |  10 +-
 net/mptcp/protocol.c                               |  54 ++-
 net/mptcp/protocol.h                               |   2 +-
 net/netfilter/nf_tables_api.c                      |  30 ++
 net/rds/rds.h                                      |   2 +-
 net/sched/act_bpf.c                                |   6 +-
 net/sched/act_connmark.c                           |  30 +-
 net/sched/act_ife.c                                |  12 +-
 net/sched/cls_bpf.c                                |   6 +-
 net/sched/sch_generic.c                            |  17 +-
 net/sctp/diag.c                                    |  23 +-
 net/sctp/transport.c                               |  13 +-
 net/smc/smc_clc.c                                  |   1 +
 net/strparser/strparser.c                          |   2 +-
 net/tipc/net.c                                     |   2 +
 net/unix/garbage.c                                 |  14 +-
 net/xfrm/espintcp.c                                |   4 +-
 security/integrity/ima/ima_appraise.c              |  23 +-
 sound/drivers/serial-generic.c                     |  12 +-
 sound/pci/hda/patch_realtek.c                      |  17 +-
 sound/soc/codecs/cs4271.c                          |  10 +-
 sound/soc/codecs/lpass-va-macro.c                  |   2 +-
 sound/soc/codecs/max98090.c                        |   6 +-
 sound/soc/codecs/tas2781-i2c.c                     |   9 +-
 sound/soc/codecs/tlv320aic3x.c                     |  32 +-
 sound/soc/fsl/fsl_sai.c                            |   3 +-
 sound/soc/intel/avs/pcm.c                          |   2 +
 sound/soc/meson/aiu-encoder-i2s.c                  |   9 +-
 sound/soc/qcom/qdsp6/q6asm.c                       |   2 +-
 sound/soc/qcom/sc8280xp.c                          |   3 +
 sound/soc/stm/stm32_sai_sub.c                      |   8 +
 sound/usb/endpoint.c                               |   5 +
 sound/usb/mixer.c                                  |   9 +
 sound/usb/mixer_s1810c.c                           |  28 +-
 sound/usb/validate.c                               |   9 +-
 tools/bpf/bpftool/btf_dumper.c                     |   2 +-
 tools/bpf/bpftool/prog.c                           |   2 +-
 tools/include/linux/bitmap.h                       |   1 +
 tools/lib/bpf/bpf_tracing.h                        |   2 +-
 tools/lib/thermal/Makefile                         |   9 +-
 tools/perf/util/symbol.c                           |   1 -
 tools/power/cpupower/lib/cpuidle.c                 |   5 +-
 tools/power/cpupower/lib/cpupower.c                |   2 +-
 .../x86_energy_perf_policy.c                       |  30 +-
 tools/testing/selftests/Makefile                   |   2 +-
 tools/testing/selftests/bpf/test_lirc_mode2_user.c |   2 +-
 tools/testing/selftests/bpf/test_xsk.sh            |   2 +
 .../selftests/drivers/net/netdevsim/Makefile       |  21 +
 .../selftests/drivers/net/netdevsim/settings       |   1 +
 .../ftrace/test.d/filter/event-filter-function.tc  |   4 +
 tools/testing/selftests/iommu/iommufd.c            |   2 +
 tools/testing/selftests/net/fcnal-test.sh          | 432 +++++++++++----------
 .../selftests/net/forwarding/local_termination.sh  |   2 +
 tools/testing/selftests/net/gro.c                  | 101 ++++-
 tools/testing/selftests/net/mptcp/mptcp_connect.c  |  18 +-
 tools/testing/selftests/net/mptcp/mptcp_connect.sh |   2 +-
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |  54 +--
 tools/testing/selftests/net/psock_tpacket.c        |   4 +-
 tools/testing/selftests/net/traceroute.sh          |  13 +-
 tools/testing/selftests/user_events/perf_test.c    |   2 +-
 usr/include/headers_check.pl                       |   2 +
 504 files changed, 4874 insertions(+), 2090 deletions(-)



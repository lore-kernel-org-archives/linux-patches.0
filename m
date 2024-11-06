Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5911E909B;
	Wed,  6 Nov 2024 12:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897019; cv=none; b=Pmy9AyKwYSr6O/U9vgpqTfcXDukZuFYwn+IQNKudbwb+40PIkydDyJQTZmU85M06h6T0ygUpJidwajHPhAy5klQZIH3XS3iu4Gl6RU2Drmwmizb11puNQaCSTJcX9C9ji4e40hD6bMZEfcTmn7Q7oqLr/UwsUa4QckajP1o45QE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897019; c=relaxed/simple;
	bh=lQuCGGSXc079cT/fVxPn2TlIkH3V3iaqNGf8/p8xFqU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Y/2p6wf24mb73rdQ9gY0duyaXJRYDfLbACJDr0cEv8hP0hDBgcqCX2yAMV5KTEqM+406Bsqh61xp7NoJPBzPQ2p0JkiKpMVz7VXZ+yX+hKmllYpgoArNXGFMfoGGwz6qxh2G8SGeQXdth/ZK+uaa6PEyJMzOHcCKQ3HtWbG1GpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dFHepY0G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dFHepY0G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8743C4CECD;
	Wed,  6 Nov 2024 12:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897019;
	bh=lQuCGGSXc079cT/fVxPn2TlIkH3V3iaqNGf8/p8xFqU=;
	h=From:To:Cc:Subject:Date:From;
	b=dFHepY0GgOePpkvI9ZW7DHtWMPw+fSYkT29jR/WXOUvCvtox11/mNzpkjtkXO23iF
	 FKJAovbSqI4Opo3teYrz3yCElfVL02nj2M22mBqjvYdhLAr08BiFIcVmAe5ptOZhl4
	 RUjHKSZgw0c1p+XgZHcdfKXM8OclX+FpQzVhK8JI=
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
	hagar@microsoft.com,
	broonie@kernel.org
Subject: [PATCH 6.1 000/126] 6.1.116-rc1 review
Date: Wed,  6 Nov 2024 13:03:21 +0100
Message-ID: <20241106120306.038154857@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.116-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.116-rc1
X-KernelTest-Deadline: 2024-11-08T12:03+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.1.116 release.
There are 126 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 08 Nov 2024 12:02:47 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.116-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.116-rc1

Huang Ying <ying.huang@intel.com>
    migrate_pages_batch: fix statistics for longterm pin retry

Linus Torvalds <torvalds@linux-foundation.org>
    mm: avoid gcc complaint about pointer casting

Jeongjun Park <aha310510@gmail.com>
    vt: prevent kernel-infoleak in con_font_get()

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Skip on writeback when it's not applicable

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/display: Add null checks for 'stream' and 'plane' before dereferencing

Michael Walle <mwalle@kernel.org>
    mtd: spi-nor: winbond: fix w25q128 regression

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Fix build errors due to backported TIMENS

Jeongjun Park <aha310510@gmail.com>
    mm: shmem: fix data-race in shmem_getattr()

Johannes Berg <johannes.berg@intel.com>
    wifi: iwlwifi: mvm: fix 6 GHz scan construction

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix kernel bug due to missing clearing of checked flag

Zong-Zhe Yang <kevin_yang@realtek.com>
    wifi: mac80211: fix NULL dereference at band check in starting tx ba session

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/bugs: Use code segment selector for VERW operand

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: always lock __io_cqring_overflow_flush

Gregory Price <gourry@gourry.net>
    vmscan,migrate: fix page count imbalance on node stats when demoting pages

Huang Ying <ying.huang@intel.com>
    migrate_pages: split unmap_and_move() to _unmap() and _move()

Huang Ying <ying.huang@intel.com>
    migrate_pages: restrict number of pages to migrate in batch

Huang Ying <ying.huang@intel.com>
    migrate_pages: separate hugetlb folios migration

Huang Ying <ying.huang@intel.com>
    migrate_pages: organize stats with struct migrate_pages_stats

Yang Li <yang.lee@linux.alibaba.com>
    mm/migrate.c: stop using 0 as NULL pointer

Huang Ying <ying.huang@intel.com>
    migrate: convert migrate_pages() to use folios

Huang Ying <ying.huang@intel.com>
    migrate: convert unmap_and_move() to use folios

Baolin Wang <baolin.wang@linux.alibaba.com>
    mm: migrate: try again if THP split is failed due to page refcnt

Jens Axboe <axboe@kernel.dk>
    io_uring/rw: fix missing NOWAIT check for O_DIRECT start write

Amir Goldstein <amir73il@gmail.com>
    io_uring: use kiocb_{start,end}_write() helpers

Amir Goldstein <amir73il@gmail.com>
    fs: create kiocb_{start,end}_write() helpers

Amir Goldstein <amir73il@gmail.com>
    io_uring: rename kiocb_end_write() local helper

Andrey Konovalov <andreyknvl@gmail.com>
    kasan: remove vmalloc_percpu test

Vitaliy Shevtsov <v.shevtsov@maxima.ru>
    nvmet-auth: assign dh_key to NULL after kfree_sensitive

Christoffer Sandberg <cs@tuxedo.de>
    ALSA: hda/realtek: Fix headset mic on TUXEDO Stellaris 16 Gen6 mb1

Matt Johnston <matt@codeconstruct.com.au>
    mctp i2c: handle NULL header address

Edward Adam Davis <eadavis@qq.com>
    ocfs2: pass u64 to ocfs2_truncate_inline maybe overflow

Matt Fleming <mfleming@cloudflare.com>
    mm/page_alloc: let GFP_ATOMIC order-0 allocs access highatomic reserves

Mel Gorman <mgorman@techsingularity.net>
    mm/page_alloc: explicitly define how __GFP_HIGH non-blocking allocations accesses reserves

Mel Gorman <mgorman@techsingularity.net>
    mm/page_alloc: explicitly define what alloc flags deplete min reserves

Mel Gorman <mgorman@techsingularity.net>
    mm/page_alloc: explicitly record high-order atomic allocations in alloc_flags

Mel Gorman <mgorman@techsingularity.net>
    mm/page_alloc: treat RT tasks similar to __GFP_HIGH

Mel Gorman <mgorman@techsingularity.net>
    mm/page_alloc: rename ALLOC_HIGH to ALLOC_MIN_RESERVE

Dan Williams <dan.j.williams@intel.com>
    cxl/port: Fix cxl_bus_rescan() vs bus_rescan_devices()

Dan Williams <dan.j.williams@intel.com>
    cxl/acpi: Move rescan to the workqueue

Chunyan Zhang <zhangchunyan@iscas.ac.cn>
    riscv: Remove duplicated GET_RM

Chunyan Zhang <zhangchunyan@iscas.ac.cn>
    riscv: Remove unused GENERATING_ASM_OFFSETS

WangYuli <wangyuli@uniontech.com>
    riscv: Use '%u' to format the output of 'cpu'

Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
    riscv: efi: Set NX compat flag in PE/COFF header

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek: Limit internal Mic boost on Dell platform

Alexandre Ghiti <alexghiti@rivosinc.com>
    riscv: vdso: Prevent the compiler from inserting calls to memset()

Chen Ridong <chenridong@huawei.com>
    cgroup/bpf: use a dedicated workqueue for cgroup bpf destruction

Xinyu Zhang <xizhang@purestorage.com>
    block: fix sanity checks in blk_rq_map_user_bvec

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix potential deadlock with newly created symlinks

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    iio: light: veml6030: fix microlux value calculation

Zicheng Qu <quzicheng@huawei.com>
    iio: adc: ad7124: fix division by zero in ad7124_set_channel_odr()

Zicheng Qu <quzicheng@huawei.com>
    staging: iio: frequency: ad9832: fix division by zero in ad9832_calc_freqreg()

Ville Syrjälä <ville.syrjala@linux.intel.com>
    wifi: iwlegacy: Clear stale interrupts before resuming device

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211: clear wdev->cqm_config pointer on free

Manikanta Pubbisetty <quic_mpubbise@quicinc.com>
    wifi: ath10k: Fix memory leak in management tx

Felix Fietkau <nbd@nbd.name>
    wifi: mac80211: do not pass a stopped vif to the driver in .get_txpower

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "driver core: Fix uevent_show() vs driver detach race"

Basavaraj Natikar <Basavaraj.Natikar@amd.com>
    xhci: Use pm_runtime_get to prevent RPM on unsupported systems

Faisal Hassan <quic_faisalh@quicinc.com>
    xhci: Fix Link TRB DMA in command ring stopped completion event

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    usb: typec: fix unreleased fwnode_handle in typec_port_register_altmodes()

Zijun Hu <quic_zijuhu@quicinc.com>
    usb: phy: Fix API devm_usb_put_phy() can not release the phy

Zongmin Zhou <zhouzongmin@kylinos.cn>
    usbip: tools: Fix detach_port() invalid port error path

Jan Schär <jan@jschaer.ch>
    ALSA: usb-audio: Add quirks for Dell WD19 dock

Alan Stern <stern@rowland.harvard.edu>
    USB: gadget: dummy-hcd: Fix "task hung" problem

Andrey Konovalov <andreyknvl@gmail.com>
    usb: gadget: dummy_hcd: execute hrtimer callback in softirq context

Marcello Sylvester Bauer <sylv@sylv.io>
    usb: gadget: dummy_hcd: Set transfer interval to 1 microframe

Marcello Sylvester Bauer <sylv@sylv.io>
    usb: gadget: dummy_hcd: Switch to hrtimer transfer scheduler

Dimitri Sivanich <sivanich@hpe.com>
    misc: sgi-gru: Don't disable preemption in GRU driver

Dai Ngo <dai.ngo@oracle.com>
    NFS: remove revoked delegation from server's delegation list

Daniel Palmer <daniel@0x0f.com>
    net: amd: mvme147: Fix probe banner message

Benjamin Marzinski <bmarzins@redhat.com>
    scsi: scsi_transport_fc: Allow setting rport state to current state

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Additional check in ni_clear()

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Fix possible deadlock in mi_read

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Stale inode instead of bad

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Fix warning possible deadlock in ntfs_set_state

Andrew Ballance <andrewjballance@gmail.com>
    fs/ntfs3: Check if more than chunk-size bytes are written

Pierre Gondois <pierre.gondois@arm.com>
    ACPI: CPPC: Make rmw_lock a raw_spin_lock

David Howells <dhowells@redhat.com>
    afs: Fix missing subdir edit when renamed between parent dirs

David Howells <dhowells@redhat.com>
    afs: Automatically generate trace tag enums

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    firmware: arm_sdei: Fix the input parameter of cpuhp_remove_state()

Marco Elver <elver@google.com>
    kasan: Fix Software Tag-Based KASAN with GCC

Miguel Ojeda <ojeda@kernel.org>
    compiler-gcc: remove attribute support check for `__no_sanitize_address__`

Miguel Ojeda <ojeda@kernel.org>
    compiler-gcc: be consistent with underscores use for `no_sanitize`

Christoph Hellwig <hch@lst.de>
    iomap: turn iomap_want_unshare_iter into an inline function

Darrick J. Wong <djwong@kernel.org>
    fsdax: dax_unshare_iter needs to copy entire blocks

Darrick J. Wong <djwong@kernel.org>
    fsdax: remove zeroing code from dax_unshare_iter

Darrick J. Wong <djwong@kernel.org>
    iomap: share iomap_unshare_iter predicate code with fsdax

Darrick J. Wong <djwong@kernel.org>
    iomap: don't bother unsharing delalloc extents

Christoph Hellwig <hch@lst.de>
    iomap: improve shared block detection in iomap_unshare_iter

Darrick J. Wong <djwong@kernel.org>
    iomap: convert iomap_unshare_iter to use large folios

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_payload: sanitize offset and length before calling skb_checksum()

Ido Schimmel <idosch@nvidia.com>
    mlxsw: spectrum_ipip: Fix memory leak when changing remote IPv6 address

Ido Schimmel <idosch@nvidia.com>
    mlxsw: spectrum_ipip: Rename Spectrum-2 ip6gre operations

Ido Schimmel <idosch@nvidia.com>
    mlxsw: spectrum_router: Add support for double entry RIFs

Amit Cohen <amcohen@nvidia.com>
    mlxsw: spectrum_ptp: Add missing verification before pushing Tx header

Benoît Monin <benoit.monin@gmx.fr>
    net: skip offload for NETIF_F_IPV6_CSUM if ipv6 header contains extension

Sungwoo Kim <iam@sung-woo.kim>
    Bluetooth: hci: fix null-ptr-deref in hci_read_supported_codecs

Eric Dumazet <edumazet@google.com>
    netfilter: nf_reject_ipv6: fix potential crash in nf_send_reset6()

Dong Chenchen <dongchenchen2@huawei.com>
    netfilter: Fix use-after-free in get_info()

Byeonguk Jeong <jungbu2855@gmail.com>
    bpf: Fix out-of-bounds write in trie_get_next_key()

Zichen Xie <zichenxie0106@gmail.com>
    netdevsim: Add trailing zero to terminate the string in nsim_nexthop_bucket_activity_write()

Pedro Tammela <pctammela@mojatatu.com>
    net/sched: stop qdisc_tree_reduce_backlog on TC_H_ROOT

Pablo Neira Ayuso <pablo@netfilter.org>
    gtp: allow -1 to be specified as file description from userspace

Ido Schimmel <idosch@nvidia.com>
    ipv4: ip_tunnel: Fix suspicious RCU usage warning in ip_tunnel_init_flow()

Wander Lairson Costa <wander@redhat.com>
    igb: Disable threaded IRQ for igb_msix_other

Furong Xu <0x1207@gmail.com>
    net: stmmac: TSO: Fix unbalanced DMA map/unmap for non-paged SKB data

Jianbo Liu <jianbol@nvidia.com>
    macsec: Fix use-after-free while sending the offloading packet

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    ASoC: cs42l51: Fix some error handling paths in cs42l51_probe()

Daniel Gabay <daniel.gabay@intel.com>
    wifi: iwlwifi: mvm: Fix response handling in iwl_mvm_send_recovery_cmd()

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: mvm: disconnect station vifs if recovery failed

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: synchronize the qp-handle table array

Patrisious Haddad <phaddad@nvidia.com>
    RDMA/mlx5: Round max_rd_atomic/max_dest_rd_atomic up instead of down

Leon Romanovsky <leon@kernel.org>
    RDMA/cxgb4: Dump vendor specific QP details

Geert Uytterhoeven <geert@linux-m68k.org>
    wifi: brcm80211: BRCM_TRACING should depend on TRACING

Remi Pommarel <repk@triplefau.lt>
    wifi: ath11k: Fix invalid ring usage in full monitor mode

Felix Fietkau <nbd@nbd.name>
    wifi: mac80211: skip non-uploaded keys in ieee80211_iter_keys

Geert Uytterhoeven <geert@linux-m68k.org>
    mac80211: MAC80211_MESSAGE_TRACING should depend on TRACING

Ben Hutchings <ben@decadent.org.uk>
    wifi: iwlegacy: Fix "field-spanning write" warning in il_enqueue_hcmd()

Xiu Jianfeng <xiujianfeng@huawei.com>
    cgroup: Fix potential overflow issue when checking max_depth

Alexander Gordeev <agordeev@linux.ibm.com>
    fs/proc/kcore.c: allow translation of physical memory addresses

Lorenzo Stoakes <lstoakes@gmail.com>
    fs/proc/kcore: reinstate bounce buffer for KCORE_TEXT regions

Lorenzo Stoakes <lstoakes@gmail.com>
    fs/proc/kcore: convert read_kcore() to read_kcore_iter()

Lorenzo Stoakes <lstoakes@gmail.com>
    fs/proc/kcore: avoid bounce buffer for ktext data

Kefeng Wang <wangkefeng.wang@huawei.com>
    mm: remove kern_addr_valid() completely

Donet Tom <donettom@linux.ibm.com>
    selftests/mm: fix incorrect buffer->mirror size in hmm2 double_map test

Miquel Sabaté Solà <mikisabate@gmail.com>
    cpufreq: Avoid a bad reference count on CPU node

Hector Martin <marcan@marcan.st>
    cpufreq: Generalize of_perf_domain_get_sharing_cpumask phandle format


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/alpha/include/asm/pgtable.h                   |   2 -
 arch/arc/include/asm/pgtable-bits-arcv2.h          |   2 -
 arch/arm/include/asm/pgtable-nommu.h               |   2 -
 arch/arm/include/asm/pgtable.h                     |   4 -
 arch/arm64/include/asm/pgtable.h                   |   2 -
 arch/arm64/mm/mmu.c                                |  47 --
 arch/arm64/mm/pageattr.c                           |   3 +-
 arch/csky/include/asm/pgtable.h                    |   3 -
 arch/hexagon/include/asm/page.h                    |   7 -
 arch/ia64/include/asm/pgtable.h                    |  16 -
 arch/loongarch/include/asm/pgtable.h               |   2 -
 arch/loongarch/kernel/vdso.c                       |  28 +-
 arch/m68k/include/asm/pgtable_mm.h                 |   2 -
 arch/m68k/include/asm/pgtable_no.h                 |   1 -
 arch/microblaze/include/asm/pgtable.h              |   3 -
 arch/mips/include/asm/pgtable.h                    |   2 -
 arch/nios2/include/asm/pgtable.h                   |   2 -
 arch/openrisc/include/asm/pgtable.h                |   2 -
 arch/parisc/include/asm/pgtable.h                  |  15 -
 arch/powerpc/include/asm/pgtable.h                 |   7 -
 arch/riscv/include/asm/pgtable.h                   |   2 -
 arch/riscv/kernel/asm-offsets.c                    |   2 -
 arch/riscv/kernel/cpu-hotplug.c                    |   2 +-
 arch/riscv/kernel/efi-header.S                     |   2 +-
 arch/riscv/kernel/traps_misaligned.c               |   2 -
 arch/riscv/kernel/vdso/Makefile                    |   1 +
 arch/s390/include/asm/io.h                         |   2 +
 arch/s390/include/asm/pgtable.h                    |   2 -
 arch/sh/include/asm/pgtable.h                      |   2 -
 arch/sparc/include/asm/pgtable_32.h                |   6 -
 arch/sparc/mm/init_32.c                            |   3 +-
 arch/sparc/mm/init_64.c                            |   1 -
 arch/um/include/asm/pgtable.h                      |   2 -
 arch/x86/include/asm/nospec-branch.h               |  11 +-
 arch/x86/include/asm/pgtable_32.h                  |   9 -
 arch/x86/include/asm/pgtable_64.h                  |   1 -
 arch/x86/mm/init_64.c                              |  41 --
 arch/xtensa/include/asm/pgtable.h                  |   2 -
 block/blk-map.c                                    |   4 +-
 drivers/acpi/cppc_acpi.c                           |   9 +-
 drivers/base/core.c                                |  13 +-
 drivers/base/module.c                              |   4 -
 drivers/cpufreq/mediatek-cpufreq-hw.c              |  14 +-
 drivers/cxl/acpi.c                                 |  17 +-
 drivers/cxl/core/port.c                            |  26 +-
 drivers/cxl/cxl.h                                  |   3 +-
 drivers/firmware/arm_sdei.c                        |   2 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  10 +
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c |   3 +
 drivers/iio/adc/ad7124.c                           |   2 +-
 drivers/iio/light/veml6030.c                       |   2 +-
 drivers/infiniband/hw/bnxt_re/qplib_fp.c           |   4 +
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c         |  13 +-
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.h         |   2 +
 drivers/infiniband/hw/cxgb4/provider.c             |   1 +
 drivers/infiniband/hw/mlx5/qp.c                    |   4 +-
 drivers/misc/sgi-gru/grukservices.c                |   2 -
 drivers/misc/sgi-gru/grumain.c                     |   4 -
 drivers/misc/sgi-gru/grutlbpurge.c                 |   2 -
 drivers/mtd/spi-nor/winbond.c                      |   7 +-
 drivers/net/ethernet/amd/mvme147.c                 |   7 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |   2 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_ipip.c    | 119 ++--
 .../net/ethernet/mellanox/mlxsw/spectrum_ipip.h    |   1 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c |   7 +
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  |   2 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  22 +-
 drivers/net/gtp.c                                  |  22 +-
 drivers/net/macsec.c                               |   3 +-
 drivers/net/mctp/mctp-i2c.c                        |   3 +
 drivers/net/netdevsim/fib.c                        |   4 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.c          |   7 +-
 drivers/net/wireless/ath/ath10k/wmi.c              |   2 +
 drivers/net/wireless/ath/ath11k/dp_rx.c            |   7 +-
 drivers/net/wireless/broadcom/brcm80211/Kconfig    |   1 +
 drivers/net/wireless/intel/iwlegacy/common.c       |  15 +-
 drivers/net/wireless/intel/iwlegacy/common.h       |  12 +
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |  22 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |   3 +-
 drivers/nvme/target/auth.c                         |   1 +
 drivers/scsi/scsi_transport_fc.c                   |   4 +-
 drivers/staging/iio/frequency/ad9832.c             |   7 +-
 drivers/tty/vt/vt.c                                |   2 +-
 drivers/usb/gadget/udc/dummy_hcd.c                 |  57 +-
 drivers/usb/host/xhci-pci.c                        |   6 +-
 drivers/usb/host/xhci-ring.c                       |  16 +-
 drivers/usb/phy/phy.c                              |   2 +-
 drivers/usb/typec/class.c                          |   1 +
 fs/afs/dir.c                                       |  25 +
 fs/afs/dir_edit.c                                  |  91 ++-
 fs/afs/internal.h                                  |   2 +
 fs/dax.c                                           |  49 +-
 fs/iomap/buffered-io.c                             |  31 +-
 fs/nfs/delegation.c                                |   5 +
 fs/nilfs2/namei.c                                  |   3 +
 fs/nilfs2/page.c                                   |   1 +
 fs/ntfs3/frecord.c                                 |   4 +-
 fs/ntfs3/inode.c                                   |  10 +-
 fs/ntfs3/lznt.c                                    |   3 +
 fs/ntfs3/namei.c                                   |   2 +-
 fs/ntfs3/ntfs_fs.h                                 |   2 +-
 fs/ocfs2/file.c                                    |   8 +
 fs/proc/kcore.c                                    |  94 ++-
 include/acpi/cppc_acpi.h                           |   2 +-
 include/linux/compiler-gcc.h                       |  12 +-
 include/linux/cpufreq.h                            |  34 +-
 include/linux/fs.h                                 |  36 ++
 include/linux/iomap.h                              |  19 +
 include/linux/migrate.h                            |   1 +
 include/net/ip_tunnels.h                           |   2 +-
 include/trace/events/afs.h                         | 240 +------
 io_uring/io_uring.c                                |  11 +-
 io_uring/rw.c                                      |  52 +-
 kernel/bpf/cgroup.c                                |  19 +-
 kernel/bpf/lpm_trie.c                              |   2 +-
 kernel/cgroup/cgroup.c                             |   4 +-
 mm/huge_memory.c                                   |   4 +-
 mm/internal.h                                      |  13 +-
 mm/kasan/kasan_test.c                              |  27 -
 mm/migrate.c                                       | 690 ++++++++++++++-------
 mm/page_alloc.c                                    |  95 ++-
 mm/shmem.c                                         |   2 +
 net/bluetooth/hci_sync.c                           |  18 +-
 net/core/dev.c                                     |   4 +
 net/ipv6/netfilter/nf_reject_ipv6.c                |  15 +-
 net/mac80211/Kconfig                               |   2 +-
 net/mac80211/agg-tx.c                              |   4 +-
 net/mac80211/cfg.c                                 |   3 +-
 net/mac80211/key.c                                 |  42 +-
 net/netfilter/nft_payload.c                        |   3 +
 net/netfilter/x_tables.c                           |   2 +-
 net/sched/sch_api.c                                |   2 +-
 net/wireless/core.c                                |   1 +
 sound/pci/hda/patch_realtek.c                      |  22 +-
 sound/soc/codecs/cs42l51.c                         |   7 +-
 sound/usb/mixer_quirks.c                           |   3 +
 tools/testing/selftests/vm/hmm-tests.c             |   2 +-
 tools/usb/usbip/src/usbip_detach.c                 |   1 +
 139 files changed, 1453 insertions(+), 1027 deletions(-)



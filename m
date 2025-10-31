Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C70C2221FB6;
	Fri, 31 Oct 2025 14:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919433; cv=none; b=m2pHdYFmLXfQqEj2wBRxFFwT5GqpbKqayAayXzwnnw0yNumH0/76g8efsgi4rCbHQAA7fSe8vKS9V6yJArKltK7XSa36+HK/YtZSu+DUAQmbpLBU5itjlbb+irKrknYSbtZbjsRr8wKJnu0FDBqbnoaLYlob2kEOhChxSkOth0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919433; c=relaxed/simple;
	bh=C4nYH827WpGOhpUq7flvpOIv51ppbiNv/kiXvS9sbJM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XfLI60O6UhSu5Iln+oWVKX5LPExnEE0dTfAlXaMAQh0nJ6ePxfa38geatSJVNLyFW1DsdmKdXJQd5ONLPSxx/Kd2cmRC8iknMvUOdj9f0dIIMI9ZzbhNKbTBkKQGrLTKFajm9TV+nPBkfcAcONfhCSnbgtDp6/qnlaJ1baE0Muo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T/0LcRCa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T/0LcRCa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 286BAC4CEE7;
	Fri, 31 Oct 2025 14:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919433;
	bh=C4nYH827WpGOhpUq7flvpOIv51ppbiNv/kiXvS9sbJM=;
	h=From:To:Cc:Subject:Date:From;
	b=T/0LcRCamR5Nzh/5eZl59N3dsmasaljub5fkOF7fvPBuxYKuCTbe1oZ/sIH84cJas
	 rKn1ZaAdzM+6/0Z7sh8qF4nnw9WxXZSdYrs3nonkzhDTlRtp6h9gvMNtQVsj8M68L1
	 HLzN/rsiQVGnSjtGenhVOxx73Pvef0rP2MZsSKzE=
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
Subject: [PATCH 6.12 00/40] 6.12.57-rc1 review
Date: Fri, 31 Oct 2025 15:00:53 +0100
Message-ID: <20251031140043.939381518@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.57-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.12.57-rc1
X-KernelTest-Deadline: 2025-11-02T14:00+00:00
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.12.57 release.
There are 40 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 02 Nov 2025 14:00:34 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.57-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.12.57-rc1

Edward Cree <ecree.xilinx@gmail.com>
    sfc: fix NULL dereferences in ef100_process_design_param()

Xiaogang Chen <xiaogang.chen@amd.com>
    udmabuf: fix a buf size overflow issue during udmabuf creation

Aditya Kumar Singh <quic_adisi@quicinc.com>
    wifi: ath12k: fix read pointer after free in ath12k_mac_assign_vif_to_vdev()

Kees Bakker <kees@ijzerbout.nl>
    iommu/vt-d: Avoid use of NULL after WARN_ON_ONCE

William Breathitt Gray <wbg@kernel.org>
    gpio: idio-16: Define fixed direction of the GPIO lines

Ioana Ciornei <ioana.ciornei@nxp.com>
    gpio: regmap: add the .fixed_direction_output configuration parameter

Mathieu Dubois-Briand <mathieu.dubois-briand@bootlin.com>
    gpio: regmap: Allow to allocate regmap-irq device

Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    bits: introduce fixed-type GENMASK_U*()

Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    bits: add comments and newlines to #if, #else and #endif directives

Wang Liang <wangliang74@huawei.com>
    bonding: check xdp prog when set bond mode

Hangbin Liu <liuhangbin@gmail.com>
    bonding: return detailed error when loading native XDP fails

Alexander Wetzel <Alexander@wetzel-home.de>
    wifi: cfg80211: Add missing lock in cfg80211_check_and_end_cac()

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid panic once fallocation fails for pinfile

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: in-kernel: C-flag: handle late ADD_ADDR

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: mark 'delete re-add signal' as skipped if not supported

Geliang Tang <geliang@kernel.org>
    selftests: mptcp: disable add_addr retrans in endpoint_tests

Jonathan Corbet <corbet@lwn.net>
    docs: kdoc: handle the obsolescensce of docutils.ErrorString()

Menglong Dong <menglong8.dong@gmail.com>
    arch: Add the macro COMPILE_OFFSETS to all the asm-offsets.c

Tejun Heo <tj@kernel.org>
    sched_ext: Make qmap dump operation non-destructive

Filipe Manana <fdmanana@suse.com>
    btrfs: use smp_mb__after_atomic() when forcing COW in create_pending_snapshot()

Qu Wenruo <wqu@suse.com>
    btrfs: tree-checker: add inode extref checks

Filipe Manana <fdmanana@suse.com>
    btrfs: abort transaction if we fail to update inode in log replay dir fixup

Filipe Manana <fdmanana@suse.com>
    btrfs: use level argument in log tree walk callback replay_one_buffer()

Filipe Manana <fdmanana@suse.com>
    btrfs: always drop log root tree reference in btrfs_replay_log()

Thorsten Blum <thorsten.blum@linux.dev>
    btrfs: scrub: replace max_t()/min_t() with clamp() in scrub_throttle_dev_io()

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: zoned: refine extent allocator hint selection

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    btrfs: zoned: return error from btrfs_zone_finish_endio()

Filipe Manana <fdmanana@suse.com>
    btrfs: abort transaction in the process_one_buffer() log tree walk callback

Filipe Manana <fdmanana@suse.com>
    btrfs: abort transaction on specific error places when walking log tree

Chen Ridong <chenridong@huawei.com>
    cpuset: Use new excpus for nocpu error check when enabling root partition

Avadhut Naik <avadhut.naik@amd.com>
    EDAC/mc_sysfs: Increase legacy channel support to 16

David Kaplan <david.kaplan@amd.com>
    x86/bugs: Fix reporting of LFENCE retpoline

David Kaplan <david.kaplan@amd.com>
    x86/bugs: Report correct retbleed mitigation status

Jiri Olsa <jolsa@kernel.org>
    seccomp: passthrough uprobe systemcall without filtering

Josh Poimboeuf <jpoimboe@kernel.org>
    perf: Skip user unwind if the task is a kernel thread

Josh Poimboeuf <jpoimboe@kernel.org>
    perf: Have get_perf_callchain() return NULL if crosstask and user are set

Steven Rostedt <rostedt@goodmis.org>
    perf: Use current->flags & PF_KTHREAD|PF_USER_WORKER instead of current->mm == NULL

Dapeng Mi <dapeng1.mi@linux.intel.com>
    perf/x86/intel: Add ICL_FIXED_0_ADAPTIVE bit into INTEL_FIXED_BITS_MASK

Richard Guy Briggs <rgb@redhat.com>
    audit: record fanotify event regardless of presence of rules

Xiang Mei <xmei5@asu.edu>
    net/sched: sch_qfq: Fix null-deref in agg_dequeue


-------------

Diffstat:

 Documentation/sphinx/kernel_abi.py              |  4 +-
 Documentation/sphinx/kernel_feat.py             |  4 +-
 Documentation/sphinx/kernel_include.py          |  6 ++-
 Documentation/sphinx/maintainers_include.py     |  4 +-
 Makefile                                        |  4 +-
 arch/alpha/kernel/asm-offsets.c                 |  1 +
 arch/arc/kernel/asm-offsets.c                   |  1 +
 arch/arm/kernel/asm-offsets.c                   |  2 +
 arch/arm64/kernel/asm-offsets.c                 |  1 +
 arch/csky/kernel/asm-offsets.c                  |  1 +
 arch/hexagon/kernel/asm-offsets.c               |  1 +
 arch/loongarch/kernel/asm-offsets.c             |  2 +
 arch/m68k/kernel/asm-offsets.c                  |  1 +
 arch/microblaze/kernel/asm-offsets.c            |  1 +
 arch/mips/kernel/asm-offsets.c                  |  2 +
 arch/nios2/kernel/asm-offsets.c                 |  1 +
 arch/openrisc/kernel/asm-offsets.c              |  1 +
 arch/parisc/kernel/asm-offsets.c                |  1 +
 arch/powerpc/kernel/asm-offsets.c               |  1 +
 arch/riscv/kernel/asm-offsets.c                 |  1 +
 arch/s390/kernel/asm-offsets.c                  |  1 +
 arch/sh/kernel/asm-offsets.c                    |  1 +
 arch/sparc/kernel/asm-offsets.c                 |  1 +
 arch/um/kernel/asm-offsets.c                    |  2 +
 arch/x86/events/intel/core.c                    | 10 ++--
 arch/x86/include/asm/perf_event.h               |  6 ++-
 arch/x86/kernel/cpu/bugs.c                      |  9 ++--
 arch/x86/kvm/pmu.h                              |  2 +-
 arch/xtensa/kernel/asm-offsets.c                |  1 +
 drivers/dma-buf/udmabuf.c                       |  2 +-
 drivers/edac/edac_mc_sysfs.c                    | 24 ++++++++++
 drivers/gpio/gpio-idio-16.c                     |  5 ++
 drivers/gpio/gpio-regmap.c                      | 53 ++++++++++++++++++--
 drivers/iommu/intel/iommu.c                     |  7 +--
 drivers/net/bonding/bond_main.c                 | 11 +++--
 drivers/net/bonding/bond_options.c              |  3 ++
 drivers/net/ethernet/sfc/ef100_netdev.c         |  6 +--
 drivers/net/ethernet/sfc/ef100_nic.c            | 47 ++++++++----------
 drivers/net/wireless/ath/ath12k/mac.c           |  6 +--
 fs/btrfs/disk-io.c                              |  2 +-
 fs/btrfs/extent-tree.c                          |  6 ++-
 fs/btrfs/inode.c                                |  7 +--
 fs/btrfs/scrub.c                                |  3 +-
 fs/btrfs/transaction.c                          |  2 +-
 fs/btrfs/tree-checker.c                         | 37 ++++++++++++++
 fs/btrfs/tree-log.c                             | 64 +++++++++++++++++++------
 fs/btrfs/zoned.c                                |  8 ++--
 fs/btrfs/zoned.h                                |  9 ++--
 fs/f2fs/file.c                                  |  8 ++--
 fs/f2fs/segment.c                               | 20 ++++----
 include/linux/audit.h                           |  2 +-
 include/linux/bitops.h                          |  1 -
 include/linux/bits.h                            | 38 ++++++++++++++-
 include/linux/gpio/regmap.h                     | 16 +++++++
 include/net/bonding.h                           |  1 +
 include/net/pkt_sched.h                         | 25 +++++++++-
 kernel/cgroup/cpuset.c                          |  6 +--
 kernel/events/callchain.c                       | 16 +++----
 kernel/events/core.c                            |  7 +--
 kernel/seccomp.c                                | 32 ++++++++++---
 net/mptcp/pm_netlink.c                          |  6 +++
 net/sched/sch_api.c                             | 10 ----
 net/sched/sch_hfsc.c                            | 16 -------
 net/sched/sch_qfq.c                             |  2 +-
 net/wireless/reg.c                              |  4 ++
 tools/sched_ext/scx_qmap.bpf.c                  | 18 ++++++-
 tools/testing/selftests/net/mptcp/mptcp_join.sh |  3 +-
 67 files changed, 442 insertions(+), 164 deletions(-)



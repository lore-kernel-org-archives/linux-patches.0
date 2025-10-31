Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 858F133373C;
	Fri, 31 Oct 2025 14:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919614; cv=none; b=p+waLWeY9JsNgI4s0GHQTBFNdjpyVM/DhwmTegUl7ggWhedT69fRaWsVzdkxkoK013PezR6UyQ6pjsDazCZvhHwcqypOM4M4K+WxQHnBSKwfOU+42R7i7iwvPCL6ap6aNVh3a7OwZLI7HudNi6zUnx6lQB57FkMKssyWSN02Oac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919614; c=relaxed/simple;
	bh=Sj3+TgjLAtnajVRfZvxcN3kIzrWgQxS9oMK9hZP2YC4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jwop4+4Je3bLvwd9iMhgmej0vcQxTxMba3boXg0fl7XtfQ/btl5GhoLbFvjB6tmvzy14MvmO5krVcqGdzkNv6z4f7C53xsgvpWS34NaLPLYFe87vjCYLuv+/GbC6Q2ARgohJddDkB14kSw/z5ciE6oG0imHKKuCwyKM/FYziM98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JinkpT1f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JinkpT1f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8AD4C4CEE7;
	Fri, 31 Oct 2025 14:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919614;
	bh=Sj3+TgjLAtnajVRfZvxcN3kIzrWgQxS9oMK9hZP2YC4=;
	h=From:To:Cc:Subject:Date:From;
	b=JinkpT1fWFz8bmx1ikLARgkK31eESQKo8JFzS/9+FqONrH7edH7ecLLqLSw6B0Vyc
	 iz6lKGVxGq42PmxonzdRTBbTqZNKFSbNwqQGTUTupdTiFQxya1BZQ5C0Ot8/Dw9cki
	 d2Z5w3IK9zM9mCJrBFGoS4An/wVu9SqdJNNBGhbU=
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
Subject: [PATCH 6.17 00/35] 6.17.7-rc1 review
Date: Fri, 31 Oct 2025 15:01:08 +0100
Message-ID: <20251031140043.564670400@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.17.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.17.7-rc1
X-KernelTest-Deadline: 2025-11-02T14:00+00:00
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.17.7 release.
There are 35 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 02 Nov 2025 14:00:34 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.7-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.17.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.17.7-rc1

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

Aaron Lu <ziqianlu@bytedance.com>
    sched/fair: update_cfs_group() for throttled cfs_rqs

David Kaplan <david.kaplan@amd.com>
    x86/bugs: Add attack vector controls for VMSCAPE

Tejun Heo <tj@kernel.org>
    sched_ext: Keep bypass on between enable failure and scx_disable_workfn()

Jiri Olsa <jolsa@kernel.org>
    seccomp: passthrough uprobe systemcall without filtering

Kuan-Wei Chiu <visitorckw@gmail.com>
    EDAC: Fix wrong executable file modes for C source files

Josh Poimboeuf <jpoimboe@kernel.org>
    perf: Skip user unwind if the task is a kernel thread

Josh Poimboeuf <jpoimboe@kernel.org>
    perf: Have get_perf_callchain() return NULL if crosstask and user are set

Steven Rostedt <rostedt@goodmis.org>
    perf: Use current->flags & PF_KTHREAD|PF_USER_WORKER instead of current->mm == NULL

Dapeng Mi <dapeng1.mi@linux.intel.com>
    perf/x86/intel: Add ICL_FIXED_0_ADAPTIVE bit into INTEL_FIXED_BITS_MASK

Kyle Manna <kyle@kylemanna.com>
    EDAC/ie31200: Add two more Intel Alder Lake-S SoCs for EDAC support

Richard Guy Briggs <rgb@redhat.com>
    audit: record fanotify event regardless of presence of rules

Charles Keepax <ckeepax@opensource.cirrus.com>
    genirq/manage: Add buslock back in to enable_irq()

Charles Keepax <ckeepax@opensource.cirrus.com>
    genirq/manage: Add buslock back in to __disable_irq_nosync()

Charles Keepax <ckeepax@opensource.cirrus.com>
    genirq/chip: Add buslock back in to irq_set_handler()

David Kaplan <david.kaplan@amd.com>
    x86/bugs: Qualify RETBLEED_INTEL_MSG

David Kaplan <david.kaplan@amd.com>
    x86/bugs: Report correct retbleed mitigation status

Haofeng Li <lihaofeng@kylinos.cn>
    timekeeping: Fix aux clocks sysfs initialization loop bound

Tejun Heo <tj@kernel.org>
    sched_ext: Sync error_irq_work before freeing scx_sched

Tejun Heo <tj@kernel.org>
    sched_ext: Put event_stats_cpu in struct scx_sched_pcpu

Tejun Heo <tj@kernel.org>
    sched_ext: Move internal type and accessor definitions to ext_internal.h


-------------

Diffstat:

 .../admin-guide/hw-vuln/attack_vector_controls.rst |    1 +
 Makefile                                           |    4 +-
 arch/alpha/kernel/asm-offsets.c                    |    1 +
 arch/arc/kernel/asm-offsets.c                      |    1 +
 arch/arm/kernel/asm-offsets.c                      |    2 +
 arch/arm64/kernel/asm-offsets.c                    |    1 +
 arch/csky/kernel/asm-offsets.c                     |    1 +
 arch/hexagon/kernel/asm-offsets.c                  |    1 +
 arch/loongarch/kernel/asm-offsets.c                |    2 +
 arch/m68k/kernel/asm-offsets.c                     |    1 +
 arch/microblaze/kernel/asm-offsets.c               |    1 +
 arch/mips/kernel/asm-offsets.c                     |    2 +
 arch/nios2/kernel/asm-offsets.c                    |    1 +
 arch/openrisc/kernel/asm-offsets.c                 |    1 +
 arch/parisc/kernel/asm-offsets.c                   |    1 +
 arch/powerpc/kernel/asm-offsets.c                  |    1 +
 arch/riscv/kernel/asm-offsets.c                    |    1 +
 arch/s390/kernel/asm-offsets.c                     |    1 +
 arch/sh/kernel/asm-offsets.c                       |    1 +
 arch/sparc/kernel/asm-offsets.c                    |    1 +
 arch/um/kernel/asm-offsets.c                       |    2 +
 arch/x86/events/intel/core.c                       |   10 +-
 arch/x86/include/asm/perf_event.h                  |    6 +-
 arch/x86/kernel/cpu/bugs.c                         |   27 +-
 arch/x86/kvm/pmu.h                                 |    2 +-
 arch/xtensa/kernel/asm-offsets.c                   |    1 +
 drivers/edac/ecs.c                                 |    0
 drivers/edac/edac_mc_sysfs.c                       |   24 +
 drivers/edac/ie31200_edac.c                        |    4 +
 drivers/edac/mem_repair.c                          |    0
 drivers/edac/scrub.c                               |    0
 fs/btrfs/disk-io.c                                 |    2 +-
 fs/btrfs/extent-tree.c                             |    6 +-
 fs/btrfs/inode.c                                   |    7 +-
 fs/btrfs/scrub.c                                   |    3 +-
 fs/btrfs/transaction.c                             |    2 +-
 fs/btrfs/tree-checker.c                            |   37 +
 fs/btrfs/tree-log.c                                |   64 +-
 fs/btrfs/zoned.c                                   |    8 +-
 fs/btrfs/zoned.h                                   |    9 +-
 include/linux/audit.h                              |    2 +-
 kernel/cgroup/cpuset.c                             |    6 +-
 kernel/events/callchain.c                          |   16 +-
 kernel/events/core.c                               |    7 +-
 kernel/irq/chip.c                                  |    2 +-
 kernel/irq/manage.c                                |    4 +-
 kernel/sched/build_policy.c                        |    1 +
 kernel/sched/ext.c                                 | 1056 +------------------
 kernel/sched/ext.h                                 |   23 -
 kernel/sched/ext_internal.h                        | 1064 ++++++++++++++++++++
 kernel/sched/fair.c                                |    3 -
 kernel/seccomp.c                                   |   32 +-
 kernel/time/timekeeping.c                          |    2 +-
 tools/sched_ext/scx_qmap.bpf.c                     |   18 +-
 54 files changed, 1326 insertions(+), 1150 deletions(-)



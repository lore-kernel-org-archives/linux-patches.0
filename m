Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE8134D387;
	Fri, 31 Oct 2025 14:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919369; cv=none; b=t+ENtcf4/XhUKnGzIqEzb+RLQPRbAbx7Y65yU4aZ7WH2ixzpBn1xxYbsYcx7g9WXxumz1shLHlNmpDG21PumE50I2sRTRuB10+7Fo0lPN5P6uqC8uaS+rX1P5U0sUwFbwPYQFDjJ7Au7UUSPdC6pvk7feHvKsrXX3F36nNpuqmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919369; c=relaxed/simple;
	bh=7gauDtVmZdxF8kYzQPep4JSHyIXeR/fMwkd8eRHdpic=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Jx7Oq6Btn8AAl4TLROfD2ICLKxQGhrnvrr+cDpSWDN8JgiCf3rA7j73eWJs2F9KangmCHPTR692BokHmyCXzRzgrfzHuRyztfpM8v7i/qhov4KEIovWs/3qkWYXBwtwlwHBnsQY0hDFXPf1diCHJaJlNcgN7I3eQ7hUJcOEyATY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p6uA9PNg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p6uA9PNg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64FD3C4CEE7;
	Fri, 31 Oct 2025 14:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919368;
	bh=7gauDtVmZdxF8kYzQPep4JSHyIXeR/fMwkd8eRHdpic=;
	h=From:To:Cc:Subject:Date:From;
	b=p6uA9PNg48VG0vAdcp28M9JaihUMW2iS1XE65EX1fzmHW/7k73mcpHUoQgmtnRZCf
	 ASWriGm3N9rXJis0RGLgvRmRnKzjN4B4g11OeOMjPN1eUZPLZbLeKi/b/alepVXCNW
	 Y3TT3nMWMC+HBTQTInMuvPRAThObh9bEAHMiespI=
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
Subject: [PATCH 6.6 00/32] 6.6.116-rc1 review
Date: Fri, 31 Oct 2025 15:00:54 +0100
Message-ID: <20251031140042.387255981@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.116-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.116-rc1
X-KernelTest-Deadline: 2025-11-02T14:00+00:00
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.116 release.
There are 32 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 02 Nov 2025 14:00:34 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.116-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.116-rc1

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

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: dbc: fix bogus 1024 byte prefix if ttyDBC read races with stall event

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: dbc: Avoid event polling busyloop if pending rx transfers are inactive.

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: dbc: Improve performance by removing delay in transfer event polling.

Uday M Bhat <uday.m.bhat@intel.com>
    xhci: dbc: Allow users to modify DbC poll interval via sysfs

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: dbc: poll at different rate depending on data transfer activity

Hugo Villeneuve <hvilleneuve@dimonoff.com>
    serial: sc16is7xx: remove useless enable of enhanced features

Hugo Villeneuve <hvilleneuve@dimonoff.com>
    serial: sc16is7xx: refactor EFR lock

Hugo Villeneuve <hvilleneuve@dimonoff.com>
    serial: sc16is7xx: reorder code to remove prototype declarations

Hugo Villeneuve <hvilleneuve@dimonoff.com>
    serial: sc16is7xx: remove unused to_sc16is7xx_port macro

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: mark 'delete re-add signal' as skipped if not supported

Geliang Tang <tanggeliang@kylinos.cn>
    selftests: mptcp: disable add_addr retrans in endpoint_tests

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: in-kernel: C-flag: handle late ADD_ADDR

Menglong Dong <menglong8.dong@gmail.com>
    arch: Add the macro COMPILE_OFFSETS to all the asm-offsets.c

Filipe Manana <fdmanana@suse.com>
    btrfs: use smp_mb__after_atomic() when forcing COW in create_pending_snapshot()

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

Avadhut Naik <avadhut.naik@amd.com>
    EDAC/mc_sysfs: Increase legacy channel support to 16

David Kaplan <david.kaplan@amd.com>
    x86/bugs: Fix reporting of LFENCE retpoline

David Kaplan <david.kaplan@amd.com>
    x86/bugs: Report correct retbleed mitigation status

Josh Poimboeuf <jpoimboe@kernel.org>
    perf: Skip user unwind if the task is a kernel thread

Josh Poimboeuf <jpoimboe@kernel.org>
    perf: Have get_perf_callchain() return NULL if crosstask and user are set

Steven Rostedt <rostedt@goodmis.org>
    perf: Use current->flags & PF_KTHREAD|PF_USER_WORKER instead of current->mm == NULL

Richard Guy Briggs <rgb@redhat.com>
    audit: record fanotify event regardless of presence of rules

Xiang Mei <xmei5@asu.edu>
    net/sched: sch_qfq: Fix null-deref in agg_dequeue


-------------

Diffstat:

 .../ABI/testing/sysfs-bus-pci-drivers-xhci_hcd     |  10 ++
 Makefile                                           |   4 +-
 arch/alpha/kernel/asm-offsets.c                    |   1 +
 arch/arc/kernel/asm-offsets.c                      |   1 +
 arch/arm/kernel/asm-offsets.c                      |   2 +
 arch/arm64/kernel/asm-offsets.c                    |   1 +
 arch/csky/kernel/asm-offsets.c                     |   1 +
 arch/hexagon/kernel/asm-offsets.c                  |   1 +
 arch/loongarch/kernel/asm-offsets.c                |   2 +
 arch/m68k/kernel/asm-offsets.c                     |   1 +
 arch/microblaze/kernel/asm-offsets.c               |   1 +
 arch/mips/kernel/asm-offsets.c                     |   2 +
 arch/nios2/kernel/asm-offsets.c                    |   1 +
 arch/openrisc/kernel/asm-offsets.c                 |   1 +
 arch/parisc/kernel/asm-offsets.c                   |   1 +
 arch/powerpc/kernel/asm-offsets.c                  |   1 +
 arch/riscv/kernel/asm-offsets.c                    |   1 +
 arch/s390/kernel/asm-offsets.c                     |   1 +
 arch/sh/kernel/asm-offsets.c                       |   1 +
 arch/sparc/kernel/asm-offsets.c                    |   1 +
 arch/um/kernel/asm-offsets.c                       |   2 +
 arch/x86/kernel/cpu/bugs.c                         |   9 +-
 arch/xtensa/kernel/asm-offsets.c                   |   1 +
 drivers/edac/edac_mc_sysfs.c                       |  24 +++
 drivers/gpio/gpio-idio-16.c                        |   5 +
 drivers/gpio/gpio-regmap.c                         |  53 +++++-
 drivers/tty/serial/sc16is7xx.c                     | 185 ++++++++++-----------
 drivers/usb/host/xhci-dbgcap.c                     |  70 +++++++-
 drivers/usb/host/xhci-dbgcap.h                     |   7 +-
 fs/btrfs/disk-io.c                                 |   2 +-
 fs/btrfs/extent-tree.c                             |   6 +-
 fs/btrfs/inode.c                                   |   7 +-
 fs/btrfs/scrub.c                                   |   3 +-
 fs/btrfs/transaction.c                             |   2 +-
 fs/btrfs/tree-log.c                                |   9 +-
 fs/btrfs/zoned.c                                   |   8 +-
 fs/btrfs/zoned.h                                   |   9 +-
 include/linux/audit.h                              |   2 +-
 include/linux/bitops.h                             |   1 -
 include/linux/bits.h                               |  38 ++++-
 include/linux/gpio/regmap.h                        |  16 ++
 include/net/pkt_sched.h                            |  25 ++-
 kernel/events/callchain.c                          |  16 +-
 kernel/events/core.c                               |   7 +-
 net/mptcp/pm_netlink.c                             |   6 +
 net/sched/sch_api.c                                |  10 --
 net/sched/sch_hfsc.c                               |  16 --
 net/sched/sch_qfq.c                                |   2 +-
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |   3 +-
 49 files changed, 405 insertions(+), 174 deletions(-)



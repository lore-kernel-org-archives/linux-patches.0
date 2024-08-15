Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C18F1B1506;
	Thu, 15 Aug 2024 14:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730722; cv=none; b=hwUOseY+YNF2wGY+BgwdZ3DMun56bpWrLXSy+WyALQNSmHweKpW3kBiJeUBJ+iJ1pYYXqhMJHVp0sXDxIXk9WpSMsVylw11QLsvl2T1YNRO6vE226wflvBHEfCtJPgzi3z1AABkn2D/olbglOVsnNG6oeleVAUcxe8cE9qKW1ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730722; c=relaxed/simple;
	bh=eji902DDgOk3QU750A1W35qOU7VXtqWsiXRYdbxl8aU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ZYLedu9JvUHgDksrmSm0bE0DP51cxZCESUwl8BXRkVEagxgU39US3NrYiZSXgi/74vFJgdAwZ5OM3NllfAKfduFk2FAT9NXkMORJomxoinpdbbsZ25WpvVgshBdrkFy1BJhI2MRlNDlqlj/WzKQlpQaFYg8LpljAKHa2c4wTF10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bF2724Wd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bF2724Wd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BED63C32786;
	Thu, 15 Aug 2024 14:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730722;
	bh=eji902DDgOk3QU750A1W35qOU7VXtqWsiXRYdbxl8aU=;
	h=From:To:Cc:Subject:Date:From;
	b=bF2724WdAodA/d036kRj69DLtKG4p+u1/DJCQKd988Kr3nf2yD2PfEtjFhkgwNiuR
	 0Cz98Z2dkIl0ffQifyKnnH4qDtyoCooHxh8b53uLWut3zlJ0aN4g1bYiZBbk+U+NrA
	 /+Zspq98HhLnaGxrvnuEmuAkeiyubFg9so9g39Tk=
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
	allen.lkml@gmail.com,
	broonie@kernel.org
Subject: [PATCH 6.1 00/38] 6.1.106-rc1 review
Date: Thu, 15 Aug 2024 15:25:34 +0200
Message-ID: <20240815131832.944273699@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.106-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.106-rc1
X-KernelTest-Deadline: 2024-08-17T13:18+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.1.106 release.
There are 38 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 17 Aug 2024 13:18:17 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.106-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.106-rc1

Will Deacon <will@kernel.org>
    KVM: arm64: Don't pass a TLBI level hint when zapping table entries

Eric Dumazet <edumazet@google.com>
    wifi: cfg80211: restrict NL80211_ATTR_TXQ_QUANTUM values

Waiman Long <longman@redhat.com>
    cgroup: Move rcu_head up near the top of cgroup_root

Kees Cook <kees@kernel.org>
    binfmt_flat: Fix corruption when not offsetting data start

Andi Shyti <andi.shyti@linux.intel.com>
    drm/i915/gem: Adjust vma offset for framebuffer mmap offset

Dan Carpenter <dan.carpenter@linaro.org>
    drm/i915: Fix a NULL vs IS_ERR() bug

Nirmoy Das <nirmoy.das@intel.com>
    drm/i915: Add a function to mmap framebuffer obj

Yafang Shao <laoar.shao@gmail.com>
    cgroup: Make operations on the cgroup root_list RCU safe

Andi Shyti <andi.shyti@linux.intel.com>
    drm/i915/gem: Fix Virtual Memory mapping boundaries calculation

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: fully established after ADD_ADDR echo on MPJ

WangYuli <wangyuli@uniontech.com>
    nvme/pci: Add APST quirk for Lenovo N60z laptop

Josef Bacik <josef@toxicpanda.com>
    nfsd: make svc_stat per-network namespace instead of global

Josef Bacik <josef@toxicpanda.com>
    nfsd: remove nfsd_stats, make th_cnt a global counter

Josef Bacik <josef@toxicpanda.com>
    nfsd: make all of the nfsd stats per-network namespace

Josef Bacik <josef@toxicpanda.com>
    nfsd: expose /proc/net/sunrpc/nfsd in net namespaces

Josef Bacik <josef@toxicpanda.com>
    nfsd: rename NFSD_NET_* to NFSD_STATS_*

Josef Bacik <josef@toxicpanda.com>
    sunrpc: use the struct net as the svc proc private

Josef Bacik <josef@toxicpanda.com>
    sunrpc: remove ->pg_stats from svc_program

Josef Bacik <josef@toxicpanda.com>
    sunrpc: pass in the sv_stats struct through svc_create_pooled

Josef Bacik <josef@toxicpanda.com>
    nfsd: stop setting ->pg_stats for unused stats

Josef Bacik <josef@toxicpanda.com>
    sunrpc: don't change ->sv_stats if it doesn't exist

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Fix frame size warning in svc_export_parse()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Rewrite synopsis of nfsd_percpu_counters_init()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Refactor the duplicate reply cache shrinker

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace nfsd_prune_bucket()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Rename nfsd_reply_cache_alloc()

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Refactor nfsd_reply_cache_free_locked()

Jeff Layton <jlayton@kernel.org>
    nfsd: move init of percpu reply_cache_stats counters back to nfsd_init_net

Jeff Layton <jlayton@kernel.org>
    nfsd: move reply cache initialization into nfsd startup

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Define __ARCH_WANT_NEW_STAT in unistd.h

Kees Cook <kees@kernel.org>
    exec: Fix ToCToU between perm check and set-uid/gid usage

Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
    ASoC: topology: Fix route memory corruption

Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
    ASoC: topology: Clean up route loading

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: test both signal & subflow

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: do not ignore 'subflow' if 'signal' flag is also set

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: don't try to create sf if alloc failed

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: reduce indentation blocks

Geliang Tang <geliang.tang@suse.com>
    mptcp: pass addr to mptcp_pm_alloc_anno_list


-------------

Diffstat:

 Makefile                                        |   4 +-
 arch/arm64/kvm/hyp/pgtable.c                    |  10 +-
 arch/loongarch/include/uapi/asm/unistd.h        |   1 +
 drivers/gpu/drm/i915/gem/i915_gem_mman.c        | 192 ++++++++++++++++------
 drivers/gpu/drm/i915/gem/i915_gem_mman.h        |   2 +-
 drivers/nvme/host/pci.c                         |   7 +
 fs/binfmt_flat.c                                |   4 +-
 fs/exec.c                                       |   8 +-
 fs/lockd/svc.c                                  |   3 -
 fs/nfs/callback.c                               |   3 -
 fs/nfsd/export.c                                |  32 ++--
 fs/nfsd/export.h                                |   4 +-
 fs/nfsd/netns.h                                 |  25 ++-
 fs/nfsd/nfs4proc.c                              |   6 +-
 fs/nfsd/nfscache.c                              | 201 ++++++++++++++----------
 fs/nfsd/nfsctl.c                                |  24 ++-
 fs/nfsd/nfsd.h                                  |   1 +
 fs/nfsd/nfsfh.c                                 |   3 +-
 fs/nfsd/nfssvc.c                                |  24 +--
 fs/nfsd/stats.c                                 |  52 +++---
 fs/nfsd/stats.h                                 |  83 ++++------
 fs/nfsd/trace.h                                 |  22 +++
 fs/nfsd/vfs.c                                   |   6 +-
 include/linux/cgroup-defs.h                     |   7 +-
 include/linux/sunrpc/svc.h                      |   5 +-
 kernel/cgroup/cgroup-internal.h                 |   3 +-
 kernel/cgroup/cgroup.c                          |  23 ++-
 net/mptcp/options.c                             |   3 +-
 net/mptcp/pm_netlink.c                          |  49 +++---
 net/mptcp/pm_userspace.c                        |   2 +-
 net/mptcp/protocol.h                            |   2 +-
 net/sunrpc/stats.c                              |   2 +-
 net/sunrpc/svc.c                                |  36 +++--
 net/wireless/nl80211.c                          |   6 +-
 sound/soc/soc-topology.c                        |  32 +---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |  14 ++
 36 files changed, 555 insertions(+), 346 deletions(-)



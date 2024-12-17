Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7BE51F707D;
	Tue, 17 Dec 2024 17:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455520; cv=none; b=set/RJ9lMoVQR9a3UiDj7ahXRimbSieZKy6mPnjxzoxnwwS5YGpXIL7E8p/unjKqwVxtG0JR3L976AfnqC9XJ/PiUSx8IYPJALHMCQlSLjUiuW3LMgca1un7T54laAb/2fMVM729RjZ05Hff2vYDWjb1ZSCuWVPVNabTHBHnYT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455520; c=relaxed/simple;
	bh=Zyxt59rEmZ1bxrDVQDnZq15NkUsFlTUdCwdCjjg6RJc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=SdBqF3U+sI0pV/aM4RLK1+89vFq/g9eZ4g1+P0Lot+V56A5wcJ3iP7YSEXGXnKA4jx8wjh5Q/Ki2TN9l+7QzUdw0GlYZ8tEL3TPpmEuDLmEpVwDugJEDQdMXGAkt39EVkrkATY6ypqJUjhD8IhC1+Uv07Jfx0VxfZwdVLR/u+kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BKVWrSsO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BKVWrSsO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B54E2C4CED3;
	Tue, 17 Dec 2024 17:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455519;
	bh=Zyxt59rEmZ1bxrDVQDnZq15NkUsFlTUdCwdCjjg6RJc=;
	h=From:To:Cc:Subject:Date:From;
	b=BKVWrSsOWHlrc2o1wrSAihhxr2CHEsulKymY3VAGK+iPzvfQ6Kebw/+nWsHi/7Vxg
	 9JXdDzU8Ef5ZsOnneAl5IgKcLnXce2qw/6dBDrcaEkrkPvWYwGYdsj7a8Y58NVG+h4
	 1GZqF19thZZmDouHBugWovpIBG9wBhwfJ7Nl1XMs=
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
Subject: [PATCH 5.10 00/43] 5.10.232-rc1 review
Date: Tue, 17 Dec 2024 18:06:51 +0100
Message-ID: <20241217170520.459491270@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.232-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.232-rc1
X-KernelTest-Deadline: 2024-12-19T17:05+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.10.232 release.
There are 43 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 19 Dec 2024 17:05:03 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.232-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.232-rc1

Dan Carpenter <dan.carpenter@linaro.org>
    ALSA: usb-audio: Fix a DMA to stack memory bug

Juergen Gross <jgross@suse.com>
    x86/xen: remove hypercall page

Juergen Gross <jgross@suse.com>
    x86/xen: use new hypercall functions instead of hypercall page

Juergen Gross <jgross@suse.com>
    x86/xen: add central hypercall functions

Juergen Gross <jgross@suse.com>
    x86/xen: don't do PV iret hypercall through hypercall page

Juergen Gross <jgross@suse.com>
    x86/static-call: provide a way to do very early static-call updates

Juergen Gross <jgross@suse.com>
    objtool/x86: allow syscall instruction

Juergen Gross <jgross@suse.com>
    x86: make get_cpu_vendor() accessible from Xen code

Juergen Gross <jgross@suse.com>
    xen/netfront: fix crash when removing device

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "clkdev: remove CONFIG_CLKDEV_LOOKUP"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "clocksource/drivers:sp804: Make user selectable"

Jiasheng Jiang <jiashengjiangcool@outlook.com>
    drm/i915: Fix memory leak by correcting cache object name in error handler

Nikolay Kuratov <kniv@yandex-team.ru>
    tracing/kprobes: Skip symbol counting logic for module symbols in create_local_trace_kprobe()

Eduard Zingerman <eddyz87@gmail.com>
    bpf: sync_linked_regs() must preserve subreg_def

Nathan Chancellor <nathan@kernel.org>
    blk-iocost: Avoid using clamp() on inuse in __propagate_weights()

Daniil Tatianin <d-tatianin@yandex-team.ru>
    ACPICA: events/evxfregn: don't release the ContextMutex that was never acquired

Daniel Borkmann <daniel@iogearbox.net>
    team: Fix feature propagation of NETIF_F_GSO_ENCAP_ALL

Daniel Borkmann <daniel@iogearbox.net>
    bonding: Fix feature propagation of NETIF_F_GSO_ENCAP_ALL

Alexander Lobakin <alobakin@pm.me>
    net: bonding, dummy, ifb, team: advertise NETIF_F_GSO_SOFTWARE

Martin Ottens <martin.ottens@fau.de>
    net/sched: netem: account for backlog updates from child qdisc

Stefan Wahren <wahrenst@gmx.net>
    qca_spi: Make driver probing reliable

Stefan Wahren <wahrenst@gmx.net>
    qca_spi: Fix clock speed for multiple QCA7000

Anumula Murali Mohan Reddy <anumula@chelsio.com>
    cxgb4: use port number to set mac addr

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    ACPI: resource: Fix memory resource type union access

Eric Dumazet <edumazet@google.com>
    net: lapb: increase LAPB_HEADER_LEN

Danielle Ratson <danieller@nvidia.com>
    selftests: mlxsw: sharedbuffer: Remove duplicate test cases

Danielle Ratson <danieller@nvidia.com>
    selftests: mlxsw: sharedbuffer: Remove h1 ingress test case

Eric Dumazet <edumazet@google.com>
    tipc: fix NULL deref in cleanup_bearer()

Remi Pommarel <repk@triplefau.lt>
    batman-adv: Do not let TT changes list grows indefinitely

Remi Pommarel <repk@triplefau.lt>
    batman-adv: Remove uninitialized data in full table TT response

Remi Pommarel <repk@triplefau.lt>
    batman-adv: Do not send uninitialized TT changes

Suraj Sonawane <surajsonawane0215@gmail.com>
    acpi: nfit: vmalloc-out-of-bounds Read in acpi_nfit_ctl

Sungjong Seo <sj1557.seo@samsung.com>
    exfat: fix potential deadlock on __exfat_get_dentry_set

Michal Luczaj <mhal@rbox.co>
    virtio/vsock: Fix accept_queue memory leak

Michal Luczaj <mhal@rbox.co>
    bpf, sockmap: Fix update element with same

Darrick J. Wong <djwong@kernel.org>
    xfs: fix scrub tracepoints when inode-rooted btrees are involved

Darrick J. Wong <djwong@kernel.org>
    xfs: don't drop errno values when we fail to ficlone the entire range

Lianqin Hu <hulianqin@vivo.com>
    usb: gadget: u_serial: Fix the issue that gs_start_io crashed due to accessing null pointer

Vitalii Mordan <mordan@ispras.ru>
    usb: ehci-hcd: fix call balance of clocks handling routines

Stefan Wahren <wahrenst@gmx.net>
    usb: dwc2: hcd: Fix GetPortStatus & SetPortFeature

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    ata: sata_highbank: fix OF node reference leak in highbank_initialize_phys()

Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
    usb: host: max3421-hcd: Correctly abort a USB request.

MoYuanhao <moyuanhao3676@163.com>
    tcp: check space before adding MPTCP SYN options


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm/Kconfig                                   |  2 +
 arch/mips/Kconfig                                  |  3 +
 arch/mips/pic32/Kconfig                            |  1 +
 arch/sh/Kconfig                                    |  1 +
 arch/x86/include/asm/processor.h                   |  2 +
 arch/x86/include/asm/static_call.h                 | 15 ++++
 arch/x86/include/asm/sync_core.h                   |  6 +-
 arch/x86/include/asm/xen/hypercall.h               | 36 ++++----
 arch/x86/kernel/cpu/common.c                       | 38 +++++----
 arch/x86/kernel/static_call.c                      | 10 +++
 arch/x86/xen/enlighten.c                           | 65 ++++++++++++++-
 arch/x86/xen/enlighten_hvm.c                       | 13 ++-
 arch/x86/xen/enlighten_pv.c                        |  4 +-
 arch/x86/xen/enlighten_pvh.c                       |  7 --
 arch/x86/xen/xen-asm.S                             | 49 +++++++++--
 arch/x86/xen/xen-head.S                            | 97 ++++++++++++++++++----
 arch/x86/xen/xen-ops.h                             |  9 ++
 block/blk-iocost.c                                 |  9 +-
 drivers/acpi/acpica/evxfregn.c                     |  2 -
 drivers/acpi/nfit/core.c                           |  7 +-
 drivers/acpi/resource.c                            |  6 +-
 drivers/ata/sata_highbank.c                        |  1 +
 drivers/clk/Kconfig                                |  6 +-
 drivers/clk/Makefile                               |  3 +-
 drivers/clocksource/Kconfig                        |  9 +-
 drivers/gpu/drm/i915/i915_scheduler.c              |  2 +-
 drivers/mmc/host/Kconfig                           |  4 +-
 drivers/net/bonding/bond_main.c                    | 12 +--
 drivers/net/dummy.c                                |  2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h         |  2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |  2 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c         |  5 +-
 drivers/net/ethernet/qualcomm/qca_spi.c            | 26 +++---
 drivers/net/ethernet/qualcomm/qca_spi.h            |  1 -
 drivers/net/ifb.c                                  |  3 +-
 drivers/net/team/team.c                            | 12 +--
 drivers/net/xen-netfront.c                         |  5 +-
 drivers/staging/board/Kconfig                      |  2 +-
 drivers/usb/dwc2/hcd.c                             | 16 ++--
 drivers/usb/gadget/function/u_serial.c             |  9 +-
 drivers/usb/host/ehci-sh.c                         |  9 +-
 drivers/usb/host/max3421-hcd.c                     | 16 ++--
 fs/exfat/dir.c                                     |  2 +-
 fs/xfs/scrub/trace.h                               |  2 +-
 fs/xfs/xfs_file.c                                  |  8 ++
 include/linux/compiler.h                           | 34 +++++---
 include/linux/static_call.h                        |  1 +
 include/net/lapb.h                                 |  2 +-
 kernel/bpf/verifier.c                              |  5 +-
 kernel/static_call.c                               |  2 +-
 kernel/trace/trace_kprobe.c                        |  2 +-
 net/batman-adv/translation-table.c                 | 58 +++++++++----
 net/core/sock_map.c                                |  1 +
 net/ipv4/tcp_output.c                              |  6 +-
 net/sched/sch_netem.c                              | 22 +++--
 net/tipc/udp_media.c                               |  7 +-
 net/vmw_vsock/virtio_transport_common.c            |  8 ++
 sound/soc/dwc/Kconfig                              |  2 +-
 sound/soc/rockchip/Kconfig                         | 14 ++--
 sound/usb/quirks.c                                 | 31 ++++---
 tools/objtool/check.c                              | 11 ++-
 .../selftests/drivers/net/mlxsw/sharedbuffer.sh    | 15 ----
 63 files changed, 534 insertions(+), 232 deletions(-)



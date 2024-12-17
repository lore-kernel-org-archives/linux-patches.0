Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E68E01F6671;
	Tue, 17 Dec 2024 17:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455400; cv=none; b=A8EjObxxsFmACSvZylmprr3GkOxxS2SLqv+HvJAiBdrTSv0yuX6XbeIU06I3vjPCJ/uttPIkzSknO7nCmpjM8k0tvYOy0hIkbSufb+c/gD8RQq/JGIiEWNHDBO0dgPv2qTvGxUUZHly8WS7mgbkKyMxTMWpnzFaEZjZ8RHdfQGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455400; c=relaxed/simple;
	bh=acxSIiL8ZpYu93GiwGA08to7fI7SRuWd4yGeCHGn/B8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=C2hx4SET0dVLot2SUR+WvEhGbPmzHj/cKfkW5tylCI8aBnvKbMk41SNcz53se+Vv0hpHitRk20IFn8Nx4UQBavYIIuOzwByh2xzOaoN90wmmq73nmie9j5+Ib2Kcpxaz+vE/OhyoxqZjs/+IxHy+vYsj2TlVIiCz0Srcguta6fE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iHmGl2n9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iHmGl2n9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC29DC4CED3;
	Tue, 17 Dec 2024 17:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455399;
	bh=acxSIiL8ZpYu93GiwGA08to7fI7SRuWd4yGeCHGn/B8=;
	h=From:To:Cc:Subject:Date:From;
	b=iHmGl2n9uHy7ngCMcoVmWPA2wTU5Ha2cu1k2gk/skctpyrU5JcSdmCMyQ6DLenUHo
	 NwRDsgBPQtvhP58DAnrwalecGVviSAt4bmDVbXU/PHjaUrJ0CGw0VvEeWlZXgZ5DeW
	 JYJKWIGgUTdcXMzYPjIjmy7exNIe2XAnJF8ut9hk=
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
Subject: [PATCH 5.4 00/24] 5.4.288-rc1 review
Date: Tue, 17 Dec 2024 18:06:58 +0100
Message-ID: <20241217170519.006786596@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.288-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.288-rc1
X-KernelTest-Deadline: 2024-12-19T17:05+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.4.288 release.
There are 24 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 19 Dec 2024 17:05:03 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.288-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.288-rc1

Dan Carpenter <dan.carpenter@linaro.org>
    ALSA: usb-audio: Fix a DMA to stack memory bug

Juergen Gross <jgross@suse.com>
    xen/netfront: fix crash when removing device

Nikolay Kuratov <kniv@yandex-team.ru>
    tracing/kprobes: Skip symbol counting logic for module symbols in create_local_trace_kprobe()

Raghavendra Rao Ananta <rananta@google.com>
    KVM: arm64: Ignore PMCNTENSET_EL0 while checking for overflow status

Nathan Chancellor <nathan@kernel.org>
    blk-iocost: Avoid using clamp() on inuse in __propagate_weights()

Tejun Heo <tj@kernel.org>
    blk-iocost: fix weight updates of inner active iocgs

Tejun Heo <tj@kernel.org>
    blk-iocost: clamp inuse and skip noops in __propagate_weights()

Daniil Tatianin <d-tatianin@yandex-team.ru>
    ACPICA: events/evxfregn: don't release the ContextMutex that was never acquired

Martin Ottens <martin.ottens@fau.de>
    net/sched: netem: account for backlog updates from child qdisc

Stefan Wahren <wahrenst@gmx.net>
    qca_spi: Make driver probing reliable

Stefan Wahren <wahrenst@gmx.net>
    qca_spi: Fix clock speed for multiple QCA7000

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    ACPI: resource: Fix memory resource type union access

Eric Dumazet <edumazet@google.com>
    net: lapb: increase LAPB_HEADER_LEN

Eric Dumazet <edumazet@google.com>
    tipc: fix NULL deref in cleanup_bearer()

Remi Pommarel <repk@triplefau.lt>
    batman-adv: Do not let TT changes list grows indefinitely

Remi Pommarel <repk@triplefau.lt>
    batman-adv: Remove uninitialized data in full table TT response

Remi Pommarel <repk@triplefau.lt>
    batman-adv: Do not send uninitialized TT changes

Michal Luczaj <mhal@rbox.co>
    bpf, sockmap: Fix update element with same

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


-------------

Diffstat:

 Makefile                                |  4 +--
 block/blk-iocost.c                      | 24 ++++++++++++--
 drivers/acpi/acpica/evxfregn.c          |  2 --
 drivers/acpi/resource.c                 |  6 ++--
 drivers/ata/sata_highbank.c             |  1 +
 drivers/net/ethernet/qualcomm/qca_spi.c | 26 +++++++--------
 drivers/net/ethernet/qualcomm/qca_spi.h |  1 -
 drivers/net/xen-netfront.c              |  5 ++-
 drivers/usb/dwc2/hcd.c                  | 16 ++++-----
 drivers/usb/gadget/function/u_serial.c  |  9 +++--
 drivers/usb/host/ehci-sh.c              |  9 +++--
 drivers/usb/host/max3421-hcd.c          | 16 ++++++---
 fs/xfs/xfs_file.c                       |  8 +++++
 include/net/lapb.h                      |  2 +-
 kernel/trace/trace_kprobe.c             |  2 +-
 net/batman-adv/translation-table.c      | 58 +++++++++++++++++++++++----------
 net/core/sock_map.c                     |  1 +
 net/sched/sch_netem.c                   | 22 +++++++++----
 net/tipc/udp_media.c                    |  7 +++-
 sound/usb/quirks.c                      | 31 ++++++++++++------
 virt/kvm/arm/pmu.c                      |  1 -
 21 files changed, 167 insertions(+), 84 deletions(-)



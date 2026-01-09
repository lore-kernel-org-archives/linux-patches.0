Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 604D333D50F;
	Fri,  9 Jan 2026 11:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959106; cv=none; b=otgha7quV5cJixsMo2Sbzg4lfNmxUgl0jcWSAFVOiYHle3zid2+sSmJdfOeWha3ytz8MKeGOH6knxyCT6NW9egCwPm1ON2oVAlocUHEk5FWggP4Cd7EMrJ07uUNuuyzEExxD1UhAH3mR5NMJIJsIVSw0gFoClzH9uS22tjs8Yk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959106; c=relaxed/simple;
	bh=Rra7MijX0lUdU37/9qu5zl47tGB6P3MdW7CaerQmW7w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nDVB3oO5sNPUrAyIW+wCZP8GHYpAuU2OCDtWqbFe4c+3bG4ybtRhjUrd00nY9wlsPt417aL8jyV0QzvF5/6FfCSuCjCcZEvVtt8Z7on1yEoIAwEdHa/L3qVAZCgoUvjoyC0s8uFPX81kJM6oVNGDRg+6C2FM3LO6klnOCcnwKZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YOjvAzVD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YOjvAzVD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC059C4CEF1;
	Fri,  9 Jan 2026 11:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959105;
	bh=Rra7MijX0lUdU37/9qu5zl47tGB6P3MdW7CaerQmW7w=;
	h=From:To:Cc:Subject:Date:From;
	b=YOjvAzVDErIzU7DoixEnpA0abEBKloVQ5mGA55qPD+wOLRj249cH1+Qqzwgg8QKZH
	 dXj29zRkT0RbXTQTzeQDA68cn5Kf5hX98p6go8epK+MfA91MjbDyYpRgCZs1CVIEFP
	 pKe+BfkAJmJ9RlWe+MQKhMS/l4ii7zZ+51Zb29iU=
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
Subject: [PATCH 6.12 00/16] 6.12.65-rc1 review
Date: Fri,  9 Jan 2026 12:43:41 +0100
Message-ID: <20260109111951.415522519@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.65-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.12.65-rc1
X-KernelTest-Deadline: 2026-01-11T11:19+00:00
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.12.65 release.
There are 16 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 11 Jan 2026 11:19:41 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.65-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.12.65-rc1

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "iommu/amd: Skip enabling command/event buffers for kdump"

Sean Nyekjaer <sean@geanix.com>
    pwm: stm32: Always program polarity

Maximilian Immanuel Brandtner <maxbr@linux.ibm.com>
    virtio_console: fix order of fields cols and rows

Peter Zijlstra <peterz@infradead.org>
    sched/fair: Proportional newidle balance

Peter Zijlstra <peterz@infradead.org>
    sched/fair: Small cleanup to update_newidle_cost()

Peter Zijlstra <peterz@infradead.org>
    sched/fair: Small cleanup to sched_balance_newidle()

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    net: Remove RTNL dance for SIOCBRADDIF and SIOCBRDELIF.

Richa Bharti <richa.bharti@siemens.com>
    cpufreq: intel_pstate: Check IDA only before MSR_IA32_PERF_CTL writes

Natalie Vock <natalie.vock@gmx.de>
    drm/amdgpu: Forward VMID reservation errors

Miaoqian Lin <linmq006@gmail.com>
    net: phy: mediatek: fix nvmem cell reference leak in mt798x_phy_calibration

Jouni Malinen <jouni.malinen@oss.qualcomm.com>
    wifi: mac80211: Discard Beacon frames to non-broadcast address

Paolo Abeni <pabeni@redhat.com>
    mptcp: ensure context reset on disconnect()

Bijan Tabatabai <bijan311@gmail.com>
    mm: consider non-anon swap cache folios in folio_expected_ref_count()

David Hildenbrand <david@redhat.com>
    mm: simplify folio_expected_ref_count()

Alexander Gordeev <agordeev@linux.ibm.com>
    mm/page_alloc: change all pageblocks migrate type on coalescing

Paolo Abeni <pabeni@redhat.com>
    mptcp: fallback earlier on simult connection


-------------

Diffstat:

 Makefile                               |  4 +--
 drivers/char/virtio_console.c          |  2 +-
 drivers/cpufreq/intel_pstate.c         |  9 +++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c |  6 ++--
 drivers/iommu/amd/init.c               | 28 +++++----------
 drivers/net/phy/mediatek-ge-soc.c      |  2 +-
 drivers/pwm/pwm-stm32.c                |  3 +-
 include/linux/if_bridge.h              |  6 ++--
 include/linux/mm.h                     | 10 +++---
 include/linux/sched/topology.h         |  3 ++
 kernel/sched/core.c                    |  3 ++
 kernel/sched/fair.c                    | 65 +++++++++++++++++++++++++++-------
 kernel/sched/features.h                |  5 +++
 kernel/sched/sched.h                   |  7 ++++
 kernel/sched/topology.c                |  6 ++++
 mm/page_alloc.c                        | 24 ++++++-------
 net/bridge/br_ioctl.c                  | 36 +++++++++++++++++--
 net/bridge/br_private.h                |  3 +-
 net/core/dev_ioctl.c                   | 16 ---------
 net/mac80211/rx.c                      |  5 +++
 net/mptcp/options.c                    | 10 ++++++
 net/mptcp/protocol.c                   |  8 +++--
 net/mptcp/protocol.h                   |  9 +++--
 net/mptcp/subflow.c                    | 10 +-----
 net/socket.c                           | 19 +++++-----
 25 files changed, 186 insertions(+), 113 deletions(-)



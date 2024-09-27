Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5DF818C33C;
	Fri, 27 Sep 2024 12:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440233; cv=none; b=mhMDo2+YuwKIdJ9Ldhru7guBooX08dOS9HnU9Xn3BwRQ1GMK6dDBN53khXgfATle3S3jdjIVHLnvzmXDA1gk5XCOVP8Na/7dKRvZvq+Vm1He9rNkVtEmO70JjTGW9UTomHareJBM0BfFMqXtPT9qqjaXzRqRPkBgOMUI7CPUQp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440233; c=relaxed/simple;
	bh=BkpU5HDKgClJecuAz/1QvgWI1zEZOPsVGHrUna7gqx4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=StdqsR+H0LlBoAu7oPzhAPpJ9QZh+niJAt0hKhZCu19++gKNtZx9fgPx2UIrU/UvlOnt8hCWy05jVpZamnA9zBuZ9pGiIgII+ZPxUHuHZoNFRjCTc+zMvChlDGhAfzfc2EQhadpZxn2az6eQflS8F/Qjiitv8ekDss0UMltIrGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PhVsUHJU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PhVsUHJU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C50D9C4CEC6;
	Fri, 27 Sep 2024 12:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440231;
	bh=BkpU5HDKgClJecuAz/1QvgWI1zEZOPsVGHrUna7gqx4=;
	h=From:To:Cc:Subject:Date:From;
	b=PhVsUHJUdRQLuXTuxnbO8QGcII4QFGwgFAERP+GFFVHGiZprunZSnmD+vC6eWPQhZ
	 k3dlhf0mdiEEjj2r8VNO2muJR2CvvWEtvletg/VEumAl77GsHlZYtVt9B4gJzHXZJj
	 +DG+ik1z0uc31hFFKNQbJi+cijAosFkTjoZzfi9Y=
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
Subject: [PATCH 6.11 00/12] 6.11.1-rc1 review
Date: Fri, 27 Sep 2024 14:24:03 +0200
Message-ID: <20240927121715.213013166@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.11.1-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.11.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.11.1-rc1
X-KernelTest-Deadline: 2024-09-29T12:17+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.11.1 release.
There are 12 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 29 Sep 2024 12:17:00 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.11.1-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.11.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.11.1-rc1

Edward Adam Davis <eadavis@qq.com>
    USB: usbtmc: prevent kernel-usb-infoleak

Junhao Xie <bigfoot@classfun.cn>
    USB: serial: pl2303: add device id for Macrosilicon MS3020

Keith Busch <kbusch@kernel.org>
    nvme-pci: qdepth 1 quirk

Vijendar Mukunda <Vijendar.Mukunda@amd.com>
    ASoC: amd: acp: add ZSC control register programming sequence

Kiran K <kiran.k@intel.com>
    Bluetooth: btintel_pcie: Allocate memory for driver private data

Dan Carpenter <dan.carpenter@linaro.org>
    netfilter: nft_socket: Fix a NULL vs IS_ERR() bug in nft_socket_cgroup_subtree_level()

Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>
    cpufreq/amd-pstate: Add the missing cpufreq_cpu_put()

Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>
    powercap/intel_rapl: Fix the energy-pkg event for AMD CPUs

Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>
    powercap/intel_rapl: Add support for AMD family 1Ah

Michał Winiarski <michal.winiarski@intel.com>
    drm: Expand max DRM device number to full MINORBITS

Michał Winiarski <michal.winiarski@intel.com>
    accel: Use XArray instead of IDR for minors

Michał Winiarski <michal.winiarski@intel.com>
    drm: Use XArray instead of IDR for minors


-------------

Diffstat:

 Makefile                              |   4 +-
 drivers/accel/drm_accel.c             | 110 +++-------------------------------
 drivers/bluetooth/btintel_pcie.c      |   2 +-
 drivers/cpufreq/amd-pstate.c          |   5 +-
 drivers/gpu/drm/drm_drv.c             |  97 +++++++++++++++---------------
 drivers/gpu/drm/drm_file.c            |   2 +-
 drivers/gpu/drm/drm_internal.h        |   4 --
 drivers/nvme/host/nvme.h              |   5 ++
 drivers/nvme/host/pci.c               |  18 +++---
 drivers/powercap/intel_rapl_common.c  |  35 +++++++++--
 drivers/usb/class/usbtmc.c            |   2 +-
 drivers/usb/serial/pl2303.c           |   1 +
 drivers/usb/serial/pl2303.h           |   4 ++
 include/drm/drm_accel.h               |  18 +-----
 include/drm/drm_file.h                |   5 ++
 net/netfilter/nft_socket.c            |   4 +-
 sound/soc/amd/acp/acp-legacy-common.c |   5 ++
 sound/soc/amd/acp/amd.h               |   2 +
 18 files changed, 129 insertions(+), 194 deletions(-)



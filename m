Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 281D0284B3B;
	Tue, 17 Feb 2026 20:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361410; cv=none; b=k7glUTaNXQh7y7+dnud9LU0nRd870jFlrLI3A2qyv5qPnM0NAzQI6dtxYU4GR9dLQXPMklTHvXCdsh76titFQESTRVn4PHz5NsCiE8yr/hGy1EsCm+G8LkKVrftdLBgF92QSRRKbetzpuQkp0+NbXdGIaNYoifXIQD+kViapU+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361410; c=relaxed/simple;
	bh=WvPf1I49P7BCocBSucrEIz/sEevT1TdGkDSsdtohbgs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=SqAn3QVzmXDQl19JzDmgqo8UPeAfvw0ZOxUtRBPe583eC4ITqsO5CTTZbCRcj8FChWY59U6nKTCnbDNnfjoX040wpWEU/DIwmdXE1aVxIdpJEaNLAGS5LyoE7bLvZtRZ7gUcgt5zr9Tvsiic7L4m6eISbV0zPWW43YgDxjwb7T8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YafYEbxS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YafYEbxS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1084FC4CEF7;
	Tue, 17 Feb 2026 20:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361409;
	bh=WvPf1I49P7BCocBSucrEIz/sEevT1TdGkDSsdtohbgs=;
	h=From:To:Cc:Subject:Date:From;
	b=YafYEbxSuK2IIhlIcS5hF9aAEuf9yjsyxBJcoiPVYl8kz/lgJb8AFJ7vwgWrh74oH
	 FgdiR99IUMhZ7KR9q8ckATClQoph9tVz4C5lQg077ruRnfQ2/iFqXzkSh2ucNBAJmR
	 LeXoHqMsTTg+pMO3DZiGd9okJVf2UzbllQETwQqU=
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
	pavel@nabladev.com,
	jonathanh@nvidia.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com
Subject: [PATCH 6.19 00/18] 6.19.3-rc1 review
Date: Tue, 17 Feb 2026 21:31:56 +0100
Message-ID: <20260217200002.683975158@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.19.3-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.19.3-rc1
X-KernelTest-Deadline: 2026-02-19T20:00+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.19.3 release.
There are 18 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 19 Feb 2026 19:59:50 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.19.3-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.19.3-rc1

Chao Yu <chao@kernel.org>
    f2fs: fix to do sanity check on node footer in {read,write}_end_io

Chao Yu <chao@kernel.org>
    f2fs: fix to do sanity check on node footer in __write_node_folio()

Fabio Porcedda <fabio.porcedda@gmail.com>
    USB: serial: option: add Telit FN920C04 RNDIS compositions

Chao Yu <chao@kernel.org>
    Revert "f2fs: block cache/dio write during f2fs_enable_checkpoint()"

Danilo Krummrich <dakr@kernel.org>
    iommu/arm-smmu-qcom: do not register driver in probe()

Yeongjin Gil <youngjin.gil@samsung.com>
    f2fs: optimize f2fs_overwrite_io() for f2fs_iomap_begin

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid mapping wrong physical block for swapfile

Daeho Jeong <daehojeong@google.com>
    f2fs: support non-4KB block size without packed_ssa feature

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid UAF in f2fs_write_end_io()

Yongpeng Yang <yangyongpeng@xiaomi.com>
    f2fs: fix out-of-bounds access in sysfs attribute read/write

Yongpeng Yang <yangyongpeng@xiaomi.com>
    f2fs: fix IS_CHECKPOINTED flag inconsistency issue caused by concurrent atomic commit and checkpoint writes

Chao Yu <chao@kernel.org>
    f2fs: fix to check sysfs filename w/ gc_pin_file_thresh correctly

Zhiguo Niu <zhiguo.niu@unisoc.com>
    f2fs: fix to add gc count stat in f2fs_gc_range

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    fbdev: smscufx: properly copy ioctl memory to kernelspace

Guangshuo Li <lgs201920130244@gmail.com>
    fbdev: rivafb: fix divide error in nv3_arb()

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: Rework KASAN initialization for PTW-enabled systems

Otto Pflüger <otto.pflueger@abscue.de>
    arm64: dts: mediatek: mt8183: Add missing endpoint IDs to display graph

Anil Gurumurthy <agurumurthy@marvell.com>
    scsi: qla2xxx: Fix bsg_done() causing double free


-------------

Diffstat:

 Makefile                                   |  4 +-
 arch/arm64/boot/dts/mediatek/mt8183.dtsi   | 37 ++++++++++---
 arch/loongarch/mm/kasan_init.c             | 80 +++++++++++++--------------
 drivers/iommu/arm/arm-smmu/arm-smmu-impl.c | 14 +++++
 drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c | 14 +++--
 drivers/iommu/arm/arm-smmu/arm-smmu.c      | 24 ++++++++-
 drivers/iommu/arm/arm-smmu/arm-smmu.h      |  5 ++
 drivers/scsi/qla2xxx/qla_bsg.c             | 28 ++++++----
 drivers/usb/serial/option.c                |  6 +++
 drivers/video/fbdev/riva/riva_hw.c         |  3 ++
 drivers/video/fbdev/smscufx.c              |  8 ++-
 fs/f2fs/data.c                             | 53 ++++++++++++------
 fs/f2fs/f2fs.h                             | 67 +++++++++++++++++------
 fs/f2fs/gc.c                               | 24 +++++----
 fs/f2fs/node.c                             | 50 ++++++++++-------
 fs/f2fs/node.h                             |  8 ---
 fs/f2fs/recovery.c                         |  6 +--
 fs/f2fs/segment.c                          | 86 ++++++++++++++++--------------
 fs/f2fs/segment.h                          |  9 ++--
 fs/f2fs/super.c                            | 64 +++++++---------------
 fs/f2fs/sysfs.c                            | 62 +++++++++++++++++----
 include/linux/f2fs_fs.h                    | 73 +++++++++++++++----------
 22 files changed, 460 insertions(+), 265 deletions(-)



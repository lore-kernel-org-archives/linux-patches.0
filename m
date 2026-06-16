Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35ADD428828;
	Tue, 16 Jun 2026 15:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781622014; cv=none; b=GelOuOv3fqsrQvpqc2/S2tw6CwfJqNJkiOyNwebKIp+TDol4SH2BEpYK6yCULZU7jDKJcWyes7d27C4iGC12nK6EtaUe7ZEqzykVT2jDkMpQFBnsTm9z6fUmy8zU3Dx6wSAbXoLNmTW0d2ybXVtZSaHtOCbk68qIUo2TYdWcxGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781622014; c=relaxed/simple;
	bh=VPwAc6jOJ5745UgKPZZh62fWuWEUi4IvbBCAQyarGS8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=R6+/L5pAjbkPAmoCe2/qamOL7B2wq1cPD83AVUdp7qGxAqKo0+KUZN0U/i4Bs0/35DKoZSZZ5VUk9KQCnvgHJBqQUApXcxWhyIVehCM83B1R20v/Yxup5xmLRliYQvxDw7q/VD+3zCgXV+fOYkL3vXk5Va3oxJ8XLV6dRk/kIQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Opqmt72K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Opqmt72K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B645D1F00A3D;
	Tue, 16 Jun 2026 15:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781622012;
	bh=xZ/HMy/kNb+H2zFZw3YTDc1VaDbtY/DJfX1Dq9th/l0=;
	h=From:To:Cc:Subject:Date;
	b=Opqmt72KytHQd3jDnb7n8eM0exjBbcGlHYkYvW3H6QGnAaYvLL7CZLro4XYzoKqSs
	 e4tcVIbAi4TrsXBfftffE8mNFiF/cv2LfX43KiuAOiNwm6A8D8TGJCY5HNdC2b8hnc
	 Hmpg6IQxugHkc3Lu0mQvHnHDBUPDGd7itq569E8M=
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
Subject: [PATCH 7.1 0/8] 7.1.1-rc1 review
Date: Tue, 16 Jun 2026 20:28:45 +0530
Message-ID: <20260616145523.335696673@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.1-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-7.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 7.1.1-rc1
X-KernelTest-Deadline: 2026-06-18T14:55+00:00
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 7.1.1 release.
There are 8 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 18 Jun 2026 14:55:16 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.1-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 7.1.1-rc1

Will Deacon <will@kernel.org>
    arm64: errata: Mitigate TLBI errata on Microsoft Azure Cobalt 100 CPU

Shanker Donthineni <sdonthineni@nvidia.com>
    arm64: errata: Mitigate TLBI errata on NVIDIA Olympus CPU

Mark Rutland <mark.rutland@arm.com>
    arm64: errata: Mitigate TLBI errata on various Arm CPUs

Mark Rutland <mark.rutland@arm.com>
    arm64: cputype: Add C1-Premium definitions

Mark Rutland <mark.rutland@arm.com>
    arm64: cputype: Add C1-Ultra definitions

Johan Hovold <johan@kernel.org>
    driver core: reject devices with unregistered buses

Johan Hovold <johan@kernel.org>
    driver core: faux: fix root device registration

Mingyu Wang <25181214217@stu.xidian.edu.cn>
    fs/fcntl: fix SOFTIRQ-unsafe lock order in fasync signaling


-------------

Diffstat:

 Documentation/arch/arm64/silicon-errata.rst | 46 +++++++++++++++++++++++++++++
 Makefile                                    |  4 +--
 arch/arm64/Kconfig                          | 38 ++++++++++++++++++++++++
 arch/arm64/include/asm/cputype.h            |  4 +++
 arch/arm64/kernel/cpu_errata.c              | 34 +++++++++++++++++++--
 drivers/base/bus.c                          | 11 +++++--
 drivers/base/faux.c                         | 22 +++++++-------
 fs/fcntl.c                                  |  8 ++---
 8 files changed, 145 insertions(+), 22 deletions(-)



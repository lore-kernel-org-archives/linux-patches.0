Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C7435962;
	Fri,  3 Oct 2025 16:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759507726; cv=none; b=aWfkorLFwsaGU9itFC4jVZ53qOdkLdbxLMilxDS319NxOnbSAzLnv51+43BX62F0drYGxpMzIZRoYWpDemWHpTC6WrdXerrznlTDmevBIPxulXFsOaXJjx+o0gjwsskWk5mdivrNfxKfXdgE2NY86ZZDFD+dqb/yGKZmMN9Zns8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759507726; c=relaxed/simple;
	bh=TcV7MiW8Fesu8TxlwA3xge3zckML+YWn2RsDatupFwU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cge2FBsnRHFxJgqtZwQ5e7jraQFNYdsF0MqBiBaKh5A8EyS01GxOY6BcCOrVHKmEQazo0iMAq98u7Z7YgHFbkYSx809KA6U2h/yBGXzKi08e1n1OhPa7mZpHpUS4uHAh4sY+y37ZGxKcua+HFEuRhK2tJEloXlCps0WK5ZobH4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CXOD/weF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CXOD/weF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 156BDC4CEF5;
	Fri,  3 Oct 2025 16:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759507725;
	bh=TcV7MiW8Fesu8TxlwA3xge3zckML+YWn2RsDatupFwU=;
	h=From:To:Cc:Subject:Date:From;
	b=CXOD/weF98+ogSfcE7tVf7+YiqBWgH0xh5GOAOS+3SmKM4UyzxeQD/ggFKrzDyPIt
	 H+/pMF5D7TmfTZFJTqVE8iXu0aMBeVj6NFqons/4s4RL2Yap8THd55fT4EU/laS6dq
	 pChD25RXCdveOAOxrr9Xo1+oflQbneYQnMHB9MMw=
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
	achill@achill.org
Subject: [PATCH 6.12 00/10] 6.12.51-rc1 review
Date: Fri,  3 Oct 2025 18:05:47 +0200
Message-ID: <20251003160338.463688162@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.51-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.12.51-rc1
X-KernelTest-Deadline: 2025-10-05T16:03+00:00
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.12.51 release.
There are 10 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 05 Oct 2025 16:02:25 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.51-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.12.51-rc1

Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
    ASoC: qcom: audioreach: fix potential null pointer dereference

Matvey Kovalev <matvey.kovalev@ispras.ru>
    wifi: ath11k: fix NULL dereference in ath11k_qmi_m3_load()

Charan Teja Kalla <charan.kalla@oss.qualcomm.com>
    mm: swap: check for stable address space before operating on the VMA

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    media: uvcvideo: Mark invalid entities with id UVC_INVALID_ENTITY_ID

Larshin Sergey <Sergey.Larshin@kaspersky.com>
    media: rc: fix races with imon_disconnect()

Duoming Zhou <duoming@zju.edu.cn>
    media: tuner: xc5000: Fix use-after-free in xc5000_release

Duoming Zhou <duoming@zju.edu.cn>
    media: b2c2: Fix use-after-free causing by irq_check_work in flexcop_pci_remove

Wang Haoran <haoranwangsec@gmail.com>
    scsi: target: target_core_configfs: Add length check to avoid buffer overflow

Kees Cook <kees@kernel.org>
    gcc-plugins: Remove TODO_verify_il for GCC >= 16

Breno Leitao <leitao@debian.org>
    crypto: sha256 - fix crash at kexec


-------------

Diffstat:

 Makefile                              |  4 +-
 drivers/media/pci/b2c2/flexcop-pci.c  |  2 +-
 drivers/media/rc/imon.c               | 27 +++++++++----
 drivers/media/tuners/xc5000.c         |  2 +-
 drivers/media/usb/uvc/uvc_driver.c    | 73 ++++++++++++++++++++++-------------
 drivers/media/usb/uvc/uvcvideo.h      |  2 +
 drivers/net/wireless/ath/ath11k/qmi.c |  2 +-
 drivers/target/target_core_configfs.c |  2 +-
 include/crypto/sha256_base.h          |  2 +-
 mm/swapfile.c                         |  3 ++
 scripts/gcc-plugins/gcc-common.h      |  7 ++++
 sound/soc/qcom/qdsp6/topology.c       |  4 +-
 12 files changed, 87 insertions(+), 43 deletions(-)



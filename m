Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617B0257C
	for <patches@lists.linux.dev>; Thu, 23 Feb 2023 13:04:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90AEAC433A0;
	Thu, 23 Feb 2023 13:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677157490;
	bh=B7K2Hp17wxTx3rvm6GO2NIiUGJOTXFTwJZ4BbXeLqCs=;
	h=From:To:Cc:Subject:Date:From;
	b=LxSASbfyio+gz2pTGJZzeEkRyYZ1o9qsowqRws44J8c8QaPdF0r4Qb3ucujdJF9Ir
	 yPJDzNXeGY4lEu/souiNcSvuat0l84Se1W5iH48J6fr42RzbOxkrTTmsVdO/gaV+Ec
	 GDtEqK4Z1gi6Bg7vpFUoqIouX+5eWKOYA9WbgsdM=
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
	rwarsow@gmx.de
Subject: [PATCH 4.14 0/7] 4.14.307-rc1 review
Date: Thu, 23 Feb 2023 14:04:37 +0100
Message-Id: <20230223130423.369876969@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.307-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.307-rc1
X-KernelTest-Deadline: 2023-02-25T13:04+00:00
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 4.14.307 release.
There are 7 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 25 Feb 2023 13:04:16 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.307-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.307-rc1

Lukas Wunner <lukas@wunner.de>
    wifi: mwifiex: Add missing compatible string for SD8787

Dave Hansen <dave.hansen@linux.intel.com>
    uaccess: Add speculation barrier to copy_from_user()

Thomas Gleixner <tglx@linutronix.de>
    alarmtimer: Prevent starvation by small intervals and SIG_IGN

Sean Anderson <sean.anderson@seco.com>
    powerpc: dts: t208x: Disable 10G on MAC1 and MAC2

Jason A. Donenfeld <Jason@zx2c4.com>
    random: always mix cycle counter in add_latent_entropy()

Sean Anderson <sean.anderson@seco.com>
    powerpc: dts: t208x: Mark MAC1 and MAC2 as 10G

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtl8xxxu: gen2: Turn on the rate control


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi | 44 ++++++++++++++++++++++
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi | 44 ++++++++++++++++++++++
 arch/powerpc/boot/dts/fsl/t2081si-post.dtsi        | 20 +++++++++-
 drivers/net/wireless/marvell/mwifiex/sdio.c        |  1 +
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |  8 +---
 include/linux/nospec.h                             |  4 ++
 include/linux/random.h                             |  6 +--
 kernel/time/alarmtimer.c                           | 33 ++++++++++++++--
 lib/usercopy.c                                     |  7 ++++
 10 files changed, 154 insertions(+), 17 deletions(-)



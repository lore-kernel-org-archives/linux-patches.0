Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CFA819D066;
	Thu, 25 Jul 2024 14:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918670; cv=none; b=ornfZXXEJaJZaHBn7NZe5+dW9V/dyO1aomqGrXwAvGiwktkAkQgvqudExsm1Br0Kk8jdCniveuPD6Z6+oPDV7mGGOD2MFLd+icOpiudm2FBZxAbrKJBkkfkhg6KGWGpr4h8FA1mMrBafuwhzfYRwsCEvwImcDcjZLVoZuN+Nm6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918670; c=relaxed/simple;
	bh=pjN/m4ScIOKWRLZR1SP7MoVIpqpQ4u+iEJXDzQUotho=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=J2xknN9xAM+QU/crYLN6tousXSOHFuu8H5iKZm4T7o9ZS3DEaezLHHfsvxEkDpXTQEKMp8azmvDo8boR9MaZS4YXv2u3HqWEf+HqtfKzovxRTzcZZNq/hiFRyRfNfXynRlXm2g+q3+pS77vrQIJ0XwSsXJyEs2KCQlySuHDOZ1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t+uFvZsZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t+uFvZsZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E93C0C116B1;
	Thu, 25 Jul 2024 14:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918670;
	bh=pjN/m4ScIOKWRLZR1SP7MoVIpqpQ4u+iEJXDzQUotho=;
	h=From:To:Cc:Subject:Date:From;
	b=t+uFvZsZpKELrJC0kUKOvNbSjsgMJQ8yqkUZ/Y6QC6MH9aRteZhqsG2Zj1yE+LSgM
	 bsl0S82B/MJ1LxR2CWfG4jDys5whxBxLJG3IrdwklA+4zO5ZUJ28i2BVwcLE/rdJ5G
	 HEo6LVqpulxIaWKBk9QrHHJgB95utI5fQCSVpjhg=
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
Subject: [PATCH 6.1 00/13] 6.1.102-rc1 review
Date: Thu, 25 Jul 2024 16:37:09 +0200
Message-ID: <20240725142728.029052310@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.102-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.102-rc1
X-KernelTest-Deadline: 2024-07-27T14:27+00:00
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.1.102 release.
There are 13 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 27 Jul 2024 14:27:16 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.102-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.102-rc1

Filipe Manana <fdmanana@suse.com>
    btrfs: do not BUG_ON on failure to get dir index for new snapshot

Jann Horn <jannh@google.com>
    filelock: Fix fcntl/close race recovery compat path

Shengjiu Wang <shengjiu.wang@nxp.com>
    ALSA: pcm_dmaengine: Don't synchronize DMA channel when DMA is paused

Krishna Kurapati <quic_kriskura@quicinc.com>
    arm64: dts: qcom: sdm630: Disable SS instance in Parkmode for USB

Krishna Kurapati <quic_kriskura@quicinc.com>
    arm64: dts: qcom: ipq6018: Disable SS instance in Parkmode for USB

Krishna Kurapati <quic_kriskura@quicinc.com>
    arm64: dts: qcom: msm8996: Disable SS instance in Parkmode for USB

Seunghun Han <kkamagui@gmail.com>
    ALSA: hda/realtek: Fix the speaker output on Samsung Galaxy Book Pro 360

Edson Juliano Drosdeck <edson.drosdeck@gmail.com>
    ALSA: hda/realtek: Enable headset mic on Positivo SU C1400

lei lu <llfamsec@gmail.com>
    fs/ntfs3: Validate ff offset

lei lu <llfamsec@gmail.com>
    jfs: don't walk off the end of ealist

lei lu <llfamsec@gmail.com>
    ocfs2: add bounds checking to ocfs2_check_dir_entry()

Chao Yu <chao@kernel.org>
    f2fs: avoid dead loop in f2fs_issue_checkpoint()

Dan Carpenter <dan.carpenter@linaro.org>
    drm/amdgpu: Fix signedness bug in sdma_v4_0_process_trap_irq()


-------------

Diffstat:

 Makefile                               |  4 +--
 arch/arm64/boot/dts/qcom/ipq6018.dtsi  |  1 +
 arch/arm64/boot/dts/qcom/msm8996.dtsi  |  1 +
 arch/arm64/boot/dts/qcom/sdm630.dtsi   |  1 +
 drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c |  2 +-
 fs/btrfs/transaction.c                 |  5 +++-
 fs/f2fs/super.c                        | 15 +++++++++--
 fs/jfs/xattr.c                         | 23 ++++++++++++++---
 fs/locks.c                             |  9 +++----
 fs/ntfs3/fslog.c                       |  6 ++++-
 fs/ocfs2/dir.c                         | 46 +++++++++++++++++++++-------------
 sound/core/pcm_dmaengine.c             |  6 ++++-
 sound/pci/hda/patch_realtek.c          |  2 ++
 13 files changed, 87 insertions(+), 34 deletions(-)



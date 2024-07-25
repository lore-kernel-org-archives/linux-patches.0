Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D476CF519;
	Thu, 25 Jul 2024 14:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918711; cv=none; b=VWRlP+LWrV89KT2yp2Xw3EVXy7hVHxY7wHv7oh/UOtncRag1r1nIYOH0Z1y/OGf8pL/CtUVx7/p6L3QG+Lgn2oiIBarHwFCeuWPgQ/axpM6RL5fkQ30PNb5eh4sC91Sps0wKfPBYNEmai5GdcBSmG8zdZ84FD6xgM2dzW9FHa3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918711; c=relaxed/simple;
	bh=+IRDZcQBmsdRpSFIMJm5ogdws9ZtOm4shKG7MuMgAY4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kxMQXJ2SVUxsptt39v+cEpPWUZVLawm6KqGa48wFuIM1Xd5lWjrV+iB3frVMQre4FuJNAhSXN1rh1YvYpvPvr+qytekRp7GcdqxByYwzED9t5NkGtbbDvnAMVu1rUQm6WJ46P9z2rESNPvjcJ09i7ub2fCRP+/pGQqx1gi7HORw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PgF03fJ1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PgF03fJ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C50DC4AF07;
	Thu, 25 Jul 2024 14:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918711;
	bh=+IRDZcQBmsdRpSFIMJm5ogdws9ZtOm4shKG7MuMgAY4=;
	h=From:To:Cc:Subject:Date:From;
	b=PgF03fJ10kXl0i+ro8Q70MM69oLkWfx0lRdc/vbJjFHYJIvio9yY02IobDWOfG/r5
	 hdbbb6TOFHsPjUY+5muODpgSzKRvWkm4GVoAtZA7DnFZ46EoN492Kd+uWX2AvL8PZh
	 RPY86U2IGFIVR8LCFjeJAVVukNvCoxr34kmOP4ck=
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
Subject: [PATCH 6.6 00/16] 6.6.43-rc1 review
Date: Thu, 25 Jul 2024 16:37:13 +0200
Message-ID: <20240725142728.905379352@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.43-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.43-rc1
X-KernelTest-Deadline: 2024-07-27T14:27+00:00
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.43 release.
There are 16 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 27 Jul 2024 14:27:16 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.43-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.43-rc1

Jann Horn <jannh@google.com>
    filelock: Fix fcntl/close race recovery compat path

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: ump: Skip useless ports for static blocks

Shengjiu Wang <shengjiu.wang@nxp.com>
    ALSA: pcm_dmaengine: Don't synchronize DMA channel when DMA is paused

Krishna Kurapati <quic_kriskura@quicinc.com>
    arm64: dts: qcom: sdm630: Disable SS instance in Parkmode for USB

Krishna Kurapati <quic_kriskura@quicinc.com>
    arm64: dts: qcom: ipq6018: Disable SS instance in Parkmode for USB

Krishna Kurapati <quic_kriskura@quicinc.com>
    arm64: dts: qcom: sm6350: Disable SS instance in Parkmode for USB

Krishna Kurapati <quic_kriskura@quicinc.com>
    arm64: dts: qcom: msm8996: Disable SS instance in Parkmode for USB

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: qrb4210-rb2: switch I2C2 to i2c-gpio

Seunghun Han <kkamagui@gmail.com>
    ALSA: hda/realtek: Fix the speaker output on Samsung Galaxy Book Pro 360

Edson Juliano Drosdeck <edson.drosdeck@gmail.com>
    ALSA: hda/realtek: Enable headset mic on Positivo SU C1400

Takashi Iwai <tiwai@suse.de>
    usb: gadget: midi2: Fix incorrect default MIDI2 protocol setup

lei lu <llfamsec@gmail.com>
    fs/ntfs3: Validate ff offset

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Add a check for attr_names and oatbl

lei lu <llfamsec@gmail.com>
    jfs: don't walk off the end of ealist

lei lu <llfamsec@gmail.com>
    ocfs2: add bounds checking to ocfs2_check_dir_entry()

Dan Carpenter <dan.carpenter@linaro.org>
    drm/amdgpu: Fix signedness bug in sdma_v4_0_process_trap_irq()


-------------

Diffstat:

 Makefile                                 |  4 +--
 arch/arm64/boot/dts/qcom/ipq6018.dtsi    |  1 +
 arch/arm64/boot/dts/qcom/msm8996.dtsi    |  1 +
 arch/arm64/boot/dts/qcom/qrb4210-rb2.dts | 13 ++++++++-
 arch/arm64/boot/dts/qcom/sdm630.dtsi     |  1 +
 arch/arm64/boot/dts/qcom/sm6350.dtsi     |  1 +
 drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c   |  2 +-
 drivers/usb/gadget/function/f_midi2.c    | 19 +++++++------
 fs/jfs/xattr.c                           | 23 +++++++++++++---
 fs/locks.c                               |  9 +++----
 fs/ntfs3/fslog.c                         | 44 +++++++++++++++++++++++++-----
 fs/ocfs2/dir.c                           | 46 ++++++++++++++++++++------------
 sound/core/pcm_dmaengine.c               |  6 ++++-
 sound/core/seq/seq_ump_client.c          | 16 +++++++++++
 sound/pci/hda/patch_realtek.c            |  2 ++
 15 files changed, 142 insertions(+), 46 deletions(-)



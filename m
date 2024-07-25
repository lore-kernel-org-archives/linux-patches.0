Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8AB13C816;
	Thu, 25 Jul 2024 14:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918815; cv=none; b=RRaMZQkbIzlsbDnPg1AEunkSZH4DmVaVBKtB5z2bLrylPWz1eTDAsDHmbsFZwmho+rH0RSvSVj0tWfq6Z+OPXDLyqgv/6D7+n/AAjcj4tJUDv3QELGBZ7WV+YALJCiKh0JvM2EAzjALJATT6CMZyctbaN1uEQpgJSJPbdcvq6jE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918815; c=relaxed/simple;
	bh=HoKSbsIf8MHpcYcgfedMDU9CVcxBwnFZH/e8vIInTM8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KEZj1Ytuw83AVAuAPqFQSyukv6OdeYbd8JuMvupfiKZgXzgCuj5sutqfooMmrZO6sqUFSJAmZKmFwpjpe4e3x+W/vgzJ1ZALmqGCOA/dmtnyjuQbMpe/ub1qgAr3RXPNWzSH/Oc2C8PD3wv+OB55ZJRJbFxgPNec7EE0pksNpm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rms967v7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rms967v7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEE57C116B1;
	Thu, 25 Jul 2024 14:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918815;
	bh=HoKSbsIf8MHpcYcgfedMDU9CVcxBwnFZH/e8vIInTM8=;
	h=From:To:Cc:Subject:Date:From;
	b=rms967v7eqI9AEAoxICMXVmVGoEHS+VOsdP7WR1lizu2No5TY++9wD8PzGHJsFLZN
	 aWgfd9MsCzpU4r3P6taEdnWrvvaZmRVPKvLfVu7hEXV8VLUnsHiflmwHGUD6DkMgVE
	 zHEkECRLzHRBkrtdvvV5vXtoJe0BPzv71EfIjFSQ=
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
Subject: [PATCH 6.9 00/29] 6.9.12-rc1 review
Date: Thu, 25 Jul 2024 16:37:10 +0200
Message-ID: <20240725142731.678993846@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.12-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.9.12-rc1
X-KernelTest-Deadline: 2024-07-27T14:27+00:00
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.9.12 release.
There are 29 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 27 Jul 2024 14:27:16 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.12-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.9.12-rc1

Jann Horn <jannh@google.com>
    filelock: Fix fcntl/close race recovery compat path

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: ump: Skip useless ports for static blocks

Shengjiu Wang <shengjiu.wang@nxp.com>
    ALSA: pcm_dmaengine: Don't synchronize DMA channel when DMA is paused

Krishna Kurapati <quic_kriskura@quicinc.com>
    arm64: dts: qcom: sm6115: Disable SS instance in Parkmode for USB

Krishna Kurapati <quic_kriskura@quicinc.com>
    arm64: dts: qcom: sdm845: Disable SS instance in Parkmode for USB

Krishna Kurapati <quic_kriskura@quicinc.com>
    arm64: dts: qcom: ipq8074: Disable SS instance in Parkmode for USB

Krishna Kurapati <quic_kriskura@quicinc.com>
    arm64: dts: qcom: sdm630: Disable SS instance in Parkmode for USB

Krishna Kurapati <quic_kriskura@quicinc.com>
    arm64: dts: qcom: ipq6018: Disable SS instance in Parkmode for USB

Krishna Kurapati <quic_kriskura@quicinc.com>
    arm64: dts: qcom: msm8998: Disable SS instance in Parkmode for USB

Krishna Kurapati <quic_kriskura@quicinc.com>
    arm64: dts: qcom: sm6350: Disable SS instance in Parkmode for USB

Krishna Kurapati <quic_kriskura@quicinc.com>
    arm64: dts: qcom: msm8996: Disable SS instance in Parkmode for USB

Abel Vesa <abel.vesa@linaro.org>
    arm64: dts: qcom: x1e80100-crd: Fix USB PHYs regulators

Abel Vesa <abel.vesa@linaro.org>
    arm64: dts: qcom: x1e80100-qcp: Fix the PHY regulator for PCIe 6a

Abel Vesa <abel.vesa@linaro.org>
    arm64: dts: qcom: x1e80100-crd: Fix the PHY regulator for PCIe 6a

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: qrb4210-rb2: switch I2C2 to i2c-gpio

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: qrb2210-rb1: switch I2C2 to i2c-gpio

Abel Vesa <abel.vesa@linaro.org>
    arm64: dts: qcom: x1e80100-qcp: Fix USB PHYs regulators

Krishna Kurapati <quic_kriskura@quicinc.com>
    arm64: dts: qcom: sc7280: Disable SuperSpeed instances in park mode

Krishna Kurapati <quic_kriskura@quicinc.com>
    arm64: dts: qcom: sc7180: Disable SuperSpeed instances in park mode

Seunghun Han <kkamagui@gmail.com>
    ALSA: hda/realtek: Fix the speaker output on Samsung Galaxy Book Pro 360

Edson Juliano Drosdeck <edson.drosdeck@gmail.com>
    ALSA: hda/realtek: Enable headset mic on Positivo SU C1400

Shenghao Ding <shenghao-ding@ti.com>
    ALSA: hda/tas2781: Add new quirk for Lenovo Hera2 Laptop

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

Gerald Schaefer <gerald.schaefer@linux.ibm.com>
    s390/mm: Fix VM_FAULT_HWPOISON handling in do_exception()

Dan Carpenter <dan.carpenter@linaro.org>
    drm/amdgpu: Fix signedness bug in sdma_v4_0_process_trap_irq()


-------------

Diffstat:

 Makefile                                  |  4 +--
 arch/arm64/boot/dts/qcom/ipq6018.dtsi     |  1 +
 arch/arm64/boot/dts/qcom/ipq8074.dtsi     |  2 ++
 arch/arm64/boot/dts/qcom/msm8996.dtsi     |  1 +
 arch/arm64/boot/dts/qcom/msm8998.dtsi     |  1 +
 arch/arm64/boot/dts/qcom/qrb2210-rb1.dts  | 13 ++++++++-
 arch/arm64/boot/dts/qcom/qrb4210-rb2.dts  | 13 ++++++++-
 arch/arm64/boot/dts/qcom/sc7180.dtsi      |  1 +
 arch/arm64/boot/dts/qcom/sc7280.dtsi      |  1 +
 arch/arm64/boot/dts/qcom/sdm630.dtsi      |  1 +
 arch/arm64/boot/dts/qcom/sdm845.dtsi      |  2 ++
 arch/arm64/boot/dts/qcom/sm6115.dtsi      |  1 +
 arch/arm64/boot/dts/qcom/sm6350.dtsi      |  1 +
 arch/arm64/boot/dts/qcom/x1e80100-crd.dts | 17 +++++++++---
 arch/arm64/boot/dts/qcom/x1e80100-qcp.dts | 17 +++++++++---
 arch/s390/mm/fault.c                      |  3 +-
 drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c    |  2 +-
 drivers/usb/gadget/function/f_midi2.c     | 19 +++++++------
 fs/jfs/xattr.c                            | 23 +++++++++++++---
 fs/locks.c                                |  9 +++---
 fs/ntfs3/fslog.c                          | 44 ++++++++++++++++++++++++-----
 fs/ocfs2/dir.c                            | 46 +++++++++++++++++++------------
 sound/core/pcm_dmaengine.c                |  6 +++-
 sound/core/seq/seq_ump_client.c           | 16 +++++++++++
 sound/pci/hda/patch_realtek.c             |  3 ++
 25 files changed, 191 insertions(+), 56 deletions(-)



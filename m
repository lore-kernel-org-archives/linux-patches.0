Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3AC8189BB0;
	Sun,  7 Sep 2025 20:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276491; cv=none; b=XkPExC4Ng9BhpDQwVefJuR47bQvSeWHeX/svQR62VyVLLDQRmlSDLeQIhjd/8Isd/IZ8u+3yBPFwaZ6s3hkkaYDuUFY9yfuNZ3bWFqTc3u9ywwzVa+ju5bW0n1kyhh+gR1/2Ytdh7lEvO0gyavHedq6bwuxNEGNfp+3zunU31Yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276491; c=relaxed/simple;
	bh=eq/4dzH4MBCBOexBNHZsplYC9793aqJne01l+17qaLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=glI30ajYLYArBdDpTe7x1cCDInwOFbnq9Bh6aDSGsonuC2W6rOJWXuT/JZcVeGFhiaj+eFFaFEH8zMY+xJeab+PtqmPue+nu35OZE99wK8LgY1aR0iOEkygjpfaWkmFTcS+YQGxK2Qye0Uk6EtTKpgaT+boEwf9dCMybTl+lZd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xc4XqMZD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xc4XqMZD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 517C6C4CEF0;
	Sun,  7 Sep 2025 20:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276490;
	bh=eq/4dzH4MBCBOexBNHZsplYC9793aqJne01l+17qaLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xc4XqMZD4HE592jgBpO6BkTgy8cTR/UUgkuLJLADfW6m8D4LsYmNKFn4McoNiJnrx
	 jKxuM+A0gW3KBFOcq7vpBR/v8VcCthnJgplFWvQZSJmvd7AOGSreni3DFwEMdmBCHa
	 FvzvEJVSnuEjUQWNDeoyiPUTX8nXd8DaMc+bRERk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marek.vasut@mailbox.org>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 017/121] arm64: dts: imx8mp: Fix missing microSD slot vqmmc on DH electronics i.MX8M Plus DHCOM
Date: Sun,  7 Sep 2025 21:57:33 +0200
Message-ID: <20250907195610.257762701@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195609.817339617@linuxfoundation.org>
References: <20250907195609.817339617@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marek.vasut@mailbox.org>

[ Upstream commit c53cf8ce3bfe1309cb4fd4d74c5be27c26a86e52 ]

Add missing microSD slot vqmmc-supply property, otherwise the kernel
might shut down LDO5 regulator and that would power off the microSD
card slot, possibly while it is in use. Add the property to make sure
the kernel is aware of the LDO5 regulator which supplies the microSD
slot and keeps the LDO5 enabled.

Fixes: 8d6712695bc8 ("arm64: dts: imx8mp: Add support for DH electronics i.MX8M Plus DHCOM and PDK2")
Signed-off-by: Marek Vasut <marek.vasut@mailbox.org>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi b/arch/arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi
index eae39c1cb9856..2e93d922c8611 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi
@@ -571,6 +571,7 @@ &usdhc2 {
 	pinctrl-2 = <&pinctrl_usdhc2_200mhz>, <&pinctrl_usdhc2_gpio>;
 	cd-gpios = <&gpio2 12 GPIO_ACTIVE_LOW>;
 	vmmc-supply = <&reg_usdhc2_vmmc>;
+	vqmmc-supply = <&ldo5>;
 	bus-width = <4>;
 	status = "okay";
 };
-- 
2.50.1




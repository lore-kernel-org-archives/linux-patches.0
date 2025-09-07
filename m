Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54AF314BFA2;
	Sun,  7 Sep 2025 20:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276272; cv=none; b=hbfWDoGsBUTeWnuo2mhvqd50si1XCkTK3kC5mSSEOWdHci2Kl7U7L1wH0633KidlU+OZ/WrDUtiQKL5KPtQG0kfjZq60Kb1ifAbGBknjLdsCT7gR3/XH+LiOitzqnuCSkT0Ee2siiqhFwL+GdXuoJLMXq9+33+fzKhNk6ucTumo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276272; c=relaxed/simple;
	bh=gdwXxc0mGXTwWX84/aD6kCpYcFwM4/OEZB/v1WplQXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rLwXZvFcquP1knX9+EL2ay2SQuuNU/cUGlPZAdZ1QXLlWglGwq+ZojCduYBhhjBHgINvdiI2cdalP+9q8UlCCSuZGEIP1BF2xIYDtLO0vykk56fYsJ+dYh71sDrSjaHLU5CLMpuDupcCOYfgmUctDK9CRpD7MMJEpwYzkfbe29g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nRDUbzkp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nRDUbzkp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9D9BC4CEF0;
	Sun,  7 Sep 2025 20:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276272;
	bh=gdwXxc0mGXTwWX84/aD6kCpYcFwM4/OEZB/v1WplQXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nRDUbzkp+HhXE2u7DrG4mOaDKteuQ7GdjKEIILtaWsGkoaLFxnSEq/ROR5gL+UDLu
	 0MBE4OBn9eWOGTMvcH5JJnLTF7NksxUVMOMiX0QQyAdPStLbH18DBRyFDeKOStj7bK
	 OvZnJsK9BnyDODG1Jx+5tTOGvzkntIwViXdP1FcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marek.vasut@mailbox.org>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 015/104] arm64: dts: imx8mp: Fix missing microSD slot vqmmc on DH electronics i.MX8M Plus DHCOM
Date: Sun,  7 Sep 2025 21:57:32 +0200
Message-ID: <20250907195608.076689797@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195607.664912704@linuxfoundation.org>
References: <20250907195607.664912704@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0f13ee3627715..2fd50b5890afa 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi
@@ -508,6 +508,7 @@ &usdhc2 {
 	pinctrl-2 = <&pinctrl_usdhc2_200mhz>, <&pinctrl_usdhc2_gpio>;
 	cd-gpios = <&gpio2 12 GPIO_ACTIVE_LOW>;
 	vmmc-supply = <&reg_usdhc2_vmmc>;
+	vqmmc-supply = <&ldo5>;
 	bus-width = <4>;
 	status = "okay";
 };
-- 
2.50.1




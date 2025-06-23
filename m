Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD60B676;
	Mon, 23 Jun 2025 22:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717673; cv=none; b=ChH5EMb9sMRSm765bycqTIRrz47SUkIy6SDGcOBVxPHGJJPw+T7lWK4l8lPsm72KzPxYC/LVQ0IoqkOBoYanXM5g4eEUav1inKmRbnQ94M97ytKTQqza29eEe9oIxt/fXwYSgu9fHSYCFPff7VNIjISv8mUeiBy/y8Vk8rT3qDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717673; c=relaxed/simple;
	bh=MoZ0CATRzXeQAqvavfl7BDstpEEfKcxfDdUif2251SU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KeyWaxVUB0EpSOPM9keT+v8fQKef6UH3eC4NZ4ZGSqLxk+2/lrt062JLq5R6tyraNa8Ndo/6zwhYCI89d+uWYyjr4Mz1yV/sJ1b2DpcmMbxbeGCkh2jdinxuCpzSKnZcsNbGVh+BXE9kpMqjBeVwz7Vhks0/vvdZi1MQOB8rv34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wk3Or4z1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wk3Or4z1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EA28C4CEEA;
	Mon, 23 Jun 2025 22:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717673;
	bh=MoZ0CATRzXeQAqvavfl7BDstpEEfKcxfDdUif2251SU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wk3Or4z1Iv4LU/amfbj8iARBNsLvx8YzJE209g4Uowhnqrc5wkVfixDWJ7DM152oL
	 otf0HXEJJ5sq3zkawn5ewujB0WUxwhrCjq3hmyTe2Y8gL9w5pMjKYbnuwc+VzPdqog
	 C60wGs8y+7ocn5nVPoPBMrLa14sT4cOEYkERgOrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Frieder Schrempf <frieder.schrempf@kontron.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Francesco Dolcini <francesco.dolcini@toradex.com>
Subject: [PATCH 6.1 498/508] arm64: dts: imx8mm: Drop sd-vsel-gpios from i.MX8M Mini Verdin SoM
Date: Mon, 23 Jun 2025 15:09:03 +0200
Message-ID: <20250623130657.272318403@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

From: Marek Vasut <marex@denx.de>

commit 8bad8c923f217d238ba4f1a6d19d761e53bfbd26 upstream.

The VSELECT pin is configured as MX8MM_IOMUXC_GPIO1_IO04_USDHC2_VSELECT
and not as a GPIO, drop the bogus sd-vsel-gpios property as the eSDHC
block handles the VSELECT pin on its own.

Signed-off-by: Marek Vasut <marex@denx.de>
Reviewed-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi
@@ -372,7 +372,6 @@
 		pinctrl-names = "default";
 		pinctrl-0 = <&pinctrl_pmic>;
 		reg = <0x25>;
-		sd-vsel-gpios = <&gpio1 4 GPIO_ACTIVE_HIGH>;
 
 		/*
 		 * The bootloader is expected to switch on the I2C level shifter for the TLA2024 ADC



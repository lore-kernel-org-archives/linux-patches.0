Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF2C071B51;
	Mon, 15 Apr 2024 14:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191094; cv=none; b=YnHJjlmhPh2NluXgxHZlkvdtx3XP3a2WHu+O/zQB0SpBSZo56m/WumP+Mqf+JEd58MAaxCOP+WU0R76oi6lRnQBKyaPIgeIkdPXG5azMXTZ6L284FjL9jxbiaUUpgXX4Q3D0xBvgNbcpA0AwERovyEKI6AX5ISwGcbSAKQ+vf2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191094; c=relaxed/simple;
	bh=0KqwtW5uwALZpbD+du0iphmThktQOOTSyokD+d1cbaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LHBRtqKFKpTg7sv0txWblJhjNTJ5cl0NGT6MlqNwAMBJ8g0abhgN9j8WuaBKwznhlf/OF8SwHvnFmN3I4AnhVmsRn4LJgC29VsMcIZDucs/IQ/3j3NGM8JVUS3t7IhbZt7MVF3fTd/j/ZpWLq0s0xWgUe9CeS906op15DjnZabw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O4OD2Ls6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O4OD2Ls6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44D36C113CC;
	Mon, 15 Apr 2024 14:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191094;
	bh=0KqwtW5uwALZpbD+du0iphmThktQOOTSyokD+d1cbaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O4OD2Ls6sqindfiifOXQZ6ZFGpA2BenlfP/UNiuLwJthZCfjvmbjWP8XJXXmyfCqp
	 p5evCQWQW+hokb+lvupkErrviyv4xjCbDLiHmwPg6gQutddjqWIfAefA9PXNGYENW2
	 MmHoUOrLXNkVhqHLg5S0C/qWZrPrpAbqldoTsHFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Harvey <tharvey@gateworks.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 030/172] arm64: dts: freescale: imx8mp-venice-gw72xx-2x: fix USB vbus regulator
Date: Mon, 15 Apr 2024 16:18:49 +0200
Message-ID: <20240415142001.351452703@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Harvey <tharvey@gateworks.com>

[ Upstream commit 8cb10cba124c4798b6cb333245ecdc8dde78aeae ]

When using usb-conn-gpio to control USB role and VBUS, the vbus-supply
property must be present in the usb-conn-gpio node. Additionally it
should not be present in the phy node as that isn't what controls vbus
and will upset the use count.

This resolves an issue where VBUS is enabled with OTG in peripheral
mode.

Fixes: ad9a12f7a522 ("arm64: dts: imx8mp-venice: Fix USB connector description")
Signed-off-by: Tim Harvey <tharvey@gateworks.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-venice-gw72xx.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-venice-gw72xx.dtsi b/arch/arm64/boot/dts/freescale/imx8mp-venice-gw72xx.dtsi
index 41c79d2ebdd62..f24b14744799e 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-venice-gw72xx.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-venice-gw72xx.dtsi
@@ -14,6 +14,7 @@ connector {
 		pinctrl-0 = <&pinctrl_usbcon1>;
 		type = "micro";
 		label = "otg";
+		vbus-supply = <&reg_usb1_vbus>;
 		id-gpios = <&gpio3 21 GPIO_ACTIVE_HIGH>;
 
 		port {
@@ -183,7 +184,6 @@ &usb3_0 {
 };
 
 &usb3_phy0 {
-	vbus-supply = <&reg_usb1_vbus>;
 	status = "okay";
 };
 
-- 
2.43.0




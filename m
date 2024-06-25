Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AA7A12EBEA;
	Tue, 25 Jun 2024 09:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308615; cv=none; b=OQsNDVR5uDUQ9D83i8hauFH8GaatSsk/6tTg/X95LDLlPu4kc7JhUeiMPNGm0m7s1It//xmZDyb3d9Hbye07vGj4sGwn8by7dFVNXy9dTgHseDyQKxbYgQyqk+m4caY6w6bPOgToXWH2LeK03Y2ILu4Ea4gzZj6hZsreEa6zsfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308615; c=relaxed/simple;
	bh=f41zaNddtyN4sPaDIl9QSfStgYK4YIAHW7riVHaNZRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CfNpnPsLU+onX3iG3jcmRMXmhUIvJAp5wZ2tPNm3Zv+32wZYbs0NW/jrJ0p/yL3goE5kQBUGtU72kHI5qZMmsMLMtHKSJ/BO1a48uqyM1XSCj7QIaaiGMsWvlsT1i14nRjcahK/mxUCget0mHny7i9Et6gMocDiFtQerxmfdBoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gAuXBkB1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gAuXBkB1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7587C32781;
	Tue, 25 Jun 2024 09:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308615;
	bh=f41zaNddtyN4sPaDIl9QSfStgYK4YIAHW7riVHaNZRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gAuXBkB1u6Kik+euo4VGTXffUuII84uKgQ9BeGhrTfjyR4AiAsPxI4DzVFjKSk9D/
	 KJNUMU4ZvCxVlktsYDrJ6Mw4pj0afrbPNdBK9txNOkrz8XWZ3yxLCYZ8s78H96m8Xg
	 nb4qR+gfK4TYEfYVsnS5yU7kEs6IOUbzoDp3o5cQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Krummenacher <max.krummenacher@toradex.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 164/250] arm64: dts: freescale: imx8mm-verdin: enable hysteresis on slow input pin
Date: Tue, 25 Jun 2024 11:32:02 +0200
Message-ID: <20240625085554.352994077@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Krummenacher <max.krummenacher@toradex.com>

[ Upstream commit 67cc6125fb39902169707cb6277f010e56d4a40a ]

SODIMM 17 can be used as an edge triggered interrupt supplied from an
off board source.

Enable hysteresis on the pinmuxing to increase immunity against noise
on the signal.

Fixes: 60f01b5b5c7d ("arm64: dts: imx8mm-verdin: update iomux configuration")
Signed-off-by: Max Krummenacher <max.krummenacher@toradex.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi
index 64e2f83f26498..1b1880c607cfe 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi
@@ -930,7 +930,7 @@
 	/* Verdin GPIO_9_DSI (pulled-up as active-low) */
 	pinctrl_gpio_9_dsi: gpio9dsigrp {
 		fsl,pins =
-			<MX8MM_IOMUXC_NAND_RE_B_GPIO3_IO15		0x146>;	/* SODIMM 17 */
+			<MX8MM_IOMUXC_NAND_RE_B_GPIO3_IO15		0x1c6>;	/* SODIMM 17 */
 	};
 
 	/* Verdin GPIO_10_DSI (pulled-up as active-low) */
-- 
2.43.0




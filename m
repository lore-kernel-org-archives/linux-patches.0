Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F326928DC4;
	Wed, 20 May 2026 17:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298480; cv=none; b=iM3nydI8JWWIBjf+76IaCvq9kOZq0mENWf3bu6821ttJdApeWX+sEZvXbCPdvtn2hEBU73d+ex55Q65mn3g69OxRJiGCLvSjKp1UA6/hOjOSBps01T3kCPSdN2HAsoKyZjgxYXA8e2CHNsmMf2sExsJaNYcHy5g7+rXCf+zZW1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298480; c=relaxed/simple;
	bh=mQUToaTCFFLuIXXT4rW7LyZRyqgGZ2AA/MX334rPmuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u672Lr9GY+ziweuE+u8vlnA5FMaCzxSoGeO2ugWFylmkTS/i20/amA/LBm4PsOH7fHyU80hW16BwAVetRX0lW7XHuxRjS/4ruQ2CpDC8CSK25xD2pGBjUwBEWqL1r3/oTv73CnjXA+6eTk1l+XmDfDjUR5l28fbFlYtxn7pBhLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZHJdKpzZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZHJdKpzZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 631081F000E9;
	Wed, 20 May 2026 17:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298478;
	bh=wqP+LBsx+7rnVXrn+rsdirlRf1LasMYFnQM0jVAPOgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZHJdKpzZGHxCrEhgpMuH4uaWykk4grhCNe8De+ba+tyvMLwVrFxkdyVZe96UhnE+b
	 +MnduoJBii5Ti4h7p8mo/fdrBMMX8ChgVm3cUzeuM70Nv5a4YKqtwZj1/n6bB3kXzQ
	 kU/VrXlDN6DTcimyagqYUPY/dozUZMT9FVfWyE6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Yang <xu.yang_2@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 425/957] arm64: dts: imx8qm-mek: switch Type-C connector power-role to dual
Date: Wed, 20 May 2026 18:15:08 +0200
Message-ID: <20260520162143.739074822@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Yang <xu.yang_2@nxp.com>

[ Upstream commit e3d3d19d1c0050789a4813ce836a641a3387d916 ]

When attach to PC Type-A port, the USB device controller does not function
at all. Because it is configured as source-only and a Type-A port doesn't
support PD capability, a data role swap is impossible.

Actually, PTN5110THQ is configured for Source role only at POR, but after
POR it can operate as a DRP (Dual-Role Power). By switching the power-role
to dual, the port can operate as a sink and enter device mode when attach
to Type-A port.

Since the board design uses EN_SRC to control the 5V VBUS path and EN_SNK
to control the 12V VBUS output, to avoid outputting a higher VBUS when in
sink role, we set the operation current limit to 0mA so that SW will not
control EN_SNK at all.

Fixes: b237975b2cd58 ("arm64: dts: imx8qm-mek: add usb 3.0 and related type C nodes")
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8qm-mek.dts | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8qm-mek.dts b/arch/arm64/boot/dts/freescale/imx8qm-mek.dts
index df99fe88cf4ac..a97883873b564 100644
--- a/arch/arm64/boot/dts/freescale/imx8qm-mek.dts
+++ b/arch/arm64/boot/dts/freescale/imx8qm-mek.dts
@@ -593,9 +593,17 @@ ptn5110: tcpc@51 {
 		usb_con1: connector {
 			compatible = "usb-c-connector";
 			label = "USB-C";
-			power-role = "source";
+			power-role = "dual";
 			data-role = "dual";
+			try-power-role = "sink";
 			source-pdos = <PDO_FIXED(5000, 3000, PDO_FIXED_USB_COMM)>;
+			/*
+			 * Set operational current to 0mA as we don't want EN_SNK
+			 * enable 12V VBUS switch when it work as a sink.
+			 */
+			sink-pdos = <PDO_FIXED(5000, 0, PDO_FIXED_USB_COMM)>;
+			op-sink-microwatt = <0>;
+			self-powered;
 
 			ports {
 				#address-cells = <1>;
-- 
2.53.0




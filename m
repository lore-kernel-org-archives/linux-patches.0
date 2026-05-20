Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BD3D3769E0;
	Wed, 20 May 2026 18:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300883; cv=none; b=nnP7G96D4W9+LyQV1iYzhSF78QQjjZjr6W+7eAueLzeyPORp1tJdgenQTK95mV9ZSx6kKcdlEf1onmb8zkRrrbhdZuNix1p6H7gfT0ZOWHONO4yyszRDZwwi2PmkEI2b6nplXhxTUlYHVFtnKVyXiKfvCwOaTyBPZpFYRMaATuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300883; c=relaxed/simple;
	bh=zHIDNI10kt/0+C5oJYoA6PCRi1/3oIFnOcJovptrAXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o5wdZFhPmFhUCmzRJ5yQxuVgILQ1sQLpKDn9KVXsZBBjISZEvnc1ocNcESKr4MqGF5JqjAfCfh5AuigG2YFsPv3R1bY7RCJg5nJFCX9/uxWbAgvDO0vxRWyC41P1OBFuOVFUMO/BZAU+GdGEZn/O532y8554PrQ+v7Gpb6QrFbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EYB55Iv2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EYB55Iv2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F14111F000E9;
	Wed, 20 May 2026 18:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300882;
	bh=7d8UByChrIS+glrA4cqxpY51ZkjGEsI6WiLcVA1+rKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EYB55Iv2zXMToUgUKPIO6blNoh7dPArQ9vqe9SnkIUc3jxF4FEkRR1tFcBiOvG3CC
	 Hmkm7Pkh3i+qZGIOIVzAWB1cCsC4tw8Fkn5NJQIjdqs8WWNhVqKuqAns40JP6w04wj
	 hjc17Qa4UMKPbsD82zwbmV+U25CSy41xUCG7cXnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Yang <xu.yang_2@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 303/666] arm64: dts: imx8qm-mek: switch Type-C connector power-role to dual
Date: Wed, 20 May 2026 18:18:34 +0200
Message-ID: <20260520162117.787061416@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 19c8d7ce1d409..32a37e0d0b425 100644
--- a/arch/arm64/boot/dts/freescale/imx8qm-mek.dts
+++ b/arch/arm64/boot/dts/freescale/imx8qm-mek.dts
@@ -351,9 +351,17 @@ ptn5110: tcpc@51 {
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




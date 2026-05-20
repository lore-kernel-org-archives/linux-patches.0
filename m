Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F9D828DC4;
	Wed, 20 May 2026 17:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298482; cv=none; b=uACeB7S7jQ+lvuShWNSv2XtXwT+POMn6nd8rTzIGBeRapZUSdE1dqDAdO9J/iMa00TTE3vycNJ7U9cp8xcdxGHW5fL28Mj11CAjiMZ8JVKWQUAjAGTo71/W0IRewxvE3XXKQW8wIwkDi6UzgSH6DmEPAvQ9/V/4STaeP116Gfck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298482; c=relaxed/simple;
	bh=9JpRveCSySgO7ypcOt0Pp+m91jg8lcX5NlaoMCqYVq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hGPR6YzgsN2I1HvKXukVUkMD1F3UqLmRyyYgaKI/FixXmugkXphGUeEjPnbGfMettqqSLll7B9BmuT+pHLqCYCwBJiFP0GoUmBpgnQre8BXK+4dWVOvYw+IA3WrCL9XJvDInFzUbakyQraE5ZAVma9daBngCFts97lLr2Z2sQPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TE1nsb7A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TE1nsb7A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08EF61F000E9;
	Wed, 20 May 2026 17:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298481;
	bh=PXV+f3J3qpquro6bKoBDks0wZ2OFtX6cpnXMw8Rqg4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TE1nsb7ArKDaAZIIANacRPh5jyp9btADRgcEMHlVJU6dXo0kqpl7YFsXvj/yMWFP7
	 jzPZhw1Yrure66wbFx+2aJnLz7GXi3RUxFkj4nRdjsYvN6nsRnl3jpMkxhcga/M5Xk
	 tH7PT/wYTaUCfhwUM7iqeCFkN5o67oszVAMYSzhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Yang <xu.yang_2@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 426/957] arm64: dts: imx8qxp-mek: switch Type-C connector power-role to dual
Date: Wed, 20 May 2026 18:15:09 +0200
Message-ID: <20260520162143.760317766@linuxfoundation.org>
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

[ Upstream commit 825b8c7e1d2918d89eb378b761530d1e51dba82e ]

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

Fixes: 2faf4ebcee2e5 ("arm64: dts: freescale: imx8qxp-mek: enable cadence usb3")
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8qxp-mek.dts | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8qxp-mek.dts b/arch/arm64/boot/dts/freescale/imx8qxp-mek.dts
index 7b03374455410..ea78e84341523 100644
--- a/arch/arm64/boot/dts/freescale/imx8qxp-mek.dts
+++ b/arch/arm64/boot/dts/freescale/imx8qxp-mek.dts
@@ -497,9 +497,17 @@ ptn5110: tcpc@50 {
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




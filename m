Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C965352016;
	Wed, 20 May 2026 16:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295779; cv=none; b=Vt24XRzl3maUoJ4z87XdAUkVM7ohcYL5DZi+9bTYTqU8a+oca/kR2JOetETSF4STXQIAYHKw1VOu1QiWt6fDuEtZ1i9Timvs3m8cCXMRTAc17SvWbT3o5Q21ta/caElAwnTcQFelhozw2lNJIai9/lpok4dKzUSXxOlzzppzjPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295779; c=relaxed/simple;
	bh=LhlAs7V3bPnGfAf5g5zdaLhScjtkbjgmZ+VE86V5dGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TjOahFKwZsAIENZ5DIW1NpwoEXJcR+UOvw4M5ON7yzQ9X1c50WQxkzRG8L6DaEeL486RdhZgcPGV33QIIhDhkum5BN8EzIVMfzhK43isp5Aro3pLZaE099rl8JAQ7Ti2GSZq0nhfqOzcDgM3Ud4NQqCnK6nXGshYhICLLTzztAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VQS/Q+No; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VQS/Q+No"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E5A31F000E9;
	Wed, 20 May 2026 16:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295777;
	bh=dmpCaVSlcI4pDG526sJa2lpYGLa9Y99aM7S5WJtpkac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VQS/Q+NoGv/cWIUEiXJIVb2tGRJXu9CSrT7bbt9+ad8Y2V1T9Oo6wGuqLlqzvzIAh
	 +caLGvwphJrfUTOtHbq4PwG1l+kkEaz3svvmaRia5CgHOux++mSfvANSSCs2MwYXxy
	 6Ii0haaIsgZteZtgbFyGdxISn0QxIJmhMScluA+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Yang <xu.yang_2@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0547/1146] arm64: dts: imx8qm-mek: switch Type-C connector power-role to dual
Date: Wed, 20 May 2026 18:13:17 +0200
Message-ID: <20260520162200.559464746@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index dadc136aec6e6..011a89d85961d 100644
--- a/arch/arm64/boot/dts/freescale/imx8qm-mek.dts
+++ b/arch/arm64/boot/dts/freescale/imx8qm-mek.dts
@@ -611,9 +611,17 @@ ptn5110: tcpc@51 {
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




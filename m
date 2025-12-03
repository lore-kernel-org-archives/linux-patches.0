Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0603D33506D;
	Wed,  3 Dec 2025 15:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777198; cv=none; b=uSJlRbX8HRP9h9zKMXH9DGi+/lFrNIX+juZCXjtCwHZedYNG6NiYDLac2oJucz8ORelughFGh5oG2ZA+7oWhPAihVCFPkpuhE3UevMqFVB64A4TCsTFU00+bzVsb1REhpCfG6kbUTmhYxKegXQjD+kNyXg7kTrLYtr8+iXLSgDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777198; c=relaxed/simple;
	bh=1HgY1Sga16RBijABOAEPa+Qdqw9o+hfLQ1FPC2crqoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mDQ/K5WYAaj+tPfDtml9GC2mDPzCXiJX2RVX9b7am5QNNY0zogFDyjMN4vm4h087qOTNpMryNCLev42slH14pYP6GvoNpBtf5AbhC0FzSmne7S9DGcr616kU7ebs9BqXgny/wM75b2YpSDP9N1+uF78Ax2Wj9xpNy2VJEM5cTlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MPGH2l+C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MPGH2l+C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EF00C116B1;
	Wed,  3 Dec 2025 15:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777197;
	bh=1HgY1Sga16RBijABOAEPa+Qdqw9o+hfLQ1FPC2crqoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MPGH2l+CwL1OhtKIX7b9ELdol2Ftu//c0mMYCLZALZPc+HSFy+PaveeZSGC/LGkM6
	 uRdOynJ0JqlC3ZV7PhTXr2yeiJ53vxcCmCm9msEHxhUmkB+FZCo0bUDZGJDqNn99K7
	 mj3aXHuG3YK96fFpo38KqPNWesRr0aK6TG7GxKt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jun Li <jun.li@nxp.com>,
	Xu Yang <xu.yang_2@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.17 079/146] arm64: dts: imx8qm-mek: fix mux-controller select/enable-gpios polarity
Date: Wed,  3 Dec 2025 16:27:37 +0100
Message-ID: <20251203152349.355205299@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Yang <xu.yang_2@nxp.com>

commit e89ee35567d3d465ef0715953170be72f5ef1d4c upstream.

According to the board design, set SEL to high means flipped
connection (TX2/RX2). And the TCPM will output logical 1 if it needs
flipped connection. So switch to active high for select-gpios.
The EN pin on mux chip is low active, so switch to active low for
enable-gpios too.

Fixes: b237975b2cd5 ("arm64: dts: imx8qm-mek: add usb 3.0 and related type C nodes")
Cc: stable@vger.kernel.org
Reviewed-by: Jun Li <jun.li@nxp.com>
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/imx8qm-mek.dts |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/freescale/imx8qm-mek.dts
+++ b/arch/arm64/boot/dts/freescale/imx8qm-mek.dts
@@ -217,8 +217,8 @@
 		compatible = "nxp,cbdtu02043", "gpio-sbu-mux";
 		pinctrl-names = "default";
 		pinctrl-0 = <&pinctrl_typec_mux>;
-		select-gpios = <&lsio_gpio4 6 GPIO_ACTIVE_LOW>;
-		enable-gpios = <&lsio_gpio4 19 GPIO_ACTIVE_HIGH>;
+		select-gpios = <&lsio_gpio4 6 GPIO_ACTIVE_HIGH>;
+		enable-gpios = <&lsio_gpio4 19 GPIO_ACTIVE_LOW>;
 		orientation-switch;
 
 		port {



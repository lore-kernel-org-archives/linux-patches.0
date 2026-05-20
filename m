Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A783BE64B;
	Wed, 20 May 2026 16:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295774; cv=none; b=pz8oskUdGHq49/56OBLAiv1+oV/cmhoo8fbfapLTcQknsghLnrHajYTfFCAkvhiTIzsP+h5nfUsY9creOAx1R2clk+pZqr25Vn8ndg6w/BD//eiDWc0kmuwLUUv8rFtfga1UCQZZgNN0kiagChDN2ixYr5uCdSpbIMWTpkaJ9RU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295774; c=relaxed/simple;
	bh=Z2DR/V24Y9xoWUzBhbA/zgzgQkHKfdtxZ/+MqRhp6F0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X/gyUjJcnWHONJKVvyF7N8jETv4Vd78+XQeNMx58RkxzGpBSQr8Iga0U2n2jmkb81u6KQYyhf5od4zMye3oJ1cxMdryhrqa4X2BacBix4FAaextRdlwdNWWEqXtIZklxFEV2hPEHNL33IsxhlxhcN+evwNOK4fq7VKaPVotkFGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cnls10Qf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cnls10Qf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B0191F000E9;
	Wed, 20 May 2026 16:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295771;
	bh=JTopMf6gtb30tcoTnrACAaf/4SgV8tQ6Zd+rZgUhbA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cnls10QfyUL6UqltY7eTjKRTUlD53cCcnM/8nheq4q//w574q5uDi+/vPTwyx93If
	 VyFJz+QULrVlDAQ/EWEWmtFkCFtJ4m/eyMUKMR4wMyUKmnrQZK44u4iSA0lhdcazJt
	 OSLQMBnLqPqeMaAUep+2q2qRGF07lZjBgVgF7pjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josua Mayer <josua@solid-run.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0545/1146] arm64: dts: lx2160a: change zeros to hexadecimal in pinmux nodes
Date: Wed, 20 May 2026 18:13:15 +0200
Message-ID: <20260520162200.513141226@linuxfoundation.org>
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

From: Josua Mayer <josua@solid-run.com>

[ Upstream commit 03241620d2b9915c9e3463dbc56e9eb95ad43c08 ]

Replace some stray zeros from decimal to hexadecimal format within
pinmux nodes.

No functional change intended.

Fixes: 8a1365c7bbc1 ("arm64: dts: lx2160a: add pinmux and i2c gpio to support bus recovery")
Signed-off-by: Josua Mayer <josua@solid-run.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi b/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
index 53b9c5f1f1935..d266bf96e2c6a 100644
--- a/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
@@ -1722,7 +1722,7 @@ pinmux_i2crv: pinmux@70010012c {
 			pinctrl-single,function-mask = <0x7>;
 
 			i2c1_pins: iic2-i2c-pins {
-				pinctrl-single,bits = <0x0 0 0x7>;
+				pinctrl-single,bits = <0x0 0x0 0x7>;
 			};
 
 			gpio0_31_30_pins: iic2-gpio-pins {
@@ -1734,7 +1734,7 @@ esdhc0_cd_wp_pins: iic2-sdhc-pins {
 			};
 
 			i2c2_pins: iic3-i2c-pins {
-				pinctrl-single,bits = <0x0 0 (0x7 << 3)>;
+				pinctrl-single,bits = <0x0 0x0 (0x7 << 3)>;
 			};
 
 			gpio0_29_28_pins: iic3-gpio-pins {
@@ -1742,7 +1742,7 @@ gpio0_29_28_pins: iic3-gpio-pins {
 			};
 
 			i2c3_pins: iic4-i2c-pins {
-				pinctrl-single,bits = <0x0 0 (0x7 << 6)>;
+				pinctrl-single,bits = <0x0 0x0 (0x7 << 6)>;
 			};
 
 			gpio0_27_26_pins: iic4-gpio-pins {
@@ -1750,7 +1750,7 @@ gpio0_27_26_pins: iic4-gpio-pins {
 			};
 
 			i2c4_pins: iic5-i2c-pins {
-				pinctrl-single,bits = <0x0 0 (0x7 << 9)>;
+				pinctrl-single,bits = <0x0 0x0 (0x7 << 9)>;
 			};
 
 			gpio0_25_24_pins: iic5-gpio-pins {
@@ -1758,7 +1758,7 @@ gpio0_25_24_pins: iic5-gpio-pins {
 			};
 
 			i2c5_pins: iic6-i2c-pins {
-				pinctrl-single,bits = <0x0 0 (0x7 << 12)>;
+				pinctrl-single,bits = <0x0 0x0 (0x7 << 12)>;
 			};
 
 			gpio0_23_22_pins: iic6-gpio-pins {
-- 
2.53.0




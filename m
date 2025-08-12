Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB7FE61FFE;
	Tue, 12 Aug 2025 18:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023635; cv=none; b=BFVQJvwOrheCxFKZjXRqXSCiFMZF8CL3sdszENdYIV0rBl/wbh4TJgboSg+IZcfvsVCSkjgvFU83V9dGfsjc4tsCbOOESUHdDJ4dwioyHNcNT088FRCTGeU9rsA6Ej1aBFXGzhH8l0mQcts/4Oyw7jKrIn8a6tEagHvzwypy1H4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023635; c=relaxed/simple;
	bh=l0NRyTUd9b3hF+D8+06USVkkLbPE5IzoQuYZ+52TuG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UjGrZxGjeQOfX7ngKQBV2j/zQjaNLEFL4NrhegamnwEGddlvCK3pAL3sgqjP8raVG/+cf1/2RW+VkFUcwhG+Zjeu5c+1EctrcR5ku1DW9qfkq5I2XvvCMyREGNpaeq2v9vaSL848CChb3RwqDME++Wn6A7N2ylvPhZUEtdmm+X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=isLidWQ9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="isLidWQ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3852BC4CEF1;
	Tue, 12 Aug 2025 18:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023635;
	bh=l0NRyTUd9b3hF+D8+06USVkkLbPE5IzoQuYZ+52TuG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=isLidWQ9HYT6KDv2aNNoT5lWdn0W7ZAUMUZajhwbByMh/zLz/pxEAVc/naik2YliS
	 iK7gesulrPxWgwG+RAs8tjXxvM7v6kQL90u8jkPFIIkCm2/2SB+abGjnuMXjs6cwLa
	 jOG/U2Y80TerpM69Td1sZ1s4h9uD4s3jgOD51qsw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Krummenacher <max.krummenacher@toradex.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 104/627] arm64: dts: freescale: imx8mp-toradex-smarc: fix lvds dsi mux gpio
Date: Tue, 12 Aug 2025 19:26:39 +0200
Message-ID: <20250812173423.272434500@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Krummenacher <max.krummenacher@toradex.com>

[ Upstream commit 29d34c678cf82341cb0bedb3179d59c56856a80f ]

The MUX which either outputs DSI or 2nd channel LVDS signals is part of
the SoM. Move the pinmuxing of the GPIO used for controlling the MUX
to the SoM dtsi file.

Fixes: 97dc91c04558 ("arm64: dts: freescale: add Toradex SMARC iMX8MP")
Signed-off-by: Max Krummenacher <max.krummenacher@toradex.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-toradex-smarc-dev.dts | 5 -----
 arch/arm64/boot/dts/freescale/imx8mp-toradex-smarc.dtsi    | 2 ++
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-toradex-smarc-dev.dts b/arch/arm64/boot/dts/freescale/imx8mp-toradex-smarc-dev.dts
index 55b8c5c14fb4..d5fa9a8d414e 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-toradex-smarc-dev.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-toradex-smarc-dev.dts
@@ -102,11 +102,6 @@ &gpio1 {
 		    <&pinctrl_gpio13>;
 };
 
-&gpio3 {
-	pinctrl-names = "default";
-	pinctrl-0 = <&pinctrl_lvds_dsi_sel>;
-};
-
 &gpio4 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_gpio4>, <&pinctrl_gpio6>;
diff --git a/arch/arm64/boot/dts/freescale/imx8mp-toradex-smarc.dtsi b/arch/arm64/boot/dts/freescale/imx8mp-toradex-smarc.dtsi
index 22f6daabdb90..11fd5360ab90 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-toradex-smarc.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-toradex-smarc.dtsi
@@ -320,6 +320,8 @@ &gpio2 {
 };
 
 &gpio3 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_lvds_dsi_sel>;
 	gpio-line-names = "ETH_0_INT#", /* 0 */
 			  "SLEEP#",
 			  "",
-- 
2.39.5




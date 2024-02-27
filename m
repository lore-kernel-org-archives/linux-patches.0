Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCAEC13DBBC;
	Tue, 27 Feb 2024 14:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044130; cv=none; b=W63X4q4wS/aCS5TEbp/YkOPRIGjV6j2pnxmVhpODZEtZPc7BZyM0DzFUIdLiSdgGTCW4Dj+fXXLyqfXnCeNGpbW7teEMMHuxUcTaAMIxBYPqsNd67ryIViP8vrWugOIGS2T8gwmJC5f56xf0bDdyDTuhT+o/WVMB+bQ4HNG+/KM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044130; c=relaxed/simple;
	bh=XxWImPIAIdeTry7Tzis4HlxE6ETkgqiieR7j8aGBodQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O/jdMYw2pBu4Ta82P3xO4C1V+anBZ/ZTkAMcRcb2ClvFrJEartTQYL4jxekxyMoU2IV5OhYXYk773RK2hm7eJruj2DGVikj3TNaZKgyHprztRQ+3kyWnH4TEHVGTsF8KnjVZY3HRbpxXLxL1pTg/K9EUVXWQsjOmnPqi3tUb7yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DAaQgbxg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DAaQgbxg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A39DC433C7;
	Tue, 27 Feb 2024 14:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709044130;
	bh=XxWImPIAIdeTry7Tzis4HlxE6ETkgqiieR7j8aGBodQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DAaQgbxgcxFwyJQwM9fFyQBSO/TCfEqKwZXV/FA7Be1SiU/C1si1J9IeS88q8+9BA
	 867+ghxmD1YiAfZCY1IsybkaSh9fBitc/okcjNLQMZE/DjU3AJpVmp6vQnCRL1hu3M
	 IRQEtuYpjmGH1D+gVSXKWIy9KAhSo722CZWKk2y8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaolei Wang <xiaolei.wang@windriver.com>,
	Fabio Estevam <festevam@gmail.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 045/122] ARM: dts: imx: Set default tuning step for imx6sx usdhc
Date: Tue, 27 Feb 2024 14:26:46 +0100
Message-ID: <20240227131600.185411393@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131558.694096204@linuxfoundation.org>
References: <20240227131558.694096204@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiaolei Wang <xiaolei.wang@windriver.com>

[ Upstream commit 0a2b96e42a0284c4fc03022236f656a085ca714a ]

If the tuning step is not set, the tuning step is set to 1.
For some sd cards, the following Tuning timeout will occur.

Tuning failed, falling back to fixed sampling clock

So set the default tuning step. This refers to the NXP vendor's
commit below:

https://github.com/nxp-imx/linux-imx/blob/lf-6.1.y/
arch/arm/boot/dts/imx6sx.dtsi#L1108-L1109

Fixes: 1e336aa0c025 ("mmc: sdhci-esdhc-imx: correct the tuning start tap and step setting")
Signed-off-by: Xiaolei Wang <xiaolei.wang@windriver.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6sx.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/imx6sx.dtsi b/arch/arm/boot/dts/imx6sx.dtsi
index 08332f70a8dc2..51491b7418e40 100644
--- a/arch/arm/boot/dts/imx6sx.dtsi
+++ b/arch/arm/boot/dts/imx6sx.dtsi
@@ -981,6 +981,8 @@ usdhc1: mmc@2190000 {
 					 <&clks IMX6SX_CLK_USDHC1>;
 				clock-names = "ipg", "ahb", "per";
 				bus-width = <4>;
+				fsl,tuning-start-tap = <20>;
+				fsl,tuning-step= <2>;
 				status = "disabled";
 			};
 
@@ -993,6 +995,8 @@ usdhc2: mmc@2194000 {
 					 <&clks IMX6SX_CLK_USDHC2>;
 				clock-names = "ipg", "ahb", "per";
 				bus-width = <4>;
+				fsl,tuning-start-tap = <20>;
+				fsl,tuning-step= <2>;
 				status = "disabled";
 			};
 
@@ -1005,6 +1009,8 @@ usdhc3: mmc@2198000 {
 					 <&clks IMX6SX_CLK_USDHC3>;
 				clock-names = "ipg", "ahb", "per";
 				bus-width = <4>;
+				fsl,tuning-start-tap = <20>;
+				fsl,tuning-step= <2>;
 				status = "disabled";
 			};
 
-- 
2.43.0




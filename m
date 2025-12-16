Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F8E834A76E;
	Tue, 16 Dec 2025 11:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885201; cv=none; b=RsB9JIn4js8+yj50IYvmVfDmiJRp9+pY97UKqUGVgm4WOS4GZWrXrkeuYIyhXZNY2Qujn1CXqLCdpo8bJNjAvV1V/QAwG8ne6OsRI6e8qw+k/ERJyx541pGndQhU0c5NUYedWglDdLopuAnSCTSL+wns90nI59sA9wPBE/QbVmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885201; c=relaxed/simple;
	bh=BVE7BLl0Jr+QR5+1lrttWKMgqdYZmQkIRyZFAFqJUKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oCeSCqNcsMO/OyhcbYkxa9Vv+acEdS43yfTWGeo5tblv6zl/Hcm+LjkSkxfUa2fJcBv41ZQm7kzM5qzKuirrRArSJFBfInXc248p4d8xJ/b8nnBbWpL3Q3lhKYy2bI+Ux39ZFIKW7OkUB0KfRLcOYEK4U3JekNLwxvegbn4B/9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X0lR48Pu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X0lR48Pu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FFCCC4CEF1;
	Tue, 16 Dec 2025 11:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885201;
	bh=BVE7BLl0Jr+QR5+1lrttWKMgqdYZmQkIRyZFAFqJUKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X0lR48PupqsIVJILaDAQw/dKtuPIeJTjd84EmaFtQkGS+J1jd/APYk9irJzQWWfe8
	 RezQPapHuvJ0SClRzGXLlyqsnRZPinAQ2KNoKT4s+SqepZ7O9L/qncX8yk8C+OVmf+
	 N0lXlvKdFrbHZR3h2Wo7ZHiBEGUSFZUNjnHSEwRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Harvey <tharvey@gateworks.com>,
	Peng Fan <peng.fan@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 061/507] arm64: dts: imx8mm-venice-gw72xx: remove unused sdhc1 pinctrl
Date: Tue, 16 Dec 2025 12:08:22 +0100
Message-ID: <20251216111347.754072202@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

From: Tim Harvey <tharvey@gateworks.com>

[ Upstream commit d949b8d12d6e8fa119bca10d3157cd42e810f6f7 ]

The SDHC1 interface is not used on the imx8mm-venice-gw72xx. Remove the
unused pinctrl_usdhc1 iomux node.

Fixes: 6f30b27c5ef5 ("arm64: dts: imx8mm: Add Gateworks i.MX 8M Mini Development Kits")
Signed-off-by: Tim Harvey <tharvey@gateworks.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/freescale/imx8mm-venice-gw72xx.dtsi      | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw72xx.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw72xx.dtsi
index 752caa38eb03b..266038fbbef97 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw72xx.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw72xx.dtsi
@@ -351,17 +351,6 @@ MX8MM_IOMUXC_UART4_TXD_UART4_DCE_TX	0x140
 		>;
 	};
 
-	pinctrl_usdhc1: usdhc1grp {
-		fsl,pins = <
-			MX8MM_IOMUXC_SD1_CLK_USDHC1_CLK		0x190
-			MX8MM_IOMUXC_SD1_CMD_USDHC1_CMD		0x1d0
-			MX8MM_IOMUXC_SD1_DATA0_USDHC1_DATA0	0x1d0
-			MX8MM_IOMUXC_SD1_DATA1_USDHC1_DATA1	0x1d0
-			MX8MM_IOMUXC_SD1_DATA2_USDHC1_DATA2	0x1d0
-			MX8MM_IOMUXC_SD1_DATA3_USDHC1_DATA3	0x1d0
-		>;
-	};
-
 	pinctrl_usdhc2: usdhc2grp {
 		fsl,pins = <
 			MX8MM_IOMUXC_SD2_CLK_USDHC2_CLK		0x190
-- 
2.51.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C580A344D9A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301702; cv=none; b=XFLmm7KIlYQOAMfByZujCt5d7v7NvdW38q7ZeLYN2N3/QNViPYkgxcY+EO+FdLWDEahfA7YzhU3Gb4V0r8VpiQ2NXQUr4RcViGYvxCMmJsMuaR9cLIZITdMQ2K05r5xD727irUMj6svzWl/YkqyHUZetM4dv603GtRfPb65r6J0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301702; c=relaxed/simple;
	bh=71XPasmX0dh+j1wKlos4iSgEp8cxPZ+4+lAux1Dzb5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O0W2dbd/tgdT4TBnftBOSz6ZTF4FTT49VanVfbakhU3huA6SBPxs69TEcfDMnkG30mD9lyYA82oED7sbqYsWzDltEAf2p0XhiJDVd4Sjhc21nA3/FcDhkMhwQuKyYJUY6DR0cK9PfhAV6cPGB3yt93zygvtAOgFc4empSiV++NA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qo85tr1L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qo85tr1L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36685C116D0;
	Sat, 28 Feb 2026 18:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301702;
	bh=71XPasmX0dh+j1wKlos4iSgEp8cxPZ+4+lAux1Dzb5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qo85tr1LrONv4hj2IWZOFk5kir8a1euhszp+SaUv1wJjGpJuKdmCwmQheCYSYSvmi
	 qO+A9XEIbrFbJUqWri/LQwiUafSvniD/gi15tahsoPs9RKcN+J8WYo80R9TdfIP6GM
	 ZwN8YSqmMHm1wLcPgnaBqaNBDarhQN3gZFFAYbpP1A8VftraDbh2/JDonTyGlgvjnR
	 6OLjYUgexodd6gxrSsDw3dEuofTaxIBszoacSJxOoPmJRgmYL1X9nRdx68cnplKG1M
	 /6pELxR/gHS9CoSb0krYMn/H3qow1psoVKLITmgq+Bo9VZoWEBRxNz5v9mynt6sM4l
	 QzOUCTygsWIow==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Alexander Stein <alexander.stein@ew.tq-group.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 096/385] arm64: dts: tqma8mpql-mba8mp-ras314: Fix HDMI CEC pad control settings
Date: Sat, 28 Feb 2026 12:55:18 -0500
Message-ID: <20260228180011.1568201-96-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 53a5c1d98d1155ece4c9446c0fea55e17d08774a ]

As per datasheet of the HDMI protection IC the CEC_IC pin has been
configured as open-drain.

Fixes: ddabb3ce3f90 ("arm64: dts: freescale: add TQMa8MPQL on MBa8MP-RAS314")
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mp-ras314.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mp-ras314.dts b/arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mp-ras314.dts
index f7346b3d35fe5..a122f2ed5f531 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mp-ras314.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mp-ras314.dts
@@ -704,7 +704,7 @@ pinctrl_hdmi: hdmigrp {
 		fsl,pins = <MX8MP_IOMUXC_HDMI_DDC_SCL__HDMIMIX_HDMI_SCL	0x400001c2>,
 			   <MX8MP_IOMUXC_HDMI_DDC_SDA__HDMIMIX_HDMI_SDA	0x400001c2>,
 			   <MX8MP_IOMUXC_HDMI_HPD__HDMIMIX_HDMI_HPD	0x40000010>,
-			   <MX8MP_IOMUXC_HDMI_CEC__HDMIMIX_HDMI_CEC	0x40000154>;
+			   <MX8MP_IOMUXC_HDMI_CEC__HDMIMIX_HDMI_CEC	0x40000030>;
 	};
 
 	pinctrl_gpt1: gpt1grp {
-- 
2.51.0


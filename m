Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9172F33F8A2;
	Sat, 30 May 2026 17:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161269; cv=none; b=k4+xP+5fGnNVx2daFfoWEwuE1l7YPwhMh9IHy65VKRwLNK9AH4OudurntzSNJSFnmVltGMby10/akGOhH0r4MtfBnQAb8ahk1No2bftRyCbJPqI73IJAx/h6Yr9LwnM5JS7FlEpAC+R/F9872Msq6Dzx5LFaTKu1vwMyElVjKFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161269; c=relaxed/simple;
	bh=imvNC2ef6QvykF7AqCxfXoIf9YhA+QOo/TDE5/GSoSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RC+EFuitYASvENMRhn/iaYnauV30exyRuJEsmm0y/8EBoIxWYS/4cA/rmPxffPOsojzM17fbPvdQCmRq4aAyh6IG3BpMyGjEkA2umcFLslPMPLKasZcnvhSNyCet1pmKiyusTx/7LcfZ2X0kyDGauyKDGsFy36MIyam3gP67RBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V4lNvgdg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V4lNvgdg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6ECF1F00893;
	Sat, 30 May 2026 17:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161268;
	bh=gE+rVbfMd8QtjBfe6//mYEv7D1G1/ZhPGgN8Z4Lt/9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V4lNvgdg217TgeX65IYHbUlmMCLCFWopFxw7C1e07KD4luDRFnE4SxPEw+ggavmZH
	 EXnq4fnqfIqYwdFX7+WbJ0WGTIcIEJ5l6sUGZZ/kwZ2RykjEnC1RQW3SY0GosOxj8F
	 FtlEZV8obOsV/ejzrp7uf8YIUiuqvdYlWbLe6a/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sherry Sun <sherry.sun@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 575/969] arm64: dts: imx8mp-evk: Enable pull select bit for PCIe regulator GPIO (M.2 W_DISABLE1)
Date: Sat, 30 May 2026 18:01:39 +0200
Message-ID: <20260530160316.284578569@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sherry Sun <sherry.sun@nxp.com>

[ Upstream commit d1e7eab6033f9885a02c4b4e8f09e34d8e9d21ab ]

The current pin configuration for MX8MP_IOMUXC_SD1_DATA4__GPIO2_IO06
sets the weak pull-up but does not enable the pull select field.
Bit 8 in the IOMUX register must be set in order for the weak pull-up
to actually take effect.

Update the pinctrl setting from 0x40 to 0x140 to enable both the pull
select and the weak pull-up, ensuring the line behaves as expected.

Fixes: d50650500064 ("arm64: dts: imx8mp-evk: Add PCIe support")
Signed-off-by: Sherry Sun <sherry.sun@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-evk.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-evk.dts b/arch/arm64/boot/dts/freescale/imx8mp-evk.dts
index 126c839b45f2d..703eec6b0107e 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-evk.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-evk.dts
@@ -551,7 +551,7 @@ MX8MP_IOMUXC_SD1_DATA5__GPIO2_IO07	0x40
 
 	pinctrl_pcie0_reg: pcie0reggrp {
 		fsl,pins = <
-			MX8MP_IOMUXC_SD1_DATA4__GPIO2_IO06	0x40
+			MX8MP_IOMUXC_SD1_DATA4__GPIO2_IO06	0x140
 		>;
 	};
 
-- 
2.53.0




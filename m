Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A446363C4C;
	Wed, 20 May 2026 17:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298955; cv=none; b=r4W9O/XgbSOL0LzE3IhhAi0Cqffn5BQwEcTH0x8NveUrznZJ4Um+Wh/nun3jCnBs8g6Q7jYJ1HgMuPJbpHdesZurmnMzoL6ecdXuW60rEH5hpbZUP11k1g6ZAHXJsNXzXqxX0NJXGwqMIYdDnKZGGKeN12dfebn/Q95JmjbrB88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298955; c=relaxed/simple;
	bh=7BskovTGeYpy2kU0ncyDT8tqfKbgHNRSPjSz914NNDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mHTD1Fjd4lf+BFZIYTUVKda5SgXGxzVcz3m9kBSYftshq3dbgCJNhOEUuujPA1tCQxi1neAStviQjTKjXDLgUau5f1zrHVa4BC+XAKodHOz8GaiTfNMDFoEneYAKRbgBN1Au1ISvDC4sz0I8GEMHlZw00Gm0d/t1JJhwO3ytxQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZGycJsYz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZGycJsYz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 809DE1F000E9;
	Wed, 20 May 2026 17:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298954;
	bh=bwzvo/jOU8il57LeFhvJmld2w8ChpYO/aizibm+k/hU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZGycJsYzz0MF8xJL+Y91zeYNwbi2i6wnJoxDYVhBeQCEHvmKz+Ef/hl8i7CjXcemP
	 wBTB4UvnBCJgFWkYvrIxPDXEYyZn3I/2HXXVk23Tx3n/N0He0MY+hGMRDMNXrMVoHs
	 cUB1qIxCS4+qQqObHmQir7aJarokajzUA3HjwCfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 606/957] arm64: dts: imx8mp-dhcom-som: Correct PAD settings for PMIC_nINT
Date: Wed, 20 May 2026 18:18:09 +0200
Message-ID: <20260520162147.676540774@linuxfoundation.org>
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

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit f9ed5afc988da3e22543725e35be6addbb0497bc ]

PMIC_nINT is low level triggered, but the current PAD settings is
PE=0,PUE=0,FSEL_1_FAST_SLEW_RATE=1,SION=1. So PAD needs to be configured
as PULL UP with PULL Enable, no need SION. Correct it.

Fixes: 8d6712695bc8e ("arm64: dts: imx8mp: Add support for DH electronics i.MX8M Plus DHCOM and PDK2")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi b/arch/arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi
index f8303b7e2bd22..0a6a60670f762 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi
@@ -989,7 +989,7 @@ MX8MP_IOMUXC_SAI5_RXC__GPIO3_IO20		0x22
 	pinctrl_pmic: dhcom-pmic-grp {
 		fsl,pins = <
 			/* PMIC_nINT */
-			MX8MP_IOMUXC_GPIO1_IO03__GPIO1_IO03		0x40000090
+			MX8MP_IOMUXC_GPIO1_IO03__GPIO1_IO03		0x1c0
 		>;
 	};
 
-- 
2.53.0




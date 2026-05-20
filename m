Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5458A359A6F;
	Wed, 20 May 2026 17:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298324; cv=none; b=ojKKjosKVTpTEMe5CuebkMrGTLh/FlAu2Xl0mVYqnUvB4CPP2wO/7BF61OkOPVSG7Gd+f8e3nj2GQCP+bvkLESwAC378rseD/BYayPUDFemOznhOtiQKR3JHO+gF8LDmu65UGgm9v1YKwOXUNqB0Znr/KvNHsPZTJxqx7180e5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298324; c=relaxed/simple;
	bh=QD9j7V5zCRKSjEcJGCmeQ9ari82xbkG8QX9OVvJ2Gfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TRntK+PYOJpuHKWMtJ3qQ/IUTxgxz0AJGhEix8UFCeqFxas6p8id+EwKJgw6c+LLDa6nsW5rU4Tv3kDBpJY8B3eOgs/STbrjz3skB+RbKncjoV3n7dvrwYycQfCbjLEqr8SZq9qnpSXbtx6BXO7LB3zn9TXRyTby2Xwt06r9ohE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1uNtiKrW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1uNtiKrW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9EF31F00893;
	Wed, 20 May 2026 17:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298323;
	bh=+2czx6mpFb3rDAF2Fq1iXAk+1v0Q9XiloyAKnyGY5Ng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1uNtiKrWcyaJaMfRSt6c6ykzTIX2SIm6MMxGke+m31TwfOaKfGJ14n7Ihw8O88abO
	 ytoUgKGa4MD1EQbTJyHoPhlm6M3qLGG7Cz+dP81nTeCuRqO8zh4ZsBky8pQ9dbHwec
	 lsNsaJT76fvS9JQ4PQxFO2fso5xRYq8sSOzg3myo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sherry Sun <sherry.sun@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 368/957] arm64: dts: imx8mp-evk: Enable pull select bit for PCIe regulator GPIO (M.2 W_DISABLE1)
Date: Wed, 20 May 2026 18:14:11 +0200
Message-ID: <20260520162142.508883195@linuxfoundation.org>
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
index 3730792daf501..d957d6cc20f7f 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-evk.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-evk.dts
@@ -995,7 +995,7 @@ MX8MP_IOMUXC_SD1_DATA5__GPIO2_IO07	0x40
 
 	pinctrl_pcie0_reg: pcie0reggrp {
 		fsl,pins = <
-			MX8MP_IOMUXC_SD1_DATA4__GPIO2_IO06	0x40
+			MX8MP_IOMUXC_SD1_DATA4__GPIO2_IO06	0x140
 		>;
 	};
 
-- 
2.53.0




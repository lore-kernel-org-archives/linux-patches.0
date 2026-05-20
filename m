Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1499E3FB7EE;
	Wed, 20 May 2026 18:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300684; cv=none; b=CEfXFtR6xl0T+U27fPJm2DWvx4Ri53/Gp7/qSZIfLMmaIvZ1Euq2nk0nP32+61FBBHltqzBxI7IGXGLR8IP/KrHhFh6RZVXFsc87PEGvCKFU8MYf4GCrcpiAV5jnMfhbOS5hX+xlkkcJVjGKs2eD5tN/CCxltdVsSsOZ2ULj0PM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300684; c=relaxed/simple;
	bh=1C7QZZEs5Ocqa07oG0ky/DT5M6lapBC6eRVKR1343wU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L8yxUz7gmURktGvRBMNGKI1SW7XgHOckM46P9hW9CngiUe5opxfZ7wX56XZ6Kb4FPdjvueYFbqp+/+1m5lBMDY1D+7uk4yu/wcHLIEDYN4V/br8IbP27W52lOVUU8FcAWYSrnl5Sn2PQIeGRj1nSDJQ9YCcB4eP6fbDF9xc/VZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=clD9Gz4E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="clD9Gz4E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78F9A1F000E9;
	Wed, 20 May 2026 18:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300683;
	bh=wfpGbgENj9fwGpB5B5eDyzYoucDV0xFEceL0EVPkLoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=clD9Gz4E+cU/omjz8hSH4vvUGJwGoD3GVDLGQfaWBgNngLQ2FMqDX2fIQGJaAIBNA
	 lOuB7hC89Q/dnJHa7kDo2o7IxyEkaMuSxLYOJeIx4JwB2v4zOx3a98GtfxRB+A6glp
	 uxWiYsK9MircLSbPE9B/jKWrc9GX2kdU2k7b++yU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sherry Sun <sherry.sun@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 269/666] arm64: dts: imx8mp-evk: Enable pull select bit for PCIe regulator GPIO (M.2 W_DISABLE1)
Date: Wed, 20 May 2026 18:18:00 +0200
Message-ID: <20260520162117.046982148@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d26930f1a9e9d..2f1ef1b188bed 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-evk.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-evk.dts
@@ -947,7 +947,7 @@ MX8MP_IOMUXC_SD1_DATA5__GPIO2_IO07	0x40
 
 	pinctrl_pcie0_reg: pcie0reggrp {
 		fsl,pins = <
-			MX8MP_IOMUXC_SD1_DATA4__GPIO2_IO06	0x40
+			MX8MP_IOMUXC_SD1_DATA4__GPIO2_IO06	0x140
 		>;
 	};
 
-- 
2.53.0




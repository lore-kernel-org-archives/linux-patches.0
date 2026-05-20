Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD7A33F9287;
	Wed, 20 May 2026 18:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301189; cv=none; b=R9v7Ooxb54YbRyLvNehN+Sf9ktFZAPG6eTvt6qqKrUcrVYGyX9H/UFfbtCxGUAgS+udZSt4BQL7WVFrwe/sO+ycyhHv9ZIHSMbpkn3mQuBLYkBAKkU1Gfqc9WzDLw9f3U0MOacvEGEkDFjYX5ds6ZqOFx8PVXsBRGQMwG3GtKPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301189; c=relaxed/simple;
	bh=GIcOSfKdSZ/LYyRuZ2tGNyxTWSqVik4xawQ+fXDGM44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XC8zito7KUUV42nsGwOpbgb1mPP0UZ95aGVjEw4LQsgquPDf3kRKmTugkPMO+b7UBN7puBA9U+qToDVvLPFlj89KtRNPd14KmRujfZUiLHIVj+smqPVH6aiwnLQ7U25hsC9zuJj5r5ss5vK3OCiZT/gJPEf7CkwAKCzSbz8kF10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fNo0SkQ8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fNo0SkQ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DE631F000E9;
	Wed, 20 May 2026 18:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301188;
	bh=iMJORxYBX9VUHAs5D4FiloiBFdfVFc8jhqSbaojus7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fNo0SkQ8M8LOiIoyDFNHlWB857wLZy7uV2yaMNJk9FH7ibTK0Ut088hv7KPqvF+B4
	 4sBYE3UgHqL2/jquJWXEcEqPuntg/HJxpE83jc9Q3gvdpJmL6PMSNzABNgEY4NaFXm
	 wdBhDxrd/ajCimU64vgSKCD38jM3ukWsG6jKcTCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 433/666] arm64: dts: imx8mp-debix-model-a: Correct PAD settings for PMIC_nINT
Date: Wed, 20 May 2026 18:20:44 +0200
Message-ID: <20260520162120.655979656@linuxfoundation.org>
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

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 3b778178997aee24537b521a8cb60970bc1ce01c ]

With commit 5d0efaf47ee90 ("regulator: pca9450: Correct interrupt type"),
there is interrupt storm for i.MX8MP DEBIX Model A. Per schematic, there
is no on board PULL-UP resistors for GPIO1_IO03, so need to set PAD
PUE and PU together to make pull up work properly.

Fixes: c86d350aae68e ("arm64: dts: Add device tree for the Debix Model A Board")
Reported-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Closes: https://lore.kernel.org/all/20260323105858.GA2185714@killaraus.ideasonboard.com/
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Tested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-debix-model-a.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-debix-model-a.dts b/arch/arm64/boot/dts/freescale/imx8mp-debix-model-a.dts
index af02af9e5334d..740cac4cb31d9 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-debix-model-a.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-debix-model-a.dts
@@ -440,7 +440,7 @@ MX8MP_IOMUXC_SAI5_RXC__I2C6_SDA					0x400001c3
 
 	pinctrl_pmic: pmicirqgrp {
 		fsl,pins = <
-			MX8MP_IOMUXC_GPIO1_IO03__GPIO1_IO03				0x41
+			MX8MP_IOMUXC_GPIO1_IO03__GPIO1_IO03				0x1c0
 		>;
 	};
 
-- 
2.53.0




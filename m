Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FB9729B78D;
	Wed, 20 May 2026 18:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301242; cv=none; b=uLLBM2U5tNnWUtsFPkd8jBh73F9GW+wOexBrs0f5Dr2nvJJG2LJllp85G5BBekNNCUj4mb9+ZOXt9/9Ks09iVhYFpLROxaipuZUO58pi6grM1tv+TcJCnhJTEKrvn60oz4crfZftecEAicI5o9vyryWJkDZrzjOGg5aEw4Dg2Zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301242; c=relaxed/simple;
	bh=Y8fsoxJeAAHUI5WPshNioffQXlFDgCme+MpcKC0Scfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qmG3bkuiGJoki9afmPiB8FzNwnOn3TAp8dcQxF3gQpE6FXK1tLtr5giFpgpFPl3g2DIwG1A6+ndA0Qv6uSlUxBPCvsXR05aREa7SwwpYjAdDZDY6tiO0XIqKWjmeW/0TvFiQlpVjyd5rp7s3IiA5a9CEE6E4zbz7JyaPg5TxUgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RXfkjXHg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RXfkjXHg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C66551F000E9;
	Wed, 20 May 2026 18:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301241;
	bh=y07pQSOxGNYorDjZ5dQ6RL1QqNbPWOGGo/yMOTO/zYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RXfkjXHgRLedcJb+aymyPAiRkfxHMmVzSdbxoBOLZXT0Z+HISuAWt7RrCZRHvx4F7
	 9T/E4FE0s1hgfSqzT9b+x7iBiGQgpagdy4mZBsWQLGm6CFbPkNgnHIi7AkPaybVtCL
	 Ik6T80xygPSZvGJ6O+Injv8o7u0QMlg/Iv808wtk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 438/666] arm64: dts: imx8mp-data-modul-edm-sbc: Correct PAD settings for PMIC_nINT
Date: Wed, 20 May 2026 18:20:49 +0200
Message-ID: <20260520162120.767006472@linuxfoundation.org>
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

[ Upstream commit 8ff145577e93f312ff398cb950ee3bd44835f5be ]

PMIC_nINT is low level triggered, but the current PAD settings is
PE=0,PUE=0,FSEL_1_FAST_SLEW_RATE=1,SION=1. So PAD needs to be configured
as PULL UP with PULL Enable, no need SION. Correct it.

Fixes: 562d222f23f0f ("arm64: dts: imx8mp: Add support for Data Modul i.MX8M Plus eDM SBC")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-data-modul-edm-sbc.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-data-modul-edm-sbc.dts b/arch/arm64/boot/dts/freescale/imx8mp-data-modul-edm-sbc.dts
index 16078ff60ef08..fa13662ca3667 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-data-modul-edm-sbc.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-data-modul-edm-sbc.dts
@@ -900,7 +900,7 @@ MX8MP_IOMUXC_SAI3_RXFS__AUDIOMIX_PDM_BIT_STREAM00	0x0
 	pinctrl_pmic: pmic-grp {
 		fsl,pins = <
 			/* PMIC_nINT */
-			MX8MP_IOMUXC_GPIO1_IO03__GPIO1_IO03		0x40000090
+			MX8MP_IOMUXC_GPIO1_IO03__GPIO1_IO03		0x1c0
 		>;
 	};
 
-- 
2.53.0




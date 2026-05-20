Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81C613F0AAD;
	Wed, 20 May 2026 16:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296335; cv=none; b=RtUw1iRzrqgcWYB/grw7Fel/SKz0qqO7z8YVdjEz1QpYLUnvLGflgc9Y1XGcQNvT/QpkWynxJOZq9zAWyrqQSL3enSvxAi13MCFEXLdGlEppHSZG7kIXZSUrU4AmzMOiewAhUnPfE1T1ZxHQRh8+cusvB99o2jFzFimkj+2KPT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296335; c=relaxed/simple;
	bh=GcKAbL/EEGp3UZ9nqE8J2rH7CBfdV7xBd1K2d4K0jLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ANOxSRLOuarodLFs44BuTYDV0140XMgucwY8eeIEIsVyXfSONdyrWiOgXFgTBYwUTpCR8fHSh6h0jtKTKeoV0ngXtTb0bqKA2Mx6MqHzhNiJR5AkmFfBKNHP0muENr8tesi6aUMNwgTCbPLSq4RXaQ+9ShERihNL+fUVJbqk9w4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QCkz/gjR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QCkz/gjR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E81301F000E9;
	Wed, 20 May 2026 16:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296334;
	bh=K27dWDFP/472VapxPfTIxgbzz7xA0Gd160ihmkIb5mw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QCkz/gjRPwBFhnYqqpiwzxjMfIVQ+YBaYUGpqPAcxYQTMkqo13/90w92kaBAFVIvc
	 CaHCLmevWk3rmR2RVABCjEGLzkk9bdpcKdhJfDoOOnHj3xpNq/mQ/VR2eT1ttdVukx
	 Si00CDhGs3da6ruP7f1bWiadk1eOJ0DhaOWfeBmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0760/1146] arm64: dts: imx8mp-data-modul-edm-sbc: Correct PAD settings for PMIC_nINT
Date: Wed, 20 May 2026 18:16:50 +0200
Message-ID: <20260520162205.409565805@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 7e46537a22a01..cb28cf1cdd23f 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-data-modul-edm-sbc.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-data-modul-edm-sbc.dts
@@ -1001,7 +1001,7 @@ MX8MP_IOMUXC_SAI3_RXFS__AUDIOMIX_PDM_BIT_STREAM00	0x0
 	pinctrl_pmic: pmic-grp {
 		fsl,pins = <
 			/* PMIC_nINT */
-			MX8MP_IOMUXC_GPIO1_IO03__GPIO1_IO03		0x40000090
+			MX8MP_IOMUXC_GPIO1_IO03__GPIO1_IO03		0x1c0
 		>;
 	};
 
-- 
2.53.0




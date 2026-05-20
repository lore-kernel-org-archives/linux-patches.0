Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7643409127;
	Wed, 20 May 2026 18:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302649; cv=none; b=Fo7JnyZ8i7QyLl2DI6D0Ue+F8mtqE3MuuyqcpBfuI4BNrEOdb/dPhqdBtBfMqKbh8NOOXrLPfGBEABT/gccEjZ/jzWEO9EwpOZSECJkAJFbgshvYVQxai+DlJP0WF/e6zZTk9GFZKKYsk2z/wuxbzDyFCacWNzvb71BxBKcSwBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302649; c=relaxed/simple;
	bh=ENML4/Ct3F8G3pp6zd2f5qZhid+6Nwpi8ijzFcxxAaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mxS/eNlEJrEN6G8xBwus0j/BsvxOQWV8QMi3RMB9yTSkDnyNiqce1NcND5Nb+E5UKZe3UmDd2OSFSZH3XhMGhhQfknmEGZENd4N5US5dvVeblsyW9nnqjtnP0+IjfYj4XWzV6W46k9Vv3s+9sjRq592bhIykjtV/MkLy9arRpxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YgzXji1Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YgzXji1Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 283641F000E9;
	Wed, 20 May 2026 18:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302648;
	bh=eWnXlcNzIrB8DieizBjLBldKqCGg9RoYhHwD0OE1hk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YgzXji1ZntbmZSzYI06PGQtuiQ5WH5t94ITgF7nAiNxpkHf5mxy7Cen4BYTyYfCHz
	 EXfX8T+8g1LO8XqWZMzRqF6Hl4JIxD92eg556JXjCGHDTJgXZIjN3qljWKUKwTq0jH
	 1XGG0Qz5YmoctMwiVvL6uc8BTqgHsDmXvGDp7caE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 306/508] arm64: dts: imx8mp-data-modul-edm-sbc: Correct PAD settings for PMIC_nINT
Date: Wed, 20 May 2026 18:22:09 +0200
Message-ID: <20260520162105.271055226@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 678ecc9f81dbb..816469fcd5d76 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-data-modul-edm-sbc.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-data-modul-edm-sbc.dts
@@ -780,7 +780,7 @@ MX8MP_IOMUXC_SAI3_RXFS__AUDIOMIX_PDM_BIT_STREAM00	0x0
 	pinctrl_pmic: pmic-grp {
 		fsl,pins = <
 			/* PMIC_nINT */
-			MX8MP_IOMUXC_GPIO1_IO03__GPIO1_IO03		0x40000090
+			MX8MP_IOMUXC_GPIO1_IO03__GPIO1_IO03		0x1c0
 		>;
 	};
 
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A353D1CC6;
	Wed, 20 May 2026 18:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301234; cv=none; b=KRN8tHduYYlDrhtvpZlKxVNYEDtgeUTKRWEogTmACoSRGqrKRrnvQwMef3ox5XgOUxPG9z9uui4CbSvstLJTiLJ9VzkGKtT93A5RCmT+0w+02xn+4xep/KWHPkpJKSsIrWznRd8cieZVw4YpegEVxmFhMdTz1Dhx9oQ7PWq8RvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301234; c=relaxed/simple;
	bh=eaxDIPKlEVrxIUL/QwR+3i1PvSu4upxiBs43W1Bdq9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ko2cxnR7QVs5rIxe2PtaonKxCiji1KJq/7YuCfUDnS+dSXN2iFnd5zrSFbhDzZ1yZ0AIigDtN+mhvoG+U9QgvOE+4uwL5m+1FvXnsucF9OAajXint8OWV1WKW+HLcBChPgDZS6k83Ovd14ezx7n7NKBIXuN16U4yQWXtdNBNsBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XKXFoYaa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XKXFoYaa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E38281F000E9;
	Wed, 20 May 2026 18:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301233;
	bh=EV7C53WfWzK3wSiflbdFl2GOHdsPDe6u0aaZiVAyjCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XKXFoYaaLvKSOFRRLyMjVntBFXAzANcSNBJ9Jd5PAVi5fgC5cO2XcZd1m9CxUZJ4+
	 +lFVUd6BZQoBgCG9AEdMjfYPNodTg6hg8+Who+6YUKYZ12oiLx/iVhRZzjXrwdDvvx
	 r8M0jCQ5u0jWOoEMbgc0Ulxt4S4tpD/h1D6RuoNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 435/666] arm64: dts: imx8mp-navqp: Correct PAD settings for PMIC_nINT
Date: Wed, 20 May 2026 18:20:46 +0200
Message-ID: <20260520162120.700049693@linuxfoundation.org>
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

[ Upstream commit 741d6ac1a2a2e0f3e2cae5eef3516cdd75119e83 ]

With commit 5d0efaf47ee90 ("regulator: pca9450: Correct interrupt type"),
there will be interrupt storm for i.MX8MP NAVQP. Per schematic, there
is no on board PULL-UP resistors for GPIO1_IO03, so need to set PAD
PUE and PU together to make pull up work properly.

Fixes: 682729a9d506d ("arm64: dts: freescale: Add device tree for Emcraft Systems NavQ+ Kit")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-navqp.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-navqp.dts b/arch/arm64/boot/dts/freescale/imx8mp-navqp.dts
index 5fd1614982cd5..128bc1e6dac54 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-navqp.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-navqp.dts
@@ -309,7 +309,7 @@ MX8MP_IOMUXC_I2C4_SDA__I2C4_SDA					0x400001c3
 
 	pinctrl_pmic: pmicgrp {
 		fsl,pins = <
-			MX8MP_IOMUXC_GPIO1_IO03__GPIO1_IO03				0x41
+			MX8MP_IOMUXC_GPIO1_IO03__GPIO1_IO03				0x1c0
 		>;
 	};
 
-- 
2.53.0




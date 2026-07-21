Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D8D46AA71;
	Tue, 21 Jul 2026 15:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648314; cv=none; b=GlDW7QaKbaIbiNYUxLgQKN5+T7YzrKx6PjRaVOqUj5e2GXGIU78j3YtUw8r0QLZVEyW1GiA4fN11PnZ143Qd2ww8bTFuChfaqSdPBAF2aiUPliue9+3DKTri5zFVaAsS24WE5N4nnGYGkazWZAjyoSzXHwI+f1pRkZcccBksdM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648314; c=relaxed/simple;
	bh=7pVcMuUCp6Vp9E3LHfp7PfhWyla7QfHX44dPpSPlBDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SmBeLWm8baEx5+4Xkf4h1hOYKJJckx59txaScVEgEc0xKsboKafQvzQc2Dhx+Vt3kiqPjExVfWIdzlb0YIyswxZjcVnphZ7YjlhU2c90sJyarir1FmyhUaKMGT5kAuHjmCT2EQ4d/9NVentuJ7Vn9vxhESXqTalrrffRuDKtocA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vw1JlKz2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vw1JlKz2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F15B1F000E9;
	Tue, 21 Jul 2026 15:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648312;
	bh=FljWTCEpanh7FRphxa7BsVDrJnMDz0M81RsH+ViuxG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vw1JlKz2sEWNAksRAkfT33MhE0SU23GO/oekyQwvb4RIUZ0bXlEkBeaA/zBQQpo89
	 ikXu0MbemPUp6wGESzCwrAelA9qP7e94yn8Erxj+qtauHQt35BlSvMYvAx3jvLbP1J
	 QQETw5yLpnv0IZCAPvwp/tj+ekr5BdvU8zn2eOB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Marek Vasut <marex@nabladev.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0152/2077] arm64: dts: imx8mn-vhip4-evalboard-v1: Correct interrupt flags
Date: Tue, 21 Jul 2026 16:57:05 +0200
Message-ID: <20260721152556.269500064@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

[ Upstream commit 895e7756cdc1ba6467eb37eba31c1358243f6ad9 ]

GPIO_ACTIVE_x flags are not correct in the context of interrupt flags.
These are simple defines so they could be used in DTS but they will not
have the same meaning:
1. GPIO_ACTIVE_HIGH = 0 => IRQ_TYPE_NONE
2. GPIO_ACTIVE_LOW  = 1 => IRQ_TYPE_EDGE_RISING

Correct the interrupt flags, assuming the author of the code wanted the
same logical behavior behind the name "ACTIVE_xxx", this is:
ACTIVE_LOW  => IRQ_TYPE_LEVEL_LOW

Fixes: 5eb7405db99b ("arm64: dts: imx8mn: Add ifm VHIP4 EvalBoard v1 and v2")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Reviewed-by: Marek Vasut <marex@nabladev.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mn-vhip4-evalboard-v1.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mn-vhip4-evalboard-v1.dts b/arch/arm64/boot/dts/freescale/imx8mn-vhip4-evalboard-v1.dts
index 5f37065bf43f38..a8f7c226a61f86 100644
--- a/arch/arm64/boot/dts/freescale/imx8mn-vhip4-evalboard-v1.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mn-vhip4-evalboard-v1.dts
@@ -112,7 +112,7 @@ &i2c3 {
 
 &ifm_pmic {
 	interrupt-parent = <&gpio2>;
-	interrupts = <0 GPIO_ACTIVE_LOW>;
+	interrupts = <0 IRQ_TYPE_LEVEL_LOW>;
 };
 
 &iomuxc {
-- 
2.53.0




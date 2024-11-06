Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A1D1E909B;
	Wed,  6 Nov 2024 12:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897901; cv=none; b=CgGnwqRNgHoMc8t0u5DNDw+pLiyp233H0cWg7MDoFUXR5v4mepprMgOEvOKDMgcZrH39cVFTyeGuJk5z9zeyGJj+qcK58PBci8nFuO1UTcV8G8GKNu8rLRv9elu3ambgZ8hC0cUw4jqWIU7ZCBdh2Io3xYmxnJZj4tNIp6nTwZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897901; c=relaxed/simple;
	bh=7J7VczyrPIfhi60d/Knh5Sh5Fk3jev6WRYdAr4V5D1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u1mqXe01TdrwFgptJDby07rfXRvkJa/qvb+PxXYC1tQlg2sPZoSEJS6CmpC6hOE0rOd2dmnSDlUaMswPpOwZgh3qUWs9HPriPW70D5euGihsLb6atd3DMlb3y1e9JfbKNh95zazZLenpqmo7pxkhDGiEE0smf/Kxd+NuMO0s3Gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EuOGBRbs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EuOGBRbs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A64EDC4CECD;
	Wed,  6 Nov 2024 12:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897901;
	bh=7J7VczyrPIfhi60d/Knh5Sh5Fk3jev6WRYdAr4V5D1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EuOGBRbsthFkvtW2oQVM8N9LSG8h1Tgq+VHYFeLMHkFTLCWAoVC8laYegiE9DaQyS
	 iNaZiXMa12T1m0qHuAweKr9rvgxUN+M9ECC7jLlU5b/SFdMcfpOBMvlCaQitcq3bMk
	 JD5FSvkDOozuJ9VJvKA/iPEs+iwnUl/RH9PLLPHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 057/462] ARM: dts: imx7d-zii-rmu2: fix Ethernet PHY pinctrl property
Date: Wed,  6 Nov 2024 12:59:10 +0100
Message-ID: <20241106120332.926133459@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 0e49cfe364dea4345551516eb2fe53135a10432b ]

There is no "fsl,phy" property in pin controller pincfg nodes:

  imx7d-zii-rmu2.dtb: pinctrl@302c0000: enet1phyinterruptgrp: 'fsl,pins' is a required property
  imx7d-zii-rmu2.dtb: pinctrl@302c0000: enet1phyinterruptgrp: 'fsl,phy' does not match any of the regexes: 'pinctrl-[0-9]+'

Fixes: f496e6750083 ("ARM: dts: Add ZII support for ZII i.MX7 RMU2 board")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx7d-zii-rmu2.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx7d-zii-rmu2.dts b/arch/arm/boot/dts/imx7d-zii-rmu2.dts
index 2b8d6cc45a538..7d9209cd4c316 100644
--- a/arch/arm/boot/dts/imx7d-zii-rmu2.dts
+++ b/arch/arm/boot/dts/imx7d-zii-rmu2.dts
@@ -350,7 +350,7 @@ MX7D_PAD_SD3_RESET_B__SD3_RESET_B	0x59
 
 &iomuxc_lpsr {
 	pinctrl_enet1_phy_interrupt: enet1phyinterruptgrp {
-		fsl,phy = <
+		fsl,pins = <
 			MX7D_PAD_LPSR_GPIO1_IO02__GPIO1_IO2	0x08
 		>;
 	};
-- 
2.43.0




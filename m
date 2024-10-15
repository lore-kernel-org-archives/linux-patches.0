Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C921C07C2;
	Tue, 15 Oct 2024 13:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997200; cv=none; b=i7da4HZ8ZKLx3p01EsB+NLAoudbOORg+lmH13b+G1047AStwCLAiV6IRVKjD38oxCsSjl/YkkMGRepvI8qW5++C42M3T0m1gxZxzZ55zzSzxovGGn7GYHxEcIt5aMLI3Yze3yd1oLULwYDQ9rtboOtLhE564r7BPpIH4v/B5SsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997200; c=relaxed/simple;
	bh=qZvOIRpBP/uL+kbNa64YCWpGNQXXeutrXpUoR5IebBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fR60davWqkucnRZxQHT0OSiQNon1UT1iGIzh8Lr5xktxhi8APSyvUAlFJbEYKzr0sTBC6exlTZIbJ7hQghmMlNegJV14mPysgRuORCUHgJ9CIv27G+VjXK9rJ8FJ9RN+ayiW4smvYJgbI1xuTtP+OM10JftOiske2d5IHkeclOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t9U9Q2kY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t9U9Q2kY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16C01C4CEC6;
	Tue, 15 Oct 2024 12:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997200;
	bh=qZvOIRpBP/uL+kbNa64YCWpGNQXXeutrXpUoR5IebBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t9U9Q2kYmYDPkDZJlrHgHj5B5bi0jfx9aqFGiezSOIzy9NtigZzbv8nsJknOnUCOn
	 PTc94+DRabi8ZpkHffV/Uuo+7pJk72ihTTq7IwfoyGxiax4LUvoLx9N4+yzTnNBv1M
	 f2yG4eS+GZHY9qRJVgMrhVK6fGmGfXBIQRUpsFd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 098/518] ARM: dts: imx7d-zii-rmu2: fix Ethernet PHY pinctrl property
Date: Tue, 15 Oct 2024 14:40:02 +0200
Message-ID: <20241015123920.784121040@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 1065941807e83..ce59342e55aae 100644
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




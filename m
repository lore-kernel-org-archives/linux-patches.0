Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79EF81E907D;
	Tue, 15 Oct 2024 11:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992671; cv=none; b=DJwdLqsKB8aizrPPMwbL9M5zAPPyT4/eRXFGehSqoPU1MiJzROuPT5vEmh0YQDzGLAoJDG1eo80UwkAGK/5Quc2mIpLMYuC3HKrb5SqXgvusMnswXwMA0b5aOLC4rbVja/CjlNFrfvrafVl9uEJ5NhPmcIG0zEejX2iN4E8+TX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992671; c=relaxed/simple;
	bh=eDImqEvNAH0jV1UlvKxQhJxRFi2H738nioGuMDXvYIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i5A9na/s0Xnp3CAl9CBZiFx8kYYNhFz2+nl3FVvQCtwj5d6iL9DrWJhq5JEHJctxgxjyL1/X1iAh5siFTU+EdAn1kCGu0VwR7+OEd80qmqTwjhEPYh8AwPiqM7VabPV3iP0rqfVFM9BPn4AdGVRjm7+Oj76kdANfKHHlZBtAA64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yKvi/ul9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yKvi/ul9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6722C4CEC6;
	Tue, 15 Oct 2024 11:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992671;
	bh=eDImqEvNAH0jV1UlvKxQhJxRFi2H738nioGuMDXvYIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yKvi/ul9uohNrCp6PDZx8jGL1frHdlATs/EzZUKecv4Rw8DGucKIqZ1Hfc5WvDPh3
	 IhdvtmklJiKw12t/jbxf3UGexA+4Ho5TanSp1sTsTN9DwIV+yE/F3YbOBNdJ+Tl8BR
	 XGW6XeyrVaOPT5W2MmnPvDC+8nMOnZkGIVNiLmzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 143/691] ARM: dts: imx7d-zii-rmu2: fix Ethernet PHY pinctrl property
Date: Tue, 15 Oct 2024 13:21:31 +0200
Message-ID: <20241015112446.031444109@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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




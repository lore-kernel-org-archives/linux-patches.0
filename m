Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0764515CAE
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:11:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81593C433C1;
	Tue,  8 Nov 2022 14:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916680;
	bh=l9Fe8KUK3hlZVif3KbAYDtaybQ70326y2nrODt5d3zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ri1ZiycvwlpMk/Y3/LfFtFB2i0s6+qATE9gQiCTSIGfjwgwgI7nHe7f/DyLiDx+9j
	 Urr63GIE5VzC/I3x913Ca3lFcUZvX9qwiMWiM+Fxbqm0/kY4eHrdu9kjFEUKfWtlgk
	 FGGh/Ec4wxPkVt8b0k71m9G2dtDk1goXR26Oqixw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Jun <jun.li@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 100/197] arm64: dts: imx8mn: remove otg1 power domain dependency on hsio
Date: Tue,  8 Nov 2022 14:38:58 +0100
Message-Id: <20221108133359.411628079@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Li Jun <jun.li@nxp.com>

[ Upstream commit 9e0bbb7a5218d856f1ccf8f1bf38c8869572b464 ]

pgc_otg1 is an independent power domain of hsio, it's for usb phy,
so remove hsio power domain from its node.

Fixes: 8b8ebec67360 ("arm64: dts: imx8mn: add GPC node")
Signed-off-by: Li Jun <jun.li@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mn.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mn.dtsi b/arch/arm64/boot/dts/freescale/imx8mn.dtsi
index cb2836bfbd95..950f432627fe 100644
--- a/arch/arm64/boot/dts/freescale/imx8mn.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mn.dtsi
@@ -662,7 +662,6 @@ pgc_hsiomix: power-domain@0 {
 					pgc_otg1: power-domain@1 {
 						#power-domain-cells = <0>;
 						reg = <IMX8MN_POWER_DOMAIN_OTG1>;
-						power-domains = <&pgc_hsiomix>;
 					};
 
 					pgc_gpumix: power-domain@2 {
-- 
2.35.1




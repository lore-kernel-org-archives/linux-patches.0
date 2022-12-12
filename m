Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F147428ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:36:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24EE1C433EF;
	Mon, 12 Dec 2022 13:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670852197;
	bh=zACkU0W13o7qFnR/o1IHxmuRGO5fj0rTbw+zLCHYxAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v+JpawbnI9kDBITZfWxnRfpTG4VR6mBsktPEmYOUl33NRo3jXnm9UAiJhlan/R2D/
	 hHoLq0M/VYTzBknzU1IXg7KO2hn5g/ImCSD2+5hHR81a2vqIxbhILL99X2yQ6NhDih
	 dXewLoHU6dRqA89BCHEQb8R5+SXZ3LulR2ibf6u0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Furkan Kardame <f.kardame@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 005/157] arm64: dts: rockchip: remove i2c5 from rk3566-roc-pc
Date: Mon, 12 Dec 2022 14:15:53 +0100
Message-Id: <20221212130934.617576792@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Furkan Kardame <f.kardame@manjaro.org>

[ Upstream commit b44bc59d0d279fa4f3dc11b895f2c8f77719885d ]

i2c5 is owned by hdmi port

Signed-off-by: Furkan Kardame <f.kardame@manjaro.org>
Link: https://lore.kernel.org/r/20221010190142.18340-4-f.kardame@manjaro.org
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3566-roc-pc.dts | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3566-roc-pc.dts b/arch/arm64/boot/dts/rockchip/rk3566-roc-pc.dts
index b8ed215ab8fb..ab1abf0bb749 100644
--- a/arch/arm64/boot/dts/rockchip/rk3566-roc-pc.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3566-roc-pc.dts
@@ -401,10 +401,6 @@
 	status = "okay";
 };
 
-&i2c5 {
-	status = "okay";
-};
-
 &mdio1 {
 	rgmii_phy1: ethernet-phy@0 {
 		compatible = "ethernet-phy-ieee802.3-c22";
-- 
2.35.1




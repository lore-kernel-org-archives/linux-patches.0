Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50CAD168C9
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:06:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A75A4C433D2;
	Mon,  8 May 2023 11:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683543962;
	bh=sAbMWjNHDw8Wx8pEol48dJq5ycLoLpQjHLz8U2qGtqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n9BY6mAM91i4W2zRkYbce2gClY4onoyMijAy8W/bIuOg8actzJvY8sv5KFhMYxxaJ
	 krhtZRYHEC6CqVZU7bXNhvQpXp40xauEss6CqcJsC+HW36stQAMt62cjCEO5zNSBy0
	 5t/YCr/DCDYGcKjNje4/wF4gevcdNEhTLlMRQGWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 258/694] arm64: dts: rockchip: Assign PLL_PPLL clock rate to 1.1 GHz on rk3588s
Date: Mon,  8 May 2023 11:41:33 +0200
Message-Id: <20230508094440.666928116@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit b46a22dea7530cf530a45c6b84c03300083b813d ]

The clock rate for PLL_PPLL has been wrongly initialized to 100 MHz
instead of 1.1 GHz. Fix it.

Fixes: c9211fa2602b ("arm64: dts: rockchip: Add base DT for rk3588 SoC")
Reported-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Link: https://lore.kernel.org/r/20230402095054.384739-3-cristian.ciocaltea@collabora.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3588s.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3588s.dtsi b/arch/arm64/boot/dts/rockchip/rk3588s.dtsi
index a506948b5572b..f4eae4dde1751 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588s.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3588s.dtsi
@@ -423,7 +423,7 @@
 			<&cru ACLK_BUS_ROOT>, <&cru CLK_150M_SRC>,
 			<&cru CLK_GPU>;
 		assigned-clock-rates =
-			<100000000>, <786432000>,
+			<1100000000>, <786432000>,
 			<850000000>, <1188000000>,
 			<702000000>,
 			<400000000>, <500000000>,
-- 
2.39.2




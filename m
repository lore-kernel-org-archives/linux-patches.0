Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8CDC198837;
	Wed,  2 Oct 2024 14:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878184; cv=none; b=feh1kOUkWoUUCljnomPNW8FgKeJpdqJF4Ra5dhmKGcpJCsjvAfMn2SNBg9HAE73GcSQKbAiOzvh8bmA/1WU53f7HzeLpSnDzLHsdDZ3EHBWI+Ll5MqHAfwPC1tLfQYbk8OadSCXgH1t/84FjPDYhhqr4SgO+x6i4YrRCpQAOPPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878184; c=relaxed/simple;
	bh=dErPW5lXXBmWKmnHfEPAd7zGIBA3OQFrkzHvBkmtPdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RiJZgrNJDR5QiGTZB78G5XlAF7GDt80Wgrq+auaR8rZ3tSmm55m/dH93Ftjgdq7mZvUBcDqR3LhlzsHgbEfcYfOmrncsRjHr6BHSxwJCLTej5KUHr6KSoKapbRo5jsMsTp85YjMg38E4Ogb8HkXfaC6p7Hh5kXmbccwCYlE8KQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yh4u8dRT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yh4u8dRT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21646C4CEC2;
	Wed,  2 Oct 2024 14:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878184;
	bh=dErPW5lXXBmWKmnHfEPAd7zGIBA3OQFrkzHvBkmtPdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yh4u8dRTtnn3Ywpn2X+TA6Hcq7/B9w3kIATPuVoiRy9/2OIs0BkUm2ndZCQCHWNss
	 Uvwk4KuTqrmAcs/7ZHi40w/s1Z+aQfP2qvUN4XW26T2J5mBbanyaNuloS94DX1L5q4
	 zKKfGjojnvzK36qtnPZoK1gKIoAsYmIJH8bXa408=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Stuebner <heiko@sntech.de>,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 328/634] phy: phy-rockchip-samsung-hdptx: Explicitly include pm_runtime.h
Date: Wed,  2 Oct 2024 14:57:08 +0200
Message-ID: <20241002125824.051020123@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit 1b369ff94bc36d2e16c8a91c0ea8ebd329555976 ]

Driver makes use of helpers from pm_runtime.h, but relies on the header
file being implicitly included.

Explicitly pull the header in to avoid potential build failures in some
configurations.

Fixes: 553be2830c5f ("phy: rockchip: Add Samsung HDMI/eDP Combo PHY driver")
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Link: https://lore.kernel.org/r/20240620-rk3588-hdmiphy-clkprov-v2-1-6a2d2164e508@collabora.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c b/drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c
index 946c01210ac8c..3bd9b62b23dcc 100644
--- a/drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c
+++ b/drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c
@@ -15,6 +15,7 @@
 #include <linux/of_platform.h>
 #include <linux/phy/phy.h>
 #include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
 #include <linux/rational.h>
 #include <linux/regmap.h>
 #include <linux/reset.h>
-- 
2.43.0




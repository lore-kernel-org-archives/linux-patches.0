Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E8D18DF60;
	Wed,  2 Oct 2024 13:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876290; cv=none; b=JurOxpY4bkgGnze/PV7xe55JWtYy4+JsP4/rM3IiUMkTSYKpZtS5ADygOEyRzjhwflE0z8BmgEzcYCWafaY6SeNE1162HJFfndwjgGIIWatO+I0+RjzcteqMMyM2rv9iSya9lAXnTjOoHaV6Aa5+xowe6N6xPaTEWT/+h1aLyjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876290; c=relaxed/simple;
	bh=5GMv1IsqzlkqRIzqo0U25YnqCgcDJn7LCBxNhK2WImQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sXjFQOR4MZFNg0mEkhB2T0gIbeUG/yRnLeONhQG8d6++tOesdb9oBvriCkWW4knbjDNuwc89I2SOEKHFzOYmzxlPk1e1J2l8XRqfCWg+QVeA9UzWfjYJvtQF0rmRSgCUxw93C7PAZi0KrfH5eY57ztN4PfkU6cTDDRPElxm/BNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XwjoNmVD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XwjoNmVD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E22EC4CECE;
	Wed,  2 Oct 2024 13:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876289;
	bh=5GMv1IsqzlkqRIzqo0U25YnqCgcDJn7LCBxNhK2WImQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XwjoNmVD/plPmjKaIH2AsK/lLfTA9MCddJgqKT/IrOJ2meHvUzh8TckilhrbNmCNb
	 eMUfNwyPDyLMetskFZXYspyspGozcog8KJMCp8Qz+hAz7qMHIs+WsR6Fx5djZSxv1H
	 +5zNhH9d4QbjF7dGWZK6z3gx2qgimdx/4OYeqBnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Stuebner <heiko@sntech.de>,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 362/695] phy: phy-rockchip-samsung-hdptx: Explicitly include pm_runtime.h
Date: Wed,  2 Oct 2024 14:56:00 +0200
Message-ID: <20241002125836.895801988@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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




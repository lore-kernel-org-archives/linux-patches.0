Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039795;
	b=gdl/ImYkW40SW3dHmFQfy+svMhYObwKdK4hr90OUH68WMyiIE03wWOSzvOZH1eWRO78a
	 yFrnrOZbIr2KrRa9SHxegyB/mgOI6Lxb709nDayvrIeMA7MkuP7I76DRueBxzsHkcNbiF
	 IKi1dZ2ovWDQfT5edNEcDsxZiKYFxRKhaRfm1MaRFj9Wr+ATXEGbyykOSBxumf5OLFUBm
	 EJ4rmYtjVcEmXwjDNteXZu/jPSW8eBG9+kx3Wu+gcIBkqtAA2jV/eNJOqpqSmNsZvDgeB
	 m2OCVQ4fSmRDFCUC++Zi4tE62sQvnhdF9rNWbFK3sEunhRb+BPU5fZG/hhrzq9VRl0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039795;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QhbRK8+8lAWwCCPZ4hmMg/IKPIv0VJuSOiOd7lPmDEI=;
	b=qLh6kHMipFY9nInE4MiOhZ9QnRBymT6fBtkKUiFs6j5H94xlvu4ge791wuMVQX0mSPaU
	 PkFpbKHWyXfiGnVcYbZvMCEUjhLhRXz93FzuCEJ/HBjs98ta1+YpnHIsRSOrUGnAyfUtt
	 bqRuiKFrWdGKpjB0bCdAQpqOgnqvBgztHmYpWfiquqotPwEJ0l2pfB2Q7T7pfRF+9RxZg
	 1xqEZ+EVU9ONGo63bWsFXm+J5my2on4D/LpSPQ9zS3FJ+G2F75yoa50WBDoaoe165plNW
	 z3jTb8GGpu3B/htzVkSiHfiTIJjt+Q5qwaw8+N9dnCiyGIuWm5hqoKGmY4AyD5VjcmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U9Uw9Cvc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D12606A320;
	Wed, 18 Nov 2026 22:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U9Uw9Cvc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 173F31F000C4;
	Wed, 18 Nov 2026 22:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039795;
	bh=QhbRK8+8lAWwCCPZ4hmMg/IKPIv0VJuSOiOd7lPmDEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U9Uw9Cvc+y53w2Nt8fmvSaCkPHXsdbgAJPXaVsd/+QOmmUv0R2cxYrNhmbhQiTHg5
	 tRBLXNg4fBmte8fyYlzB0G4d/f1QAZBxKjRjmgMw/7sB8UUWkfbVm5r5x7yZV6qs7j
	 rGlJ2OiXz6fYZF6KfrAtAr9PqpdLnJBLVt5XdFiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fei Shao <fshao@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2187/3318] clk: mediatek: reset: Return regmaps error code
Date: Wed, 18 Nov 2026 15:46:49 +0100
Message-ID: <20261118150427.568455575@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fei Shao <fshao@chromium.org>

[ Upstream commit ae8ca031f590dc2c33f0f0286034d34e629099ce ]

device_node_to_regmap() can return different errors, and it's better
practice to pass them to callers.

Clean up the hardcoded -EINVAL and use PTR_ERR(regmap) instead.

Signed-off-by: Fei Shao <fshao@chromium.org>
Link: https://lore.kernel.org/r/20240717115919.975474-1-fshao@chromium.org
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Stable-dep-of: 8d5fa37307ac ("clk: mediatek: reset: Fix device registration kernel-doc")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mediatek/reset.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/mediatek/reset.c b/drivers/clk/mediatek/reset.c
index 290ceda84ce47..f8c0fd0315129 100644
--- a/drivers/clk/mediatek/reset.c
+++ b/drivers/clk/mediatek/reset.c
@@ -138,7 +138,7 @@ int mtk_register_reset_controller(struct device_node *np,
 	regmap = device_node_to_regmap(np);
 	if (IS_ERR(regmap)) {
 		pr_err("Cannot find regmap for %pOF: %pe\n", np, regmap);
-		return -EINVAL;
+		return PTR_ERR(regmap);
 	}
 
 	data = kzalloc(sizeof(*data), GFP_KERNEL);
@@ -198,7 +198,7 @@ int mtk_register_reset_controller_with_dev(struct device *dev,
 	regmap = device_node_to_regmap(np);
 	if (IS_ERR(regmap)) {
 		dev_err(dev, "Cannot find regmap %pe\n", regmap);
-		return -EINVAL;
+		return PTR_ERR(regmap);
 	}
 
 	data = devm_kzalloc(dev, sizeof(*data), GFP_KERNEL);
-- 
2.53.0




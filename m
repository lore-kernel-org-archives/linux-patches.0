Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829401;
	b=IdyBFhSkk4lqnwbW0zn1Qr048HPFv1eJK8T0+gji58faVbsA8uxouVV4KRkftKXV9PeE
	 PCrc1O35cJ+mf5PMnm8sjMmkzFyQUWkJyBe/e7FrrimTOHAz8eHN41FAswHIxu41MI5hP
	 helNoXusSQzTdLv3IExYWK80k6b3tc8cnS+diQTOgu2RUyqs8hAnmAIGiiSYbqc1wz9Mh
	 sIf8hFUJFTZCeKl6WtPg0y+q//+vuh3hbr+0DVgZWltxthiZTVovXgmVZuK7icUYpOVPG
	 Dgqr0aK3/9e/OaDpMlWZXUSDJ7/mmI0KSprVNXRaS+/Ha+qfjFfbk1U0g/AHCezMcjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829401;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V9OESGtWin4fN8Y+BxCzEdKp6RgsMkHCGnd6NQWsZYU=;
	b=HXu5TP5ZmHuCAw6s6gR04bCPK0+8TmHJuvhip6Tou4Zzn8MjBQjHX3zXaxvP60m5a7Ih
	 aZ4XQCuFZLEDCZvVNQFc5jcH5EeNhPSST3bNZOmVQexKgZyclBSFgqwIErjlOTJIdKD/u
	 rgWf7vl0jwUADNe2j830H3yQpuXagErT3OjrcD1JudbNVj7vSZBPh7ABLM459IfEagQ3w
	 D2niqXbhh9nFBzqfBnogglmoq6M9yFJ+ADbLaNeeEssaeCMOhoaZf9a/sknJtOjyV5o1l
	 iaqv57d5QOW9yyMJ8ubIf0eJbz/W4IG51yvo4l/WT7SY8AsSDPTDrPYoGvNrnnUmjLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xolgyVxE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA9C60C29A0;
	Wed,  4 Nov 2026 21:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xolgyVxE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E31531F00A16;
	Wed,  4 Nov 2026 21:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829401;
	bh=V9OESGtWin4fN8Y+BxCzEdKp6RgsMkHCGnd6NQWsZYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xolgyVxEmz37VkXafi1Er68QJ6/4DufKZ8ONCRvt53zlLyke7Sg/RzbK+bPK2dES3
	 iJqNnjaZl7tk9SrgQ0jEKAAf2S7pI3GuMi7+VmzmkdKiEIH31yiEMnnS3cdd2avJyo
	 346Kda/LDrw1SaTr6tSWxsAfDUBXosbcaTKLDth4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Chen-Yu Tsai <wens@kernel.org>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0104/1005] clk: sunxi-ng: fix ccu probe clock unregister on error
Date: Wed,  4 Nov 2026 15:57:17 -0500
Message-ID: <20261104211046.563255154@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit 81f4ddc9f7e0c11d3e9d24d0f30023845a02f7ee ]

When registering clocks with sunxi_ccu_probe(), the number of ccu_clocks
and the number of hw clocks might be different, eventhough they usually are
the same.

If they are different, it could lead to out-of-bound access or registered
clock left behind on error.

Use a different variable when iterating on hw clocks so every registered
clock, and only those, gets unregistered on error.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/r/20260629131254.7E34C1F00A3A@smtp.kernel.org
Reviewed-by: Chen-Yu Tsai <wens@kernel.org>
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Link: https://patch.msgid.link/20260706-a733-rtc-v4-3-f330728db3d3@baylibre.com
Signed-off-by: Chen-Yu Tsai <wens@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/sunxi-ng/ccu_common.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/clk/sunxi-ng/ccu_common.c b/drivers/clk/sunxi-ng/ccu_common.c
index c7e00f0c29a55..bbda75c2bc461 100644
--- a/drivers/clk/sunxi-ng/ccu_common.c
+++ b/drivers/clk/sunxi-ng/ccu_common.c
@@ -114,7 +114,7 @@ static int sunxi_ccu_probe(struct sunxi_ccu *ccu, struct device *dev,
 			   const struct sunxi_ccu_desc *desc)
 {
 	struct ccu_reset *reset;
-	int i, ret;
+	int i, j, ret;
 
 	ccu->desc = desc;
 
@@ -130,8 +130,8 @@ static int sunxi_ccu_probe(struct sunxi_ccu *ccu, struct device *dev,
 		cclk->lock = &ccu->lock;
 	}
 
-	for (i = 0; i < desc->hw_clks->num ; i++) {
-		struct clk_hw *hw = desc->hw_clks->hws[i];
+	for (j = 0; j < desc->hw_clks->num ; j++) {
+		struct clk_hw *hw = desc->hw_clks->hws[j];
 		const char *name;
 
 		if (!hw)
@@ -143,7 +143,7 @@ static int sunxi_ccu_probe(struct sunxi_ccu *ccu, struct device *dev,
 		else
 			ret = of_clk_hw_register(node, hw);
 		if (ret) {
-			pr_err("Couldn't register clock %d - %s\n", i, name);
+			pr_err("Couldn't register clock %d - %s\n", j, name);
 			goto err_clk_unreg;
 		}
 	}
@@ -186,8 +186,8 @@ static int sunxi_ccu_probe(struct sunxi_ccu *ccu, struct device *dev,
 err_del_provider:
 	of_clk_del_provider(node);
 err_clk_unreg:
-	while (--i >= 0) {
-		struct clk_hw *hw = desc->hw_clks->hws[i];
+	while (--j >= 0) {
+		struct clk_hw *hw = desc->hw_clks->hws[j];
 
 		if (!hw)
 			continue;
-- 
2.53.0




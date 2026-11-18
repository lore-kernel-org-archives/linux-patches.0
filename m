Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051017;
	b=G2Co47+R/BHzKsF5OgfodCplBuf7gP/KzPvsg0EasSq6Z6Gx/E4FxFTAtuGqLqDhs6b/
	 MwzJQtaUuuhDAy1WerdOi3z9zZ3ELRwE+d+WaGBhai+wHtZirfWqJwSaxWGFKcgbtp7na
	 o8/WR86VM4166k6ok1OX0YAma/IxiwUnJTxOmpSYNm7qajFwzKG/Wtal58RbsNFbuOgdR
	 jAkAqdimPAjlU0etQQCCC6X0/43/g9E+dFeEf3utieR+Dqc9HtyDGT//A4VnINE35TVeC
	 9dW1c4HouhD2dHDfoZ0AtYiKaOi0vT7YLkxq/OCFQYapzU43zRC4eP1K+A5xc73kf+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051017;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XWRYClXn22gWX5TbUndNhevPfIaOYc1FNM50KCftEfc=;
	b=pqhYqFmnhwmASAmTWEd8yi+qGd9wXG0Ph6vlzEls0vM3akBY2MfRveLGlXb3+KUHxmRS
	 CO7YuihAQf7YYiOT+1adaMFRZd3PJHIiJJRJK1pEn2/Xvo23jujKkUxNaT4xZF/Rgcn9n
	 sy1U9aGgGQhSg7fAA6nxtuM8dWEaeprNIG43muf8Cr4D8nXQf0kTLo73zZvQV8ZzAItlg
	 BYKPE/0dR34cV9ZGOVeWSHZhtB48hfwzr4qtNRrk2X9rQMaMsoVGsxFMwaIxHsxVD9tzW
	 l0nBzoOnQcJJYGMku/5dhrAoC+3nY29yN9ylxQ9LIub2K/mEgKGQAV6QzLQ0OKO/v+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k5REF40G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B7A1606A32C;
	Thu, 19 Nov 2026 01:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k5REF40G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 826961F000C4;
	Thu, 19 Nov 2026 01:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051017;
	bh=XWRYClXn22gWX5TbUndNhevPfIaOYc1FNM50KCftEfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k5REF40GSNQbTZEn3tnfn5L45bPEuWC14Pl7l/FsYXiw9lrqkSBR8ofPsvulkA6fk
	 xvkUG/JyD5eMomIbGzeId4KGV0q28Ut+FJ5F+dS5YLpDarxCNDZY/2hDh/EEG9zOGU
	 TP0G1uy7yHq+nZtyJ3dG+xU9RO+TDMKhYQWGT8Jo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Chen-Yu Tsai <wens@kernel.org>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0059/2214] clk: sunxi-ng: fix ccu probe clock unregister on error
Date: Wed, 18 Nov 2026 15:28:55 +0100
Message-ID: <20261118150012.383527645@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 88cb569e58358..45e106db1fef9 100644
--- a/drivers/clk/sunxi-ng/ccu_common.c
+++ b/drivers/clk/sunxi-ng/ccu_common.c
@@ -90,7 +90,7 @@ static int sunxi_ccu_probe(struct sunxi_ccu *ccu, struct device *dev,
 			   const struct sunxi_ccu_desc *desc)
 {
 	struct ccu_reset *reset;
-	int i, ret;
+	int i, j, ret;
 
 	ccu->desc = desc;
 
@@ -104,8 +104,8 @@ static int sunxi_ccu_probe(struct sunxi_ccu *ccu, struct device *dev,
 		cclk->lock = &ccu_lock;
 	}
 
-	for (i = 0; i < desc->hw_clks->num ; i++) {
-		struct clk_hw *hw = desc->hw_clks->hws[i];
+	for (j = 0; j < desc->hw_clks->num ; j++) {
+		struct clk_hw *hw = desc->hw_clks->hws[j];
 		const char *name;
 
 		if (!hw)
@@ -117,7 +117,7 @@ static int sunxi_ccu_probe(struct sunxi_ccu *ccu, struct device *dev,
 		else
 			ret = of_clk_hw_register(node, hw);
 		if (ret) {
-			pr_err("Couldn't register clock %d - %s\n", i, name);
+			pr_err("Couldn't register clock %d - %s\n", j, name);
 			goto err_clk_unreg;
 		}
 	}
@@ -145,8 +145,8 @@ static int sunxi_ccu_probe(struct sunxi_ccu *ccu, struct device *dev,
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




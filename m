Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057323;
	b=z5xP69H+rZFdNOz0VNGocm0yuG7nAnhYkc53xWFpLWJgjQyQ4sqgE8jEKrrVIOL6SaSx
	 IZegKWxv3PhfzDlZ+CmGiPG9atvcLsvg94Xj+VfMvvuYsPcj3JHWiG7m0oHI24G9CtTJF
	 chpYDfN0/t05HpBwmvU8CBVm3Z8EpkpokxJwE8xDddE6OjDSVWp+AHX0MYANwZecB4Utq
	 EkUExDitKatDkAw7jU7+W0B6vlgessvfEKLajeLwafusv8Zq12ngpjC8ADHDYM7gnteoL
	 uEKJQg1WyqvibtbxA+jvYPGuAVPoco3jSBQZL9AuQqU0xOaH6CjXl+vFD7xpACXb7rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057323;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xJOqQMQBPwRCa4TROqi8LW/WXPT4Bg1kJxGj6J5kKAk=;
	b=oksMj0lDsMJSq9jFx8jwFNEvZLcJFK7CbshCp67Q7FuMWwkWczEFACPyqAqLsuBeKrUr
	 QdBkUVWm/HykdTl7yOgoCwTx4THZ2RKLCipBdF+/iNrBgZ9kTuWmHI9jzXz2keiNLS7zq
	 J6M41G5ez3ci0Qf2VVdze4F8WbKjEWXwyFI6pi0iUdtium+hQx8U2ussLusWwhpt33RcY
	 O0So81qnQx0MHqt8blUOVbUSpSMXQ5dX15Ti5jOHfZvlFgfQJVRokWwjOyJ7mfd83Nctc
	 lPjg8YGiAYMCtl6aA4gDS23/W0Dw5ciavuZh/VB2SH+G14YNAm3OI+iDDMuilnTXigA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GDL+Khom;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F13460A3803;
	Thu, 19 Nov 2026 03:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GDL+Khom
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E12471F000C5;
	Thu, 19 Nov 2026 03:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057323;
	bh=xJOqQMQBPwRCa4TROqi8LW/WXPT4Bg1kJxGj6J5kKAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GDL+KhomOV5ZtFl0uO+MUYC+Zuvc6hXJsIp8J+w0R3kqMkfbZg6aofdE3FsSMmhZP
	 LCuhM6Jbq+FiJLWknIU5XQlmKK5yAM5Zkx0vu/3fBKzzG7IQ8mBNsUE93sLtNyWcnp
	 iwcihDmYTCE+M/NA7gAULrgFhiKndXE9YmBSD5Jc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Chen-Yu Tsai <wens@kernel.org>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0053/1848] clk: sunxi-ng: fix ccu probe clock unregister on error
Date: Wed, 18 Nov 2026 15:34:51 +0100
Message-ID: <20261118145913.331356575@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 2e20e650b6c01..9df98d99752c8 100644
--- a/drivers/clk/sunxi-ng/ccu_common.c
+++ b/drivers/clk/sunxi-ng/ccu_common.c
@@ -83,7 +83,7 @@ int sunxi_ccu_probe(struct device_node *node, void __iomem *reg,
 		    const struct sunxi_ccu_desc *desc)
 {
 	struct ccu_reset *reset;
-	int i, ret;
+	int i, j, ret;
 
 	for (i = 0; i < desc->num_ccu_clks; i++) {
 		struct ccu_common *cclk = desc->ccu_clks[i];
@@ -95,8 +95,8 @@ int sunxi_ccu_probe(struct device_node *node, void __iomem *reg,
 		cclk->lock = &ccu_lock;
 	}
 
-	for (i = 0; i < desc->hw_clks->num ; i++) {
-		struct clk_hw *hw = desc->hw_clks->hws[i];
+	for (j = 0; j < desc->hw_clks->num ; j++) {
+		struct clk_hw *hw = desc->hw_clks->hws[j];
 		const char *name;
 
 		if (!hw)
@@ -105,7 +105,7 @@ int sunxi_ccu_probe(struct device_node *node, void __iomem *reg,
 		name = hw->init->name;
 		ret = of_clk_hw_register(node, hw);
 		if (ret) {
-			pr_err("Couldn't register clock %d - %s\n", i, name);
+			pr_err("Couldn't register clock %d - %s\n", j, name);
 			goto err_clk_unreg;
 		}
 	}
@@ -140,8 +140,8 @@ int sunxi_ccu_probe(struct device_node *node, void __iomem *reg,
 err_alloc_reset:
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




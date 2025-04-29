Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3EED24A067;
	Tue, 29 Apr 2025 17:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946207; cv=none; b=CKdOli8e7UIUr9ljNS6EGYJ3stmbXzVUUWVoJ9gr9Ipa5s9NnfztKdUP0yvzSNPPzZPBEPcQzfIHz6gw+z4YgbtwNOCwYhV68H8zvB0BScsAZCNOfkJ8N5N+lBIlRdgNVHb0izhvVmFu8g7FWGwYU7aYJqsKJnHi++Jjk8HDU0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946207; c=relaxed/simple;
	bh=JVN7dS7oaKfxtIieQu5OtUvF0F4Jbfa5B4rq2vQFwN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IAqRhSHttFrHZLraokL5CmXRbWEux/oXxc6E7MXPWNKkUhKy6EjR6Ve9PTyYY72k3EM+D5qKo+uzxyAUZfrtzA8objEjPtMAsdFGv95cXrlRBHyHMWAHNBHy7G1OyzhDpNWgH+icoi21ABprO+WvkkbnrBvdisWWMsq444vvBug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hLtCSwJe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hLtCSwJe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 474C3C4CEE3;
	Tue, 29 Apr 2025 17:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946206;
	bh=JVN7dS7oaKfxtIieQu5OtUvF0F4Jbfa5B4rq2vQFwN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hLtCSwJeai70D/P8BHrqikk6YQ+n4/L1GRGackDFFUlZ+UYUJ2f3YqJRxnr45r+Er
	 8EQN+k8zhJWQ+Pr4qwLYxCcBi3tAIJPNJodMCNX65mxnn/r0Wv6fXVUVK8EW/MXZ4f
	 cQL+zsUIL5Mz5cTJB4yODX9AeasMYxjRORkOmdy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 191/311] clk: renesas: rzv2h: Adjust for CPG_BUS_m_MSTOP starting from m = 1
Date: Tue, 29 Apr 2025 18:40:28 +0200
Message-ID: <20250429161128.838465125@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit 69ac2acd209a15bd7a61a15c9532a5b505252e1c ]

Avoid using the "- 1" for finding mstop_index in all functions accessing
priv->mstop_count, by adjusting its pointer in rzv2h_cpg_probe().

While at it, drop the intermediate local variable index.

Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
Closes: https://lore.kernel.org/all/CAMuHMdX1gPNCFddg_DyK7Bv0BeFLOLi=5eteT_HhMH=Ph2wVvA@mail.gmail.com/
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/20250222142009.41324-1-biju.das.jz@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/rzv2h-cpg.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/clk/renesas/rzv2h-cpg.c b/drivers/clk/renesas/rzv2h-cpg.c
index a4c1e92e1fd76..4e81a0bae0228 100644
--- a/drivers/clk/renesas/rzv2h-cpg.c
+++ b/drivers/clk/renesas/rzv2h-cpg.c
@@ -447,8 +447,7 @@ static void rzv2h_mod_clock_mstop_enable(struct rzv2h_cpg_priv *priv,
 {
 	unsigned long mstop_mask = FIELD_GET(BUS_MSTOP_BITS_MASK, mstop_data);
 	u16 mstop_index = FIELD_GET(BUS_MSTOP_IDX_MASK, mstop_data);
-	unsigned int index = (mstop_index - 1) * 16;
-	atomic_t *mstop = &priv->mstop_count[index];
+	atomic_t *mstop = &priv->mstop_count[mstop_index * 16];
 	unsigned long flags;
 	unsigned int i;
 	u32 val = 0;
@@ -469,8 +468,7 @@ static void rzv2h_mod_clock_mstop_disable(struct rzv2h_cpg_priv *priv,
 {
 	unsigned long mstop_mask = FIELD_GET(BUS_MSTOP_BITS_MASK, mstop_data);
 	u16 mstop_index = FIELD_GET(BUS_MSTOP_IDX_MASK, mstop_data);
-	unsigned int index = (mstop_index - 1) * 16;
-	atomic_t *mstop = &priv->mstop_count[index];
+	atomic_t *mstop = &priv->mstop_count[mstop_index * 16];
 	unsigned long flags;
 	unsigned int i;
 	u32 val = 0;
@@ -630,8 +628,7 @@ rzv2h_cpg_register_mod_clk(const struct rzv2h_mod_clk *mod,
 	} else if (clock->mstop_data != BUS_MSTOP_NONE && mod->critical) {
 		unsigned long mstop_mask = FIELD_GET(BUS_MSTOP_BITS_MASK, clock->mstop_data);
 		u16 mstop_index = FIELD_GET(BUS_MSTOP_IDX_MASK, clock->mstop_data);
-		unsigned int index = (mstop_index - 1) * 16;
-		atomic_t *mstop = &priv->mstop_count[index];
+		atomic_t *mstop = &priv->mstop_count[mstop_index * 16];
 		unsigned long flags;
 		unsigned int i;
 		u32 val = 0;
@@ -926,6 +923,9 @@ static int __init rzv2h_cpg_probe(struct platform_device *pdev)
 	if (!priv->mstop_count)
 		return -ENOMEM;
 
+	/* Adjust for CPG_BUS_m_MSTOP starting from m = 1 */
+	priv->mstop_count -= 16;
+
 	priv->resets = devm_kmemdup(dev, info->resets, sizeof(*info->resets) *
 				    info->num_resets, GFP_KERNEL);
 	if (!priv->resets)
-- 
2.39.5




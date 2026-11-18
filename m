Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043064;
	b=TyoJKvBOd2/7nN1VW9x1LYELLqhd6Gx+DsRAGTZTpQAoAjy1TytnuodszEvWCR/7ysNd
	 RcVWQH4+E50bdKY0K8oRSeT79RqwkV4H3bGE2sDN1Gjx2XFmRrc/GQQ7h07aKTWA1tCPr
	 OVMwamP1LPFblkkfS12cIqBHcy0AWX0zVXP/Qna4zkr1ailtobgev7qFXuUN8p7CNcbkf
	 gRyi9ZqMsCqmB8BSfHE4G3zhJNn5Z/ANOcb4Yu8rCd+cj1507t+rmb8haLa03L1iQ7f3m
	 Kw8BsN4dI4Uot5ojT6mHVfDi68uC/CRbM5SOpI+7Uv8Hs97LYdD22NcdhFeJkcv9bzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043064;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MRBWPiGdDPIIcnd5IskQCUdVUNRbSlabbGw5lhy0PKA=;
	b=3x1iWjwZraB59tJa1TrA6CYKfd28Z1NcUCNyLktvxQEN4PpjzQdNoAObmQsZuxy1gGGS
	 D09zEKWHae5iWNV06z/x/uCjhMMQrcw/dstotXbdbBipQYhApysMP/3S/NKFVdpSpA1pY
	 b97bQFJqvv47agVwnQeVEsl3khuFoXeMCPwOKj87H80vV0NHGywxqwMG66M8fYP4KjGoY
	 3YkTmdI8Sud94dV8Tarq6CKbwF+UJpVHYNR7S73wGRDBk4HOoqFfNhQ7SqjD981zDhgh4
	 6bYPHD6SsDRAIBdj7jtwf+U8OUszASgYSEfGsFEtSNwkPP+Y2tzIAbRIIONi0AeRsBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HgQ4VRLd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88234606A31C;
	Wed, 18 Nov 2026 23:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HgQ4VRLd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E9DC1F000C4;
	Wed, 18 Nov 2026 23:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043064;
	bh=MRBWPiGdDPIIcnd5IskQCUdVUNRbSlabbGw5lhy0PKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HgQ4VRLdZ1UziO6X3cyLzLHfFRED8RFSf9rw1adXI0eg/it7dDvp6O843uWozTcFM
	 d3TKMwUpraRtOswSya5denedDu30wWN6sSiaJljT9894iHVK3QgUdXtl8L6J1LAyI4
	 38yu3r+n1XRInV3jtrbijcCyyl5ybMsmX4fFoZas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Chen-Yu Tsai <wens@kernel.org>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0060/2857] clk: sunxi-ng: fix ccu probe clock unregister on error
Date: Wed, 18 Nov 2026 15:18:14 +0100
Message-ID: <20261118150203.464861846@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8d28a7a079d09..03ebbc0c926a4 100644
--- a/drivers/clk/sunxi-ng/ccu_common.c
+++ b/drivers/clk/sunxi-ng/ccu_common.c
@@ -92,7 +92,7 @@ static int sunxi_ccu_probe(struct sunxi_ccu *ccu, struct device *dev,
 			   const struct sunxi_ccu_desc *desc)
 {
 	struct ccu_reset *reset;
-	int i, ret;
+	int i, j, ret;
 
 	ccu->desc = desc;
 
@@ -108,8 +108,8 @@ static int sunxi_ccu_probe(struct sunxi_ccu *ccu, struct device *dev,
 		cclk->lock = &ccu->lock;
 	}
 
-	for (i = 0; i < desc->hw_clks->num ; i++) {
-		struct clk_hw *hw = desc->hw_clks->hws[i];
+	for (j = 0; j < desc->hw_clks->num ; j++) {
+		struct clk_hw *hw = desc->hw_clks->hws[j];
 		const char *name;
 
 		if (!hw)
@@ -121,7 +121,7 @@ static int sunxi_ccu_probe(struct sunxi_ccu *ccu, struct device *dev,
 		else
 			ret = of_clk_hw_register(node, hw);
 		if (ret) {
-			pr_err("Couldn't register clock %d - %s\n", i, name);
+			pr_err("Couldn't register clock %d - %s\n", j, name);
 			goto err_clk_unreg;
 		}
 	}
@@ -149,8 +149,8 @@ static int sunxi_ccu_probe(struct sunxi_ccu *ccu, struct device *dev,
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




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060648;
	b=fb5YvEIAc2kksCr55BLY3wNOfBPVDuqkgZzRx3e9EI40tMJ1PqKdH78itmxgXb+Tn8gY
	 A8BqG0rBeDkk2IOdc9k5w1HxZIzp2odIEFCGHzjsTr7p331vvisx8A36JmlYhTAzrXu/6
	 lFRxH9sMsOdTFh7LKJD38cGUgd56FD7z15kBAkdE0Z9neLeIB6wLAiXDMYRXRd3eOomx8
	 gnxUG/XEgis3AozRPGEhJVgmHx/EellyMrm0a2fSlrKoomLIzpvnuRXln8ljc8jLzmbuq
	 iOhd8yWp94o6JT6kfb+n0M4u4yOVF+BWbPuab8xK9Qkrb+AEDY0V0WVJ611Y3nJh7dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060648;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FyJXZ83girQtQUJra3HBhL5vqm9hfKQI+jDDNjV4lCY=;
	b=3QrxjbFhio5/P6Dgh6eah/v09B46Q+UNZvKjMzKPFh+uMrG0X/guGyt3+/qFvzv+PUrN
	 w3U6tIbN8Zh7M83KvQ3YWa95c6eEKrBfryYk4z4tR0FKOq3NcUxvu1lsivI2yJgWLrVtj
	 j9sqj7x539+rdEBddmMsB+mSEzIHtokhb03DwcgyYN6TpWmsRe6bHyexQ/Kh6dKWCT3MY
	 +0kGY+8cJxeSjc1FEwkOKulZzDCVnUqaU0Iblu8sNmjQYBBeyZQ4lFPJtPgTldP6BrabB
	 OlfCcNgX97iEMbv+aIxE2tLRe769+ezDIiITY9AahhZweJpPsHQB7gkeUcEoLMGvi1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CwlYevW5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B769E606A326;
	Sat,  7 Nov 2026 14:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CwlYevW5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E2D61F0089F;
	Sat,  7 Nov 2026 14:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060647;
	bh=FyJXZ83girQtQUJra3HBhL5vqm9hfKQI+jDDNjV4lCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CwlYevW565CfaPlUj1VT1rasGOSEBfSJ+rBJLTRC4rt4fflYejV6SyfpsYx/byQP+
	 cta3GfQEXIegji1V1dbqA7IN1BHLmgBZ6CpbQHm2MwmLXxZ4QgPwI4FXSnMhGiSZzK
	 V7H8dG4VkF5RS3wuptUO6uPlkN1Qf9k95lSskN24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Chen-Yu Tsai <wens@kernel.org>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0089/1536] clk: sunxi-ng: fix ccu probe clock unregister on error
Date: Sat,  7 Nov 2026 08:35:05 -0500
Message-ID: <20261107135000.167430340@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4117b0bea2671..390017abd6242 100644
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




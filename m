Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019987;
	b=T5mVfCdUjHNetX+vrenBvdA/iNgGeaM1YtqcjThnPf7jcKq5bX5q1PLfGYce9KYWWncY
	 eq2syUgJ4d7ikUt+jj4GehmgETOfDuKhMgRhdhVVU6MhVCD3yWERYr4FkwgjSA5ls9WGh
	 wHwJO+LowYIv7TPmT9h7PNvoDV1AkkRQIZ0otEc+I72frNnCOntOXAzKjOTPUx+y/8tzM
	 lFZa5UHwObPoZnX7IytdOP7/V0U/eLyxywxRKZUxW03w4md2XzNiAzNUf4NGvk0Z9fXsy
	 1Oa3U93o6xZdOobValWcsdknNXhVigphADHAd4iCbMVlm9CHffqVq2h/FQdpC8EmvlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019987;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RUKwwy6zITgLKcY8tNe0L7AeMbBX+Yqm21J8SdcGJJE=;
	b=GYx2soRF+5M9vKIyYq1w1F3q52nRwQXxEYz8TSR8NJuRWdC4nJrSt9oD5Ih81zCX2WKv
	 lWJfx6h83JnfJpuLRdpQvGE6+PWkMrCTVAXEuGNVnPDoqmWoHvXj2urhrUYcI/GgBqQa4
	 g4Y7NXwPPAWpRSskLQzxL+vZ8xObMQFdXpfzxuKkUh4RHpKJwq/wQhjhcegcz/+D3+1fA
	 GRoJkor3klOY3DE1EYN64ZlMUQSlz4XoIzQ0aFe2YzRUGSAi05FON/y7Y9S9QC6Wv0JDT
	 JPjmGisVn19NhvwWdK5nbzVHSKjR3xblNbGwYedF9csENsz1zjF3KewjkbCBI/zGYrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fzgPaN2F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D256C60A2614;
	Wed, 18 Nov 2026 16:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fzgPaN2F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F4761F000CD;
	Wed, 18 Nov 2026 16:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019987;
	bh=RUKwwy6zITgLKcY8tNe0L7AeMbBX+Yqm21J8SdcGJJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fzgPaN2FY84sE+adRufegPebW2k09pZeDImGCN7fcFYBKT0JM/71eoKg3pFlSClE3
	 FXs2/YJJzM6Stlxxfc/fwL2dVugUMvUf/iD/wGmsEx8XZckhy3tiDsclNidnLbbBUW
	 K8OBZbXq+5Yvc4K6uH0PLEYVkr6NSBoZpUToWdxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1750/2651] clk: qcom: rcg2: Initialize shared floor clock state
Date: Wed, 18 Nov 2026 15:49:50 +0100
Message-ID: <20261118150350.515205726@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit 72f34d429f6e51b0ef8c43ab7667c4fb4099dd46 ]

Shared floor RCGs use the cached parked_cfg whenever CCF considers the
clock disabled. Unlike the other shared RCG variants, their ops do not
initialize that cache, leaving it zeroed until the first disable or rate
change. This can make registration report an undivided XO configuration
instead of the boot-programmed parent and divider.

Initialize parked_cfg from CFG_REG without parking or otherwise changing
the hardware. Propagate read failures so a clock with unknown initial
state is not registered.

Fixes: aec8c0e28ce4 ("clk: qcom: rcg2: add clk_rcg2_shared_floor_ops")
Assisted-by: LLM
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://patch.msgid.link/20260917-topic-qc_clk_fixes-v1-1-5531cb00514b@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/clk-rcg2.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/clk/qcom/clk-rcg2.c b/drivers/clk/qcom/clk-rcg2.c
index d7914e59129f6..adb03c3aa0dc0 100644
--- a/drivers/clk/qcom/clk-rcg2.c
+++ b/drivers/clk/qcom/clk-rcg2.c
@@ -1555,7 +1555,20 @@ const struct clk_ops clk_rcg2_shared_ops = {
 };
 EXPORT_SYMBOL_GPL(clk_rcg2_shared_ops);
 
+static int clk_rcg2_shared_no_init_park(struct clk_hw *hw)
+{
+	struct clk_rcg2 *rcg = to_clk_rcg2(hw);
+
+	/*
+	 * Read the config register so that the parent is properly mapped at
+	 * registration time.
+	 */
+	return regmap_read(rcg->clkr.regmap, rcg->cmd_rcgr + CFG_REG,
+			   &rcg->parked_cfg);
+}
+
 const struct clk_ops clk_rcg2_shared_floor_ops = {
+	.init = clk_rcg2_shared_no_init_park,
 	.enable = clk_rcg2_shared_enable,
 	.disable = clk_rcg2_shared_disable,
 	.get_parent = clk_rcg2_shared_get_parent,
@@ -1567,19 +1580,6 @@ const struct clk_ops clk_rcg2_shared_floor_ops = {
 };
 EXPORT_SYMBOL_GPL(clk_rcg2_shared_floor_ops);
 
-static int clk_rcg2_shared_no_init_park(struct clk_hw *hw)
-{
-	struct clk_rcg2 *rcg = to_clk_rcg2(hw);
-
-	/*
-	 * Read the config register so that the parent is properly mapped at
-	 * registration time.
-	 */
-	regmap_read(rcg->clkr.regmap, rcg->cmd_rcgr + CFG_REG, &rcg->parked_cfg);
-
-	return 0;
-}
-
 /*
  * Like clk_rcg2_shared_ops but skip the init so that the clk frequency is left
  * unchanged at registration time.
-- 
2.53.0




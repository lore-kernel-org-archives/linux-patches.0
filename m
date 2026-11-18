Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026435;
	b=w9/OepoTWWmdlzUYWlrwBDecUSgXieYdUisB/qF7d7AJo2bjlu7UviAeemfaadae3m0Y
	 V1/uqkNh1UXH9RRHalo1/1K+YguwuOFXK7gnJQ+sRe/rJONzK5cLsQR+gDaLJJo2SXCZ0
	 H2rmtfX+XFqQSwZoMDOaNFrYeXLvPGTVz8RuEfxowS0GKcMYquiLGjsfTaLzgVb6d/MKp
	 ceXncQyEP0sdrGCwoRvxieOBfBNjkzTeHDY0kCBdnInky4V+Xe8TYlw2JPC0K6QisQs+F
	 0tdd/8JDvNPCRBCmBr8hxe0lBBwWpgTTJksoKhwKcjhOGmSfbCWCpo3JAsnt9yX7D/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026435;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aRJxc6GTUTxpJxJRRz8COf/LzZYpR0QtuBhttnlCHHE=;
	b=vaShYTlVDmTgvXrVmU6fBOCE6ZEPQWOcKL6Ijo6omYtqWddnzHGnNwUPmhJpMJBbPF5H
	 QAXzoqLfsWTQcIYQSYIHSesdzFK09IfGqzVd9PtbvI1zWqG7kKfKknHzlQNrnK+ekJKQL
	 MpZmV8YEcoeBcKLYf/ePaIffbsKVmmBamUMiXJKkgBZ3gLc1Ec6ZhZF/b7VEW37TY0gfk
	 O4nlhEmqsdiC7+ZV/i4QY60LAxg/qmSZX/Fdc8qxb3rrrOyoLPGook9qRsyqExbAbpI/p
	 yPgZAs1MN5qO0y21+v1HjBqqrYu7zMNOJ0np/Leby4dF9NGgGS2uouxOrU53G0gdbJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="D41RBPv/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA7060A2608;
	Wed, 18 Nov 2026 18:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D41RBPv/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D1041F000C4;
	Wed, 18 Nov 2026 18:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026435;
	bh=aRJxc6GTUTxpJxJRRz8COf/LzZYpR0QtuBhttnlCHHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D41RBPv/NMxvAhDzWqFzIXEZe0UHm+twne6OOA7fBZtzuVNy+bMnLB+cFqsCPh+d9
	 0kzSp1Lgx73TNUGxQHuvzFcLNwYgpplFvaPdRnctQ9GZTC6at67WhCjIcY9XYhhfMK
	 z6YHcFNExdqJsiRcLEhgKTMznpM9CMB9JBK9SI+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1435/2151] clk: qcom: rcg2: Initialize shared floor clock state
Date: Wed, 18 Nov 2026 15:52:50 +0100
Message-ID: <20261118150214.212464629@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index d0a5847f91114..b6e30985deab6 100644
--- a/drivers/clk/qcom/clk-rcg2.c
+++ b/drivers/clk/qcom/clk-rcg2.c
@@ -1553,7 +1553,20 @@ const struct clk_ops clk_rcg2_shared_ops = {
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
@@ -1565,19 +1578,6 @@ const struct clk_ops clk_rcg2_shared_floor_ops = {
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




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031672;
	b=BUPaqi8MGtP8TaYIwq8yiBivd8fsg6itsBaN3dJvGicV/c5Ntt4nlo8HSmhlv0FWwhW/
	 tAwv9+BMhKQrLG2tgzLaORZ4XkSo19fJB2MS9NEG0ejwNxMEfbG56SAdu+OdhCqozmiI9
	 G4jsXSxsydEQ375tm8K2Bgclr7CUX6EJyNT04lGT6Y7lHZx2OxAVKFqx9Tx/wax/mA4gb
	 EsTdDvEKQcUVV+xVJTCMxkKs6yHxbIsBtgc08g67ECmOpPDaTo6pJpr57x9oka+l94kX4
	 ws6vLojxGDxZngQqA+ecz2y6Tpl6J/FuLdd1H2PPsMwtcbwKcR/kWGv3CXuBsctt/7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031672;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Pj3OrL30H0Aw4i4ij9bEVhuyReWLQPSCsP3l1TqhoeI=;
	b=vkt3wJk00p1TvMxRcFO8Bpro5SRagd31Rp56Y1ziODHAao8VqcexTIXOeBtZN6wPCMfo
	 JPrIlKgAPrkAXm00fM8WqKM5i5kXXFTRJjJpSwMz6kHeHUWRR1Ts9OV7FH/cKAWyYP1dd
	 BSZ9JNnTspND3i9vKSLPa1tWFMAAcq29VrIC/GVFQQoXhe1nOsed/8Gtrto+KMtGuuWYn
	 2NHSzBz4rIH4mheqvYgZOGzfi04wgsRPUUmplMNa3kwobkEMTbf955xFgOd+9a2OmT9AZ
	 l0lgJ2MV6sdWbw2J8N6Kpd+9nz+t8yOAO5VyyXxja3nBPtyxMIKwMlIjSnBBh4kOGPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MIQXULNd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9FC0606A31C;
	Wed, 18 Nov 2026 19:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MIQXULNd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48D831F000C5;
	Wed, 18 Nov 2026 19:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031671;
	bh=Pj3OrL30H0Aw4i4ij9bEVhuyReWLQPSCsP3l1TqhoeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MIQXULNdvNB64uklBJMMgiTzDeG8KNSlTgULqdES9ObNpXd4vXeV4VAoeuP4lF+w7
	 MpfFvkCY5xKCJqoIiT7be9/TOtRu6vRIkTYmYZpZTbBqt2/7sYoURQWNj3HkxXhKcy
	 Fxdg/tsX2/hYV/eqTfzoUKSc5gGnx7LQcnvNZrqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1139/1756] clk: qcom: rcg2: Initialize shared floor clock state
Date: Wed, 18 Nov 2026 15:54:26 +0100
Message-ID: <20261118150055.396279843@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index 6aa9dcdabffde..c811ed72c26ca 100644
--- a/drivers/clk/qcom/clk-rcg2.c
+++ b/drivers/clk/qcom/clk-rcg2.c
@@ -1373,7 +1373,20 @@ const struct clk_ops clk_rcg2_shared_ops = {
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
@@ -1385,19 +1398,6 @@ const struct clk_ops clk_rcg2_shared_floor_ops = {
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




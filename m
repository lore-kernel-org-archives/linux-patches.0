Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041535;
	b=GaiIJWdZ1s5Mp/K6nY30EpAZT3ZpEtN0HbgYeWaYRnPy3RqmhB71kbrhxGUWvaHijmfB
	 MSPWcn6jlQaCOAc8GaHIfH01EJpo84eeLTZAo1TSwfXpPJ7ovAHKvnas3Akc9Ev2r162M
	 AvBDtQ8gFVkO73biM7F4HpQd0AqvvcYjg/Pz4Sb8S5HKa4PK76HkPlF+p037MzgMF2q+J
	 7cuGVmG+d1bYgFKoHxLCQQZ4K0elbxYCGYvbZmHFSFtdyJNI7NLBiN9C57U+e3qYwuM12
	 3KEUoUJCJFuUbCzEkM95Xk4Udi76nImvaoPiPUoIHUNUE1AMy/ANxoLHVFoZ2ku9Ctg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041535;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p+pJLBtyuuaIBj7VMcqQ56WRCt1ZIUldFII+xiCRhOE=;
	b=v2+5SqyJEZ7oOf8z5NHCxAj4IP+RIzkDKNtf/FXoHSnI1WERnJrFKCPBfWIWITVFF2Dj
	 yOH/NEOkG1Z11Y4WadDWHq/mA0JsJL1LHM/3mPfyarqsV8+wjqU+ciBwOUQP4Qf2pZ284
	 DLRArwyl6AWFkUd63B3YMVBIG1qFsLaxNoS9bYlP1Pj0a8ifJhFsrxuMmJh6iqtan0Phx
	 Jp/ZkJYWaDHUA8iuTzxoxv4x0Cy694DvgN76awLl0sE3CxVDGinutXEGtbv0oGMjGpNow
	 mMH1QmhBHF9NfCqZ0VIZzcF/H2Ug0nd834ccMeoNc4m3GGV577Jp8cdnC4xnqtXMuzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oQiWlO8S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34159606A32F;
	Wed, 18 Nov 2026 22:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oQiWlO8S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A2EB1F000C4;
	Wed, 18 Nov 2026 22:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041535;
	bh=p+pJLBtyuuaIBj7VMcqQ56WRCt1ZIUldFII+xiCRhOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oQiWlO8Sd3q3jGrAGHYoiSaNfe/jsMOK0duF6XGbPeMLIkVeIEGeF2UvwpVesTZJZ
	 sL8JKm3rGUaVpH1hv9FJHYi0pk6Ipot/WaqfTpn3ymvpKddKpunYjL0A8/SGHicroE
	 gewzocoMqZxIzRl9CseCGNHNsNivBOMKt+y56bao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2807/3318] clk: qcom: rcg2: Initialize shared floor clock state
Date: Wed, 18 Nov 2026 15:57:09 +0100
Message-ID: <20261118150444.879882816@linuxfoundation.org>
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
index 20bb72565f0ed..55c2c1e957c89 100644
--- a/drivers/clk/qcom/clk-rcg2.c
+++ b/drivers/clk/qcom/clk-rcg2.c
@@ -1207,7 +1207,20 @@ const struct clk_ops clk_rcg2_shared_ops = {
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
@@ -1219,19 +1232,6 @@ const struct clk_ops clk_rcg2_shared_floor_ops = {
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




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214232;
	b=UAcSSGu5f+DW05X0RM8Gepl/d/cf6rbZkoVSZVdwoGBHqVXKzFZ0yy7CryCPAJmnhpo9
	 PoDPdl6gvY+vN+NtxX9h++ES8KQxt/iFfyrYFwYE8gRs7ZcoYL7uY+dRpM84EkfBJWUTo
	 eylyr8KRUDGTaAIwFqTOAEswH1OYV3+S1Mi/OkaaheLiYv2Xe1kNu3r1+9oGdK3UhMZqf
	 BlI5HLoip9O8kB+lv5Q+gi067Pyz/8JGc1sS+WRJd7fU91DG9pFhFTGqesFaLZ/O9S7ap
	 Q3yzwVuxKLVooDm0WsopCkTIgUyWKGs5utJe8nbOQy/cmEO++g5vU48I3+E9SZOqWQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214232;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ie+ea88qX1WYv5Al8j5dG5EFXLU70WwpOvlhPt5djIA=;
	b=L8nmTOWXWwAZ+BlXQYJwC9Gh1YWEejrCQaVC/BjJQuFVQPgfVluA/2Eh6qjR+wSShBtx
	 sKplPbODypabE8Fw1MVNnxoiw+JkcVuKKLJzrrRbH8HdbRDsmnfwHfk7gBe/ZO2WnI0FR
	 cMm5pDbjXe7mKfXbR/vAtiXXuTTldCVmHNkJo58USwaffn9pH1ChqFjUH8+Wid0Wd/ZHi
	 EeG+DjLv92uPYpOqh5SKjIwbB2X8Dljrl5yyzitcOFIphfLgnHCrYaKYNey1WWXC93RrY
	 0cERlJymUzD1mNLapEAiNDaAEX8HmWuipPUxPbfkDtiin5sGcHdM2jYOicgGAh7vBQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eGoPZw+2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 814E3606A329;
	Wed, 28 Oct 2026 19:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eGoPZw+2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D47011F01825;
	Wed, 28 Oct 2026 19:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214232;
	bh=ie+ea88qX1WYv5Al8j5dG5EFXLU70WwpOvlhPt5djIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eGoPZw+2YXdzaYRuAx8TrNRRk6X0HJVkWvq8PqjlKhPFzdklH/9zrODaUdZA4+rCZ
	 JqbZyIIeooS/EDImdEGaHRvEd8jFYoUzmemCIFR3sLDpLzpBOnHsCzCbyhiN/+FJP8
	 /4ezLYglOSd+bMua4wvCCxQM4KU/qW4QgYJOXvVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philippe Simons <simons.philippe@gmail.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0786/1887] clk: sunxi-ng: h616: Reparent GPU clock during frequency changes
Date: Wed, 28 Oct 2026 17:48:02 +0100
Message-ID: <20261028170517.324213703@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Philippe Simons <simons.philippe@gmail.com>

[ Upstream commit eb963d7948ce6571939c6875424b557b25f16610 ]

The H616 manual does not state that the GPU PLL supports
dynamic frequency configuration, so we must take extra care when changing
the frequency. Currently any attempt to do device DVFS on the GPU lead
to panfrost various ooops, and GPU hangs.

The manual describes the algorithm for changing the PLL
frequency, which the CPU PLL notifier code already support, so we reuse
that to reparent the GPU clock to GPU1 clock during frequency
changes.

Signed-off-by: Philippe Simons <simons.philippe@gmail.com>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://patch.msgid.link/20250220113808.1122414-2-simons.philippe@gmail.com
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/sunxi-ng/ccu-sun50i-h616.c | 36 +++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/sunxi-ng/ccu-sun50i-h616.c b/drivers/clk/sunxi-ng/ccu-sun50i-h616.c
index e52f94822aff8..5831bcfbe5002 100644
--- a/drivers/clk/sunxi-ng/ccu-sun50i-h616.c
+++ b/drivers/clk/sunxi-ng/ccu-sun50i-h616.c
@@ -318,10 +318,16 @@ static SUNXI_CCU_M_WITH_MUX_GATE(gpu0_clk, "gpu0", gpu0_parents, 0x670,
 				       24, 1,	/* mux */
 				       BIT(31),	/* gate */
 				       CLK_SET_RATE_PARENT);
+
+/*
+ * This clk is needed as a temporary fall back during GPU PLL freq changes.
+ * Set CLK_IS_CRITICAL flag to prevent from being disabled.
+ */
+#define SUN50I_H616_GPU_CLK1_REG        0x674
 static SUNXI_CCU_M_WITH_GATE(gpu1_clk, "gpu1", "pll-periph0-2x", 0x674,
 					0, 2,	/* M */
 					BIT(31),/* gate */
-					0);
+					CLK_IS_CRITICAL);
 
 static SUNXI_CCU_GATE(bus_gpu_clk, "bus-gpu", "psi-ahb1-ahb2",
 		      0x67c, BIT(0), 0);
@@ -1103,6 +1109,19 @@ static struct ccu_pll_nb sun50i_h616_pll_cpu_nb = {
 	.lock		= BIT(28),
 };
 
+static struct ccu_mux_nb sun50i_h616_gpu_nb = {
+	.common		= &gpu0_clk.common,
+	.cm		= &gpu0_clk.mux,
+	.delay_us	= 1, /* manual doesn't really say */
+	.bypass_index	= 1, /* GPU_CLK1@400MHz */
+};
+
+static struct ccu_pll_nb sun50i_h616_pll_gpu_nb = {
+	.common		= &pll_gpu_clk.common,
+	.enable		= BIT(29),	/* LOCK_ENABLE */
+	.lock		= BIT(28),
+};
+
 static int sun50i_h616_ccu_probe(struct platform_device *pdev)
 {
 	void __iomem *reg;
@@ -1151,6 +1170,14 @@ static int sun50i_h616_ccu_probe(struct platform_device *pdev)
 	val &= ~(GENMASK(21, 16) | BIT(0));
 	writel(val | (11 << 16) | BIT(0), reg + SUN50I_H616_PLL_AUDIO_REG);
 
+	/*
+	 * Set the input-divider for the gpu1 clock to 3, to reach a safe 400 MHz.
+	 */
+	val = readl(reg + SUN50I_H616_GPU_CLK1_REG);
+	val &= ~GENMASK(1, 0);
+	val |= 2;
+	writel(val, reg + SUN50I_H616_GPU_CLK1_REG);
+
 	/*
 	 * First clock parent (osc32K) is unusable for CEC. But since there
 	 * is no good way to force parent switch (both run with same frequency),
@@ -1171,6 +1198,13 @@ static int sun50i_h616_ccu_probe(struct platform_device *pdev)
 	/* Re-lock the CPU PLL after any rate changes */
 	ccu_pll_notifier_register(&sun50i_h616_pll_cpu_nb);
 
+	/* Reparent GPU during GPU PLL rate changes */
+	ccu_mux_notifier_register(pll_gpu_clk.common.hw.clk,
+				  &sun50i_h616_gpu_nb);
+
+	/* Re-lock the GPU PLL after any rate changes */
+	ccu_pll_notifier_register(&sun50i_h616_pll_gpu_nb);
+
 	return 0;
 }
 
-- 
2.53.0




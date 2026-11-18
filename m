Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030006;
	b=FRr2ayfgKB5DwsDjw+HLV2TIylrMd65fLup+oUTr9OANvYZfTAhnH839z3pCxCpm3l8Q
	 GET9DwUvwNkM0JW68uJUYgvp+a4ud0KHZ8sB/pzJDjaQLBrkZX5CZhdc8nTgQNHVB7J2m
	 QJt05JwRt9rY/SVOo7VfTulyzKsFhuwOkJ3KzBp736RwEMW9jCF6SwtcvqGEjg+AEv56k
	 tGT3dVE8s2S6P4VMR/PnO+UECNPfGNXD5apuLdHVNYSoNtjhEYITJbl87KQ2L1g9EXh6i
	 kfjWzzDf8FcmWGgckYS6CvcHlcMO2SHeqL0G8DiifGbgGK4V1J7nNNlbdszpCHuHZJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030006;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DqqtmErJFA8IZlrSY+SoS2yseFtdjOmaqf6Cwzp6cYc=;
	b=z0fMWuwgxBHO1fel4SrKXGQAucxHzxJ7fV06lmJRIAwJP3uC5JkfcKmu6dfP2mx5nDpd
	 Ir7fG0D7CoesSRkHkYNX3lKOCVLdgvttPAuhVMsF08lVSmiHeTidQQEzJxghAIF0ieGS0
	 +iTeD9pXcQAtItoa1Fp51rs3lVtISZ7VcAZ9Q7BBI01foRDqEut0uuvmXUCFgixtTqbAO
	 4oHXHOGHzvMBkY4vSaXlreVMk6B6+/+ZAS3yg1z8sOW0FuzT07FYAjFwYhvW+UjSk0bbp
	 oCexOhFupUy4IcCs8JHFHN17DP25ebdxnagQktRtJzxazU0oKjoIvEAal4Pt61RceGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y9nh+1jQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71073606A325;
	Wed, 18 Nov 2026 19:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y9nh+1jQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDF781F000C4;
	Wed, 18 Nov 2026 19:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030006;
	bh=DqqtmErJFA8IZlrSY+SoS2yseFtdjOmaqf6Cwzp6cYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y9nh+1jQ5nP8yT1FDyoIvDxSrFVWD9WdvOkMzVQ8i1lYKryqpyclM/Ic4E04blDdw
	 N1OoZvgPNCENhPb+FO83D5I3sCxmK1BlCO0hk/On7sYBJYeg0UxmIKsALrROXvH4dx
	 I0tg6act1HB5KxxqV45C9J0HNol6sB1NE8IvjmG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Esteban Urrutia <esteuwu@proton.me>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0550/1756] clk: qcom: alpha-pll: Check Lucid Ole PLL status before configuring
Date: Wed, 18 Nov 2026 15:44:37 +0100
Message-ID: <20261118150031.017696240@linuxfoundation.org>
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

From: Esteban Urrutia <esteuwu@proton.me>

[ Upstream commit eb34e2804ce4ea56efb741e23d598469274a2f94 ]

On some platforms such as SM8475, not doing this may result in graphical
glitches when the mdss driver takes over.
This fixes the aforementioned issue.

Fixes: 3132a9a11e57 ("clk: qcom: clk-alpha-pll: Add support for lucid ole pll configure")
Signed-off-by: Esteban Urrutia <esteuwu@proton.me>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Suggested-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260713-sm8450-qol-dispcc-v3-3-56fd05822270@proton.me
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/clk-alpha-pll.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/clk/qcom/clk-alpha-pll.c b/drivers/clk/qcom/clk-alpha-pll.c
index e76ecc4663511..9f1da888b6fb0 100644
--- a/drivers/clk/qcom/clk-alpha-pll.c
+++ b/drivers/clk/qcom/clk-alpha-pll.c
@@ -2304,6 +2304,15 @@ void clk_lucid_ole_pll_configure(struct clk_alpha_pll *pll, struct regmap *regma
 {
 	u32 lval = config->l;
 
+	/*
+	 * If the bootloader left the PLL enabled it's likely that there are
+	 * RCGs that will lock up if we disable the PLL below.
+	 */
+	if (trion_pll_is_enabled(pll, regmap)) {
+		pr_debug("Lucid Ole PLL is already enabled, skipping configuration\n");
+		return;
+	}
+
 	lval |= TRION_PLL_CAL_VAL << LUCID_EVO_PLL_CAL_L_VAL_SHIFT;
 	lval |= TRION_PLL_CAL_VAL << LUCID_OLE_PLL_RINGOSC_CAL_L_VAL_SHIFT;
 	clk_alpha_pll_write_config(regmap, PLL_L_VAL(pll), lval);
-- 
2.53.0




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026533;
	b=W/gFsqb+EDibQXMV9kE1nTfoc7h3wDY2zaGYpxocaFgL+MZxtmAbR8Xcx6Ef/w3kuVYR
	 59cv6j9pXRYTy/epp8wjIvqrP/5JCpBpRRnOqS9ytcAyM0Atvu0k6kXdpGe7JBenMoI6A
	 FZutVgNGZMa5lZXcQbvkRMuDAbuyBe5eD1TZIoPpurwknBwmJPCf2Yknl92bzz6JGYjbt
	 coD9P1qFn4q3+VCDfyCUWV9PnaUqFCBLIi++GXsHhfsWjlc4X/p9AbTXLgtML696CI0Vb
	 +NZxSzRGSTDHAJBf26C1uutPiWMs4bWKkdIgwA31EeaUTLfxOmC339f8I08pr2iSeDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026533;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GOe7+ALC01FP/vQFqPu21QiJy6mPLxuO/A+3QN7Fk4s=;
	b=L8G3vczxorRNljq0wD8jbrifWbwJutSCJiNjDnqAt0adEIdnCSm/mMqPKeDAIxPQELFJ
	 t+rZh/DRUIEvunyHhuJQytud1vR26JgatKHKJunsuIGitPYqChJHJcADe0zM+mV9MuaVF
	 33wT46RhwTXNkyRCn2B6oVMkFBT80A0gmlyDZ8wZR33wIsQel0rVSmdrRejJW+UpMs4k1
	 qdR8DE15/eOmoNDrho6w/Z1YE6+MWHFMc5J/gQ17siniOGC4J56iTNKLXZQpG2YvMemDF
	 SWn3c8AOFibz2r351un5hts43G6yV5aifj9EPZHAoTo+kCHD8nkI/3ty1YG487RpuzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WgbqdDTs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19E6E606A31C;
	Wed, 18 Nov 2026 18:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WgbqdDTs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 312111F000C4;
	Wed, 18 Nov 2026 18:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026532;
	bh=GOe7+ALC01FP/vQFqPu21QiJy6mPLxuO/A+3QN7Fk4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WgbqdDTsvHUNBqpqz4q5bk7uXdMKufp9GRh9o4yTqu4vUSbZXCAr7+go4oBaaDteg
	 FYOJuld8h3Cb8P4QdyPCVLPX1xEeveDTrrvKE1cJLcLJjjF5XdHTh6hTxkBRFiq3xu
	 74DO8zq/bVoeyhw5iV7AepKGK7SnP0ikdHqtxL3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1427/2151] clk: qcom: rpmh: Update the clock suffix for Glymur
Date: Wed, 18 Nov 2026 15:52:42 +0100
Message-ID: <20261118150213.930038430@linuxfoundation.org>
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

From: Taniya Das <taniya.das@oss.qualcomm.com>

[ Upstream commit 3dadc1dc5e85cefc7a2f1c9d428b5622fda12d3d ]

The current RPMh VRM clock definitions do not accurately represent the
hardware mapping of these clocks. While there is no functional impact,
this update aligns the definitions with the hardware convention by adding
the appropriate suffix to indicate the clock divider and the E0 variant
for the C3A_E0, C4A_E0, C5A_E0, and C8A_E0 resources on Glymur.

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Taniya Das <taniya.das@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251209-gcc_kaanapali-v3-v5-1-3af118262289@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: 1ebab545ee3a ("clk: qcom: rpmhcc: Add LNBB clocks support for Glymur")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/clk-rpmh.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/clk/qcom/clk-rpmh.c b/drivers/clk/qcom/clk-rpmh.c
index 82f18e15cd77b..feeb288479b00 100644
--- a/drivers/clk/qcom/clk-rpmh.c
+++ b/drivers/clk/qcom/clk-rpmh.c
@@ -388,10 +388,10 @@ DEFINE_CLK_RPMH_VRM(clk7, _a4, "clka7", 4);
 
 DEFINE_CLK_RPMH_VRM(div_clk1, _div2, "divclka1", 2);
 
-DEFINE_CLK_RPMH_VRM(clk3, _a, "C3A_E0", 1);
-DEFINE_CLK_RPMH_VRM(clk4, _a, "C4A_E0", 1);
-DEFINE_CLK_RPMH_VRM(clk5, _a, "C5A_E0", 1);
-DEFINE_CLK_RPMH_VRM(clk8, _a, "C8A_E0", 1);
+DEFINE_CLK_RPMH_VRM(clk3, _a1_e0, "C3A_E0", 1);
+DEFINE_CLK_RPMH_VRM(clk4, _a1_e0, "C4A_E0", 1);
+DEFINE_CLK_RPMH_VRM(clk5, _a1_e0, "C5A_E0", 1);
+DEFINE_CLK_RPMH_VRM(clk8, _a1_e0, "C8A_E0", 1);
 
 DEFINE_CLK_RPMH_BCM(ce, "CE0");
 DEFINE_CLK_RPMH_BCM(hwkm, "HK0");
@@ -882,12 +882,12 @@ static const struct clk_rpmh_desc clk_rpmh_sm8750 = {
 static struct clk_hw *glymur_rpmh_clocks[] = {
 	[RPMH_CXO_CLK]		= &clk_rpmh_bi_tcxo_div2.hw,
 	[RPMH_CXO_CLK_A]	= &clk_rpmh_bi_tcxo_div2_ao.hw,
-	[RPMH_RF_CLK3]		= &clk_rpmh_clk3_a.hw,
-	[RPMH_RF_CLK3_A]	= &clk_rpmh_clk3_a_ao.hw,
-	[RPMH_RF_CLK4]		= &clk_rpmh_clk4_a.hw,
-	[RPMH_RF_CLK4_A]	= &clk_rpmh_clk4_a_ao.hw,
-	[RPMH_RF_CLK5]		= &clk_rpmh_clk5_a.hw,
-	[RPMH_RF_CLK5_A]	= &clk_rpmh_clk5_a_ao.hw,
+	[RPMH_RF_CLK3]		= &clk_rpmh_clk3_a1_e0.hw,
+	[RPMH_RF_CLK3_A]	= &clk_rpmh_clk3_a1_e0_ao.hw,
+	[RPMH_RF_CLK4]		= &clk_rpmh_clk4_a1_e0.hw,
+	[RPMH_RF_CLK4_A]	= &clk_rpmh_clk4_a1_e0_ao.hw,
+	[RPMH_RF_CLK5]		= &clk_rpmh_clk5_a1_e0.hw,
+	[RPMH_RF_CLK5_A]	= &clk_rpmh_clk5_a1_e0_ao.hw,
 };
 
 static const struct clk_rpmh_desc clk_rpmh_glymur = {
-- 
2.53.0




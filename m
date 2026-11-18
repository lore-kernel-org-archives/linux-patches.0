Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056425;
	b=uSRaCkaTX3BZcuAZA0y5lMok00+nZwBA+B6zPJ91aZ7ozBzUE5bgO4op6drCSGLWpC1I
	 z7qv/Jc4LjG8eK9rRciQzGvnFkXIsHeS0Ymsp9Km00zBTEK4FI7XgnzIDMv3QzMlSQ9Vb
	 hBZ7MpHA69P0TkZ6vG8sm49ZlkwdPTozJT/IC60wS3STfX1arDn7KgAHWBS+i5r83jAX6
	 IBgTtuQc12z2VmAjIZCYD54rvS5gPO50guYH/QWzCzlErIA4L2Y6obDoEa1FuEC0bK8b2
	 1aEXg2DHqbPKBxhlI/eWJJkzm4HmX47TZPVVk3GjRh32SY0tu7zcHwKhTdv1nQxQIbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056425;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cKHqlXO2Tk6EXN207DFQZkYI39jBsZDpd4jqbqqH7Mk=;
	b=kbJhxqgAucuSRvfkSSUF8e9BTpprxa09BrK2hGaxw12GQifbqogVsc+H7LX9zs1Fa8ll
	 n9kr9SQKhwoQBnBher7ipZ/ONSAHeo1ktExucwKtYWLSQ91Ua2//GNxzqGvsig/u4bpny
	 OjGiV8AV93eXOH1qeZ1HzAPZB6Oj7QeAYrgen6dTPV8A8jxKigAlSFT2qU6cSxHO9yWau
	 GmRxXx62gVzpq3O1f5JC0lSQMCeqQnmveek1SkCFhVAzviAcNwPaTOcOZL2k0ygiXqAjc
	 pRS8DtZD8LrrB8kjpG5fB1Reg01JcwNEVPKH013itZVdGYD8XBNKxg1uFIu1BEOjJgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vqNXmntz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E06BA606A31C;
	Thu, 19 Nov 2026 02:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vqNXmntz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E17961F000C4;
	Thu, 19 Nov 2026 02:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056424;
	bh=cKHqlXO2Tk6EXN207DFQZkYI39jBsZDpd4jqbqqH7Mk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vqNXmntzbV9zhLZbkx7hAO9gYkEK5nrMRUVP3P05tdUSJJw24E35SUBH53HP9LZyh
	 raHZCVWm4QZa9yU9u5Spf5FQWbFWev7RMtR5gy6vGxadL5ol9RXW0JP8kG3KLao3XA
	 HLiZAF1gsF8YeNGi9N9t8457qw+lKnoIGxL1h5UE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1982/2214] ASoC: mediatek: mt8195: make several arrays static const
Date: Wed, 18 Nov 2026 16:00:58 +0100
Message-ID: <20261118150130.151123911@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Ian King <colin.i.king@googlemail.com>

[ Upstream commit 91745b034dca6044407b559fe28dd1cf7efccc29 ]

Don't populate various arrays on the stack but instead make them
static const. Also makes the object code smaller by a few hundred
bytes.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Link: https://lore.kernel.org/r/20211129224236.506883-1-colin.i.king@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: c23390ecf5c0 ("ASoC: mediatek: mt8195: Fix register access clock error handling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8195/mt8195-afe-clk.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/sound/soc/mediatek/mt8195/mt8195-afe-clk.c b/sound/soc/mediatek/mt8195/mt8195-afe-clk.c
index d1939e08d333c..d311c5199f0b5 100644
--- a/sound/soc/mediatek/mt8195/mt8195-afe-clk.c
+++ b/sound/soc/mediatek/mt8195/mt8195-afe-clk.c
@@ -321,7 +321,7 @@ int mt8195_afe_enable_reg_rw_clk(struct mtk_base_afe *afe)
 {
 	struct mt8195_afe_private *afe_priv = afe->platform_priv;
 	int i;
-	unsigned int clk_array[] = {
+	static const unsigned int clk_array[] = {
 		MT8195_CLK_SCP_ADSP_AUDIODSP, /* bus clock for infra */
 		MT8195_CLK_TOP_AUDIO_H_SEL, /* clock for ADSP bus */
 		MT8195_CLK_TOP_AUDIO_LOCAL_BUS_SEL, /* bus clock for DRAM access */
@@ -342,7 +342,7 @@ int mt8195_afe_disable_reg_rw_clk(struct mtk_base_afe *afe)
 {
 	struct mt8195_afe_private *afe_priv = afe->platform_priv;
 	int i;
-	unsigned int clk_array[] = {
+	static const unsigned int clk_array[] = {
 		MT8195_CLK_AUD_A1SYS,
 		MT8195_CLK_AUD_A1SYS_HP,
 		MT8195_CLK_AUD_AFE,
@@ -375,11 +375,11 @@ static int mt8195_afe_enable_timing_sys(struct mtk_base_afe *afe)
 {
 	struct mt8195_afe_private *afe_priv = afe->platform_priv;
 	int i;
-	unsigned int clk_array[] = {
+	static const unsigned int clk_array[] = {
 		MT8195_CLK_AUD_A1SYS,
 		MT8195_CLK_AUD_A2SYS,
 	};
-	unsigned int cg_array[] = {
+	static const unsigned int cg_array[] = {
 		MT8195_TOP_CG_A1SYS_TIMING,
 		MT8195_TOP_CG_A2SYS_TIMING,
 		MT8195_TOP_CG_26M_TIMING,
@@ -398,11 +398,11 @@ static int mt8195_afe_disable_timing_sys(struct mtk_base_afe *afe)
 {
 	struct mt8195_afe_private *afe_priv = afe->platform_priv;
 	int i;
-	unsigned int clk_array[] = {
+	static const unsigned int clk_array[] = {
 		MT8195_CLK_AUD_A2SYS,
 		MT8195_CLK_AUD_A1SYS,
 	};
-	unsigned int cg_array[] = {
+	static const unsigned int cg_array[] = {
 		MT8195_TOP_CG_26M_TIMING,
 		MT8195_TOP_CG_A2SYS_TIMING,
 		MT8195_TOP_CG_A1SYS_TIMING,
-- 
2.53.0




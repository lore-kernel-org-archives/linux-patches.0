Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040165;
	b=Y+jY1OB//GeJl5C4OFr2EyZMR+2BWUap9uro3NOnxceS0AYm7mFYmG1xFQ5iVlxgx63M
	 A5nzS3U68+XCJNDCqlJYpTWADtd+yk0qQTDPYyWkezcwmMv6bUlMWYOvmJFXnUbif4VaY
	 af1oNNLb525s9Hp0E+PRTnT45/lzOViHgEMUSWxFjvXQnQrRSNoAACWoKSMGY5eODHGto
	 3Ke1N1N7UVac+YUuNF54MC8FCQLEMK7+d10/8DmW7NwQpkwt4P3+PGZ8mCFJbzf6O7ks3
	 ljRYlxaHFjZnyTMb+OH9KY4iyxQfNm9PDPjjadJHlZ+t657B7/j6yHWVqjYV42jr7Fg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040165;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yjHbFAYlvRq0wEYud7/DuGa9RwALKo/vfm/+zJ/uoXU=;
	b=4GzW4v55JqExO212iHu+4ND1JMotg353HOGKDkoTeYtJQNn9mJTCWHl42kn4xTNoUyHq
	 /yzYKaboKrNYrkiVnWE9NGow4y/5ovTMvfTRRYDGsHMy5sP/QBoYb5vn4bSBcTnkb1uFN
	 qahTVJTehkF19WKcNECe5gG+Jkl9OtOGdktNMkH+3juqya1qtHTCIp+tUjqHChS7YEuHi
	 s+s4YEvdiE84ouE8QfSPR9WNePi7jfN+LpO+oSEHZTdQv43U7XTswq65wNPyls2iDrnJ+
	 dJqt1NtebdqtxomNWLlpwHfZyyYqPApXbJukdTM78iD6MNbKpMSLDn0PJetBCa0Ct7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wQ8FgxoM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7466606A31C;
	Wed, 18 Nov 2026 22:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wQ8FgxoM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F334E1F000C4;
	Wed, 18 Nov 2026 22:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040165;
	bh=yjHbFAYlvRq0wEYud7/DuGa9RwALKo/vfm/+zJ/uoXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wQ8FgxoMdOSHR8pJ8o14W4QoUuZXslVN9Z6W7w4F0JxR+7DSDSgwrrnMFdG2skeR3
	 CDNR0nXuLvDg74BBjzBYJAGbdc8WVCF/oSxirr1+cpIgxZ1BM8XbKO4hf3KVbIllbx
	 fvDvLiNw2YhIbmYAp00p44JLVLxZceo9JftUsogA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2358/3318] ASoC: mediatek: mt8188: mt8188-afe-clk: Handle tuner clock enable errors
Date: Wed, 18 Nov 2026 15:49:40 +0100
Message-ID: <20261118150432.333215257@linuxfoundation.org>
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

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit a2c3ee3349a7da91e563b9a21a355a28fa754bc7 ]

Clock enable errors are currently ignored when enabling the APLL
and tuner clocks.
Check the return values and roll back the APLL clock if the tuner
clock fails to enable.

Fixes: f6b026479b13 ("ASoC: mediatek: mt8188: support audio clock control")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://patch.msgid.link/20260907120310.135693-3-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8188/mt8188-afe-clk.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/sound/soc/mediatek/mt8188/mt8188-afe-clk.c b/sound/soc/mediatek/mt8188/mt8188-afe-clk.c
index 7f411b8577823..b41069b752a94 100644
--- a/sound/soc/mediatek/mt8188/mt8188-afe-clk.c
+++ b/sound/soc/mediatek/mt8188/mt8188-afe-clk.c
@@ -260,15 +260,28 @@ static int mt8188_afe_enable_tuner_clk(struct mtk_base_afe *afe,
 				       unsigned int id)
 {
 	struct mt8188_afe_private *afe_priv = afe->platform_priv;
+	int ret;
 
 	switch (id) {
 	case MT8188_AUD_PLL1:
-		mt8188_afe_enable_clk(afe, afe_priv->clk[MT8188_CLK_AUD_APLL]);
-		mt8188_afe_enable_clk(afe, afe_priv->clk[MT8188_CLK_AUD_APLL1_TUNER]);
+		ret = mt8188_afe_enable_clk(afe, afe_priv->clk[MT8188_CLK_AUD_APLL]);
+		if (ret)
+			return ret;
+		ret = mt8188_afe_enable_clk(afe, afe_priv->clk[MT8188_CLK_AUD_APLL1_TUNER]);
+		if (ret) {
+			mt8188_afe_disable_clk(afe, afe_priv->clk[MT8188_CLK_AUD_APLL]);
+			return ret;
+		}
 		break;
 	case MT8188_AUD_PLL2:
-		mt8188_afe_enable_clk(afe, afe_priv->clk[MT8188_CLK_AUD_APLL2]);
-		mt8188_afe_enable_clk(afe, afe_priv->clk[MT8188_CLK_AUD_APLL2_TUNER]);
+		ret = mt8188_afe_enable_clk(afe, afe_priv->clk[MT8188_CLK_AUD_APLL2]);
+		if (ret)
+			return ret;
+		ret = mt8188_afe_enable_clk(afe, afe_priv->clk[MT8188_CLK_AUD_APLL2_TUNER]);
+		if (ret) {
+			mt8188_afe_disable_clk(afe, afe_priv->clk[MT8188_CLK_AUD_APLL2]);
+			return ret;
+		}
 		break;
 	default:
 		return -EINVAL;
-- 
2.53.0




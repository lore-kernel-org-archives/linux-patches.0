Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017213;
	b=veihmYx82ehyrIMDiaUtBPRkbrysOHSUuRdJ5QTsB/GK+ToZ21+8bWzUy4iEd73Dm1+l
	 JoFIWdf+xuOVI0FFwe373KwJCHaC+Jz4wRs7hnk/4i6ah+vtAHKVZUmoc46CJnNN2cqlC
	 ssnZkS62HYS8SC51uQc1aLgUHm0YG31v2XgDBlROqxpXFif2saHNAOlYfn6r9ZXzVYFZX
	 L6ZaVAuRHaQOPSom1DW2ZxNV32RpKm/WDEDIT++y93bTmOvwE86Vx6AYb7TlTvBpBttb1
	 gW2conYUUWfLpW8ke2eVT478txiK8/hUCuRcWAlhoplNrGlGzwyRAijGsDo8HnN+NEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017213;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IL8rxoha0QC3Nh7I3g4/0xjiRPULCVgy3veCTPKc8AQ=;
	b=PWMkxzgk8YzvMoxx6CZWjOqTBdRw1Ra9ZPEpnYtGelYBVXqngpqFx/SjKyImWDYt0Rzd
	 kk21MmimSeusNpcrtw/436XdUlIpacOkkfhj/bVunNsdfC/d+YZGFzCtkVovTz1+PxkuB
	 IM5BihZ5foMV4M2s9q9/85KVTeGeNGnHnTfYSDLcwSTsz/Kjume+ByAAMYmwegMCS2mEA
	 UI/WDtQP80FyeqoQ0Pm5abQJlhzKcwZ3qRSRdb4HMw5LAgY6QjrAbeBknHfRvZT6KHWtM
	 4AjWTJ6Xv7uYPmI1nX4zlkrG/nTUrVm3tDtuDi4I1i0mbAGQwzp6zOSHkeSehaUZVcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UCLZDxtC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69361606A31C;
	Wed, 18 Nov 2026 15:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UCLZDxtC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B82D41F000C5;
	Wed, 18 Nov 2026 15:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017213;
	bh=IL8rxoha0QC3Nh7I3g4/0xjiRPULCVgy3veCTPKc8AQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UCLZDxtCDbd9elsUBE1MAjC9BgLebdwxfdEjVMi/YnbSIJE3uVzwXc5TSeoyTUjOZ
	 JExPMvg34iOj/0LYNM+WGAxM61on4P8KFyGmqGF62gBWAYAIxCpaIpNnI9VmsH7FMp
	 OzXWb2vxPqNU7OB1ecQJhxlb5qYo1FEHb3whj6EU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0804/2651] ASoC: mediatek: mt8188: mt8188-afe-clk: Handle tuner clock enable errors
Date: Wed, 18 Nov 2026 15:34:04 +0100
Message-ID: <20261118150316.822001029@linuxfoundation.org>
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
index fc6cb3f0469e5..586fe0a521b80 100644
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




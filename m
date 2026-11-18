Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032127;
	b=HI8syXhUut3AIRa3/rnz9iV+szNs6K94PizzeRJ43NvrU4og52DWkaykv+7L5/1gWsfe
	 quJ2FzU+laqvwZ541iMLNYHizJTuEg2EOFdGKLyla3X+3mFu3d7g+H4R+NpCNeMtEI/4I
	 9xBjghYSolDKdjT38JGMRsqDb/ICX9Rjy04hL9OE8joycpz8k3u1JXMq9lgv/Rk3NhKXW
	 Z+IqaWCHWlHvaQxX7BwkPvBqlYAPPebKizF1Pv4TTUpK4MEApdi+9LPbTZPOl4LWjULJ3
	 ky61IV3/m5ROOWy7dsnOxjxupHdM67wmh75pHw5qq8UpZBooFs6QkJQH7y5JswLbQ0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032127;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RxYUAJW2cS+xhl/4zeLOobQgtnCuj4yk83fiE7Iw6LQ=;
	b=dwxo1DY+EvyBiZooq/NSZ8frZnF3jCRtnvxxgNRQ0ZIWsLkaQBAQnGbGryr5uDwxgrx4
	 eZ3HlnbQPFSbRBlEIEdWC7RYw984u7c5s3o/KBJrEwaGI/LGsFvmowk8xCI//zZpv+oJD
	 pkq6976qI/FV9CNWcDj6s8DFzEj9KvRJROkXfZxZ7EJBycVfeHX23qB7OkTYrEKQNs8F/
	 y1itIa3Lr7vtI9pFTDI/ZzHJoYZFjE2nt9Cp2T7xRVTxGiX0dyPuKXHjvFYlINMn5pt93
	 PB5WAHLhMqIrmSZuKysBIkmVPj8sLDqlBPcV3EsvTkZjkNEOWbx0AVaufrpxyb28akA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HI22zE1m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69864606A32C;
	Wed, 18 Nov 2026 20:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HI22zE1m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA85A1F000C4;
	Wed, 18 Nov 2026 20:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032127;
	bh=RxYUAJW2cS+xhl/4zeLOobQgtnCuj4yk83fiE7Iw6LQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HI22zE1mKdOYV2ySnbILk2NPVRNYMHtztYu6zD3CEzHn8e/oIgzc9WQdsEuvcRxhv
	 ms3I+VwYfHx2QH4SIi9uPlGbsiIiPXyi0qXU/VJC2uUnaZMdju/61jUFvXWTjOtBEw
	 c0/TYl9a3PZ4MBSWB8ro8QWG5z4zrEZnmmPAgYrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1302/1756] ASoC: mediatek: mt8195: Fix tuner clock error handling
Date: Wed, 18 Nov 2026 15:57:09 +0100
Message-ID: <20261118150101.335970551@linuxfoundation.org>
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

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 8e5a2eabb0d7cbd6db0b94f7f30e1ca2c0a8994f ]

Check and propagate errors from mt8195_afe_enable_clk(). If enabling
the tuner clock fails, disable the previously enabled APLL clock.

Fixes: ff5a90173d98 ("ASoC: mediatek: mt8195: enable apll tuner")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261014112752.683032-2-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8195/mt8195-afe-clk.c | 24 +++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/sound/soc/mediatek/mt8195/mt8195-afe-clk.c b/sound/soc/mediatek/mt8195/mt8195-afe-clk.c
index f35318ae07392..5d4ba88ceaef1 100644
--- a/sound/soc/mediatek/mt8195/mt8195-afe-clk.c
+++ b/sound/soc/mediatek/mt8195/mt8195-afe-clk.c
@@ -241,21 +241,35 @@ static int mt8195_afe_enable_tuner_clk(struct mtk_base_afe *afe,
 				       unsigned int id)
 {
 	struct mt8195_afe_private *afe_priv = afe->platform_priv;
+	int ret;
 
 	switch (id) {
 	case MT8195_AUD_PLL1:
-		mt8195_afe_enable_clk(afe, afe_priv->clk[MT8195_CLK_AUD_APLL]);
-		mt8195_afe_enable_clk(afe, afe_priv->clk[MT8195_CLK_AUD_APLL1_TUNER]);
+		ret = mt8195_afe_enable_clk(afe, afe_priv->clk[MT8195_CLK_AUD_APLL]);
+		if (ret)
+			return ret;
+		ret = mt8195_afe_enable_clk(afe, afe_priv->clk[MT8195_CLK_AUD_APLL1_TUNER]);
+		if (ret) {
+			mt8195_afe_disable_clk(afe, afe_priv->clk[MT8195_CLK_AUD_APLL]);
+			return ret;
+		}
 		break;
 	case MT8195_AUD_PLL2:
-		mt8195_afe_enable_clk(afe, afe_priv->clk[MT8195_CLK_AUD_APLL2]);
-		mt8195_afe_enable_clk(afe, afe_priv->clk[MT8195_CLK_AUD_APLL2_TUNER]);
+		ret = mt8195_afe_enable_clk(afe, afe_priv->clk[MT8195_CLK_AUD_APLL2]);
+		if (ret)
+			return ret;
+		ret = mt8195_afe_enable_clk(afe, afe_priv->clk[MT8195_CLK_AUD_APLL2_TUNER]);
+		if (ret) {
+			mt8195_afe_disable_clk(afe, afe_priv->clk[MT8195_CLK_AUD_APLL2]);
+			return ret;
+		}
 		break;
 	default:
+		ret = 0;
 		break;
 	}
 
-	return 0;
+	return ret;
 }
 
 static int mt8195_afe_disable_tuner_clk(struct mtk_base_afe *afe,
-- 
2.53.0




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031234;
	b=YNwiUYWrcKf6OidvWSTZhzgD7xBMM7EaCamWZ6m7USHzeod2gfjQpXgkp8zgodOo8yuV
	 ha0HnXctJiKBXQCt7ANfgnHkysgJ1qgarfnFq9mPLD/YM/paCc4dQK5RL3QQcAWd1wr7i
	 RQay5QF12+k1RYmc0FokHs/V4II7ql4Q6FG2eTqbBNdnvhDutNFVFWfV+A+Ta8mXhU8LV
	 RaH1ZnI18NsbWSUxkdiW0+3dWrNLoPAADFeuFz7bsHwBzyWREbRGI+uVAB7oRoHug1vk3
	 fENt0xTkBj0XPpyxxJrqsrJ/h6Du6da8S8+tjCGpvbMzj0hRXVGaTk6drZn5I1fjeFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031234;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UvffpGuGrPxWiBb5TXn3rLHx1QjuJCnn1hjmIfiU4dg=;
	b=zV0M6kIVgXzliL2uvUf4O88tx12R0NagQ1jBkQdIgk7zA2lR5hWj/Xk4G+jF8rP9GDvc
	 jtK4XpiO3XuqzNjqZ5kpX0t2FTO3Vg26QqtZNarUdNmw60cwQULSyAb97e4Fgn9Dm42wX
	 aBo1iUEhoucNNwuZCNtmA8ja6hcbB6BJOWcXyEG7nC/90lAEOna3ZYpMgStfZKMk8BNDL
	 Y2JZb9YfnFMqzLpPJgMqcMSfe27LwD1v49krxHwC51iKNC0fcZki+wJCuNKmU+bo5TjJb
	 BzTH0CS20CFcWlonozC6oUsN8OFbtmWjevj3X3miBLOwZ9mY0h+nls8gznUFsfjK1TA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a91hniyl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21AE8606A31C;
	Wed, 18 Nov 2026 19:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a91hniyl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74BC61F000C4;
	Wed, 18 Nov 2026 19:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031234;
	bh=UvffpGuGrPxWiBb5TXn3rLHx1QjuJCnn1hjmIfiU4dg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a91hniylu7QL3GQG5JhcM1+a1HeN6ccMLdwyWHhcaCiKDgLYKY6qb9gfE5/26mGRi
	 Y+Rn84fYt18g/bj82fwB8NDIEC71Ye6bMFCY2xbkqx/EyeFDZUIATx6CfiSRMX5/Jq
	 j6ld2kAcedjAJAdJZCE3YH13TdyIfhFEcTh3kfHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0986/1756] ASoC: mediatek: common: Handle constraint return value in FE startup
Date: Wed, 18 Nov 2026 15:51:53 +0100
Message-ID: <20261118150049.427305642@linuxfoundation.org>
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

[ Upstream commit 5fcdb40a4776cc6f8d3179aa9cf9663fc18c7861 ]

snd_pcm_hw_constraint_integer() may return 1, which is then returned
from mtk_afe_fe_startup(). ASoC only treats 0 as success when marking
the DAI as started, so .shutdown() can be skipped on rollback.

Return 0 explicitly on success.

Fixes: 283b612429a2 ("ASoC: mediatek: implement mediatek common structure")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20261007110858.509341-2-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/common/mtk-afe-fe-dai.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/sound/soc/mediatek/common/mtk-afe-fe-dai.c b/sound/soc/mediatek/common/mtk-afe-fe-dai.c
index 3044d9ab3d4d9..4e47689bb1f16 100644
--- a/sound/soc/mediatek/common/mtk-afe-fe-dai.c
+++ b/sound/soc/mediatek/common/mtk-afe-fe-dai.c
@@ -75,8 +75,10 @@ int mtk_afe_fe_startup(struct snd_pcm_substream *substream,
 
 	ret = snd_pcm_hw_constraint_integer(runtime,
 					    SNDRV_PCM_HW_PARAM_PERIODS);
-	if (ret < 0)
+	if (ret < 0) {
 		dev_err(afe->dev, "snd_pcm_hw_constraint_integer failed\n");
+		return ret;
+	}
 
 	/* dynamic allocate irq to memif */
 	if (memif->irq_usage < 0) {
@@ -88,10 +90,10 @@ int mtk_afe_fe_startup(struct snd_pcm_substream *substream,
 		} else {
 			dev_err(afe->dev, "%s() error: no more asys irq\n",
 				__func__);
-			ret = -EBUSY;
+			return -EBUSY;
 		}
 	}
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(mtk_afe_fe_startup);
 
-- 
2.53.0




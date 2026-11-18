Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019183;
	b=cXZ23jmcnU6QnUzYRS1rydk5PlpXs9cB4+9333ATr7Z3kb68sCZoSMv7F3Am8OM5pXVP
	 fpCL7+/ivGEJmU5Zh9p6sA+6YKRpIYOfoMWrg/sxtjvn+RH32yalHdi6ffuSEBJwzeICt
	 2MTqUi/F7UhV0pmPzDRabp4OJwwDwqwXPSVKVlbKLthkx0s7ZyqoPfAq9pEa8hFbdHcc6
	 z6+vpbwUD2OfIwrJ+35U/C2kr28H8uQVV7jvruOHzmLs/PM9EyKgxP1V9TV2yexlRRmqb
	 E50jVZZpJrOZfGCsWsEnKP3Cbp3SZtIaK5kxkxLKDM3DZcm4rSkX/Q1g4SzmSkfym2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019183;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SXopsvF6jtS6QwWwqobisYmPXV1r3pnGN0/iDqVItBk=;
	b=nJpTn3zNjexrGyV3qOJCVFYS3NTN+8DgnDA+Hizi3eVEdP7ugNs0QJoZr84lPfDcHfBV
	 DIzOSGbPxaWgxu5dp+VJmOazV8YnyszgGJqyVOCXQEpChRBSpEyR1SmHH96Zee680RT85
	 AkOmP8L7PKq8Ab/zxzEKXWZKpy4meRJ+EwSbHxGfVyXdlaWea3CqqxzWrh3CgTE9gZQxp
	 Q4jvE0ECGgN91hxVgXRhocBjSWaK/PIzIU8w2Qf6KYj1kDqwwEHiqr7KoBg4RB5U8ldfP
	 WSgZdSZFhduyPbBUrcpjFcHqF/yrHHemUhtSrF7U5UPQA0R8XXI/UCIbjpEkiuQbufw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uHpXexG0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B8B5606A31C;
	Wed, 18 Nov 2026 16:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uHpXexG0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A0F41F000C4;
	Wed, 18 Nov 2026 16:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019182;
	bh=SXopsvF6jtS6QwWwqobisYmPXV1r3pnGN0/iDqVItBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uHpXexG0uOhikYoqq/+nR83oPW4KA0LVSs6z/kjNuY1HOfljv6j7gZo00daX1bPwY
	 uQDFj5SaOxl1PHoUIdp905jbdrtA5AkGX3yQcVXNQQNWZlRSUsCKFB21Ychyv6gZcI
	 HT4hf/AXkHmwNnd/W6bl011s2TuLjRfZRZ9mFX/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1505/2651] ASoC: mediatek: common: Handle constraint return value in FE startup
Date: Wed, 18 Nov 2026 15:45:45 +0100
Message-ID: <20261118150342.196559670@linuxfoundation.org>
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
index 2a20fa5dba492..002953400938d 100644
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




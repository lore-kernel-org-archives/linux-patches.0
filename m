Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041070;
	b=CWHYsrmfkhukCaipJR1e8Oi9rr8zuQ3Q1tbsjC/NQd4C3XHud97sC393LwC8SZeCWseu
	 c/SlMFJOHRNKlScjwC3xHV5qmGBMaFRRA73SwmQnrmEWYgwcNsX0kLDhaQAc2xfbI0sQk
	 SaACtYJBO9UEGTjUvkNXS1xDOPuJcacQdsu4c+PlRKjM72wyS5MKOLsw2Xx/YNZMdeWf3
	 UHVT5YyFrCBCrMJ02z3qEjDni8DqAT6N8pUNDoO/OiY/wmyDDJ7VckiOMfZlIRwsF/Y3h
	 RhvP/qpVH8U64xQBh4lfql7JlsJ5jJOUezml7Zz2cpJ0GUMAKdYZzRtYinOgcXFP1nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041070;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8COHJtJMjA2li7WnEzMOSfTSIlYhEC1xH3EQ89wWzW0=;
	b=1zOoH2NWcRuiMGWTJQ4B8Iang1S+6U4gPS2guVJbIarYd83jdgDER/4LphVz3KDSfkeT
	 alkDcid0Tz0cgZzA3eXKg5KvIstyEQj7hj18ib9wdUdNG60QkWVHfh/gqyi3fmQcr6mY/
	 ZdopNGoJHzM/Jxjn9ucnbZM39pdpI1HmTiU8BOX9XRrPJTQF+La1YKAXtSMrxmJtwldYh
	 FsNCwecO/O4b9Z4s4pu/SBZL/Gymyex1tZCY3Zs7Y0mqKxN7dnB4OBXAm0V01oW61h8lD
	 VfAEtg0R1v04Zkl0lv7Gshub/Po7z0gqgoWtl8++fUDUfwnyqQEv6+fmTw5CKub/4Xg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w4rNmEgR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 409AD606A31C;
	Wed, 18 Nov 2026 22:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w4rNmEgR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 985F31F000C4;
	Wed, 18 Nov 2026 22:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041070;
	bh=8COHJtJMjA2li7WnEzMOSfTSIlYhEC1xH3EQ89wWzW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w4rNmEgRH+mCR/kyjeWeChjXgsFBBk4Qd8rkF8zfRcvKARxToY5QcAh8DqwUaPsGo
	 a+8iR53kElWzyUGmaKjo7MI59GGgFZHxFqzPoHp1sb7xVRgimZDcS8CVAipBs6Ls6T
	 eoIRzBAc7BuMsTY6LlNUm5URZyvpgOFqw4aUjkq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2683/3318] ASoC: mediatek: common: Handle constraint return value in FE startup
Date: Wed, 18 Nov 2026 15:55:05 +0100
Message-ID: <20261118150441.467153130@linuxfoundation.org>
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
index 395be97f13ae0..85f24e217b3d6 100644
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




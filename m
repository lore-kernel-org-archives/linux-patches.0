Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049389;
	b=wc1miyTmOH/2YhxuwYLS4SISkzzaKhkUjJU+p9bBOtp12BExByIDbxRpR10F/7TyexNe
	 MctvUzDgqvCBLn7qzDvwdaUHzhAFarbPOj1doBuY8efyOlLIEdEKhtfPjN2UNiEA8G9+n
	 stUvK/loMioDGB8O2jRwGBxqbU3+zx1ZW4vfqfe2/RL4MllRBfoYJ6PS93+6YMvNIi5ID
	 YPoaw6E4231HlGxCSqLNC4TXUL+ixVESnMfSLvTPcNs+W9hfgnDA6ychKyRG4XWuTMKB3
	 ynBfBPwJrqQ13aO/X53y0zn4BacsGYDiJgEzq8Yjgl8J+jkWOkz1ccDfPjeWP5CKRPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049389;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tx1MPP+krxsKBMQRwfsOlo3SteMbV9AJ5yxHkPIbnPo=;
	b=bfUcNvENuqIxqpJ9dlqAQk5AzKqiVxtpXbCFmZoz4aq8rr+8/ToMOunvnBE18w5iEn8v
	 nj41C7b6Zjr/tZJ4pxRCr5utDqhORUMGj746JeQCr6gsJwYtz46GY8GTD0s5wkyKdjYOX
	 7MdcpHJvx6B4qzlwCQOYgMN+23unMt4AHOqElLbVxWXZXFn2+BK4DY+yjS4P7cb1B+dzs
	 NCZe7bHxYPdM2uHX3duWDaQ7A04//XGmEbru/81sEGRiyAQLHS9FsyW/fBNHV83aSps7l
	 NrLFMjgSNRt36hKQMkdNTYsxer9pFWkmmhV8+ydVPFTMqfdpVb3YoLPdRz+vpOcDO/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yJbdZuYV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27C06606A31C;
	Thu, 19 Nov 2026 00:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yJbdZuYV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7688A1F000C5;
	Thu, 19 Nov 2026 00:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049389;
	bh=tx1MPP+krxsKBMQRwfsOlo3SteMbV9AJ5yxHkPIbnPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yJbdZuYVIIwxf6D6Ba03QxGdjBDgPbYeVH7TCBHb+wsQqpRdzTgnLfX4aeVFpIJpg
	 VUm5OGbAHX/e2xClHcC4NIqfK7pA/O+c3G3QK9a2cJu4f+cHbl/61K/5EW19yzv9ov
	 h6233YpsNERVGPlwc3J8Yk7b/Rtk7OcJFxZLbh1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2317/2857] ASoC: mediatek: common: Handle constraint return value in FE startup
Date: Wed, 18 Nov 2026 15:55:51 +0100
Message-ID: <20261118150324.960970395@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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




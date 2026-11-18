Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019188;
	b=R+B3AZmNj56PZrYEHT5zivHXBuZYWLcOXQ1LVDTI6WQRkfIa0nKvML7jfbIA9Hzsmw9o
	 SHxNdYf+1wSUCABqkrs72Wxtrw7gItEbp5p/ZX9HtGXRHwQRpMh53/Vo1/2Iw3h5haBFn
	 7oGf3vPxRIFmaVWuLeqX6EY8YwegsZgU9LknWWtpb0I3GHT6an07xCGdyDf4uU8e9+ox4
	 uAVUkTIBD8e6yMtn8hMr6OIwOtnJFDJ4FS5BVatwoC+nTRBtN6UIf3qOrQBzmnX4b8Cxe
	 hqelWR51oQz1UKl6VYv4T16InXzuLdLZwYAu+YsbpJWGMs7aydc+XZUCVdMv8/M2BxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019188;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x0s/W/xIphuP15ZnQPO7S7qYD6ZGQ6s20ZEFIwHxSsw=;
	b=ptc8qjFOjmbUxeWqLyKnJE8oTERRoMyEih+hO6SbarFBK6hBGEaC580LSA+aJgDsb9d2
	 nyEMPJA7r+imMvQltQ4HC++rfHfi8KQpln/TksQItcaiqmZgYz+4xXLFApLY3FUb8ElWG
	 HQJJ9ixSB/GmXxmMasTh3Pp7Fip2KMHvdIocyCHvujfwfPcwOWUWPvckdg829t57XXbd7
	 rmZDEiLW28Z9pQW+67iZDVkTmdEe50vFuXAiIG0AYGEpY4BAKuWfEoKhQDWlxIHU+kSdw
	 VizZ2NnrnKKCIXqCHF8Y4uoBh7sVg0BC/376v7/5XDQDvH4a2tswaMJt6eTYC2g9wJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DJA+CXcm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B01F0606A31C;
	Wed, 18 Nov 2026 16:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DJA+CXcm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB1531F000C4;
	Wed, 18 Nov 2026 16:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019188;
	bh=x0s/W/xIphuP15ZnQPO7S7qYD6ZGQ6s20ZEFIwHxSsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DJA+CXcmLAynioGIEAxtnUj2qCO9FsyKCbA+3b2YF2LI6deSYl344Vpt8g2gJrcqt
	 gv3MlACKr3nSIqj8Ja33bBnnMf+WLCsG4087BCHobLA9Lgh5czbAzdFGNiY22CvKDo
	 5ejZS3CROvFXqbxS5OYa7rj0xlzLp3TPGmTRCNnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1507/2651] ASoC: mediatek: mt8189: Handle constraint return value in FE startup
Date: Wed, 18 Nov 2026 15:45:47 +0100
Message-ID: <20261118150342.261386464@linuxfoundation.org>
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

[ Upstream commit 1f234d33e42e7c38f3ea6012ca93ff579c43ed58 ]

snd_pcm_hw_constraint_integer() may return 1, which is then returned
from mt8189_fe_startup(). ASoC only treats 0 as success when marking
the DAI as started, so .shutdown() can be skipped on rollback.

Return 0 explicitly on success.

Fixes: 7eb153585598 ("ASoC: mediatek: mt8189: add platform driver")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20261007110858.509341-4-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8189/mt8189-afe-pcm.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/sound/soc/mediatek/mt8189/mt8189-afe-pcm.c b/sound/soc/mediatek/mt8189/mt8189-afe-pcm.c
index 39cc2804ad4c9..311d8dcab5e2b 100644
--- a/sound/soc/mediatek/mt8189/mt8189-afe-pcm.c
+++ b/sound/soc/mediatek/mt8189/mt8189-afe-pcm.c
@@ -155,8 +155,10 @@ static int mt8189_fe_startup(struct snd_pcm_substream *substream,
 
 	ret = snd_pcm_hw_constraint_integer(runtime,
 					    SNDRV_PCM_HW_PARAM_PERIODS);
-	if (ret < 0)
+	if (ret < 0) {
 		dev_warn(afe->dev, "snd_pcm_hw_constraint_integer failed\n");
+		return ret;
+	}
 
 	/* dynamic allocate irq to memif */
 	if (memif->irq_usage < 0) {
@@ -168,11 +170,11 @@ static int mt8189_fe_startup(struct snd_pcm_substream *substream,
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
 
 static void mt8189_fe_shutdown(struct snd_pcm_substream *substream,
-- 
2.53.0




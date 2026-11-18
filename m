Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026038;
	b=NnFdhcSKx8pP3krsEYt+gasYIxVRh0scuph5fwN/PYFNTSWQFdvH90vAqdeXA2MRVFbp
	 b8W6/L8QGvnVYGpV9NFLZEu3EtjhK2VnjBRBLg0ckpOqD9naA3MPDn9FooEcAbvzoQmoY
	 MmF5NKQjkyAfzH5lsHo9VaEwT+l6UkbHTSoV9aApCdyg8BAXiqA06p0243upI+JWvCGLv
	 XHrqpjOS7K+NNzzlOBd/2IF4QM1JNGWWfObDAoEIhjEK5yNiPxwaOY4G3YHpaLX7w6NQc
	 7QI+LKun/dKCBQIq0sdIOfamCYAvZnAGsf+vzeCBvBtFod9emGndNLaYAPtWrQrSjsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026038;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SFqgGIZT3uq8cdX1dtRlIzLQg0AeLh35mz5TqE9Dntk=;
	b=X8EUXA11ZxJ1UqD8gMm6hQJrgUIT7KrqpLaPIVw/ZdckyGVaqYCl2i5F2nb/Ei310dqJ
	 Th1lvYebYJJc9fGGfLg16yN1bOCUTBHYswYRzYuBS3EIkyzn5CXtt1eTRw4NaoFDC//zy
	 wMMVpoCkEazZiRc9iO+Vd/DgwGAaxQC/ZxfOU6Bir22bsh4IrsXlWSik+NikIqM7vJs7S
	 565NcXm70sCK9T5SscdRLjFvT4qbrQe2ANeeea8+t1K6BUowm7IejSQGCNQLhhTLCZPu3
	 JcpfPYl+WpM7BQ5DIjdVZWcApPOUICwCKkmvyE9tJJMwKzt3/LA9t8UmWG/SAjdiS9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=onZIlZyS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58744606A31C;
	Wed, 18 Nov 2026 18:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=onZIlZyS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE62E1F000C4;
	Wed, 18 Nov 2026 18:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026038;
	bh=SFqgGIZT3uq8cdX1dtRlIzLQg0AeLh35mz5TqE9Dntk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=onZIlZySOcnS7ZSmVyDYD3yTGtksjGh0xzEjpcJCsdIQyc0+FPIjTlYYJEl4jrd65
	 xuBp7P3jcP+QmvB2NW+2Sd0pQo5hSEf+4BEbINzee9O3cbRCiiZEFxmBnpQoZei95v
	 Ba+LwdTIBkOOsWIxPHHJqNahaA7iWEGWJoak6vQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1250/2151] ASoC: mediatek: common: Handle constraint return value in FE startup
Date: Wed, 18 Nov 2026 15:49:45 +0100
Message-ID: <20261118150207.699940330@linuxfoundation.org>
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
index 3809068f5620b..ba0c9db4ca083 100644
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




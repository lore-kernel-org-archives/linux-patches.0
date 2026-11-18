Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055920;
	b=eDStur1ldmTkD2W0p4zJCpM/YD2IzDICBtyI6HpCyV4GnTvwK9Q9bzELRzM7JYg0KfPG
	 O/QjAXXnom4TaobTvm89My9BlIKlDWMzG8j1FX4M3XZ/xUU4JEdSQq7rYevYzs4UFog6P
	 Oq4zR2qkn1iAJ5vvaTYetp9Voy7YWdw127ufDkUd2GKsiTS95eXdds4Bx3xig4lKp0fRS
	 +ERelwtTgSpdeFaJMshlaRWh+pWN1KPL/E93xZTSDzo5vNp5e/sqitmysQ5E0crgFmf/C
	 6xA4FCfn7MRpBnbIEqSacnxVySTPAthspuc1hw+pXrTdHb+WzgxQ2K3qAnNgTmIcN0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055920;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KpitsH2PicZPq/u7TXx8PpS98zn0CQvUPWF5S4nhPAc=;
	b=RFnBtduqFRIX90D6eL06ppYlNZjof/AL9GWfBbrE9ZAQfYnYpHnAxECGvQSdeJ2ayo/4
	 7e1pNGk3c34gwW0J5x02dVwL3hUtMuQoCdUwtnIP4PECi6nZ6/GagoYTW2mG1e8Cix5px
	 ENhts1+kF6UqxSoUK7nnmjPltyWGcJHbHNdpwmREVZz38faV9p+FcytC4PZAFYlhyI//w
	 YmmZR3jsRQR/LXoFy03TCL3Xk5HZG7A9EoN21ZC/WigDYG1e57CTJ6oQ5hVwfRm9bgGTP
	 h7G+KYu8CC/gJqhC4nEBFQKPRYxqpl24caKEw0M5KLUic/MFZ6kovr4uxB4bzSprtxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jU0LC3Ek;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65628606A320;
	Thu, 19 Nov 2026 02:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jU0LC3Ek
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6D5B1F000C4;
	Thu, 19 Nov 2026 02:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055920;
	bh=KpitsH2PicZPq/u7TXx8PpS98zn0CQvUPWF5S4nhPAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jU0LC3EkOJiwT5Y9OxpQ/HwOJkE7eNbNErS4v6KM6jWzO5K/OwOP9viI+/naTGEEt
	 zLwrr9ekadl0b2lCJXubEOtLFEcteY5i7IMGhtmp9oaJuaxoQqVRZXwTXkaDU7FIUb
	 TCKFFdyOffQ0pkCJyFL2degbNQyIiKlnPbQNZQvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1802/2214] ASoC: mediatek: common: Handle constraint return value in FE startup
Date: Wed, 18 Nov 2026 15:57:58 +0100
Message-ID: <20261118150123.588842558@linuxfoundation.org>
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
index e95c7c018e7d4..2b0ca330af939 100644
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




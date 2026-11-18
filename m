Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061386;
	b=ygywR0K2B9MNhiwzDJcvSZ85ic3QmHYKybO/Q9qkiRc+8hhBKIqNDpAdt9MnAyLS1cTj
	 fDeiGZXeNjc2E9UMxqgdz6XiZf/ITPqsSgFcDk0qpB0ds5ZSvoW9KnV2Tj73oJnh6k3aX
	 byz0Q83rs6RFApGzXPsRquoWcgsc8Z0gfYpBgdmAcLti1fpC752olBtY/J45pPAkQJStC
	 d0YpqGFgBWvIq6dpWBuykggM1eh29p6L04766fAjIAw0b5Vs0pieWzp2L9YUPNgv2wpoS
	 vWYEcWci0wrzEoBgtfezsbndi1kJaL6KbZS/0HDFLQpGugP0+RkjiTN7tdXu9+gzyxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061386;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e8Yrt2uOISvs52dn3bJJ/2ZL3ZjjMXDm2aYjz6VhdSM=;
	b=quUCfrcE8MRalO1dB+BlTLEbUigV5AAtkYa2vRj6FdgPyMwAZ6KcEmWpukaPn1SsCp5c
	 y4RS/dq4Vq75tJVF9rta9AJvTPVWLiQeGBem2WWZ32iou8TywmVKavzXhSypD0E0aazud
	 FbGtCF86b7XLoUp6ZIAZhlDUjP54NispvFJ4m8liOaEcl1s+xjIA99a0QQw+woIk03E7D
	 00jYbr4gaDWtsaxvia9h+f+jzJ24MsO4FgOMPSNfhKZRFiDde1PRZIW7F1U7MI+aZrFoo
	 9zoPMDlHBekqlU6ncig+RpHRJuxKL2awWcVojnoKgfAIC9AB7wbxePtjXw8KlcND5mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HNszwnH4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71087606A320;
	Thu, 19 Nov 2026 04:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HNszwnH4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C7BB1F000C4;
	Thu, 19 Nov 2026 04:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061385;
	bh=e8Yrt2uOISvs52dn3bJJ/2ZL3ZjjMXDm2aYjz6VhdSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HNszwnH4UDv1IwdCntuS9eZmafO9XiOon2/uim9TZdzwDl7sG8uPJexBCrFlhNxwN
	 i+kbOykBFZpkj6XH6fPzJp6wtblqY6bO7f56qeC1xthVB/E0UWKmd0I32zRMCn+Fu6
	 AQDtHECf9mzCrwQlqkJtCmNv+So2X0SGGLpBiVVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1534/1848] ASoC: mediatek: common: Handle constraint return value in FE startup
Date: Wed, 18 Nov 2026 15:59:32 +0100
Message-ID: <20261118150023.683027083@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 882cdf86c8bf8..22bd137d61c57 100644
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




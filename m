Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829426;
	b=eY+h46Rwm9LRi4xqWqW0oCVlOeB7nBYaxvRDFj0EW1Xu2JR66Qg6ZQ3lKx487FOGhjds
	 UXwfkaAkRTL0kwDlkMTl9UzOqtRxeAEAdEG3g1uMBOJDuda6epO7MZoZruypxrJ+IVFos
	 Gsmc2XtjDLUuD6NlJJxVo0YSG3bTIh8uoSUg8bgMKlsgRJvH5fWyIImwK7yyVsKU1rMyd
	 a/E+LfzzViaGtE3F2JpWjD199rF7TA2xwoIuFk/CFdNexXeYJ2gF+kxPdADCRy2YLsdc2
	 iachXpgCNoXlfAQ5bdGyd2ooI9w+DCXuXwhTTgoAA+qMHAt7/CTHzkkKZFh1tprdLMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829426;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=23bbIPNZ0+3EkZdGaYof2r2hDj8MlYJoU/jKr6EMZpE=;
	b=YFEuPfzmKlAFO8K9v1SrzTLT7MDO/JIhMZewy7TaGWYOd4qOEMDvNhPOn0C6XosI6IYd
	 ZbZhJmfA3MMTsSnrS9lTnuczjzllUot+3waNfXEw5aCJMbDCM5Pe/GZ15Mnl3IfEZPo/S
	 zNKKmfgE4bqrZHJ3ZMfU1oRRp7bwQaNVTg/YN39jragR5ESL79Crb17/Zjc+ayw8zVxts
	 IdZ3uSPeucwrNjMMB+DZPpDSvhnUeh/PiSsX49Vza1MjSMYN/hQCUvgH04VP1nwm/M1TP
	 XRPTp28PUyaPM03dzpqBOncsTEaNyoiPBn69PjbqfDj5yoos6EC6wr05eqT8sCYsbzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BmBXWDYt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B61606A84F;
	Wed,  4 Nov 2026 21:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BmBXWDYt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F4511F000C1;
	Wed,  4 Nov 2026 21:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829426;
	bh=23bbIPNZ0+3EkZdGaYof2r2hDj8MlYJoU/jKr6EMZpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BmBXWDYth0scesW5ow9YrG2akY2fE9lZ9keWf9XQZqn/6Ncd3cHaqFylAZVpWsMNY
	 dAYwi4QChpFiEbcXWUhx3We33Q1uQKBlIOd0umXDwmoRq0VSG2bw8HonSOUdPGW1Ip
	 qPvAoFtvTH05Bdl9auBmBy9ioBpHnt+stGPEMSlQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0119/1005] ASoC: codecs: max98396: Unwind supplies on resume failure
Date: Wed,  4 Nov 2026 15:57:32 -0500
Message-ID: <20261104211046.999308379@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit d20de7409dfa8e3341af7f157cd42130bd4ba3a7 ]

max98396_resume() enables the core, pvdd, and vbat supplies before
leaving cache-only mode, resetting the device, and replaying cached
register state. The function currently ignores regcache_sync() failures,
and the optional pvdd/vbat enable failures return without unwinding
supplies that were already enabled in this resume attempt.

Rework the function to use common error labels. This propagates sync
failures, restores cache-only/dirty state on failed cache replay, and
disables each supply acquired by this resume path before returning the
error.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260704040651.47558-1-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/max98396.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/max98396.c b/sound/soc/codecs/max98396.c
index 4b4e1fc98a6da..0255399c405df 100644
--- a/sound/soc/codecs/max98396.c
+++ b/sound/soc/codecs/max98396.c
@@ -1601,19 +1601,37 @@ static int max98396_resume(struct device *dev)
 	if (max98396->pvdd) {
 		ret = regulator_enable(max98396->pvdd);
 		if (ret < 0)
-			return ret;
+			goto err_core_supplies;
 	}
 
 	if (max98396->vbat) {
 		ret = regulator_enable(max98396->vbat);
 		if (ret < 0)
-			return ret;
+			goto err_pvdd;
 	}
 
 	regcache_cache_only(max98396->regmap, false);
 	max98396_reset(max98396, dev);
-	regcache_sync(max98396->regmap);
+	ret = regcache_sync(max98396->regmap);
+	if (ret < 0) {
+		regcache_cache_only(max98396->regmap, true);
+		regcache_mark_dirty(max98396->regmap);
+		goto err_vbat;
+	}
+
 	return 0;
+
+err_vbat:
+	if (max98396->vbat)
+		regulator_disable(max98396->vbat);
+err_pvdd:
+	if (max98396->pvdd)
+		regulator_disable(max98396->pvdd);
+err_core_supplies:
+	regulator_bulk_disable(MAX98396_NUM_CORE_SUPPLIES,
+			       max98396->core_supplies);
+
+	return ret;
 }
 
 static const struct dev_pm_ops max98396_pm = {
-- 
2.53.0




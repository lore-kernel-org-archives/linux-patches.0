Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211718;
	b=agc6nrqINxarz6BhThMCtQJ4tF7Keh9oHI+d8XiGQcNI6d+lU1d8VbzRig9hBCqhEATX
	 XR8kVzMtq9St+G9CILtiixvRXmrikdE91qJMfYWV+PUOMgUcbdhy8io3APCHz8CKOY1JI
	 EUncsUNu2ssFxIP/KlmzD9ZxgugtWcS5bOKTcVs0D5hp940TbVTfove9Ho0Oo0Fu243NO
	 rVFhiCFe0HVX+2vYnnr8b1ivvmCmu0m2Lndjle7REZrB8sdqI8yKG4MCMb9t/XvsQHfgI
	 vtHg95Me918IEczsPx8N/nED74ekeGhioGq5Fwx5RYvFRBI+RVKY4gLTdXWzHfF17Ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211718;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8jZU69F2nXXe4S5jfrqPttG6QIZiUTOStwu2PkuVV4k=;
	b=1VkK+7x/isyk3/iHitK9srLbn792c1i+5gNymbuqFmMmwW3yGxNlah4hMGNNsWsKT4b0
	 QrrpwcKZRgZUXWs5IS586dsFLLgcb3QbYmNwxds/qhP+JiAzCamV/HBS91Adsx7pA91iF
	 vHUyUl14Z5simiUk6Jltte4Qb+5SvEebYymQ0GZoKxfbKZc7tUMJNE6kpSU7Z/bbCsmAS
	 IqcpiJr6kjIuaNjmBNeXAOVkYVDhjXQXFtN8B1kK6+5y31Vv2ala35ikreI8d+9MZejXL
	 nGWQsHG3yE1I9NRW2IdcthfjqayaWz3Lk0nU95o39CVVX1z+O9DhEqhXkoIfqIlfI+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uyABVZe+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB5D2606A333;
	Wed, 28 Oct 2026 18:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uyABVZe+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2928D1F01825;
	Wed, 28 Oct 2026 18:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211717;
	bh=8jZU69F2nXXe4S5jfrqPttG6QIZiUTOStwu2PkuVV4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uyABVZe+ld51l2AltVoWlcuoHtjD4R1CsRwUohbvMctMiqhLL45Oa9WrCMt1WhyEX
	 ga3HMStZH7tBb4f4+KvZjaQqXRJhDmUeuWuRG+YubGBmgrEu9PXi6uvg+7OEwixcpb
	 n2Uz8oioplfzu84ypSINf/4dGaad9zEnVLmgYF4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 477/571] ASoC: max98371: Fix the Speaker DHT Min Volume bits
Date: Wed, 28 Oct 2026 18:00:24 +0100
Message-ID: <20261028170019.340171105@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit f7934340c56a84fc1b246ebf6b2e806d775f3b54 ]

Register 0x31 holds two 4-bit fields. The datasheet puts SPK_GAIN_MIN
at bits 7:4 and DHT_VROT_PNT at bits 3:0. The Speaker DHT Min Volume
and Speaker DHT Rotation Volume controls both use bits 3:0.

So setting the minimum speaker gain changes the DHT rotation point, and
SPK_GAIN_MIN cannot be set.

Move Speaker DHT Min Volume to bits 7:4.

Fixes: ca2cd6bc6663 ("ASoC: Add max98371 codec driver")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/20261008130953.2446692-5-sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/max98371.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/max98371.c b/sound/soc/codecs/max98371.c
index e424779db02bf..f0614c47f3641 100644
--- a/sound/soc/codecs/max98371.c
+++ b/sound/soc/codecs/max98371.c
@@ -166,7 +166,7 @@ static const struct snd_kcontrol_new max98371_snd_controls[] = {
 			0, (1<<MAX98371_DHT_MAX_WIDTH)-1, 0,
 			max98371_dht_max_gain),
 	SOC_SINGLE_TLV("Speaker DHT Min Volume", MAX98371_DHT_GAIN,
-			0, (1<<MAX98371_DHT_GAIN_WIDTH)-1, 0,
+			4, (1<<MAX98371_DHT_GAIN_WIDTH)-1, 0,
 			max98371_dht_min_gain),
 	SOC_SINGLE_TLV("Speaker DHT Rotation Volume", MAX98371_DHT_GAIN,
 			0, (1<<MAX98371_DHT_ROT_WIDTH)-1, 0,
-- 
2.53.0




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020742;
	b=2ABcuHR+kbiy8pJnNFpV6DWiOw6lXxfjBa/EWv7F0fMBu/yny1ScqKQimYCFoc/oxDYm
	 TopqjfHFEi1saRLO14XxdoJhBnUrn3BHIgcUR/PnkP7/u0Wdn3wwvqq0lhISrv/MGbs1q
	 HDPz+EhqnDrKvc9Fpp6LH1EB8BDj0mOzMu2M8YUZh3o0xFLCRB9r806tgAIgR7psI5gdK
	 H3NHWu0QdXRKXMxaJFcwQOM//q9CLveYZjRllAHXpLfmEAdU15SGeF/wXrvk+eN1JtqlD
	 HVSCNAkABCD8gNiF8QJE9HojEkD8TefZ4YMKVx12TlmLYOLRSGGN63ZdgMSp0Ih4qYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020742;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Cspj0vKesHUynOXngRX44ZTwh0ztsv2RyKW40I6EWeU=;
	b=HCB9sHpfgsJA2KevJqVEB3k1DHVfCW2SQHDe+dpTrUO6+EFWwF6F/oxQbk7VZ9P75P67
	 EjVX01iQ5NLgijpvlOCMxFO5zDkE2Tm2Y+3BG1h75zu8AcoRyqT9TKMjT339a38ob0PH/
	 lv3nmE4sFx80U8QeNUyabAGLwMRLgBmUSpX+TtcwQUx9XuOhkTFb3XNRN3W2pwMQV7xY/
	 6Z+IXGbFEqzSEl5IKKxBmIKNTR4xty4khzVYVuJHIa1GySzjucHtwQMwvUwkKcxsB+E/e
	 ULQRaej392Cv1e937fZjEMBsN3a6bOXhr7VcXCH1tt5ZnF7Elecmumtop17n5NpXRZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dwmLznsQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69925606A33B;
	Wed, 18 Nov 2026 16:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dwmLznsQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C03911F000C4;
	Wed, 18 Nov 2026 16:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020742;
	bh=Cspj0vKesHUynOXngRX44ZTwh0ztsv2RyKW40I6EWeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dwmLznsQfD5hNj8iix0nOkHFyXi9Jem8XdVsGaqcd6rIzNg3+tjikreaMLfYstHgN
	 zt+ATdBgzWgsz9+a3OBB7gCWBpwmmeWfPk1hgwKFV6lwkfNGA6RP1DqvJJ+nzwHXlj
	 nREMOrcKu0NSrlUFd14g6ES+ZQV/utpAsLskigLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2061/2651] ASoC: codecs: da732x: Fix definition of ADC2 EQ Overall Volume control
Date: Wed, 18 Nov 2026 15:55:01 +0100
Message-ID: <20261118150400.252092991@linuxfoundation.org>
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

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit ebef9212cb469706e28002a20f9d48307d1fd867 ]

The ADC2 EQ overall volume is in DA732X_REG_ADC2_EQ5 (0x9F), not in
DA732X_REG_ADC1_EQ5 (0x97), which holds the ADC1 one.

Fixes: 48e278746070 ("ASoC: codecs: Add DA732x codec driver")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/35bae3f84cdc3ceb6ca412153f44dee3647fdbd6.1792135144.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/da732x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/da732x.c b/sound/soc/codecs/da732x.c
index 12d1ac98461e4..f7a2bb42c811f 100644
--- a/sound/soc/codecs/da732x.c
+++ b/sound/soc/codecs/da732x.c
@@ -511,7 +511,7 @@ static const struct snd_kcontrol_new da732x_snd_controls[] = {
 	SOC_SINGLE_TLV("ACD2 EQ Band 5 Volume", DA732X_REG_ADC2_EQ5,
 		       DA732X_EQ_BAND5_SHIFT, DA732X_EQ_VOL_VAL_MAX,
 		       DA732X_INVERT, eq_band_pga_tlv),
-	SOC_SINGLE_TLV("ADC2 EQ Overall Volume", DA732X_REG_ADC1_EQ5,
+	SOC_SINGLE_TLV("ADC2 EQ Overall Volume", DA732X_REG_ADC2_EQ5,
 		       DA732X_EQ_OVERALL_SHIFT, DA732X_EQ_OVERALL_VOL_VAL_MAX,
 		       DA732X_INVERT, eq_overall_tlv),
 
-- 
2.53.0




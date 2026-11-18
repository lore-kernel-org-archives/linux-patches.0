Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032263;
	b=k8llJnkGmu8J1G769E03xepmwNmew4LpEr4GCdkfXBhovvtG/dikbNwY8Afsc86pxCWu
	 gow7MH/Lc8GDktWC2izFeZpGLyF1o0ViaJST1femrTDxwhSYfQ9yT12JZsS4no2AbR9X6
	 IdLBKIAY0nfO1mOlYkg/B5OK1l/71/h+Xwq6kIULbkG9Z1aM69xRwVvnoG6QNKLruzgfD
	 liAinq2+OBvhykPwI67fhq0OUz2NT9kjKW83waVeFogyjzN5+A8rbgIA4CCCph210+71Z
	 sgx1zAdOGi50H9KEu4Tt0IEq/I/DG9lpm5pBO589Dd64ovpdIKhEg3g63CA1XZI2R8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032263;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=j6+3RwmFmju5GHWFHFSIciVCVsQpSMQoXIuZ0QtsDaQ=;
	b=Xi2O5eEtlC8PrUmOLnlOk1NH7i5XKTWXvXJT7mnHsJX3eOxGmc+EKmacFEF9iFrzRjoA
	 Xz+DmckKYhuYxtCgkpYvtoXolOaq5yk2QGnt+h7v2NgaFjGyKFhJwCcGha7tc0TWAAnyz
	 EO8lB419kA7TNeLCFygALN+QCzz4MVjNvNYe6l0ALOhqBBXPBM7uOH0aZB7+uAQpPAq5m
	 lyTLKL7IxZEZnRZLvFhFuzs7bNDBKlAzxLQyNujAybZ0LaOx6nsBb1dqq0DC2j9y+Ktty
	 t/VU8Y0BjJsBe1FT2c/KhPrVe2zerZYwd7FMPPX++oHP6tqQT2eAPDKtoAtyIBbm3rQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pcpdOlzu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93879606A32A;
	Wed, 18 Nov 2026 20:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pcpdOlzu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAE681F000C5;
	Wed, 18 Nov 2026 20:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032263;
	bh=j6+3RwmFmju5GHWFHFSIciVCVsQpSMQoXIuZ0QtsDaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pcpdOlzugD+CTxqoOnbOSzH8jUs3JB9CLrDr6u45paDAA21qULY1DNM1LCTqWc/IZ
	 UiMYGj6+s9NBw81yL+p11PXzChumLzxYmAxND5mrQAhrQLUyOooVN+SYRlGfpndguj
	 rFIZ19/elctsnHrBhPriLE84XtgL78ezIfvEO8rI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1350/1756] ASoC: codecs: tlv320adc3xxx: Fix definition of AGC Target Level control
Date: Wed, 18 Nov 2026 15:57:57 +0100
Message-ID: <20261118150103.068281655@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit 0a9efcb663b5a4d468cbb90de29c6dd3794af124 ]

The right channel AGC target level is in RIGHT_CHN_AGC_1, as on the
left, not in RIGHT_CHN_AGC_2, which holds the right noise threshold
and hysteresis.

Fixes: e9a3b57efd28 ("ASoC: codec: tlv320adc3xxx: New codec driver")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/09cad9ec9bb382e44cad079a680bdf0f6163567e.1792135144.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tlv320adc3xxx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/tlv320adc3xxx.c b/sound/soc/codecs/tlv320adc3xxx.c
index 7073b9d1cda84..d83d5430503d9 100644
--- a/sound/soc/codecs/tlv320adc3xxx.c
+++ b/sound/soc/codecs/tlv320adc3xxx.c
@@ -691,7 +691,7 @@ static const struct snd_kcontrol_new adc3xxx_snd_controls[] = {
 	SOC_DOUBLE_R("AGC Capture Switch", ADC3XXX_LEFT_CHN_AGC_1,
 		     ADC3XXX_RIGHT_CHN_AGC_1, 7, 1, 0),
 	SOC_DOUBLE_R_TLV("AGC Target Level Capture Volume", ADC3XXX_LEFT_CHN_AGC_1,
-		     ADC3XXX_RIGHT_CHN_AGC_2, 4, 0x07, 1, agc_target_tlv),
+		     ADC3XXX_RIGHT_CHN_AGC_1, 4, 0x07, 1, agc_target_tlv),
 	SOC_DOUBLE_R_TLV("AGC Noise Threshold Capture Volume", ADC3XXX_LEFT_CHN_AGC_2,
 		     ADC3XXX_RIGHT_CHN_AGC_2, 1, 0x1f, 1, agc_thresh_tlv),
 	SOC_DOUBLE_R_TLV("AGC Hysteresis Capture Volume", ADC3XXX_LEFT_CHN_AGC_2,
-- 
2.53.0




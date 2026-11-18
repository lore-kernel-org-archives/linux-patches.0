Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042036;
	b=gtFnJ6AbmywQlj8zMVAjqqV+l1IcJeBgrXvuywSMS7K89XXy/kigp2GBpoIjaaKliQyu
	 8uweZh2v/iaCwmuUqQOujmCzQDGhuThG0KrMA41JY6LgFhD2iBv26nqdj1PZgpYTtn7Ls
	 DcZRPM2RpRiyOLHE0FPVm+0dHDIw85VqfTVf5zUbjrf1/Gwgs/xZlFnx5hC5tKUDJiPED
	 lLamLa3Xv21RjyKA2VXgpIwmZYPnbRbQE/Uw2NM1e7jkRxr+Agt9MPEKESURIiokB2axd
	 8k7XBq5o3cUh+8ji3lqKRSJzsRVtjxrV2/GA+6EldH+Bhwy/9Y+HdLBWgHeKOF6ciJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042036;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rFzAle9lPlwnvBiqwzMvlO81ztoxvJ7nnA4nQrZWRo0=;
	b=TGQM4ClaYos9HwVVMJiklq0KzaZZDTfokdpOb14IwgrTPijOCY5HhRheIxlL5/tpqnPF
	 cpjkBi3GT6EMO5ba5Tg4hPG0Vfc6weLRoWau4Pq7w5iSPtvUhOeVxaWMMyNhZGExjVNRu
	 6MqOOGvsWWXiCCt/b4Jai1F2CwOmg7MLmugnku/PQZ63UpOlifopNs8922kJQMaxC35LQ
	 SSVumVKYbNd3xG0yPliT6lK1I1C/IwqBYyRsOKo+QuULHfjau1BvhO2iWPAUjCJ02xPny
	 BhzWc5aD7CJkt8LE/7s9Cj3TNmbOWH586KwwKbV7/YO5OFAvl4MCAKhQmK/z8K11djQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ogPdmK2P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13676606A320;
	Wed, 18 Nov 2026 22:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ogPdmK2P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 620681F000C6;
	Wed, 18 Nov 2026 22:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042035;
	bh=rFzAle9lPlwnvBiqwzMvlO81ztoxvJ7nnA4nQrZWRo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ogPdmK2P2MG+L7cEpMW04npc7XxKqPYfadQ9tD4TLHjsOxe/QOR4g/jKNrMj5wHQo
	 wdyJAjmebZ946arN59Mzfow8t0IIhPtgf7QKaqoSLZYC4o7u8XN3k6UQRkled2wnZz
	 ZgW5H3Qc54rwaXx7jTA+xySb/aAa4NXk0yq1cy9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2986/3318] ASoC: codecs: tlv320adc3xxx: Fix definition of AGC Target Level control
Date: Wed, 18 Nov 2026 16:00:08 +0100
Message-ID: <20261118150449.852541221@linuxfoundation.org>
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
index e100cc9f5c192..ea3d0a6244cee 100644
--- a/sound/soc/codecs/tlv320adc3xxx.c
+++ b/sound/soc/codecs/tlv320adc3xxx.c
@@ -690,7 +690,7 @@ static const struct snd_kcontrol_new adc3xxx_snd_controls[] = {
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




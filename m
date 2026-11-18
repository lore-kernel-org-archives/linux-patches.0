Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050216;
	b=kgTnSmBdYkVFFVQfmag+xXZK5Q1y1eIKFggRG2fh2bJ3twr09vSiKt0QlMJ1W1sXbnOS
	 iQ93tCXEIAWXui6CprWOC8HyQR6zy1jb8zhedjjWa6fXXRtmV3v7OoVU/woEfaSEA+H/Q
	 ylY42/pwSXkIuWV6554+1XHmdIcbHdgfNnCuC3OK4l87ZOEv8/0tQrmuYWig8V7B1uXql
	 SYwFNnkS1+bPGdpNUltAcnITdondgq+Q0GJ79nvQ6DVkrj8l7ceydLBXfhy1//7DOTc45
	 Zn6rP+Z1ciVKAPtVBPTEBhgsGxZwk1A1JEZHcuJfYnw6mseHDwfmDADbfC+qMWh48fA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050216;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w95ZoHIDVjAGqT6Q/qjkHSFdkI2ZhHxmw8nGQCAoj4Q=;
	b=qDrtcRf2ghOCNBL4vkfomJk0vNdPLJBE4HtGD7g340dH61TCYN36S7ek4eArm8wK/ee3
	 BRLqAlp+OcWJ6SsfPxNotXlX3a9pXjnmxneyHWXbh1ZJF8ONTxu/hrZgE5bw+9+cIYrh2
	 hWMDgNE/8AHxLWY0Tf0E3i2sQM2M+qBCBcDMo935WQBpIfocDF1tQV6Enue0BU5JZCAew
	 AEfah5GH/8SVA41wRsG3xAz2eCV8MJ3AKvKMUz0BISeqMVSTVLTqijzlDy6xbmHQzc1gg
	 F+bSZQk1M3dy8Q8qesf0RhpSg/3iYUmJir7Qj7ioBx5FbreYRFzcftKHYq1h0XTXovw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zK7VpX9v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A6D4606A320;
	Thu, 19 Nov 2026 01:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zK7VpX9v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C740F1F000C4;
	Thu, 19 Nov 2026 01:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050216;
	bh=w95ZoHIDVjAGqT6Q/qjkHSFdkI2ZhHxmw8nGQCAoj4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zK7VpX9voPVfW6Qi1KRXFlOoHOezTPcEDHFwi4jUN4ax0nR+1vgjBzp5TckUaBVAO
	 0IHtV2pNMkqxiO2P2+u458EKhFsSyUYJANEc3xqIFCEoWtp1VIyLw1y6qgEew8KY1X
	 v0qquOwknEX6UEZHTJqBhohgWCRMJCyldnB9WP1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2578/2857] ASoC: codecs: da732x: Fix definition of ADC2 EQ Overall Volume control
Date: Wed, 18 Nov 2026 16:00:12 +0100
Message-ID: <20261118150334.321613013@linuxfoundation.org>
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
index 2c5b0b74201c7..9b167e6cb8388 100644
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




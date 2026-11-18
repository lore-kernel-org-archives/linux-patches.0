Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040349;
	b=0/gsfkfzkOhIctq3QVaZVwbMVFLt8txEE8pal6oyiRJpamB6LgtbBxatWTe1F5QxgXgC
	 XpqMaej5DEaAtX92Q3WCq74TC91hoyOtr6PRiCcKYsJu6zNuxwX5joE2UfkUba5REBhof
	 9nHlx+41qacadtGuRtfoUnxcVucH/lXKYsaFawDQxvNAxlQhZWkX9XkArjaaLy6WKHTDP
	 Sc/Um+aax4FfYGCLlBYXe5rvIX4YUcJykV/HIWIL9Jmh0VAOGAN3QcicZKfKogwgR/JMT
	 feMkS0o82YmfT0iSs4IUzGpf+pZHTCe8YggPEk2O9x+/r05apQb06emXkaXLqf46tjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040349;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5qNk3Ev6RNwTDRUo0SO2Wgc+WZz42ZM938l759kKrfw=;
	b=ml5BdEn0AqYqimHxwwQl0jPrRbson8U4f6PdB39hNHKuvenW1nqT55e9825JVyuqOwHr
	 eiiVh/bEBbgnQxwHaYTAGlmjRFCIR3oxpsQyaZaCnyiB5vWN/24s8mIG8UmQHqMm4dW3A
	 joDRweFMc1b2/sMjWd93maesi/Cy1+fLGQ+KaX8VG1qW5d71ops6lb2zH9JH7jRlMbh68
	 O27+i7amyIgSTZw4QchrM+SSkO/Ps6LdxXmXdaAT24At3pksP/iuGJxkWjlKq0ZVln/ZX
	 dVR9TU9yjRHnHx/QN90b4rTZ1sv8DOU0On55OC2rQsuEPKG9VCwWyTCr1hqAvLTQPMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=StcSSniA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20995606A32A;
	Wed, 18 Nov 2026 22:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=StcSSniA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EE2F1F000C4;
	Wed, 18 Nov 2026 22:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040349;
	bh=5qNk3Ev6RNwTDRUo0SO2Wgc+WZz42ZM938l759kKrfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=StcSSniAEbcxPhPcY5IEy341OkVmAH1m6jI/zV/jjxS0njiDnfSv4HTtG+bZeOEO3
	 pXB3dp0qWYojEz8/0if1C24Tltgh4anRpiunybGuII8slMmFJKJ2CzHdCC0tNGeJ3x
	 sJ6m3ShCEsNbQ0jw6H/+Jd1Zq4hCDC32x6bIcIes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2425/3318] ASoC: mediatek: mt8192: mt8192-afe-gpio: Use guard() for mutex locks
Date: Wed, 18 Nov 2026 15:50:47 +0100
Message-ID: <20261118150434.217988951@linuxfoundation.org>
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

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 14edf39daefbf7aa689ea2bb8811a85c498e0ff6 ]

Convert the explicit mutex_lock()/mutex_unlock() pair to guard(mutex)
to simplify the locking logic and automatically release the mutex on
all exit paths.

This changes the mutex release point from immediately before dev_warn()
to automatic cleanup at scope exit. However, the affected path only emits
a warning and immediately returns -EINVAL, without any further processing.

Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260610102021.83273-6-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 411be3902fa8 ("ASoC: mediatek: mt8192: Propagate errors in mt8192_afe_gpio_request()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8192/mt8192-afe-gpio.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/mediatek/mt8192/mt8192-afe-gpio.c b/sound/soc/mediatek/mt8192/mt8192-afe-gpio.c
index 165663a78e36a..88dca80cd69c7 100644
--- a/sound/soc/mediatek/mt8192/mt8192-afe-gpio.c
+++ b/sound/soc/mediatek/mt8192/mt8192-afe-gpio.c
@@ -209,7 +209,7 @@ static int mt8192_afe_gpio_adda_ch34_ul(struct device *dev, bool enable)
 int mt8192_afe_gpio_request(struct device *dev, bool enable,
 			    int dai, int uplink)
 {
-	mutex_lock(&gpio_request_mutex);
+	guard(mutex)(&gpio_request_mutex);
 	switch (dai) {
 	case MT8192_DAI_ADDA:
 		if (uplink)
@@ -297,11 +297,9 @@ int mt8192_afe_gpio_request(struct device *dev, bool enable,
 		}
 		break;
 	default:
-		mutex_unlock(&gpio_request_mutex);
 		dev_warn(dev, "%s(), invalid dai %d\n", __func__, dai);
 		return -EINVAL;
 	}
-	mutex_unlock(&gpio_request_mutex);
 
 	return 0;
 }
-- 
2.53.0




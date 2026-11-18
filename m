Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058222;
	b=SFtQJyF5+/uZinO9m7k8NOkxeSQ3hVrg5+CzZK+lKlE3joNC0gWQzujTTlGfRJKgQR9D
	 Pvu0qKF7ZquxtIxXFNNw/FSZhaUdpLT16jMFeVdt7zykI2Y8gK0Dznf69XT+oNkOgm5Po
	 8MpxfTkJfLf5WtxtevHxsoY3GVvDAn8B3EDlkBDV5RTjJHf8eJMT9rnDRAlXyIxtTxURP
	 3W31+3a0YwLEVASjR6kSowASTwzQMsPMyZr69t32s/mGCMgwLj+c1PUl5hcAMXebrafYb
	 ptgHuWOTf5a33k4uAq8M7V7/izC5sDZGtkPIgOqYe+/n2sxAQIe7bCoA/5NQndnpdPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058222;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QQ3YQsdDEk+g2X6zM6jlC3K7xm5VRSMJsRDUCgZyVhk=;
	b=fWAhO9O/V+xb2RT4lW3WPoBmnGQ8CSB8IQVyD7hDuUBYh4BkkfttHkcrnoHH/W9SSNjn
	 4aDcSWMckAcWitQ32oILxfM06jGpu2wK4yF4Re8C/k4CXwu3LijnDOkg23tEIaEJ6m7yS
	 HCefCm5h5uOnROcqH/+yNsX+IwPnTbbLxZAiW/5f9U72Gkwot9j/3qkJe5tFCfuDidbme
	 4RgL1ARBT05jd6trLG2M80uZSt08786J9H1InXuodviwExtr8pzi42EOjY2bInuO+nc7u
	 HHd1P7M3iN1Du1eFybath/Jc6FlZjB98BLE+H6wcoO53wyOS1POMNUCo5SvPndkg6mA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kBF9Rt8d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E05B606A320;
	Thu, 19 Nov 2026 03:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kBF9Rt8d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FF891F000C4;
	Thu, 19 Nov 2026 03:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058221;
	bh=QQ3YQsdDEk+g2X6zM6jlC3K7xm5VRSMJsRDUCgZyVhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kBF9Rt8dPl3b2OtLMxkVjc2y7K+U94+5mS/P1MrWLhAxmFdVx7gC2mLjymYcFesSm
	 T3Tbzn5W3MPEbovwCbAAD9V6UGsKU0qnwm8FCTmlvU2wMkfDDMR74OnR6ml0G7TdJr
	 qvwy2ckOmto2CqMS/DTcxR3//jRzWu61e5e3w/To=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0410/1848] ASoC: codecs: wm8994: Fix runtime PM leak in wm8994_mic_detect()
Date: Wed, 18 Nov 2026 15:40:48 +0100
Message-ID: <20261118145931.064064168@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit b2c0e5bf750e33b0e1dcdfbb2df8103a06c7caab ]

wm8994_mic_detect() resumes the component before configuring the MICBIAS
pins, but the default case of the micbias switch returns -EINVAL right
after taking that reference, skipping the pm_runtime_put() on the
success path. This leaks a runtime PM reference on every call with an
invalid micbias.

Release the reference before returning -EINVAL.

Fixes: f5a2cda4f1db ("ASoC: wm8994: Ensure the device is resumed in wm89xx_mic_detect functions")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260917165130.2163278-1-vulab@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8994.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/wm8994.c b/sound/soc/codecs/wm8994.c
index 0b4c3c37c7e99..2cfe067a9d823 100644
--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -3533,6 +3533,7 @@ int wm8994_mic_detect(struct snd_soc_component *component, struct snd_soc_jack *
 		break;
 	default:
 		dev_warn(component->dev, "Invalid MICBIAS %d\n", micbias);
+		pm_runtime_put(component->dev);
 		return -EINVAL;
 	}
 
-- 
2.53.0




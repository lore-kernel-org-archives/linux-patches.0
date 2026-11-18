Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035967;
	b=Nhmi649j4UawKFLQOg1ZzX/5p1OWIuesDzi6D1X3eD6ZdHNouFN45tiWt6aBr7zvDh1G
	 F8ts6YlV3Ae1lVkmI/FwssAB9MzGuv73qlNXAKUkfnwGJQZSuHRsh/knVgzejoqb9uSAW
	 0qlXVlWI7uiYJMrAKLrZt5vYLJQqTk0VxkzPWXH75Xtw2H7f9MGA4hOxRwr5k/xrBhSGe
	 C1sY9HYIE8eJwGUgprid5VL5BZayGDfZc9+8JNXDSoh06F6X47lRRgyV3Yx7OTuiujc0m
	 vmeC1LOOctffSyGB5SdG42kH6Zx4wsi1AeQRBdDhvQHvfhtTOrZSr3mxqkh/mARaKkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035967;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1rklVk3IGLQG4VJ+CdIWwFqj6k2ZVIT4Cwm4mNVHauo=;
	b=pF4b5tGxn7RWZ1ZebluTD/BU6IVqWmu6rvdrWSf6vxAC7XNIfLdXnmn5Ycj/oDIdLfg9
	 A4DREi5+eFT+FwT5PXJAbW2+SGzlJQwE7poweE/WhH0T7us8gaVRY5Q3oxpzbvRl+L3Wv
	 xwXQJz63pbqkgaX34DROc/fPdyuzVXKFv8GFdULZuKDKa4dDCF7eh/GZsDIn4b3Zdjgdr
	 P9z3NaFCdhLwdPG2ZeFjhwt4Lzvs1DkXuqbV22+Vi/honFHJvlxZjnTknRaBigqjfR00F
	 Q2iBpyiEFHXhqek09rUmBhFS1V3IMplDFjg1jTTiwfF/hX9VrznDuRc+25c1c25BaUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OQRl74x6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6C84606A325;
	Wed, 18 Nov 2026 21:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OQRl74x6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2468D1F000C4;
	Wed, 18 Nov 2026 21:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035967;
	bh=1rklVk3IGLQG4VJ+CdIWwFqj6k2ZVIT4Cwm4mNVHauo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OQRl74x6ZcHJDSJoEgpxi3sqoETd69ljV8+61r/RZOpUnRDJZ8QdlUgV6XvuPpybv
	 eqvzgxodMT7M5Uomf1GYvvRuLEiDoGSJ/zETfi8SPI27EYLfrmUAmLeupkjVkBt2oT
	 opBqHjouhpqa/8z962JQF36Wj6l0tgi18LM3bang=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0892/3318] ASoC: codecs: wm8994: Fix runtime PM leak in wm8994_mic_detect()
Date: Wed, 18 Nov 2026 15:25:14 +0100
Message-ID: <20261118150346.190681197@linuxfoundation.org>
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
index 4558b0dd0c072..5c7d55212838d 100644
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




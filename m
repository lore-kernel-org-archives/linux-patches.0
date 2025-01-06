Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 295F11DDC3C;
	Mon,  6 Jan 2025 16:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736179234; cv=none; b=Z8f+EgZI4/LR++wAMY8EpsMk8Sg5YR7lN5A9yrcTMyFQTdcQ1z4uHl3zfV7hHsnhW4+W4Z4qCyV2PuERFJo2o5r3mG+wzZ/73MjbkqVDrMa2u5cxE9CWqrfgHalZScaYCYnA7P1jN5qrxIOAAYIzskDKnW4CjeaKPe2yAUyQh+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736179234; c=relaxed/simple;
	bh=kcNb69z0vbkFBmF2Ms05vNs2fEP/XZNbbB+BCktxxro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CYM8GcqN+OEa9THE91Qagxa8ykRE1QzEsTvP6j5fYeW962D8qwCQSravxJ0QkHlebaytoRj6WKuF571cBzl3oDBaj7kEJa/q+LBBLVwSFsN7arZ6KNMfWvmHrxkbnItC6Alo8NbrXO4GT0FWqHR3fjQ9N5IjkFiph1s1ozTCF6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=krKfnWb+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="krKfnWb+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CCECC4CEE1;
	Mon,  6 Jan 2025 16:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736179233;
	bh=kcNb69z0vbkFBmF2Ms05vNs2fEP/XZNbbB+BCktxxro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=krKfnWb++QGFME2KGLzBiTDyU125Hlk9OuxP0aomHmDqrJpxqnG7kBHCPvyx/e6BK
	 C8iDlLjx/PpOwmwEx5CAuyNTxyITgUYxlYOeYrG7IpcSQRE5yU4DYvq4wUOXJiYUPi
	 vuJTEUtd6Q1iAaEPoIYYHlqZkFasa2997ygD2plk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bogdan Togorean <bogdan.togorean@analog.com>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 70/93] drm: bridge: adv7511: Enable SPDIF DAI
Date: Mon,  6 Jan 2025 16:17:46 +0100
Message-ID: <20250106151131.347097888@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151128.686130933@linuxfoundation.org>
References: <20250106151128.686130933@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bogdan Togorean <bogdan.togorean@analog.com>

[ Upstream commit f7f436b99364a3904387eba613fc69853cc2f220 ]

ADV7511 support I2S or SPDIF as audio input interfaces. This commit
enable support for SPDIF.

Signed-off-by: Bogdan Togorean <bogdan.togorean@analog.com>
Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>
Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200413113513.86091-1-bogdan.togorean@analog.com
Stable-dep-of: 902806baf3c1 ("drm/bridge: adv7511_audio: Update Audio InfoFrame properly")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/adv7511/adv7511_audio.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/gpu/drm/bridge/adv7511/adv7511_audio.c b/drivers/gpu/drm/bridge/adv7511/adv7511_audio.c
index d05b3033b510..f101dd2819b5 100644
--- a/drivers/gpu/drm/bridge/adv7511/adv7511_audio.c
+++ b/drivers/gpu/drm/bridge/adv7511/adv7511_audio.c
@@ -121,6 +121,9 @@ int adv7511_hdmi_hw_params(struct device *dev, void *data,
 		audio_source = ADV7511_AUDIO_SOURCE_I2S;
 		i2s_format = ADV7511_I2S_FORMAT_LEFT_J;
 		break;
+	case HDMI_SPDIF:
+		audio_source = ADV7511_AUDIO_SOURCE_SPDIF;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -177,11 +180,21 @@ static int audio_startup(struct device *dev, void *data)
 	/* use Audio infoframe updated info */
 	regmap_update_bits(adv7511->regmap, ADV7511_REG_GC(1),
 				BIT(5), 0);
+	/* enable SPDIF receiver */
+	if (adv7511->audio_source == ADV7511_AUDIO_SOURCE_SPDIF)
+		regmap_update_bits(adv7511->regmap, ADV7511_REG_AUDIO_CONFIG,
+				   BIT(7), BIT(7));
+
 	return 0;
 }
 
 static void audio_shutdown(struct device *dev, void *data)
 {
+	struct adv7511 *adv7511 = dev_get_drvdata(dev);
+
+	if (adv7511->audio_source == ADV7511_AUDIO_SOURCE_SPDIF)
+		regmap_update_bits(adv7511->regmap, ADV7511_REG_AUDIO_CONFIG,
+				   BIT(7), 0);
 }
 
 static int adv7511_hdmi_i2s_get_dai_id(struct snd_soc_component *component,
@@ -215,6 +228,7 @@ static const struct hdmi_codec_pdata codec_data = {
 	.ops = &adv7511_codec_ops,
 	.max_i2s_channels = 2,
 	.i2s = 1,
+	.spdif = 1,
 };
 
 int adv7511_audio_init(struct device *dev, struct adv7511 *adv7511)
-- 
2.39.5




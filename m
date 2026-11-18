Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023774;
	b=hWZRoKFB5c/W8vhN8xU7tNqRr/6rFTC8rxyMyd2hEeCNIieekReqzmv2HoRnbZafzSkP
	 0B7RYXJjsmvWfQtOr2ZDVy9/zoCOnvJxPM7QH6As+GIvr1iZPKS7b/fOXqfxy5XJ7TSN1
	 cSQ5hPAY2ap61CwZS664W3QfVFGTZvKEyzu3bx2MiJz66MYJPQYYqOGIbU4zjTQbN1hLw
	 Ll1imMK6fp5HPpQD7Yaq3JGEjg1m9ycNdw/7QC1g1d/VXKQgxz4NxVkIXSM7thQ4qFpj3
	 jrjH4AfWdl4KLwKptDAFFvZgRIkIV3bdK+tlrpVKs7rW9aente41xiHYcTHICvLPGmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023774;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CDxUMLF5BMm+uoi78O3ehq/mU13cUuJXnlr3wCj0x9w=;
	b=jDtMi2/IiIGXfOwPcm3NbHiikobYWp5zQwQws6LZs9xWNo4cIA6l+aK41THdeYzUIQYr
	 AD4OgaAVPjCZEZHwPwoLY09aDOKloRlaicHnmxPrNQtEX4nq15+ZyIIVYgqCqCgXSVxsG
	 gWTgOlYDrgD4mgxfuCdd+NhqwhP/uKgfGrvYeDgMgOxCCEJYoSsE80iKbBRULyBQewfr6
	 v3f+Xxcf7Dk3cHycZYBdX0tdzUWJEBsRCcda9cH3EAt1CFHL2dZEbl8tHwkXuXVVu3yBa
	 gHl1nIGgEhBT+f6CMHjVyYstGRmftey8132osBM0T1ocxkgyxbW8CEGU9ae6SUymcyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iHHcHhfb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6959A606A320;
	Wed, 18 Nov 2026 17:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iHHcHhfb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EF831F000C4;
	Wed, 18 Nov 2026 17:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023773;
	bh=CDxUMLF5BMm+uoi78O3ehq/mU13cUuJXnlr3wCj0x9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iHHcHhfbTAZPWXgPfAV0rr55oaH8yeI2U4lQMy5kBdpVF9RiC6ha2C5jzzIRRX0/9
	 CFXyiXiPeXlq0mJsMjtJhCSOUKrvaXK8zh9P/DUr17NTM6zRdL45PlltmQKbCz6n8E
	 P2GFSG39uvvRvYwwojODK75v+vRmOxcCyrJX24WU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0472/2151] ASoC: codecs: rt1015: convert to snd_soc_dapm_xxx()
Date: Wed, 18 Nov 2026 15:36:47 +0100
Message-ID: <20261118150139.203595642@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit 8b1c56ae39d3bf304ab0c8de456e8f02081be9ed ]

This patch converts below functions.

dapm->dev					-> snd_soc_dapm_to_dev()
dapm->card					-> snd_soc_dapm_to_card()
dapm->component					-> snd_soc_dapm_to_component()

dapm_kcontrol_get_value()			-> snd_soc_dapm_kcontrol_get_value()

snd_soc_component_enable_pin()			-> snd_soc_dapm_enable_pin()
snd_soc_component_enable_pin_unlocked()		-> snd_soc_dapm_enable_pin_unlocked()
snd_soc_component_disable_pin()			-> snd_soc_dapm_disable_pin()
snd_soc_component_disable_pin_unlocked()	-> snd_soc_dapm_disable_pin_unlocked()
snd_soc_component_nc_pin()			-> snd_soc_dapm_nc_pin()
snd_soc_component_nc_pin_unlocked()		-> snd_soc_dapm_nc_pin_unlocked()
snd_soc_component_get_pin_status()		-> snd_soc_dapm_get_pin_status()
snd_soc_component_force_enable_pin()		-> snd_soc_dapm_force_enable_pin()
snd_soc_component_force_enable_pin_unlocked()	-> snd_soc_dapm_force_enable_pin_unlocked()
snd_soc_component_force_bias_level()		-> snd_soc_dapm_force_bias_level()
snd_soc_component_get_bias_level()		-> snd_soc_dapm_get_bias_level()
snd_soc_component_init_bias_level()		-> snd_soc_dapm_init_bias_level()
snd_soc_component_get_dapm()			-> snd_soc_component_to_dapm()

snd_soc_dapm_kcontrol_component()		-> snd_soc_dapm_kcontrol_to_component()
snd_soc_dapm_kcontrol_widget()			-> snd_soc_dapm_kcontrol_to_widget()
snd_soc_dapm_kcontrol_dapm()			-> snd_soc_dapm_kcontrol_to_dapm()
snd_soc_dapm_np_pin()				-> snd_soc_dapm_disable_pin()

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/87bjl94drz.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 98fe8aab04ce ("ASoC: rt1015: make control calibration failures observable")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt1015.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/rt1015.c b/sound/soc/codecs/rt1015.c
index 818b45226b728..bd0b1d3c829dd 100644
--- a/sound/soc/codecs/rt1015.c
+++ b/sound/soc/codecs/rt1015.c
@@ -494,9 +494,10 @@ static int rt1015_bypass_boost_get(struct snd_kcontrol *kcontrol,
 static void rt1015_calibrate(struct rt1015_priv *rt1015)
 {
 	struct snd_soc_component *component = rt1015->component;
+	struct snd_soc_dapm_context *dapm = snd_soc_component_to_dapm(component);
 	struct regmap *regmap = rt1015->regmap;
 
-	snd_soc_dapm_mutex_lock(&component->dapm);
+	snd_soc_dapm_mutex_lock(dapm);
 	regcache_cache_bypass(regmap, true);
 
 	regmap_write(regmap, RT1015_CLK_DET, 0x0000);
@@ -518,7 +519,7 @@ static void rt1015_calibrate(struct rt1015_priv *rt1015)
 	regcache_cache_bypass(regmap, false);
 	regcache_mark_dirty(regmap);
 	regcache_sync(regmap);
-	snd_soc_dapm_mutex_unlock(&component->dapm);
+	snd_soc_dapm_mutex_unlock(dapm);
 }
 
 static int rt1015_bypass_boost_put(struct snd_kcontrol *kcontrol,
-- 
2.53.0




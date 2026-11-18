Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026260;
	b=29yMRnWMVOgnkjgWoXRF29DADNJ7xwgP7LAOiB8xWk2ELEP6UYbPFd8CgvS8K2BBVk7y
	 oxYMBR/llyKJO5j0rYBDSPLRJHlqXUXA43viqSjEq3QXan8VxY0rOoMuLblb9GXLPcpeW
	 RrbJh2bVOwciSHCcXcJQWPDiaQMTK5dWg1qV6912zSE/aU3Bx9SxmmWt04KwTDA8s/9Uo
	 qfm3zIEOFmsEwnaA06deUZoYYMRbRphAiPchrr5tCnTlSvm/V1s3KplV9jG6h2uD2gs4s
	 6AGuhTScgzoNsZVfjgACapZw8PWZsg3tfsfNbNQn7/eqQd0B61n3VGlguADDN4DsM/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026260;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gusLiz0s/GZJ309vAeTIJxArnIf1bWguCJ5gCIi6OUM=;
	b=22FGSQLzl2czwGMvNcUqek9bceBY0eLRhs+qeRBKCu4WWZa91J/nHQe5jB3M3grGeNQx
	 BCIKYdF4wDMrh6yTEaU8AwviGK0qWJiuYt3S3qdMm+aC4gxAmf734CeIJ5oZUBKYgvF+y
	 9veXpnh/J1uo8KF0wYeYWd/VLLUI+LKKWCeVPAPqqvz+zXDafVCcMs2qP8WXjNHdQp0fj
	 /AZNAScJGxArLFiLsOj83B4QV2nBwLW0/dyIDJ/Xcox+E+4Pk02MVNgEwkZVfVXwG+Zup
	 8YT4q9EHVzp2oLSx7GsDQa9/xQGiDoehTbur0RTUYhObvEOMZAxnxBasV+lO7uR7bbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yPzXeNgv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D93F606A32C;
	Wed, 18 Nov 2026 18:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yPzXeNgv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0FCD1F000C4;
	Wed, 18 Nov 2026 18:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026260;
	bh=gusLiz0s/GZJ309vAeTIJxArnIf1bWguCJ5gCIi6OUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yPzXeNgv5w35gmXVeYF1l+XwFzgfd2qKw3DVEmTMonn5wLSg71xcm8cBagmMnCB7I
	 U31NH4RKtFEYC+kBkHnSiZW6zjIWzUwL3VQeFIFhvOsnOYb2fEy/9DDo2kgrtbN0iZ
	 DJtIByw8FNbTQb3UXWAdho7O7sA/IfTVCIA7/skU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joonhoe Kim <26rote@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1370/2151] ASoC: codecs: wcd939x: read the SoundWire port switches per channel
Date: Wed, 18 Nov 2026 15:51:45 +0100
Message-ID: <20261118150211.930362370@linuxfoundation.org>
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

From: Joonhoe Kim <26rote@gmail.com>

[ Upstream commit e7860dc5d8d45f6a0e98bfe542c7b776c5ede2a4 ]

The "HPHL/HPHR", "ADCn" and "DMICn" switches are channels of shared
SoundWire ports (ADC1-4 are channels 0-3 of the ADC_1_4 port), but
wcd939x_get_swr_port() reports a per-port flag. Once one channel of a
port is switched on, every switch on that port reads back as on:

  amixer cset name='ADC1 Switch' on   -> ADC1..ADC4 Switch all read "on"

Setting one of the others then looks like a no-op to userspace, and
"alsactl store" saves all of them as on, so a later "alsactl restore"
really enables the unused channels of the port.

Read the channel's own bit in the port's channel mask instead, drop the
now unused port_enable[] and return 0 from the put handler when the
switch does not change, as ALSA expects.

Fixes: 10f514bd172a ("ASoC: codecs: Add WCD939x Codec driver")
Link: https://lore.kernel.org/all/20251124064850.15419-6-jonathan@marek.ca/
Assisted-by: LLM
Signed-off-by: Joonhoe Kim <26rote@gmail.com>
Link: https://patch.msgid.link/20261007123954.1709-1-26rote@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wcd939x.c | 10 +++++++---
 sound/soc/codecs/wcd939x.h |  1 -
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/wcd939x.c b/sound/soc/codecs/wcd939x.c
index e74e6f0131318..6068e2a9ed913 100644
--- a/sound/soc/codecs/wcd939x.c
+++ b/sound/soc/codecs/wcd939x.c
@@ -1793,8 +1793,9 @@ static int wcd939x_get_swr_port(struct snd_kcontrol *kcontrol,
 	struct wcd939x_priv *wcd939x = snd_soc_component_get_drvdata(comp);
 	struct wcd939x_sdw_priv *wcd = wcd939x->sdw_priv[mixer->shift];
 	unsigned int portidx = wcd->ch_info[mixer->reg].port_num;
+	u8 ch_mask = wcd->ch_info[mixer->reg].ch_mask;
 
-	ucontrol->value.integer.value[0] = wcd->port_enable[portidx] ? 1 : 0;
+	ucontrol->value.integer.value[0] = !!(wcd->port_config[portidx - 1].ch_mask & ch_mask);
 
 	return 0;
 }
@@ -1820,10 +1821,13 @@ static int wcd939x_set_swr_port(struct snd_kcontrol *kcontrol,
 	struct wcd939x_priv *wcd939x = snd_soc_component_get_drvdata(comp);
 	struct wcd939x_sdw_priv *wcd = wcd939x->sdw_priv[mixer->shift];
 	unsigned int portidx = wcd->ch_info[mixer->reg].port_num;
+	u8 ch_mask = wcd->ch_info[mixer->reg].ch_mask;
+	bool enable = !!ucontrol->value.integer.value[0];
 
-	wcd->port_enable[portidx] = !!ucontrol->value.integer.value[0];
+	if (enable == !!(wcd->port_config[portidx - 1].ch_mask & ch_mask))
+		return 0;
 
-	wcd939x_connect_port(wcd, portidx, mixer->reg, wcd->port_enable[portidx]);
+	wcd939x_connect_port(wcd, portidx, mixer->reg, enable);
 
 	return 1;
 }
diff --git a/sound/soc/codecs/wcd939x.h b/sound/soc/codecs/wcd939x.h
index 6bd2366587a8f..dab7ef108b485 100644
--- a/sound/soc/codecs/wcd939x.h
+++ b/sound/soc/codecs/wcd939x.h
@@ -899,7 +899,6 @@ struct wcd939x_sdw_priv {
 	struct sdw_stream_runtime *sruntime;
 	struct sdw_port_config port_config[WCD939X_MAX_SWR_PORTS];
 	const struct wcd_sdw_ch_info *ch_info;
-	bool port_enable[WCD939X_MAX_SWR_CH_IDS];
 	int active_ports;
 	bool is_tx;
 	struct wcd939x_priv *wcd939x;
-- 
2.53.0




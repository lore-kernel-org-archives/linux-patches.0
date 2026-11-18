Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019641;
	b=Qp0HfGEvP2k+4aUmZBI7HgdMV/a3/iy0Lp9qSWI9128TqIAjFNERmjJRsLKbLdy5TVd6
	 ERQSxpJcFStBr59Nbn3tZ8c9pKhHNl+q4UJKUgfE93Hhh/y/XNRvYNdzAJ5pxBMyWaxsH
	 95V6lEFXqiV9NfHkHjFc492d1013iF3cWk53PRdwSyOmiQrL2cw0+C4nfIFCGwR8jCQ6s
	 iYOANMdDa33kZyFK3w0ChKJVObjjDTYJChUeNEWYgH3ICteawtyi67I0sKgupIy+537XZ
	 BueGw75C8A0p+7MdMyE4CbFsAGqt3f9Ye4XVx8qHunZKdZOXZeIbpILsQ+4yTeH6IUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019641;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0Z5E6alAz9ej6/wBkHnzuYNodNoMszlZp7+a7yTfEbA=;
	b=U4vDalW2ICXIZdRaNx/rwZQoCE9hPsB/Q1i4KpuKbBdNhueMhuB/7E3ZYWDEW+aMauD+
	 4HvKTzz4NmsmOnxgvZIRMuYXb/cj/rZFxnF6Sr76BxCWOLpQy3nKONgHFTXlGlS+Pn8tY
	 HA2IpFO6+2T4vvINCOfZarV48RYZ82/t+Hmfi6awUJjt8raW3ZWzqXFrOh51/w0AGz1FH
	 D9Pvm1JuUx1qvE3oBFf/91dQWh+gOoeT96DmDhaYqFZjyvMZSNd/OLAUPBRohYNnJ9d3h
	 Av+FpcOReqN2pcUiRerpexD5R/8rWFHXi1U60xskQWtU4BoRqC3OVVQw/U69anD/wYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lwx39pz5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50539606A325;
	Wed, 18 Nov 2026 16:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lwx39pz5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A21C01F000C7;
	Wed, 18 Nov 2026 16:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019641;
	bh=0Z5E6alAz9ej6/wBkHnzuYNodNoMszlZp7+a7yTfEbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lwx39pz5C3DvccyYbElQZQ8iOmoHRfUnvZ7IOuBIxlHWhLclZlasKXEsxoqid67C5
	 R7FI4bB5JwCSnfov7nWsQFxMlIsINoJA632S5Tf99AqD9tbMLeq25y146v5feydbuT
	 VlSPb+aUVshFIm1LZah3VbD55s0h225s9C0OURgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joonhoe Kim <26rote@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1669/2651] ASoC: codecs: wcd939x: read the SoundWire port switches per channel
Date: Wed, 18 Nov 2026 15:48:29 +0100
Message-ID: <20261118150347.789930332@linuxfoundation.org>
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
index 26fe0b6313cdb..2d463f062e6d7 100644
--- a/sound/soc/codecs/wcd939x.c
+++ b/sound/soc/codecs/wcd939x.c
@@ -1794,8 +1794,9 @@ static int wcd939x_get_swr_port(struct snd_kcontrol *kcontrol,
 	struct wcd939x_priv *wcd939x = snd_soc_component_get_drvdata(comp);
 	struct wcd939x_sdw_priv *wcd = wcd939x->sdw_priv[mixer->shift];
 	unsigned int portidx = wcd->ch_info[mixer->reg].port_num;
+	u8 ch_mask = wcd->ch_info[mixer->reg].ch_mask;
 
-	ucontrol->value.integer.value[0] = wcd->port_enable[portidx] ? 1 : 0;
+	ucontrol->value.integer.value[0] = !!(wcd->port_config[portidx - 1].ch_mask & ch_mask);
 
 	return 0;
 }
@@ -1821,10 +1822,13 @@ static int wcd939x_set_swr_port(struct snd_kcontrol *kcontrol,
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




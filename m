Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625358;
	b=BjQQb5JO9kUsFDwaDLEKTwHnV9PfbOsxzV8y2xLbKalWST8BPTX6MhfFl2976Dp4ip4u
	 cCkL6BV5nTgcxPrkw4WtELcB5JLYsN9OLjKGYQQioZeBmFktdNZjGhbImM+ZuetPOijQ+
	 tfbPs3yyih3BnjREmzJMroDJWer67CslK200TWZD6Dj9Tv5z5YlTBjfvz0k94b+Ax7BWA
	 bumo/CP4piQycb4IMROw9qQ7ZLJt66/h7P7NCbvDv5zzGDndofCgDXlqy6BSJxT8VPgf4
	 SQCe6WlZzpVGgERVksYjDkmU9Q7DeolEvTHjRppfYmgJivwPR3LDaJwPDeA5IYtUSdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625358;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HfpG2RXts1GQSr16De6mfzJ1ye8rzb5BppvBMXeg4Y8=;
	b=DBQD9r7AZgFcuC5iMgpBPrsp0Sfp8hdHK+oX3S71MACmKrGDYeVgC+yOsxte0RC067/o
	 75efHN4PCW7KVmUheKco/B+WUXj079/h/aMMQjtaArLAqAxcXFRXLs53pxtbx/xcsozpx
	 qrDJJJiyKjNTQT2xQ8rqLTl1JGHJwQrWLjIWdxTk7uVxiNrjKk/LpasFK3qHIknwnSSez
	 a/2B4PTIfWXD9YwzardinhYXSlix6+fDBkJScUTPils0ujT9Os6Z/Lvetj9HATWbqJUtr
	 t4FAJBP5SxkYR+D7OZKlwik4I4kScO7AOZjykqI8RnB6TzcR77tk5f/SGF7mCHUuiSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UnNmiWvV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DBDD606A31E;
	Wed, 25 Nov 2026 16:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UnNmiWvV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5CA61F000C4;
	Wed, 25 Nov 2026 16:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625357;
	bh=HfpG2RXts1GQSr16De6mfzJ1ye8rzb5BppvBMXeg4Y8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UnNmiWvVUkikT90rld3noMkTSD9R4PczBjHQS4DtgPQVx0YQd59VYbGpdfcQsBxv1
	 nNMj20cWY1GhhVUHC2K/FqsnAzGl8I330mlDnPfKNjuRQU/gFygdqHCm7oT4dtv55X
	 35y8o4kCRptDMgzDcwDzkhoEhlSJkQE/dlEM7Oz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joonhoe Kim <26rote@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 490/816] ASoC: codecs: wcd939x: read the SoundWire port switches per channel
Date: Wed, 25 Nov 2026 15:33:58 +0100
Message-ID: <20261125143900.534473127@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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
index 4a417a92514d7..db634a6cdfbc4 100644
--- a/sound/soc/codecs/wcd939x.c
+++ b/sound/soc/codecs/wcd939x.c
@@ -1792,8 +1792,9 @@ static int wcd939x_get_swr_port(struct snd_kcontrol *kcontrol,
 	struct wcd939x_priv *wcd939x = snd_soc_component_get_drvdata(comp);
 	struct wcd939x_sdw_priv *wcd = wcd939x->sdw_priv[mixer->shift];
 	unsigned int portidx = wcd->ch_info[mixer->reg].port_num;
+	u8 ch_mask = wcd->ch_info[mixer->reg].ch_mask;
 
-	ucontrol->value.integer.value[0] = wcd->port_enable[portidx] ? 1 : 0;
+	ucontrol->value.integer.value[0] = !!(wcd->port_config[portidx - 1].ch_mask & ch_mask);
 
 	return 0;
 }
@@ -1819,10 +1820,13 @@ static int wcd939x_set_swr_port(struct snd_kcontrol *kcontrol,
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
index 3204fb10b58d7..ea6b46a996615 100644
--- a/sound/soc/codecs/wcd939x.h
+++ b/sound/soc/codecs/wcd939x.h
@@ -910,7 +910,6 @@ struct wcd939x_sdw_priv {
 	struct sdw_stream_runtime *sruntime;
 	struct sdw_port_config port_config[WCD939X_MAX_SWR_PORTS];
 	const struct wcd939x_sdw_ch_info *ch_info;
-	bool port_enable[WCD939X_MAX_SWR_CH_IDS];
 	int active_ports;
 	bool is_tx;
 	struct wcd939x_priv *wcd939x;
-- 
2.53.0




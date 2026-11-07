Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062006;
	b=fHFUF4yGRXXAQF792UqFTEArUPuOVAFdWg5Z6yVLs4ny5xJAhEJ6ogY9uK83UM2xQ8F7
	 TCSSJax0m8E8IbCmlFmfH9nLafBPFk9pGyWixPQnmjWAIpjWOjGvuiXIDh35wEYfk/Zd/
	 Vv4UTnCetYrwMAI7wPhtg0Kv17Ukc/oAuMNfqElPBkRqn8GtfTF5+V1SxRvfpo3rxW+t/
	 pS6LQv546dDZsxi/7aqBuVsMP2FxxKAw1UeaNjj4TUhGaarUbxil5F55JGggomoE3rXk7
	 ZkV+Vi3pA+Yd7loEqNQjQOAScNe3RN2TIi11Yj2cxpQRh1deXimY9JIynJgbtbyDScg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062006;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LhGzaPNwpn+fqPpXUXH9lrTe5uBW+zNf9tzSxYTzD6I=;
	b=0oM9KhFLxX5JZoDZmDDMlfcU+rIUqrg+Jh48HtpZcgEhHFydSq0JJhMjWigpyjLwckpA
	 Ca9f4czW9bALLV2pugMwOmuf53lvEcnjZXTAL/JLdSWoDgEElWL+25uGGGg2a8LfLOTXp
	 iohedchhwB4FU8In0gJkuqc536UW6NK6mluuv2Q9ds7T0cmru8zvpWwxaQ3Wp8pEP/+/m
	 UE6GLkHIcDGHToX0BrUSbPOa9MGDKfKKecPNI19rT9hIbE5GSKKZwVHyfjtAATCAN3MbL
	 aXZvYjb0HJy+galXHx2E3ROCciVVn53BpQsDG2t0VSAu+JfnxOZuZDrBvgKtkC5EdIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hzi4OmS2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3EEA606A337;
	Sat,  7 Nov 2026 14:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hzi4OmS2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 810621F0089F;
	Sat,  7 Nov 2026 14:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062005;
	bh=LhGzaPNwpn+fqPpXUXH9lrTe5uBW+zNf9tzSxYTzD6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hzi4OmS2vhSGGjDiccHSKdfBLUGjzsrb8wJBXv7dTU3iWynrvZXMoqb9Z8CQ8Rubh
	 P2MsUg3ckSAJJmkKXylgno/p9Rlhhvtk8Me5M5LtxpNftRgsTKSfSbyNdjyqdJOf/J
	 kQf2VGwXBu86OuvgO/DD4T7EsOd2Lwa8L+3S75lw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0947/1536] ASoC: codecs: lpass-wsa-macro: use v2.5 Compander1 addresses on v2.5+
Date: Sat,  7 Nov 2026 08:49:23 -0500
Message-ID: <20261107135024.254818746@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>

[ Upstream commit 233d36a96009682208cc4ca1139b9e5641a8bf09 ]

wsa_macro_set_spkr_mode() unconditionally writes CDC_WSA_COMPANDER1_CTL3
(0x5CC) and CDC_WSA_COMPANDER1_CTL7 (0x5DC).  On v2.5+ silicon these
registers moved to CDC_2_5_WSA_COMPANDER1_CTL3 (0x5EC) and
CDC_2_5_WSA_COMPANDER1_CTL7 (0x5FC); the v2.1 addresses are dead on
that hardware, so the update_bits() calls take a bus error:

  wsa_macro 6c90000.codec: ASoC error (-5): at
    snd_soc_component_update_bits() on 6c90000.codec for
    register: [0x000005dc]

The flat regcache had been hiding the read side of this by returning
the zero-initialised cache slot instead of doing a bus read, so the
error only becomes visible once the cache reports the miss honestly
and regmap falls back to a real bus read.

Select the correct address for Compander1 CTL3/CTL7 based on
codec_version.  The Compander0 and Boost registers used in the same
function have the same address across versions, so they stay
unchanged.  Also collapse the two mode branches to a single sequence
with mode-selected values, which is what the switch was doing anyway.

Fixes: 727de4fbc546 ("ASoC: codecs: lpass-wsa-macro: Correct support for newer v2.5 version")
Cc: stable@vger.kernel.org
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Link: https://patch.msgid.link/20260908082806.648797-2-srinivas.kandagatla@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/lpass-wsa-macro.c | 42 ++++++++++++++++++------------
 1 file changed, 25 insertions(+), 17 deletions(-)

diff --git a/sound/soc/codecs/lpass-wsa-macro.c b/sound/soc/codecs/lpass-wsa-macro.c
index 1f25630841e50..73c5f6a9e1453 100644
--- a/sound/soc/codecs/lpass-wsa-macro.c
+++ b/sound/soc/codecs/lpass-wsa-macro.c
@@ -1128,27 +1128,35 @@ static const struct regmap_config wsa_regmap_config = {
 int wsa_macro_set_spkr_mode(struct snd_soc_component *component, int mode)
 {
 	struct wsa_macro *wsa = snd_soc_component_get_drvdata(component);
+	unsigned int comp1_ctl3, comp1_ctl7;
+	u8 comp_val, boost_val;
 
 	wsa->spkr_mode = mode;
 
-	switch (mode) {
-	case WSA_MACRO_SPKR_MODE_1:
-		snd_soc_component_update_bits(component, CDC_WSA_COMPANDER0_CTL3, 0x80, 0x00);
-		snd_soc_component_update_bits(component, CDC_WSA_COMPANDER1_CTL3, 0x80, 0x00);
-		snd_soc_component_update_bits(component, CDC_WSA_COMPANDER0_CTL7, 0x01, 0x00);
-		snd_soc_component_update_bits(component, CDC_WSA_COMPANDER1_CTL7, 0x01, 0x00);
-		snd_soc_component_update_bits(component, CDC_WSA_BOOST0_BOOST_CTL, 0x7C, 0x44);
-		snd_soc_component_update_bits(component, CDC_WSA_BOOST1_BOOST_CTL, 0x7C, 0x44);
-		break;
-	default:
-		snd_soc_component_update_bits(component, CDC_WSA_COMPANDER0_CTL3, 0x80, 0x80);
-		snd_soc_component_update_bits(component, CDC_WSA_COMPANDER1_CTL3, 0x80, 0x80);
-		snd_soc_component_update_bits(component, CDC_WSA_COMPANDER0_CTL7, 0x01, 0x01);
-		snd_soc_component_update_bits(component, CDC_WSA_COMPANDER1_CTL7, 0x01, 0x01);
-		snd_soc_component_update_bits(component, CDC_WSA_BOOST0_BOOST_CTL, 0x7C, 0x58);
-		snd_soc_component_update_bits(component, CDC_WSA_BOOST1_BOOST_CTL, 0x7C, 0x58);
-		break;
+	/* Compander1 CTL3/CTL7 moved on v2.5+ silicon. */
+	if (wsa->codec_version >= LPASS_CODEC_VERSION_2_5) {
+		comp1_ctl3 = CDC_2_5_WSA_COMPANDER1_CTL3;
+		comp1_ctl7 = CDC_2_5_WSA_COMPANDER1_CTL7;
+	} else {
+		comp1_ctl3 = CDC_WSA_COMPANDER1_CTL3;
+		comp1_ctl7 = CDC_WSA_COMPANDER1_CTL7;
 	}
+
+	if (mode == WSA_MACRO_SPKR_MODE_1) {
+		comp_val = 0x00;
+		boost_val = 0x44;
+	} else {
+		comp_val = 0x80;
+		boost_val = 0x58;
+	}
+
+	snd_soc_component_update_bits(component, CDC_WSA_COMPANDER0_CTL3, 0x80, comp_val);
+	snd_soc_component_update_bits(component, comp1_ctl3, 0x80, comp_val);
+	snd_soc_component_update_bits(component, CDC_WSA_COMPANDER0_CTL7, 0x01, comp_val ? 0x01 : 0x00);
+	snd_soc_component_update_bits(component, comp1_ctl7, 0x01, comp_val ? 0x01 : 0x00);
+	snd_soc_component_update_bits(component, CDC_WSA_BOOST0_BOOST_CTL, 0x7C, boost_val);
+	snd_soc_component_update_bits(component, CDC_WSA_BOOST1_BOOST_CTL, 0x7C, boost_val);
+
 	return 0;
 }
 EXPORT_SYMBOL(wsa_macro_set_spkr_mode);
-- 
2.53.0




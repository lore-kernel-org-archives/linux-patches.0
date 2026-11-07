Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063907;
	b=WwoG5gt+r20RDR+AvZTeR5jatQVvV27OafS/cQYXHqHLXYMLK41RRDpZdpWHpjyMICmZ
	 4GY4l4r/SLiHOvoMbrkEUXAGfCTFZt/zXZF4FbPzHNV4YSqVvXy192t9EepjzYK8EgJqO
	 2hg6vK8/A30ZjSJd2WbqoMkAOFoztKbfxZ87hc/m477SlpKNd+qUuZTWsEKWJ8TcNtvJx
	 UNy+47IFq6VQtJ1VHpSKB9obKltm/7i61qLU90Nq1yQSbzJQ0Mh3TO4wdR3BLWDWtKcQs
	 EyScnFUXHOPUFhSRAQCDuIL936MR8nplD229Iy++4K/3UbZWX8TVN/mEOJH7j9AX+pQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063907;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xa2PdQe0QGYrd5xOvioRCS6T8nQvUw0bYmEKOlrrx/8=;
	b=GVb4/UWckKIGnEOe89ttg9HoLbWZloAYrqFdFZyMiFXl/W34PayspGt+N2NF5NPsRHqU
	 7WjUMgRCoJm6fbe4Rr8IWwmbITvZZKYQNnUdl5Vyg5zdDWAR5cWEWu7LGd+Z2K91djrrX
	 NFQDlnkVaJ4eC/x1Y7GBRCQVk60Ke3s67lZrp2lBMplMiSBJijPfSdtbMaT95FPKTE4gX
	 GTVa2wCwffnNKJkSsw4NzqKjdei2i/pffT4XoxPEvuem32gKP9INIR9Vn7ngfkwad71Ss
	 LDLj8MKQVYlxPE3zZQlp50sAsfp4VDB9MjPk+mHyW2iwqCvP1LQ7zUFlMBpgrOJMH6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fzntAF4p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF3A606D81A;
	Sat,  7 Nov 2026 15:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fzntAF4p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE0E21F0089F;
	Sat,  7 Nov 2026 15:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063907;
	bh=xa2PdQe0QGYrd5xOvioRCS6T8nQvUw0bYmEKOlrrx/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fzntAF4pNzneAqGLoxBmr4ZW+I6WYvRgP05Dmx/7ouLfIW9vfSmZgPhXYj+ODGYMd
	 /Xs/yQA5zegF5WnmYYE66UOkJbcQHEixB/dYgRyvOoXXs3261RPuCNNAFMnre+Zvw/
	 8Zsht+Sly4gYG+IcUCweV389mDz7ll14Ka0muEl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0106/1257] ASoC: codecs: lpass-wsa-macro: use v2.5 Compander1 addresses on v2.5+
Date: Sat,  7 Nov 2026 08:40:02 -0500
Message-ID: <20261107134942.285141573@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index 38e37908baf91..f7dad096bfa39 100644
--- a/sound/soc/codecs/lpass-wsa-macro.c
+++ b/sound/soc/codecs/lpass-wsa-macro.c
@@ -1129,27 +1129,35 @@ static const struct regmap_config wsa_regmap_config = {
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




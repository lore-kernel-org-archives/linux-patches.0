Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062786;
	b=VB7mZ6j532VHQJCp9uGrp+YUGRAGNTRyz16+mX8ZuUImGfrrXVpO1D9+jaKI+xH8fXH0
	 04eIZijYBddktC46yvLPiTKcukdEdjQ8r9DjzFJtacHRpQgsHHRL3+9aJATnuGEQi+Qok
	 a5wKbZ9k8wMZrezEBZvjQyLv3DfO/ECYBMk1n8ajignB5G82C4RCFVLDAS/5amqreLzgL
	 EUos+ftTaKCcEqaoPnAgHq5lIfOX04LGlWedE/DJwyIW9DZ5rGJIST82cuf5+PqCAP9v/
	 n79KQWQyAaC6FxF7cq2sRai26q7/abhpfQnQ0BECagKQck2r+DsRAV+J0+V9GANTKnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062786;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2z2AX5NWl0BEmuw7Gxecw806Zqs7Z3qX4sIlGURSSqg=;
	b=ZiSbNoM8GLfAXLsFXCjHoceiKZsv1/eQJjqCi8nWFbfvul2KOaWDV/uo554GXFPpdKYE
	 WNJG4tMnYwIzlAEuH40EA/zl0E5FqcvBHbJfxBM48zTPacBmwXFb3y4fjdQ2K1xAkgOju
	 leLdn/gg/KVxZ9JkB+c3e99ag8tGpp8+eSwV+NUIV7R55OupCKmRX8aquqHGBM0CkG1sr
	 +RH2R+rCindwep1c/iSnuMhEL8A3n+wlufkBIjRIu6gvMYL5GasU/WoZWM7JmXAHtoCw5
	 7GkBamfKa4NAmo5ipRHLrAz3txL/oB9uWVwiFL70xpQf8KNQ2RkBvhyV3/MHwqFYZHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dzSab9VJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 318AD606A326;
	Sat,  7 Nov 2026 14:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dzSab9VJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3DC41F0089F;
	Sat,  7 Nov 2026 14:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062786;
	bh=2z2AX5NWl0BEmuw7Gxecw806Zqs7Z3qX4sIlGURSSqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dzSab9VJxmElBcC9ojvdmFQ+gN8bxY06Kd58My+0gh9+lGrxJePlLq7hQXMeeEKoX
	 DTfuO5a2UlpkQmp2XurMa32lrZS5597mPPHHxEWzUb3Vxv7OFFzYnRfLqNk7DK+H2t
	 Ye+frTzMhEIuSIVBQQJzk/isUMmJTLIjE9FHoD6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 093/869] ASoC: codecs: lpass-wsa-macro: use v2.5 Compander1 addresses on v2.5+
Date: Sat,  7 Nov 2026 08:46:15 -0500
Message-ID: <20261107134855.852576320@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index 8350b02b575fb..f094225ba40a4 100644
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




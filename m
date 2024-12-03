Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67C31F429B;
	Tue,  3 Dec 2024 15:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238349; cv=none; b=NseEl28zHx72PgxjnjJ2ppJLMHwSkpjuXQ0TRDH92nIkWfYKxyiw55YnpYfH6XS9L6iwgRVAymdkToLaGnbdbzNwu+8cs1wAAhGMVykk9bh8a5Cdi6tnLxg5pN4olGBC5g/1BHE9vnhbhMuy2RGIrp4GPXNn8+z6O/vLXeO2dOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238349; c=relaxed/simple;
	bh=/o3fBt+8vBlnRuW0hw+iGJBOU/AvAb2ESiF7Iw0EfG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ETq7CJO+/dP1hVpmAdq6apvumKm3oI50j/mHeiSqXV2SDMW8WaNl1cXAofPLppFCGONGNe1DJu799RDjnEBri1KfNn5QkEwRCv1foSxz/SibbFWc3f+pb1xzwR8q3yCLCmMFOMa1jDbrY88rCPlnkyLSnPDSA6Au9LpX7kUYYdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jQm3PTDP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jQm3PTDP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 353F0C4CECF;
	Tue,  3 Dec 2024 15:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238349;
	bh=/o3fBt+8vBlnRuW0hw+iGJBOU/AvAb2ESiF7Iw0EfG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jQm3PTDPQVNnH8tfaLLIYXY5XdHzY2jRdibZgMTmQHhia37OUGqM0oTNkE++0jHfZ
	 CstGKEEye18Y9xnst6XWx0nChSfeDN0QKHxwuGVDVuSi/zfjyAx4RpB+XBv5PRtH7b
	 Tzn1j5Bvkge4IWvsJxAI/2EVnbKauAV5ee5lczN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 249/817] ASoC: fsl-asoc-card: Add missing handling of {hp,mic}-dt-gpios
Date: Tue,  3 Dec 2024 15:37:01 +0100
Message-ID: <20241203144005.490219759@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit cfd1054c65eefec30972416a83eb62920bc1ff8d ]

The DT bindings deprecated the "hp-det-gpio" and "mic-det-gpio"
properties in favor of "hp-det-gpios" and "mic-det-gpios", but the
driver was never updated to support the latter.

Even before, there existed users of "hp-det-gpios" and "mic-det-gpios".
While this may have been handled fine by the ASoC core, this was missed
by the Freescale-specific part.

Fixes: 4189b54220e5af15 ("ASoC: dt-bindings: fsl-asoc-card: convert to YAML")
Fixes: 40ba2eda0a7b727f ("arm64: dts: imx8mm-nitrogen-r2: add audio")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
Link: https://patch.msgid.link/dbcb5bfea005a468ec6dc38374fe6d02bc693c22.1727438777.git.geert+renesas@glider.be
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl-asoc-card.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/sound/soc/fsl/fsl-asoc-card.c b/sound/soc/fsl/fsl-asoc-card.c
index f6c3aeff0d8ea..a0c2ce84c32b1 100644
--- a/sound/soc/fsl/fsl-asoc-card.c
+++ b/sound/soc/fsl/fsl-asoc-card.c
@@ -1033,14 +1033,15 @@ static int fsl_asoc_card_probe(struct platform_device *pdev)
 	}
 
 	/*
-	 * Properties "hp-det-gpio" and "mic-det-gpio" are optional, and
+	 * Properties "hp-det-gpios" and "mic-det-gpios" are optional, and
 	 * simple_util_init_jack() uses these properties for creating
 	 * Headphone Jack and Microphone Jack.
 	 *
 	 * The notifier is initialized in snd_soc_card_jack_new(), then
 	 * snd_soc_jack_notifier_register can be called.
 	 */
-	if (of_property_read_bool(np, "hp-det-gpio")) {
+	if (of_property_read_bool(np, "hp-det-gpios") ||
+	    of_property_read_bool(np, "hp-det-gpio") /* deprecated */) {
 		ret = simple_util_init_jack(&priv->card, &priv->hp_jack,
 					    1, NULL, "Headphone Jack");
 		if (ret)
@@ -1049,7 +1050,8 @@ static int fsl_asoc_card_probe(struct platform_device *pdev)
 		snd_soc_jack_notifier_register(&priv->hp_jack.jack, &hp_jack_nb);
 	}
 
-	if (of_property_read_bool(np, "mic-det-gpio")) {
+	if (of_property_read_bool(np, "mic-det-gpios") ||
+	    of_property_read_bool(np, "mic-det-gpio") /* deprecated */) {
 		ret = simple_util_init_jack(&priv->card, &priv->mic_jack,
 					    0, NULL, "Mic Jack");
 		if (ret)
-- 
2.43.0




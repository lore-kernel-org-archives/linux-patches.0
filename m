Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976C72500B8;
	Tue,  3 Dec 2024 15:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240716; cv=none; b=CeNI0MeUqEvk0/nqouHVO2eI8vW8y80tP0DFw67Wpt6bClTQWR64s17OxN4MUUKkUkTorR0+39tvjHFFU6DsQob7kBexWU8lR6fLhBFHYQZBbDIL4ScBXqPpCqg94sIvVC5BAGxzOnn4h/8CmWLgUHvMlgKXNSvyhQyRXHLSfq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240716; c=relaxed/simple;
	bh=kO+rBg74bKNdxAkJjGa9HKCGrvsmpkx81E9JTIW1foI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MZ8zijs0lc3/83EdvNGDnH7BFFu4MDgApThIY+/1gC2rO9/BcVk43/yXMOz1jmhBfWbMOyp3xif38JcuUFacJPycqaqiHpdx/v4AtshhE/sChdrKi8O3AjTXsBoWzCMCRcc4uc3wByjE8uiKluxzMwdwydtOvIHaVQL58VWcip4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oS0OW9iH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oS0OW9iH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AEC6C4CECF;
	Tue,  3 Dec 2024 15:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240716;
	bh=kO+rBg74bKNdxAkJjGa9HKCGrvsmpkx81E9JTIW1foI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oS0OW9iH9tyM79da7s255dQoXZKlGzi0DqGPmniGFyvCG8/uQD9XIfPVy1B6tpsBh
	 Hp6Io9aRHN+FZcCCXEwtP9Kbm/MxlgPNbKIFkW5l6+aMQVFM1qoDw7wbAFgyYWtl5J
	 60fpsQOnKwrjdiVx63xB1afI+dVm2L3xQblmXnoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 216/826] ASoC: fsl-asoc-card: Add missing handling of {hp,mic}-dt-gpios
Date: Tue,  3 Dec 2024 15:39:03 +0100
Message-ID: <20241203144752.167228531@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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




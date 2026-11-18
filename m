Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032094;
	b=0cBcF4PlTPOflHHXgLnk6cKyq5IeOXiSBXibOs+jLgKLzuYjIy8oZyBexs/k/i45LyrI
	 NhGGEM4GR1X0fGFBd5v8dNlb2XneVD2cSdr2mW2UaoptkawfO9+UjljFJEVzFXbLzEwec
	 666cP6sx352DlXF0AdhCSy+IH5gcqhgrMA3oMiA0ePcEQWF17+k5IXCGzPgOq8PLlB7AF
	 ND1XXGNJse1rWofmI+9yetEl5R/HS35o6zXjAsiX+WnRWoO9HdArngfHrG1MbX2hRbnnR
	 16h1PyMCRdhQAmRr10Hcf6jh2/A39riv22BzMuqbwN+WbkJVvfVVjQgWE+rLUKYu2UA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032094;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YbjpRdL6ApWdn7KwHYc0JTiY1/nv9k1NJpJnqvwqKIw=;
	b=ARpa9JNceIndqECcExZb97oQ1HhIrgWkgtNiifT+ZN6hI77qpM5sBeieK2viV5rHGG8u
	 qHhVTUkz3NFP1eb2j10PkEjkla3aTYdbdz6vU5jSVKYSgbgMpbTat5nxPhWI15Tgv1Bgw
	 vPNndmt7AX1bHmchyxhm2aNI5lLAtqS9YfIVXQ+IhCmM6rW/3ap/67nrS4tR0QK3jHwAa
	 tQxkpOdF6N0nNCstaiZ1s+ekmtlgjqIq+YNej+QeKgtAkjqiYHpXJfdBUzsP8ns2aVbWN
	 wrjQV/s6lwCDzURBBUeTGjtbVCxUhp1r1DlMaeGYKiNXwwdM3h+z2UOvMYZypNymKUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oYZdDKdz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F8E606A31C;
	Wed, 18 Nov 2026 20:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oYZdDKdz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 470111F000C4;
	Wed, 18 Nov 2026 20:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032093;
	bh=YbjpRdL6ApWdn7KwHYc0JTiY1/nv9k1NJpJnqvwqKIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oYZdDKdzJGUSI2ynY4yI9FWrTDYVL3mwPn6T/ckoBmx7N6/eGJha1ZLt9RgqbiBIM
	 dXDfP9XJtDu4gh8cHVgOZH2TWT+A14BwZhrLhkGak2vHkQi5EYFoF0ejGtrLbiCAP9
	 mhfNogTG4zfdfFeqany4eqZ7OIt+nwKsBd7DRMuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1291/1756] ASoC: rockchip: rk3288_hdmi_analog: Drop redundant probe error messages
Date: Wed, 18 Nov 2026 15:56:58 +0100
Message-ID: <20261118150100.944878763@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 931f4a1223e154fdea63071074cbaa633ebf394b ]

Remove the probe error messages to avoid duplicate error reporting,
since the error is already reported by the called functions.

Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260806052136.21034-2-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: f15b2df0b940 ("ASoC: rockchip: fix device node reference leak in rk3288_hdmi_analog")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/rockchip/rk3288_hdmi_analog.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/sound/soc/rockchip/rk3288_hdmi_analog.c b/sound/soc/rockchip/rk3288_hdmi_analog.c
index a65d923d94dc4..2b06ca336ec16 100644
--- a/sound/soc/rockchip/rk3288_hdmi_analog.c
+++ b/sound/soc/rockchip/rk3288_hdmi_analog.c
@@ -184,10 +184,8 @@ static int snd_rk_mc_probe(struct platform_device *pdev)
 	gpiod_set_consumer_name(machine->gpio_hp_en, "hp_en");
 
 	ret = snd_soc_of_parse_card_name(card, "rockchip,model");
-	if (ret) {
-		dev_err(card->dev, "SoC parse card name failed %d\n", ret);
+	if (ret)
 		return ret;
-	}
 
 	rk_dailink.codecs[0].of_node = of_parse_phandle(np,
 							"rockchip,audio-codec",
@@ -222,11 +220,8 @@ static int snd_rk_mc_probe(struct platform_device *pdev)
 	rk_dailink.platforms->of_node = rk_dailink.cpus->of_node;
 
 	ret = snd_soc_of_parse_audio_routing(card, "rockchip,routing");
-	if (ret) {
-		dev_err(&pdev->dev,
-			"Unable to parse 'rockchip,routing' property\n");
+	if (ret)
 		return ret;
-	}
 
 	snd_soc_card_set_drvdata(card, machine);
 
-- 
2.53.0




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062858;
	b=O6UvOWUkK4nVrhEfgdCd1oLSs4R2euUnUeuLDfNLFd/xTo/QUuddNaFMDKk0D/eiLKcX
	 SaGJzOyFfBPs7Y53ExbTbLEiRduN52SQOSQz/pvgEoaLJ8aAp4LWLiLL2Dl5WNTfrD+KG
	 yv3+GZRQn5wl28tDkKSUrxpvzIydwRan9uAvzQ+Sq/eTcp28MkPdnL5nuJV7Uj5x0S+O3
	 j9BFLyLqA49DvAa4uF/DLgQWy0cVIekikVYuDCJugDxAlzJKTEPMFrGUbqIl+6Y2iQW9l
	 dkFXyhV4Q+pWGkRK++1lZTWWDCsfsic1nzpG5T13/oPAGv3FxuMcOrdcxOeEF/HjPhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062858;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MZZnOAyn04Igzt6yszGH065l4fz4sRpCYLQVDxCe7DQ=;
	b=pyTI5raVNsJkI4hCk8gTA/YmyHBL82/bBBdU+S1LqctXkoHRKjBEycUf80lCjRaIII/A
	 9aVZNO7evUC2ocRlTo41KpUcENeZjlDt3sAy9RlPzWYFuwYAZk0LC1Vpacll9vzsCLCGG
	 ZSNCmlVvcl+nOTeDZaepmrOVUgEyaO98kDzHLcCUiNYNev4+Kdl9IF8B00Zq16WABvdKT
	 Yj+gHpbN5NLsW02jn0PcInosXoaVBulVBq0RO6n3Ia2tup4l8UQaTjLEtpDMb+HzO1ZFa
	 Mis+deC3Hi1XPO8LIwz7NyUTZ5Dczv1Tdo0BQFOtzOrua+6WoAqAF6pD/yzsOICKUFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yT6K1n7q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD56F606A333;
	Sat,  7 Nov 2026 14:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yT6K1n7q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59E361F0089F;
	Sat,  7 Nov 2026 14:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062857;
	bh=MZZnOAyn04Igzt6yszGH065l4fz4sRpCYLQVDxCe7DQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yT6K1n7qvKUvQjvsJGdYge0WVMN8/BK5O6q3gqPqbCcL0cSsPRCytc5DffevsxOSK
	 pzDmpzpMLUszpUzUc8o5R7EzJP6UQzLyhQ/oFqpowObEWnTbOz6kIDxn2BPpZ2VzUe
	 SzuEid2uMH8ER6DbSu82IuXb8dHMH3uXrVPiVZ/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 147/869] ASoC: wm8994: Fix runtime PM imbalance in wm8994_component_probe()
Date: Sat,  7 Nov 2026 08:47:09 -0500
Message-ID: <20261107134857.344265603@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 480a5528cb6268d626632d45d4a1f29b4c0c11df ]

In wm8994_component_probe(), pm_runtime_get_sync() is invoked before
reading the GPIO configuration registers. If either regmap_read() fails,
the function jumps to err_irq without calling pm_runtime_put(), leaving
the runtime PM usage count incremented and causing a leak.

Add pm_runtime_put() on both GPIO read failure paths before jumping to
err_irq.

Fixes: f5a2cda4f1db ("ASoC: wm8994: Ensure the device is resumed in wm89xx_mic_detect functions")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260916072737.1970990-1-vulab@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8994.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/codecs/wm8994.c b/sound/soc/codecs/wm8994.c
index 128c3a59beac3..71e8dd18b57be 100644
--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -4352,6 +4352,7 @@ static int wm8994_component_probe(struct snd_soc_component *component)
 	ret = regmap_read(control->regmap, WM8994_GPIO_1, &reg);
 	if (ret < 0) {
 		dev_err(component->dev, "Failed to read GPIO1 state: %d\n", ret);
+		pm_runtime_put(component->dev);
 		goto err_irq;
 	}
 	if ((reg & WM8994_GPN_FN_MASK) != WM8994_GP_FN_PIN_SPECIFIC) {
@@ -4364,6 +4365,7 @@ static int wm8994_component_probe(struct snd_soc_component *component)
 	ret = regmap_read(control->regmap, WM8994_GPIO_6, &reg);
 	if (ret < 0) {
 		dev_err(component->dev, "Failed to read GPIO6 state: %d\n", ret);
+		pm_runtime_put(component->dev);
 		goto err_irq;
 	}
 	if ((reg & WM8994_GPN_FN_MASK) != WM8994_GP_FN_PIN_SPECIFIC) {
-- 
2.53.0




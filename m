Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062049;
	b=Mjxh3Ii56LpOWLy0edXQ3ZHIw3Pm1IVvFUTeH5+YrUAMpILELeAm72R9m7vz1DN51ruf
	 ZB0MZP3mrygMDQ6Nwa0epHhAYOFs9iU0GZ//pNkDz4Mb2M2f4nn43kXkiTJs9EkH8uy/i
	 /hvzNy9jIkLWCpBL5Pu5sYjNCmiyzvNa2rVxABGneTEEEqJj6UOqN7fVwM3ZLzs0fxwSx
	 tS+aQGomWXEWG++nX9kXA9cmznhaXgRKJdFm5rM+K+RYte/C7fmktvAz2EgizXG8hmzJE
	 0Ta8bmpq89OP6PALvKyz2BGGHYkarsF8sm2eauKg5i9tZ6U6gRqQCWjZqzTcOjLJPuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062049;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HvLWGEPs5GEGojQHvTzqrm9AnD1Ea3b56ylQGAPuvCs=;
	b=2m6xV+HXQdRBxq3ucAvj1XpZ90ndObObuWMdbuAbRamPZJ2hAEcpLer/Tmnhw+szZFC4
	 GMjHMSlj4B1KVvtYwD6nj8zYjCz+Eo6RPVOIHGIXrWHNBx1cUqHbHahN9R3ORsKlpMYMO
	 Ep+9G23P5UgfTg/valECDhAbh+n2hVUZDg2ut52T69PzXZvUnAjN04iffyQzoXs5U6wWz
	 j6uVwsF1MgyVcGkXAJr90z6kLNcQkPTp4XcxjXBs4VpWHxxotcH4zqiLSAZZ7PE609pG3
	 qeO9KAvzFNU1O8rN+O//HWem8c0OrjbVy4ExTajq5RhK3UV5okLRomjmIvFzgAfBEXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rZG6xCZU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86AE0606A334;
	Sat,  7 Nov 2026 14:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rZG6xCZU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33E4F1F008A2;
	Sat,  7 Nov 2026 14:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062049;
	bh=HvLWGEPs5GEGojQHvTzqrm9AnD1Ea3b56ylQGAPuvCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rZG6xCZUZk3OvJ2VqaEAm4CaXcsKZSseQigb/vl90KaUEyMwcxKaigXoCKAn+uXHb
	 VCbiZQiDRqGoeyf3+zwr72tVW99hCcWd7WwAKg0yQ3aeofNW4l8Uc0SKgPkncKUuVi
	 asugIhnEj/NpGbRvOx8DyA/EwSaACFHgOjbxwdtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0993/1536] ASoC: wm8994: Fix runtime PM imbalance in wm8994_component_probe()
Date: Sat,  7 Nov 2026 08:50:09 -0500
Message-ID: <20261107135025.555581254@linuxfoundation.org>
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
index a4abe6e53bfc5..4f11b95c78834 100644
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




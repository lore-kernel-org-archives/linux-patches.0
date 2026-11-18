Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058298;
	b=mBZeEdJWtKlTZkzVCAG/qUiJZn+Kt8zckCZPs43R1pHeNVHTwnwNElMe/mHyDT0MdhLN
	 YjpLNDrnNsU7DPUt6uwvEoSgAFNCMguvphGL9o20wjVt5WwaEBtkXmeqgWX5wZDvm8D3k
	 by121WlGi1Nv8a3e2MWtSgCeukttgS8hYboWaYS00nLPxW8hWKWHRW7x+RD1qAbRPXx6w
	 CQf/XIHnyu+KZuAS86kfcsUVCNMiTH+hfVGhUNg80cVvGxfMLW+t8hoX88/uWvZtvjraJ
	 eDb5N/Nf9bPilZ8NCMbfz8+3CxGHDyhTEy90oOJcduB3sv0LcOdygpyojt4c0zitVHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058298;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rKKY9MsvVXXwS8XVsvhP0FEk9rn2WJH0aP2aMjLRIkg=;
	b=a8m16YcFR8FhxkiRzxCTS/w5MSxQm86VGgDpVTu/gLO+OLyFklAiZ+FQzJL/xeCISTwy
	 yYmNo9IqaqewWaOHQPHgjtfoKcsZAhFavQ0oPGmzT5ICPJqr+CZUSDOB8cLo4iX3bCfKo
	 y+JAXCTWlEfg1OP7lV7rFPTU2mhRqBOGz2alwaU8dLqPUErLwW8OZ34JqtYM2HPHjTt91
	 ZBPppH71cqnmPyEBiEvVNARBw6gZWCvH/JHLSbQNTT83mPMuiuD2y82fBm1zV0MjKM00O
	 ugqomZYLq311VrOv81qOVOG+kCyW5+2jV5XchpyxxCQu1vVs9VwTtZ7D0pd4u4nDHcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kBi8mLhu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE9B7606A32C;
	Thu, 19 Nov 2026 03:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kBi8mLhu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 300611F000C4;
	Thu, 19 Nov 2026 03:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058298;
	bh=rKKY9MsvVXXwS8XVsvhP0FEk9rn2WJH0aP2aMjLRIkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kBi8mLhuzMmf6+cjiYLSOGs72erNhCOCMAXLxUA9hHLXvllQuALUoymXaxFKgAXf0
	 OFzAotvJuWYp8oBrmMsdaxaNCccdTfxuCe3pblHxx+oJPha9RGIReuykDXI/SAJu1X
	 qla+fJGmFd+j+hE1kEpUC7aey3KKLOA9NqNRoSvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0399/1848] ASoC: wm8994: Fix runtime PM imbalance in wm8994_component_probe()
Date: Wed, 18 Nov 2026 15:40:37 +0100
Message-ID: <20261118145930.514987106@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d3a7480fda435..0b4c3c37c7e99 100644
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




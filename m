Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052246;
	b=YnWNXTP8uPX2NBujivpfIMsLxuY1GmUVvaOkwcyG+k1ESG/dAnMXjYTV/yMNz02w98M+
	 j6a4drV97brp7pWIS1WfP+Gf7ciCLklsiEGqZfi+f8LNkzJpl+ariPKfmCLMA8ljplmjh
	 D1PTDE2nytJW1XNGHYJ/svtyBOQIcvY1a15HnOvqnk6yuj3u6t9F+ozoCyhIqbOy7j6V6
	 PGCU9U6wjciVLYXuAq7WIrDMrvywRTx5Nt8lUUrWNX0SRk8FJhbWrOaRKpy7Fcl+yn7ke
	 uJ0Lgjg2oEGUJwJr1e6JxlcL5eWSXW09C50JHmqDoEa4G9gMlP4opBcmZqUtg8Hof8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052246;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UbOIK+jO5OPc9O/9/ZxOLDCSAOqHXacpEgKCiuFr6E4=;
	b=IgkaUJR48wBncOKVeBkBHgg+BzWxJGvCFx6398aOik2O7ZABz5L4T38zkh8tV4Qj+Lwe
	 asIN/dUeg8B/KUIlaTFRzDAIzcIe8UR1v7RSDuWmSViNfeT5AqKz+qg2IWXMvaBjN9i4x
	 zHrF7lXMokftsWTGepi4j2Z9GvM+PQaBrrHPXrTL+byi4z1t4loQ3dZY50L585/VbrCgt
	 xnYuvBBgP6FtqMVWVJukgwR1hJQpZWpST/BaB2Y8aXduSROYs6LpvvqUIJLywE3N9HSUY
	 Qh7jwZ7/zfFW9yFrqrHuHXfwZbjQIuo50Oxht6V5005+Hv0F+3e5cVBxCNNIjdJIPKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BXgdPdS3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 829C6606A32A;
	Thu, 19 Nov 2026 01:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BXgdPdS3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D67EA1F000C4;
	Thu, 19 Nov 2026 01:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052246;
	bh=UbOIK+jO5OPc9O/9/ZxOLDCSAOqHXacpEgKCiuFr6E4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BXgdPdS3NUvk6l9TP48L8Z9XthCbwwiORsgdL8nkLGf7ZGaU/9wksHQaRLZ+Faiwf
	 2zIW0gFLI7u6oVnZr9U0hucziFldGr/l/4oUMLdvtxOm3QsB79goNCW/7t/xzb7cQ5
	 p7qawiT30XCsDAJvsF3+CpjsqaL2evh0nOk/TKjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0495/2214] ASoC: wm8994: Fix runtime PM imbalance in wm8994_component_probe()
Date: Wed, 18 Nov 2026 15:36:11 +0100
Message-ID: <20261118150030.972468582@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6759db92f6c46..e9037cf0f2c0f 100644
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




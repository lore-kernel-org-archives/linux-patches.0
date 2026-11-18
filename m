Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036056;
	b=s16Cnb+P7tEg6YaBUIZc/j6ZLtdG9P32/quHv74zea8C0qHl3wXKFgxOwrJdIPy0FMwa
	 N+que6Jh9EBtaddXiwXITeneFegK23vntfMEZ/T0xQQUxCJvvFzLkLskeoKtqX6h8gWvI
	 dUPF3+dFmOwxghZd2Og2XKIMh4ZvaBeKqvN4txLEvUGN5JSa4he58/89MKzK5OHwdFd9z
	 tBq725len8qiikcS+ZWyDhM87+HLtFWQAxC7nHx2VVawpMoHKr5OU5WlOjz3bPi/ayhA0
	 i/kRhWdKeK60K794A/z+1uDKJjVWdSfPxjI0POYybmhdxqNBUnr2eZR/LMujURjIpQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036056;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BA9F8tOtwVLVXMqJ1fWn7JCpw9jCRYESdj91hGZWJso=;
	b=ByQU1Zdgl4w0Sv/LMiac4N3gJbDfE81TP2ZJ19eS6JnpJSuNCsw6ZSoj3WQigr7aUfJd
	 ZcZJENuRDsHtjOsZj3EERUWT9acDpMo38BRCqlLWqDgtd6lzjFVp6rEm2LNw837Q6ZRx+
	 XiXO489R/TVN3u8Ye9Ljz4Wur+Ty5s2bMbJBM4sb4HO/k+UQsqTq+EtoRRG9TrzDpoIIa
	 cUpbiYu4L4WP7Uo9IOR73emPKXfec4KU1sytatoJ8YlRoGDqyltt4w3WRSjHYDw7jJF2y
	 yZz7CbBHHVQFSwGTEnznw4cwlQYQ7cCkxapf21Lqbjsl+QFp5IbsgUA4+4CCTvzMamw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MYnsAXoP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96283606A31C;
	Wed, 18 Nov 2026 21:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MYnsAXoP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAE901F000C4;
	Wed, 18 Nov 2026 21:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036056;
	bh=BA9F8tOtwVLVXMqJ1fWn7JCpw9jCRYESdj91hGZWJso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MYnsAXoPLw3oU9Htisht75RwmxyAtYuOtryyP5TkP8wVz9/yHAGILmFXfFgTN+j6g
	 GotfL0APcYZytBJYl7LgjyY3snG0Sb1uMYzHs3bAHCXzcE6lmDGJTrMZjhbUiYVGvN
	 bDCDPhIoJAS5wKbDu8ds4rX2Isb2k76awe0f3NOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0880/3318] ASoC: wm8994: Fix runtime PM imbalance in wm8994_component_probe()
Date: Wed, 18 Nov 2026 15:25:02 +0100
Message-ID: <20261118150345.722419050@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a48e904a97403..4558b0dd0c072 100644
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




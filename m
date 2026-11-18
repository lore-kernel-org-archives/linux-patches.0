Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042440;
	b=Co3yG+bnA3YFz6ZFcU0TbS1n6EH6uanzIIr0tkfI9IUbpDsH6EDkm5YhyBSlQ5DoMqhC
	 r8enrfJAKi0qMMhlBKPQFU3k3J5wJ6UdCEOvjDDuLIIqN8XIOEKtVJTur0YSHqBWEuJgH
	 w8DqqY4cwDROaBHB3vh15/kc8vuVq+mem9dOFymdnHNqrkLAEu73yYawJgDigukBz08ZR
	 /J0eIAFS38cWoTYK3wR9A/IsgUIdHynRnJuiubzcLV8nGCSVL15DCTjykF5MqkqOZQJXt
	 O7LwzRM8wPkeUZMB0c6mv/xAKox9kvbl+278hCOy09/9+DmOa4coBBRgHXqRpXAmI9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042440;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4h6+pTUEgqV2Z0blJlxDWaVEwxUDRUSyQlXRYIWfBWk=;
	b=lbJKuk/rb45goVEU/Yhh5ru8JDoU7g4/raE85w0v3ZKdauoonmetMTxHiQVqCizhZYiQ
	 J8qTT52O+6m/2Goj2av1x9xHnrH8rkVxGs1WDsB8bjXLMnclnSgAGCClUMFV1AeurP0sU
	 nJgEiLjKcK54nTAstZ8vFMEgBQkCatByOO3WsoWMI8TMB6I2g3jrFkdiSZ82NN11CS9wx
	 JIdrmwvET9k3lDWdP1aSIyYUlwxRM+xc7vZVSSATYHPee0Oa3qymB6EXrE3xj8aMpyjty
	 75OhItESS1WO/U2PQ1QCVELisBXec/nEIDWAnxFD5F9jKGGY9ocQ4hZp5c/i3vuE+eQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ALgzJJHd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AE62606A31C;
	Wed, 18 Nov 2026 22:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ALgzJJHd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B2901F000C4;
	Wed, 18 Nov 2026 22:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042440;
	bh=4h6+pTUEgqV2Z0blJlxDWaVEwxUDRUSyQlXRYIWfBWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ALgzJJHdfZBpZXROvyerMteiCkV37Ez8TgWeLrkxwizppNQ6pVpq+YGiyKisdCvlt
	 6bUYvihBaoSGS9CqRvwokQp3KhQordmZbAR2TEXVmKhj2Y/Fg6/rvU3DJaefRfjIJN
	 Rmcd2hNfmWHRrEd4xxH+TPDI5QRJwt691mMMRr6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3172/3318] ASoC: codecs: wsa884x: disable runtime PM on unbind
Date: Wed, 18 Nov 2026 16:03:14 +0100
Message-ID: <20261118150454.990441355@linuxfoundation.org>
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

From: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>

[ Upstream commit 54c121eaeed8ee7751935db8100b6b5c57124db9 ]

Probe enables runtime PM but nothing disables it on unbind. The pending
autosuspend then runs wsa884x_runtime_suspend() after the devm-managed
regmap is freed, and dereferences NULL:

  Unable to handle kernel NULL pointer dereference at virtual address 0000000000000020
  pc : regcache_cache_only+0x18/0x80
  lr : wsa884x_runtime_suspend+0x24/0x40 [snd_soc_wsa884x]

Use devm_pm_runtime_enable() so runtime PM is disabled before the regmap
is freed.

Fixes: aa21a7d4f68a ("ASoC: codecs: wsa884x: Add WSA884x family of speakers")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Link: https://patch.msgid.link/20261023171316.819857-5-srinivas.kandagatla@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wsa884x.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wsa884x.c b/sound/soc/codecs/wsa884x.c
index 7228a1418f2a2..927d03a64c1c1 100644
--- a/sound/soc/codecs/wsa884x.c
+++ b/sound/soc/codecs/wsa884x.c
@@ -1889,7 +1889,9 @@ static int wsa884x_probe(struct sdw_slave *pdev,
 	pm_runtime_use_autosuspend(dev);
 	pm_runtime_mark_last_busy(dev);
 	pm_runtime_set_active(dev);
-	pm_runtime_enable(dev);
+	ret = devm_pm_runtime_enable(dev);
+	if (ret)
+		return ret;
 
 	return devm_snd_soc_register_component(dev,
 					       &wsa884x_component_drv,
-- 
2.53.0




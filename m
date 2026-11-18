Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015676;
	b=RUIsrDtUhkHi3YdPXDC0QKmJRoUvLBR6V/s+bfiNXNfosHtRY51eGo2TCuRED3hrFTPg
	 9XJfD4mqRFZ/aMK6V+CqbvZsFM6dI4xNyB0jrn9D3qq9ha0aF8mG47IrcgsSF+M5vE7s7
	 7y7/ow/oquJFy0vbjQ9VRFAap6i5UrFTYrwTYQWYXfWzGIl6geU2udGzzO0gchlePpbyJ
	 2zQPLUmW9tku1Vm7wJC7t8VWOWfqijrX8RK9ggAekYjFVDDof2bW8uwlr+k03R6zy0see
	 kBwfdDJeErd7nCuwrIj3qzi5KEcGO+/J9zAD0GbNsxRFahdnHPb5ZbtUsYWrixkZSZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015676;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JtXMHPDpPhqI/k1rlvtbZDJVdGhXYS/I0S4Jv+9C/W4=;
	b=snBOXkg1fBNKVIVbwQKMRQnVoGEC7HCgGQeJrBPIBljo63k995VtNA0WBG6Zsdj/EAw7
	 wbZphcEXfcrkD/nMzvRLr27gEtkKcDISjW9X7nS80741FiX+BoBz/58ZjG1lTpc+LxcWS
	 zc3WM7MURBPnskmcAUgUO9vt725k2aQbYenBUBxYbh3FuOWER8RfBIel7zKYOoIDa7Gv6
	 evGFoiZ/lRORzCXpzo/iuzqRMgNQm1oI5iZpHKHkr9MbhX4EpaoLtUeivGrckM/L7+PUY
	 d5jeo67FdLrc0drG4UMsGExe+P1z58HURXXaz8ivU2OhlBwteAaULZNXFsetcuLmk+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2Ct278zq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09AB606A320;
	Wed, 18 Nov 2026 15:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2Ct278zq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BFE31F000C4;
	Wed, 18 Nov 2026 15:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015675;
	bh=JtXMHPDpPhqI/k1rlvtbZDJVdGhXYS/I0S4Jv+9C/W4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2Ct278zqkHtEuf7iFSRI7c1tfRQMFA/NQ9fXO42DWzHRQKOp73OTwWmy/mM0JcCxk
	 +0KoVhQXgkbIB+tKM/l6kdGa6eW4t4X6xgaBBi1rHeFPzMEw0jRSTx2fzVPrv+kPwe
	 4NCF8MKfj/RLfO06YagCXqMN3xl4abWVJP+x7vnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <hppiscas@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0259/2651] ASoC: es8326: report resume restore errors
Date: Wed, 18 Nov 2026 15:24:59 +0100
Message-ID: <20261118150257.200270213@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <hppiscas@163.com>

[ Upstream commit 349e94679968785803cc32c1d2e41e000e8afd5f ]

es8326_resume() ignores the status-register read, the direct clock-state
write and the register-cache replay. A read failure can also leave reg
uninitialized before it selects the reset path, and a cache failure is
followed by jack IRQ processing.

Return these errors before later resume work. The ASoC component wrapper
reports the callback failure while retaining its best-effort resume
contract.

The issue was found by our static-analysis tool and manually reviewed.

Fixes: 5c439937775d ("ASoC: codecs: add support for ES8326")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <hppiscas@163.com>
Link: https://patch.msgid.link/20260906034217.85696-2-hppiscas@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/es8326.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/sound/soc/codecs/es8326.c b/sound/soc/codecs/es8326.c
index b6eadc2e96598..32f39cdff79d8 100644
--- a/sound/soc/codecs/es8326.c
+++ b/sound/soc/codecs/es8326.c
@@ -1130,18 +1130,28 @@ static int es8326_resume(struct snd_soc_component *component)
 {
 	struct es8326_priv *es8326 = snd_soc_component_get_drvdata(component);
 	unsigned int reg;
+	int ret;
 
 	regcache_cache_only(es8326->regmap, false);
 	regcache_cache_bypass(es8326->regmap, true);
-	regmap_read(es8326->regmap, ES8326_CLK_RESAMPLE, &reg);
+	ret = regmap_read(es8326->regmap, ES8326_CLK_RESAMPLE, &reg);
 	regcache_cache_bypass(es8326->regmap, false);
+	if (ret)
+		return ret;
+
 	/* reset internal clock state */
-	if (reg == 0x05)
-		regmap_write(es8326->regmap, ES8326_CLK_CTL, ES8326_CLK_ON);
-	else
+	if (reg == 0x05) {
+		ret = regmap_write(es8326->regmap, ES8326_CLK_CTL,
+				   ES8326_CLK_ON);
+		if (ret)
+			return ret;
+	} else {
 		es8326_init(component);
+	}
 
-	regcache_sync(es8326->regmap);
+	ret = regcache_sync(es8326->regmap);
+	if (ret)
+		return ret;
 
 	es8326_irq(es8326->irq, es8326);
 	return 0;
-- 
2.53.0




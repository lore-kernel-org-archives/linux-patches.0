Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023151;
	b=f4+5UJZ/9LmXmRFrj8Jtk9jbnNkQ7H7UaHyP/SKOQCkkrDLEsh4rza06hgGQnOiSupQn
	 MSO3T76Mi2YwamFkhuIdTqS6q6xC6j/AFALh2parQg8lax1hnBP+voz6u9IswFgX61sj6
	 DaZ1rPGrIWCtXxpAueamOflPqzOGaP6DFXNuQdQ+SHjaHrocUNSxRjminRe8iD8d35V+Y
	 LhxS7JM84fP29XPy4Mvsi3enmxhES8a3GqzGcZ+f3xE2EbF/stwaPBzv/hWn+op7CP7N4
	 t5/ehH448uazSIozDBY51GVYr8Eo+FwSAW2xxO6B3R1tRhZjGq+4GjOOjDfB55CliZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023151;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rdY5QeNcK/ay0hcdk/iQB3CU4jdwK7OkRah8eEBcbIk=;
	b=NKn0Cx99h/5FVM+v/6YpRkTCSvNCsvbyX7cOVeFkGWb0fXY5kDQHkFfpNR3EX7RI2SUn
	 2p0dIKS2noqPk73phmMWlKS29D09TSHLaI/IOep2yKVOLN2VM+cF+UCQnlj0mf2vkUVRO
	 kXwXyI2fzvn5IrfKHG01Ks2vakGolykNO1i3zR+O7Wa0fQSPIps0UX3rTWXW5vYK4RXzd
	 1JL7hu3JAJ6u8E0etPhXPUuOBs7dF5FW2yKa2QcXKEkZ+EPEkxDfdZdxmVfDJPZ/Q/ufH
	 FCWH3DvxthZCiHEqPz822dcJOLs3vnXbJfC4zcW4blqt/XpOvMWM9UcHk/OsxRtEB3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GX1sVGS3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BB89606A32C;
	Wed, 18 Nov 2026 17:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GX1sVGS3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FC2A1F000C4;
	Wed, 18 Nov 2026 17:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023151;
	bh=rdY5QeNcK/ay0hcdk/iQB3CU4jdwK7OkRah8eEBcbIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GX1sVGS35xVDVhtyUDpH1WsEn7WZRWnkTQDiB/IcbgOevj132O2+8vEkYJsJLxsM1
	 AmzEXg/oGMI1CahRiW3coFCX1KeUWB/QvpW1ngRC52b4JndBAFvMR1iQvhBV+lGJu2
	 6AqEyiF6Czj+Rs/5A4L3dimenRNKf7V9vF5UJ3lE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <hppiscas@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0267/2151] ASoC: es8326: report resume restore errors
Date: Wed, 18 Nov 2026 15:33:22 +0100
Message-ID: <20261118150131.538433654@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 78c4e68f60024..4cefaa1f51d99 100644
--- a/sound/soc/codecs/es8326.c
+++ b/sound/soc/codecs/es8326.c
@@ -1108,18 +1108,28 @@ static int es8326_resume(struct snd_soc_component *component)
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




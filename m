Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B8B33346A8;
	Thu, 17 Sep 2026 15:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659793; cv=none; b=hJNH9ikbOdAJI4utm8ZVnn8PQbS0V5B4WzGXBiIwI5tnBl6ajXwwBu6mjTSibH3T/8E5svgptQQdjZIbjaQCZxiUTsj0H1vfzJ67/hby63hyVUqm7QtNWlOFbF3NIb1CrnfIhoMIEntUH3E34k1SxQrWPKzCnpObNwJG3+DMdTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659793; c=relaxed/simple;
	bh=IO0aq/xOf+In28jEXarChmdcgjFJZsHsHiFV/y4JCO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YJ1hoLvocQDqw91mGjcehz3Gzg+8yjdpDGOqZGOjkweTbWaqXLxakm4Wte/3FLD/+cvpTVgM+O3j6Kliftbix+9rbhNcPwXad8tq/yABRDT72NXVJir4huKnONg82KHtGfqwcmTaQ8Ift52eunhsdrJ9CZqkoMJkETkBS3KivhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aDBecmaf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aDBecmaf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA0FD1F00899;
	Thu, 17 Sep 2026 15:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659779;
	bh=mMoMXWKhUUjsKCFoLNKr0FmOvPGOauw/oukpTldoSjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aDBecmafE+oySEAbqQP50e9QA4sqnkhdvoR1zpGEIfzRrQhodHVFv+EkArv2W8rK2
	 a8yON1pyRYWLj9v3f6Dov4ol6ep+gDldQhFZQ5v4SVk2IHsNSDBJqYe5rTEP50xvo/
	 zJqpbAeYOK+Ye8HlL0UjyocU86TRx4hl3ZlCd6Gc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"hpp.iscas" <hppiscas@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 333/733] ASoC: bcm: bcm63xx: Publish the OF module aliases
Date: Thu, 17 Sep 2026 16:10:41 +0100
Message-ID: <20260917151359.829370632@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: hpp.iscas <hppiscas@163.com>

[ Upstream commit 32689f0fc54fd801f1cd11637666e534984cb04a ]

The BCM63xx I2S platform driver matches brcm,bcm63xx-i2s using
snd_soc_bcm_audio_match. With SND_BCM63XX_I2S_WHISTLER=m, the platform
bus emits an OF modalias but snd-soc-63xx does not publish that table.

Export the existing OF IDs for module autoloading. The PCM companion
and the probe path remain unchanged.

Fixes: 88eb404ccc3e ("ASoC: brcm: Add DSL/PON SoC audio driver")
Signed-off-by: hpp.iscas <hppiscas@163.com>
Link: https://patch.msgid.link/20260905133103.63432-1-hppiscas@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/bcm/bcm63xx-i2s-whistler.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/bcm/bcm63xx-i2s-whistler.c b/sound/soc/bcm/bcm63xx-i2s-whistler.c
index c47ed1e6ea2b6..14d111fe29d83 100644
--- a/sound/soc/bcm/bcm63xx-i2s-whistler.c
+++ b/sound/soc/bcm/bcm63xx-i2s-whistler.c
@@ -285,6 +285,7 @@ static const struct of_device_id snd_soc_bcm_audio_match[] = {
 	{.compatible = "brcm,bcm63xx-i2s"},
 	{ }
 };
+MODULE_DEVICE_TABLE(of, snd_soc_bcm_audio_match);
 #endif
 
 static struct platform_driver bcm63xx_i2s_driver = {
-- 
2.53.0




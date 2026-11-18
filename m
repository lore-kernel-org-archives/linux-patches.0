Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042166;
	b=0vSitBhmG1lDYvVsKAbiNClWXxBubbpqOZDY3yLUzYQUyR6wXH3zOlR+QBs7Y+zcFjRi
	 hYd3stTqlHDDFMLj9PUefJ+1qNJB+x3wXnbnCtyr1Xq+npUvbY2mjvBNZ2eX0OHFR4fdg
	 1l7K3FVLppzs8oj0cVgKzs3HCkdD7f+t6BDKKblXB8cq6k+b4rUNHN3E9X9HosRMA/ru/
	 ylhG7xjFbz8w2rTB3bWg4MfdIpVwmkRLF0T92bSz9HlqQnXr2vR7nZZ+T3VxarCH8JanS
	 VeHSyISA9fdat9zUTv7NaPCCAQPial4+n2SsU1yx4cOPNxyV4qAWO+3FiEbBUCxcaag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042166;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n7178yTSZK7efZzIZIC1GGsw3LHjxr9DJDuh6uIYKXg=;
	b=JqC5Y7Jo93nx7rfwzbdZcroslyBtytF0om+Z0Dwy1yUwGGxkxPe55kCFIN/avQbYaCIk
	 m+Up2FoJNUSHeyncwTzFX2PnqgqdBhjps24h43ZqJCE7lLpDzNljhWgSysSvnjF78mi/E
	 kbR6FDKQzfTe3+6zMeBas1Uwu5gceNQBr5XofSFTt0xT7WPfpqxca5Gmzc9l+3xvH3pRb
	 2veI/DkxBO1IUCwDPqLJhgsHjsuaxVAeSecDewgOfTNpD4BlBqdyul2oaW5E+f8sAev06
	 zHKfZTJD8mCHZRbuAu6r2gknxdE82Y2uB4FS1EXf2jtVKLNgiSDd0xNd1f6+sQUgbNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Qel/USKz";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 224B5606A31C;
	Wed, 18 Nov 2026 22:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qel/USKz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C1AC1F000C4;
	Wed, 18 Nov 2026 22:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042166;
	bh=n7178yTSZK7efZzIZIC1GGsw3LHjxr9DJDuh6uIYKXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qel/USKzgepfZLdn27U7MT88hxu+zA7jIMjdNI8hqcwgU53jmkEPv3C2mQYfd0mHp
	 uYzGWBVpSjNNuxeGwcHuNp6ljveDEctAVAKRaU5u1UK3/zD7Le0LDWNVeoCZ7B2Nb/
	 VrqOph73lQyp/b67An7XCd+VwxBUBP5zgYyGsu5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3032/3318] ASoC: tlv320aic32x4-spi: Simplify probe()
Date: Wed, 18 Nov 2026 16:00:54 +0100
Message-ID: <20261118150451.140076448@linuxfoundation.org>
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

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit c6d86149db94c0289b0e5950fa23c5b19031ab8d ]

Simplify probe() by replacing of_match_node() and spi_get_device_id() with
spi_get_device_match_data().

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://lore.kernel.org/r/20230831194622.87653-4-biju.das.jz@bp.renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: f28c09b7e62f ("ASoC: tlv320aic32x4: Fix definition of TAS2505 HP Driver Gain Volume control")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tlv320aic32x4-spi.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/sound/soc/codecs/tlv320aic32x4-spi.c b/sound/soc/codecs/tlv320aic32x4-spi.c
index 81c05030dd3bf..d5976c91766e0 100644
--- a/sound/soc/codecs/tlv320aic32x4-spi.c
+++ b/sound/soc/codecs/tlv320aic32x4-spi.c
@@ -16,8 +16,6 @@
 
 #include "tlv320aic32x4.h"
 
-static const struct of_device_id aic32x4_of_id[];
-
 static int aic32x4_spi_probe(struct spi_device *spi)
 {
 	struct regmap *regmap;
@@ -31,18 +29,7 @@ static int aic32x4_spi_probe(struct spi_device *spi)
 	config.read_flag_mask = 0x01;
 
 	regmap = devm_regmap_init_spi(spi, &config);
-
-	if (spi->dev.of_node) {
-		const struct of_device_id *oid;
-
-		oid = of_match_node(aic32x4_of_id, spi->dev.of_node);
-		type = (uintptr_t)oid->data;
-	} else {
-		const struct spi_device_id *id_entry;
-
-		id_entry = spi_get_device_id(spi);
-		type = id_entry->driver_data;
-	}
+	type = (uintptr_t)spi_get_device_match_data(spi);
 
 	return aic32x4_probe(&spi->dev, regmap, type);
 }
-- 
2.53.0




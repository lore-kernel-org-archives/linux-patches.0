Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050171;
	b=RUocEw4fivj5eYHfnq39uFcLUGSQAI26cIFcd4jLDqzXYEbE7hZGxX/ucmPakkt4q49l
	 O2WgRhbTi8+jV2+LR20dHalG++SDlNeLKsdCtr2Tj7E+t7olZFn3SeMlT1TEaObqTlrFy
	 v048utjZRtUa07kKy+mHh2t7GnhDzjlIhha7t5KwrOfiuBUCA/Vy9DMJnwjNRvaQNWdET
	 pqN7x8GLmmtfIjlEp5gojPlMutgzXBCxWIeHVbsy732sYHNe7626fvYZ1zd9zwnrzC34h
	 zRNKRTi39x6XlHRuqpmA/CGxgVh3WCZ5JkeEJ1hCOjt6qWYjA+cTGon5WukasGUbPQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050171;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u9t21aK8iwHCc+cRttg/pGLfT190eE7ba3+2Iz3Fohc=;
	b=xEnzWhcYcyj/9CUVNNgbXp77Rt1VZhpSDf5Wn9a2dxAZkeyQWdc5N13C9rTun+BYEAOe
	 3k4nj6Bw64g+KKKPcdXAoSD93xaeePJzv/fDVqw3hZcL8IV0FT/udgI6D8/mNDZJAqomI
	 BaS27rQ1dauu5oWmxH5f8VnoGdM6LEp+huep1+jNyxEzVjqREuHMvC/kuwV0u9I6q7kP+
	 wJBdn8swLwFvyKqYXuRauSq3rdkSBVDoFStHwH9Few3k3sDLnp3//fIGONyg9ZPTn/QP9
	 q9HQU+bkVfxmKsKZtGfKDOAoEEP1OEURpDDPaxD1hrvW6HwP3f4Q4XcqkYqJmdIwoaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T+4p866r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA52B606A330;
	Thu, 19 Nov 2026 01:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T+4p866r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D4BE1F000CA;
	Thu, 19 Nov 2026 01:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050171;
	bh=u9t21aK8iwHCc+cRttg/pGLfT190eE7ba3+2Iz3Fohc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T+4p866relwsNawQK+5jUYNMKFVVVkEuekaZE8OVPeZKt5GFF75bomlvycJm0Q+zM
	 MS4Q2k/U/PRx6fYRPQXfZavCa8iTCbHeGehUMyAj0PbfglQLM/tqbzFUBsIXcPYFEl
	 6L4VESpSOKiIXHowflwceAk+NnTYi8zWvKgAlK7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2612/2857] ASoC: tlv320aic32x4-i2c: Simplify probe()
Date: Wed, 18 Nov 2026 16:00:46 +0100
Message-ID: <20261118150335.629418892@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit d44f7bc9d181a2bec0dcff694d00b08c8f99284d ]

Simplify probe() by replacing of_match_node() and i2c_match_id() with
i2c_get_match_data().

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20230831194622.87653-3-biju.das.jz@bp.renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: f28c09b7e62f ("ASoC: tlv320aic32x4: Fix definition of TAS2505 HP Driver Gain Volume control")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tlv320aic32x4-i2c.c | 16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff --git a/sound/soc/codecs/tlv320aic32x4-i2c.c b/sound/soc/codecs/tlv320aic32x4-i2c.c
index 6983b9251525e..1b807faea3d4f 100644
--- a/sound/soc/codecs/tlv320aic32x4-i2c.c
+++ b/sound/soc/codecs/tlv320aic32x4-i2c.c
@@ -16,9 +16,6 @@
 
 #include "tlv320aic32x4.h"
 
-static const struct of_device_id aic32x4_of_id[];
-static const struct i2c_device_id aic32x4_i2c_id[];
-
 static int aic32x4_i2c_probe(struct i2c_client *i2c)
 {
 	struct regmap *regmap;
@@ -30,18 +27,7 @@ static int aic32x4_i2c_probe(struct i2c_client *i2c)
 	config.val_bits = 8;
 
 	regmap = devm_regmap_init_i2c(i2c, &config);
-
-	if (i2c->dev.of_node) {
-		const struct of_device_id *oid;
-
-		oid = of_match_node(aic32x4_of_id, i2c->dev.of_node);
-		type = (uintptr_t)oid->data;
-	} else {
-		const struct i2c_device_id *id;
-
-		id = i2c_match_id(aic32x4_i2c_id, i2c);
-		type = id->driver_data;
-	}
+	type = (uintptr_t)i2c_get_match_data(i2c);
 
 	return aic32x4_probe(&i2c->dev, regmap, type);
 }
-- 
2.53.0




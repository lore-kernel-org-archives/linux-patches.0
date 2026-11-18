Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042163;
	b=wnjogPQmTFC8LMLXTZODcPzNrlbj+d3uYDieJ44w3Owi5oZTYj+IBfrrLPHuDECMQaIf
	 IJ2cW75udahchmIddKpADm2bkSFV/q9mtKuo97diVgClpDnrU2FgZ0US+YB6nTn2IfpnY
	 RTfbABTxyGblBzoHTvhT4u5TvMqnC3+e2PmoAZOudAxHx0HeW9jP5S3A0iMrG8wzXbBBM
	 4eVNQv8EmIpZr+WAvg0DdGD5hszAxSyrd0+4iceFG17LkKR0FdL9dUBjSN9be+ed7IydY
	 XH5myKpTmLvYXCP4PVcmxytbRkq4x94pUSijxm4Up3MsCoI9T8nDrQnCzh2l7M9PbCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042163;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Gx1EjH1fcD6ZYLn8NCwbKBhfP/qLU+lkU7MJPFH7ZnM=;
	b=IRkFM/aDu2A8UsH7X2Fg4oLGvgiQD+iGqhwKNOV0yEsCAlO4O+F1494aP1b2AwxpBC2d
	 G96KKoc7vo7v1Bqm2QtmXt2z9sptcxYFrgksdzdiBslhf+NxefASnkcXeGxpyRoAXCj3P
	 77r3sq/TtsNS4KIpZjhMSBqU8BOuphQesYMIm9jFmL+oyp7uf51oRozOKqWvLUfa4kN9o
	 Vw0E2Gq6wkUa8QmK5i7tblJ3dMVDereEyurpGbZHAsrw74rBg9BcGqZHA7c9f9i0z2d+U
	 iTiXB44DWxjV52h3vpWj6YKSaLbt0DqD780aoSi5WTwKowjU70YedHhrFbDWMezDU+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XcmAV2bw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73459606A31C;
	Wed, 18 Nov 2026 22:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XcmAV2bw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C837B1F000C4;
	Wed, 18 Nov 2026 22:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042163;
	bh=Gx1EjH1fcD6ZYLn8NCwbKBhfP/qLU+lkU7MJPFH7ZnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XcmAV2bwO2JPxDmAGBQErp6p1+X2Dol2BCUxjeho3iIj7dIwHSawVh6XYM/GFri2+
	 N/Bj2qAndv7Sda7srxd4EmRwWjVYQaThz9PmESwfNo1hbZ/9TrURuDu8J3cSucqrZB
	 zI8pU/Pltxk1zkTwlBChXkkLfc/o6jwIYy4An8HE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3031/3318] ASoC: tlv320aic32x4-i2c: Simplify probe()
Date: Wed, 18 Nov 2026 16:00:53 +0100
Message-ID: <20261118150451.112899954@linuxfoundation.org>
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
index 713f3f63b5e3b..b27b5ae1e4b20 100644
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




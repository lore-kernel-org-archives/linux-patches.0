Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051287;
	b=AWAXeGDmbqr2mDZgkGb+EWceP10bhlEoM3N9I3uNFxbPQAOcKTORtLRq664LXwl7KpSi
	 My07edkB0XKUVPgRXrkE2V+uJhyfo5RDxK6IJA2yttZyQAF59ZWq3NfZd8fXegBg5AVRt
	 2BZ3pWI2KJHkg51sUlOW0F7JMW+I5mr4LzyVW+NgMBMwc9FkXCnEVuls0BX9lHPuWZqdk
	 D2fIgIClTwTHxnv4pMXkne3rhJKWTBFTrBu0oNoKWQjQCNJ5Zvt+ALbUbXKbzujFXZAKq
	 1hY89PMu9p4G6y0mi4YSSV/NORWNyUHe0hOW6JHi8yTW+rZZ0GjgdTj9Jb4RTOmLgmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051287;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r/WdfzThOFy/Ro7+PKB49IVKVS1R0MRNj6ev2uy27r4=;
	b=dX0iR8zlJEDdI8wp/dkNNuXmWCc4ogFCPDY9TlIt2hBcKmgtTxh5cGePrXdttyhYYL+y
	 mX7WU6e/ZqeIM29rLmdV3Cr0Dp9MMCUxEeO7iGohdWcxQbTu36JMmCQY/Tu04fqq/Am8S
	 egaWjwgd84fi+URAgOW8alp7VMvmyUS9nkJo6G+nvUmCWDwl6DHuelrInYOquPo3YjEeQ
	 VQtnWBVfisWUxHweq9dbpb0dB+6O52ck9uK0WxF5zp7GH+2Fbpw+zy8uaDzVWQHK/0UhK
	 FV+7He+gL7t/R0rABRbUAAt/vhurCP3z7DBRuVYIvcgIei/+jrQXGHRSqHHxYajRrtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gZDQ034Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FD9D606A31C;
	Thu, 19 Nov 2026 01:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gZDQ034Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B08681F000C4;
	Thu, 19 Nov 2026 01:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051287;
	bh=r/WdfzThOFy/Ro7+PKB49IVKVS1R0MRNj6ev2uy27r4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gZDQ034ZzqOs8lYuCMUTnHjoOHMpjbamvujm8dCYXdRteLh/QFZdYG5vid8vbvPKt
	 Bejh38LCtwrakB7XrPQDDP+Qp50/i25MeCvn0tp+/3Gvswr+OXQmrXmfzYa5gwZ2oq
	 ligi4a06ZFcx4lyzUSUVVzt+Y9aUU+L/0yN3hCrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0155/2214] regulator: rt6245: Restore state on enable failure
Date: Wed, 18 Nov 2026 15:30:31 +0100
Message-ID: <20261118150016.342352292@linuxfoundation.org>
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

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit e95a0a309ca02bf26dc937cdeb3fe2a235c65f63 ]

Currently, if regcache_sync() fails after the enable GPIO has been
asserted, the driver returns with enable_gpio still set high and
regcache_cache_only() left disabled. This leaves the device state
inconsistent with the disabled state, where the enable GPIO is low and
cache_only is enabled.
On failure, restore the original state by setting cache_only back to
true and driving the enable GPIO low before returning the error.

Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260729100018.66577-1-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/rt6245-regulator.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/rt6245-regulator.c b/drivers/regulator/rt6245-regulator.c
index cb22a207e9fff..051b444224bb7 100644
--- a/drivers/regulator/rt6245-regulator.c
+++ b/drivers/regulator/rt6245-regulator.c
@@ -49,8 +49,11 @@ static int rt6245_enable(struct regulator_dev *rdev)
 
 	regcache_cache_only(regmap, false);
 	ret = regcache_sync(regmap);
-	if (ret)
+	if (ret) {
+		regcache_cache_only(regmap, true);
+		gpiod_direction_output(priv->enable_gpio, 0);
 		return ret;
+	}
 
 	priv->enable_state = true;
 	return 0;
-- 
2.53.0




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829302;
	b=t5Zy4Gk+A5sCf9O2iwUFz1F/5UDziMgQ04u6A6sTyHNsruG9vB7UdLFO3nPHqeeg+1t8
	 XAUH5s5SfuGroRdVtuzz+GPRC/tzhw2IcS9FHd0KnMzxKsp/IFMLCaXeVKdm8nYkunVUZ
	 nNls9njsRPRoocfZnbbYRqmoiFygZZA1d+D8FuTLCJRYeo1kvRSf3s7uP70D9JZZ/MlTv
	 3n/S9catp6nX4Wveebbx5x4YVgjfjF/OIxHW0A/6kF4BuzLZE2N6je5NbJMJXHwEzsiVY
	 2F8JnSGXsOfDejEhrMYWj7AhrRe9nZchblOVyz8Ljb/bSrIcJXBWP72dtqQtai8YHfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829302;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=vI2av7/GmDzqR/DF/KwlBljWN818p/BbasvHVTqU2iM=;
	b=CEiuevLE9VHwZk51Jexz3l6Fm6blSa1/HOfDmRxun2C4Wi3K/6XF9zvV0a8BWTKVAUue
	 qJgNy7nNcLbyENvQddjSn3rZPlrPVulqbBo1ksRc+mo30d5C/AnJqtHYplYGIZrVJWdNP
	 aBrOtlUjxX1CA1GYkUwhPAqnxNpJ+k/0PeQUU2Wvo2lAE4+/nxlTYK0xlaBQ7PYS7fBVh
	 FuUh0uc33ChW5udbBBkWGeL4b8bsPOUwAS/RGHRQs1n7Scsb80EfV1x72326U/SNX9TXH
	 z9ThTYuuFcYaYLhhoER9JRwu1kKCaedEz3NtWRmt1Alm1YQDSa1FxwMDmCSVwXwuZYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m6ctmB61;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9758A6086615;
	Wed,  4 Nov 2026 21:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m6ctmB61
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 473BE1F00A16;
	Wed,  4 Nov 2026 21:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829302;
	bh=vI2av7/GmDzqR/DF/KwlBljWN818p/BbasvHVTqU2iM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m6ctmB61kPQAAFS4rXWnzoobM8x/j2AAJuSfj5sxjvyotWFK0NVBqGRu9s8JL2511
	 o49ckTWmVVCswSLjcF37eHypQK/xSaFwOlxP2wM4QuxgKo7vXHCBAd81EZ9/6PpyXY
	 bMBFNSrjOOIabHKTV2WWEgRbF1Z16CsprXtKupGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20 ?= <u.kleine-koenig@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0039/1005] regmap: maple: Workaround for another false-positive compiler warning
Date: Wed,  4 Nov 2026 15:56:12 -0500
Message-ID: <20261104211044.668318069@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König (The Capable Hub) <u.kleine-koenig@baylibre.com>

[ Upstream commit dffd32eb2b0e714a8ae23f98518ad7152cb06369 ]

Similar to the issue fixed in commit 542440fd7b30 ("regmap: maple: work
around gcc-14.1 false-positive warning"), I see an uninitialized warning
for upper_index and upper_last.

Happens with arc-linux-gnu-gcc (Debian 15.3.0-1) 15.3.0 on an
allmodconfig for ARCH=arc.

Signed-off-by: Uwe Kleine-König (The Capable Hub) <u.kleine-koenig@baylibre.com>
Link: https://patch.msgid.link/20260626060427.2548578-2-u.kleine-koenig@baylibre.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/regmap/regcache-maple.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regcache-maple.c b/drivers/base/regmap/regcache-maple.c
index 38a648efa6069..040fe03f66143 100644
--- a/drivers/base/regmap/regcache-maple.c
+++ b/drivers/base/regmap/regcache-maple.c
@@ -112,7 +112,7 @@ static int regcache_maple_drop(struct regmap *map, unsigned int min,
 	unsigned long *entry, *lower, *upper;
 	/* initialized to work around false-positive -Wuninitialized warning */
 	unsigned long lower_index = 0, lower_last = 0;
-	unsigned long upper_index, upper_last;
+	unsigned long upper_index = 0, upper_last = 0;
 	int ret = 0;
 
 	lower = NULL;
-- 
2.53.0




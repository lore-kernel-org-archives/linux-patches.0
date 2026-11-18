Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043328;
	b=FUXDegjwMml+8d4jmOscXI01MeIaJKKjuJI+wI7ptiJ6AS0DMOiLApOoNOUZa5XQbZw7
	 uForXsFdT2bbsZlrgZe7w8/QujLLBrUsFGSWRPqN3Nny1ixFqBQsUXdHhGMSVWLWTMpUz
	 yUGyeE+RPF2L8NL9CrFDZjlogq0hMhn65qz05RCSc5aUNEcY1QYmrrwX0B0aCPT1V4deD
	 bMsSBZ9NfQQ4iSAqPnf5Fo9SasoSKOXv9UV8U3ml89Qg/483Zc6oeimqajEfd4DfIbv/N
	 XkuvScR07c5O01gHYekePl9gT+BUoKQ+8B0kaUjAcC2ppZsl82MmuDZGZO+bzCu9YGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043328;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9avYHlXpRI6l+bRwstMn8zWLyoMc6MN6FDInAMfamus=;
	b=QJaBtKonsaK2hBlaH0+nh/5j6F3UG2lSe/lpFZ5DQazwlrAXfu3P9L+KhhvyIHDSQm52
	 pkgIuIFd39bM7FaP8jfSXrTA1npNH5LxSPKoj8jGNcUQLhiqy3TgkCGE/AtTuTCMBWp2O
	 neFIsDGUCTtnpMWxt12lkZQfaoX46/r1y6+u2JSuyIf0Uj2UPoMVnyViERTZj/NYHUlQq
	 Sy3fxJKQlv7LN2YHS8FG0WnCPlHcFPrMcw0D57IV4mMVrVKxi6sztxxUASwZUTinLwCfc
	 6m0cU5GniS7m/AGEbyYN+llmy+qEpmVssbmBBo0UykGink/IFfwccukhBNr81mD1iyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aCpdFF5Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C967606A31C;
	Wed, 18 Nov 2026 23:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aCpdFF5Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FA2A1F000C4;
	Wed, 18 Nov 2026 23:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043327;
	bh=9avYHlXpRI6l+bRwstMn8zWLyoMc6MN6FDInAMfamus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aCpdFF5Zey8VcCbXrtCMqWd9D3lrL17tsmeVWIJvSqt6q+xPjluYJVQkTIWOK73i4
	 Znapt53D/CcK3g9A9fX+qypaM8UVc9/CWjV3NGI0i0rt8zRmW+3vjl8Y1/dx/BRjZG
	 OLUFhYsqejbzIb7G/WFq0/vdQLnQGE8KYomc7n9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0171/2857] regulator: rt6245: Restore state on enable failure
Date: Wed, 18 Nov 2026 15:20:05 +0100
Message-ID: <20261118150207.510967802@linuxfoundation.org>
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




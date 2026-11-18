Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016407;
	b=Tnf2XnHCJhLlr9rxBwbr5hsJ6jIvx4jrDJjDLyB73sJI4xfGDDp7pqkJdcvX98GJIGyU
	 e8NkvPs6kYLmF1sEA4ZejRpOXx+nyWRH9UJ4D9LlW953nrqHfbleDTCFqdU/FGOmgccDE
	 o30GMBEsgD0xkf50hxG73So56kuPHXtrcj2fZvYx6Squ6ZFwscb6hZuu2mCLuADNcaE7R
	 ezrVyYzKM+8N91qUh7Pt6IH0PcF4efhVLATibjCrtkd3sWpO6zbvikAdxTlCTIuGALbIX
	 WcOfZ5q2HH127L1B+ercuml5p7zApzPv7+l2qctQbcdALqSRIxQgrTYXIVsmFazVLmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016407;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LXzKoNJgac/LxwVZrEua8RKpIym3hCZRJvpeKoT/KcM=;
	b=e0YlHMlicuf0fNIwFmQnm+WNcZAGr7aL7RXxJWlDKcDlmNAp0i9nxSj7ePxfVmcRabFc
	 lqWF2mU+CAD8ch4SgeubOB3tsV5jA+TS7TAxBu8SV8QJFwM+1FKed8V7fY3tdQZ56ElDQ
	 P1grY9ad2H96wCwMGl8Hlzn4eaYiUMHm8q31l/HR6rTWKcabAw9MqkSSF9c8D19fe3nC7
	 llCa64Sqn7yTMBmcn/sjk0yX9F6UVLj/3N9cCq5mMbl9D3balu/w8+bMSyPAD6dKfNUtK
	 45zX7WyNyc0xyLxxcxRU6NES9hTxcOYelhflL9PR5qnITZUG1zwzPxG0yR5zDFMkaGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WDuB9lp2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A0D60A380A;
	Wed, 18 Nov 2026 15:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WDuB9lp2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED8391F000C8;
	Wed, 18 Nov 2026 15:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016407;
	bh=LXzKoNJgac/LxwVZrEua8RKpIym3hCZRJvpeKoT/KcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WDuB9lp2wRmcsDyqzBTkr2jB8UFkK93ivL++YkYg2eU2wvamhcFaepqSRNBQyj+JP
	 a11vgPdpay6g8rSD3jKcTRChe1PbWFo5Iz2oqi3zfgjYSBm3TaNnEjzG/BetpKUNKI
	 t2ZB3KwHpiH0wKBKKm67qb7YJ/pegH4sqoDFHhbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0477/2651] media: i2c: t4ka3: drop unmatched runtime PM put
Date: Wed, 18 Nov 2026 15:28:37 +0100
Message-ID: <20261118150304.956662040@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit 2695038ac43cf63b95580544a4e9d1031660aa99 ]

t4ka3_probe() marks the device runtime active and enables runtime PM,
but does not increment the runtime PM usage counter. Nevertheless, the
probe failure path calls pm_runtime_put_noidle(), which has no matching
runtime PM get operation.

pm_runtime_put_noidle() currently does not decrement usage_count when
it is already zero, so the call is ineffective. Remove the unmatched
put to keep the runtime PM reference handling balanced and avoid
misleading cleanup code.

This issue was found by manual code inspection.

Fixes: fd55319692151 ("media: Add t4ka3 camera sensor driver")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/t4ka3.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/i2c/t4ka3.c b/drivers/media/i2c/t4ka3.c
index a5a68e3fbec22..bf48a56f5a91f 100644
--- a/drivers/media/i2c/t4ka3.c
+++ b/drivers/media/i2c/t4ka3.c
@@ -1034,7 +1034,6 @@ static int t4ka3_probe(struct i2c_client *client)
 
 err_pm_disable:
 	pm_runtime_disable(&client->dev);
-	pm_runtime_put_noidle(&client->dev);
 	t4ka3_pm_suspend(&client->dev);
 
 	return ret;
-- 
2.53.0




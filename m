Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060851;
	b=SRPnVnZ5i/tv4JGovf/ScvxnJ2ygxIOdj0tnjGYh+FnBd1Fo703liNSc2RWc6YxR/obd
	 77CgVtLqHiJ7kwlYua/WYhDIyQXZdJo/rTW2cQ0D3LcP9A8xxuQI2MmedA20IcdohxRwI
	 l3GAEUiCnyKvzQTHcpMRBNYkbSL/BlUuPZdgxK1fJ3BEyetKrH3fWyH+6L4VTkl4KfNSz
	 tsFazZvg3me7zW5GjVUoe8hYFQ8SKR0xfDC73gH2brjXxPVadMf0laIk/bYhikUrmUTE/
	 Mx2ol+wNS6eSVQPYR3f9nYoGEhdG4LSbg34C5+yyTMj+AxFnM+HY5uQFKnvRppvtzRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060851;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kFZqHNqUDTxY1IisTWWyZ7xNgjjOM/O1h8u4Dif9AHw=;
	b=EnjBIz4rSz9W2fb+FCdRed6GsM4yXDYd6s1ePEdUqKEWpJfgohmtKGnf7aalNIjSE6Ld
	 AuJ5yPw0xxZd/Rdd+YsZ+A02hXza76UHWJPud/KwLEuiUgw8QN9LKjYsIam76Wf3OaOs0
	 lvpOwmMM+ff4dj9lsTzQX86mmtBMksmij6UMpY6S3+SGqJQLbtroeqdXAKQUgWrsAGDoa
	 tNFwx0EOLskAlNN2G12JX1BnxTIYbxtkoIfQiNHgP+9SIYCVFM22dM39+Of9xCro4t5Iu
	 UkBsYuHerAoV3pdgyxWZO1dkVxBh06sjSnwvwLJcNu0dV+LfjqJEiRsZyITwSPmE6Ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sAZ3++8x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF0F606D805;
	Sat,  7 Nov 2026 14:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sAZ3++8x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88B311F00901;
	Sat,  7 Nov 2026 14:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060850;
	bh=kFZqHNqUDTxY1IisTWWyZ7xNgjjOM/O1h8u4Dif9AHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sAZ3++8xHU7BoqQ66LF7xrlrtAdkmM6R5YrLY9rTSYQcAdhLBNlB6AKiPzA0qxOj2
	 7fR40xU9+Q20YZNY4b9f/tYI6URlKhJTnDeVw2wCPuEbhWvjWHfMDKXIghsaik42gW
	 fnr9qIxck+ptfvEx+NXARjpnzFmUKepNcUAwV0rs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0237/1536] regulator: rt6245: Restore state on enable failure
Date: Sat,  7 Nov 2026 08:37:33 -0500
Message-ID: <20261107135004.331627693@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 1843ecec19229..5c0ee04e97ac7 100644
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




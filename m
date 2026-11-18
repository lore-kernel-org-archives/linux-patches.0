Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049560;
	b=B4/UmtI3nTLBdrQSFHK+Q93qa0fpCJcMLpN5Hj+VOMH4FENsAS9JAsjR0QTALLJKSYQf
	 Rksw+x4w8XIp1EoFlj3qtBU9XCcQqckhSsOAB6XcxbO7id9cYpEttDsXkljPyU+u6yIEb
	 RjjGS5RUWgy8WqPyy6zeGFe0vyviyCD6ZTU0ceov9wX523CdIZPR2Vjo2AK4ZQ/u6T7+A
	 Mq06Gx6mLBJMotOnTyS7DglCWlbdyBFcjHH4QFab4wxYITb7Fydn58ECImo+u3iryJJmV
	 7mWOjDDRYLafDDvaW97d2NT14TOJZoJcfrofllfidjAHThG5bYhEzio0JJu4n+pW8EA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049560;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q/FGEA74YVHjxMTdkmreX2a8pE3kORgeH8I8Duk0F2U=;
	b=CRqmGDilO7M/q43PDeNzd8kl+eWluGYglsWAX7m03Iqr+N7oLZJf3i41V5haZ6vvcX+v
	 7qDPKUBLxa7/A/Qbp1QJ9By1BM9uodCsZp6XNRzHN17sWfCRdy5T5hfoIxitx/Rd6bzSF
	 LIFx52F9pfiZdtEn7wfBWxOxiLIEN0oOafHa9XDDm2MZH/7cfDnVKElMALu3LQStYewy+
	 pRNKo5bzAwh+N4hmus0dfG4OAXxYYbN5ZT7MV7pD+NOvBGfPGL9K2RYwmYwLIt7ic9CVL
	 ePcC2fzol2qwSrUNFrlHRM1PlH99qaFPukd0L6Wrru17/6a+0jsKZAJEYf3nU1jTOTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p2WbPnj7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC2E606A31C;
	Thu, 19 Nov 2026 00:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p2WbPnj7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39E771F000C4;
	Thu, 19 Nov 2026 00:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049560;
	bh=Q/FGEA74YVHjxMTdkmreX2a8pE3kORgeH8I8Duk0F2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p2WbPnj7fHJ+ikpTtSw7IdXaAkJiuVDGrCQ4U6ZDxWGXzcqZ9SYxumv9ApQlZe6Hq
	 oiJkh6w2o7gLqjYcOKWAJ1XMAGR3eIS76A6X6i82EiIcEk+lL8Rpwfq13DMpnxEXB1
	 HBPqOvK0TkXpRWdfAsOcHaeCAD5Wxf3Ai3hA0pNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joas Antonio dos Santos <joasantonio108@gmail.com>,
	Daniel Machon <daniel.machon@microchip.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2394/2857] calipso: hash the cache key, not the option start, in calipso_cache_add()
Date: Wed, 18 Nov 2026 15:57:08 +0100
Message-ID: <20261118150327.720188417@linuxfoundation.org>
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

From: Joas Antonio dos Santos <joasantonio108@gmail.com>

[ Upstream commit d538cc3ec0bc4cb7b40981b3213a6c6671959ed5 ]

calipso_cache_add() stores calipso_ptr + 2 as the cache key, but
computes entry->hash over calipso_ptr, i.e. starting two bytes earlier
at the option type and length.  calipso_opt_getattr() looks entries up
with calipso_cache_check(calipso + 2, calipso[1], ...), which hashes the
key itself.

The two hashes only match on a jhash collision, so the CALIPSO label
cache never hits and every labelled packet takes the full DOI lookup and
category conversion path.  The memcmp() on the key keeps lookups
correct, so this is a performance bug only.

Hash the stored key, as cipso_v4_cache_add() does for CIPSO.

Fixes: 4fee5242bf41 ("calipso: Add a label cache.")
Signed-off-by: Joas Antonio dos Santos <joasantonio108@gmail.com>
Assisted-by: Claude:claude-opus-5-5
Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
Link: https://patch.msgid.link/179138670045.80227.16155454353416856947@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/calipso.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/calipso.c b/net/ipv6/calipso.c
index 72079ef2959b9..e4e2ee5059c3d 100644
--- a/net/ipv6/calipso.c
+++ b/net/ipv6/calipso.c
@@ -284,7 +284,7 @@ static int calipso_cache_add(const unsigned char *calipso_ptr,
 		goto cache_add_failure;
 	}
 	entry->key_len = calipso_ptr_len;
-	entry->hash = calipso_map_cache_hash(calipso_ptr, calipso_ptr_len);
+	entry->hash = calipso_map_cache_hash(entry->key, calipso_ptr_len);
 	refcount_inc(&secattr->cache->refcount);
 	entry->lsm_data = secattr->cache;
 
-- 
2.53.0




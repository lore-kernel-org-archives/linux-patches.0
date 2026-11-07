Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065317;
	b=OSEIQQtTzEiJEcVFlN02hLmk8v9QPfNyXflLgtDgxTkBRJ+RU5BjOVMLjcN/IIGsOLlU
	 gRw1gycVXYRq7kkccS0/6ll6lPfkz5yT4tkFxCbUzgVMoyFYWmR7L7UGJ2UYrZnW7jBRH
	 lpjFJwM8IYiukjkNFjD+KNyEybX+AHPaPxtIA2PcAoYLWUan76fzCiXa54xxhlqZ7NwE6
	 foSKbatFKw7cxYqK1a/kndEDaRR99kJHDAaHCBxehRJ4YIK6VLG/iOoGUyEx4buBQDn+y
	 JaFrIJMC35eTRGbi5zBjuEpo91fW7waoT//ES0KjaujOSEdBs6IeRC/q/zK6RHoEDIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065317;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iQL8DFigNGINWv5P0/uIJp4jcu6jIAnBMcrk/Qo+J5s=;
	b=gFJWPBYPLCeHgMov6UaArfZEMQ5pT5+aw0oc5/Wyj73XjQM07k2xGOwSjFAB0vupiihx
	 KXmjj2lwpSjKsUAwzIfzgYc9xnjJDoAl8O3RjqsRyr3dIIHu1ahXzjY1EthUz+sZRmeJC
	 01tHct+XCTmc8m+GYo9ySTF8r+zbH38Q5Q4pOw3kh1Zo+YbJkQLfz47NnFS6m8cfUtesi
	 pXiUKQbli0n3zjIthWWZtEmSHyD5N12H81IvnSQ1sc75Xfv6mOqxr/hoWeNYFdfEESsZn
	 kIOPKvjled8UfbChvlftis63U92m/uN+MtLPDVkX0oASTZhJdYTIrh8tH5tcX8SI4BQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fhLeVdaZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082BF606A32D;
	Sat,  7 Nov 2026 15:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fhLeVdaZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FE491F0089F;
	Sat,  7 Nov 2026 15:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065316;
	bh=iQL8DFigNGINWv5P0/uIJp4jcu6jIAnBMcrk/Qo+J5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fhLeVdaZ1/fJ4sFChyweVJpdUMiDkZMGfjkduW+lLtDN2Z0cDCpAdFGoVSmxmlTlM
	 Py+Kl0p3uGXKPCdCOU1lt2fO0hXhBJ0Co9m62wXfA7Yjm3OsP7Tt5TUfo/3WREEXSd
	 k9xloqWiQTlduBnLu+sgSdfFPIPO8XOXV6Ykt9+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Kan <ckan@cloudflare.com>,
	Matt Fleming <mfleming@cloudflare.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Marco Elver <elver@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
	Caleb Kan <calebkan1106@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1064/1257] stackdepot: stop preallocating after the final pool
Date: Sat,  7 Nov 2026 08:56:00 -0500
Message-ID: <20261107135008.663764697@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Caleb Kan <ckan@cloudflare.com>

[ Upstream commit 8f56ea8e0706d92774603260779c7032f03ef3ac ]

depot_init_pool() decides whether another pool is needed before it
increments pools_num. When it registers the last allowed pool, pools_num
is still one below stack_max_pools, so the existing comparison clears
new_pool.

With new_pool cleared, stack_depot_save_flags() can allocate another
order-2 pool after a lookup miss. depot_keep_new_pool() retains its pointer
in the global new_pool, so the allocation is not lost. However, pools_num
has already reached stack_max_pools, and depot_init_pool() rejects every
attempt to register the pool. It remains allocated and unusable until
reboot. The non-NULL pointer prevents later saves from allocating more
spare pools.

Account for the pool being registered in the limit check so registering
the final pool installs STACK_DEPOT_POISON and prevents the extra
allocation.

Link: https://lore.kernel.org/20261022083330.3159793-1-matt@readmodwrite.com
Fixes: 31639fd6cebd ("stackdepot: use variable size records for non-evictable entries")
Signed-off-by: Caleb Kan <ckan@cloudflare.com>
Signed-off-by: Matt Fleming <mfleming@cloudflare.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Cc: Caleb Kan <calebkan1106@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/stackdepot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/stackdepot.c b/lib/stackdepot.c
index dd2717ff94bff..90c52f2e0d3f4 100644
--- a/lib/stackdepot.c
+++ b/lib/stackdepot.c
@@ -323,7 +323,7 @@ static bool depot_init_pool(void **prealloc)
 	 * NULL; do not reset to NULL if we have reached the maximum number of
 	 * pools.
 	 */
-	if (pools_num < stack_max_pools)
+	if (pools_num + 1 < stack_max_pools)
 		WRITE_ONCE(new_pool, NULL);
 	else
 		WRITE_ONCE(new_pool, STACK_DEPOT_POISON);
-- 
2.53.0




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064571;
	b=A3jYIArWxT+zlx4jgFBzmqLgeBDaQ62cfZy7W2DYeOBzNkD45mPstvqNBnRWO+zVQnqZ
	 Xo4cWCwiLAFxcaSTkYlh9ObP7kJsJ1CcKa8imRD/JasrrSPh/UeGPheD4ySe2yeq729dP
	 H3NpXsoanATfuAXeLeeF3Ahn0Mtaj6rzGEQgYnEkedL1ImdndSBj86/JZdPp/6LxnmOR7
	 wsincat9Vna7vu4w0owyWtBiGUnodfIWTdc43oksd4zxQ/zak78hV+S06KN2uakbLEP1x
	 rC1yuw19HME9nC3UXWgaI65PgZkC0JRWgMmTwouwtBjSo2tAcRTroPzeU2jfs545A9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064571;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FyEPx9xAiAx8uRtK90S4fQNLnsHaHvHjyQ9ep6BuNfc=;
	b=AmvXsyqA+Z6MutmzBti9BTdShkvhP8CAFMeDZOrORqm3+40nMUp7eflB70tajocrrFta
	 hNt3FwUn7lGhcZP7LqXMzIRB8zOxavPNsqHke8BBwCQFbvuF2JYknufYrP+v7xdhukfVz
	 leFy4ogVStr+CBi7w0i4B19TBOrSJJ4UItENmceaUUC8Su3ATDPFaMidWDtPJ5iqrAb95
	 5bj+K5khES01nGu4amH6MgtD7FaIF+xI+ZhM8gYSc82PnMyUPSFGkeBBMVhECLg0PJ8+3
	 5FKubbUAImhWXjn2DVrObwv2U/zenxz8C0z5nX9uIXRB42ZvgGUiO5cdo+k/pcvtJPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xFXWVRq+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 844A5606D809;
	Sat,  7 Nov 2026 15:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xFXWVRq+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 390F31F0089F;
	Sat,  7 Nov 2026 15:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064571;
	bh=FyEPx9xAiAx8uRtK90S4fQNLnsHaHvHjyQ9ep6BuNfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xFXWVRq+PV2JIErva0sHtRXhJDPdVyDFxyWwdP6niwV2pd16exunHtlJHfWBYLI4/
	 j5O7tfWibS8XAoDJTKdU/FNy5g6Fxg2gwvRzsCoETFDSsA4F/fgVOjp7B2PmKbfsw8
	 KPsxcG3SmdFcRufCkQ8tERTdvypvJqL+8O5O5ogk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Longlong Xia <xialonglong@kylinos.cn>,
	Andrew Morton <akpm@linux-foundation.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0584/1257] mm/zswap: enable zswap_ever_enabled in zswap_pool_create()
Date: Sat,  7 Nov 2026 08:48:00 -0500
Message-ID: <20261107134955.478779494@linuxfoundation.org>
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

From: Longlong Xia <xialonglong@kylinos.cn>

[ Upstream commit 91b4edb993e1549afdc3c2495216734b9f13f00e ]

If zswap is enabled by default at boot and pool creation fails, then a
pool is later created by updating the compressor, data written to zswap is
corrupted on swapin.

Enable the static key in zswap_pool_create(), covering boot-time and
runtime pool creation with a single site.

Verified with fault injection on a stock kernel (compressor builtin,
CONFIG_ZSWAP_DEFAULT_ON=n):

  1. Boot with zswap.enabled=1; pool creation fails, init completes
     pool-less (static key off).
  2. Echo an available compressor name to zswap.compressor.
  3. Enable zswap.
  4. madvise(MADV_PAGEOUT) a pattern-verified 512 MiB region, then
     fault it back in and verify.

Step 4 reads back 131072/131072 zeroed pages (zswpin=0, zswpout=131072)
without this patch; all pages intact (zswpin=131072) with it.

Link: https://lore.kernel.org/20260906135938.3568108-1-xialonglong2025@163.com
Fixes: 2d4d2b1cfb85 ("mm: zswap: add zswap_never_enabled()")
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Yosry Ahmed <yosry@kernel.org>
Acked-by: Yosry Ahmed <yosry@kernel.org>
Assisted-by: Zcode:GLM-5.3
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/zswap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index cb5a0855fd2a7..e6e6377a62a0b 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -324,6 +324,8 @@ static struct zswap_pool *zswap_pool_create(char *compressor)
 
 	zswap_pool_debug("created", pool);
 
+	static_branch_enable(&zswap_ever_enabled);
+
 	return pool;
 
 ref_fail:
@@ -1805,7 +1807,6 @@ static int zswap_setup(void)
 		pr_info("loaded using pool %s\n", pool->tfm_name);
 		list_add_rcu(&pool->list, &zswap_pools);
 		zswap_has_pool = true;
-		static_branch_enable(&zswap_ever_enabled);
 	} else {
 		pr_err("pool creation failed\n");
 		zswap_enabled = false;
-- 
2.53.0




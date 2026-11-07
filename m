Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062303;
	b=iGHqvl6JUIDeyQJNvj7lX10ABNoCCVZy6PBMORmPQXnfvNE5Qf7VmpI5DsF3DpBxGDEc
	 E9qhlmJDPXbLW39pCfS+RuEo+LjhhIfuWGeDKfvMGffKXGysksLuJgGcazPLKlWwwMup5
	 k97zNiEYrXTSBsK/MW8jCokTpK5f6+Ou7bVTxQCDOGWZAQ0jGi4WysvmJM60caZTSkuXS
	 dL0X86Y5j8lIfGT1XqWWxWMRua1UrUAqZIhkivmTOQjsnNC3lCsYnd+7nB27xQQrVh6nV
	 fIZgV1Gzg8TDmudbWiPWydsRN+MwW1BXZoAI0ZB8k1vkZW7vDYyCXBX3KrPNK0hFyFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062303;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YLaKUrJ0tSdI5I3NxbT8XdTnpMVtlw/K5+nXJULQW9w=;
	b=DiK2MDqLXwln0DA6QIP++zvgRyH8mHTJ1UDrzUjbIb9z7MrLwDItbITBseoUb036jTEs
	 Eary6gg7ztuIMGQL0bz9WWAPqkpJ7uk1zwsjG+qX3dWRPrnrtfR8NXeHgLOHAJ+781bvc
	 fBm/AWEjcc9XwB/asTYYZrQrV5H21evxJNRQSmJ6AWZhGPhfAv1pzJD+Ezz4vHxfBgz7Y
	 GLH/HV/hqP1avBMvIi1F6zDMXOodWkcPGYH/Qh4xtVyiNKHvBtZEiDJt/RfajmNgDoX1P
	 Nju4zCiakmm2gvJL12lsueg5Nw9S/ohvSWWsS7R7RWmeNOdS3OHZxSTPgDleaWo/f6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t+5nyUbY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E8BA60A3839;
	Sat,  7 Nov 2026 14:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t+5nyUbY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33FE21F0089F;
	Sat,  7 Nov 2026 14:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062303;
	bh=YLaKUrJ0tSdI5I3NxbT8XdTnpMVtlw/K5+nXJULQW9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t+5nyUbYSpg5hh3oJwVB22vvldeppNK7IhLvMYSuAxlpgr1j3XGz+WMwzkcNehfes
	 VTymEsCceeFxEUQ/q3VacMfOjgtSn6vj4NeZ2gUk+dIiJcUIJ6yTW93zlu+Q/D+6UL
	 LG4fa5RlV5epQE8JhzdKmaSqw+9YhmFyCXB1DXt4=
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
Subject: [PATCH 6.12 1201/1536] mm/zswap: enable zswap_ever_enabled in zswap_pool_create()
Date: Sat,  7 Nov 2026 08:53:37 -0500
Message-ID: <20261107135031.481522417@linuxfoundation.org>
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
index e058195ee4c48..6c50249d5398f 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -304,6 +304,8 @@ static struct zswap_pool *zswap_pool_create(char *type, char *compressor)
 
 	zswap_pool_debug("created", pool);
 
+	static_branch_enable(&zswap_ever_enabled);
+
 	return pool;
 
 ref_fail:
@@ -1778,7 +1780,6 @@ static int zswap_setup(void)
 			zpool_get_type(pool->zpool));
 		list_add(&pool->list, &zswap_pools);
 		zswap_has_pool = true;
-		static_branch_enable(&zswap_ever_enabled);
 	} else {
 		pr_err("pool creation failed\n");
 		zswap_enabled = false;
-- 
2.53.0




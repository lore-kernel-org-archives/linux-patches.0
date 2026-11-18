Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034632;
	b=ulMzDyF3hIok6kJLp3Af6RXT+aAzTdkAwb1J+2sqWQ5lvTW2duHYJdbFInRuDh6eHEUK
	 Nxr6kCSfjXfLpj42poG1C5Y66x/clsXuXorM4FZE2wBUj/kEt89OX7PxgbrXGpD8aHiV9
	 aBgCAcyhCzB+pXGZKx4P1HPsXbnMoZNe+dKYl8Q6cw5dQaCHKMwO5AlSQw9VTuZBqVOrQ
	 yTGmQNsijmIh5+u2yxVgRQK94wH2xoWrfhyDbEt0LQv7AOHqjBWmzQ8NiDvaLB6IJM6DY
	 JCaxbW5hdQKUFc9s7yq3yT22uQfXcLmWahf04KZidyzPSdCCv+R6TtTFZLtRtb/AspQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034632;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ynRxNkAfh/Jj8qpvQtpWVyOHPo4GjixWGsIYdwNGP3M=;
	b=NavtNYGbL+FtPF610Co2iHM5wSvMaXuxs8O3RN4q0/SM92IvLPYB7OT152S/PMKrnKmy
	 BZPthwXkk1CyR+MY0LSfwlYTdbRpQb/N3Yx7xqHYCEjCHkFxsIfBUlIevSNm4iIwqxn2Q
	 xfJxNy4ZpR0WLmr6ZTuQrQV78G5U5ZK/U1FonrsWoe0cdf09Gcm5vke3pbpBrE7n/w8b3
	 a9jzdw4MDm7ot0lBw5GJl+2XTIFWK5m24SIv5v+ML7ImKZWRZ/aNGbrvtTVSJY6yTdtgN
	 nDasG5l/0znjNM1g3SvlNomvLXkD+KDXVT1O8PFxZdmVBkTKAqcLiITwMU5cXdF0UTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CjqM07px;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB79606A320;
	Wed, 18 Nov 2026 20:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CjqM07px
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 365E71F000C4;
	Wed, 18 Nov 2026 20:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034631;
	bh=ynRxNkAfh/Jj8qpvQtpWVyOHPo4GjixWGsIYdwNGP3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CjqM07px8Vz07BdwzzQF1r2OuWv5BX3Kg2d4bHfc5M8V+z+Tgp16VE7b9sUJj7tnq
	 3a6k/1e2c9kVDcREIMnDl8D/xyPDLc/afXJQjy93eBI6pcan5wtmlrKmekUOu2n8ey
	 R5PyQwELVH6tmwFuJq00V+Pp6RjeFYGsgh5mk+yc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Longlong Xia <xialonglong@kylinos.cn>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Minchan Kim <minchan@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0431/3318] zsmalloc: account for handle size in class lookup
Date: Wed, 18 Nov 2026 15:17:33 +0100
Message-ID: <20261118150329.559855341@linuxfoundation.org>
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

From: Longlong Xia <xialonglong@kylinos.cn>

[ Upstream commit f7bf5cd5b5f2b13fe2361860880c4e214c08b440 ]

zs_lookup_class_index() lets zram recompression decide whether a newly
compressed object would use a smaller size class.  It currently classifies
the payload size directly, while zs_malloc() adds ZS_HANDLE_SIZE before
selecting the class.

This makes lookup disagree with allocation near size-class boundaries.
With 4 KiB pages, CONFIG_ZSMALLOC_CHAIN_SIZE=8, and 64-bit handles, a
1025-to-1024-byte recompression appears to move from class 64 to class 62
although both allocations use class 64.  Conversely, a 1049-to-1025-byte
recompression appears to stay in class 64 although the allocations move
from class 65 to class 64.

As a result, zram can accept replacements with no allocation benefit or
reject ones that would save memory, potentially marking the object
incompressible.

Factor size-class selection into lookup_size_class(), account for the
handle there, and use the helper for both lookup and allocation.

Link: https://lore.kernel.org/20260809115518.3791787-1-xialonglong2025@163.com
Fixes: 7c2af309abd2 ("zram: add size class equals check into recompression")
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ sashal: Context adapted: the new helper is inserted above class_stat_inc() (not yet renamed class_stat_add()), and zs_malloc() keeps its three-argument signature and pool-wide lock. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/zsmalloc.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 14327fc34aa71..85cb0d06db01e 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -516,6 +516,11 @@ static int get_size_class_index(int size)
 	return min_t(int, ZS_SIZE_CLASSES - 1, idx);
 }
 
+static struct size_class *lookup_size_class(struct zs_pool *pool, size_t size)
+{
+	return pool->size_class[get_size_class_index(size + ZS_HANDLE_SIZE)];
+}
+
 static inline void class_stat_inc(struct size_class *class,
 				int type, unsigned long cnt)
 {
@@ -1163,7 +1168,7 @@ unsigned int zs_lookup_class_index(struct zs_pool *pool, unsigned int size)
 {
 	struct size_class *class;
 
-	class = pool->size_class[get_size_class_index(size)];
+	class = lookup_size_class(pool, size);
 
 	return class->index;
 }
@@ -1372,9 +1377,7 @@ unsigned long zs_malloc(struct zs_pool *pool, size_t size, gfp_t gfp)
 	if (!handle)
 		return (unsigned long)ERR_PTR(-ENOMEM);
 
-	/* extra space in chunk to keep the handle */
-	size += ZS_HANDLE_SIZE;
-	class = pool->size_class[get_size_class_index(size)];
+	class = lookup_size_class(pool, size);
 
 	/* pool->lock effectively protects the zpage migration */
 	spin_lock(&pool->lock);
-- 
2.53.0




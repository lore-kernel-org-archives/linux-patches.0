Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027878;
	b=S98WTleMQL4RWL5dgYDzQQFAfbvDWwIIRK7DiQerY9xl6XqakP/oPmb2Um5PpPZKFkDt
	 gpZBroCTnb8FbxlePbGm0+0/uGNq2NUPtVBt52ya1dbLz6E7Bcf41vf6bSryU4OWKtL9P
	 CWTK/039m6eKWpv6cXdqQcnt/Sk6QpPAj+AnSEjb0z7dEBFRfzTnX7rHppTsvaLGrdzXM
	 bR3TT6sCzVoXGX3ChWn/EtemcEB/KJVmXvDHpv7kGyObDdTxMutsAc1k0vn46iT5b27eX
	 34B7pXIxDR7K9s2fD3q/T3D8a7vGD6ZcIdP0ji5ztOIzf8R3A0O7w1yPQ/xfxcqOXNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027878;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7zxw68eXfAvWX/0KBhaWvFMAtBz/b6syx9bWNtU1UGA=;
	b=i999rzAE9dwdmqA378VRvz+UUm+EN0L23c8OWDfH8g6pFrBZq2SfoQvowIvXNPdSCI8T
	 q6XJLMedP5Ozme01+kMC6jR7+oNbft1hCb/2hn0huub9X8UyW3IDlqVXoHHTGmv3O+TqA
	 jvdV76s0jofPaN1R0SVi5OSJNMLL2LLCtxDb4m7hAkJQQWJwWsl+Y9Cd8NXjSUsHnT1XH
	 5vT0AmoIAUQNt89LKKzHjnKVyMefRP+PHZhCh/u5CL17R+HNTNoYag+uPUwD8XaiLDP/T
	 YeW+StJjYrfC5Nr7rvFfo/Cdy4Bxe9njbqQ0IbD7qyazLyHDOCnHBsTO2xRnVYwdUfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="fh/Qeold";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C38C606A31C;
	Wed, 18 Nov 2026 18:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fh/Qeold
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C22601F000C4;
	Wed, 18 Nov 2026 18:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027878;
	bh=7zxw68eXfAvWX/0KBhaWvFMAtBz/b6syx9bWNtU1UGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fh/QeoldgqqhQL7KThCUZqAdOpSiz3G6dBlsyJwqQdgv3viJwhT9K7losLoyI1zmi
	 Ow954v29yHR7i4vjObyvkdm4hzB8tg8ETyo1hk4DzFwT5ae2ORnKM55j4yVgZqkcMc
	 4R+bTZEoA3blCQnOSCs0SpnW2/1JjNpTkAqwO6PA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Liam R. Howlett (Google)" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	"Vishal Moola (Fractile)" <vishal.moola@gmail.com>,
	SJ Park <sj@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1944/2151] tools/testing/shared: catch a failed posix_memalign()
Date: Wed, 18 Nov 2026 16:01:19 +0100
Message-ID: <20261118150232.585400922@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liam R. Howlett (Google) <liam@infradead.org>

[ Upstream commit c9ed13789061af00d9239f9fab8e246adbed2076 ]

posix_memalign() returns zero or a positive error number and never sets
errno, so the checks for a negative return in kmem_cache_alloc_lru() and
kmem_cache_alloc_bulk() is not possible.  A failed aligned allocation
carries on with the pointer unset, into the constructor or the memset().

Test for any non-zero return.

Link: https://lore.kernel.org/20261020033128.1934349-1-liam@infradead.org
Fixes: 8801c35c3672 ("tools: fix -Wunused-result in linux.c")
Signed-off-by: Liam R. Howlett (Google) <liam@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Vishal Moola (Fractile) <vishal.moola@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/shared/linux.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/shared/linux.c b/tools/testing/shared/linux.c
index 8c72571559583..590428436025e 100644
--- a/tools/testing/shared/linux.c
+++ b/tools/testing/shared/linux.c
@@ -83,7 +83,7 @@ void *kmem_cache_alloc_lru(struct kmem_cache *cachep, struct list_lru *lru,
 	} else {
 		pthread_mutex_unlock(&cachep->lock);
 		if (cachep->align) {
-			if (posix_memalign(&p, cachep->align, cachep->size) < 0)
+			if (posix_memalign(&p, cachep->align, cachep->size))
 				return NULL;
 		} else {
 			p = malloc(cachep->size);
@@ -191,7 +191,7 @@ int kmem_cache_alloc_bulk(struct kmem_cache *cachep, gfp_t gfp, size_t size,
 
 			if (cachep->align) {
 				if (posix_memalign(&p[i], cachep->align,
-					       cachep->size) < 0)
+					       cachep->size))
 					break;
 			} else {
 				p[i] = malloc(cachep->size);
-- 
2.53.0




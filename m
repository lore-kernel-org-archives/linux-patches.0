Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026588;
	b=a71uivqIP9MifSjQ97j7X/BzNVDzCos/uByIYpvv0XgxRdfX9LP3e5rHmPFRQVKKZTc+
	 ypj9O9w4VvL+6vhcZ5/xin6ZvAuPFCCOnrY0g9jRu6J1o4ewjpHanwW1AV/G6m8fo6qaS
	 ZY6xTx24G9Aig2hsSOmrvFBuPuzoxh56Kf7ruM3LwP6d80joBCzjRDpjMwMcAdS002fwS
	 Z578RfL23OX9pZuPoAn7YEq78gbXDi0SPcd8UsrUTDP5mfWCJ3VX5/fGbtURA3HnjMb/2
	 zk3lRsR2PmfB/71y956dGfcSsU6eLf36OThZv/ECu8S91QGvh+ZERs/cBnatIXKoZSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026588;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KVgj81zL8ZvV9ITY5dXEMSJf0KvhF9QzKze8lfNXNWo=;
	b=rd/psWFCar/VvjQu5m0f2pdigMiyhVKykm2+yB50UKCplgX24hQKa+VF8CWFscx0fdDF
	 DPGkAgJ6fNCp+OAt+QdzUJ8he4BUXGtNfXeUlkBiFpvAmgs3Z1UBdoB92tiUovA82b8/D
	 aLIZC0IgoVvpaH5thHgEVl3oSArUYUbM/eU81mhDWONq0HjUvmGgYG6xXM+N1MqPhPqAO
	 iqlLqm9RUc83qPj0QJaPykYjRY6brhGpg48fmWeFDwK2mILWWgpvpAcvIi5JzvTL7zQ2I
	 RKKJMcfErDYNq+HCsllNk8Qh2Dg4IY6NZ9FslQO/3TKsaUPbaUgc7GtK8oHLR6CF9/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X7neW9gB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2965606A31C;
	Wed, 18 Nov 2026 18:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X7neW9gB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E025C1F000C4;
	Wed, 18 Nov 2026 18:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026588;
	bh=KVgj81zL8ZvV9ITY5dXEMSJf0KvhF9QzKze8lfNXNWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X7neW9gBHLHzJRWjzcYOtlGdqTkaUK8bbF729EjePH4jMAjg9fWwArMND27IxsqUJ
	 BQDvyRkzl3nuS0gIEpIF0Lyd3OA+vS9VTtWUvs4X+D1VRMhwmeSiLLStr+NTvlkk1d
	 LylK8PdC/G3SjlM9yvpLNv6ja0uy3K1Z9BEm9hyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Harry Yoo (Meta)" <harry@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Hao Li <hao.li@linux.dev>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1489/2151] mm/slab: Mark the kmem_buckets_create() context as a Context: section
Date: Wed, 18 Nov 2026 15:53:44 +0100
Message-ID: <20261118150216.119099291@linuxfoundation.org>
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

From: Kees Cook <kees@kernel.org>

[ Upstream commit 655668f0caf32a42fef10aaf31137e52f46a0260 ]

kmem_buckets_create() had the same sentence about calling context as
kmem_cache_create(), but lacked the "Context:" prefix, so kernel-doc
rendered in the body instead of as a "context" section.

Give it the missing prefix. Additionally fix the "a interrupt" typo
__kmem_cache_create_args() had.

Fixes: b32801d1255be ("mm/slab: Introduce kmem_buckets_create() and family")
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
Acked-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Hao Li <hao.li@linux.dev>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Kees Cook <kees@kernel.org>
Link: https://patch.msgid.link/20261014052344.384723-1-kees@kernel.org
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/slab_common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index 0058d1f25905c..9a95bed7ca39b 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -308,7 +308,7 @@ __kmem_cache_alias(const char *name, unsigned int size, slab_flags_t flags,
  * &SLAB_TYPESAFE_BY_RCU - Slab page (not individual objects) freeing delayed
  * by a grace period - see the full description before using.
  *
- * Context: Cannot be called within a interrupt, but can be interrupted.
+ * Context: Cannot be called within an interrupt, but can be interrupted.
  *
  * Return: a pointer to the cache on success, NULL on failure.
  */
@@ -405,7 +405,7 @@ static struct kmem_cache *kmem_buckets_cache __ro_after_init;
  *		to/from userspace.
  * @ctor: A constructor for the objects, run when new allocations are made.
  *
- * Cannot be called within an interrupt, but can be interrupted.
+ * Context: Cannot be called within an interrupt, but can be interrupted.
  *
  * Return: a pointer to the cache on success, NULL on failure. When
  * CONFIG_SLAB_BUCKETS is not enabled, ZERO_SIZE_PTR is returned, and
-- 
2.53.0




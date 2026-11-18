Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020249;
	b=GXGfiOwylp3JsTgfKIUZjlaa33TS5+KAzTatFItUkzNZjNrYGh0ErO3F+NH6MGIEZ+XF
	 jK09m8pdjRpOFq5NCVNq92F1E7zC36ZTxVwzoJE7+hOBhfmBBkDX7P7eOUGDmCbOy+Xyd
	 QdnDGMSwRuiUa3JhVadqoRF4QT/IAVSVPPFRUn/TTFYuoMnl+YggPTHgA9xfuXrFN0nYP
	 QeVwu9Zp5zVRvr8OvIKRUrl7tNbSBozL1rONtJlDPyq/Aho7O59/EtqUSW6s66RynUV/h
	 M2bFtcnMdIpedyLRy8oMAsi90gOjaouj0XSGBJhT45q4B3NTTWkni26BmDJH7mGQIQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020249;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5PYR/SmTmakEj9mB3TnpQHGz+e+nr/ivCXmLaeiXm8I=;
	b=FlLquiTvL+358ejfPqs1Zy4mVOZda2SS0zaA5Od1AjWmmUWH1+3O+L+DlbWAaqn/3qdL
	 /H15jhq+RPlB/Oz+/jZDWROQy8KKLmtHUaiVmHEb1zV+0cLGzVD9ZqpGBb83+7nkrNZts
	 W0rmJe3u7h30MmnuFqtFloSJfmyppgYcsrtVe+Ltf/fpPbNsnFpE3sSA0KmTpgT5fA/LW
	 5lo7SGmZBOgjNff2JWNaeSZ8RrKdn0NaR8aeIC11yT2dxgBrbP8Szv/7PpKa111rZPmiS
	 oB0s5FFW9hgQ4erHD4S4Gd9l+tg0Jp/gRN5ORfkg8EBsGf4P24s1Sik90Tl50fp9oUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i9xyInul;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4ABD606A31C;
	Wed, 18 Nov 2026 16:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i9xyInul
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B0331F000C4;
	Wed, 18 Nov 2026 16:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020249;
	bh=5PYR/SmTmakEj9mB3TnpQHGz+e+nr/ivCXmLaeiXm8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i9xyInul+R79PPRF7Hpk2CNV4E+Mky6Ih+nv+3eqkieofqVERinkp61I+YqDgBuaH
	 5n+N4dm4hKtmXVIO1Bu4GFlbFM8Z6A721qv6xlSnX75Srqijtod60zCoQZ6gFayNAw
	 nAItMqTsaNCUSG6CipJ3DaTXftjwLKMHdaye1zmU=
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
Subject: [PATCH 7.3 1832/2651] mm/slab: Mark the kmem_buckets_create() context as a Context: section
Date: Wed, 18 Nov 2026 15:51:12 +0100
Message-ID: <20261118150353.073356814@linuxfoundation.org>
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
index de11edfd1a0bc..84366c112f4b1 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -311,7 +311,7 @@ __kmem_cache_alias(const char *name, unsigned int size, slab_flags_t flags,
  * &SLAB_TYPESAFE_BY_RCU - Slab page (not individual objects) freeing delayed
  * by a grace period - see the full description before using.
  *
- * Context: Cannot be called within a interrupt, but can be interrupted.
+ * Context: Cannot be called within an interrupt, but can be interrupted.
  *
  * Return: a pointer to the cache on success, NULL on failure.
  */
@@ -422,7 +422,7 @@ static struct kmem_cache *kmem_buckets_cache __ro_after_init;
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




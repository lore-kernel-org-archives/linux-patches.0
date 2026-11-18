Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021015;
	b=BIbS8G2pa7wk/XcCgaYpsR77En8vDqMDJSh8DiTQz/efh/5iagDYSYtYqqY322XLiY94
	 ZLu2Esxx1Y0Bm+YWe+fOI4Vk/g5q3lcYFu7YGP5KTQLag55+/6tF0kDpNHk6ou5pULAzJ
	 +iCras/9cVpG3AGkduYYxy957A3j+sN4Nvk8csbLn9OaZtMBZDloCtNsA0BFpI8iEmXwN
	 5k6NYNLEiMQS99dnXjkN4roc9x7arbvSILGn0NJE+IbfLP34s359Hc9OQBUDya2NkIQIN
	 CgCjWUB0vMHOkdHWhzdssJfoFqROk+aHJizi5XHpEpNjBcOlE3bnlWGWiuhKZolQKjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021015;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4S/8iMqZx5rs+yt4OcR92W9wSwiF0oyEmtLHK+LMcGA=;
	b=qdO5QG27NU231rE6gasnnh6XV2YyuAfRrk4HB2z5JabNzom0QaRllgcxvJHBr23YCSw1
	 X6XtBrFKl5FfysuTPkRsgxyb/0YNJ9zNzX7SJL1lixJdrSzrBXQnUUCE5WNn3F7RKT+Ze
	 MDG4ds/Y5E7oC6+Q/pJ4E4bZusVt14jqVBn6dnTqkJUvUrmZ9C8M7k4UNgNYfeP7vBnbz
	 2MUqlZyuzcv4/85oYhx+MD2EMaPjb5pxrHsFCxIOzvAEWRhIZcADYuJN+8YeAQXbp2EFs
	 fPp9PecuirS+cNyf4DXKLik3+92HXQ/aoPo0plBIM7fLYX+pvx2ohuSHP/SFCwkJDAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oanPwR9e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82074606A31C;
	Wed, 18 Nov 2026 16:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oanPwR9e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D91FC1F000C4;
	Wed, 18 Nov 2026 16:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021015;
	bh=4S/8iMqZx5rs+yt4OcR92W9wSwiF0oyEmtLHK+LMcGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oanPwR9eWaZ0Iah4bSghQT/CFUOW/gPgWMcjD137Cyr8Ho7ul+SxfzndXZPnsj7wM
	 rUd6/BQ4I8xhESOFQ5gVzx4b2ooWNMbRFuvDn0cabaEl/FOKT0FsxdvFjTnTBROWMS
	 XIK7HeEOZxPrIB0Utn2z9qS34FXeJ2OWOk8uFeBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	"Harry Yoo (Meta)" <harry@kernel.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Shengming Hu <hu.shengming@zte.com.cn>,
	David Rientjes <rientjes@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2158/2651] mm/slub: initialize the free pointer of the bootstrap kmem_cache_node
Date: Wed, 18 Nov 2026 15:56:38 +0100
Message-ID: <20261118150403.502848806@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit d15d7703166daf7bd62c844a3cb1b3a6279adb4c ]

With slub_debug=FZPU, validating kmem_cache_node reports

  BUG kmem_cache_node (Not tainted): Freepointer corrupt
  Object 0xffff888000140040 @offset=64 fp=0x5a5a5a5a5a5a5a5a

and taints the kernel. Poisoning places the bootstrap object's free
pointer outside the object, where check_object() checks it even while
allocated.

early_kmem_cache_node_alloc() previously took this object from a
freelist with an initialized pointer. It now takes it from the slab
iterator and builds the freelist only for the remaining objects,
leaving its pointer filled with POISON_INUSE.

Initialize the bootstrap object's free pointer to NULL.

Fixes: dc795d4c0282 ("mm/slub: defer freelist construction until after bulk allocation from a new slab")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
Link: https://patch.msgid.link/20261010203906.93156-1-kmehltretter@gmail.com
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Shengming Hu <hu.shengming@zte.com.cn>
Tested-by: David Rientjes <rientjes@google.com>
Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/slub.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/slub.c b/mm/slub.c
index 544cff39762c5..6bb75db087a2d 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -7778,6 +7778,7 @@ static void early_kmem_cache_node_alloc(int node)
 
 	n = next_slab_obj(kmem_cache_node, &iter);
 	BUG_ON(!n);
+	set_freepointer(kmem_cache_node, n, NULL);
 
 	slab->inuse = 1;
 	build_slab_freelist(kmem_cache_node, slab, &iter);
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C19F22257E;
	Tue,  8 Apr 2025 11:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113009; cv=none; b=MXWt9eTPzH2b1048RDW3EncNGkJ2HiBJ+gnw/fs84FbWhHvF3LAqQLwMgrJ1Q7JmEGOUNLK4U9BRnerosBF5Yx3ywoGK4fZb0JMZ23FPeET2utvE3BYKYG8pdIum2TtHaDaQSWricPR6vpnK5G3PYC3mkaQpa5+r/OIxofxFXfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113009; c=relaxed/simple;
	bh=AxBDGED06w1Z1xfF2kLFzweT43nwZJLpJAFksKv4kEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ON1kKdZPZL6c4a2XCvan5UeUxfUtJdzq4lGpCjfWRmEutp4g6prHc6fE8f6PcKcSw+cVku6yBKF0N8ym+MaAfUzZHTy9Cok3MeQly70pTrLxxWY3W2bYLV7N+CZtUGbSau91Ma2f9cZAPWRanVN+Gmus7iJnXP6RVzd/4ET1mP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oCiHOZj6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oCiHOZj6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DECEFC4CEE5;
	Tue,  8 Apr 2025 11:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113009;
	bh=AxBDGED06w1Z1xfF2kLFzweT43nwZJLpJAFksKv4kEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oCiHOZj6fZlwNKC7FET4HrNQp9XIsNFpEKW23sDbNZEWDDjUX6UYquby+/HtT5icx
	 GAIVteVn685W32Tvuv/xn4DIiBJmUd24EpzKF62EU/n4z79Z0QRYrH3eqr7uikNBKg
	 LnhKCxioOvT1iV7Ce7BghqBM4TuGvJzirXmAIU9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akira Yokosawa <akiyks@gmail.com>,
	Kees Cook <keescook@chromium.org>,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 5.15 279/279] mm, slab: remove duplicate kernel-doc comment for ksize()
Date: Tue,  8 Apr 2025 12:51:02 +0200
Message-ID: <20250408104833.922066944@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlastimil Babka <vbabka@suse.cz>

commit c18c20f16219516b12a4f2fd29c25e06be97e064 upstream.

Akira reports:

> "make htmldocs" reports duplicate C declaration of ksize() as follows:

> /linux/Documentation/core-api/mm-api:43: ./mm/slab_common.c:1428: WARNING: Duplicate C declaration, also defined at core-api/mm-api:212.
> Declaration is '.. c:function:: size_t ksize (const void *objp)'.

> This is due to the kernel-doc comment for ksize() declaration added in
> include/linux/slab.h by commit 05a940656e1e ("slab: Introduce
> kmalloc_size_roundup()").

There is an older kernel-doc comment for ksize() definition in
mm/slab_common.c, which is not only duplicated, but also contradicts the
new one - the additional storage discovered by ksize() should not be
used by callers anymore. Delete the old kernel-doc.

Reported-by: Akira Yokosawa <akiyks@gmail.com>
Link: https://lore.kernel.org/all/d33440f6-40cf-9747-3340-e54ffaf7afb8@gmail.com/
Fixes: 05a940656e1e ("slab: Introduce kmalloc_size_roundup()")
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/slab_common.c |   14 --------------
 1 file changed, 14 deletions(-)

--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1305,20 +1305,6 @@ void kfree_sensitive(const void *p)
 }
 EXPORT_SYMBOL(kfree_sensitive);
 
-/**
- * ksize - get the actual amount of memory allocated for a given object
- * @objp: Pointer to the object
- *
- * kmalloc may internally round up allocations and return more memory
- * than requested. ksize() can be used to determine the actual amount of
- * memory allocated. The caller may use this additional memory, even though
- * a smaller amount of memory was initially specified with the kmalloc call.
- * The caller must guarantee that objp points to a valid object previously
- * allocated with either kmalloc() or kmem_cache_alloc(). The object
- * must not be freed during the duration of the call.
- *
- * Return: size of the actual memory used by @objp in bytes
- */
 size_t ksize(const void *objp)
 {
 	size_t size;



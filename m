Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D5C373C1A;
	Thu, 30 Jul 2026 15:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426176; cv=none; b=qaV7M/VjeH3hxnWx77SduClCbO9NjbZQebWx//EbeCoouRp9X90b2Vhlctlyc0ExXy0NqLHfJTY/gaoUiXwDxW9WggJgNyCa76u6sdHZMOo+8vWrpwi6rnFMkJ3v4DZsdG7YEkiutLoGoWf/9MFltZkKrm0LKKCB7XHnhG6n2HE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426176; c=relaxed/simple;
	bh=9+uPVBjPfkJ1RvdbMJR8+h1WpcwK66cpXhyLJ+FHGEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d1QqV3u+nFZVocEGzD7QT58gK5DK6U7QdatKspr5jEkDj57J9sidoEfK5AwwBsBx/9bRxY9WVHzODAoYGoHByf8yOevuNQOpbA8UZUQBhbTe5l7Uz56AuQnHwgqVDurCjdqN6xedrZW0DRnTsmuJlcU0nBBggBsAdGo0ACXpp3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YZLeqLhc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YZLeqLhc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD4411F000E9;
	Thu, 30 Jul 2026 15:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426175;
	bh=UqJb9l8aZLqiY8cFnkeULW+r6OstUVL/nEABWOyhocM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YZLeqLhcEnvYRCM+4GUNTbvzdw7VYXxxs6g4GkGILaPPBJAVuG2MeqLcAidlFM1dy
	 vPrAhPrdR2lCFd2stVh+o06HPsXrl5aVXFQajGEykQbhEqc03GrRFvkPvkw5giC9lc
	 svpLdye+rKpKWEViFsa20YVcfFbR/q5sXA25o344=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Hodo <martin.hodo@intel.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sebastian Brzezinka <sebastian.brzezinka@intel.com>
Subject: [PATCH 6.12 283/602] drm/i915: Return NULL on error in active_instance
Date: Thu, 30 Jul 2026 16:11:15 +0200
Message-ID: <20260730141441.916848622@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>

commit 1e33f0de5fdcd09e51fdec1e5822448970b6420f upstream.

Avoid returning &node->base when node is NULL due to OOM
during GFP_ATOMIC allocation.

Discovered using AI-assisted static analysis confirmed by
Intel Product Security.

Reported-by: Martin Hodo <martin.hodo@intel.com>
Fixes: bfaae47db3c0 ("drm/i915: make lockdep slightly happier about execbuf.")
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Simona Vetter <simona.vetter@ffwll.ch>
Cc: <stable@vger.kernel.org> # v5.13+
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Reviewed-by: Sebastian Brzezinka <sebastian.brzezinka@intel.com>
Reviewed-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Link: https://patch.msgid.link/20260624090940.74840-1-joonas.lahtinen@linux.intel.com
(cherry picked from commit 6029bc064f0b1bac184203a50fbaaf070fa18832)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/i915_active.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/i915_active.c
+++ b/drivers/gpu/drm/i915/i915_active.c
@@ -319,7 +319,7 @@ active_instance(struct i915_active *ref,
 	 */
 	node = kmem_cache_alloc(slab_cache, GFP_ATOMIC);
 	if (!node)
-		goto out;
+		goto err;
 
 	__i915_active_fence_init(&node->base, NULL, node_retire);
 	node->ref = ref;
@@ -333,6 +333,11 @@ out:
 	spin_unlock_irq(&ref->tree_lock);
 
 	return &node->base;
+
+err:
+	spin_unlock_irq(&ref->tree_lock);
+
+	return NULL;
 }
 
 void __i915_active_init(struct i915_active *ref,



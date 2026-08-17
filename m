Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F1D175A6B;
	Mon, 17 Aug 2026 14:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977030; cv=none; b=mzUF5uWwEYy9pggVj31gHiEXTemUXT+KEDbJM6oLsumniABEARMJYOXbaf7LTBqNWui1CiN4D0RAZ8JWVr4hUE6Ias0j9ztwi6G5ioItS2gtA0brdwNigO4Kp7GgMj/l90Kpd8l4rU3kPnWtIYc5mGLQ4cqX2yZrSpuYwZPy8jQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977030; c=relaxed/simple;
	bh=27HfTDqaINJs5cIC//vEDXyQIcWTr+lf7r5MSS+Oqg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S0N3MVUqfguuC4jy3mUA2aBTdvGp89q9Bkoy6+23ZTww2CuDFUxERI5ye2vX9hrRwennUJXjaXLKw1qlpL6Ab6u8AeqoMHna2jWVuO1smNjuCG49RjEHT9YDa/WTqh/FF4enuld0PUFkvVQ2yEnEm2JIKl9tbP8RPPHmIuF65KA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tMKK1sn4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tMKK1sn4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC3121F000E9;
	Mon, 17 Aug 2026 14:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977029;
	bh=sFulJKLMOpAtdnEBm32yz5ancAhi5RXnKmxPZsUwZHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tMKK1sn4/nYeZ9ukB4AflI0CGTps2SlmCEBJi3RAp+rGslYzINHw1v20vdmTrka7R
	 0npKZEMemBKuyzm7jP5JfGC3RYOi5mn85ggib1C/HEMnV64dRho3ivZzbSV0H5OuPw
	 dZGhL4Dr3f1jm+LfETUHzNc6NcgLuPAfwnyOLscY=
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
Subject: [PATCH 5.15 148/456] drm/i915: Return NULL on error in active_instance
Date: Mon, 17 Aug 2026 15:28:58 +0200
Message-ID: <20260817132545.864616758@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



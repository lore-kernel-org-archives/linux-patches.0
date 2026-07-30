Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18AEE3955D7;
	Thu, 30 Jul 2026 16:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427600; cv=none; b=JdBx5Fj7rTETVcI0qn1DWhgELUQRiaeyZEjFP7cwJxiTp0UsotcMgtyfzQpayIrriJFdHsKTHYalTUX3kpNTRxWL1wmQ5nGGFl736wZ8DGRQYI67qKQN8U512UkHPhzBXLkpqZoMM6aN5T+PKHROeiOovf9EJ7PlOLcQpIRyWKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427600; c=relaxed/simple;
	bh=+QX8OTYtAbMZtZ4S6H+0bAzzhblxanBtn7cyiHZ/tjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=COy5xFTgyUc5h3vWZZy69MwdOVPTnMKxTEA2HCxkVb2DXdpBAz4biMEbID45WQnQoqFA1c/y5/oqFDJniuqtCOFDyNImEHz7sW6AlVSNl4PDso2O1pwzhwMBdXDR5nadYLL79hsPa2CEz/6W1pYrsf6MbK+GbpGVhEeSdJvS4y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2R9D8oup; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2R9D8oup"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C55A1F000E9;
	Thu, 30 Jul 2026 16:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427599;
	bh=vtie5VXH5qNYj4bl6+FOq5CukrByl2+xvMIAIO5y+aM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2R9D8oup9TUnqA71YOVIHT/JrLQA5SgB4YRyD1fGHXPZgkgBE4hfHeZUy8UmlLf/P
	 uxOoT9SsqwMhRAOh1jK/9DzpTOqWkGO1PaFVuWZ+IRISZhfvFfgQVNWpZ1dE4vW/It
	 YvBtF2dD87ViliRVnAmEPaq64H0zEZqvOx6ZYbDE=
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
Subject: [PATCH 6.6 225/484] drm/i915: Return NULL on error in active_instance
Date: Thu, 30 Jul 2026 16:12:02 +0200
Message-ID: <20260730141428.360188017@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



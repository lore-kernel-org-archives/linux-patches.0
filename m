Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A823932E9;
	Thu, 30 Jul 2026 16:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427568; cv=none; b=U4remBdeZrn62MvhX7j3XSaaP9XSOTYFzcTc3Scjgx+OSKROcWRXOlotdOHzwyhmK5MhkG1Drb1xpH95eUu04Blhj3UpH96FHfD/un7G/lCQqsM2Wbc6OyVLoqiHnEskmSjK3oUSUU9le2Oh0a8Iz81aF9bM0Yagv1bXPE6JVv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427568; c=relaxed/simple;
	bh=dslJk9bLB5OqYNWqTluwnFLwqWGbYcZTwGeHNRoEYHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kZP9gVRA1wnR42ySjH0ECvI9RhokfGF5wWcx1Lfhbs3bm8+JIhsW8q2q2c+nHuJPogTpOQbC9Ufqfz4PPta/4aw30pNCzgl6cGflvkFTrbeeyjTsACCLyyIy98d1fx7PkTVDMYWG3D2blKxHe2wHfHHNk1LZRAjqfassbYew5iU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ix6C3j6U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ix6C3j6U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A92C1F000E9;
	Thu, 30 Jul 2026 16:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427567;
	bh=AvWTlKn92+zGb6na6Dxpv/6XXfUayGeWnRbDKnFJAyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ix6C3j6UU/wsietR1tR8RVy636IqBjKWEoLuGWYOz+gPv1sOnUEDq9reDKmfi1Mu2
	 d8OYzL28KuqXbsORdkit5q+mCTPBpLGz4ysY/odQcS+m4QYr9+IUspZ3N4VTnVh3qR
	 A/D02FcEa7VqxNadW4/oRHYYtmgDNSSOWCOf64uk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Hodo <martin.hodo@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Subject: [PATCH 6.6 215/484] drm/i915/gem: Add missing nospec on parallel submit slot
Date: Thu, 30 Jul 2026 16:11:52 +0200
Message-ID: <20260730141428.143133611@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>

commit 914a76a9f08366434bf595700f62026b7a19a9cc upstream.

Add missing Spectre mitigation for userspace controlled parallel
submission slot.

Discovered using AI-assisted static analysis confirmed by Intel
Product Security.

Reported-by: Martin Hodo <martin.hodo@intel.com>
Fixes: e5e32171a2cf ("drm/i915/guc: Connect UAPI to GuC multi-lrc interface")
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Tvrtko Ursulin <tursulin@ursulin.net>
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Cc: <stable@vger.kernel.org> # v5.16+
Link: https://patch.msgid.link/20260622132539.165558-1-joonas.lahtinen@linux.intel.com
(cherry picked from commit 15b9353deff3cf72331c387780de3cf9c316b643)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_context.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/i915/gem/i915_gem_context.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_context.c
@@ -610,6 +610,7 @@ set_proto_ctx_engines_parallel_submit(st
 		return -EINVAL;
 	}
 
+	slot = array_index_nospec(slot, set->num_engines);
 	if (set->engines[slot].type != I915_GEM_ENGINE_TYPE_INVALID) {
 		drm_dbg(&i915->drm,
 			"Invalid placement[%d], already occupied\n", slot);



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FBD723AB9D;
	Mon, 17 Aug 2026 15:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979287; cv=none; b=LwAyc6+pN+E/tpyMYD6R9rSKd5vd3f3j+ogcHw+q0zJso33Yk9GD/R5GHJnUtO5+dJ8kZFVbIdvqXDlf7H7LO6JBdVodMEa/H8Uf8oXbcOuLbf1eudqOPMs4APDMKeb1V2poskws0Wnr2USbUGICLs5ZZM+NKvSg60LBG8pEXNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979287; c=relaxed/simple;
	bh=iOVcobUmBlRD4Uc2Q19k8X9RuSEtVU+JdsYrrI3EriI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G5Z9Z1zKSte8C5g0Q9R4+tjrFvy6wmLkij8pP7CQli2JnZUKAqobDCLch6NSTFkw9/8DGGA5cizjgQaGDZ2D0e6d2ZqwFsakTw02uzDhp9wdhEXAyVzRGVWxcEJX0xFzafgMjSr70is0GclbAy8+rkIC0ogxtTmtiC3lZCbPa8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uce1Pvkl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uce1Pvkl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B711D1F000E9;
	Mon, 17 Aug 2026 15:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979286;
	bh=2XkBQuJHXmgD0qSWUe+ys7/9MiW1hg3ExKkvUBODlwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uce1PvklOr4wB0o2e2HkgPtAF+tYS7b8LWfjXlLCtbPQRxAydpTn55C8bpG0OdE5s
	 pLEqY044vVlHmosBpXmJheMOHu7GoImEEpPLZn4hrrDoBCZ1IDBLkCavbdeAnyaRjH
	 3uiMH2rtrMhpFE/5I933r/zNr7p9NeAUEeGN9j74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Hodo <martin.hodo@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Subject: [PATCH 6.1 173/609] drm/i915/gem: Add missing nospec on parallel submit slot
Date: Mon, 17 Aug 2026 15:27:49 +0200
Message-ID: <20260817132549.843544738@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



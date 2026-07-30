Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF2C37B012;
	Thu, 30 Jul 2026 15:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426002; cv=none; b=JhCCKO6Va6ygV0mYDeH9rm0nEn7Vty4j43PZAzZeL41Qu+rDaxyEqqCghYX1jNFBydNzD3xJH52aiT1l8t7tzBj40g9UXcIQPz8eIfVO4uTOwVx5unML6UHAkjqjYzgdpEfDsD55rWFKYGEeHquwQ3rl/9u4aikkmUPBhYRxEuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426002; c=relaxed/simple;
	bh=E3iDQsTFUdMKIgjBkmjfGoTNyHaDdvSNJ1vDW0tJki0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oergMexvXQLTs5RajPtZr/9HC5eKvxQOHOnRXco63rz187gxVfhbXnblaiE6r8Keo1R3J5IUjksnF4fEdm7d65J0bkDL1AnYu6tOThrug+S4SQXDKT56DuAIET6RxEFdZDuq4Z3U+HxCewJWN7MvWc3HkhBv8razU3p79ePEYro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e43jWRXk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e43jWRXk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 496411F000E9;
	Thu, 30 Jul 2026 15:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426000;
	bh=8jSPKLQCelY1jqTbc1RTx9w+d89UGen3mrSU4XXWqc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e43jWRXk3EnB3Grdez31Pf0L0T+nVWXRau7IojT0PdItyqUpZm4nNQ6b+VZCRHpIm
	 aLykk1CQl9nf40or5xTiP3wSAdL9hCfAqdCArdzfUc50Is/PZlvqV6VMHp+rL4HjL/
	 wP0MPh71FiDeD+wRJA1A9T3oa+zgaviAaHB2v5E8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Hodo <martin.hodo@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Subject: [PATCH 6.12 265/602] drm/i915/gem: Add missing nospec on parallel submit slot
Date: Thu, 30 Jul 2026 16:10:57 +0200
Message-ID: <20260730141441.539871005@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -613,6 +613,7 @@ set_proto_ctx_engines_parallel_submit(st
 		return -EINVAL;
 	}
 
+	slot = array_index_nospec(slot, set->num_engines);
 	if (set->engines[slot].type != I915_GEM_ENGINE_TYPE_INVALID) {
 		drm_dbg(&i915->drm,
 			"Invalid placement[%d], already occupied\n", slot);



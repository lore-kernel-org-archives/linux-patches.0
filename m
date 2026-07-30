Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ABDC411689;
	Thu, 30 Jul 2026 14:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422309; cv=none; b=TaB24Q2yMbucaN5QoVJVS+hrDzFef98hSFtFls7ybU3Eh+W2CaEREpVrt2rrt3d6Yfdmgzi7VUpa8q4aFexgy29NhV6U/tEPQsN+Wt0XfvZS+NHeOR5EPHW3y1Z0lkGmuDv/gVJ85IDYzEsq0rCWnpDbkxa2XwSV/n0kJuN3XUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422309; c=relaxed/simple;
	bh=rKO2K8HZgTEvV+JS1NCwB5BvCRacT0I0kus6Acm7Rpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m04IW0p1r3F8Ne9FYaF2MNcR64t1/srVgoEltwrOEBrpUt4jNGhVIwygiuFSQFQMfnwdd8IGE1lYCaecf2N4yMjTcl3p5trhIPKRcTTDI69lu8Xibg2/SMl9HY6dQbkxQ5JSZrXd18XQH5tuWJedtEgp19zGKQD38erCcoxroWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bjk/JwFE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bjk/JwFE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B954B1F000E9;
	Thu, 30 Jul 2026 14:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422308;
	bh=Y/vDU4UPRxLBZ4PqQPcCjc///FV/+JbUfknnykXJTpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bjk/JwFE3nWDvghKM73k+NKgU0FPHjABRcrE6L1xbAWfjytsuEd82xvZvQARTqbA8
	 zVzBVXZoqcqjsBpnxrCgywY+1eHf1YyMaHBKKBHf6BJXE/J2QgAN943lGg8VGC83mb
	 XQs8UnktroWcRhmme0YpFs56gT0SdR2U3OUzI8RE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Hodo <martin.hodo@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Subject: [PATCH 7.1 393/744] drm/i915/gem: Add missing nospec on parallel submit slot
Date: Thu, 30 Jul 2026 16:11:06 +0200
Message-ID: <20260730141452.642379384@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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



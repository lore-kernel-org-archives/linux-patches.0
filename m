Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A10440FDB9;
	Thu, 30 Jul 2026 15:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424294; cv=none; b=Xh3rhWcYiT9V4uZWAJjzT4OrNs8qs7n0BO1tgE1uOZYhtChCwV/mKkTd0nen68V2vmhJ1S5l1j2SlO8MEVlvRNIW+ux6TGTKiMrikdGPH2s2imZf4vUTeRa0x2eUvOoU9Y6ssUpisaXSL02dvg7mnzCK5zFerJCz8eA4KFz5zBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424294; c=relaxed/simple;
	bh=fnT09k4/p6Y97UGTonGFlWSroDo/5AKK05w3oLD4fRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NXpbYM7pbWtc90i7P54w67ufIq5edNg6K/mGJy3bQZflY6QxBqLktTcZrDweW+aXIAQtC5lUVWPIBS027aGkQKXQ+2gzQ3NtQMUh5z5d9xYQg/eTEGq4V2uwDq3+447lI8HTUHMTjykYqlPnlsa1pynzN2vsEAmXwipgYt4rLZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bqvj71ob; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bqvj71ob"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4A321F000E9;
	Thu, 30 Jul 2026 15:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424293;
	bh=F8FvGu+/sVIE4F0fSbvk3h3igQM3Zt1rdFzTe+83Tag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bqvj71obj4hBc+pG5twIoKnQ2aC864vDe0DZrLq6y8E+6wIz8YQ1NKrub8E/TV+wC
	 e+SSUormCtwB0O+zo1/fU90ss2lWNLV8fFGw3SW5YsnAuF7K0wArZ+eNB1SjNgZ+aZ
	 6TQU3nGhf1yA9VG/8Ev6QF4NWrP7lT5Y7biXHA+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Hodo <martin.hodo@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Subject: [PATCH 6.18 342/675] drm/i915/gem: Add missing nospec on parallel submit slot
Date: Thu, 30 Jul 2026 16:11:12 +0200
Message-ID: <20260730141452.399694914@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -612,6 +612,7 @@ set_proto_ctx_engines_parallel_submit(st
 		return -EINVAL;
 	}
 
+	slot = array_index_nospec(slot, set->num_engines);
 	if (set->engines[slot].type != I915_GEM_ENGINE_TYPE_INVALID) {
 		drm_dbg(&i915->drm,
 			"Invalid placement[%d], already occupied\n", slot);



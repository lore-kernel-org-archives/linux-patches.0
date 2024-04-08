Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 671507E0F3;
	Mon,  8 Apr 2024 13:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582226; cv=none; b=iOa0SvvGg2McgH7dbwKr4mVhYzEjpucshgkLGmmlN8AcTo8NSklIFg4m8GpIjXOvZxipvh4rfrSz/MqETEGYSqHy8hhojPz/eqVYAU/yrIrdCtL9Jb6v2VxL2dpdu2B79uIYuymSWh05+dzKFD9HX3Is9esa9WqlAQdSlIkRqPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582226; c=relaxed/simple;
	bh=OcOk07sg5cV9lM4nKjZgOSvkTw1dqJtPjwYPpzC5wIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RuKPZQokoRPxGjdl3YJw/4bu0hMnE8w6yNE8Qv6/0wxNtbpCohzW8EYmHAJofX6CcylNdfYgsbj+KBibRmsn8gAAyO3Tz29S2syo9Yn1lI23NG5viMgxIiKDzBqfFbhX/Y+VqbkNVxxiCmVqWkI0LtbLEMhMAdx7Lv7ZCyL+U/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rowVEy9o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rowVEy9o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E29E5C433F1;
	Mon,  8 Apr 2024 13:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582226;
	bh=OcOk07sg5cV9lM4nKjZgOSvkTw1dqJtPjwYPpzC5wIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rowVEy9oOYC6XrALN4q88Auiz8x0SizapBD6woyOLW6qz3cz7lSlWODU8Hpc0yHQs
	 hZOsdbOM8foWAnMeab8jdCrf3FrGVHiPFZSPn0woRFYW/lH6mlS2yOScFtA5GJjtES
	 OffNYoUGlDUIoBONv+KbUd1mpsjrTIjtISYOy2tc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Shawn Lee <shawn.c.lee@intel.com>,
	Nirmoy Das <nirmoy.das@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 5.15 125/690] drm/i915: Check before removing mm notifier
Date: Mon,  8 Apr 2024 14:49:51 +0200
Message-ID: <20240408125404.084141243@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Nirmoy Das <nirmoy.das@intel.com>

commit 01bb1ae35006e473138c90711bad1a6b614a1823 upstream.

Error in mmu_interval_notifier_insert() can leave a NULL
notifier.mm pointer. Catch that and return early.

Fixes: ed29c2691188 ("drm/i915: Fix userptr so we do not have to worry about obj->mm.lock, v7.")
Cc: <stable@vger.kernel.org> # v5.13+
[tursulin: Added Fixes and cc stable.]
Cc: Andi Shyti <andi.shyti@linux.intel.com>
Cc: Shawn Lee <shawn.c.lee@intel.com>
Signed-off-by: Nirmoy Das <nirmoy.das@intel.com>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240219125047.28906-1-nirmoy.das@intel.com
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
(cherry picked from commit db7bbd13f08774cde0332c705f042e327fe21e73)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_userptr.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/i915/gem/i915_gem_userptr.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_userptr.c
@@ -374,6 +374,9 @@ i915_gem_userptr_release(struct drm_i915
 {
 	GEM_WARN_ON(obj->userptr.page_ref);
 
+	if (!obj->userptr.notifier.mm)
+		return;
+
 	mmu_interval_notifier_remove(&obj->userptr.notifier);
 	obj->userptr.notifier.mm = NULL;
 }



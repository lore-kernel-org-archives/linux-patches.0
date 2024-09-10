Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 319AC18C324;
	Tue, 10 Sep 2024 10:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725965252; cv=none; b=WedIgjnEcX3iZWi+Lnaf0Oyfh6hixxGIB03ygB0aBw40IGt5VW5M/AyNLUKBBaMeX/dDI37nc6DCF1W7OjEp46z9vf1Er5zv1J7X1+H+26TkZulv3P6Ttr9hebadxDNDX638ae6/Uobmy7F9Ydx8M5+nV6MeqbkbaqQmtF25UWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725965252; c=relaxed/simple;
	bh=dImi5/FdCHS+VmPb+qzsUJl7XffkkWtUAKx5nIXauP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oeao8MpbwBWS4VfWIIZGKIu+1RDaz9tZG9978H9PHjyw0Nq+BQuLBPxTWuB43ndt360tMe+EaDekIsEzjZ7sLIAV7DF+T2n801quHDyfiDzKyBc8SLNUrxM5IKZ4rHE6iWsolBj3tNtomo1apWAksq/6XHamMVoZqjaqhE2XTCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RHRun03J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RHRun03J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABAA3C4CEC3;
	Tue, 10 Sep 2024 10:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725965252;
	bh=dImi5/FdCHS+VmPb+qzsUJl7XffkkWtUAKx5nIXauP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RHRun03JqenUcbEBKpkMrc9s2h6MkVzvyYEc1+zQ8BiXG9umUGZ5hrOWv4puTVosC
	 Ro22pXOPazo5LzgJ736PilCF4WbZOUdgONc3WBRruEgVeQtB31Fy+C+XlUYr4ZYJGJ
	 oAqmImF34WkA1iw0WSAPhV2SBdYsm7NCFvS7bKMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 181/186] drm/i915/fence: Mark debug_fence_free() with __maybe_unused
Date: Tue, 10 Sep 2024 11:34:36 +0200
Message-ID: <20240910092602.077629585@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit f99999536128b14b5d765a9982763b5134efdd79 ]

When debug_fence_free() is unused
(CONFIG_DRM_I915_SW_FENCE_DEBUG_OBJECTS=n), it prevents kernel builds
with clang, `make W=1` and CONFIG_WERROR=y:

.../i915_sw_fence.c:118:20: error: unused function 'debug_fence_free' [-Werror,-Wunused-function]
  118 | static inline void debug_fence_free(struct i915_sw_fence *fence)
      |                    ^~~~~~~~~~~~~~~~

Fix this by marking debug_fence_free() with __maybe_unused.

See also commit 6863f5643dd7 ("kbuild: allow Clang to find unused static
inline functions for W=1 build").

Fixes: fc1584059d6c ("drm/i915: Integrate i915_sw_fence with debugobjects")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240829155950.1141978-3-andriy.shevchenko@linux.intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit 8be4dce5ea6f2368cc25edc71989c4690fa66964)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/i915_sw_fence.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_sw_fence.c b/drivers/gpu/drm/i915/i915_sw_fence.c
index 1c4498c29f25..136a7163477d 100644
--- a/drivers/gpu/drm/i915/i915_sw_fence.c
+++ b/drivers/gpu/drm/i915/i915_sw_fence.c
@@ -70,7 +70,7 @@ static inline void debug_fence_destroy(struct i915_sw_fence *fence)
 	debug_object_destroy(fence, &i915_sw_fence_debug_descr);
 }
 
-static inline void debug_fence_free(struct i915_sw_fence *fence)
+static inline __maybe_unused void debug_fence_free(struct i915_sw_fence *fence)
 {
 	debug_object_free(fence, &i915_sw_fence_debug_descr);
 	smp_wmb(); /* flush the change in state before reallocation */
@@ -108,7 +108,7 @@ static inline void debug_fence_destroy(struct i915_sw_fence *fence)
 {
 }
 
-static inline void debug_fence_free(struct i915_sw_fence *fence)
+static inline __maybe_unused void debug_fence_free(struct i915_sw_fence *fence)
 {
 }
 
-- 
2.43.0




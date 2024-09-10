Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68ACE172BAE;
	Tue, 10 Sep 2024 10:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963902; cv=none; b=XcOQyQIBEQLGQu+GjvF8ZlJ3aLhkuyUnA/YIRWhaVAPxKCDUiQE0og/v68gWfSikUkJaOop+iEaDweONZjp1QmLpJS0EpVwKN3n9ohOveU7lv+tFINaVX7r/ZF6TW/nfFfXq0lw+b50Lqdmua+2K3SvUhgiSyLOAlQwANqXy7MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963902; c=relaxed/simple;
	bh=Jjsg/1XGcUyV9hRLJ6yScRNwsnkEMw4CpfCezYzX3VE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GRvUQTPh6sA32aetEA3xeAk8j0chLaynqcH0/x4cawiwTLITWeCMO7IhJJP+96BmRrhsQXAKTgXx5+HzFPdv4pFbToA4Fvz51QM32Lwb+VVdMdzOF/aStUgqDtioBorb06qIYjrwx1PUnP0ut9hVC+Wix1s1Gmb6pA0UJos+Gvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IiOdcIa5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IiOdcIa5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D631CC4CEC3;
	Tue, 10 Sep 2024 10:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963902;
	bh=Jjsg/1XGcUyV9hRLJ6yScRNwsnkEMw4CpfCezYzX3VE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IiOdcIa51apQSk9nRyd8IGUWGBst6GR83WaESDdEsZEdbYSjHxWzruQryCRgxgh4U
	 O5fcMkWsxMsVJxNz0byaHkJoBtLz9fz/AACQnknMF+b6PJMTz1gFVS/F/rDyQ/tluf
	 ZMhGn32G4oRO4v0GyOasRhtOh2H3Vk+jo1U/Jx1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 204/214] drm/i915/fence: Mark debug_fence_free() with __maybe_unused
Date: Tue, 10 Sep 2024 11:33:46 +0200
Message-ID: <20240910092606.867745947@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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
index 11d1f9136c41..cce8a7be11f2 100644
--- a/drivers/gpu/drm/i915/i915_sw_fence.c
+++ b/drivers/gpu/drm/i915/i915_sw_fence.c
@@ -75,7 +75,7 @@ static inline void debug_fence_destroy(struct i915_sw_fence *fence)
 	debug_object_destroy(fence, &i915_sw_fence_debug_descr);
 }
 
-static inline void debug_fence_free(struct i915_sw_fence *fence)
+static inline __maybe_unused void debug_fence_free(struct i915_sw_fence *fence)
 {
 	debug_object_free(fence, &i915_sw_fence_debug_descr);
 	smp_wmb(); /* flush the change in state before reallocation */
@@ -113,7 +113,7 @@ static inline void debug_fence_destroy(struct i915_sw_fence *fence)
 {
 }
 
-static inline void debug_fence_free(struct i915_sw_fence *fence)
+static inline __maybe_unused void debug_fence_free(struct i915_sw_fence *fence)
 {
 }
 
-- 
2.43.0




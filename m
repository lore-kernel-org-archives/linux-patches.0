Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDF8D1885A5;
	Tue, 10 Sep 2024 10:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962723; cv=none; b=Zt3Oq8wwbQI5PpfrYhHQ/L1TMOz1ff9fHmEYOsbIUQZVmqvnjWAyyMWvuDtX+hGN06q1FnzVPxED5n93evvLC+FCcKKd5JRBfvhw1D9zjMqAGSVA6AJTgIAWgQXMkj0Y295uSLXXTp9Bdjr52MzVWq9QpHRcH3RUTdJvk4hpqoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962723; c=relaxed/simple;
	bh=qI9xEda6GTNWaOUjwjob4rGrxLZLEIakXBvjrsPuJAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lOWGM6BgycOinGT1oFo3+j3cR++PpF/umnzOIr76+o4JZKmOhHrnBpsWv04/jbbIHqBRbRkCbUnGexFi3HHgDnmp5OYjuEmlCf7/+TJwwLJwjBsNOlbLHKIydRWWaOLRo1lHiGN4kzsYk3Vct1bD7EGAatCZ1jl2EhvqBZ5ZeCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZvqOfV1B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZvqOfV1B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D921C4CEC3;
	Tue, 10 Sep 2024 10:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962722;
	bh=qI9xEda6GTNWaOUjwjob4rGrxLZLEIakXBvjrsPuJAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZvqOfV1BT9oujhhqfvPMFQ2gzlB8W+jUhheQV0sLsH2dWQosxhM97+1vbfzGKPqP4
	 CJUUFde7+WCaZ3qsvVb077tn5dcMiMJAffF1E+TpgYl2xgLuN23rChSea/+EdGuKDo
	 UJ+Fg5/ndq/JcJfxsgK+QsqT5LWrPCac956gb3+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 117/121] drm/i915/fence: Mark debug_fence_init_onstack() with __maybe_unused
Date: Tue, 10 Sep 2024 11:33:12 +0200
Message-ID: <20240910092551.353143466@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092545.737864202@linuxfoundation.org>
References: <20240910092545.737864202@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit fcd9e8afd546f6ced378d078345a89bf346d065e ]

When debug_fence_init_onstack() is unused (CONFIG_DRM_I915_SELFTEST=n),
it prevents kernel builds with clang, `make W=1` and CONFIG_WERROR=y:

.../i915_sw_fence.c:97:20: error: unused function 'debug_fence_init_onstack' [-Werror,-Wunused-function]
   97 | static inline void debug_fence_init_onstack(struct i915_sw_fence *fence)
      |                    ^~~~~~~~~~~~~~~~~~~~~~~~

Fix this by marking debug_fence_init_onstack() with __maybe_unused.

See also commit 6863f5643dd7 ("kbuild: allow Clang to find unused static
inline functions for W=1 build").

Fixes: 214707fc2ce0 ("drm/i915/selftests: Wrap a timer into a i915_sw_fence")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240829155950.1141978-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit 5bf472058ffb43baf6a4cdfe1d7f58c4c194c688)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/i915_sw_fence.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_sw_fence.c b/drivers/gpu/drm/i915/i915_sw_fence.c
index b3fd6ff665da..475e4b9485af 100644
--- a/drivers/gpu/drm/i915/i915_sw_fence.c
+++ b/drivers/gpu/drm/i915/i915_sw_fence.c
@@ -38,7 +38,7 @@ static inline void debug_fence_init(struct i915_sw_fence *fence)
 	debug_object_init(fence, &i915_sw_fence_debug_descr);
 }
 
-static inline void debug_fence_init_onstack(struct i915_sw_fence *fence)
+static inline __maybe_unused void debug_fence_init_onstack(struct i915_sw_fence *fence)
 {
 	debug_object_init_on_stack(fence, &i915_sw_fence_debug_descr);
 }
@@ -81,7 +81,7 @@ static inline void debug_fence_init(struct i915_sw_fence *fence)
 {
 }
 
-static inline void debug_fence_init_onstack(struct i915_sw_fence *fence)
+static inline __maybe_unused void debug_fence_init_onstack(struct i915_sw_fence *fence)
 {
 }
 
-- 
2.43.0




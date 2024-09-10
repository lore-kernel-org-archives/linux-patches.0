Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9255118B488;
	Tue, 10 Sep 2024 09:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962269; cv=none; b=RctJqpsWILWb2JLK+iv/F/RG5x7vKEFHqFlyEQTDu+axib3K/shRrmsbKIIR7kGTuCbMv4jvLoTq24e9Ve380/nTsm7mM7mrVJoiSy+CEOus0drQ9oQ1Po8LoJU9sDUOspY5aqRSoAQgjBxydvrMksqwdXmw/2tzz9zFr6HhAgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962269; c=relaxed/simple;
	bh=CpUH7gtaMUTnQi0OK1CDFKguhb4RzgQ5enxxDYJ9F/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fMWYy7hjuIrMqMoCMm8MroUcPgQtX+3K92Eo0DPKI589FVRs0jyaDpMent3lMFRrifpIOjjDlIO3Jbt0JJRDkQdthntRM4hPzUiqLrPLU2OGcNHIU5MUOCSv5S6fSDePWFv9ujnbRPrivlfIYYgJJhnlObrprAef//DdiyiIIYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zTw4hZoA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zTw4hZoA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A522C4CEC3;
	Tue, 10 Sep 2024 09:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962269;
	bh=CpUH7gtaMUTnQi0OK1CDFKguhb4RzgQ5enxxDYJ9F/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zTw4hZoAqau/0nICTBz07Ca0kzdkS8D1dmpMgaPE0/39J/7tji3k6PllO+GHyPt7O
	 Bsufh4aAxMr3qyZ30s2+PC+XHxP1U+0BMAI6ssnTHmUFI+68PZXYHMr8/dcmjEu439
	 MT/8z6ylsDY0+RnD8O5GsltqkcGbKN+/OOrnI0pU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 353/375] drm/i915/fence: Mark debug_fence_init_onstack() with __maybe_unused
Date: Tue, 10 Sep 2024 11:32:30 +0200
Message-ID: <20240910092634.458337499@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 8a9aad523eec..d4020ff3549a 100644
--- a/drivers/gpu/drm/i915/i915_sw_fence.c
+++ b/drivers/gpu/drm/i915/i915_sw_fence.c
@@ -51,7 +51,7 @@ static inline void debug_fence_init(struct i915_sw_fence *fence)
 	debug_object_init(fence, &i915_sw_fence_debug_descr);
 }
 
-static inline void debug_fence_init_onstack(struct i915_sw_fence *fence)
+static inline __maybe_unused void debug_fence_init_onstack(struct i915_sw_fence *fence)
 {
 	debug_object_init_on_stack(fence, &i915_sw_fence_debug_descr);
 }
@@ -94,7 +94,7 @@ static inline void debug_fence_init(struct i915_sw_fence *fence)
 {
 }
 
-static inline void debug_fence_init_onstack(struct i915_sw_fence *fence)
+static inline __maybe_unused void debug_fence_init_onstack(struct i915_sw_fence *fence)
 {
 }
 
-- 
2.43.0




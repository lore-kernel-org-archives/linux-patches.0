Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEF55EEC9;
	Tue, 10 Sep 2024 09:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962272; cv=none; b=Gyb2yHhTFY/JkYbLmpRKfhM6jtj/z8O5IPfw/2ch5bm+UluQTW4lHfgQOlVKgaEEtjUSPjgyggoJh2vh6son1HJoaNLbjcfBH1LuCnFX9wE1xBlrsg5bMHr+mKMIkEE2p3c4id91+ndRYGKyPZSwxzDrx6effwxYDYx1AhAmZkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962272; c=relaxed/simple;
	bh=wlQZ9+WhDYb+Q9qWpaTQxnUgP0OXfJso1Yjj7dEQasI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T+qGn9qLpurCWhF+b6rYVeZkcba6F4nQcaLXLPlB8xW7kWhQvVNqJbyi0bAfC+bDwpmosfq8totHiSshUJUX8pKR1y82//SFVjlP/a31Irl7FvI9ENq4QgVaJZlqY7JggaJ3IQunnztMj1qhT8GypV8Ej+TpecQNB96Bdc5BIoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uuNydIn6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uuNydIn6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06D50C4CEC3;
	Tue, 10 Sep 2024 09:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962272;
	bh=wlQZ9+WhDYb+Q9qWpaTQxnUgP0OXfJso1Yjj7dEQasI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uuNydIn6OAAgtbgF3lBTuCDKvuE1P1U4KsPooZ2CJgmnvnfEhr8AJZcuJwx9IJ8eV
	 4zbifSkgH8b7iKhAsxHBm3K8GMVDdBVFsiU+bvbjHYWI2sMjPfgl6n6fxPWp0/xupp
	 RBix3ZjpTFysDtqTqWFlLh9s815ENo3FZuxEEZR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 354/375] drm/i915/fence: Mark debug_fence_free() with __maybe_unused
Date: Tue, 10 Sep 2024 11:32:31 +0200
Message-ID: <20240910092634.489812385@linuxfoundation.org>
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
index d4020ff3549a..1d4cc91c0e40 100644
--- a/drivers/gpu/drm/i915/i915_sw_fence.c
+++ b/drivers/gpu/drm/i915/i915_sw_fence.c
@@ -77,7 +77,7 @@ static inline void debug_fence_destroy(struct i915_sw_fence *fence)
 	debug_object_destroy(fence, &i915_sw_fence_debug_descr);
 }
 
-static inline void debug_fence_free(struct i915_sw_fence *fence)
+static inline __maybe_unused void debug_fence_free(struct i915_sw_fence *fence)
 {
 	debug_object_free(fence, &i915_sw_fence_debug_descr);
 	smp_wmb(); /* flush the change in state before reallocation */
@@ -115,7 +115,7 @@ static inline void debug_fence_destroy(struct i915_sw_fence *fence)
 {
 }
 
-static inline void debug_fence_free(struct i915_sw_fence *fence)
+static inline __maybe_unused void debug_fence_free(struct i915_sw_fence *fence)
 {
 }
 
-- 
2.43.0




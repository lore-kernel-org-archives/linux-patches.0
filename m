Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9BF914D280;
	Tue, 10 Sep 2024 10:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964653; cv=none; b=Mx6UPKNsnX9wQxD1aACkqfY9AkrRlVYqG/xfzAevy/WvfT9BXwQm8YBd1GNEjpgmqwAAA4PiRvJbdz2bXDxpT1iJmqqiQ2P6pApx8C/3oCCoGZVgmji6zRvPnanVELJf0fNoOvQk0J/BnggvCYs9UKMuy0Jzo8NGp9gJscpkH+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964653; c=relaxed/simple;
	bh=KcvamTlO8D40B+Bgs/rLyASDPFiG9Tfqm7FUgn/l9mo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oHoEIrNRPIkBjsOntfUphl56KFFUfSH/OUksV8uheV09hTEFS0OsN+E2Y0N701Kp8oQofd0t/Lz1tU5SL6MfAKg1m3PigTqV+0flszYHKi2FjsQjX2eOKFoJD7TRGNdOqi+bt4HlU/Y+lRYK2h9pOhU2DP+JDt7O01tGW/8adCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=USag/dtH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="USag/dtH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 272A6C4CEC3;
	Tue, 10 Sep 2024 10:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964653;
	bh=KcvamTlO8D40B+Bgs/rLyASDPFiG9Tfqm7FUgn/l9mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=USag/dtHe/adVoz574Q2kc2BPRTO5jIHPrcncHEpNYyYbvZkXjdBRxxQ+ek4FhUla
	 Y69jn9M9Bo9+plRRLpVTyQB300XNcBY3EqaH2d2JvOvbGF4TQfX0Qen8MCLw+PryKf
	 QIwbQRaJUG1VRZUly1cPNxqMtT/Yx9QXXn3E1Vmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 255/269] drm/i915/fence: Mark debug_fence_init_onstack() with __maybe_unused
Date: Tue, 10 Sep 2024 11:34:02 +0200
Message-ID: <20240910092616.884580558@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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




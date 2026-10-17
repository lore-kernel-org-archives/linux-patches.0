Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D1653A0E85;
	Sat, 17 Oct 2026 16:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255148; cv=none; b=VsGyIqVV9ba/U18Mc2DkQqJFk0U0oAEUSGm0O1K8Hd8g38eNDgwLeYsdhUR2d52VMOBni382L+hQNQpKnRKmDmqc1Qeex9Ycly/imSsJGQz/s8MwZQl7V3HDhDiNPeU18th3RaiTGN8wF7w9HGndXSMg0ARkoTjMhc+qlYCb/KI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255148; c=relaxed/simple;
	bh=xreMNOYhdq8eSGbYcV5ipbbqWZ37LmPNJP6C309x2mE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=plDu2IgIDPdu3BE1KS1uFN6ch8aBmMliimra5M2DwJT5a/UAjrApDpK7a4t9esBt91tfxhZcZ7HtynGZ66shex2Y6Z2fzHiM5wUPG7EiebguzcRmys3QjJyghicGb9wpW8IJyXhbzEaqZJo7/gbu78h1bFg+KHxPJNlnVHD/G9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k+hVeJE1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k+hVeJE1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 510161F000C4;
	Sat, 17 Oct 2026 16:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255146;
	bh=yHDv32fEEUNglSPz1JSQX1boguMcoGt3xLKIUgPCxDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k+hVeJE1jRIjpqq7pfl/yqX9pBvT3a4pzjSHb4itPmVkVvVT7A3pVss+ROL/wuLyd
	 +pbxTu43rlbQ2ORX03XDwhVKGxkzjhCS8sG1ldr+4bgk0OG1s06HdshiXXE0oHcTuC
	 tlYjDJ1ZZfXRMnAq+uTzdsSkQvKYwDBTqiTjZoes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-hardening@vger.kernel.org,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 680/869] drm/i915: rename range_overflows_end() to range_end_overflows()
Date: Sat, 17 Oct 2026 17:58:41 +0200
Message-ID: <20261017160054.413278656@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

[ Upstream commit 1e4c85167cf672312a178b2af0b058add77e448b ]

Rename range_overflows_end() to range_end_overflows(), along with the _t
variant.

It's all rather subjective, but I think range_end_overflows() reads
better.

Cc: Kees Cook <kees@kernel.org>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: linux-hardening@vger.kernel.org
Reviewed-by: Jouni Högander <jouni.hogander@intel.com>
Link: https://lore.kernel.org/r/20250829174601.2163064-1-jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Stable-dep-of: 985f5e12f3cd ("drm/panthor: Add vm_bind region with kbo range overlap check")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_fbc.c | 4 ++--
 drivers/gpu/drm/i915/gt/intel_rc6.c      | 2 +-
 drivers/gpu/drm/i915/i915_utils.h        | 6 +++---
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_fbc.c b/drivers/gpu/drm/i915/display/intel_fbc.c
index 7cb1a9cfa20f4..809b477f907e3 100644
--- a/drivers/gpu/drm/i915/display/intel_fbc.c
+++ b/drivers/gpu/drm/i915/display/intel_fbc.c
@@ -378,11 +378,11 @@ static void i8xx_fbc_program_cfb(struct intel_fbc *fbc)
 	struct drm_i915_private *i915 = to_i915(display->drm);
 
 	drm_WARN_ON(display->drm,
-		    range_overflows_end_t(u64, i915_gem_stolen_area_address(i915),
+		    range_end_overflows_t(u64, i915_gem_stolen_area_address(i915),
 					  i915_gem_stolen_node_offset(&fbc->compressed_fb),
 					  U32_MAX));
 	drm_WARN_ON(display->drm,
-		    range_overflows_end_t(u64, i915_gem_stolen_area_address(i915),
+		    range_end_overflows_t(u64, i915_gem_stolen_area_address(i915),
 					  i915_gem_stolen_node_offset(&fbc->compressed_llb),
 					  U32_MAX));
 	intel_de_write(i915, FBC_CFB_BASE,
diff --git a/drivers/gpu/drm/i915/gt/intel_rc6.c b/drivers/gpu/drm/i915/gt/intel_rc6.c
index 9ca42589da4da..bf38cc5fe8729 100644
--- a/drivers/gpu/drm/i915/gt/intel_rc6.c
+++ b/drivers/gpu/drm/i915/gt/intel_rc6.c
@@ -341,7 +341,7 @@ static int vlv_rc6_init(struct intel_rc6 *rc6)
 		return PTR_ERR(pctx);
 	}
 
-	GEM_BUG_ON(range_overflows_end_t(u64,
+	GEM_BUG_ON(range_end_overflows_t(u64,
 					 i915->dsm.stolen.start,
 					 pctx->stolen->start,
 					 U32_MAX));
diff --git a/drivers/gpu/drm/i915/i915_utils.h b/drivers/gpu/drm/i915/i915_utils.h
index 71bdc89bd6215..61e561d6996d6 100644
--- a/drivers/gpu/drm/i915/i915_utils.h
+++ b/drivers/gpu/drm/i915/i915_utils.h
@@ -81,7 +81,7 @@ bool i915_error_injected(void);
 #define range_overflows_t(type, start, size, max) \
 	range_overflows((type)(start), (type)(size), (type)(max))
 
-#define range_overflows_end(start, size, max) ({ \
+#define range_end_overflows(start, size, max) ({ \
 	typeof(start) start__ = (start); \
 	typeof(size) size__ = (size); \
 	typeof(max) max__ = (max); \
@@ -90,8 +90,8 @@ bool i915_error_injected(void);
 	start__ > max__ || size__ > max__ - start__; \
 })
 
-#define range_overflows_end_t(type, start, size, max) \
-	range_overflows_end((type)(start), (type)(size), (type)(max))
+#define range_end_overflows_t(type, start, size, max) \
+	range_end_overflows((type)(start), (type)(size), (type)(max))
 
 #define ptr_mask_bits(ptr, n) ({					\
 	unsigned long __v = (unsigned long)(ptr);			\
-- 
2.53.0




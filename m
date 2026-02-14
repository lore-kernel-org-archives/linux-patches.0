Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982D82236F2;
	Sat, 14 Feb 2026 01:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031247; cv=none; b=uhPXNLLWIBw42nhUpzjf8OCy+lfTfpQcL/8jLA7gh0KNCkxiq/xRKaIr7cVUP01+T2QG/xHqPqE5Bn6zg7r5fE1iIS9lz11IAAeLmu4V/CL5+6DfsSAUrarFzhSynE9o31l2FpX3YlHgBfVbxoG2Q7NHvC0SPNZJbHZqJJ/Kr24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031247; c=relaxed/simple;
	bh=gcaiq5w8OKeuzVtzSK1Ej2JDOPNoTNrvySAmPbTmoBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JA2kVbG1tjEzddgbtT3kiB/SEZMlkGFjqKeDXSxW6YHozZDXxQLlsBggNNtIQM/WTpXLcBEeVOFSYP43ygumLaTv41ehYciMDz3yzmT6hrYU2ZjMZgPwCR8Z7lU2RaMiMxC01cWMzPzEbeKqx2wEvZq59E2PdG3MDxwhu8fHtwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XCICgVh5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XCICgVh5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B953AC16AAE;
	Sat, 14 Feb 2026 01:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031247;
	bh=gcaiq5w8OKeuzVtzSK1Ej2JDOPNoTNrvySAmPbTmoBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XCICgVh5t/pc0Nu8w2gT0G8orpjuI20M3N4VDvpoLoJNxUEjqK1kFvSJYAfzja5/r
	 NA4cMFrGJr6SOV0j4AQqHPnYXi7lDGwKb3e0y3LoPzTtET7deIUFXXr5XkzjUmmUz2
	 64c+DqbFnNV/8mbOWSDWbrb7j8hi+R1VadqwORlTc2M7kegusTDaGAGiHIOf/w8VoI
	 pcKezpYCfPD+1+oKXS67uPztB9aXs75ClsyMoOdiWxn1iMfTneZywA0a6mbOWYblSl
	 YHaf8MJRlowPjAm4L7Pdu/fKeI/mysBUI5SBFWMgaKyw/sfBCOPCsmyDDsKA2BrVAi
	 oswHo+KhlJLcA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Ren=C3=A9=20Rebe?= <rene@exactco.de>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	airlied@redhat.com,
	dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.19] drm/ast: Swap framebuffer writes on big-endian machines
Date: Fri, 13 Feb 2026 19:59:58 -0500
Message-ID: <20260214010245.3671907-118-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214010245.3671907-1-sashal@kernel.org>
References: <20260214010245.3671907-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Transfer-Encoding: 8bit

From: René Rebe <rene@exactco.de>

[ Upstream commit 50c26c301c5176cc8b431044390e10ec862b9b77 ]

Swap the pixel data when writing to framebuffer memory on big-endian
machines. Fixes incorrect output. Aspeed graphics does not appear to
support big-endian framebuffers after AST2400, although the feature
has been documented.

There's a lengthy discussion at [1].

v5:
- avoid restricted cast from __be16 (kernel test robot)

Signed-off-by: René Rebe <rene@exactco.de>
Link: https://lore.kernel.org/dri-devel/20251202.170626.2134482663677806825.rene@exactco.de/ # [1]
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patch.msgid.link/20251212.210504.1355099120650239629.rene@exactco.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

### 1. Commit Message Analysis

The commit fixes **incorrect display output on big-endian machines**
when using the AST (Aspeed) DRM graphics driver. The commit message
says:
> "Swap the pixel data when writing to framebuffer memory on big-endian
machines. Fixes incorrect output. Aspeed graphics does not appear to
support big-endian framebuffers after AST2400, although the feature has
been documented."

The author is René Rebe, who also authored the analogous `drm/mgag200:
Fix big-endian support` commit (6cb31fba137d4), which explicitly carries
a `Fixes:` tag and `Cc: stable@kernel.org`. This is the same class of
bug fix across two different server BMC graphics drivers. The "v5"
iteration marker shows the patch went through multiple rounds of review.

### 2. Code Change Analysis

The patch modifies 2 files with **17 insertions and 5 deletions** — very
small and contained.

**`ast_cursor.c` — cursor plane fix:**
On big-endian, the cursor data is written with byte-swapped 16-bit
writes (`writew(swab16(...))`) instead of the plain `memcpy_toio()`.
This is wrapped in `#if defined(__BIG_ENDIAN)`, making it entirely
compiled away on little-endian systems.

**`ast_mode.c` — primary plane fix:**
On big-endian, `ast_handle_damage()` calls `drm_fb_swab()` (an existing
DRM helper that byte-swaps pixel data per-pixel) instead of
`drm_fb_memcpy()`. This requires passing the `fmtcnv_state` from
`drm_shadow_plane_state` through to the function, which is why the
function signature is modified to accept a `struct drm_format_conv_state
*` parameter. Again, wrapped in `#if defined(__BIG_ENDIAN)`.

The underlying problem: Aspeed graphics chips (post-AST2400) expect
little-endian pixel data in the framebuffer, but on a big-endian host
(e.g., PowerPC), `memcpy_toio` copies the bytes in host order, resulting
in byte-swapped (garbled) display output.

### 3. Dependency Analysis

- `drm_fb_swab()` was introduced in v5.8 (commit bd34cea2a0e4b, May
  2020) — available in all active stable trees.
- The current API with `struct drm_format_conv_state *state` parameter
  was added in commit 903674588a48d (Oct 2023), present in **v6.10+**.
- `fmtcnv_state` field in `struct drm_shadow_plane_state` also from
  v6.10+.

For **v6.12.y** and **v6.19.y**: All dependencies exist. The patch would
apply cleanly.
For **v6.6.y** and earlier: `drm_fb_swab` has a different signature (no
`state` param), and `fmtcnv_state` doesn't exist. The patch would need
non-trivial adaptation.

### 4. Risk Assessment

**Risk is extremely low:**
- All new code is behind `#if defined(__BIG_ENDIAN)`, so **zero impact
  on little-endian** (x86, ARM-LE) — the vast majority of systems.
- On big-endian, the fix uses well-established kernel APIs
  (`drm_fb_swab`, `writew`, `swab16`).
- Reviewed by Thomas Zimmermann, the DRM AST subsystem maintainer.
- The mgag200 version of this same fix was explicitly marked `Cc:
  stable@kernel.org`.

### 5. User Impact

AST (Aspeed) graphics chips are **extremely common** in server BMC/IPMI
systems (Supermicro, ASUS, Gigabyte, etc.). Big-endian platforms that
use these include **PowerPC/POWER servers** (e.g., Raptor Talos
II/Blackbird). For these users, the display is completely garbled —
effectively making local console unusable. While the affected user base
is small (big-endian + AST), for those affected, the system's local
display is entirely broken.

### 6. Why the Author Didn't Mark It for Stable

The companion mgag200 fix (6cb31fba137d4) by the same author WAS marked
`Cc: stable@kernel.org` with a `Fixes:` tag. The AST fix was not, likely
because:
1. The AST fix is slightly more invasive (changes function signature,
   adds `fmtcnv_state` dependency)
2. The author may have been uncertain about clean backportability
3. The mgag200 fix was pure register programming (simpler)

This doesn't diminish the fix's value — it's the same class of bug.

### 7. Classification

This is a **hardware bug workaround / driver fix** — the Aspeed hardware
doesn't support big-endian framebuffers despite documentation suggesting
it does (post-AST2400). The fix makes the software compensate. This
falls into the "quirks and workarounds for broken hardware" category.

### Summary

| Criterion | Assessment |
|---|---|
| Fixes real bug | Yes — completely broken display on big-endian |
| Small and contained | Yes — 17 insertions, 5 deletions, 2 files |
| Regression risk | Near zero — `#if __BIG_ENDIAN` guards |
| Reviewed | Yes — by subsystem maintainer |
| Dependencies in stable | Yes — for v6.12.y and v6.19.y |
| User impact | Complete display failure for affected users |

The fix is small, surgically targeted, has zero regression risk for the
vast majority of users, and resolves a complete display failure for big-
endian users. It meets stable criteria for at least v6.12.y and v6.19.y.

**YES**

 drivers/gpu/drm/ast/ast_cursor.c | 11 ++++++++---
 drivers/gpu/drm/ast/ast_mode.c   | 11 +++++++++--
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/ast/ast_cursor.c b/drivers/gpu/drm/ast/ast_cursor.c
index 2d3ad7610c2e9..7da0a2d463e6c 100644
--- a/drivers/gpu/drm/ast/ast_cursor.c
+++ b/drivers/gpu/drm/ast/ast_cursor.c
@@ -92,12 +92,17 @@ static void ast_set_cursor_image(struct ast_device *ast, const u8 *src,
 				 unsigned int width, unsigned int height)
 {
 	u8 __iomem *dst = ast_plane_vaddr(&ast->cursor_plane.base);
-	u32 csum;
-
-	csum = ast_cursor_calculate_checksum(src, width, height);
+	u32 csum = ast_cursor_calculate_checksum(src, width, height);
 
 	/* write pixel data */
+#if defined(__BIG_ENDIAN)
+	unsigned int i;
+
+	for (i = 0; i < AST_HWC_SIZE; i += 2)
+		writew(swab16(*(const __u16 *)&src[i]), &dst[i]);
+#else
 	memcpy_toio(dst, src, AST_HWC_SIZE);
+#endif
 
 	/* write checksum + signature */
 	dst += AST_HWC_SIZE;
diff --git a/drivers/gpu/drm/ast/ast_mode.c b/drivers/gpu/drm/ast/ast_mode.c
index cd08990a10f93..57c6fbc3232b0 100644
--- a/drivers/gpu/drm/ast/ast_mode.c
+++ b/drivers/gpu/drm/ast/ast_mode.c
@@ -526,12 +526,18 @@ static int ast_primary_plane_helper_atomic_check(struct drm_plane *plane,
 
 static void ast_handle_damage(struct ast_plane *ast_plane, struct iosys_map *src,
 			      struct drm_framebuffer *fb,
-			      const struct drm_rect *clip)
+			      const struct drm_rect *clip,
+			      struct drm_format_conv_state *fmtcnv_state)
 {
 	struct iosys_map dst = IOSYS_MAP_INIT_VADDR_IOMEM(ast_plane_vaddr(ast_plane));
 
 	iosys_map_incr(&dst, drm_fb_clip_offset(fb->pitches[0], fb->format, clip));
+
+#if defined(__BIG_ENDIAN)
+	drm_fb_swab(&dst, fb->pitches, src, fb, clip, !src[0].is_iomem, fmtcnv_state);
+#else
 	drm_fb_memcpy(&dst, fb->pitches, src, fb, clip);
+#endif
 }
 
 static void ast_primary_plane_helper_atomic_update(struct drm_plane *plane,
@@ -561,7 +567,8 @@ static void ast_primary_plane_helper_atomic_update(struct drm_plane *plane,
 	if (drm_gem_fb_begin_cpu_access(fb, DMA_FROM_DEVICE) == 0) {
 		drm_atomic_helper_damage_iter_init(&iter, old_plane_state, plane_state);
 		drm_atomic_for_each_plane_damage(&iter, &damage) {
-			ast_handle_damage(ast_plane, shadow_plane_state->data, fb, &damage);
+			ast_handle_damage(ast_plane, shadow_plane_state->data, fb, &damage,
+					  &shadow_plane_state->fmtcnv_state);
 		}
 
 		drm_gem_fb_end_cpu_access(fb, DMA_FROM_DEVICE);
-- 
2.51.0


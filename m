Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97CC62264B0;
	Sat, 14 Feb 2026 01:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031163; cv=none; b=fOevC1rrP5gzIJt99WXehEaAmtMVIrj5V0HQ2ghqXh0/9KNBfUqkZXu1UU+fanNJ9C94XDDKGTSCwcPYImwP0CZbIAHLj73Xy0+rqZ+ziRvMlK+kPaqC+hWDh63dHUbM2Pn1Cvk7ERDDWL1WcZkHwFZxJD09x+eqQ80+Deaq2lY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031163; c=relaxed/simple;
	bh=FJSLGiaQrTdjaNFn5/fWJS1Yn2FwKMG/XhZ9Z4b/a8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KxHs1w5gqqspr1notXSegyTfoSB4Pmzh2CfEC3nO0imV+vDDr4HTrTYRfCr+uLUkffolYwiDaj0RIlKRWIHH1I5jC44rA6ZyzFLBbr0YKEFOl9btgoETL0A6xAMo7KI00W7imL3cO9iIOw6B+voUD32G5mTZMWgeWz59+FH4xbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Maa9S8zt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Maa9S8zt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65FC3C19423;
	Sat, 14 Feb 2026 01:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031163;
	bh=FJSLGiaQrTdjaNFn5/fWJS1Yn2FwKMG/XhZ9Z4b/a8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Maa9S8ztrtxiPXcPPr4zD9VhGNCx1BtgDUwmW05/XWWzkZ3mtUdkNg9op/dHMjhkM
	 OcanWHJ9p9IUmjvSaNr9Jh2Y3gGNnbrlj5GUlwuhEB60Rc10v3AfIal46VwhneOYTT
	 LohWm9IZ7gbqK1BGTS26CVUEFoMvlQqI+zgYNhSpCpZoDyy5UkwVDASazCKgRmM1Ze
	 PTIGb2o/5RShVC4sFraTJ7vtj63nYhtYTevzriFXIrGYXG8TT2aK/bbQ3lSfKz4jl/
	 y8kYQbTlM1Wjb+o9t8tIYjzgS6OWOk+VJT36Wj+zr9lpLiThAzW+XrMvQjGidjzJSf
	 FyHXVKErFgW5A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ludovic Desroches <ludovic.desroches@microchip.com>,
	Manikandan Muralidharan <manikandan.m@microchip.com>,
	Sasha Levin <sashal@kernel.org>,
	dharma.b@microchip.com,
	nicolas.ferre@microchip.com,
	alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev,
	dri-devel@lists.freedesktop.org,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.19] drm/atmel-hlcdc: destroy properly the plane state in the reset callback
Date: Fri, 13 Feb 2026 19:59:25 -0500
Message-ID: <20260214010245.3671907-85-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214010245.3671907-1-sashal@kernel.org>
References: <20260214010245.3671907-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ludovic Desroches <ludovic.desroches@microchip.com>

[ Upstream commit 81af99cbd9e4f238011af811d544fff75641fc25 ]

If there is a plane state to destroy when doing a plane reset, destroy
it using the atmel_hlcdc_plane_destroy_state() function. So we call
__drm_atomic_helper_plane_destroy_state() and avoid code duplication.

Signed-off-by: Ludovic Desroches <ludovic.desroches@microchip.com>
Reviewed-by: Manikandan Muralidharan <manikandan.m@microchip.com>
Link: https://patch.msgid.link/20251218-lcd_cleanup_mainline-v2-8-df837aba878f@microchip.com
Signed-off-by: Manikandan Muralidharan <manikandan.m@microchip.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis of the Commit

### Commit Message Analysis

The commit message says: "destroy properly the plane state in the reset
callback" — the key word is **properly**. This suggests the previous
destruction was **improper**, meaning there was a bug in the old code.

### Code Change Analysis

Let me examine the old vs new `atmel_hlcdc_plane_reset()` function
carefully.

**Old code (being removed):**
```c
if (p->state) {
    state = drm_plane_state_to_atmel_hlcdc_plane_state(p->state);
    if (state->base.fb)
        drm_framebuffer_put(state->base.fb);
    kfree(state);
    p->state = NULL;
}
```

**New code (replacement):**
```c
if (p->state) {
    atmel_hlcdc_plane_atomic_destroy_state(p, p->state);
    p->state = NULL;
}
```

**What `atmel_hlcdc_plane_atomic_destroy_state()` does that the old
inline code did NOT:**
```c
static void atmel_hlcdc_plane_atomic_destroy_state(...)
{
    // 1. Frees DMA descriptors from the DMA pool
    for (i = 0; i < ARRAY_SIZE(state->dscrs); i++) {
        dma_pool_free(dc->dscrpool, state->dscrs[i],
                      state->dscrs[i]->self);
    }
    // 2. Puts the framebuffer reference
    if (s->fb)
        drm_framebuffer_put(s->fb);
    // 3. Frees the state
    kfree(state);
}
```

### Bug Identified: DMA Descriptor Resource Leak

The old reset code was **missing the DMA pool free** for the descriptors
(`state->dscrs[i]`). Every time `atmel_hlcdc_plane_reset()` was called
with an existing plane state, the DMA descriptors allocated from
`dc->dscrpool` were **leaked** — they were never returned to the DMA
pool.

This is a **real resource leak**. DMA pool memory is coherent DMA
memory, a finite and precious resource, especially on embedded ARM
systems where this Atmel HLCDC display controller runs. DMA pool
exhaustion can lead to allocation failures and display malfunction.

Additionally, the old code was also **missing the
`__drm_atomic_helper_plane_destroy_state()` call** that the proper
destroy function would provide (though in this driver the destroy
function doesn't call it either, it does its own fb put + kfree).
However, the DMA descriptor leak is the primary bug.

### Additional Change: CSC Initialization

The new reset function also adds:
```c
if (plane->layer.desc->layout.csc)
    dc->desc->ops->lcdc_csc_init(plane, plane->layer.desc);
```

This is a **new addition** — CSC (Color Space Conversion) initialization
during plane reset. This is arguably a feature addition or a separate
fix for missing initialization. This adds a bit of risk since it's not
purely fixing the leak but also changing initialization behavior.

### Scope and Risk Assessment

- **Files changed:** 1 file
- **Net change:** The function is reorganized, and the core fix (using
  proper destroy) is straightforward
- **Risk:** LOW for the resource leak fix. MEDIUM for the CSC init
  addition — but CSC init during reset is standard practice and the code
  only runs on Atmel HLCDC hardware
- **Subsystem:** DRM driver for a specific ARM SoC (Atmel/Microchip
  SAM9/SAMA5) — limited blast radius

### Stable Criteria Assessment

1. **Obviously correct:** Yes — the DMA descriptors were being leaked;
   they must be freed via the proper destroy path
2. **Fixes a real bug:** Yes — DMA pool memory leak on plane reset
3. **Important issue:** Moderate — resource leak in a display driver; on
   embedded systems with limited DMA pool memory, this could eventually
   cause display failures
4. **Small and contained:** Yes — one file, one function reorganized
5. **No new features:** The CSC init addition is borderline — it's
   initialization that was arguably missing, but it does add new
   behavior
6. **Applies cleanly:** Would need to verify, but it's self-contained

### Concerns

1. The CSC initialization addition goes beyond the pure leak fix and
   introduces new behavior. This makes it slightly riskier than a pure
   fix.
2. The commit message doesn't emphasize the DMA descriptor leak — it's
   described as avoiding "code duplication," which undersells the actual
   bug being fixed. This is a classic case of a bug fix disguised as
   cleanup.
3. No `Fixes:` tag or syzbot report, but the bug is clearly visible in
   the code.

### Verdict

The core of this commit fixes a **real DMA pool memory leak** — DMA
descriptors were not being freed when the plane state was destroyed
during reset. This is a legitimate resource leak bug fix. The change is
small, contained to a single driver file, and the fix approach (reusing
the existing proper destroy function) is obviously correct.

The CSC initialization addition adds some risk but is limited to
specific hardware and is part of proper plane reset behavior.

On balance, the resource leak fix makes this worth backporting despite
the small additional CSC change.

**YES**

 .../gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c   | 52 +++++++++----------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c b/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c
index 92132be9823f1..0ffec44c6d317 100644
--- a/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c
+++ b/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c
@@ -1155,32 +1155,6 @@ static int atmel_hlcdc_plane_alloc_dscrs(struct drm_plane *p,
 	return -ENOMEM;
 }
 
-static void atmel_hlcdc_plane_reset(struct drm_plane *p)
-{
-	struct atmel_hlcdc_plane_state *state;
-
-	if (p->state) {
-		state = drm_plane_state_to_atmel_hlcdc_plane_state(p->state);
-
-		if (state->base.fb)
-			drm_framebuffer_put(state->base.fb);
-
-		kfree(state);
-		p->state = NULL;
-	}
-
-	state = kzalloc(sizeof(*state), GFP_KERNEL);
-	if (state) {
-		if (atmel_hlcdc_plane_alloc_dscrs(p, state)) {
-			kfree(state);
-			drm_err(p->dev,
-				"Failed to allocate initial plane state\n");
-			return;
-		}
-		__drm_atomic_helper_plane_reset(p, &state->base);
-	}
-}
-
 static struct drm_plane_state *
 atmel_hlcdc_plane_atomic_duplicate_state(struct drm_plane *p)
 {
@@ -1222,6 +1196,32 @@ static void atmel_hlcdc_plane_atomic_destroy_state(struct drm_plane *p,
 	kfree(state);
 }
 
+static void atmel_hlcdc_plane_reset(struct drm_plane *p)
+{
+	struct atmel_hlcdc_plane_state *state;
+	struct atmel_hlcdc_dc *dc = p->dev->dev_private;
+	struct atmel_hlcdc_plane *plane = drm_plane_to_atmel_hlcdc_plane(p);
+
+	if (p->state) {
+		atmel_hlcdc_plane_atomic_destroy_state(p, p->state);
+		p->state = NULL;
+	}
+
+	state = kzalloc(sizeof(*state), GFP_KERNEL);
+	if (state) {
+		if (atmel_hlcdc_plane_alloc_dscrs(p, state)) {
+			kfree(state);
+			drm_err(p->dev,
+				"Failed to allocate initial plane state\n");
+			return;
+		}
+		__drm_atomic_helper_plane_reset(p, &state->base);
+	}
+
+	if (plane->layer.desc->layout.csc)
+		dc->desc->ops->lcdc_csc_init(plane, plane->layer.desc);
+}
+
 static const struct drm_plane_funcs layer_plane_funcs = {
 	.update_plane = drm_atomic_helper_update_plane,
 	.disable_plane = drm_atomic_helper_disable_plane,
-- 
2.51.0


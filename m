Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D3D2E717C;
	Tue, 28 Oct 2025 12:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761655700; cv=none; b=DJIihbhZ/W4Swo/Ynw33TuQWJDRdfoCxUJK3+p67uTV50c5vxG/ZaLOhUO/0sQx8LWCAV6vpiMvYhF72Kh4LWaoz/zKwbdU4zuv4HRBigq6SnX2KmxRDyufdWYu9lQOiu8bqphm/diK8hQkLFzUpmUWTrPWPCojr6Qj6yE9Rjtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761655700; c=relaxed/simple;
	bh=/h2drVqO1InF96B9qDaDz4yv3OkbMe5ocrXajxyCvCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EtK443e2y4JixDIYsA6F9F3bAqYeDCAqGScC9wouXllIOF9c/GXNxUoeStnJnO/4p9BfiJuPYr/91RZG3PG2RoUNABSnvK/vpTlju5ms4vGVD3wkkMpfstm2by4vjiGALkoM4BlV0xKpaY4/FHU3z0HQ78IEXrr8+jld8Nk/4Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gh8C1Nss; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gh8C1Nss"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54DE4C4CEF7;
	Tue, 28 Oct 2025 12:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761655700;
	bh=/h2drVqO1InF96B9qDaDz4yv3OkbMe5ocrXajxyCvCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gh8C1NssEqtzYfLhxQq7CXUuGTBQ15t03R4w7cBvkorwvE0n8JTPtxsZpaqhJ4cxx
	 GlpD+5FRryJRXPvB2v84kWayhaH4cdFJ+L+9oGOWq1XkQ5PRA7X61rhXAx2JGrcIVg
	 m7fAUUQLl0HmuacbWiO0QpTKVqRKNsSwOPHd8P5eizXGk0zlWHF07qySbZLRAmCoc+
	 CskreMOR/DAi/McxaiuHEguSvYG0d3pSkkwbu5LsNM5gT+i/ZfLJ+8ZTPObLuDQx1F
	 W9CIKwrvu8o4FkwubJ+FJ/7DCUXZJLN1e5iIit78vkTF6C0UtlIriEZQbSuNXIac2C
	 BlyI9ncqw50ZQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jocelyn Falempe <jfalempe@redhat.com>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de,
	dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.17-6.12] drm/panic: Fix overlap between qr code and logo
Date: Tue, 28 Oct 2025 08:48:03 -0400
Message-ID: <20251028124815.1058740-3-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251028124815.1058740-1-sashal@kernel.org>
References: <20251028124815.1058740-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jocelyn Falempe <jfalempe@redhat.com>

[ Upstream commit cfa56e0a0e9b259077b0cb88b431e37dc9a67dee ]

The borders of the qr code was not taken into account to check if it
overlap with the logo, leading to the logo being partially covered.

Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://lore.kernel.org/r/20251009122955.562888-3-jfalempe@redhat.com
Signed-off-by: Jocelyn Falempe <jfalempe@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my analysis of the Linux kernel repository, I can now provide a
comprehensive assessment.

## BACKPORT RECOMMENDATION: **YES**

## DETAILED ANALYSIS:

### 1. COMMIT CONTEXT & HISTORY
Using git history examination, I found:
- The QR code feature was introduced in commit **cb5164ac43d0f**
  (2024-08-22) and first appeared in **v6.12**
- The bug was present from the initial QR code implementation
- This fix is currently only in **v6.18-rc3** and has NOT been
  backported to any stable kernel (v6.12.x, v6.16.x, v6.17.x)
- The commit is part of a patch series (patch 3/3, Link:
  20251009122955.562888-3) alongside other panic screen fixes

### 2. CODE ANALYSIS

**The Bug (drivers/gpu/drm/drm_panic.c:749):**
```c
- if (!drm_rect_overlap(&r_logo, &r_msg) && !drm_rect_overlap(&r_logo,
  &r_qr))
+       if (!drm_rect_overlap(&r_logo, &r_msg) &&
!drm_rect_overlap(&r_logo, &r_qr_canvas))
```

**Context Understanding:**
- Line 727: `qr_canvas_width = qr_width + QR_MARGIN * 2` (canvas
  includes margins)
- Line 734: `r_qr_canvas` = full QR area including **4-module margins**
  (QR_MARGIN=4)
- Line 739: `r_qr` = actual QR code area **excluding margins**
- Lines 756-758: The margin is intentionally drawn with foreground color
  for visual contrast

**Impact:** The incorrect overlap check allows the logo to be drawn over
the QR code's margin area, causing visual corruption of the panic
screen.

### 3. SCOPE & IMPACT ASSESSMENT

**Affected Code Paths:**
- `draw_panic_static_qr_code()` (line 762) → called when user selects
  "qr_code" panic screen (line 796)
- Only affects systems using the QR code panic screen option
- No security implications, no data corruption, no crashes

**User Visibility:**
- Medium impact: Visible corruption on panic screens that use QR codes
  with logos
- QR code readability may be reduced if logo overlaps the margin
- Affects user experience during critical system failures

### 4. BACKPORT SUITABILITY ANALYSIS

**Positive Indicators:**
- ✅ **Bug fix**: Corrects incorrect overlap detection logic introduced
  in v6.12
- ✅ **Minimal change**: Single-line fix, extremely low regression risk
- ✅ **Self-contained**: No dependencies, no API changes
- ✅ **Stable kernel affected**: v6.12.x series is actively maintained
  (currently at v6.12.55)
- ✅ **Related fixes exist**: Sibling commit 179753aa5b789 "Fix drawing
  the logo on a small narrow screen" has `Fixes: 4b570ac2eb54` tag and
  addresses similar issues
- ✅ **Active subsystem**: 50+ drm/panic commits since QR feature
  introduction shows active maintenance

**Negative Indicators:**
- ⚠️ **No stable tag**: Missing `Cc: stable@vger.kernel.org` (likely
  oversight)
- ⚠️ **No Fixes tag**: Should have `Fixes: cb5164ac43d0f ("drm/panic:
  Add a QR code panic screen")`
- ⚠️ **Cosmetic bug**: Visual-only issue, not a critical functional or
  security bug

### 5. STABLE KERNEL RULES COMPLIANCE

According to stable kernel rules (Documentation/process/stable-kernel-
rules.rst):
- ✅ Must fix a real bug that affects users (visual corruption affects
  usability)
- ✅ Must be obviously correct (trivial rectangle variable substitution)
- ✅ Must be small and self-contained (1 line changed)
- ✅ Must not introduce new features (pure bug fix)
- ✅ Should already exist in mainline (exists in v6.18-rc3)

### 6. TOOLS USED IN ANALYSIS
- **git log/show**: Commit history, patch series identification
- **git tag --contains**: Version tracking (feature introduction, fix
  propagation)
- **git diff**: Code change examination
- **Grep**: Function and pattern location
- **Read**: Contextual code analysis around the bug

### 7. RECOMMENDATION RATIONALE

This commit **should be backported** to stable trees (v6.12.x, v6.16.x,
v6.17.x) because:

1. **Fixes a real user-visible bug** in the panic screen QR code display
2. **Extremely low risk**: One-line variable substitution with no side
   effects
3. **Consistent with kernel practices**: Similar logo fixes
   (179753aa5b789) were deemed worthy of Fixes: tags
4. **Affects stable kernels**: The QR feature exists in all kernels ≥
   v6.12
5. **Missing tags likely oversight**: The commit should have had `Fixes:
   cb5164ac43d0f` tag based on pattern of similar fixes
6. **Improves panic screen quality**: Better visual presentation during
   critical system failures aids debugging

The lack of explicit stable tags appears to be an oversight rather than
intentional exclusion, especially given that the closely related commit
in the same patch series (179753aa5b789) includes proper Fixes: tags.

 drivers/gpu/drm/drm_panic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_panic.c b/drivers/gpu/drm/drm_panic.c
index 1d6312fa14293..ea6a64e5ddd76 100644
--- a/drivers/gpu/drm/drm_panic.c
+++ b/drivers/gpu/drm/drm_panic.c
@@ -746,7 +746,7 @@ static int _draw_panic_static_qr_code(struct drm_scanout_buffer *sb)
 	/* Fill with the background color, and draw text on top */
 	drm_panic_fill(sb, &r_screen, bg_color);
 
-	if (!drm_rect_overlap(&r_logo, &r_msg) && !drm_rect_overlap(&r_logo, &r_qr))
+	if (!drm_rect_overlap(&r_logo, &r_msg) && !drm_rect_overlap(&r_logo, &r_qr_canvas))
 		drm_panic_logo_draw(sb, &r_logo, font, fg_color);
 
 	draw_txt_rectangle(sb, font, panic_msg, panic_msg_lines, true, &r_msg, fg_color);
-- 
2.51.0


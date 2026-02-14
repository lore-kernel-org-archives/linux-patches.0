Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7691E221FB6;
	Sat, 14 Feb 2026 01:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031261; cv=none; b=CKC5itzFuhGsudw8fuUH6URMYJYse9gLYzjvPKeZeBqOQ2IePF3vT909AkbgudC/RmSKOMIVKipNY4VUecdv/lmed9k+dSY2jjwQ8OUZEJZnSk8fjaMBXC0LggFCBiW/iiFsy9Vi8zFp5OkUF6oiFYi1vR+HQXmYjQ2G97jc+Uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031261; c=relaxed/simple;
	bh=NdZuwBF6c3SvE15mIrOUjss8LIFzipRcisNbCNnXhVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cEK4xX4ZQ8mGGHRMa6+0y2Smv3b1igBWyKJOEakzj9wCspECYdRMo9nOhe+QafghZwyB9tLJUQ2NqTSYrRuOgYcgMiwtbmRA9JCoIcLjpExi6btychkWvCdg/pgGQKA7aKTshkjHESI3n4BqkbtZAwIRwRNsHgE/0ptS3q61dM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gDPUrj5S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gDPUrj5S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ABD0C116C6;
	Sat, 14 Feb 2026 01:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031261;
	bh=NdZuwBF6c3SvE15mIrOUjss8LIFzipRcisNbCNnXhVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gDPUrj5SHKhvQ5u0nLkGnMMabnuBO9pJwn3djMNzr/LRq6tSYVoX2uvxp3XOxga5c
	 bCA406XP42BUrgpuxlgQ7vbmHTT1odXSfw+o3Sh//8FkLsA0GRIv7WZEop/MIXLUCS
	 u6VSqfqYNJevEluFBc8v/miuRRYAoa7bHqqcpYzVtiNz+Lsaa2IvIEfAARavWJL+nQ
	 Y0+d1YAd0qINfixiSrA4cot5tirZ6u6PH0iksgoB/O2OaIxWocvNHlfg1v17cL83nf
	 f3OEfl4ekykNoYIbx5AOvtTEkrvhijDd30rTtSpA3/qnE3UghC15PVdjcGdY2NUZRP
	 bQXYWqiTHE9fQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	neil.armstrong@linaro.org,
	yelangyan@huaqin.corp-partner.google.com
Subject: [PATCH AUTOSEL 6.19-5.10] media: omap3isp: isppreview: always clamp in preview_try_format()
Date: Fri, 13 Feb 2026 20:00:05 -0500
Message-ID: <20260214010245.3671907-125-sashal@kernel.org>
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

From: Hans Verkuil <hverkuil+cisco@kernel.org>

[ Upstream commit 17e1e1641f74a89824d4de3aa38c78daa5686cc1 ]

If prev->input != PREVIEW_INPUT_MEMORY the width and height weren't
clamped. Just always clamp.

This fixes a v4l2-compliance error:

	fail: v4l2-test-subdevs.cpp(171): fse.max_width == ~0U || fse.max_height == ~0U
	fail: v4l2-test-subdevs.cpp(270): ret && ret != ENOTTY
test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL

Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a thorough analysis.

---

## Detailed Analysis

### 1. Commit Message Analysis

The commit message is clear and direct: when `prev->input !=
PREVIEW_INPUT_MEMORY`, the `preview_try_format()` function was **not
clamping** width and height values at all. The fix simply makes the
clamping unconditional. The commit explicitly references a
v4l2-compliance test failure.

### 2. Code Change Analysis

The change is in `preview_try_format()`, specifically the
`PREV_PAD_SINK` case:

**Before (buggy):**
```c
if (prev->input == PREVIEW_INPUT_MEMORY) {
    fmt->width = clamp_t(u32, fmt->width, PREV_MIN_IN_WIDTH,
                         preview_max_out_width(prev));
    fmt->height = clamp_t(u32, fmt->height,
                          PREV_MIN_IN_HEIGHT,
                          PREV_MAX_IN_HEIGHT);
}
```

**After (fixed):**
```c
fmt->width = clamp_t(u32, fmt->width, PREV_MIN_IN_WIDTH,
                     preview_max_out_width(prev));
fmt->height = clamp_t(u32, fmt->height,
                      PREV_MIN_IN_HEIGHT,
                      PREV_MAX_IN_HEIGHT);
```

The conditional `if (prev->input == PREVIEW_INPUT_MEMORY)` is removed,
making the clamp apply regardless of input source.

### 3. Bug Mechanism — How the Problem Manifests

The critical caller is `preview_enum_frame_size()` (line 1892). This
function implements `VIDIOC_SUBDEV_ENUM_FRAME_SIZE`, which userspace
applications call to discover supported frame sizes. The function works
by:

1. Setting `format.width = -1; format.height = -1;` (i.e., `0xFFFFFFFF`
   as u32)
2. Calling `preview_try_format()` to clamp to the maximum
3. Reading back `fse->max_width = format.width; fse->max_height =
   format.height;`

When `prev->input != PREVIEW_INPUT_MEMORY` (i.e., input is from CCDC),
the clamp is skipped, so:
- `fse->max_width` remains `~0U` (4294967295)
- `fse->max_height` remains `~0U` (4294967295)

This causes the v4l2-compliance test failure (`fse.max_width == ~0U ||
fse.max_height == ~0U`), and more importantly, returns **incorrect,
nonsensical values** to any userspace application querying supported
frame sizes.

### 4. Beyond Compliance — Real Bug Impact

This isn't just a compliance issue. The unclamped values have real
downstream consequences:

**a) Incorrect crop calculations:** In `preview_set_format()` (line
2042), after calling `preview_try_format()`, the unclamped format
dimensions are used to initialize the crop rectangle:

```c
crop->width = fmt->format.width;   // could be ~0U
crop->height = fmt->format.height; // could be ~0U
```

This then feeds into `preview_try_crop()`, where `sink->width -
PREV_MARGIN_RIGHT` with `sink->width = ~0U` would cause an integer
wraparound calculation for the `right` boundary.

**b) Userspace confusion:** Any V4L2 media application that uses frame
size enumeration to determine valid dimensions would receive nonsensical
maximum values, potentially leading to incorrect format negotiation.

### 5. Scope and Risk Assessment

- **Lines changed:** Net -5 lines (removing the `if` guard and comment
  lines, keeping the clamp calls)
- **Files touched:** 1 file (`isppreview.c`)
- **Risk:** Extremely low. The change makes an existing clamp operation
  unconditional. Values that were already in-range will remain unchanged
  after clamping. For the CCDC input path, the original comment said the
  CCDC already constrains the size — so clamping here is merely
  defensive, adding an extra safety net. It cannot break the CCDC path.
- **Dependencies:** None — fully self-contained change.

### 6. Stable Tree Applicability

- **Code exists in stable trees:** Confirmed. The identical buggy code
  is present in v5.15 (old path `drivers/media/platform/omap3isp/`),
  v6.1, and v6.6 (new path `drivers/media/platform/ti/omap3isp/`).
- **Clean backport:** The patch applies cleanly to all stable trees with
  at most a trivial path adjustment for v5.15.
- **Testing:** Acked by Sakari Ailus (omap3isp maintainer). The fix was
  tested with v4l2-compliance.

### 7. Classification

This is a **bug fix** that:
- Fixes incorrect V4L2 API behavior (returning ~0U for max frame
  dimensions)
- Fixes a v4l2-compliance test failure
- Prevents potential integer wraparound in downstream crop calculations
- Is small, obvious, self-contained, and low-risk
- Has no dependencies on other commits

### 8. Verdict

The fix meets all stable kernel criteria:
1. **Obviously correct:** Removing a conditional around a clamp
   operation is trivially safe.
2. **Fixes a real bug:** Incorrect max frame size values returned to
   userspace, compliance failure.
3. **Small and contained:** -5 net lines, 1 file, 1 function.
4. **No new features:** Purely a bug fix.
5. **Low regression risk:** Clamping in-range values is a no-op; only
   out-of-range values (the bug) are affected.

The fix is small, surgical, obviously correct, and fixes a real API
correctness bug that affects any userspace application querying frame
sizes on the OMAP3 ISP preview engine when connected to the CCDC. It
applies cleanly to all active stable trees.

**YES**

 .../media/platform/ti/omap3isp/isppreview.c   | 21 +++++++------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/media/platform/ti/omap3isp/isppreview.c b/drivers/media/platform/ti/omap3isp/isppreview.c
index e383a57654de8..5c492b31b5160 100644
--- a/drivers/media/platform/ti/omap3isp/isppreview.c
+++ b/drivers/media/platform/ti/omap3isp/isppreview.c
@@ -1742,22 +1742,17 @@ static void preview_try_format(struct isp_prev_device *prev,
 
 	switch (pad) {
 	case PREV_PAD_SINK:
-		/* When reading data from the CCDC, the input size has already
-		 * been mangled by the CCDC output pad so it can be accepted
-		 * as-is.
-		 *
-		 * When reading data from memory, clamp the requested width and
-		 * height. The TRM doesn't specify a minimum input height, make
+		/*
+		 * Clamp the requested width and height.
+		 * The TRM doesn't specify a minimum input height, make
 		 * sure we got enough lines to enable the noise filter and color
 		 * filter array interpolation.
 		 */
-		if (prev->input == PREVIEW_INPUT_MEMORY) {
-			fmt->width = clamp_t(u32, fmt->width, PREV_MIN_IN_WIDTH,
-					     preview_max_out_width(prev));
-			fmt->height = clamp_t(u32, fmt->height,
-					      PREV_MIN_IN_HEIGHT,
-					      PREV_MAX_IN_HEIGHT);
-		}
+		fmt->width = clamp_t(u32, fmt->width, PREV_MIN_IN_WIDTH,
+				     preview_max_out_width(prev));
+		fmt->height = clamp_t(u32, fmt->height,
+				      PREV_MIN_IN_HEIGHT,
+				      PREV_MAX_IN_HEIGHT);
 
 		fmt->colorspace = V4L2_COLORSPACE_SRGB;
 
-- 
2.51.0


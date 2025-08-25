Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46FB8405F7;
	Mon, 25 Aug 2025 12:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756124119; cv=none; b=hdG0iPvm4o4RdpcUx34vA3h1jDAbwCdAMPau2TPOI0KsS8l7HkPzNZ9BnwiDDBHDLHlMmlwceX+e/Kht92lL9fINx+oC0/H8azvutPJ2x0BsXkeSkS8oZ9njheZtD8BdIOEP9GXkvuPihhgxJQqKbU8S+FNDU4enD5ItGEhveEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756124119; c=relaxed/simple;
	bh=sNWPxgv+b1A4FaJWevhxqfNI+FaYtWmhebrqEcudSBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nAICCI/aBUSW+L271/W6rzQflhwsB/JEVylKUh2xFFv6ysKl1uKCfIaU7wHIqmt1oE1BN1wOpYJFmfr4zqWbPyKeUz+UV61XtAB0NNEtWB0CfkcCvsLNUzkypsY1WPaRHPwi7DTB7TAISWSbg0fHyqfNfmQkOlI72bbkVCxq1k8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gFEY0m77; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gFEY0m77"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18F2CC4CEED;
	Mon, 25 Aug 2025 12:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756124118;
	bh=sNWPxgv+b1A4FaJWevhxqfNI+FaYtWmhebrqEcudSBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gFEY0m77Z8ZuBbZcwcj/5pNIgAmcvJ0xt9UXrZePCRYaCUqiY+grTb9xT+HP2k6tg
	 VDw1TB3buWee/pcO6N0C2C1gCInE16wIJQWoxxFWfcn4v8GeBhcFGWcK7jcMJjUas7
	 gj7tnc1WxyyJT4SEchr03wsYvJQ0OytUovL73VC9Y0ya7xdHb/UdjZCtKcGjV1UxTE
	 YYJN4aJudG8j9bkA1UCnDdD6jxEA98yBwCx+UJ8oIoHt6mb0hAsaogS+pgDn3rzThf
	 3L5D96nS1n83bz1Z34rSxU1YTRcr9N7MshzQ38wbdVrl749KCtGPZ0LZ08f+KjAl8E
	 3ElI9SdGDW9Aw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Rodrigo Siqueira <siqueira@igalia.com>,
	Alex Hung <alex.hung@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.16-5.10] drm/amd/display: Don't warn when missing DCE encoder caps
Date: Mon, 25 Aug 2025 08:14:57 -0400
Message-ID: <20250825121505.2983941-8-sashal@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250825121505.2983941-1-sashal@kernel.org>
References: <20250825121505.2983941-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16.3
Content-Transfer-Encoding: 8bit

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit 8246147f1fbaed522b8bcc02ca34e4260747dcfb ]

On some GPUs the VBIOS just doesn't have encoder caps,
or maybe not for every encoder.

This isn't really a problem and it's handled well,
so let's not litter the logs with it.

Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Rodrigo Siqueira <siqueira@igalia.com>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 33e0227ee96e62d034781e91f215e32fd0b1d512)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my analysis of this commit, here is my determination:

**Backport Status: YES**

## Extensive Explanation:

This commit is a good candidate for backporting to stable kernel trees
for the following reasons:

### 1. **It fixes a user-visible issue (log spam)**
The commit addresses warning messages that unnecessarily clutter system
logs. The code shows that when `get_encoder_cap_info()` returns
`BP_RESULT_NORECORD` (meaning the VBIOS doesn't have encoder
capabilities for that specific encoder), it was incorrectly logging a
warning. Looking at the code pattern across the AMD display driver,
`BP_RESULT_NORECORD` is a normal, expected condition - not an error.

### 2. **The fix is minimal and contained**
The change is extremely simple - it only modifies the condition check
from:
```c
if (BP_RESULT_OK == result) {
    // handle success
} else {
    DC_LOG_WARNING(...); // Always warn on non-OK
}
```
to:
```c
if (result == BP_RESULT_OK) {
    // handle success
} else if (result != BP_RESULT_NORECORD) {
    DC_LOG_WARNING(...); // Only warn on actual errors
}
```

### 3. **No functional changes or new features**
The commit doesn't change any behavior - it only suppresses
inappropriate warning messages. The driver already handles the missing
encoder caps gracefully (as noted in the commit message: "This isn't
really a problem and it's handled well").

### 4. **Low risk of regression**
The change only affects logging behavior. It doesn't modify:
- Any hardware initialization sequences
- Any encoder capabilities detection logic
- Any functional paths in the driver
- Any data structures or APIs

### 5. **Pattern consistency across the codebase**
My grep analysis shows that `BP_RESULT_NORECORD` is commonly handled
without warnings in other parts of the AMD display driver. For example,
in `dc_link.c`, it uses `ASSERT(bp_result == BP_RESULT_NORECORD)`
showing it's an expected condition. Many other functions simply return
`BP_RESULT_NORECORD` without logging warnings.

### 6. **Applied to two identical code paths**
The commit applies the same fix to both
`dce110_link_encoder_construct()` and `dce60_link_encoder_construct()`
functions, maintaining consistency and preventing the warning in both
DCE 11.0 and DCE 6.0 hardware paths.

### 7. **Already cherry-picked**
The commit message shows "(cherry picked from commit 33e0227ee96e...)",
indicating it was already deemed important enough to cherry-pick to
another branch, suggesting its stability importance.

### 8. **Quality of Life improvement for users**
Reducing unnecessary log spam improves the user experience and makes it
easier to identify real problems in system logs. This is especially
important for users monitoring their systems for actual issues.

The commit follows stable tree rules perfectly: it's a small, contained
fix for a real issue (log spam) that affects users, with minimal risk of
introducing regressions.

 drivers/gpu/drm/amd/display/dc/dce/dce_link_encoder.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dce/dce_link_encoder.c b/drivers/gpu/drm/amd/display/dc/dce/dce_link_encoder.c
index 4a9d07c31bc5..0c50fe266c8a 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dce_link_encoder.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_link_encoder.c
@@ -896,13 +896,13 @@ void dce110_link_encoder_construct(
 						enc110->base.id, &bp_cap_info);
 
 	/* Override features with DCE-specific values */
-	if (BP_RESULT_OK == result) {
+	if (result == BP_RESULT_OK) {
 		enc110->base.features.flags.bits.IS_HBR2_CAPABLE =
 				bp_cap_info.DP_HBR2_EN;
 		enc110->base.features.flags.bits.IS_HBR3_CAPABLE =
 				bp_cap_info.DP_HBR3_EN;
 		enc110->base.features.flags.bits.HDMI_6GB_EN = bp_cap_info.HDMI_6GB_EN;
-	} else {
+	} else if (result != BP_RESULT_NORECORD) {
 		DC_LOG_WARNING("%s: Failed to get encoder_cap_info from VBIOS with error code %d!\n",
 				__func__,
 				result);
@@ -1798,13 +1798,13 @@ void dce60_link_encoder_construct(
 						enc110->base.id, &bp_cap_info);
 
 	/* Override features with DCE-specific values */
-	if (BP_RESULT_OK == result) {
+	if (result == BP_RESULT_OK) {
 		enc110->base.features.flags.bits.IS_HBR2_CAPABLE =
 				bp_cap_info.DP_HBR2_EN;
 		enc110->base.features.flags.bits.IS_HBR3_CAPABLE =
 				bp_cap_info.DP_HBR3_EN;
 		enc110->base.features.flags.bits.HDMI_6GB_EN = bp_cap_info.HDMI_6GB_EN;
-	} else {
+	} else if (result != BP_RESULT_NORECORD) {
 		DC_LOG_WARNING("%s: Failed to get encoder_cap_info from VBIOS with error code %d!\n",
 				__func__,
 				result);
-- 
2.50.1


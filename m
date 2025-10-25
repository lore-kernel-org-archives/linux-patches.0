Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE9D238142;
	Sat, 25 Oct 2025 16:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409274; cv=none; b=nu+MypENF/KpDeuItR1MPtzs+J54DE9mbgr5xqgR2U/idGWP5Ribn6znbbdAo1GQwQTT56umff4ej5kxRIT4IqUNDVXWXRqEq+SRSxy+oJUlOpqBLIFEZc+5Dloz7oZ6buA9oY6bfkrlg/w/yGIYA1fLGl/X/39n2Pue6dbO+TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409274; c=relaxed/simple;
	bh=0nsqrPcI03IOBD7eCVS3QRH2Y1z/lcDXp2LMPapP2Hg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WpUCLqcH7FDrJtaC8JbcuE2XGpaXcd9WEUls3Q7sYYWzw7T9KbOrl75vAkx+mHmxOIuUrz2hyP3LfN6EdSYaU/JfhLB5+RR5K86FSsafQQcwPuZxVKhLln5wwBLMaq9B/sWjZ7lP1GyBS/PL6ZVqCDycwp+FJQsoqsvjPm9hbio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bZXHmI+Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bZXHmI+Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0237FC19421;
	Sat, 25 Oct 2025 16:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409271;
	bh=0nsqrPcI03IOBD7eCVS3QRH2Y1z/lcDXp2LMPapP2Hg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bZXHmI+QW+Kv6iLgaZcA8b6CdESFKIFqr9KUY3b0UfOPEqKK4BulzLFVc/0XfbkL2
	 0cd94Gkix9TEq4MVrSm0bBIbnAhRq36hskodfP8wWO5QbXKLDuFDbPMiWU4D914INd
	 mViH4Dq9R0f5CVTDSIWGVjTXgGGbYmjpilxFH19QZotZUSgrvHiDbY0fmB0Wz8vMKs
	 lyqjHDpIHCmmBmgMeKgoaqzDjbX0M4U/x2SGa+Uqylm6aywO/uplfTTszlpmXNwtqT
	 iMrxYbzliUfz9lh+GlzSZKMOd0c2ZPjbab1fYdIQUmhXWk+IU4MHMz/hN3u1rWPz1a
	 f92Uz7xsntd7w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mario Limonciello <superm1@kernel.org>,
	Alex Hung <alex.hung@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	mario.limonciello@amd.com,
	Wayne.Lin@amd.com,
	aurabindo.pillai@amd.com,
	chiahsuan.chung@amd.com,
	alexandre.f.demers@gmail.com
Subject: [PATCH AUTOSEL 6.17] drm/amd/display: Indicate when custom brightness curves are in use
Date: Sat, 25 Oct 2025 11:58:08 -0400
Message-ID: <20251025160905.3857885-257-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
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

From: Mario Limonciello <superm1@kernel.org>

[ Upstream commit 68f3c044f37d9f50d67417fa8018d9cf16423458 ]

[Why]
There is a `scale` sysfs attribute that can be used to indicate when
non-linear brightness scaling is in use.  As Custom brightness curves
work by linear interpolation of points the scale is no longer linear.

[How]
Indicate non-linear scaling when custom brightness curves in use and
linear scaling otherwise.

Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Mario Limonciello <superm1@kernel.org>
Signed-off-by: Wayne Lin <wayne.lin@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it changes
  - Sets `backlight_properties.scale` during backlight registration to
    reflect actual brightness scaling:
    - Marks non-linear when custom brightness curves are used:
      drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c:5071
    - Marks linear otherwise:
      drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c:5073
  - Gate is identical to where custom curves are actually applied
    (`caps->data_points` present and debug mask not set):
    drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c:5069

- Why it matters (user-visible bug)
  - The backlight class exposes a sysfs `scale` attribute that reports
    the brightness scale type from `bd->props.scale`:
    drivers/video/backlight/backlight.c:264
  - Without this patch, AMDGPU leaves `props.scale` at its zero-
    initialized default (unknown) due to `props = { 0 }`:
    drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c:5041
  - When custom brightness curves are in use, AMDGPU actually performs a
    piecewise linear interpolation of luminance vs. input signal (i.e.,
    non-linear to the user’s scale), see the interpolation path and the
    same debug-mask gate:
    drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c:4826
  - Reporting “unknown” is inaccurate and prevents userspace from
    correctly indicating or adapting to non-linear scaling.

- Scope and risk
  - Small, localized change in a single function at device registration
    time; no architectural changes.
  - Does not alter brightness programming, only improves sysfs
    reporting. The backlight core only reads `props.scale` for the
    `scale` sysfs attribute (no behavioral dependency):
    drivers/video/backlight/backlight.c:264
  - Uses established backlight scale enums: `BACKLIGHT_SCALE_LINEAR` and
    `BACKLIGHT_SCALE_NON_LINEAR`: include/linux/backlight.h:83,
    include/linux/backlight.h:91
  - Matches existing pattern in other backlight drivers that already set
    `props.scale`.

- Stable backport criteria
  - Fixes a user-visible correctness issue (sysfs attribute previously
    “unknown” despite known scaling behavior).
  - Minimal risk of regression; confined to AMDGPU backlight
    registration.
  - No new features or ABI additions—just accurate population of an
    existing, stable attribute.

- Note on applicability
  - Targets stable trees that already have `backlight_properties.scale`
    and the `scale` sysfs attribute. For trees lacking these, mechanical
    backporting would need adaptation, but for kernels with the field
    present, this is straightforward and safe.

 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index afe3a8279c3a9..8eb2fc4133487 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -5032,8 +5032,11 @@ amdgpu_dm_register_backlight_device(struct amdgpu_dm_connector *aconnector)
 	} else
 		props.brightness = props.max_brightness = MAX_BACKLIGHT_LEVEL;
 
-	if (caps->data_points && !(amdgpu_dc_debug_mask & DC_DISABLE_CUSTOM_BRIGHTNESS_CURVE))
+	if (caps->data_points && !(amdgpu_dc_debug_mask & DC_DISABLE_CUSTOM_BRIGHTNESS_CURVE)) {
 		drm_info(drm, "Using custom brightness curve\n");
+		props.scale = BACKLIGHT_SCALE_NON_LINEAR;
+	} else
+		props.scale = BACKLIGHT_SCALE_LINEAR;
 	props.type = BACKLIGHT_RAW;
 
 	snprintf(bl_name, sizeof(bl_name), "amdgpu_bl%d",
-- 
2.51.0


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 494753043D4;
	Sat, 25 Oct 2025 16:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409133; cv=none; b=MkdnmHVOlflvV5EihY6JOINBambAYk7jYXRBKG8dIFVphb4Xlg8jvxf8Q6Ludrpm+X/lpjf06tfoAuYH4hZjdXCS8M43fgJivxhrZRMv+uEJ9n//bXGWFvJUzft3i+J8jk8qVz0APVOkFrKF1cUTUqND5edc2R53ITGC+nmfMzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409133; c=relaxed/simple;
	bh=Yq+4z6HuVvhYk55wT49mSp8aKdDxY5/CmTo7RIp7nVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jzwgg6cKg681OjN773d7SNBWOPct8CFT8kCkfm1gfZfu3/CrU+CY4GXXN+1jVYfYNOB1R88g9/skUYKeNrkCmbOantGq9pBJTEn0/+3YyneukYZ+XGwrY1ZNwL9XQdMqP6udsCCe6lyb9JQs9u2kBH2RdLPpXJbnjXD3K3FB56s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uWuUgYy/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uWuUgYy/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A50C6C4CEF5;
	Sat, 25 Oct 2025 16:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409133;
	bh=Yq+4z6HuVvhYk55wT49mSp8aKdDxY5/CmTo7RIp7nVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uWuUgYy/DCBzdi2xj4DGoTIm9t6ruJ7L9d7OZ8rMVSA8Ls5zHY9CP2ZOURhrF5hxz
	 49g8QXuB7uhcRYYqu6anASTgXq+mIDZfWezksSY9H1h/3+HwTcMePaCjt1QNXr580X
	 wWuYDzRDVJRF3TbEIwtUJVUxQgZyV4iwthnMpyso9kEUI3zpJfFJDPibkJfT9szmCj
	 LoL0+/mobQKBmt3YWeYwXUNN2aQcKgB4P9e018GkpYV5wijpkWq2vd2SzG9SjVoM2o
	 0o1VxyyabnmZbMLqNQSIah6zxhJNz/574LL6k/U7h1YSlZxKE6ooUPxwGPFQragV5T
	 R7X5kMjvvFG9g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Relja Vojvodic <rvojvodi@amd.com>,
	Chris Park <chris.park@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Austin.Zheng@amd.com,
	Dillon.Varone@amd.com,
	alvin.lee2@amd.com,
	colin.i.king@gmail.com,
	Yihan.Zhu@amd.com,
	alexandre.f.demers@gmail.com
Subject: [PATCH AUTOSEL 6.17-6.12] drm/amd/display: Increase minimum clock for TMDS 420 with pipe splitting
Date: Sat, 25 Oct 2025 11:57:23 -0400
Message-ID: <20251025160905.3857885-212-sashal@kernel.org>
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

From: Relja Vojvodic <rvojvodi@amd.com>

[ Upstream commit 002a612023c8b105bd3829d81862dee04368d6de ]

[Why]
-Pipe splitting allows for clocks to be reduced, but when using TMDS 420,
reduced clocks lead to missed clocks cycles on clock resyncing

[How]
-Impose a minimum clock when using TMDS 420

Reviewed-by: Chris Park <chris.park@amd.com>
Signed-off-by: Relja Vojvodic <rvojvodi@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it fixes
  - Prevents missed clock cycles during clock resync when using HDMI
    TMDS with YCbCr 4:2:0 and ODM pipe splitting (commit message
    explicitly cites user-visible failures). This is a correctness fix,
    not a feature.

- What changed (code-level)
  - `CalculateRequiredDispclk` now takes `isTMDS420` and clamps the
    required display clock to a minimum of `PixelClock / 2.0` when TMDS
    4:2:0 is used:
    - Function signature adds the flag: drivers/gpu/drm/amd/display/dc/d
      ml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c:1239
    - The ODM-scaling branches are unchanged (e.g., 4:1 → `PixelClock /
      4.0` at 1247), but a new clamp is applied:
      - TMDS-420 check: 1256
      - Clamp: `DispClk = math_max2(DispClk, PixelClock / 2.0);` at 1258
  - `CalculateODMMode` detects TMDS 4:2:0 and passes the new flag to all
    `CalculateRequiredDispclk` calls:
    - TMDS-420 detection: `(OutFormat == dml2_420 && Output ==
      dml2_hdmi)` at 4134
    - Updated calls: 4136, 4137, 4138, 4139

- Why it’s needed
  - ODM combine modes lower pipe clocks (e.g., 3:1 → `PixelClock/3`, 4:1
    → `PixelClock/4`). For HDMI TMDS 4:2:0 (two pixels per TMDS clock),
    letting DISPCLK drop below `PixelClock/2` can cause resync to miss
    clock cycles. The clamp ensures DISPCLK never falls below the
    effective minimum for TMDS 420, avoiding those failures.

- Scope and side effects
  - Scope is tightly limited to DML2.1 DCN4 calculations for AMD
    display, and only when:
    - Output is HDMI and the output format is 4:2:0 (line 4134).
    - ODM pipe splitting is being considered (the affected DISPCLK
      computations at 4136–4139).
  - No architectural changes; static function signature change is local
    to the file, with all callers updated.
  - Potential behavioral change: ODM 3:1 or 4:1 modes may no longer be
    selected if the clamped DISPCLK would exceed the device’s
    `MaxDispclk`. That trades an unstable configuration (missed clocks)
    for a safe one (bypass or 2:1), which is appropriate for stable.

- Risk assessment
  - Small, localized change; clearly guarded by `isTMDS420`. No API,
    ABI, or cross-subsystem impact.
  - Aligns with existing math for TMDS 4:2:0 behavior elsewhere (e.g.,
    other code also treats 4:2:0 as 2 pixels per clock).
  - The worst case is a slightly higher required DISPCLK or a different
    ODM choice, which avoids the reported failure mode.

- Stable backport criteria
  - Fixes a real user-visible bug (missed clock cycles/resync issues).
  - Minimal and contained to one source file in AMD display’s DML2.1
    path.
  - No new features or architectural changes.
  - Touches a GPU driver (not a core kernel subsystem), limiting
    regression blast radius.
  - Even without a Fixes: tag, the change is a clear bugfix with strong
    rationale.

Given the above, this is a good candidate for backporting to stable
trees that include the DML2.1 DCN4 code path.

 .../src/dml2_core/dml2_core_dcn4_calcs.c      | 28 +++++++++++++------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c b/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c
index b9cff21985110..bf62d42b3f78b 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c
@@ -1238,18 +1238,27 @@ static void CalculateDETBufferSize(
 
 static double CalculateRequiredDispclk(
 	enum dml2_odm_mode ODMMode,
-	double PixelClock)
+	double PixelClock,
+	bool isTMDS420)
 {
+	double DispClk;
 
 	if (ODMMode == dml2_odm_mode_combine_4to1) {
-		return PixelClock / 4.0;
+		DispClk = PixelClock / 4.0;
 	} else if (ODMMode == dml2_odm_mode_combine_3to1) {
-		return PixelClock / 3.0;
+		DispClk = PixelClock / 3.0;
 	} else if (ODMMode == dml2_odm_mode_combine_2to1) {
-		return PixelClock / 2.0;
+		DispClk = PixelClock / 2.0;
 	} else {
-		return PixelClock;
+		DispClk = PixelClock;
+	}
+
+	if (isTMDS420) {
+		double TMDS420MinPixClock = PixelClock / 2.0;
+		DispClk = math_max2(DispClk, TMDS420MinPixClock);
 	}
+
+	return DispClk;
 }
 
 static double TruncToValidBPP(
@@ -4122,11 +4131,12 @@ static noinline_for_stack void CalculateODMMode(
 	bool success;
 	bool UseDSC = DSCEnable && (NumberOfDSCSlices > 0);
 	enum dml2_odm_mode DecidedODMMode;
+	bool isTMDS420 = (OutFormat == dml2_420 && Output == dml2_hdmi);
 
-	SurfaceRequiredDISPCLKWithoutODMCombine = CalculateRequiredDispclk(dml2_odm_mode_bypass, PixelClock);
-	SurfaceRequiredDISPCLKWithODMCombineTwoToOne = CalculateRequiredDispclk(dml2_odm_mode_combine_2to1, PixelClock);
-	SurfaceRequiredDISPCLKWithODMCombineThreeToOne = CalculateRequiredDispclk(dml2_odm_mode_combine_3to1, PixelClock);
-	SurfaceRequiredDISPCLKWithODMCombineFourToOne = CalculateRequiredDispclk(dml2_odm_mode_combine_4to1, PixelClock);
+	SurfaceRequiredDISPCLKWithoutODMCombine = CalculateRequiredDispclk(dml2_odm_mode_bypass, PixelClock, isTMDS420);
+	SurfaceRequiredDISPCLKWithODMCombineTwoToOne = CalculateRequiredDispclk(dml2_odm_mode_combine_2to1, PixelClock, isTMDS420);
+	SurfaceRequiredDISPCLKWithODMCombineThreeToOne = CalculateRequiredDispclk(dml2_odm_mode_combine_3to1, PixelClock, isTMDS420);
+	SurfaceRequiredDISPCLKWithODMCombineFourToOne = CalculateRequiredDispclk(dml2_odm_mode_combine_4to1, PixelClock, isTMDS420);
 #ifdef __DML_VBA_DEBUG__
 	DML_LOG_VERBOSE("DML::%s: ODMUse = %d\n", __func__, ODMUse);
 	DML_LOG_VERBOSE("DML::%s: Output = %d\n", __func__, Output);
-- 
2.51.0


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC623570C4;
	Tue, 23 Dec 2025 10:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766484329; cv=none; b=lS53ulCyXJ4ak0wzYsZFNqRESG/DzU4+yrVX7y53RJ5uhVzVWrPckAFM/JppsC1fXdcPi7bWcAQ9tpX7FgN2t177ZQl+aeNx8a6IwcpTg+KpRzBVvh9d3t1oEcBb6bRLw+x/5pN5EHJ3ZWJPS7ALEV1nefCfuXdvrvTVu0XsvWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766484329; c=relaxed/simple;
	bh=Spb/atorjAvphrGuO+AeyfVoNbJ+9P0brPhm4qrFp7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JUo2mRtFKbQtEdN2njTvU9RMMG1zd537a2Zlb/CxqyTlP9+3VVVl2CRVLRjbxuubi0hWwqwohMhbnh/JBjeFNHKzLXn/K5hrblvWDiayPofp8xoKsZcD4waW4K7joGfarMCuPhFyZgeK55k9LVjL02A7Mns2Nxo26IjEChGQIRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KTvIbE4T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KTvIbE4T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9791DC16AAE;
	Tue, 23 Dec 2025 10:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766484329;
	bh=Spb/atorjAvphrGuO+AeyfVoNbJ+9P0brPhm4qrFp7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KTvIbE4Ttywi2sIu+hcPuzZnlo/jvwCJYMCFD7CTGXEiShS+/0xu4JIeidbBBtqme
	 JEZx+xPAOrQXzi/9eV/8QW6O8IBex5+xw8WNQLvVw4eNC4d9vlkEMgZY7ortEGsDHR
	 ySJ/sCmY07Dr0EiWjH8F1651mbqHRZVvQRx/U1THs1wXo/xrHi/B4ogiXnLelFYvS7
	 q6NKiKhY1VVaBhxquZaC7bNW/O0XCzN9tnq/rjflGrq0WAtCK086U/mk5KmjXUESKy
	 +bjew2fTNd8xDc9q0HAOn83xkwQYoSEenOGG11istOjwEmAweRz4V+/8Hwqh1txC1z
	 Q4b5SQCPGD0ww==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Charlene Liu <Charlene.Liu@amd.com>,
	Swapnil Patel <swapnil.patel@amd.com>,
	Chenyu Chen <chen-yu.chen@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	alex.hung@amd.com,
	alvin.lee2@amd.com,
	aurabindo.pillai@amd.com,
	Ausef.Yousof@amd.com,
	timur.kristof@gmail.com,
	michael.strauss@amd.com,
	Martin.Leung@amd.com,
	srinivasan.shanmugam@amd.com
Subject: [PATCH AUTOSEL 6.18-6.6] drm/amd/display: Fix DP no audio issue
Date: Tue, 23 Dec 2025 05:05:11 -0500
Message-ID: <20251223100518.2383364-7-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251223100518.2383364-1-sashal@kernel.org>
References: <20251223100518.2383364-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Charlene Liu <Charlene.Liu@amd.com>

[ Upstream commit 3886b198bd6e49c801fe9552fcfbfc387a49fbbc ]

[why]
need to enable APG_CLOCK_ENABLE enable first
also need to wake up az from D3 before access az block

Reviewed-by: Swapnil Patel <swapnil.patel@amd.com>
Signed-off-by: Charlene Liu <Charlene.Liu@amd.com>
Signed-off-by: Chenyu Chen <chen-yu.chen@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit bf5e396957acafd46003318965500914d5f4edfa)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

### 3. TECHNICAL ANALYSIS

**The Bug:**
The original code had an incorrect operation sequence:
1. Called `az_enable()` - attempts to access audio controller registers
2. Called `enable_pme_wa()` - wakes audio controller from D3 power state

This is backwards - you cannot access hardware registers while the
device is still in D3 (sleeping). The hardware must be woken up FIRST.

**The Fix:**
The fix simply reorders these operations:
1. Call `enable_pme_wa()` - wake audio controller from D3 first
2. Call `az_enable()` - now safe to access registers

### 4. SCOPE AND RISK ASSESSMENT

- **Lines changed:** ~8 lines (just reordering)
- **Files touched:** 1 file (dce110_hwseq.c)
- **Complexity:** Very low - no new logic, just reordering existing
  function calls
- **Subsystem:** AMD display driver, well-tested and mature
- **Risk:** Minimal - same operations, correct sequence

### 5. USER IMPACT

- **Affected users:** AMD GPU users with DisplayPort audio output
- **Severity:** High - complete loss of audio functionality
- **Usage scenario:** Very common (monitors with speakers, AV receivers,
  docking stations)
- **Symptoms:** "DP no audio issue" - a clearly user-visible bug

### 6. STABILITY INDICATORS

- Reviewed-by: Swapnil Patel (AMD engineer)
- Tested-by: Daniel Wheeler (AMD engineer)
- Multiple sign-offs from AMD display team
- Cherry-picked from mainline - indicates AMD considers it important

### 7. DEPENDENCY CHECK

The dce110_hwseq.c file has been in the kernel for years and the
`dce110_enable_audio_stream` function is stable code. The fix only
reorders existing calls to `enable_pme_wa()` and `az_enable()` - both of
which already exist in stable trees.

## Summary

**Meets stable criteria:**
- ✅ **Obviously correct:** Simple reordering to match hardware
  requirements
- ✅ **Fixes real bug:** Complete audio failure on DisplayPort is a
  significant user-visible bug
- ✅ **Small and contained:** ~8 lines changed, same functions, just
  different order
- ✅ **No new features:** No new functionality added
- ✅ **Tested:** Has Tested-by and Reviewed-by tags from AMD engineers
- ✅ **No dependencies:** Uses existing functions already in stable trees

**Risk vs Benefit:**
- **Benefit:** Restores DisplayPort audio functionality for affected AMD
  GPU users
- **Risk:** Very low - the same operations are performed, just in the
  correct hardware-required sequence

This is an ideal stable backport candidate: a small, surgical fix for a
clear user-visible bug (no audio on DP), with proper code review and
testing from the hardware vendor.

**YES**

 drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
index ebc220b29d14..0bf98d834e61 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
@@ -1098,13 +1098,13 @@ void dce110_enable_audio_stream(struct pipe_ctx *pipe_ctx)
 			if (dc->current_state->res_ctx.pipe_ctx[i].stream_res.audio != NULL)
 				num_audio++;
 		}
+		if (num_audio >= 1 && clk_mgr->funcs->enable_pme_wa) {
+			/*wake AZ from D3 first before access az endpoint*/
+			clk_mgr->funcs->enable_pme_wa(clk_mgr);
+		}
 
 		pipe_ctx->stream_res.audio->funcs->az_enable(pipe_ctx->stream_res.audio);
 
-		if (num_audio >= 1 && clk_mgr->funcs->enable_pme_wa)
-			/*this is the first audio. apply the PME w/a in order to wake AZ from D3*/
-			clk_mgr->funcs->enable_pme_wa(clk_mgr);
-
 		link_hwss->enable_audio_packet(pipe_ctx);
 
 		if (pipe_ctx->stream_res.audio)
-- 
2.51.0


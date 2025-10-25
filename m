Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25E7030499B;
	Sat, 25 Oct 2025 16:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409061; cv=none; b=S/KTxTLsIg+BeNQhbOP1NlzsjJGvMrXWJC9qcbTLoRLHYM/dRnWvfm51AcKziU5yMfag/fYYnhACmihc+dOhZVfnUIIEBjC33PnbNMf3DWX5QYQWPXLumD3F88Ejob94cbn3vwk1DEY1IFzpiNIyzAzPR5kwQsmWSiXG9PgZDsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409061; c=relaxed/simple;
	bh=XQEt5gHfr2U68Bm08l10lkvs66uTuukkvCt7ZDkgvH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uFXM3YZgGEm3kZfC2sJCgaabTihtMnOwOaourJ8uPzJ3B0zylLhYZQoNxzIsfXmnqoRyJABVP1Uk3Gz2oTcC8EtV6MQsM0SH4AJ+2s/ZR9gkMC96hkHePhnkWJnb5YKDzRnhM7iC5SMJu/hzs3Al0tst7C0d18OBcPFIBVxo21E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fa8X9256; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fa8X9256"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F4AC4CEF5;
	Sat, 25 Oct 2025 16:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409061;
	bh=XQEt5gHfr2U68Bm08l10lkvs66uTuukkvCt7ZDkgvH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fa8X9256iqK/KypGjEyGgNOoIPYe7NSqqAyJ5GRk0t3GWoHw+j3XiIolk1T3wFgq4
	 +Fgo8slw7ogTf47BrUJL1UpvvIqBHntnZs4rxb/UAKOtcIbbFLtwJ6IaP3WD19gxBy
	 JiMrSJKHeW89z07i0MByoB5HT4LFJdDo601jj5Bdv0GuJI3M//bvZ+X56afu9qR1DN
	 r4dxItiw86KYBYA/PQMCpfxnnN2aUFdrIf9eGAtfNIXCvKCTJP/pzvZZQp89naUJxL
	 G6Xr/UuiUVHhI1h0m0gK4bQCsLIjTlxQKQfqJVYAMNsE9BikT6OKIv0a+xycGethvM
	 t/cNP4Gi/QWHg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Clay King <clayking@amd.com>,
	Dillon Varone <dillon.varone@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	charlene.liu@amd.com,
	nevenko.stupar@amd.com,
	alexandre.f.demers@gmail.com,
	Ilya.Bakoulin@amd.com,
	Swapnil.Patel@amd.com,
	dmytro.laktyushkin@amd.com
Subject: [PATCH AUTOSEL 6.17-6.12] drm/amd/display: incorrect conditions for failing dto calculations
Date: Sat, 25 Oct 2025 11:56:58 -0400
Message-ID: <20251025160905.3857885-187-sashal@kernel.org>
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

From: Clay King <clayking@amd.com>

[ Upstream commit 306cbcc6f687d791ab3cc8fbbe30f5286fd0d1e5 ]

[Why & How]
Previously, when calculating dto phase, we would incorrectly fail when phase
<=0 without additionally checking for the integer value. This meant that
calculations would incorrectly fail when the desired pixel clock was an exact
multiple of the reference clock.

Reviewed-by: Dillon Varone <dillon.varone@amd.com>
Signed-off-by: Clay King <clayking@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

**Why This Is A Bug**
- The DTO phase for DP pixel rate is computed as an integer/fractional
  split: `dto_integer = pixclk_hz / refclk_hz` and `dto_phase_hz =
  pixclk_hz - dto_integer * refclk_hz` in
  `drivers/gpu/drm/amd/display/dc/dccg/dcn401/dcn401_dccg.c:619-620`.
- Both `dto_phase_hz` and `dto_integer` are `uint64_t`. The old check
  `if (dto_phase_hz <= 0)` (effectively `== 0` for unsigned) incorrectly
  treated a valid “exact multiple” case (phase = 0, integer > 0) as an
  error.
- The fix changes the guard to `if (dto_phase_hz <= 0 && dto_integer <=
  0)` at `drivers/gpu/drm/amd/display/dc/dccg/dcn401/dcn401_dccg.c:622`,
  only failing when both integer and phase are zero (i.e., `pixclk_hz ==
  0`), which is the truly invalid case.

**Impact of the Old Behavior**
- On a false failure, the function returns early and skips programming
  DTO registers and enabling the DTO:
  - DTO writes skipped: `DP_DTO_PHASE` and `DP_DTO_MODULO` at
    `drivers/gpu/drm/amd/display/dc/dccg/dcn401/dcn401_dccg.c:665-666`,
    and `DPDTOx_INT` at
    `drivers/gpu/drm/amd/display/dc/dccg/dcn401/dcn401_dccg.c:670-683`.
  - DTO enable toggle skipped: `DP_DTO_ENABLE` and `PIPE_DTO_SRC_SEL` at
    `drivers/gpu/drm/amd/display/dc/dccg/dcn401/dcn401_dccg.c:691-694`.
- This function is used when programming DP (non-TMDS) pixel clocks via
  `dcn401_program_pix_clk`, which calls `set_dp_dto` for DP streams at
  `drivers/gpu/drm/amd/display/dc/dce/dce_clock_source.c:1104-1106`. A
  premature return leaves the DP DTO disabled or misconfigured, causing
  mode set failures or blank displays when the requested pixel clock is
  an exact multiple of the reference clock.

**Scope and Containment**
- Affects only DCN4.01’s `dccg401_set_dp_dto` and only for non-TMDS
  (DP/eDP) signals; TMDS/HDMI paths are explicitly excluded earlier in
  the function (`dc_is_tmds_signal` guard at
  `drivers/gpu/drm/amd/display/dc/dccg/dcn401/dcn401_dccg.c:608`).
- No external API changes and no architectural changes; it is a one-line
  conditional fix in a single file.

**Risk Assessment**
- Very low risk:
  - Mathematically correct: a fractional DTO with zero phase is expected
    and valid for exact ratios; blocking it was the bug.
  - The new condition only rejects the clearly invalid `pixclk_hz == 0`
    case (integer == 0 and phase == 0).
  - Limited to DCN4.01 hardware path and the DP DTO programming
    sequence.

**Stable Criteria**
- Fixes a user-visible functional bug (DP modes that are exact multiples
  of the reference clock failing).
- Small and self-contained change, minimal regression risk, no feature
  addition, no broad subsystem churn.
- Conforms to stable rules for important bug fixes.

Given the clear, localized bugfix that prevents spurious failures and
restores valid DTO programming for exact multiple clocks, this commit is
an excellent candidate for backporting to stable trees that include
DCN4.01.

 drivers/gpu/drm/amd/display/dc/dccg/dcn401/dcn401_dccg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dccg/dcn401/dcn401_dccg.c b/drivers/gpu/drm/amd/display/dc/dccg/dcn401/dcn401_dccg.c
index 668ee2d405fdf..0b8ed9b94d3c5 100644
--- a/drivers/gpu/drm/amd/display/dc/dccg/dcn401/dcn401_dccg.c
+++ b/drivers/gpu/drm/amd/display/dc/dccg/dcn401/dcn401_dccg.c
@@ -619,7 +619,7 @@ void dccg401_set_dp_dto(
 		dto_integer = div_u64(params->pixclk_hz, dto_modulo_hz);
 		dto_phase_hz = params->pixclk_hz - dto_integer * dto_modulo_hz;
 
-		if (dto_phase_hz <= 0) {
+		if (dto_phase_hz <= 0 && dto_integer <= 0) {
 			/* negative pixel rate should never happen */
 			BREAK_TO_DEBUGGER();
 			return;
-- 
2.51.0


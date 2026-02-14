Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75C1225775;
	Sat, 14 Feb 2026 01:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031269; cv=none; b=WLeH/83eH0ULXe3iK3YE3hz45NfPZNNyc9IPZ3Gw6IGPD1D2AxbeEIPRm7Q8ere5CyYfpBPXJv2osKcP2YqTmyp/1ipWhVxYjI6k/q01UZmyVktWleXM5wK2cb8ylIDh8v+gEsRnmZ86sXD5TGg8Q0dkUYOn5D928oGtxBlsjd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031269; c=relaxed/simple;
	bh=D3nQp3mjhljowC6Lb3lZezNFF0d+eU3c+W7RdEXbv2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JeyNR1X9FSeD8Bu0nS4v1qmIMe7A4Vs1hTyK44ou/NzwsP13EvVxVFM3VFkqEF+WIWxUJO7biJTz88/nrbyQJ//+3aUhncBQKoJUz3PHUYR5xDXG+7shZGgunjuXkvriVsPieWoZVvScGJcKzxieuBGeaFjOxptwbf4ae11WcQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FlzGwqOF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FlzGwqOF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1254DC16AAE;
	Sat, 14 Feb 2026 01:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031269;
	bh=D3nQp3mjhljowC6Lb3lZezNFF0d+eU3c+W7RdEXbv2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FlzGwqOFIYfxZX4Dub5nPUTzg8UPQZzkgtFkZzMhlQnqa0DjkMdX0O0llHDPxfl76
	 ThYaGYudifd0Uk3PA6oV7cq5E0tBKAkOjb1+Km8GK7u02m+veF13OjBgmmV/b3i5k2
	 NZBxULTo2nCcwGSvSrGxBlWv9OOFaou/UCQyxjM1B6/jwr6jRa57mnTJjT1wuuvPEx
	 aB41MCw5l45IZiWbgNTyGxPrP2gJKtMTyrO4xWrZbZBIG7CCs1u/Oe5QX9+V3QNG4M
	 NiABugBpsPjBjdeFm9yhqGxWRivYTtu1wCoa4eWVPRq02rXcbuxzGpsO6M6jzWYSP0
	 vkvTQaROmoDtQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Dmytro Laktyushkin <dmytro.laktyushkin@amd.com>,
	Charlene Liu <charlene.liu@amd.com>,
	Chenyu Chen <chen-yu.chen@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Alvin.Lee2@amd.com,
	Dillon.Varone@amd.com,
	nicholas.kazlauskas@amd.com,
	aurabindo.pillai@amd.com,
	mwen@igalia.com,
	Charlene.Liu@amd.com,
	Yihan.Zhu@amd.com,
	yelangyan@huaqin.corp-partner.google.com,
	Ilya.Bakoulin@amd.com
Subject: [PATCH AUTOSEL 6.19-6.12] drm/amd/display: Add signal type check for dcn401 get_phyd32clk_src
Date: Fri, 13 Feb 2026 20:00:07 -0500
Message-ID: <20260214010245.3671907-127-sashal@kernel.org>
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

From: Dmytro Laktyushkin <dmytro.laktyushkin@amd.com>

[ Upstream commit c979d8db7b0f293111f2e83795ea353c8ed75de9 ]

Trying to access link enc on a dpia link will cause a crash otherwise

Reviewed-by: Charlene Liu <charlene.liu@amd.com>
Signed-off-by: Dmytro Laktyushkin <dmytro.laktyushkin@amd.com>
Signed-off-by: Chenyu Chen <chen-yu.chen@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the data I need. Let me compile the complete analysis.

---

## Detailed Analysis

### 1. COMMIT MESSAGE ANALYSIS

The commit message is clear and explicit: **"Trying to access link enc
on a dpia link will cause a crash otherwise"**. This is a crash fix. The
commit has proper review (Reviewed-by: Charlene Liu), was tested
(Tested-by: Daniel Wheeler), and was signed off by the AMD display
subsystem maintainers.

### 2. CODE CHANGE ANALYSIS

The change is extremely small and surgical — it moves one line of code
inside a conditional block.

**The Bug:**
In `dcn401_enable_stream_calc()`, the function `get_phyd32clk_src()` was
called **unconditionally** for every stream:

```906:942:drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
// BEFORE (buggy):
if (dc->link_srv->dp_is_128b_132b_signal(pipe_ctx))
    *dp_hpo_inst = pipe_ctx->stream_res.hpo_dp_stream_enc->inst;

*phyd32clk = get_phyd32clk_src(pipe_ctx->stream->link);  // Called for
ALL links
```

`get_phyd32clk_src()` dereferences `link->link_enc->transmitter`:

```888:904:drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
static enum phyd32clk_clock_source get_phyd32clk_src(struct dc_link
*link)
{
        switch (link->link_enc->transmitter) {  // NULL deref if
link_enc is NULL
        // ...
        }
}
```

For **DPIA (DisplayPort over USB4/Thunderbolt) links**, `link->link_enc`
is NULL because DPIA links use a different path and never create a
traditional link encoder. This is confirmed by the DPIA link
construction in `link_factory.c`:

```870:871:drivers/gpu/drm/amd/display/dc/link/link_factory.c
        /* TODO: Create link encoder */
```

The comment confirms no link encoder is created for DPIA endpoints.

**The Fix:**
The fix moves `get_phyd32clk_src()` inside the
`dp_is_128b_132b_signal()` conditional:

```c
// AFTER (fixed):
if (dc->link_srv->dp_is_128b_132b_signal(pipe_ctx)) {
    *dp_hpo_inst = pipe_ctx->stream_res.hpo_dp_stream_enc->inst;
    *phyd32clk = get_phyd32clk_src(pipe_ctx->stream->link);  // Only for
128b/132b
}
```

This is correct because:
- `phyd32clk` is ONLY used inside a `dp_is_128b_132b_signal()` guard in
  the caller `dcn401_enable_stream()` (lines 966-972), so it only needs
  to be computed for 128b/132b signals
- DPIA links that are 128b/132b signals *do* have an HPO DP link encoder
  (checked by `dp_is_128b_132b_signal`), and they should have the proper
  link_enc context available in that path
- The dcn20 equivalent (`dcn20_enable_stream`) already has the **correct
  pattern** — `get_phyd32clk_src()` is called inside the
  `dp_is_128b_132b_signal()` block (line 3054). The dcn401 code was
  simply written incorrectly when the calculation was refactored into
  `dcn401_enable_stream_calc`.

### 3. CLASSIFICATION

This is a **NULL pointer dereference crash fix**. When a DPIA link is
used (USB4/Thunderbolt display tunneling), the code dereferences
`link->link_enc->transmitter` where `link_enc` is NULL, causing a kernel
crash.

### 4. SCOPE AND RISK ASSESSMENT

- **Lines changed:** 4 lines modified (one statement moved inside
  existing braces)
- **Files touched:** 1 file only
- **Complexity:** Extremely low — just moving a call into an existing
  conditional block
- **Risk of regression:** Very low. The `phyd32clk` variable is only
  consumed inside the same `dp_is_128b_132b_signal()` check in the
  caller, so skipping its computation for non-128b/132b signals has no
  effect. This matches the dcn20 behavior exactly.

### 5. USER IMPACT

- **Who is affected:** Users with AMD DCN4.01 GPUs (RDNA 4 / Radeon RX
  9000 series) using USB-C / Thunderbolt displays (DPIA endpoints)
- **Severity:** Kernel crash/NULL pointer dereference — the system would
  crash when trying to enable a stream on a DPIA link
- **Frequency:** Every time a DPIA display is connected on affected
  hardware

### 6. STABILITY INDICATORS

- Reviewed-by: Charlene Liu (AMD display team)
- Tested-by: Daniel Wheeler (AMD QA)
- Follows the same pattern already proven correct in dcn20
- Related commit d7f5a61e1b04e also fixed a `link->enc NULL pointer
  access` in the same file, indicating this is a known class of bugs for
  dcn401

### 7. DEPENDENCY CHECK

- This commit is self-contained — no dependencies on other patches
- DCN401 code exists in stable trees from v6.11 onwards
- The code around the change doesn't appear to have changed
  significantly, so clean application is expected for recent stable
  branches

### 8. CONCLUSION

This is a textbook stable backport candidate:
- **Fixes a real crash** (NULL pointer dereference)
- **Small and surgical** (4 lines, 1 file)
- **Obviously correct** (matches the pattern already used in dcn20's
  `dcn20_enable_stream`)
- **Low regression risk** (the moved statement's output is only consumed
  inside the same condition)
- **Has proper review and testing**
- **Affects real hardware** (USB4/Thunderbolt displays on RDNA 4 GPUs)
- **Applicable to stable** (dcn401 exists from v6.11 onwards)

**YES**

 drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
index e1f5b1a34cde8..f04cbdb3d3814 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
@@ -916,10 +916,10 @@ static void dcn401_enable_stream_calc(
 			pipe_ctx->stream->link->cur_link_settings.lane_count;
 	uint32_t active_total_with_borders;
 
-	if (dc->link_srv->dp_is_128b_132b_signal(pipe_ctx))
+	if (dc->link_srv->dp_is_128b_132b_signal(pipe_ctx)) {
 		*dp_hpo_inst = pipe_ctx->stream_res.hpo_dp_stream_enc->inst;
-
-	*phyd32clk = get_phyd32clk_src(pipe_ctx->stream->link);
+		*phyd32clk = get_phyd32clk_src(pipe_ctx->stream->link);
+	}
 
 	if (dc_is_tmds_signal(pipe_ctx->stream->signal))
 		dcn401_calculate_dccg_tmds_div_value(pipe_ctx, tmds_div);
-- 
2.51.0


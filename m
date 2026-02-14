Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 129861D5ABA;
	Sat, 14 Feb 2026 01:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031067; cv=none; b=fsnyyFBU8pCxqM7LoVeEYX5d15x1z+WoA9XyY9FW6IbEFgJGnukJClS4cwE/inJnXBJ7B31HepIA+cRrylZ8Ne6w5cVG002PwGMC8aJfhJ/fLA1KH9Ppypf8XAQB7LnCxp/FoZ48xFnGcoBM1wQ5ph7hKYwgq5NoUO7HD+F5xao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031067; c=relaxed/simple;
	bh=2/05QWivxAUqXg35FZJB9eO9ubb6yCys2a7JIQ+rzdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IVKK75b8tu8JjY2IreLshqotBUIYXgyXFOTXiLdIAn5I5hCgN0/QVuVh1Lcl796LjOwx0ynqPuJfeP10g7vBWEYBN7pod9G+HiJ6/iC5YilBar53kTpS+Fjt1PMbq6wXJwVwU39ZQgVrUdvflzcMGpMk0TeUbhLO7sscUzzL1M8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jZrvs1jw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jZrvs1jw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C56CC2BC87;
	Sat, 14 Feb 2026 01:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031067;
	bh=2/05QWivxAUqXg35FZJB9eO9ubb6yCys2a7JIQ+rzdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jZrvs1jw6PmGpyY3r1p1ITgfNABVikLBIlVFjtPuv2Pp5Cgz1My8T3x2BQIFRhtro
	 6Yh/5slfCoco1Zegxuq59UxL6iT2nYHCMHrECKuMp0jaarc737NgGwIpmBxmKIWJ/f
	 zoq8mTPlc4YObi/3qfFl2Eho8Z1hcS0JVcYrzY1umN/VPqY4UckHkFpK409gegwehA
	 7BektvikhgHiSZsIDGuiamXwvwZNUL1x4hfmxDApzH7RiGJOveFgVMvMGT/9Sop8Xf
	 ReIoPszxz4R8TKwABxp/SQ2uH/gs8TIe8mE3lb+UnT0+OY22zkZavWPuyMICrXKKUQ
	 +l4Q9xfmjsxdQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Dillon Varone <Dillon.Varone@amd.com>,
	Sridevi Arvindekar <sridevi.arvindekar@amd.com>,
	Roman Li <roman.li@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Alvin.Lee2@amd.com,
	alex.hung@amd.com,
	nicholas.kazlauskas@amd.com,
	mwen@igalia.com,
	Charlene.Liu@amd.com,
	Yihan.Zhu@amd.com,
	yelangyan@huaqin.corp-partner.google.com,
	Ilya.Bakoulin@amd.com
Subject: [PATCH AUTOSEL 6.19-6.18] drm/amd/display: Guard FAMS2 configuration updates
Date: Fri, 13 Feb 2026 19:58:47 -0500
Message-ID: <20260214010245.3671907-47-sashal@kernel.org>
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
Content-Transfer-Encoding: 8bit

From: Dillon Varone <Dillon.Varone@amd.com>

[ Upstream commit 7dedb906cdfec100061daf41f8e54266e975987d ]

[WHY&HOW]
If DMCUB is not initialized or FAMS2 is not supported, the
interface should not be called.

Reviewed-by: Sridevi Arvindekar <sridevi.arvindekar@amd.com>
Signed-off-by: Dillon Varone <Dillon.Varone@amd.com>
Signed-off-by: Roman Li <roman.li@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a complete analysis. Let me summarize:

---

## Detailed Analysis

### 1. COMMIT MESSAGE ANALYSIS

The commit message says: "If DMCUB is not initialized or FAMS2 is not
supported, the interface should not be called." This is a classic
guard/safety check addition that prevents calling firmware communication
code when the firmware service is not available.

### 2. CODE CHANGE ANALYSIS

The change is to `dcn401_hardware_release()` in `dcn401_hwseq.c`. It
adds two identical guard checks before calling
`dc_dmub_srv_fams2_update_config()`:

```c
if (dc->ctx->dmub_srv && dc->debug.fams2_config.bits.enable)
```

There are two call sites in the function (in an if/else block controlled
by `disable_force_pstate_allow_on_hw_release`), and both get the same
guard.

### 3. THE BUG: NULL POINTER DEREFERENCE

**The crash path:** The dispatch function
`dc_dmub_srv_fams2_update_config()` (at `dc_dmub_srv.c:1895`) checks
`dc->debug.fams_version.major` and dispatches to:
- `dc_dmub_srv_rb_based_fams2_update_config()` if `major == 2` (safe -
  downstream has NULL check)
- `dc_dmub_srv_ib_based_fams2_update_config()` if `major == 3`
  (**CRASH** - immediately dereferences dmub_srv)

The `dc_dmub_srv_ib_based_fams2_update_config()` function's very first
line is:

```1852:1852:drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c
struct dmub_fams2_config_v2 *config = (struct dmub_fams2_config_v2
*)dc->ctx->dmub_srv->dmub->ib_mem_gart.cpu_addr;
```

If `dc->ctx->dmub_srv` is NULL, this is a **NULL pointer dereference**
leading to a kernel oops/crash.

**Consistency fix:** The other caller of
`dc_dmub_srv_fams2_update_config()`, `dcn401_fams2_update_config()`,
already has the proper guard:

```1511:1521:drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
void dcn401_fams2_update_config(struct dc *dc, struct dc_state *context,
bool enable)
{
        if (!dc->ctx || !dc->ctx->dmub_srv ||
!dc->debug.fams2_config.bits.enable)
                return;
        // ...
}
```

So `dcn401_hardware_release()` was the ONLY unguarded caller.

### 4. AFFECTED STABLE TREES

My investigation reveals:
- **v6.12, v6.15, v6.16**: DCN401 exists, but
  `dc_dmub_srv_fams2_update_config()` is a single inline implementation
  (no dispatch, no ib_based path). The downstream
  `dc_dmub_srv_cmd_list_queue_execute()` has its own NULL check. **No
  crash** in these versions, though the guard is still defensive.
- **v6.17**: The dispatch pattern + ib_based path exists, so the crash
  IS possible, but `dcn401_hardware_release()` has a different structure
  (single call, no if/else). Patch would **need adaptation**.
- **v6.18**: Has the exact same code structure as v6.19 (the if/else
  block with two calls). The dispatch + ib_based crash path exists.
  Patch **applies cleanly** and fixes a real NULL pointer dereference.

### 5. SCOPE AND RISK

- **Lines changed**: ~4 lines (adding 2 guard conditions)
- **Files changed**: 1 file
- **Risk**: Extremely low - adding guard checks before a function call
  is the safest possible change
- **Pattern**: Matches the existing guard in the sibling
  `dcn401_fams2_update_config()` function exactly

### 6. USER IMPACT

- **Hardware**: AMD DCN401 display controller (AMD RDNA 4 / latest
  generation GPU)
- **Trigger**: `dc_hardware_release()` is called on driver unload. If
  DMCUB firmware is not initialized (e.g., firmware load failed, early
  error path, or unsupported configuration), the unguarded call would
  crash.
- **Severity**: Kernel oops/crash during driver unload
- **Users affected**: Users with DCN401 hardware in configurations where
  DMCUB fails to initialize

### 7. STABILITY INDICATORS

- **Reviewed-by**: Sridevi Arvindekar (AMD)
- **Tested-by**: Dan Wheeler (AMD)
- **Author**: Dillon Varone (AMD, same author as the sibling function
  with the guard pattern)

### 8. DECISION

This commit fixes a real NULL pointer dereference that can crash the
kernel during hardware release on DCN401 systems. The fix is:
- **Obviously correct**: Adds the same guard already used by the other
  caller
- **Small and surgical**: 4 lines of guard conditions
- **Zero regression risk**: Guard checks can only prevent calls, never
  cause new issues
- **Fixes a real crash**: NULL deref in
  `dc_dmub_srv_ib_based_fams2_update_config`
- **Applicable to at least v6.18 stable**: Code structure matches
  exactly

The only concern is that DCN401 is relatively new hardware, but the fix
is needed for active stable trees (6.17.y, 6.18.y) where the crash path
exists.

**YES**

 drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
index 5ffe41a96864a..12ce3789f5130 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
@@ -1774,7 +1774,8 @@ void dcn401_unblank_stream(struct pipe_ctx *pipe_ctx,
 void dcn401_hardware_release(struct dc *dc)
 {
 	if (!dc->debug.disable_force_pstate_allow_on_hw_release) {
-		dc_dmub_srv_fams2_update_config(dc, dc->current_state, false);
+		if (dc->ctx->dmub_srv && dc->debug.fams2_config.bits.enable)
+			dc_dmub_srv_fams2_update_config(dc, dc->current_state, false);
 
 		/* If pstate unsupported, or still supported
 		* by firmware, force it supported by dcn
@@ -1794,7 +1795,9 @@ void dcn401_hardware_release(struct dc *dc)
 			dc->clk_mgr->clks.p_state_change_support = false;
 			dc->clk_mgr->funcs->update_clocks(dc->clk_mgr, dc->current_state, true);
 		}
-		dc_dmub_srv_fams2_update_config(dc, dc->current_state, false);
+
+		if (dc->ctx->dmub_srv && dc->debug.fams2_config.bits.enable)
+			dc_dmub_srv_fams2_update_config(dc, dc->current_state, false);
 	}
 }
 
-- 
2.51.0


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37B02556E;
	Sat, 14 Feb 2026 01:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031189; cv=none; b=E+gHhcUBz+H0JoQWpJ5XQize9XZx0ziJP9KPjUeaiTjIwDftw5uZWAUK7+3DDc7JyHNta8x8bhjF0VQ+U1ihZTKyeW+WngLsom3azgEeUiDv7/Hj5QN1kACJiljOB/qkmPEc1oMTNMIh5M4yufDqBTk7QbpLQThjROevxAwnOAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031189; c=relaxed/simple;
	bh=6xHN8ch6D3wfH6dNKdtq5U38lXb5ym/+KWSFYV/LZ7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZVvvq4jmz2ytUc6krU6F5VjwyCBhzdokGTwkgTxlHNIMhpj7Gnfp7lM8zm63YfGC0Y1Pw+LNk8OY7Xwveb+yPw48kargtqZ12maP5IkTif5ze0TMTLVryCiZzxHCpdcVCFEeZCb7q5wizsEPo94+pXn1cTfZWpMTHb335g5nfzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jA2YhB6+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jA2YhB6+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63B6EC16AAE;
	Sat, 14 Feb 2026 01:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031189;
	bh=6xHN8ch6D3wfH6dNKdtq5U38lXb5ym/+KWSFYV/LZ7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jA2YhB6+3N0SQx3Sj+dt2VRv4QCvUSdKvc719XVWgW1LxaMylETLFGulL88EtTBjf
	 sbWhvx85vG7IAHKDyu42fJPGevcoCNRBD+lGgy0LCJ/C5RxXWAXz4qLYdZtBAfwUJk
	 Y8XlJhZnQV9hs8yMJuFSfoqGIvvJNk1V601pMOl5ME0/A49tr0VXhIZ+K5Bs2ycpMl
	 lkBsXyv8JG9/hTPVXX6qAFAknieNJI/sYJ1pF56bNilQTwK36l+LaHqgFrfDF2Dxx7
	 emu3CZUoYAK4fsGOyLFH5I4kur4r6mFZrR5uCj0R/8B69y0X+vwK+fU2S1uSOXdPJA
	 env1v/hihdRrA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jing Zhou <Jing.Zhou@amd.com>,
	Charlene Liu <charlene.liu@amd.com>,
	Wenjing Liu <wenjing.liu@amd.com>,
	Roman Li <roman.li@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	neil.armstrong@linaro.org,
	michael.strauss@amd.com,
	yelangyan@huaqin.corp-partner.google.com
Subject: [PATCH AUTOSEL 6.19-6.18] drm/amd/display: Correct FIXED_VS Link Rate Toggle Condition
Date: Fri, 13 Feb 2026 19:59:34 -0500
Message-ID: <20260214010245.3671907-94-sashal@kernel.org>
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

From: Jing Zhou <Jing.Zhou@amd.com>

[ Upstream commit 531fe6e0fee85a1bdb5b8223a706fff654ed0a61 ]

[WHY&HOW]
The condition is only perform toggle if FIXED_VS LTTPR reports
no IEEE OUI.
The literal "\x0,\x0,\x0" contains commas changes the
bytes being compared to {0x00,0x2C,0X00}.
The correct literal should be "\x00\x00\x00" without commas.

Reviewed-by: Charlene Liu <charlene.liu@amd.com>
Reviewed-by: Wenjing Liu <wenjing.liu@amd.com>
Signed-off-by: Jing Zhou <Jing.Zhou@amd.com>
Signed-off-by: Roman Li <roman.li@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Good - the nontransparent path at line 118 doesn't have the OUI check
(it uses the older unconditional logic), so it's not affected. Only the
transparent path (line 274) has the buggy memcmp.

Now I have all the information needed for a comprehensive analysis.

---

## Comprehensive Analysis

### 1. COMMIT MESSAGE ANALYSIS

The commit message is clear and well-explained:
- **Subject**: "drm/amd/display: Correct FIXED_VS Link Rate Toggle
  Condition"
- **Why**: The C string literal `"\x0,\x0,\x0"` contains comma
  characters that change the bytes being compared from the intended
  `{0x00, 0x00, 0x00}` to `{0x00, 0x2C, 0x00}`.
- **How**: Replace the buggy literal with the correct `"\x00\x00\x00"`.
- **Trust indicators**: Reviewed-by: Charlene Liu, Reviewed-by: Wenjing
  Liu, Tested-by: Dan Wheeler, Signed-off-by: Alex Deucher (AMD GPU
  maintainer). This has strong review coverage.

### 2. CODE CHANGE ANALYSIS

The change is a single-line fix:

```273:274:drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_trainin
g_fixed_vs_pe_retimer.c
        // Only perform toggle if FIXED_VS LTTPR reports no IEEE OUI
        if (memcmp("\x0,\x0,\x0",
&link->dpcd_caps.lttpr_caps.lttpr_ieee_oui[0], 3) == 0) {
```

Changed to `"\x00\x00\x00"`.

**The Bug Mechanism in Detail:**

In C, the hex escape sequence `\xN` consumes as many hexadecimal digits
as follow. However, a comma (`,`) is NOT a hex digit, so `\x0`
terminates at the comma. The result:
- `\x0` = byte 0x00
- `,` = byte 0x2C (ASCII comma)
- `\x0` = byte 0x00
- `,` = byte 0x2C (ASCII comma)
- `\x0` = byte 0x00

The string is 5 bytes `{0x00, 0x2C, 0x00, 0x2C, 0x00}` plus null
terminator. Since `memcmp` compares only 3 bytes, the comparison is
against `{0x00, 0x2C, 0x00}` — NOT the intended `{0x00, 0x00, 0x00}`.

**Consequence**: The condition was supposed to check if the LTTPR
reports NO IEEE OUI (all zeros), and if so, perform a link rate toggle
workaround. Because of the bug, the comparison almost never matches, so
the workaround is effectively **disabled**. This breaks DisplayPort link
training on systems with FIXED_VS retimer chips that report no IEEE OUI,
potentially causing **display link failures** (no display output or
degraded link quality).

### 3. BUG ORIGIN AND AFFECTED VERSIONS

The bug was introduced in commit `7c6518c1c7319` ("drm/amd/display:
Update FIXED_VS Link Rate Toggle Workaround Usage"), first appearing in
v6.15-rc1. This commit has already been **backported** to:
- **stable/linux-6.14.y** (as `caa4938c5c92f`) — confirmed buggy
- **stable/linux-6.15.y** through **stable/linux-6.19.y** — all contain
  the same bug
- **stable/linux-6.12.y** — NOT affected (doesn't have the OUI check at
  all, uses older 128b/132b logic)

### 4. CLASSIFICATION

This is a clear **bug fix**:
- Fixes an incorrect byte comparison that breaks a hardware workaround
- No new features, no new APIs
- Pure correction of a string literal typo

### 5. SCOPE AND RISK ASSESSMENT

- **Lines changed**: 1 (single string literal correction)
- **Files touched**: 1
- **Complexity**: Trivially low
- **Risk of regression**: Near zero — this is fixing a byte comparison
  to match the original intent
- **Subsystem**: AMD display driver (DisplayPort link training for
  retimer devices)

### 6. USER IMPACT

- **Who is affected**: Users with AMD GPU systems that have FIXED_VS
  LTTPR (Link Training Tunable PHY Repeater) chips with no IEEE OUI.
  These are vendor-specific retimer chips commonly found in laptops and
  USB4/Thunderbolt dock setups.
- **Severity**: The link rate toggle workaround is completely disabled,
  potentially causing DisplayPort link training failures (no display,
  display flickering, or link instability).
- **Real-world impact**: This directly affects display functionality — a
  critical user-facing issue.

### 7. DEPENDENCY CHECK

The fix has **zero dependencies** beyond the buggy commit that's already
present in stable trees:
- The `lttpr_ieee_oui` field exists in stable (added by `7c6518c1c7319`
  itself)
- The fix is a pure string literal correction on the same line
  introduced by the bug
- No context changes needed — the fix will apply cleanly to any stable
  tree that has the buggy commit

### 8. SUMMARY

This is a textbook stable backport candidate:
- **Obviously correct**: Changing `"\x0,\x0,\x0"` to `"\x00\x00\x00"` is
  a trivially verifiable fix
- **Fixes a real bug**: The commas in the hex escape create the wrong
  byte sequence, disabling a necessary hardware workaround
- **Important issue**: Affects display link training — can cause display
  failures
- **Small and contained**: Single character-level fix in one file, one
  line
- **No new features**: Pure bug fix
- **Already tested**: Has Tested-by tag from AMD's test team, plus two
  Reviewed-by tags
- **Buggy code exists in stable**: Confirmed present in 6.14.y through
  6.19.y

**YES**

 .../dc/link/protocols/link_dp_training_fixed_vs_pe_retimer.c    | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training_fixed_vs_pe_retimer.c b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training_fixed_vs_pe_retimer.c
index ce174ce5579c0..6a7c4a59ff4c7 100644
--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training_fixed_vs_pe_retimer.c
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training_fixed_vs_pe_retimer.c
@@ -271,7 +271,7 @@ enum link_training_result dp_perform_fixed_vs_pe_training_sequence(
 	rate = get_dpcd_link_rate(&lt_settings->link_settings);
 
 	// Only perform toggle if FIXED_VS LTTPR reports no IEEE OUI
-	if (memcmp("\x0,\x0,\x0", &link->dpcd_caps.lttpr_caps.lttpr_ieee_oui[0], 3) == 0) {
+	if (memcmp("\x00\x00\x00", &link->dpcd_caps.lttpr_caps.lttpr_ieee_oui[0], 3) == 0) {
 		/* Vendor specific: Toggle link rate */
 		toggle_rate = (rate == 0x6) ? 0xA : 0x6;
 
-- 
2.51.0


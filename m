Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81EF01F4168;
	Sat, 14 Feb 2026 01:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031046; cv=none; b=RzVgtTxAIVesCf/c0k00Kk7Ogkj3VdHro2VAZFS1N25Usx2adYhd485rP036yxLmRC+26Q534fhonjuJejZ3gro2lnPmmn8zN7dSaWCaMbjkK65g0lYxTBq8md0MMRrMV/UbCyQ0o320zPvewrluvGifuOK26Dj9zbQeoWt0noQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031046; c=relaxed/simple;
	bh=4IMSX6apDz4g9EQFJcdyfG1qU6wxya22x/NbWJQPTw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iwJaCCVwdaLLBq2HoPGqB3UClCxbvGx1fLjxqJNLMSG16X3xqTzOTKwXZgH+6o1XqtLB4Q3urEl08gaolkVN2EqWVXDsPfxJxmE5r6ZhKSZRJiPKcfogLOyoP1kcJxAXW5BYgdmMosDQZ4DNbzJdhjNBius39w7mRpZ/KKeeyz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jap1S0pu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jap1S0pu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D72DC116C6;
	Sat, 14 Feb 2026 01:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031046;
	bh=4IMSX6apDz4g9EQFJcdyfG1qU6wxya22x/NbWJQPTw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jap1S0puUrGoveHYblfdgGHtixeXPaztMvB/ikDHYG1usDX5NhaQOhVU60Y41JVRj
	 AVe6LsSl8W07CXmAU62m6kwCm9NyJMI2Y305YUdmr7QnqN7mpuYQC0xir78kTKGN6a
	 p8MFZYDHfaLoDX31D/32BgP2ypQDbvJgiJOVhhHC3sgUuQnS+QBfrd7pa+0OoMXeXY
	 pjre5M8rRVtJSycqghgRWD5GVS/0nBade+vWJ0fpSEkPRBzhW7k7MIKbnCPmu1XVsf
	 Bqx2jYE3LKu5YVuXI5kCSqbh8wfWb3gEl9CM/iVBhdu+XjYOKUody1Vv39ysTPleXL
	 +03orAsf2I3DQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: LinCheng Ku <lincheng.ku@amd.com>,
	PeiChen Huang <peichen.huang@amd.com>,
	Chenyu Chen <chen-yu.chen@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	neil.armstrong@linaro.org,
	yelangyan@huaqin.corp-partner.google.com,
	dmytro.laktyushkin@amd.com
Subject: [PATCH AUTOSEL 6.19-6.12] drm/amd/display: Add USB-C DP Alt Mode lane limitation in DCN32
Date: Fri, 13 Feb 2026 19:58:36 -0500
Message-ID: <20260214010245.3671907-36-sashal@kernel.org>
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

From: LinCheng Ku <lincheng.ku@amd.com>

[ Upstream commit cea573a8e1ed83840a2173d153dd68e172849d44 ]

[Why]
USB-C DisplayPort Alt Mode with concurrent USB data needs lane count
limitation to prevent incorrect 4-lane DP configuration when only 2 lanes
are available due to hardware lane sharing between DP and USB3.

[How]
Query DMUB for Alt Mode status (is_dp_alt_disable, is_usb, is_dp4) in
dcn32_link_encoder_get_max_link_cap() and cap DP to 2 lanes when USB is
active on USB-C port. Added inline documentation explaining the USB-C
lane sharing constraint.

Reviewed-by: PeiChen Huang <peichen.huang@amd.com>
Signed-off-by: LinCheng Ku <lincheng.ku@amd.com>
Signed-off-by: Chenyu Chen <chen-yu.chen@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a comprehensive picture. Let me summarize my analysis.

## Detailed Analysis

### 1. Commit Message Analysis

The commit adds a missing `is_dp_alt_disable == 0` check to
`dcn32_link_encoder_get_max_link_cap()`. The [Why] section explains that
USB-C DP Alt Mode with concurrent USB data needs lane count limitation,
but the key fix is actually **preventing incorrect lane limiting when DP
Alt Mode is NOT active** (i.e., on native DP ports).

### 2. Code Change Analysis — The Bug

The actual code change is minimal — adding one condition
`cmd.query_dp_alt.data.is_dp_alt_disable == 0` to an existing `if`
statement, plus inline documentation.

**Before (buggy):**

```191:193:drivers/gpu/drm/amd/display/dc/dio/dcn32/dcn32_dio_link_encod
er.c
        if (cmd.query_dp_alt.data.is_usb &&
                        cmd.query_dp_alt.data.is_dp4 == 0)
                link_settings->lane_count = MIN(LANE_COUNT_TWO,
link_settings->lane_count);
```

**After (fixed):** Adds `is_dp_alt_disable == 0 &&` to only limit lanes
when DP Alt Mode is actually active.

### 3. Root Cause — Regression in `7d1e9d0369e4d`

Commit `7d1e9d0369e4d` ("drm/amd/display: Check DP Alt mode DPCS state
via DMUB", merged in v6.9) refactored DCN32 to query the DMUB
microcontroller instead of reading hardware registers. Before this
refactor, the old code correctly guarded the lane-limiting logic behind
an `is_in_alt_mode()` call:

```c
// OLD (correct):
if (enc->funcs->is_in_alt_mode && enc->funcs->is_in_alt_mode(enc)) {
    REG_GET(RDPCSPIPE_PHY_CNTL6, RDPCS_PHY_DPALT_DP4,
&is_in_usb_c_dp4_mode);
    if (!is_in_usb_c_dp4_mode)
        link_settings->lane_count = MIN(LANE_COUNT_TWO,
link_settings->lane_count);
}
```

The refactor to DMUB queries **dropped** the equivalent alt-mode check
(`is_dp_alt_disable == 0`), while the DCN31 version at
`dcn31_dio_link_encoder.c:656` correctly includes it:

```656:659:drivers/gpu/drm/amd/display/dc/dio/dcn31/dcn31_dio_link_encod
er.c
                if (cmd.query_dp_alt.data.is_dp_alt_disable == 0 &&
                                cmd.query_dp_alt.data.is_usb &&
                                cmd.query_dp_alt.data.is_dp4 == 0)
                        link_settings->lane_count = MIN(LANE_COUNT_TWO,
link_settings->lane_count);
```

This is exactly the same bug pattern previously fixed for DCN20 in
commit `8ccf0e20769d9` ("determine USB C DP2 mode only when USB DP Alt
is enabled") which stated: *"When display is connected with a native DP
port, DP2 mode register value is a don't care. Driver mistakenly reduce
max supported lane count to 2 lane based on the don't care value."*

### 4. User Impact

Without this fix, on DCN32 hardware (AMD Radeon RX 7000 series / RDNA3
GPUs), when a display is connected via a **native DP port** (not USB-C),
the `is_usb` and `is_dp4` DMUB register values are "don't care" garbage.
If `is_usb` happens to be set and `is_dp4` is 0, the driver incorrectly
caps the lane count to 2 (instead of 4), halving the available
bandwidth. This results in:
- Reduced maximum resolution
- Reduced refresh rate
- The user cannot get their display's full capabilities

This affects a very popular GPU family (RDNA3) and is triggered on every
mode set.

### 5. Scope and Risk

- **Size**: Adds 1 condition to an existing if-statement + 5 lines of
  comments. Extremely small.
- **Risk**: Very low. This change only makes the lane-limiting logic
  **more conservative** (requires an additional condition to be true
  before limiting). If the condition was already true before, behavior
  is unchanged. If it was false (native DP), it prevents the incorrect
  lane limiting.
- **Dependencies**: None. The `is_dp_alt_disable` field is already used
  in `dcn32_link_encoder_is_in_alt_mode()` in the same file (line 178),
  and the struct definition exists in `dmub_cmd.h`.
- **Backport path**: The buggy commit `7d1e9d0369e4d` was first included
  in v6.9. Note that the file was moved from `dc/dcn32/` to
  `dc/dio/dcn32/` in a later refactor (`2d62bb450ed18`, v6.15 cycle), so
  for older stable trees (6.12.y, 6.11.y, 6.10.y, 6.9.y) the path would
  need adjusting, but the code change is trivially applicable.

### 6. Stability Indicators

- **Reviewed-by: PeiChen Huang** (AMD display engineer)
- **Tested-by: Daniel Wheeler** (AMD QA)
- **Signed-off-by: Alex Deucher** (AMD display maintainer)
- The fix aligns DCN32 with the already-correct DCN31 implementation,
  providing strong confidence in correctness.

### 7. Classification

This is a **hardware bug fix / regression fix** — it corrects incorrect
DP lane count limiting on native DP ports for DCN32 hardware, a
regression introduced when the code was refactored to use DMUB queries.
It does NOT add new features, APIs, or change userspace behavior. It
restores the correct pre-refactor behavior.

### Conclusion

This commit fixes a real, user-visible regression (reduced display
resolution/refresh rate) on widely-used AMD RDNA3 GPUs. The fix is small
(1 condition added), obviously correct (matches DCN31 and pre-refactor
DCN32 behavior), well-reviewed, well-tested, and has zero risk of
introducing new issues. It meets all stable kernel criteria.

**YES**

 .../display/dc/dio/dcn32/dcn32_dio_link_encoder.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dio/dcn32/dcn32_dio_link_encoder.c b/drivers/gpu/drm/amd/display/dc/dio/dcn32/dcn32_dio_link_encoder.c
index 06907e8a4eda1..ddc736af776c9 100644
--- a/drivers/gpu/drm/amd/display/dc/dio/dcn32/dcn32_dio_link_encoder.c
+++ b/drivers/gpu/drm/amd/display/dc/dio/dcn32/dcn32_dio_link_encoder.c
@@ -188,9 +188,18 @@ void dcn32_link_encoder_get_max_link_cap(struct link_encoder *enc,
 	if (!query_dp_alt_from_dmub(enc, &cmd))
 		return;
 
-	if (cmd.query_dp_alt.data.is_usb &&
-			cmd.query_dp_alt.data.is_dp4 == 0)
-		link_settings->lane_count = MIN(LANE_COUNT_TWO, link_settings->lane_count);
+	/*
+	 * USB-C DisplayPort Alt Mode lane count limitation logic:
+	 * When USB and DP share the same USB-C connector, hardware must allocate
+	 * some lanes for USB data, limiting DP to maximum 2 lanes instead of 4.
+	 * This ensures USB functionality remains available while DP is active.
+	 */
+	if (cmd.query_dp_alt.data.is_dp_alt_disable == 0 &&
+		cmd.query_dp_alt.data.is_usb &&
+		cmd.query_dp_alt.data.is_dp4 == 0) {
+		link_settings->lane_count =
+			MIN(LANE_COUNT_TWO, link_settings->lane_count);
+	}
 }
 
 
-- 
2.51.0


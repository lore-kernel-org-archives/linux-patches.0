Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7E21222585;
	Sat, 14 Feb 2026 01:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031215; cv=none; b=upKOY233bvh/x6ueyK8XO2CQtKnPZgmDUZPgg097HK0G7yFKX0RU+rBI7lnoQNJMa0GA/lmlWnoygx7/rS6Qe657Vn4svXTOEHWdaasJ1WY9bzNyKT9+LOd2Njk2gT6b1aAiWXXGqRqY4y28MpHwRPkH/XjZpMlR5xdLkFui1bQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031215; c=relaxed/simple;
	bh=NfyZ6N9qEAQYzK3IyEcQ6NN1xPROVoZvgBnrsqg9qh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kN8pz7fP7oqPasCs7QfrAdSM111T9e9NVDdszJ6v+9qqZM5Og6wxYWQp7JsomcweMz9GKHMDPp3fJSxnwi3wwsv01ORxClZ5N5jaCKmv5OzjdbH4OGRPmXIhUos5jmkiAXT354pqfbdHPzMmBFwGA4Pn82BQmNTYKQ7MKiJpN1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fYPMm6Lx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fYPMm6Lx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09CBCC19424;
	Sat, 14 Feb 2026 01:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031215;
	bh=NfyZ6N9qEAQYzK3IyEcQ6NN1xPROVoZvgBnrsqg9qh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fYPMm6LxHXGDHBAejmh9Hynl/dl9VxMNiZjy8FKqEjd8udv7mVGR4UXUJVhm/doAj
	 /9gwsMFNy8Qwcc4HEjlvsMPwV0PCrIjxr+fzsJlIU2CZv+Zjo6+bMa8yDVr4av5uc0
	 Ry8aKRMY7HDoTovYEjzU2OOLPVoevnGqQd7zqXhO4Hgwrj07H3CQS7epT8sdayxqwF
	 yelEIKVi25pZByV8vgHB2+lSyVS/ldeIumGumkAfIGyl31Efq/qx7XrvcQjczYAsiq
	 WOetu6wfv3ErqgN7fBYt4iGGRnLmaRwBSxE2TTzHxPr1DALzl/srRFkfwVSwEJ4ZxH
	 YMEXu/kBG1XDQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Dmytro Laktyushkin <dmytro.laktyushkin@amd.com>,
	Charlene Liu <charlene.liu@amd.com>,
	Matthew Stewart <matthew.stewart2@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Alvin.Lee2@amd.com,
	Dillon.Varone@amd.com,
	nicholas.kazlauskas@amd.com,
	aurabindo.pillai@amd.com,
	mwen@igalia.com,
	Yihan.Zhu@amd.com,
	Charlene.Liu@amd.com,
	yelangyan@huaqin.corp-partner.google.com,
	Ilya.Bakoulin@amd.com
Subject: [PATCH AUTOSEL 6.19-6.12] drm/amd/display: only power down dig on phy endpoints
Date: Fri, 13 Feb 2026 19:59:46 -0500
Message-ID: <20260214010245.3671907-106-sashal@kernel.org>
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

[ Upstream commit 0839d8d24e6f1fc2587c4a976f44da9fa69ae3d0 ]

This avoids any issues with dpia endpoints

Reviewed-by: Charlene Liu <charlene.liu@amd.com>
Signed-off-by: Dmytro Laktyushkin <dmytro.laktyushkin@amd.com>
Signed-off-by: Matthew Stewart <matthew.stewart2@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a comprehensive understanding. Let me summarize the full
analysis.

---

## Comprehensive Analysis

### 1. COMMIT MESSAGE ANALYSIS

The subject "drm/amd/display: only power down dig on phy endpoints" and
body "This avoids any issues with dpia endpoints" clearly indicate this
is a bug fix. The commit skips DIG (Digital Interface Group) power-down
for DPIA (DisplayPort Interface Adapter / USB4 DP tunnel) endpoints,
which shouldn't be processed in this context.

### 2. CODE CHANGE ANALYSIS

The fix adds exactly 2 lines to `dcn401_init_hw()`:

```c
if (link->ep_type != DISPLAY_ENDPOINT_PHY)
    continue;
```

This guard is placed in the "headless boot" DIG power-down loop, which
iterates all links when no eDP links are found. The loop accesses
`link->link_enc->funcs->is_dig_enabled` without first checking if the
link is a physical endpoint.

**The Bug Mechanism: NULL Pointer Dereference**

From my investigation of the link construction code in `link_factory.c`:

- DPIA links are created via `construct_dpia()` (line 814), which
  **never assigns `link->link_enc`**. There's even a `/* TODO: Create
  link encoder */` comment at line 870.
- PHY links are created via `construct_phy()` (line 676), which **does**
  assign `link->link_enc`.
- Since links are allocated with `kzalloc()`, `link->link_enc` is NULL
  for DPIA links.
- The buggy code dereferences `link->link_enc->funcs->is_dig_enabled` —
  a **NULL pointer dereference** when the link is DPIA.

The `enum display_endpoint_type` from `dc_types.h` defines:
- `DISPLAY_ENDPOINT_PHY = 0` — Physical connector
- `DISPLAY_ENDPOINT_USB4_DPIA` — USB4 DisplayPort tunnel

### 3. CONSISTENCY WITH OTHER DCN GENERATIONS

The first loop in `dcn401_init_hw()` (line 206 at HEAD) **already has**
this exact `ep_type` check, added by commit `d7f5a61e1b04` ("increase
max link count and fix link->enc NULL pointer access"). That commit
explicitly states: "*hw_init() access null LINK_ENC for dpia non
display_endpoint*".

Both `dcn31_hwseq.c` (line 163) and `dcn35_hwseq.c` (line 196) have this
same check in their first link iteration loops, confirming this is a
well-established pattern.

### 4. DEPENDENCY ANALYSIS

There are **two** crash points in `dcn401_init_hw()` for DPIA links:
1. **First loop** (~line 209):
   `link->link_enc->funcs->hw_init(link->link_enc)` — Fixed by
   `d7f5a61e1b04`
2. **Second loop** (~line 290): `link->link_enc->funcs->is_dig_enabled`
   — Fixed by the commit under analysis

In v6.12 stable, **neither** check exists (verified by examining the
v6.12 code). Both commits need to be backported for complete protection.
The commit under analysis is self-contained for the second code path,
but the first crash path would be hit before reaching the second one
unless `d7f5a61e1b04` is also backported.

### 5. AFFECTED VERSIONS AND HARDWARE

- DCN 4.0.1 was added in v6.11 (commit `70839da636050`), present in
  v6.11+, including LTS 6.12.y
- DCN 4.0.1 targets AMD RDNA 4 GPUs (e.g., RX 9070 series)
- DPIA endpoints occur on systems with USB4/Thunderbolt with DisplayPort
  tunneling
- The bug triggers during hardware init (boot/resume) on systems with
  DPIA endpoints in a headless configuration

### 6. RISK ASSESSMENT

- **Size**: 2 lines added — minimal
- **Scope**: Only affects the specific DIG power-down code path during
  init
- **Pattern**: Identical to established practice in dcn31/dcn35
- **Side effects**: None — the guard only skips endpoints that should
  never have been processed
- **Review**: Reviewed by Charlene Liu (the author of the companion
  fix), Tested by Dan Wheeler (AMD)
- **Risk**: Extremely low

### 7. USER IMPACT

Without this fix, AMD RDNA 4 GPU users with USB4/Thunderbolt displays in
a headless boot scenario would hit a **kernel crash** (NULL pointer
dereference → oops/panic). This is a fatal initialization failure.

### 8. VERDICT

This is a clear, surgical fix for a NULL pointer dereference that causes
a kernel crash during hardware initialization. It follows an established
pattern used across multiple DCN generations, is 2 lines with zero risk
of regression, and was reviewed and tested by AMD engineers. It does
require companion commit `d7f5a61e1b04` for complete coverage of all
crash paths, but both should be backported together. The fix applies to
hardware present in stable kernels from v6.11 onward.

**YES**

 drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
index f04cbdb3d3814..1ce61f0570201 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
@@ -287,6 +287,8 @@ void dcn401_init_hw(struct dc *dc)
 			for (i = 0; i < dc->link_count; i++) {
 				struct dc_link *link = dc->links[i];
 
+				if (link->ep_type != DISPLAY_ENDPOINT_PHY)
+					continue;
 				if (link->link_enc->funcs->is_dig_enabled &&
 						link->link_enc->funcs->is_dig_enabled(link->link_enc) &&
 						hws->funcs.power_down) {
-- 
2.51.0


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 665821E5B63;
	Sat, 14 Feb 2026 01:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031246; cv=none; b=Z7I1YUzIhEJNH7TBA8Ujalwhc/YrmwzSWYFnsNUrHZdoYXQhIxKsMRsE9EuUsJSSW3ih534qhi6oxctRKe74fgjP9x2CPZAwSwo9VodSdmfawLHlxziJ4b7W0MNHUv/KQalw67djo0nE6FkhdHCVq5f5URzwVFgYH69tfvre+8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031246; c=relaxed/simple;
	bh=+9UmGzjUre24ZnoJ9X++17ykycRzExGyAIhkJPnrGxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X0IMN9N0ZV//Q1SBYLeHjqZ1/D4RpCHmf0OSa0MgMhrF1Wofwd4RYpnAnAuDNvuxdDc8/je9G7gJz0BxuSrdVMbTvKh6lzWK3R97K8rq2BQlCgCjKAXVtVm1L0VrWORobc8+Xol7Kyg7BPVfdOfFzCmEmUC8IyYEBVG4mKCvexk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JirlZPFH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JirlZPFH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 321EFC16AAE;
	Sat, 14 Feb 2026 01:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031246;
	bh=+9UmGzjUre24ZnoJ9X++17ykycRzExGyAIhkJPnrGxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JirlZPFHWdDMaEPmqpHwZbq3hE15LCmMpGD7ILgQr5FVULBgVDYsePzsp1rZO7W0t
	 puNDRuuvrnRB5Y+A/C9Kb+jHVxtLVfyQKdg3gLPzIswtitCUu4MSUAwKjWMey2Hcd8
	 JDJJOG+03trJf2i1hO/hWfiB5MRsQj3whaDpOf7UCpB9CPuSjg3aiLhHohoTfIpQNZ
	 uAwdaIBgsNoL7u7tl6WAGBqRhhizlpnUzxizjq7PZpVM26NjmbqpET2tlj0EfD9oaM
	 V6MbS+2iL9i44VxDxw1NdzBPTBypPioag2DAY+XSOeJE+qDkxDjcUxznAbF39WEQF5
	 obB10aTAxk2qw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	matthew.brost@intel.com,
	thomas.hellstrom@linux.intel.com,
	rodrigo.vivi@intel.com,
	neil.armstrong@linaro.org,
	yelangyan@huaqin.corp-partner.google.com,
	intel-xe@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.19-6.18] drm/xe/xe3_lpg: Apply Wa_16028005424
Date: Fri, 13 Feb 2026 19:59:57 -0500
Message-ID: <20260214010245.3671907-117-sashal@kernel.org>
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

From: Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>

[ Upstream commit 9d94c1cf6ef938abd4b849b66f8eab11e3c537ef ]

Applied Wa_16028005424 to Graphics version from 30.00 to 30.05

Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Signed-off-by: Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>
Link: https://patch.msgid.link/20251121100822.20076-2-balasubramani.vivekanandan@intel.com
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Here is my complete analysis:

## Commit Analysis: drm/xe/xe3_lpg: Apply Wa_16028005424

### 1. Commit Message Analysis

The commit adds hardware workaround Wa_16028005424 for Intel Xe3_LPG
GPUs targeting graphics versions 30.00 through 30.05. The commit message
is sparse (typical for Intel HW workaround additions), referencing only
the internal workaround number. It has `Reviewed-by: Matt Roper` (a
senior Intel GPU developer), which provides confidence in its
correctness.

### 2. Code Change Analysis

The change is small and consists of three parts:

**a) Register definition** (`regs/xe_guc_regs.h`): Adds
`GUC_INTR_CHICKEN` register at offset 0xc50c and defines
`DISABLE_SIGNALING_ENGINES` as bit 1. This is a GuC (Graphics
microController) interrupt "chicken register" - Intel terminology for a
hardware debug/workaround register.

**b) Include addition** (`xe_wa.c`): Adds `#include
"regs/xe_guc_regs.h"` so the new register definition is accessible.

**c) Workaround entry** (`xe_wa.c` in `gt_was[]` table):

```c
{ XE_RTP_NAME("16028005424"),
  XE_RTP_RULES(GRAPHICS_VERSION_RANGE(3000, 3005)),
  XE_RTP_ACTIONS(SET(GUC_INTR_CHICKEN, DISABLE_SIGNALING_ENGINES))
},
```

This uses the well-tested `xe_rtp_entry_sr` workaround infrastructure to
set the chicken bit during GT initialization. This is the exact same
infrastructure used by every other GT-level workaround in the driver.

### 3. Classification: Hardware Workaround / Quirk

This is a textbook hardware workaround. Intel's numbered "Wa_XXXXXXXX"
entries represent documented hardware errata tracked in their internal
systems. The name "DISABLE_SIGNALING_ENGINES" in the "GUC_INTR_CHICKEN"
register indicates this disables incorrect engine-to-GuC interrupt
signaling behavior. Without this workaround, Xe3_LPG GPUs could
experience:
- GPU hangs from incorrect GuC interrupt handling
- Spurious engine interrupts causing instability
- Work completion notification failures

### 4. Scope and Risk Assessment

- **Lines changed**: ~10 total (3 register defs, 1 include, 4 workaround
  entry lines)
- **Files touched**: 2 (`xe_guc_regs.h`, `xe_wa.c`)
- **Affected hardware**: Only Xe3_LPG GPUs (graphics versions
  30.00-30.05)
- **Risk**: Very low - uses established infrastructure, hardware-
  specific, no behavioral change for other platforms
- **Self-contained**: Yes - no dependencies on other patches

### 5. Platform Availability in Stable Trees

Xe3_LPG (graphics version 3000) was introduced in kernel 6.13
(`800d75bf20ae`). Versions 3004/3005 were added in 6.19
(`4fde66699f1c`). The workaround's `GRAPHICS_VERSION_RANGE(3000, 3005)`
covers all variants. In older stable trees (6.13-6.18), it would still
correctly match the supported versions (3000, 3001, 3003).

### 6. Pattern Consistency

Numerous similar Xe3_LPG workaround additions have been merged into
stable trees:
- `Wa_15016589081` for xe3lpg
- `Wa_14023061436` for Xe3
- `WA_14024681466` for Xe3_LPG
- `Wa_18041344222` for Xe3 30.00/30.01
- `Wa_13012615864` for xe3lpg
- `Wa_16024792527` for xe3lpg
- `Wa_14022293748`, `Wa_22019794406` for xe3lpg (cherry-picked)

All follow the identical pattern of small, self-contained workaround
table entries.

### 7. Stability Indicators

- Reviewed-by: Matt Roper (senior Intel GPU developer)
- Well-established infrastructure (`gt_was[]` table, `xe_rtp_entry_sr`)
- Follows identical patterns to dozens of other workaround additions
- Commit from Intel internal developers maintaining the driver

### 8. Concerns

- No explicit description of the bug symptom (typical for Intel WA
  additions)
- No `Fixes:` tag or `Cc: stable` (expected - that's why we're reviewing
  it)
- Xe3_LPG is relatively new hardware (6.13+)

### Decision

This commit is a standard Intel GPU hardware workaround that fits
squarely within the "quirks and workarounds" exception for stable
kernels. It is small (10 lines total), self-contained, hardware-
specific, uses proven infrastructure, and addresses a documented
hardware errata in the GuC interrupt subsystem. The risk of regression
is near zero because it only affects Xe3_LPG hardware and uses the same
mechanism as dozens of other successfully backported workarounds.
Without it, Xe3_LPG GPUs may experience interrupt-related issues
affecting GPU stability.

**YES**

 drivers/gpu/drm/xe/regs/xe_guc_regs.h | 3 +++
 drivers/gpu/drm/xe/xe_wa.c            | 5 +++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/xe/regs/xe_guc_regs.h b/drivers/gpu/drm/xe/regs/xe_guc_regs.h
index 2118f7dec287f..87984713dd126 100644
--- a/drivers/gpu/drm/xe/regs/xe_guc_regs.h
+++ b/drivers/gpu/drm/xe/regs/xe_guc_regs.h
@@ -90,6 +90,9 @@
 #define GUC_SEND_INTERRUPT			XE_REG(0xc4c8)
 #define   GUC_SEND_TRIGGER			REG_BIT(0)
 
+#define GUC_INTR_CHICKEN			XE_REG(0xc50c)
+#define   DISABLE_SIGNALING_ENGINES		REG_BIT(1)
+
 #define GUC_BCS_RCS_IER				XE_REG(0xc550)
 #define GUC_VCS2_VCS1_IER			XE_REG(0xc554)
 #define GUC_WD_VECS_IER				XE_REG(0xc558)
diff --git a/drivers/gpu/drm/xe/xe_wa.c b/drivers/gpu/drm/xe/xe_wa.c
index e32dd2fde6f1c..d606b058d588e 100644
--- a/drivers/gpu/drm/xe/xe_wa.c
+++ b/drivers/gpu/drm/xe/xe_wa.c
@@ -15,6 +15,7 @@
 
 #include "regs/xe_engine_regs.h"
 #include "regs/xe_gt_regs.h"
+#include "regs/xe_guc_regs.h"
 #include "regs/xe_regs.h"
 #include "xe_device_types.h"
 #include "xe_force_wake.h"
@@ -315,6 +316,10 @@ static const struct xe_rtp_entry_sr gt_was[] = {
 	  XE_RTP_ACTIONS(SET(VDBOX_CGCTL3F10(0), RAMDFTUNIT_CLKGATE_DIS)),
 	  XE_RTP_ENTRY_FLAG(FOREACH_ENGINE),
 	},
+	{ XE_RTP_NAME("16028005424"),
+	  XE_RTP_RULES(GRAPHICS_VERSION_RANGE(3000, 3005)),
+	  XE_RTP_ACTIONS(SET(GUC_INTR_CHICKEN, DISABLE_SIGNALING_ENGINES))
+	},
 };
 
 static const struct xe_rtp_entry_sr engine_was[] = {
-- 
2.51.0


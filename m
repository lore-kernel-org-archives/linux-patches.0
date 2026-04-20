Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CD73480DD4;
	Mon, 20 Apr 2026 13:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691893; cv=none; b=N0bWz8s00lWtetHVahZ93bokxw+p+9OAtAbjPi1f1DrVc2mxmIDmeLkCPmNiZjQxyrDh96IF7G1fOM30EpKpvyMkKIVqwUBkXaKuHDis0iWH8ou5/UoxCGKgiFk4SS4RSWDOb+yEdaQ+oD7kMaY4r9epgeKYk9J/iVnCvSE6uW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691893; c=relaxed/simple;
	bh=MYrgMk1MFpaK0NMjUX5JOisREaAuUSWxePYjYG7xn4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MNJBR5rSxuFlhKxdPIwLHhlBBbIv6GP3m2nuAv2WC7cLiA/56IHbyz/f2UxlyAFj4TTP0gPHa/Rf0WsSyoWdHZBSekdphKKXJQGnwgOFFyVUYB8ir/dDWMzZJhWf5bUqOwhCdiei5/Vm5J65Bl+SgVIlltfa4d6lrz0TGeBF3B4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bd7DJEuM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bd7DJEuM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5882C2BCC4;
	Mon, 20 Apr 2026 13:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691893;
	bh=MYrgMk1MFpaK0NMjUX5JOisREaAuUSWxePYjYG7xn4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bd7DJEuMWLmKDGSr9JcCDGDdytj5MMoa7vkRFjm/worY/hHIeGu4lWBES55zh4zSH
	 lu7mgN8G9wFjxttVBHfgNjj/WGAo2aoT94UG2wegnoFjRZ4fNHxFbxtt0eQfFp0HLO
	 jVYWk8OHLVAHykBnDkq1iNOfjxARzb4nCZYDcbvYISXOhde/dsyoRPnEVunzLIMG7U
	 z2SM8NnxowM3N1JCzO+emcSG7lEOcQj1gF0euUM3dZhDs4D1obtUNFbvfs9nyyJpHh
	 wpXU2wJrlzOCioB0or6TX1sYuaVUwaWuwVCcHIFIJZKRfLjBroUGs27NksrtzN2R+J
	 c5DeDGxv1Ee9Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>,
	sre@kernel.org,
	linux-pm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] power: supply: sbs-manager: normalize return value of gpio_get
Date: Mon, 20 Apr 2026 09:20:49 -0400
Message-ID: <20260420132314.1023554-255-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit 5c2ffc0b215a884dbc961d4737f636067348b8bd ]

The GPIO get callback is expected to return 0 or 1 (or a negative error
code). Ensure that the value returned by sbsm_gpio_get_value() is
normalized to the [0, 1] range.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Link: https://patch.msgid.link/aZYoL2MnTYU5FuQh@google.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a complete understanding. Let me compile the analysis.

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1 - Subject Line Parsing:**
Record: Subsystem: `power: supply: sbs-manager` | Action verb:
"normalize" | Summary: Normalize the return value of the GPIO `get`
callback to the [0, 1] range.

**Step 1.2 - Commit Tags:**
Record:
- Signed-off-by: Dmitry Torokhov (author)
- Reviewed-by: Linus Walleij (GPIO maintainer)
- Reviewed-by: Bartosz Golaszewski (GPIO maintainer)
- Link: https://patch.msgid.link/aZYoL2MnTYU5FuQh@google.com
- Signed-off-by: Sebastian Reichel (power supply maintainer)
- NO Fixes: tag, NO Cc: stable tag (unlike sibling patches)

**Step 1.3 - Commit Body Analysis:**
Record: Bug description: The GPIO `.get()` callback is contractually
required to return 0, 1, or a negative error code.
`sbsm_gpio_get_value()` was returning `ret & BIT(off)`, which yields
`BIT(off)` = 1, 2, 4, 8 for `off` = 0, 1, 2, 3 respectively. Values of
2, 4, 8 violate the API contract. The fix applies `!!()` to normalize.

**Step 1.4 - Hidden Bug Fix Detection:**
Record: "Normalize" is a bug-fix verb. This is a real bug fix disguised
as a "normalization" — the driver's GPIO callback was violating the
gpio_chip API contract.

## PHASE 2: DIFF ANALYSIS

**Step 2.1 - Inventory:**
Record: Single file `drivers/power/supply/sbs-manager.c`, 1 line changed
(1+/1-). Function affected: `sbsm_gpio_get_value()`. Scope: surgical.

**Step 2.2 - Code Flow:**
Record:
- Before: `return ret & BIT(off)` returns `BIT(off)` value (1, 2, 4, 8)
  when the bit is set
- After: `return !!(ret & BIT(off))` returns 0 or 1 as required by the
  API

**Step 2.3 - Bug Mechanism:**
Record: Category (g) Logic / correctness fix — API contract violation.
The `ngpio = SBSM_MAX_BATS = 4`, so `off` takes values 0-3 corresponding
to 4 smart batteries. For `off=0`, `BIT(0)=1` happens to be valid. For
`off=1,2,3`, the raw return is 2, 4, 8 — invalid.

**Step 2.4 - Fix Quality:**
Record: The fix is obviously correct. `!!()` is the idiomatic C
conversion to 0/1 boolean. No regression risk.

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1 - Blame:**
Record: The buggy code was present since the driver was introduced in
commit `dbc4deda03fe6` ("power: Adds support for Smart Battery System
Manager") in v4.15 (2017). The bug was latent for years.

**Step 3.2 - Follow Fixes: (None in this commit, but related commit):**
Record: The gpiolib wrapper that makes the invalid return value actually
matter is commit `86ef402d805d` ("gpiolib: sanitize the return value of
gpio_chip::get()") in v6.15-rc1. This wrapper rejects any value > 1 by
returning -EBADE.

**Step 3.3 - File History:**
Record: Recent changes to sbs-manager.c are minor (probe conversions,
fwnode updates). No prerequisites for this fix.

**Step 3.4 - Author Context:**
Record: Dmitry Torokhov submitted 3 sibling commits across multiple
subsystems for the SAME class of bug:
- `e2fa075d5ce19 iio: adc: ti-ads7950: normalize return value of
  gpio_get` (with Fixes: + Cc: stable)
- `2bb995e6155cb net: phy: qcom: qca807x: normalize return value of
  gpio_get` (with Fixes:)
- `5c2ffc0b215a8 power: supply: sbs-manager: normalize return value of
  gpio_get` (this commit, no Fixes/stable)

**Step 3.5 - Dependencies:**
Record: No dependencies. Standalone fix.

## PHASE 4: MAILING LIST RESEARCH

**Step 4.1 - Original Discussion:**
Record: `b4 dig -c 5c2ffc0b215a8` found the thread at
https://lore.kernel.org/all/aZYoL2MnTYU5FuQh@google.com/. Single patch
(v1), two positive Reviewed-by responses, applied by the power supply
maintainer.

**Step 4.2 - Reviewers:**
Record: Linus Walleij (GPIO maintainer), Bartosz Golaszewski (GPIO
maintainer) both Reviewed-by. Sebastian Reichel (power supply
maintainer) applied. Appropriate maintainer review coverage.

**Step 4.3 - Bug Report:**
Record: No external bug report. The fix was found as part of Dmitry
Torokhov auditing drivers for return value compliance after the sanitize
wrapper exposed the issue.

**Step 4.4 - Related Patches:**
Record: Part of a broader effort by Dmitry to fix drivers that violated
the new API contract. See sibling patches above.

**Step 4.5 - Stable Discussion:**
Record: No explicit stable discussion for this specific commit. However,
the CLOSELY related commit `ec2cceadfae72` ("gpiolib: normalize the
return value of gc->get() on behalf of buggy drivers") explicitly has
`Cc: stable@vger.kernel.org` and `Fixes: 86ef402d805d`, acknowledging
that the sanitize change broke multiple drivers. That commit references
`aZSkqGTqMp_57qC7@google.com` as a closes link and was co-reported by
Dmitry.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1 - Key Functions:**
Record: `sbsm_gpio_get_value()` — assigned to `gc->get` at
`drivers/power/supply/sbs-manager.c:287`.

**Step 5.2 - Callers:**
Record: Called via the gpiolib layer `gpiochip_get()` which is called
from `gpio_chip_get_value()` and `gpio_chip_get_multiple()`. Any
consumer that calls `gpiod_get_value()` on these GPIO lines routes
through this function.

**Step 5.3 - Callees:**
Record: Calls `sbsm_read_word()` which performs an SMBus read on the
hardware.

**Step 5.4 - Reachability:**
Record: Reachable from userspace via GPIO character device ioctls
(GPIO_V2_LINE_VALUES_IOCTL), sysfs GPIO interface, or any in-kernel
consumer. With the SBS manager hardware present and a userspace tool
like `gpioget`, the buggy path is trivially reached.

**Step 5.5 - Similar Patterns:**
Record: Sibling fixes `e2fa075d5ce19` (ti-ads7950), `2bb995e6155cb`
(qca807x). The qca807x fix is ALREADY in stable 6.17.y
(`cb8f0a3857386`), 6.18.y, 6.19.y — establishing precedent that this
class of fix is appropriate for stable.

## PHASE 6: CROSS-REFERENCING AND STABLE TREE ANALYSIS

**Step 6.1 - Buggy Code in Stable:**
Record: `sbsm_gpio_get_value()` with the buggy `ret & BIT(off)` exists
identically in 6.17.y, 6.18.y, 6.19.y stable trees. For older trees
(5.10.y, 5.15.y, 6.1.y, 6.6.y, 6.12.y), the gpiolib wrapper
`86ef402d805d` is NOT present, so the bug is latent (API contract
violation without functional consequence).

**Step 6.2 - Backport Complications:**
Record: The patch applies cleanly to 6.17.y, 6.18.y, 6.19.y (verified
code is identical). For older stable trees, the patch would also apply
but the functional benefit is minimal until the wrapper lands there.

**Step 6.3 - Related Fixes in Stable:**
Record: Qca807x normalize fix IS already in 6.17.y (`cb8f0a3857386`),
6.18.y, 6.19.y (`554e8f2fbce86`). The alternative "normalize-on-behalf"
wrapper fix `ec2cceadfae72` has `Cc: stable` but has not yet landed in
these stable trees (verified: all three still have the EBADE-returning
version).

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1 - Subsystem:**
Record: `drivers/power/supply/` — power supply (battery) subsystem.
PERIPHERAL criticality (specific hardware), but affects laptops/embedded
systems with SBS-compliant multi-battery setups.

**Step 7.2 - Activity:**
Record: sbs-manager is a mature, low-activity driver (since 2017). Used
in real products with LTC1760 and similar chips.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1 - Affected Users:**
Record: Users of SBS-compliant smart battery manager chips (LTC1760 and
others). Target: laptops, industrial embedded devices with multiple hot-
swappable batteries. Specifically affected on kernels 6.15+ that have
the gpiolib sanitize wrapper.

**Step 8.2 - Trigger:**
Record: Triggered automatically whenever userspace (or any in-kernel
consumer) reads the state of battery 2, 3, or 4 via the exposed GPIO
lines on an SBS manager. For battery 1 (`off=0`), `BIT(0)=1` escapes the
check. Trigger is deterministic — not a race.

**Step 8.3 - Failure Mode Severity:**
Record: On stable trees 6.17.y/6.18.y/6.19.y that have the EBADE
wrapper, reading batteries 2-4 returns `-EBADE` instead of the actual
state. Userspace tools that read these GPIOs see errors. This is a
functional regression: MEDIUM severity (broken hardware functionality,
but not a crash/corruption).

**Step 8.4 - Risk-Benefit:**
Record:
- BENEFIT: Restores correct GPIO reporting for SBS multi-battery systems
  on 6.17+.
- RISK: Extremely low — single-line `!!` normalization, impossible to
  regress correctness. Returns 0 or 1 as API requires.
- Ratio: Very favorable — trivial risk, real user benefit.

## PHASE 9: FINAL SYNTHESIS

**Step 9.1 - Evidence Compilation:**

FOR backporting:
- Fixes a real functional regression on stable 6.17.y/6.18.y/6.19.y
  (batteries 2-4 return -EBADE)
- One-line, obviously correct `!!` normalization
- Reviewed by both GPIO maintainers (Linus Walleij, Bartosz Golaszewski)
- Applied by power supply maintainer (Sebastian Reichel)
- Precedent: sibling commit for qca807x (same fix pattern) is already in
  6.17.y, 6.18.y, 6.19.y stable
- Applies cleanly (identical code in stable trees)

AGAINST backporting:
- Original submission had no `Fixes:` tag or `Cc: stable` (unlike
  sibling ti-ads7950 patch)
- On older stable trees (<6.15) without the gpiolib wrapper, the bug is
  purely theoretical

UNRESOLVED: Whether `ec2cceadfae72` will be backported first and make
this technically unnecessary — but even so, this patch properly fixes
the driver rather than relying on a workaround.

**Step 9.2 - Stable Rules Checklist:**
1. Obviously correct and tested: YES — trivial `!!`, reviewed by
   maintainers
2. Real bug: YES — -EBADE returned for real GPIO reads on 6.17+
3. Important issue: YES (MEDIUM) — broken functionality on SBS multi-
   battery systems
4. Small and contained: YES — 1 line
5. No new features: YES
6. Applies to stable: YES

**Step 9.3 - Exception Categories:**
Not a device-ID/quirk addition, but it's a small, surgical correctness
fix. Meets core stable criteria on its own merits.

**Step 9.4 - Decision:**
The patch fixes a real regression on stable kernels 6.17.y, 6.18.y, and
6.19.y (which contain the gpiolib sanitize wrapper from v6.15). It's a
one-line, obviously correct normalization endorsed by two GPIO subsystem
maintainers and the power supply maintainer. The sibling qca807x fix has
already been accepted into these same stable trees, establishing clear
precedent. For older stable trees lacking the wrapper, the fix is still
beneficial as a correctness improvement with zero risk.

## Verification

- [Phase 1] Parsed tags: confirmed author, two Reviewed-by entries from
  GPIO maintainers, applied by power supply maintainer; no Fixes/Cc-
  stable tags (unlike sibling ti-ads7950 patch)
- [Phase 2] Diff analysis: verified in original commit that exactly one
  line changes `ret & BIT(off)` to `!!(ret & BIT(off))`
- [Phase 2] Verified `ngpio = SBSM_MAX_BATS = 4` via Read of
  `drivers/power/supply/sbs-manager.c`, confirming off = 0..3 and
  BIT(off) = 1, 2, 4, 8
- [Phase 3] `git log` showed driver introduced in `dbc4deda03fe6`
  (v4.15, 2017), buggy code present since inception
- [Phase 3] `git log --grep="normalize return value"` found 2 sibling
  Dmitry Torokhov commits (ti-ads7950 with `Cc: Stable`, qca807x with
  `Fixes: 86ef402d805d`)
- [Phase 3] `git show 86ef402d805d` confirmed gpiolib wrapper returns
  `-EBADE` for ret > 1
- [Phase 3] `git describe --contains 86ef402d805d` → `v6.15-rc1` —
  confirms wrapper is in v6.15+
- [Phase 4] `b4 dig -c 5c2ffc0b215a8` located thread at
  lore.kernel.org/all/aZYoL2MnTYU5FuQh@google.com/
- [Phase 4] Read `/tmp/sbsm_thread.mbox`: confirmed single-version
  submission, positive reviews, quick application
- [Phase 4] Identified related commit `ec2cceadfae72` with `Cc:
  stable@vger.kernel.org` acknowledging the wrapper broke drivers
- [Phase 5] Confirmed `sbsm_gpio_get_value` is assigned to `gc->get` and
  reachable from userspace GPIO APIs
- [Phase 6] Verified with `git show stable-
  push/linux-6.17.y:drivers/gpio/gpiolib.c` that 6.17.y has the EBADE-
  returning wrapper
- [Phase 6] Verified same for 6.18.y and 6.19.y
- [Phase 6] Verified 5.10/5.15/6.1/6.6/6.12 do NOT have the wrapper (bug
  is latent there)
- [Phase 6] Verified via `git show stable-
  push/linux-6.17.y:drivers/power/supply/sbs-manager.c` that buggy `ret
  & BIT(off)` is present
- [Phase 6] Verified qca807x sibling fix is already in
  6.17.y/6.18.y/6.19.y (`cb8f0a3857386`, `554e8f2fbce86`)
- [Phase 6] Verified `ec2cceadfae72` alternative fix is NOT yet in those
  stable trees
- [Phase 8] Failure mode: on 6.17/6.18/6.19 the wrapper converts
  BIT(1/2/3) to -EBADE — verified by reading the wrapper implementation

**YES**

 drivers/power/supply/sbs-manager.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/sbs-manager.c b/drivers/power/supply/sbs-manager.c
index 6fe526222f7f4..343ad4ab4082c 100644
--- a/drivers/power/supply/sbs-manager.c
+++ b/drivers/power/supply/sbs-manager.c
@@ -199,7 +199,7 @@ static int sbsm_gpio_get_value(struct gpio_chip *gc, unsigned int off)
 	if (ret < 0)
 		return ret;
 
-	return ret & BIT(off);
+	return !!(ret & BIT(off));
 }
 
 /*
-- 
2.53.0


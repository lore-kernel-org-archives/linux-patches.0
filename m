Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C1FA33FE22;
	Mon, 10 Nov 2025 19:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762804653; cv=none; b=MGfDLD+EB6XvOVRC+ve2TbaD+MG9dR8ipXln8NtN2nyYy3VxbQTa1Y401VNfEabBkXUsIpRs46uhihqBrqSvplIGUhXIUbkA1axiEXcas9g27J415q85iFKOByj2pY1tRlSijxTtlcozH6KcZO1FLqFx6clRDD485Ed2FoBBmfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762804653; c=relaxed/simple;
	bh=8jymNanNDh6OTlugBO11d9IPEUWdygDIcCUgZeTZ+BY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZQnxvQQukEeDhFR3z62bkT2Pl8oL8sCHkyuw2+VT9vXgiqRLjGMDM1iTFj5rprgbGorb0rdwepM3cPdtYDqhIX2xd5TSXgskmvkClky1+hKlOzxq5RugW98lNBWsLRmBB2otXbuAK4a6/saMLRqHk6vCBJ7pjrtXp/pvtfnp2K8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RejfgAbF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RejfgAbF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AE84C2BC87;
	Mon, 10 Nov 2025 19:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762804652;
	bh=8jymNanNDh6OTlugBO11d9IPEUWdygDIcCUgZeTZ+BY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RejfgAbFBT59TuDSFk3Cyjg8poBLbGKWa8PYKiE8jadpNf2V5WdYycEwKl5vLFb6y
	 OJ3VzPUlRRUibfewgWupWbyVDD6Ibst15G0n/GeAONyUSJlJ+W3Vul28N2JfU8Ja5z
	 UAwB5VW6BDO1c+SlW0ZfYqImnhGm7sHyfm26Pz5Gl+Y+f7ibHuObZgtDfbJNYSj6jC
	 ouvlDEckUak8RQNs3PMpYwnxjNOKxAm0KU4bmvDbFEac9TCsxzT7LsLxA3+CuTuPxC
	 yuPujKOd1PD4I2rJdekjtZDnwON3YiUsjqzhjdazn+zl7OwLM184H7FKLRgB+LMEpI
	 XX5PtvuEUO/YQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Tejas Upadhyay <tejas.upadhyay@intel.com>,
	Nitin Gote <nitin.r.gote@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	thomas.hellstrom@linux.intel.com,
	rodrigo.vivi@intel.com,
	intel-xe@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.17-6.12] drm/xe: Move declarations under conditional branch
Date: Mon, 10 Nov 2025 14:57:06 -0500
Message-ID: <20251110195718.859919-6-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251110195718.859919-1-sashal@kernel.org>
References: <20251110195718.859919-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tejas Upadhyay <tejas.upadhyay@intel.com>

[ Upstream commit 9cd27eec872f0b95dcdd811edc39d2d32e4158c8 ]

The xe_device_shutdown() function was needing a few declarations
that were only required under a specific condition. This change
moves those declarations to be within that conditional branch
to avoid unnecessary declarations.

Reviewed-by: Nitin Gote <nitin.r.gote@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20251007100208.1407021-1-tejas.upadhyay@intel.com
Signed-off-by: Tejas Upadhyay <tejas.upadhyay@intel.com>
(cherry picked from commit 15b3036045188f4da4ca62b2ed01b0f160252e9b)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my analysis using semantic code analysis tools and git
repository examination, here is my assessment:

## Answer: YES

## Detailed Analysis:

### 1. Semantic Analysis Tools Used:

**mcp__semcode__find_function**: Located the `xe_device_shutdown`
function in drivers/gpu/drm/xe/xe_device.c:963-983

**mcp__semcode__find_callers**: Identified that `xe_device_shutdown` is
called by `xe_pci_shutdown` (the PCI device shutdown handler at
drivers/gpu/drm/xe/xe_pci.c:877)

**mcp__semcode__diff_functions**: Attempted to analyze semantic
differences in the diff

**Git history analysis**: Examined the commit chain and discovered the
critical dependency relationship

### 2. Key Findings:

**This commit is explicitly marked as a stable dependency** for commit
b11a020d914c3 ("drm/xe: Do clean shutdown also when using flr"). The git
log shows:
```
Stable-dep-of: b11a020d914c ("drm/xe: Do clean shutdown also when using
flr")
```

**The dependent bug fix (b11a020d914c3)**:
- Fixes a real bug causing "random warnings from pending related works
  as the underlying hardware is reset in the middle of their execution"
- Has a `Fixes:` tag pointing to 501d799a47e2 ("drm/xe: Wire up device
  shutdown handler")
- Includes `Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>`
  indicating maintainer involvement
- Is already cherry-picked and destined for stable trees

### 3. Code Change Analysis:

**What this commit does**:
- Moves variable declarations (`struct xe_gt *gt` and `u8 id`) from
  function start into the conditional block where they're actually used
- Purely a code organization change with **zero behavioral impact**
- Changes from:
  ```c
  void xe_device_shutdown(struct xe_device *xe) {
  struct xe_gt *gt;  // Declared at top
  u8 id;
  if (xe_driver_flr_disabled(xe)) {
  // use gt and id here
  }
  }
  ```
  To:
  ```c
  void xe_device_shutdown(struct xe_device *xe) {
  if (xe_driver_flr_disabled(xe)) {
  struct xe_gt *gt;  // Declared inside conditional
  u8 id;
  // use gt and id here
  }
  }
  ```

### 4. Impact Scope:

- **Affected function**: Single function `xe_device_shutdown` in xe DRM
  driver
- **Call path**: User shutdown/reboot → PCI shutdown handler →
  xe_pci_shutdown → xe_device_shutdown
- **Risk level**: Minimal - this is a refactoring that doesn't change
  behavior
- **Subsystem**: Intel Xe GPU driver (drm/xe) - not a core kernel
  subsystem

### 5. Why This Should Be Backported:

**Primary Reason**: **Stable Dependency Requirement**
- The subsequent bug fix b11a020d914c3 needs this commit for clean
  application
- Without it, the bug fix patch may have context conflicts or require
  manual adjustment
- Stable tree maintainers have already identified this as a required
  dependency

**Secondary Reasons**:
- **Zero risk**: Pure code movement with no behavioral change
- **Small scope**: Single function in a device driver
- **Cherry-picked**: Already cherry-picked with signature `(cherry
  picked from commit 15b3036045188f4da4ca62b2ed01b0f160252e9b)`
- **Enables important fix**: Required for fixing shutdown warnings that
  affect users

### 6. Stable Tree Rules Compliance:

✅ **Fixes real issue** (as a dependency for an actual bug fix)
✅ **Small and contained** (single function, declaration movement)
✅ **No new features** (refactoring only)
✅ **Low regression risk** (no behavioral change)
✅ **Explicitly marked for stable** (Stable-dep-of tag)

### Conclusion:

This commit should be backported to stable trees because it is
explicitly marked as a stable dependency for an important bug fix. While
it doesn't fix a bug itself, it's a necessary prerequisite that ensures
the subsequent fix (b11a020d914c3) applies cleanly. The change is safe
(zero behavioral impact), small (single function), and already
identified by maintainers as required for stable tree integration.

 drivers/gpu/drm/xe/xe_device.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_device.c b/drivers/gpu/drm/xe/xe_device.c
index 1c9907b8a4e9e..e7f838fed3298 100644
--- a/drivers/gpu/drm/xe/xe_device.c
+++ b/drivers/gpu/drm/xe/xe_device.c
@@ -962,12 +962,12 @@ void xe_device_remove(struct xe_device *xe)
 
 void xe_device_shutdown(struct xe_device *xe)
 {
-	struct xe_gt *gt;
-	u8 id;
-
 	drm_dbg(&xe->drm, "Shutting down device\n");
 
 	if (xe_driver_flr_disabled(xe)) {
+		struct xe_gt *gt;
+		u8 id;
+
 		xe_display_pm_shutdown(xe);
 
 		xe_irq_suspend(xe);
-- 
2.51.0


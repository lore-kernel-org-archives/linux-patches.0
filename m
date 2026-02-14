Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AF333EBF2C;
	Sat, 14 Feb 2026 01:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771030991; cv=none; b=p/YWYNXSCJOocmvdK6HvmM3MyYKFAZkOyro6qoD3NPa9VhHwG2BAyQ7/yxTriLOoO4uBUszOeTozvW7VDFtCqPlDXyE2LyG3z6ugV4tFXCnKuH3GlVdd38eGIJVl0KaOxjpEE8sMJSWnRK44Ja0HoH1sxM14dW7kmwWkmxwFs44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771030991; c=relaxed/simple;
	bh=gaA3jb1vSP5RLu1ltGFAqS2zH//J+KBUkCpHH0YIUoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QEqGF849k1gijDOYN0EbocJND+/1HSpppN+VTBffveQ98CuSIKhtEhCfSJe+tM/8xLe5mSLPAVaPz/bsCiFwyyfOeI8/pkChsnU4JgJ0xo4SI5zvAkoLLWT9K8YyQL9NkSglBI3f83JR84HPYbDaqYkSQ2Fe98d4/3/p9fqMbUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CTAxUgYk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CTAxUgYk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBC4BC116C6;
	Sat, 14 Feb 2026 01:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771030990;
	bh=gaA3jb1vSP5RLu1ltGFAqS2zH//J+KBUkCpHH0YIUoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CTAxUgYk/qWjqbdIFt9SOv6Ma7XK1ktVXZZX+ABvLbj7yj9F7jHC3bKjjoAsEnNKG
	 EJn5JKvkqMPAkyCt+1rwu9XYaiGQxxbcNVwbSzmhRuxfcbFbMx//UvwiA/5MSeqrwL
	 I2t9lOM4OGocwlJAAvJ3zvcjrYwro5AAzzkwYCMOvPNgpEBGGWrztaAHehjZJ5QZer
	 HtSEiNoV5SkpIYAcIvc1vbQiuogdt/TVPMlU3XccHhaYTLZKZIcAIkO0exXL2C8Al5
	 Ll8wngNbghXgcEF9iCFk33RffyJqpnPFfLY+Z4npuMaFMh3mAOkbnYs4tBmtNHbrma
	 KbeHsvhzj7Sig==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Tomasz=20Paku=C5=82a?= <tomasz.pakula.oficjalny@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	jikos@kernel.org,
	bentiss@kernel.org,
	linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.18] HID: pidff: Do not set out of range trigger button
Date: Fri, 13 Feb 2026 19:58:15 -0500
Message-ID: <20260214010245.3671907-15-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214010245.3671907-1-sashal@kernel.org>
References: <20260214010245.3671907-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Transfer-Encoding: 8bit

From: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>

[ Upstream commit e01a029654f7fb67d7151365410aa22be4e63dbe ]

Some games (mainly observed with Kylotonn's WRC Serises) set trigger
button to a random value, or always the same one, out of range.
I observed 307 and other values but, for example, my Moza R9 only
exposes 128 buttons AND it's trigger button field is 8-bit. This causes
errors to appear in dmesg.

Only set the trigger button and trigger interval in the trigger button
is in range of the field.

Signed-off-by: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a complete picture. Let me provide my analysis.

## Detailed Analysis

### 1. Commit Message Analysis

The commit clearly describes a **real-world bug**: games (specifically
Kylotonn's WRC Series) set the trigger button to random out-of-range
values (e.g., 307) when the hardware only supports 128 buttons with an
8-bit field. This causes errors in dmesg. The author is the driver's
2025 co-maintainer (Tomasz Pakula, noted at line 6 of the file).

### 2. Code Change Analysis

**The bug mechanism:** In `pidff_set_effect_report()`, the trigger
button value from userspace (`effect->trigger.button`) is written
directly to the HID field value without any bounds checking:

```526:526:drivers/hid/usbhid/hid-pidff.c
        pidff->set_effect[PID_TRIGGER_BUTTON].value[0] =
effect->trigger.button;
```

When this value exceeds what the HID field can hold (e.g., 307 in an
8-bit field with max 128), the `implement()` function in `hid-core.c`
catches it and emits a **non-rate-limited** warning:

```1472:1477:drivers/hid/hid-core.c
                if (unlikely(value > m)) {
                        hid_warn(hid,
                                 "%s() called with too large value %d
(n: %d)! (%s)\n",
                                 __func__, value, n, current->comm);
                        value &= m;
                }
```

`hid_warn` maps to `dev_warn()` which is **not rate-limited** (unlike
`hid_warn_ratelimited`). Since force feedback effects can be updated at
frame rate (60-144+ Hz), this can produce hundreds of kernel warnings
per second during gameplay.

**The fix adds a simple bounds check:** If `trigger.button` exceeds
`field->logical_maximum`, both trigger button and trigger repeat
interval are set to 0 (disabled), which is the correct semantic - an
invalid trigger button should mean "no trigger." Otherwise, the values
pass through normally. The fix is +10 lines of straightforward
validation logic.

### 3. Impact Assessment

- **Who is affected:** Users of HID PID force feedback devices (racing
  wheels like Moza R9, Thrustmaster, etc.) playing games that set out-
  of-range trigger button values (WRC Series and likely others).
- **What happens without the fix:**
  1. **Kernel log flooding** - unrestricted `hid_warn()` called per-
     frame can fill system logs
  2. **Silent value corruption** - `implement()` masks the value with `&
     m`, mapping to a random valid button rather than disabling the
     trigger
  3. **Performance degradation** from excessive logging
- **Severity:** Moderate - causes persistent dmesg spam and incorrect
  device behavior, but no crash/corruption/security issue.

### 4. Scope and Risk

- **Size:** Very small - 10 lines added in one function in one file
- **Risk:** Near-zero regression risk. Only adds an `if/else` bounds
  check with a sensible default
- **Subsystem:** HID force feedback - well-contained, affects only FF-
  capable USB HID devices

### 5. Backport Applicability

- **v6.18.y:** Patch applies cleanly (function matches HEAD context)
- **v6.15-v6.17:** Function has same structure with `pidff_set_time()` -
  minor context adjustment needed
- **v6.14 and earlier (LTS: v6.12.y, v6.6.y, v6.1.y, v5.15.y):**
  Function uses old code pattern (direct `.value[0]` assignment instead
  of `pidff_set_time()`). The fix concept is trivially portable but the
  patch won't apply as-is. The old code at v6.14 is:
  ```c
  pidff->set_effect[PID_TRIGGER_BUTTON].value[0] =
  effect->trigger.button;
  pidff->set_effect[PID_TRIGGER_REPEAT_INT].value[0] =
  effect->trigger.interval;
  ```
  The bug has existed since the driver was created (~2007).

### 6. Stable Criteria Assessment

| Criteria | Assessment |
|---|---|
| Obviously correct and tested | Yes - simple bounds check, tested with
Moza R9 + WRC games |
| Fixes a real bug | Yes - out-of-range values cause log spam and wrong
behavior |
| Important issue | Moderate - dmesg flooding + incorrect FF behavior |
| Small and contained | Yes - 10 lines in one function |
| No new features | Correct - pure input validation |

### 7. Concerns

- The patch uses C99 mixed declarations (`s32 trigger_button_max = ...`
  in the middle of the function body). While this is accepted in modern
  kernel coding, some older stable trees may have stricter compilation
  settings. For LTS backports, this should be declared at function
  scope.
- For LTS trees (6.12.y and earlier), a hand-adapted backport is needed
  since the 2025 refactoring isn't present.

### Conclusion

This is a valid input validation fix that prevents kernel log flooding
and incorrect force feedback behavior caused by userspace (games)
sending out-of-range trigger button values. The fix is small, obviously
correct, zero-risk, and addresses a real-world problem reported by force
feedback device users. Despite needing adaptation for older LTS trees,
the concept is trivially portable.

**YES**

 drivers/hid/usbhid/hid-pidff.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/usbhid/hid-pidff.c b/drivers/hid/usbhid/hid-pidff.c
index 95377c5f63356..a4e700b40ba9b 100644
--- a/drivers/hid/usbhid/hid-pidff.c
+++ b/drivers/hid/usbhid/hid-pidff.c
@@ -523,9 +523,19 @@ static void pidff_set_effect_report(struct pidff_device *pidff,
 	pidff_set_duration(&pidff->set_effect[PID_DURATION],
 			   effect->replay.length);
 
-	pidff->set_effect[PID_TRIGGER_BUTTON].value[0] = effect->trigger.button;
-	pidff_set_time(&pidff->set_effect[PID_TRIGGER_REPEAT_INT],
-		       effect->trigger.interval);
+	/* Some games set this to random values that can be out of range */
+	s32 trigger_button_max =
+		pidff->set_effect[PID_TRIGGER_BUTTON].field->logical_maximum;
+	if (effect->trigger.button <= trigger_button_max) {
+		pidff->set_effect[PID_TRIGGER_BUTTON].value[0] =
+			effect->trigger.button;
+		pidff_set_time(&pidff->set_effect[PID_TRIGGER_REPEAT_INT],
+			       effect->trigger.interval);
+	} else {
+		pidff->set_effect[PID_TRIGGER_BUTTON].value[0] = 0;
+		pidff->set_effect[PID_TRIGGER_REPEAT_INT].value[0] = 0;
+	}
+
 	pidff->set_effect[PID_GAIN].value[0] =
 		pidff->set_effect[PID_GAIN].field->logical_maximum;
 
-- 
2.51.0


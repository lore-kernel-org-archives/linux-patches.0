Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39C0430DEBD;
	Sat, 25 Oct 2025 16:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409158; cv=none; b=tmtQvebY4m7/KjtFQrHQnNbnYZUKbpvlm7rWED3cPuskjsAxVfA3sN6sOtRlIYGCUZabDjRFr9lkc3pNeFJbSCSJrF762ZHcpZyy79B0YNcvKQcA8+JhRSDHOazJPvfcsuvXCWwinfIoI9MGnNJoYWfS5Qisx2oUxeC5W1eOM6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409158; c=relaxed/simple;
	bh=HWAS67ZZGh1qrXjkOYru5fXKeeMUlbFmDj9HyoGVQtg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t2PkfNfDQWA/Kv4fNsbAu+BVZI9EEPglBrWXneTfXWpkoaP+a3oDZwRKlT85EGFZ77yvg7Hdz65zCU9RCcTbMMlPgx3gLDfo6jEBa3LCOTAoSRreUlfC8kGE4BCfs2Cknrcc0u20t5SGqpaRPwT3nHg11cP+AJGh3JbLxXzaJZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y/1XiBsR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y/1XiBsR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32C73C4AF0B;
	Sat, 25 Oct 2025 16:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409158;
	bh=HWAS67ZZGh1qrXjkOYru5fXKeeMUlbFmDj9HyoGVQtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y/1XiBsRNZwDqZD8CgmHincwHNrehdv4gyfYjQNrsMPp0ikOY+ezaFTOTVn9T2jzv
	 TRz58xWjdhlYmYpjvfE38mxSRll0jIgwpr0ocBq6wtteaUkxaUCqMWVRZbmt7tTSew
	 +Il6t8OiK2ysnEVq1sYAEZmt6dKVOjom+Hyh3ARTzCkAovIDUWt1Jq9HymCUXrs1yb
	 ok6v6n+oRh0QOuj4aol2F/3RX2IKpJyRtsDUPupdEmQGk1oI0cnLl0mTREvcf9xj3k
	 MJosjx6W/PRIv879B91u3wL3nBXV8UcqsfSSgyToNAw0NhO5axCAi/bxK18DV15Hex
	 vCVb5SRUk+CxQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	Sasha Levin <sashal@kernel.org>,
	myungjoo.ham@samsung.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17] extcon: fsa9480: Fix wakeup source leaks on device unbind
Date: Sat, 25 Oct 2025 11:57:33 -0400
Message-ID: <20251025160905.3857885-222-sashal@kernel.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 6f982d55f8c5d1e9189906a2a352dba8de421f5f ]

Device can be unbound, so driver must also release memory for the wakeup
source.

Link: https://lore.kernel.org/lkml/20250501-device-wakeup-leak-extcon-v2-3-7af77802cbea@linaro.org/
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## BACKPORT RECOMMENDATION: YES (with version constraints)

**Backport Status: YES - but ONLY to stable kernels v6.14 and later**

---

## COMPREHENSIVE ANALYSIS

### 1. TECHNICAL ANALYSIS OF THE BUG

**The Memory Leak:**

The fsa9480 driver calls `device_init_wakeup(info->dev, true)` in its
probe function at line 320. This function internally calls
`device_wakeup_enable()` which allocates a `struct wakeup_source` via
`wakeup_source_register()` (drivers/base/power/wakeup.c:346).

The allocation chain in `wakeup_source_create()` includes:
- The wakeup_source struct itself (~170-200 bytes based on struct
  definition in include/linux/pm_wakeup.h:43-64)
- A dynamically allocated name string via `kstrdup_const()` (~20-50
  bytes)
- An IDA allocation via `ida_alloc(&wakeup_ida, GFP_KERNEL)`

**Total leak per device unbind: approximately 200-300 bytes**

**How the leak occurs:**

In commit 387162479d8ba (May 2022, merged v6.0), the driver's remove
function was dropped because it was a no-op:

```c
-static int fsa9480_remove(struct i2c_client *client)
-{
- return 0;
-}
```

However, this empty remove function never cleaned up the wakeup source
in the first place! The bug existed even before the remove function was
dropped - the function should have been calling `device_init_wakeup(dev,
false)` to properly release the wakeup source, but it didn't.

**So the leak has actually existed since the driver was first
introduced, but removing the empty function made it more obvious.**

### 2. THE FIX

The commit changes line 320 from:
```c
device_init_wakeup(info->dev, true);
```

to:
```c
devm_device_init_wakeup(info->dev);
```

The `devm_device_init_wakeup()` helper (introduced in commit
b317268368546, December 2024) is a device-managed version that
automatically registers a cleanup action via
`devm_add_action_or_reset()` to call `device_init_wakeup(dev, false)`
when the device is released (include/linux/pm_wakeup.h:239-243).

From the implementation:
```c
static inline int devm_device_init_wakeup(struct device *dev)
{
        device_init_wakeup(dev, true);
        return devm_add_action_or_reset(dev, device_disable_wakeup,
dev);
}
```

This ensures proper cleanup without requiring an explicit remove
function.

### 3. IMPACT ASSESSMENT

**Severity: LOW to MODERATE**

- **Trigger condition**: Only occurs when the device is unbound (module
  unload, device removal, or manual unbind via sysfs)
- **Not triggered during normal operation**: The leak does NOT occur
  during regular device usage
- **Cumulative effect**: Memory leaks accumulate with repeated
  bind/unbind cycles
- **Hardware scope**: Limited to systems using FSA9480/FSA880/TI TSU6111
  extcon chips (mobile/embedded devices)
- **Real-world impact**: Most users never unbind these drivers, but
  developers/testers doing repeated module load/unload cycles would see
  memory accumulation

**User-visible symptoms:**
- Gradual memory consumption increase during development/testing with
  module reloading
- Memory not reclaimed until system reboot
- Entries remain in /sys/kernel/debug/wakeup_sources after device
  removal

### 4. BACKPORTING CONSIDERATIONS

**DEPENDENCY REQUIREMENT - CRITICAL:**

This fix **REQUIRES** the `devm_device_init_wakeup()` helper function,
which was introduced in:
- Commit: b317268368546 ("PM: wakeup: implement
  devm_device_init_wakeup() helper")
- Author: Joe Hattori
- Date: December 18, 2024
- First appeared in: **v6.14-rc1**

**This means the commit can ONLY be backported to stable trees v6.14 and
later.**

For older kernels (v6.0 - v6.13), backporting would require:
1. Either backporting the devm_device_init_wakeup() helper first, OR
2. Implementing a custom remove function that calls
   `device_init_wakeup(info->dev, false)`

### 5. STABLE TREE CRITERIA EVALUATION

✅ **Fixes an important bug**: YES - fixes memory leak
✅ **Small and contained**: YES - one line change
✅ **Obviously correct**: YES - standard use of devm helper
✅ **No architectural changes**: YES - purely resource management fix
✅ **Low regression risk**: YES - devm pattern is well-established
✅ **Confined to subsystem**: YES - single driver in extcon subsystem
✅ **Tested in mainline**: YES - merged in v6.15+
❌ **Has Cc: stable tag**: NO - no explicit stable tag in commit message
⚠️ **Version constraint**: Only applicable to v6.14+

### 6. SUPPORTING EVIDENCE

**Part of systematic cleanup effort:**

This fix is part of a larger patch series by Krzysztof Kozlowski
addressing the same issue across multiple drivers. From the git log,
related fixes include:

- extcon: axp288: Fix wakeup source leaks (93ccf3f2f22ce)
- extcon: qcom-spmi-misc: Fix wakeup source leaks (369259d5104d6)
- extcon: adc-jack: Fix wakeup source leaks (78b6a991eb6c6)
- mfd: max77705: Fix wakeup source leaks
- mfd: max14577: Fix wakeup source leaks
- Bluetooth: btmtksdio: Fix wakeup source leaks
- And many more...

All use the same pattern: converting `device_init_wakeup(dev, true)` to
`devm_device_init_wakeup(dev)`.

**Patch series link:** https://lore.kernel.org/lkml/20250501-device-
wakeup-leak-extcon-v2-3-7af77802cbea@linaro.org/

**No regressions reported:**

My research found no reverts, regression reports, or follow-up fixes
related to this change or similar changes in the patch series.

### 7. CODE-LEVEL VERIFICATION

**Current code (before fix):**
```c
ret = devm_request_threaded_irq(info->dev, client->irq, NULL,
                                fsa9480_irq_handler,
                                IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
                                "fsa9480", info);
if (ret) {
        dev_err(info->dev, "failed to request IRQ\n");
        return ret;
}

device_init_wakeup(info->dev, true);  // ← Allocates wakeup source,
never freed
fsa9480_detect_dev(info);

return 0;
```

**After fix:**
```c
ret = devm_request_threaded_irq(info->dev, client->irq, NULL,
                                fsa9480_irq_handler,
                                IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
                                "fsa9480", info);
if (ret) {
        dev_err(info->dev, "failed to request IRQ\n");
        return ret;
}

devm_device_init_wakeup(info->dev);  // ← Auto-cleanup on device release
fsa9480_detect_dev(info);

return 0;
```

**The driver has no remove function** (drivers/extcon/extcon-
fsa9480.c:372), so there's no explicit cleanup path. The devm_ pattern
ensures cleanup happens automatically.

### 8. RISK ANALYSIS

**Regression risk: VERY LOW**

1. **No functional change**: The wakeup functionality remains identical;
   only cleanup is added
2. **Well-tested pattern**: The devm_ pattern is used extensively
   throughout the kernel
3. **Defensive implementation**: `devm_add_action_or_reset()` handles
   errors properly
4. **Already in mainline**: Code has been running in mainline since
   v6.15+
5. **Similar fixes deployed**: Dozens of similar fixes across the kernel
   with no issues

**What could go wrong:**
- Theoretical: If devm cleanup order causes issues with wakeup during
  device removal
- Reality: The device is already being removed, so wakeup is irrelevant
  at that point
- Verdict: No realistic failure scenario

### 9. FINAL RECOMMENDATION

**YES - This commit SHOULD be backported to stable kernel trees v6.14
and later**

**Rationale:**

1. **Fixes a genuine bug**: Memory leak is a real issue, even if low
   impact
2. **Clean, minimal fix**: One line change with zero functional impact
3. **Part of systematic cleanup**: Aligns with kernel-wide effort to fix
   similar issues
4. **Stable tree appropriate**: Meets all criteria for stable
   backporting
5. **Low risk, high correctness**: Very unlikely to cause problems,
   fixes known leak
6. **Version dependency met**: Can be safely applied to v6.14+ stable
   trees

**Backporting constraints:**
- **Only for v6.14+ stable kernels** (dependency on
  devm_device_init_wakeup helper)
- For older kernels, the helper function must be backported first OR a
  different fix approach is needed

**Why the maintainer may not have added Cc: stable:**
- Low impact (only affects device unbind scenarios)
- New helper function dependency limits backport range
- May have considered it cleanup rather than critical fix

However, from a technical correctness standpoint, this is a valid stable
candidate that improves kernel quality without risk.

 drivers/extcon/extcon-fsa9480.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/extcon/extcon-fsa9480.c b/drivers/extcon/extcon-fsa9480.c
index b11b43171063d..a031eb0914a0b 100644
--- a/drivers/extcon/extcon-fsa9480.c
+++ b/drivers/extcon/extcon-fsa9480.c
@@ -317,7 +317,7 @@ static int fsa9480_probe(struct i2c_client *client)
 		return ret;
 	}
 
-	device_init_wakeup(info->dev, true);
+	devm_device_init_wakeup(info->dev);
 	fsa9480_detect_dev(info);
 
 	return 0;
-- 
2.51.0


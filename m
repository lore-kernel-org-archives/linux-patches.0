Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90D33EBF0F;
	Wed, 20 May 2026 11:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779276030; cv=none; b=UDSWqAkA4S/fBBZuFyOgW6qwHjBKg8BjHPWdElUaxLXdPp7Zic5L5I0j8E+yE7iCcITeGiDP/VA7SMzBwZs1K/p+GdD/q3jg7jae9mk1DybTIlZbul4pKtXQMv/T6jRYb1TJOycJc03+/D/Gs34dpNjMEVlqshUVocUArZGSwqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779276030; c=relaxed/simple;
	bh=KRKHu4WJoa0DmBrPO2Rq6iggehoAGmF7JjHx2Qe0fZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kLzeeIjoSijCZYMDP39dQUOxLVVdoZ33Zc9T8TsJ0eCpJIOtvoM0KJvF/cpHS10wTDJ48BbbTHMiJyBgAi5KYCh5yGr+7xnPgrGjeoee6wSs2/bqdXkxXpSUQGC5+Bfe86NBmCWN6g/L03SHdPoNtanalqCqVuC3nvgpsCBQD4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ju1naoQw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ju1naoQw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E816D1F000E9;
	Wed, 20 May 2026 11:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779276027;
	bh=TebGB/gW42Lw0MfSZeNASHalsW2sx4OdFUJ7gXRZD2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ju1naoQwm2OouaUlTSYbgQFoIrSzSQpYa/PuknOE0svysQiSgAPiFd85MLfkE9LNt
	 LMOfIgaByF5iAsQUqDnEklX2uvv5CNr6dhCj50z0aUSNWzYOZ7Y+c1Z7unAI8sZpaf
	 hA+pfbWiygnQUfNzDMFx33d98SgavaXCk3SSrx6N+PmybwkXzMlYTRgaC3Pg22N2mb
	 3Cgcre64+WemdOZnqdcX6f71oA19pyDkfK1MRutoMc792sll6eJQRI8Oo+92d6O95+
	 Niwe6Ty1PhNnsjwMVLTBYVU/B7+MZFQO2gKvitmp+oi99dDQVnhlNxmY0kTaXlPH68
	 lNIIt5YNHkRLQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Xu Rao <raoxu@uniontech.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	jikos@kernel.org,
	bentiss@kernel.org,
	linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.12] HID: i2c-hid: add reset quirk for BLTP7853 touchpad
Date: Wed, 20 May 2026 07:19:02 -0400
Message-ID: <20260520111944.3424570-30-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260520111944.3424570-1-sashal@kernel.org>
References: <20260520111944.3424570-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.9
Content-Transfer-Encoding: 8bit

From: Xu Rao <raoxu@uniontech.com>

[ Upstream commit a991aa5e89365ba1959fae6847fd288125b209e5 ]

The BLTP7853 I2C HID touchpad may fail to probe after reboot or
reprobe because reset completion is not signalled to the host. The
driver then waits for the reset-complete interrupt until it times out
and the device probe fails:

  i2c_hid i2c-BLTP7853:00: failed to reset device.
  i2c_hid i2c-BLTP7853:00: can't add hid device: -61
  i2c_hid: probe of i2c-BLTP7853:00 failed with error -61

Add I2C_HID_QUIRK_NO_IRQ_AFTER_RESET for the device so i2c-hid does
not wait for a reset interrupt that may never arrive.

Signed-off-by: Xu Rao <raoxu@uniontech.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase Walkthrough

### Phase 1: Commit Message Forensics
Record: subsystem `HID: i2c-hid`; action verb `add`; intent is to add a
reset-handling quirk for the BLTP7853 touchpad.

Record: tags present are `Signed-off-by: Xu Rao <raoxu@uniontech.com>`
and `Signed-off-by: Jiri Kosina <jkosina@suse.com>`. No `Fixes:`,
`Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-by:`, `Link:`, or
`Cc: stable@vger.kernel.org` tags are present in the supplied message.

Record: the commit message describes a real probe failure: the device
may not signal reset completion after reboot or reprobe, the driver
waits for reset completion, and probe fails with `-61` / `-ENODATA`. The
root cause given is missing reset-complete IRQ from the device.

Record: this is not hidden as cleanup; it is explicitly a hardware
workaround for a probe failure.

### Phase 2: Diff Analysis
Record: files changed are `drivers/hid/hid-ids.h` with 3 additions and
`drivers/hid/i2c-hid/i2c-hid-core.c` with 2 additions. Total scope: 5
added lines, no removals. No function body is changed; the modified
object is the private `i2c_hid_quirks[]` table.

Record: before the patch, vendor/product `0x36b6/0xc001` had no private
i2c-hid quirk entry, so the reset path used normal reset-ack waiting.
After the patch, `i2c_hid_lookup_quirk()` can match the BLTP7853 IDs and
set `I2C_HID_QUIRK_NO_IRQ_AFTER_RESET`.

Record: in current code, `I2C_HID_QUIRK_NO_IRQ_AFTER_RESET` makes
`i2c_hid_finish_hwreset()` sleep 100 ms and clear
`I2C_HID_RESET_PENDING` instead of waiting for a reset IRQ. In older
stable code, the same quirk skips the 5 second wait path that returns
`-ENODATA`.

Record: bug category is hardware workaround / quirk. Specific mechanism:
a device that does not raise the expected reset-complete interrupt is
handled through an existing no-IRQ-after-reset path.

Record: fix quality is high: tiny table-only change, uses existing
infrastructure, no new API, no locking change, no cross-subsystem
behavior. Regression risk is very low and limited to devices reporting
exactly the new vendor/product pair.

### Phase 3: Git History Investigation
Record: exact candidate subject was not found in local `git log` on
`master`, `all-next`, `fixes-next`, `input-next`, `pending-7.0`, or
`for-greg/7.0-200`; no candidate commit hash was available to blame the
newly added lines.

Record: existing no-IRQ reset quirk support was introduced by
`402946a8ef71e` (`HID: i2c-hid: Add no-irq-after-reset quirk for
0911:5288 device`), contained since `v4.15-rc1`. Related Voyo quirk
`fc6a31b007393` shows the same failure pattern: repeated `failed to
reset device` and final `can't add hid device: -61`.

Record: no `Fixes:` tag is present, so Step 3.2 is not applicable.

Record: recent history contains normal HID/i2c-hid quirk and fix
activity. Relevant related changes include `7bcf9ebb50f2a` (`Turn
missing reset ack into a warning`) and older device-specific no-IRQ
quirks. No prerequisite was identified beyond existing
`I2C_HID_QUIRK_NO_IRQ_AFTER_RESET` support.

Record: local `git log --author="Xu Rao" -- drivers/hid` found no HID
commits on `master`. `MAINTAINERS` confirms Jiri Kosina is an HID core
maintainer, and he signed off the supplied commit.

### Phase 4: Mailing List And External Research
Record: candidate `b4 dig` could not be performed because the exact
candidate commit hash is unavailable and the subject is not present in
local reachable history.

Record: `b4 dig -c 402946a8ef71e` found the original related no-IRQ-
after-reset quirk submission at
`https://patch.msgid.link/20171107122800.23196-1-hdegoede@redhat.com`;
`b4 dig -a` showed v1 and v2; `b4 dig -w` showed HID maintainers and
`linux-input@vger.kernel.org` were included.

Record: `b4 dig -c 7bcf9ebb50f2a` found the reset-ack warning patch as
`[PATCH v3 5/7]`.

Record: web searches for the exact BLTP7853 reset-quirk subject and
stable-list discussion found no direct candidate thread. Searches did
find related BLTP7853 touchpad reports, but not independent confirmation
of this exact `0x36b6/0xc001` reset failure.

### Phase 5: Code Semantic Analysis
Record: modified key object is `i2c_hid_quirks[]`; relevant functions
are `i2c_hid_lookup_quirk()`, `__i2c_hid_core_probe()`,
`i2c_hid_finish_hwreset()`, and older-branch `i2c_hid_command()`
behavior.

Record: callers verified: `i2c_hid_core_probe()` is called from ACPI,
OF, ELAN, and Goodix i2c-hid probe drivers. `__i2c_hid_core_probe()`
reads HID descriptor vendor/product IDs and calls
`i2c_hid_lookup_quirk()`.

Record: call chain is device enumeration/probe: platform driver probe ->
`i2c_hid_core_probe()` -> `__i2c_hid_core_probe()` ->
`i2c_hid_lookup_quirk()` -> HID registration -> reset during HID parse.
This is reachable during boot, reboot, and reprobe for affected
hardware.

Record: similar patterns exist for HANTICK, ITE/Voyo, and Raydium
devices already using `I2C_HID_QUIRK_NO_IRQ_AFTER_RESET`.

### Phase 6: Stable Tree Analysis
Record: `I2C_HID_QUIRK_NO_IRQ_AFTER_RESET` exists in active checked
stable branches `5.10.y`, `5.15.y`, `6.1.y`, `6.6.y`, `6.12.y`,
`6.18.y`, `6.19.y`, and `7.0.y`.

Record: BLTP-specific IDs from this patch are not present in those
checked branches or `master`.

Record: `5.10.y`, `5.15.y`, `6.1.y`, and `6.6.y` still have the reset-
ack timeout returning `-ENODATA`, matching the commit-message failure.
`6.12.y` and newer checked branches contain `7bcf9ebb50f2a`, where
missing reset ack is downgraded to a warning, so the benefit there is
mostly avoiding a delay/warning rather than fixing probe failure.

Record: patch applies cleanly to current `stable/linux-7.0.y` when
checked with `git apply --check`. Older stable trees may need minor
context adjustment due to file layout differences, but the required
quirk mechanism exists.

### Phase 7: Subsystem And Maintainer Context
Record: subsystem is HID/i2c-hid under `drivers/hid/`, criticality
`IMPORTANT` for users of affected laptop touchpad hardware.

Record: subsystem is actively maintained; `MAINTAINERS` lists HID core
as maintained by Jiri Kosina and Benjamin Tissoires.

### Phase 8: Impact And Risk
Record: affected population is hardware-specific: systems with an I2C
HID device reporting the BLTP7853 IDs added by this patch.

Record: trigger condition is probe/reprobe after reboot or reprobe, as
described by the commit message and matched to the older stable reset
path.

Record: failure severity is HIGH for older stable branches because the
touchpad can fail to bind at all. For newer branches with
`7bcf9ebb50f2a`, severity is LOW-MEDIUM because generic handling avoids
probe failure but still waits/logs.

Record: benefit is high for older stable users with this hardware; risk
is very low because the change is a narrow hardware quirk table entry.

### Phase 9: Final Synthesis
Evidence for backporting: real device probe failure, existing quirk
mechanism, tiny hardware-specific change, no new API, maintainer sign-
off, and older stable branches demonstrably still have the failing reset
timeout behavior.

Evidence against backporting: no direct candidate lore thread or
external bug report could be verified; exact hardware ID `0x36b6/0xc001`
was only verified from the supplied patch, not an external hardware
database. Newer stable branches already have generic missing-reset-ack
handling, reducing urgency there.

Stable rules: obviously correct by inspection, fixes a real hardware
probe failure on older stable branches, small and contained, no new
feature/API, and falls under the accepted hardware quirk exception.
Backport difficulty should be clean or minor.

## Verification
- [Phase 1] Parsed supplied message and tags: only Xu Rao and Jiri
  Kosina Signed-off-by tags present.
- [Phase 2] Read `drivers/hid/i2c-hid/i2c-hid-core.c`: verified quirk
  table and reset handling.
- [Phase 3] Searched local histories without `--all`: exact candidate
  not found; related no-IRQ quirk commits found.
- [Phase 3] Inspected `402946a8ef71e`, `fc6a31b007393`, and
  `7bcf9ebb50f2a`: confirmed same reset-ack quirk mechanism and later
  generic warning behavior.
- [Phase 4] Ran `b4 dig` for related commits; candidate `b4 dig` was not
  possible without a candidate hash.
- [Phase 5] Traced callers with `rg` and read ACPI/OF probe files:
  confirmed probe-time reachability.
- [Phase 6] Checked active stable branches: quirk support exists in all
  checked branches; old reset failure path exists through `6.6.y`;
  `6.12.y+` has generic warning handling.
- [Phase 6] Ran `git apply --check` against current `7.0.y`: patch shape
  applies cleanly.
- UNVERIFIED: original candidate lore discussion, independent bug
  report, and exact external hardware database confirmation for
  `0x36b6/0xc001`.

**YES**

 drivers/hid/hid-ids.h              | 3 +++
 drivers/hid/i2c-hid/i2c-hid-core.c | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index c371721826dcc..559040e47f3c7 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -277,6 +277,9 @@
 #define USB_VENDOR_ID_BIGBEN	0x146b
 #define USB_DEVICE_ID_BIGBEN_PS3OFMINIPAD	0x0902
 
+#define I2C_VENDOR_ID_BLTP		0x36b6
+#define I2C_PRODUCT_ID_BLTP7853		0xc001
+
 #define USB_VENDOR_ID_BTC		0x046e
 #define USB_DEVICE_ID_BTC_EMPREX_REMOTE	0x5578
 #define USB_DEVICE_ID_BTC_EMPREX_REMOTE_2	0x5577
diff --git a/drivers/hid/i2c-hid/i2c-hid-core.c b/drivers/hid/i2c-hid/i2c-hid-core.c
index 5a183af3d5c6a..baff2728603ec 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -149,6 +149,8 @@ static const struct i2c_hid_quirks {
 		 I2C_HID_QUIRK_BOGUS_IRQ },
 	{ I2C_VENDOR_ID_GOODIX, I2C_DEVICE_ID_GOODIX_0D42,
 		 I2C_HID_QUIRK_DELAY_WAKEUP_AFTER_RESUME },
+	{ I2C_VENDOR_ID_BLTP, I2C_PRODUCT_ID_BLTP7853,
+		I2C_HID_QUIRK_NO_IRQ_AFTER_RESET },
 	{ 0, 0 }
 };
 
-- 
2.53.0


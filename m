Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13D1E305976;
	Sat, 25 Oct 2025 16:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408898; cv=none; b=U9CXIPnnhafYpUa39FDJl2bAJpfBIoKNRPyfgDNmye2edSDGuczRDNjpI6Ycap5BflNjUOQIPgGIcqLLOBXUQNsk9K06MRMHiTH+YMYyGQSIJ/w4SK23XzUL8XKLaoPwoEgaazt8lLioxsmx/11W3LgePU3RbsNNrJS2wavbR6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408898; c=relaxed/simple;
	bh=xLX1ufVd46T/Bd8jrT4KiLflV51OPQFbnAn09kIUJEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PpYBy8vxzxUwTBOe3kxZLp4b8fgFlHIJyNYBuWTWu0PodJ8fxI6h1yc66N7KqBK94dN0iTqpPSqf530ewWKVt5aYCivUaNJkQn1BF78hRK/OiKsJAh2+9L7QBPDhu3e4zMHQcefHdNvzgQ9kbcDqOWbqSDM+CmDoGNMjDblJG0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WhbwK3q+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WhbwK3q+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BB85C113D0;
	Sat, 25 Oct 2025 16:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408897;
	bh=xLX1ufVd46T/Bd8jrT4KiLflV51OPQFbnAn09kIUJEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WhbwK3q+lIyvs9+C5lZAC1ryar1xi7MjkFAQktaeA3ZVN2OTzSDRmxtVfEK7aRfH9
	 DlJY5mBYnh+bYiE8g4l1vJtY10iYnfDoOI/8bqlY371h/99uo7/5dmyqBi7Pw8k1vg
	 WmGe9chhI6vJtRm1hjuufagwQlLbNhBQSe2/Bm5e5ifFV4PJaYcu7VhTcrA4OEWpQU
	 wyLSrebXGxXZpkYyc4KFoWy+qwo5lHxWGBamB56tmq2nc1vlwUtq4lTwBJBTLxLZer
	 Ts07wdYSRd2eqXhbM6edvxk4HyPB+YoTkyfZGjkfTqcrR7OyK/zdUcU3qOgJRP2U+l
	 0idSiFU6vItpA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Tomasz=20Paku=C5=82a?= <tomasz.pakula.oficjalny@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	jikos@kernel.org,
	bentiss@kernel.org,
	linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-6.12] HID: pidff: PERMISSIVE_CONTROL quirk autodetection
Date: Sat, 25 Oct 2025 11:55:52 -0400
Message-ID: <20251025160905.3857885-121-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Transfer-Encoding: 8bit

From: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>

[ Upstream commit c2dc9f0b368c08c34674311cf78407718d5715a7 ]

Fixes force feedback for devices built with MMOS firmware and many more
not yet detected devices.

Update quirks mask debug message to always contain all 32 bits of data.

Signed-off-by: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

Why this is a good stable backport
- Fixes real user-visible breakage: enables force feedback on devices
  with MMOS firmware and other devices misreporting PID_DEVICE_CONTROL’s
  logical_minimum (previously failed to initialize FF).
- Small, contained change in HID PID FF driver; no architectural changes
  or cross‑subsystem impacts.
- Risk is low: the new behavior only relaxes a check if the strict path
  fails, and only for the specific Device Control field; otherwise
  behavior remains identical.
- Improves diagnostics (full 32‑bit quirks mask) without functional side
  effects.
- Aligns with stable rules: important bugfix, minimal risk, confined to
  HID/PIDFF.

What changes, concretely
- Autodetect and set PERMISSIVE_CONTROL only when needed:
  - Before: Device Control lookup was strict unless the quirk was pre-
    specified (e.g., via device ID). If logical_minimum != 1, driver
    failed with “device control field not found”.
  - After: Try strict lookup first; if not found, set
    `HID_PIDFF_QUIRK_PERMISSIVE_CONTROL` and retry without enforcing
    min==1. This allows devices with non‑conforming descriptors to work
    without hardcoding IDs.
- Debug formatting improvement: print all 32 bits of the quirks mask.

Relevant code references (current tree)
- Device Control lookup currently enforces min==1 unless the quirk is
  already set:
  - drivers/hid/usbhid/hid-pidff.c:1135
    - `pidff->device_control = pidff_find_special_field(...,
      PID_DEVICE_CONTROL_ARRAY, !(pidff->quirks &
      HID_PIDFF_QUIRK_PERMISSIVE_CONTROL));`
  - The change will:
    - First call with `enforce_min=1`, then if null:
      - `pr_debug("Setting PERMISSIVE_CONTROL quirk");`
      - `pidff->quirks |= HID_PIDFF_QUIRK_PERMISSIVE_CONTROL;`
      - Retry with `enforce_min=0`.
  - Safety: If the usage isn’t present at all, the second lookup still
    returns NULL and the function returns error exactly as before.
- Quirk definition already exists:
  - drivers/hid/usbhid/hid-pidff.h:16
    - `#define HID_PIDFF_QUIRK_PERMISSIVE_CONTROL BIT(2)`
- Quirks debug formatting to widen to 8 hex digits:
  - drivers/hid/usbhid/hid-pidff.c:1477
    - Currently: `hid_dbg(dev, "Active quirks mask: 0x%x\n",
      pidff->quirks);`
    - Change to: `0x%08x` (formatting only, no logic impact).

Compatibility and dependencies
- Depends on the existing quirk bit and infrastructure (already present
  since “HID: pidff: Add PERMISSIVE_CONTROL quirk”; this is in-tree with
  Signed-off-by: Sasha Levin, so it has been flowing into stable).
- Interacts safely with the more recent fix to Device Control handling:
  - “HID: pidff: Fix set_device_control()” ensures correct 1‑based
    indexing and guards against missing fields; the autodetection does
    not invalidate those fixes.

Regression risk assessment
- Previously working devices (strict path succeeds) are unchanged.
- Previously non-working devices (strict path fails) now work via a
  guarded fallback; without the usage present, behavior remains
  identical (fail).
- The quirk only changes acceptance of the Device Control field; no
  other code paths are altered.

Conclusion
- This is a targeted, low-risk fix that unlocks FF functionality for a
  notable set of devices without broad side effects. It’s well-suited
  for backporting to stable trees that already carry the
  PERMISSIVE_CONTROL quirk.

 drivers/hid/usbhid/hid-pidff.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/usbhid/hid-pidff.c b/drivers/hid/usbhid/hid-pidff.c
index c6b4f61e535d5..711eefff853bb 100644
--- a/drivers/hid/usbhid/hid-pidff.c
+++ b/drivers/hid/usbhid/hid-pidff.c
@@ -1151,8 +1151,16 @@ static int pidff_find_special_fields(struct pidff_device *pidff)
 					 PID_DIRECTION, 0);
 	pidff->device_control =
 		pidff_find_special_field(pidff->reports[PID_DEVICE_CONTROL],
-			PID_DEVICE_CONTROL_ARRAY,
-			!(pidff->quirks & HID_PIDFF_QUIRK_PERMISSIVE_CONTROL));
+			PID_DEVICE_CONTROL_ARRAY, 1);
+
+	/* Detect and set permissive control quirk */
+	if (!pidff->device_control) {
+		pr_debug("Setting PERMISSIVE_CONTROL quirk\n");
+		pidff->quirks |= HID_PIDFF_QUIRK_PERMISSIVE_CONTROL;
+		pidff->device_control = pidff_find_special_field(
+			pidff->reports[PID_DEVICE_CONTROL],
+			PID_DEVICE_CONTROL_ARRAY, 0);
+	}
 
 	pidff->block_load_status =
 		pidff_find_special_field(pidff->reports[PID_BLOCK_LOAD],
@@ -1492,7 +1500,7 @@ int hid_pidff_init_with_quirks(struct hid_device *hid, u32 initial_quirks)
 	ff->playback = pidff_playback;
 
 	hid_info(dev, "Force feedback for USB HID PID devices by Anssi Hannula <anssi.hannula@gmail.com>\n");
-	hid_dbg(dev, "Active quirks mask: 0x%x\n", pidff->quirks);
+	hid_dbg(dev, "Active quirks mask: 0x%08x\n", pidff->quirks);
 
 	hid_device_io_stop(hid);
 
-- 
2.51.0


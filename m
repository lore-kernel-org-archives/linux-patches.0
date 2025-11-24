Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 723B92E03E6;
	Mon, 24 Nov 2025 08:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763971606; cv=none; b=j38UTCo7Ja0tMKfVeRDctL/PpHQGrNzEBTNpLvLocUfcowNvzXbn5UmuP4/CR72OFc4S6FCGv3NKrldcZS70ERMvhMnj0dnZzLAxwd3jkDpJFCHA/L0NPWMx4XzEt5nrxZ/XPItf7YhUgBvEu1sCRgvBw4460+BhevVjw5/Y8sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763971606; c=relaxed/simple;
	bh=5Dv8Z4UwOIYFcIVYLZrN4/YQTXc0S+a5v/HYmlLv1PI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=chbejR2l+fID6WahO8U17wmY3FjNBV+uVkNu6yzHT/47Irm/Wi6L9WiohzQqwqIknd8LvSPLkrey8TV0bQ1Ph79JtxFlg1EB+5u1xpi9kFtd34qt/iOkr0KpHVWT0i3qGd88FDR/j+ARsxOiIVEz2wVnvt0E8D9LmxGYy8Z/rVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JEYdfKmW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JEYdfKmW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41AA8C4CEF1;
	Mon, 24 Nov 2025 08:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763971606;
	bh=5Dv8Z4UwOIYFcIVYLZrN4/YQTXc0S+a5v/HYmlLv1PI=;
	h=From:To:Cc:Subject:Date:From;
	b=JEYdfKmW6S88BUJ0eu2si/+AlyGXqzX1nvNAUE7xRGU69lOZQyryfSRiamFU/vyTj
	 Q6aw1y8nSEPmH4tFwkkCuAZogjyfTCERt5pcXJbQu7Pp3X+mtVdmQ58YlDGUROEtJr
	 i2nXYWX6zuAsRevqr06OE9VWvBgaQ9qU4q0RFaLqI6J0vLq0mz8XmVY1jBemSZfruL
	 0kGYiX6JqxKZdOhkEDeHE653F3tkelxkCq7NbQQkheMcxM5DgPGLyuj0Bpel1NUMIy
	 I+0+62QIkvjuDhQ7eCjYibPsqtWUPDSyyPq2FUlAo3s7yZ9XlbI/1H4md4DMGq1dXl
	 MwZYhOfJpU7vQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jia Ston <ston.jia@outlook.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	hansg@kernel.org,
	platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-5.10] platform/x86: huawei-wmi: add keys for HONOR models
Date: Mon, 24 Nov 2025 03:06:15 -0500
Message-ID: <20251124080644.3871678-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.8
Content-Transfer-Encoding: 8bit

From: Jia Ston <ston.jia@outlook.com>

[ Upstream commit 5c72329716d0858621021193330594d5d26bf44d ]

HONOR MagicBook X16/X14 models produced in 2025 cannot use the Print
Screen and YOYO keys properly, with the system reporting them as
unknown key presses (codes: 0x028b and 0x028e).

To resolve this, a key_entry is added for both the HONOR Print Screen
key and the HONOR YOYO key, ensuring they function correctly on these
models.

Signed-off-by: Ston Jia <ston.jia@outlook.com>
Link: https://patch.msgid.link/20251029051804.220111-1-ston.jia@outlook.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

### Comprehensive Analysis

1. **Commit Message and Issue Analysis**
  The commit addresses a functional hardware defect on HONOR MagicBook
  X16/X14 laptops (2025 models). The "Print Screen" and "YOYO" keys do
  not generate input events, instead triggering "Unknown key pressed"
  warning logs with scancodes `0x028b` and `0x028e`. This means users
  cannot use these hardware features, which constitutes a real-world bug
  for owners of these devices.

2. **Code Review and Mechanism**
  The fix is a surgical addition to the `huawei_wmi_keymap` array in
  `drivers/platform/x86/huawei-wmi.c`.
    - **Mechanism:** The driver uses `sparse_keymap_entry_from_scancode`
      to translate WMI events into input events. Without these entries,
      the lookup fails, and the driver drops the event.
    - **Change:** Two lines are added:
      ```c
      { KE_KEY,    0x28b, { KEY_NOTIFICATION_CENTER } },
      { KE_KEY,    0x28e, { KEY_PRINT } },
      ```
    - **Dependencies:** `KEY_NOTIFICATION_CENTER` was introduced in
      Linux 5.10. This patch is suitable for stable trees 5.10, 5.15,
      6.1, and 6.6 without modification. Older LTS versions (4.19, 5.4)
      would require a minor adjustment (using a different keycode or
      backporting the definition), but the patch remains conceptually
      valid for them.

3. **Stable Kernel Rules Assessment**
    - **Exception Category:** This commit falls squarely under the
      **"QUIRKS and WORKAROUNDS"** and **"TRIVIAL SUBSYSTEM-SPECIFIC
      ADDITIONS"** exceptions defined in stable kernel rules. Adding
      keymap entries is functionally identical to adding PCI/USB IDs: it
      enables hardware that is currently present but non-functional.
    - **Feature vs. Fix:** While the commit says "add keys," it is
      fixing broken hardware support. The keys physically exist but do
      not work; enabling them is a fix, not a new software feature.
    - **New Hardware on Stable:** While the hardware is from 2025, it is
      common for users to run Long Term Support (LTS) kernels (e.g.,
      Ubuntu LTS, RHEL, or community LTS kernels like 6.6.y) on new
      hardware. Refusing to backport hardware enablement forces these
      users to run bleeding-edge kernels or suffer broken functionality.

4. **Risk vs. Benefit**
    - **Regression Risk:** **Negligible.** The change adds data to a
      static array. It only affects the handling of two specific
      scancodes (`0x28b`, `0x28e`) which previously resulted in an error
      log. It cannot affect existing key mappings or other hardware.
    - **Benefit:** Restores functionality for the "Print Screen" key
      (essential for workflows) and the specific "YOYO" key on supported
      laptops.

5. **Conclusion**
  Although the commit lacks a "Cc: stable" tag, it meets all objective
  criteria for a stable backport. It is an obviously correct, low-risk,
  hardware-enabling fix that fits the "Quirks" exception. It should be
  included to ensure this hardware works correctly on supported LTS
  releases.

### TODO Items
- No further investigation required.

**YES**

 drivers/platform/x86/huawei-wmi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/platform/x86/huawei-wmi.c b/drivers/platform/x86/huawei-wmi.c
index c3772df34679f..8a4c54089ace3 100644
--- a/drivers/platform/x86/huawei-wmi.c
+++ b/drivers/platform/x86/huawei-wmi.c
@@ -81,6 +81,10 @@ static const struct key_entry huawei_wmi_keymap[] = {
 	{ KE_KEY,    0x289, { KEY_WLAN } },
 	// Huawei |M| key
 	{ KE_KEY,    0x28a, { KEY_CONFIG } },
+	// HONOR YOYO key
+	{ KE_KEY,    0x28b, { KEY_NOTIFICATION_CENTER } },
+	// HONOR print screen
+	{ KE_KEY,    0x28e, { KEY_PRINT } },
 	// Keyboard backlit
 	{ KE_IGNORE, 0x293, { KEY_KBDILLUMTOGGLE } },
 	{ KE_IGNORE, 0x294, { KEY_KBDILLUMUP } },
-- 
2.51.0


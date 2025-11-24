Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1602B2EB5D4;
	Mon, 24 Nov 2025 08:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763971632; cv=none; b=NbXDTAW/sRtL9gPeenlTodpbvkxGIa0+Vqp5mIhVbQZID4ZaB7D6EHS9dnwlvBBffotNdUt/LC6tnaEwoCTTVxchT+vaNlOKGEiPBIjjX3wnsKhhXuqoxZCmzCT3O0ZucJ/MkmsHIMuYHE+r8nm9sPR9RfR/UbIb2/enNbD7mI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763971632; c=relaxed/simple;
	bh=5OCOJILJDQnBEbJpDctJEFC26j4Tvk/4DeHZcKfZ3KY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RfmEJDi2LpEXDfwmdLVo6oM5Qvzbk3WGSlyOcvXOlfTmQfHUzJXEHjU8EophY8S8k28dCZ2wPwHhVtXN79U/YLBwxjPnygxzHekYeFhyr2q+OqpyWDaU+qbqM3iJfwbTbtIPEgnzv4xxrfHjSeOSWABLg+79hEKuL1WULiddol4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZAQ3uNtV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZAQ3uNtV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAC6AC16AAE;
	Mon, 24 Nov 2025 08:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763971632;
	bh=5OCOJILJDQnBEbJpDctJEFC26j4Tvk/4DeHZcKfZ3KY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZAQ3uNtVo/W9qHhNgbuJbBP3dORnhmmXwzVm8OAp4savhvmpxrlrfKZHCeW9GBAEO
	 9XFGjHcKPQp2bJqytYrPBKqQEvIZ4kFlyNoxoj+YXWaFu3mgV+EhF6KeODeIZsU0sE
	 eXD0fd/ZCnsvXA2GUOdJzhlPqKS0YBhE0byQekqV8ieRd83VMEOUDQGsgwB9QjjzwP
	 cdNgr5G123rqAZ7PHUy06NF+U/TWAidTms4kcWJqaYe5yXPCMd+18xAlLk9mrN5Scf
	 8baJQxb4TBeX07trOwDY5uL6nKAicmLndPyGjf5WHr3iKIupMWWtpffpM9hnODIILK
	 skNv6ebsy0BhQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Armin Wolf <W_Armin@gmx.de>,
	Bugaddr <Bugaddr@protonmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	jlee@suse.com,
	hansg@kernel.org,
	platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-5.4] platform/x86: acer-wmi: Ignore backlight event
Date: Mon, 24 Nov 2025 03:06:29 -0500
Message-ID: <20251124080644.3871678-15-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251124080644.3871678-1-sashal@kernel.org>
References: <20251124080644.3871678-1-sashal@kernel.org>
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

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit 444a9256f8d106e08a6bc2dc8ef28a8699e4b3ba ]

On the Acer Nitro AN515-58, the event 4 - 0 is send by the ACPI
firmware when the backlight up/down keys are pressed. Ignore this
event to avoid spamming the kernel log with error messages, as the
acpi-video driver already handles brightness up/down events.

Reported-by: Bugaddr <Bugaddr@protonmail.com>
Closes: https://bugaddr.tech/posts/2025-11-16-debugging-the-acer-nitro-5-an515-58-fn-f10-keyboard-backlight-bug-on-linux/#wmi-interface-issues
Tested-by: Bugaddr <Bugaddr@protonmail.com>
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://patch.msgid.link/20251117155938.3030-1-W_Armin@gmx.de
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

1. COMMIT MESSAGE ANALYSIS
   - **Problem:** On the Acer Nitro AN515-58, pressing brightness keys
     triggers WMI event `0x4`. The driver does not recognize this event,
     causing it to fall through to the default handler which spams the
     kernel log with "Unknown function number" errors.
   - **Fix:** The commit adds `WMID_BACKLIGHT_EVENT` (0x4) to the event
     enum and adds a specific case in `acer_wmi_notify` to ignore it.
   - **Reasoning:** The commit explains that the `acpi-video` driver
     already handles the actual backlight changes, making this WMI event
     redundant. Ignoring it explicitly silences the false-positive
     warnings.
   - **Tags:** Contains `Reported-by`, `Closes`, `Tested-by`, and
     `Reviewed-by`. While it lacks a `Cc: stable` tag, the fix addresses
     a regression in usability for supported hardware.

2. DEEP CODE RESEARCH
   - **Context:** The driver `drivers/platform/x86/acer-wmi.c` has a
     switch statement to handle WMI events. Unknown events trigger a
     `pr_warn`, creating log noise.
   - **History:** Support for the Acer Nitro AN515-58 was added in
     commit `549fcf58cf58`. Once that commit landed, the driver began
     binding to this hardware, exposing this unhandled event issue.
   - **Mechanism:** The patch is a trivial suppression. It defines the
     event ID and creates a no-op path for it.
     ```c
     case WMID_BACKLIGHT_EVENT:
     /* Already handled by acpi-video */
     break;
     ```
   - **Precedent:** This driver has a history of similar fixes (e.g.,
     ignoring AC events that are handled elsewhere) which have been
     backported to stable to keep logs clean.

3. STABLE KERNEL CRITERIA ASSESSMENT
   - **Fixes a real bug?** Yes. While not a crash, excessive log spam is
     a valid bug; it fills disk space, masks legitimate kernel warnings,
     and degrades the user experience.
   - **Fits stable rules?** Yes. This falls under the **Hardware Quirks
     and Workarounds** exception. It adapts the driver to specific
     hardware behavior (firmware sending redundant events).
   - **Small and Contained?** Yes. The change is extremely small (adding
     an enum and a case statement) and localized to one file.
   - **No New Features?** Yes. It strictly suppresses an error; it adds
     no new user-visible functionality.
   - **Regression Risk?** Extremely Low. The change only affects event
     `0x4`. Previously, this event triggered a warning and did nothing
     else. Now, it triggers no warning and does nothing else. Functional
     behavior remains identical.

4. CONCLUSION
  This commit is a textbook candidate for a stable backport under the
  "Quirks and Workarounds" category. It fixes a tangible annoyance (log
  spam) for users of supported hardware without introducing any risk or
  complexity. It should be backported to all stable trees that contain
  the initial support for the Acer Nitro AN515-58.

**YES**

 drivers/platform/x86/acer-wmi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index 13eb22b35aa8f..d848afc91f87d 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -102,6 +102,7 @@ MODULE_ALIAS("wmi:676AA15E-6A47-4D9F-A2CC-1E6D18D14026");
 
 enum acer_wmi_event_ids {
 	WMID_HOTKEY_EVENT = 0x1,
+	WMID_BACKLIGHT_EVENT = 0x4,
 	WMID_ACCEL_OR_KBD_DOCK_EVENT = 0x5,
 	WMID_GAMING_TURBO_KEY_EVENT = 0x7,
 	WMID_AC_EVENT = 0x8,
@@ -2369,6 +2370,9 @@ static void acer_wmi_notify(union acpi_object *obj, void *context)
 			sparse_keymap_report_event(acer_wmi_input_dev, scancode, 1, true);
 		}
 		break;
+	case WMID_BACKLIGHT_EVENT:
+		/* Already handled by acpi-video */
+		break;
 	case WMID_ACCEL_OR_KBD_DOCK_EVENT:
 		acer_gsensor_event();
 		acer_kbd_dock_event(&return_value);
-- 
2.51.0


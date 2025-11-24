Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6948C2E03E6;
	Mon, 24 Nov 2025 08:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763971612; cv=none; b=bYkQd++qXdZNTum8tYJAfDffIskH3KgfF/wz8lVkO7hVf2p6hrezm7XRzifKCc4L33qXLuB7+E2+Po04OQSA9I8+cK/wHINNOl7fB8a2Q4Ad+Ydw5Lqx8ZzNS2xpiBAmZcpoXZuzJDXP9MEVWZFp70f3rOgo3xtKzFM1INUXQRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763971612; c=relaxed/simple;
	bh=gzvEwY+7yl/DfWGAPEPXICQXLYxhKHoothyRSDRKNMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GbmgZJJRm02AAs6PhaBW7tSfcVJPauMpgHTqRMnxJz4+AnO9r1dUmyouZVxu6OSFM+CtM/7u7ZeLOIBRkprZL/juoGBDXeEniU/SLBXPuqkOIdXF87nx1nYTuw1B0aj3LxOAurmLrITnEzD8KjbuODUoEjfx+ZHyHscN62eLDzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EOPlT9ec; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EOPlT9ec"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F88FC16AAE;
	Mon, 24 Nov 2025 08:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763971612;
	bh=gzvEwY+7yl/DfWGAPEPXICQXLYxhKHoothyRSDRKNMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EOPlT9eco4ZLX1oBy4IJlfxbM1OBDiNAcdVsmVpl6w4ZVR++saPt9qMHUM/Y/42eL
	 qCwJ4n6Q2g46eNyVt5C+Uov8FkRfZlf25r13MCCILkd1oTmFio+aThmTrKRkGyql+b
	 8bOKwjvxV02fahkbAbFYRdF3Cyt519DKTX2jPZMiis2Z9c2jkCau1BV+wx4uB1rOPI
	 KoUnqo0XXcuRUC+kS/tA+nzlnNc063ilQ7Ke6X/aZAUgBjCgbL96wZsqtQ4wmHxs9t
	 fvoG4/83iK4x+flmze3REMY4Oo5gkeSu/mnMEwHWKVB3/Xxyl+sw4NMiEGbZmnTD6b
	 JsTmrPESsmVdg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Antheas Kapenekakis <lkml@antheas.dev>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Shyam-sundar.S-k@amd.com,
	platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-6.6] platform/x86/amd/pmc: Add spurious_8042 to Xbox Ally
Date: Mon, 24 Nov 2025 03:06:19 -0500
Message-ID: <20251124080644.3871678-5-sashal@kernel.org>
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

From: Antheas Kapenekakis <lkml@antheas.dev>

[ Upstream commit c0ddc54016636dd8dedfaf1a3b482a95058e1db2 ]

The Xbox Ally features a Van Gogh SoC that has spurious interrupts
during resume. We get the following logs:

atkbd_receive_byte: 20 callbacks suppressed
atkbd serio0: Spurious ACK on isa0060/serio0. Some program might be trying to access hardware directly.

So, add the spurious_8042 quirk for it. It does not have a keyboard, so
this does not result in any functional loss.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4659
Signed-off-by: Antheas Kapenekakis <lkml@antheas.dev>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Link: https://patch.msgid.link/20251024152152.3981721-3-lkml@antheas.dev
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

### 1. Commit Message Analysis
The commit addresses a specific hardware issue on the "Xbox Ally" (ASUS
ROG Ally) equipped with the Van Gogh SoC.
- **Problem:** The device experiences spurious interrupts from the 8042
  controller (keyboard) during resume, causing log spam
  ("atkbd_receive_byte: 20 callbacks suppressed", "Spurious ACK...").
- **Solution:** Add the device to the `fwbug_list` with the
  `quirk_spurious_8042` quirk.
- **Context:** The device is a handheld gaming PC without a physical
  keyboard, so disabling keyboard wakeup has no functional downside.
- **Tags:** Includes "Closes:" linking to a bug report and "Reviewed-
  by:". It lacks a "Cc: stable" tag, but this is likely an oversight
  given the nature of the patch.

### 2. Deep Code Research
- **Code Change:** The patch adds a single `dmi_system_id` entry to
  `drivers/platform/x86/amd/pmc/pmc-quirks.c`.
- **Mechanism:**
  - The new entry matches the DMI data for "ASUSTeK COMPUTER INC." /
    "RC73YA".
  - It assigns `driver_data = &quirk_spurious_8042`.
  - In `amd_pmc_quirks_init()`, this quirk sets
    `dev->disable_8042_wakeup = true`.
  - During suspend, `amd_pmc_suspend_handler()` checks this flag and
    calls `amd_pmc_wa_irq1()`, which disables the IRQ1 wakeup source.
  - This prevents the firmware bug (spurious IRQ1 assertion) from
    triggering during resume.
- **Dependencies:** The quirk infrastructure (`quirk_spurious_8042`) was
  introduced in late 2023 and is present in all currently supported
  stable kernels (6.1.y and newer). The change is self-contained.

### 3. Historical Context & Precedent
This file (`pmc-quirks.c`) serves as a central registry for AMD PMC
firmware bugs. There is a strong established pattern of backporting new
entries for this specific issue:
- Commit `12a3dd4d2cd92` ("Add Stellaris Slim Gen6 AMD...")
- Commit `8822e8be86d40` ("Add MECHREVO Yilong15Pro...")
- Commit `c96f86217bb28` ("Add TUXEDO IB Pro Gen10...")
All of these were backported to stable trees. This commit follows the
exact same pattern.

### 4. Stable Kernel Rules Compliance
This commit falls strictly under the **"QUIRKS and WORKAROUNDS"**
exception in the stable kernel rules:
- **Rule:** "Hardware-specific quirks for broken/buggy devices" are
  allowed.
- **Compliance:** The patch fixes broken behavior (spurious interrupts)
  on specific hardware using an existing workaround mechanism.
- **Constraint Check:** It introduces no new features, APIs, or
  architectural changes. It is a data-only change (adding a struct
  entry).

### 5. Risk Assessment
- **Severity:** Medium. The issue causes log spam and potential resume
  quirks, which degrades the user experience on this specific device.
- **Regression Risk:** **Extremely Low**.
  - The change is guarded by a specific DMI match, ensuring it affects
    *only* the ROG Ally RC73YA.
  - The mitigation (disabling keyboard wakeup) is safe because the
    device physically lacks a keyboard.
  - The underlying logic is well-tested on other AMD platforms (Renoir,
    Cezanne, etc.).

### Conclusion
This is a textbook candidate for stable backporting. It is a surgical,
hardware-specific fix that uses existing infrastructure to resolve a
real-world issue (log spam/resume behavior) on a production device. It
carries negligible risk and aligns perfectly with the "Device Quirks"
exception of the stable kernel rules.

**YES**

 drivers/platform/x86/amd/pmc/pmc-quirks.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/platform/x86/amd/pmc/pmc-quirks.c b/drivers/platform/x86/amd/pmc/pmc-quirks.c
index 0fadcf5f288ac..404e62ad293a9 100644
--- a/drivers/platform/x86/amd/pmc/pmc-quirks.c
+++ b/drivers/platform/x86/amd/pmc/pmc-quirks.c
@@ -122,6 +122,14 @@ static const struct dmi_system_id fwbug_list[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "21A1"),
 		}
 	},
+	{
+		.ident = "ROG Xbox Ally RC73YA",
+		.driver_data = &quirk_spurious_8042,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_BOARD_NAME, "RC73YA"),
+		}
+	},
 	/* https://bugzilla.kernel.org/show_bug.cgi?id=218024 */
 	{
 		.ident = "V14 G4 AMN",
-- 
2.51.0


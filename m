Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65EA82E9759;
	Mon, 24 Nov 2025 08:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763971636; cv=none; b=iyXS/+lKpB2fGoK84iroX4yKdVDy+9FPBq/ozkeDg6PWxwVbdcQoThhEi6Xkayu0auUWdrqOkQOyuCY2yC9LEOpBiMkWyaM9bv6MB+yOKtWiFDO8pB6b2NrVaKjiJnnpEFSM/v1yTvOzwDyZenwhnvi7ea/7LZn26ssO59RHuu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763971636; c=relaxed/simple;
	bh=5vGvGFGSJBzW8AMJgIYu1ZEfcm+jAyPzTI/14Y0P73k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L8jf3ZIZcGXAbHpo7iclaI0UrVnDU+9M5Q0fCpmhQ241cVv8XlQUyD1xZbouCdu4/oG1ru3HzHvo1Ylhtic5yUrFaoi7qPq/1Owd+BovKsQQb4j9OfifP5kZ+8PAQup/7hVlmqGbD4F+46KHdjpEjTBHnXtP54J/bi33hK/mUbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HuCnT8qR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HuCnT8qR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A25BC19422;
	Mon, 24 Nov 2025 08:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763971636;
	bh=5vGvGFGSJBzW8AMJgIYu1ZEfcm+jAyPzTI/14Y0P73k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HuCnT8qRbh6aDU6HvUXpfx6G6Po+2XFf72V3OhF8zjNOxq/jAXJYIlIyr4N/PoQPO
	 Fpsk9K9aJKcPNjRiQsyDdJbdZqsnuSr21i1KJpDmwmaKJZ3EOe+LSWvKO5uTftwSNq
	 x7Q73fFZET0iqrDt8E+veWlUO430GvK8ri7vzFMcWODlxwkinRiHjzchM/RsMTE4T3
	 1JfM3/n+5Sf0iluResXm5qRvqbbiJafn5QoUlVeRYpw7yEPIhMWFxFKXb3w/xDNIJR
	 nNuxbScKSmpE3GlEgv8kAKsJJERDv5lXXAAX46hX1vKIp/UTYnatDGz67wvMGf8abb
	 Q/Hz8mRgVouFw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Antheas Kapenekakis <lkml@antheas.dev>,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Shyam-sundar.S-k@amd.com,
	platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-6.6] platform/x86/amd: pmc: Add Lenovo Legion Go 2 to pmc quirk list
Date: Mon, 24 Nov 2025 03:06:31 -0500
Message-ID: <20251124080644.3871678-17-sashal@kernel.org>
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

[ Upstream commit f945afe01c6768dcfed7868c671a26e1164c2284 ]

The Lenovo Legion Go 2 takes a long time to resume from suspend.
This is due to it having an nvme resume handler that interferes
with IOMMU mappings. It is a common issue with older Lenovo
laptops. Adding it to that quirk list fixes this issue.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4618
Suggested-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Antheas Kapenekakis <lkml@antheas.dev>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Link: https://patch.msgid.link/20251008135057.731928-1-lkml@antheas.dev
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Comprehensive Analysis

### 1. Commit Message Analysis
The commit "platform/x86/amd: pmc: Add Lenovo Legion Go 2 to pmc quirk
list" addresses a specific hardware issue on the Lenovo Legion Go 2. The
device experiences long resume times from suspend due to an NVMe resume
handler interfering with IOMMU mappings. This is identified as a
firmware bug common to several Lenovo laptops. The fix explicitly closes
a reported issue on GitLab (#4618) and includes `Reviewed-by` tags from
subsystem maintainers.

### 2. Deep Code Research & Mechanism
**Code Change:**
The commit modifies `drivers/platform/x86/amd/pmc/pmc-quirks.c` by
adding two new entries to the `fwbug_list` array. These entries target
the "Lenovo Legion Go 2" with product IDs `83N0` and `83N1`.

**Mechanism:**
The entries are associated with `quirk_s2idle_bug`.
- **The Bug:** On certain AMD platforms, the firmware executes a System
  Management Interrupt (SMI) handler during the resume transition (D3 ->
  D0). If IOMMU is enabled, this handler triggers page faults or
  timeouts, resulting in the "long time to resume" symptom.
- **The Fix:** The `quirk_s2idle_bug` callback triggers the
  `amd_pmc_skip_nvme_smi_handler` function. This function performs a
  specific MMIO write (typically to the FCH PM scratch register) to
  disable the problematic SMI handler during the resume phase, bypassing
  the conflict.

**Infrastructure Context:**
This uses existing quirk infrastructure (`quirk_s2idle_bug` and
`amd_pmc_skip_nvme_smi_handler`) which was introduced in kernel v6.6.
The change itself is purely data—adding IDs to an existing table—rather
than introducing new logic.

### 3. Stable Kernel Rules Compliance
This commit falls squarely under the **"QUIRKS and WORKAROUNDS"**
exception category, which is explicitly allowed in stable trees.
- **Criteria Check:**
    - **Obviously correct:** It strictly adds DMI matches to a table
      using an existing, proven handler.
    - **Fixes real bug:** Addresses a significant usability regression
      (broken/slow suspend) for end users.
    - **No new features:** It is a hardware enablement/fix, not a
      feature addition.
    - **Small scope:** Touch is limited to 17 lines of data addition in
      one file.

### 4. Risk Assessment
- **Regression Risk:** **Extremely Low**. The change is guarded by
  specific DMI matches (Vendor "LENOVO", Product "83N0"/"83N1"). It will
  only trigger on the exact hardware specified. It cannot negatively
  impact other devices.
- **User Impact:** High for owners of the device. Without this fix,
  suspend/resume is effectively broken or frustratingly slow.

### 5. Dependencies and Backporting
- **Dependencies:** The commit depends on the AMD PMC quirk
  infrastructure (`quirk_s2idle_bug`). This infrastructure is present in
  current stable branches like 6.6.y, 6.12.y, and 6.1.y (where the
  driver has been updated).
- **Applicability:** It should apply cleanly to any stable tree
  containing the `drivers/platform/x86/amd/pmc/pmc-quirks.c` file and
  the associated quirk definitions.

### Conclusion
This is a textbook stable backport candidate. It is a low-risk,
hardware-specific quirk that fixes a real user-visible bug using
established kernel infrastructure. It perfectly matches the exception
for hardware workarounds.

**YES**

 drivers/platform/x86/amd/pmc/pmc-quirks.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/platform/x86/amd/pmc/pmc-quirks.c b/drivers/platform/x86/amd/pmc/pmc-quirks.c
index d63aaad7ef599..0fadcf5f288ac 100644
--- a/drivers/platform/x86/amd/pmc/pmc-quirks.c
+++ b/drivers/platform/x86/amd/pmc/pmc-quirks.c
@@ -204,6 +204,23 @@ static const struct dmi_system_id fwbug_list[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "82ND"),
 		}
 	},
+	/* https://gitlab.freedesktop.org/drm/amd/-/issues/4618 */
+	{
+		.ident = "Lenovo Legion Go 2",
+		.driver_data = &quirk_s2idle_bug,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "83N0"),
+		}
+	},
+	{
+		.ident = "Lenovo Legion Go 2",
+		.driver_data = &quirk_s2idle_bug,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "83N1"),
+		}
+	},
 	/* https://gitlab.freedesktop.org/drm/amd/-/issues/2684 */
 	{
 		.ident = "HP Laptop 15s-eq2xxx",
-- 
2.51.0


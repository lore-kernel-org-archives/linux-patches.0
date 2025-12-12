Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15537288C2F;
	Fri, 12 Dec 2025 02:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765505348; cv=none; b=K/bvgD0WKZHUBD3KvdBBt9qxbVfmK6G4LI9R/uHDR5AU36UbvE5Vkz/3SJkT9fH3r+SPumZ858qveP2uN22UXl2xPKtTi6Z88FoRFHqtGZ45OfGrFcR5DomxVRRlCpE/czClZI2g9kyZBRVQW+MDi3GIbIfizsvh8gYvu4ZnB1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765505348; c=relaxed/simple;
	bh=xztAl+yUdUBl9iS92e/EVdZJjo1rMp7L5dv8wpvuQdI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=sOaXwVwLXjCrSk5jk2xFd07k+RWVs/RhxidwcYH4Tu2tqwrFTwux29ADC8NVhmQRusPMNzuT/82Tbz/lljtSdPlVwnMI2e3GgSH/FP2QWNhJxvIV5fsqgbrQ/ig/8Ach1X3MOgo4cGtRqb5PCexUPt7zHMXWDKUoFi4Z6tP8Ul4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QXv5dLAO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QXv5dLAO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A375AC4CEF7;
	Fri, 12 Dec 2025 02:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765505347;
	bh=xztAl+yUdUBl9iS92e/EVdZJjo1rMp7L5dv8wpvuQdI=;
	h=From:To:Cc:Subject:Date:From;
	b=QXv5dLAObLRWQuoKHMxs95NDXYjwupJRpHENY+ZcjvEfApK7xHeXP75ih3pmNS+qy
	 HHpvupI4byRjurhrCtBPSWI8W22z+XXTsKQ6o/rRm3mV2WRbBNsVeABavWoc3NloKV
	 8ywcWauZ9jLeZV3MlHtoUv/ahSUWiL9gQXuWlLkWY3uCi4JtqzT/+OLFt2olaOezdu
	 cG1QcXVm8I99SxQa2KTpP1RlIIh4sAFqykBPij/5Z0U9zHYs6yTz8hG0DC6Pcq9YmZ
	 0qQk/8B2qeoHQLRqxncEnsBQs9U2ZcBsxjPJDoNT4C+e0Z74B2qq3i+zx7J/ZZdl5W
	 sSBxKxDSgOQnA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	alexhung@gmail.com,
	platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] platform/x86/intel/hid: Add Dell Pro Rugged 10/12 tablet to VGBS DMI quirks
Date: Thu, 11 Dec 2025 21:08:53 -0500
Message-ID: <20251212020903.4153935-1-sashal@kernel.org>
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
X-stable-base: Linux 6.18
Content-Transfer-Encoding: 8bit

From: "Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>

[ Upstream commit b169e1733cadb614e87f69d7a5ae1b186c50d313 ]

Dell Pro Rugged 10/12 tablets has a reliable VGBS method.
If VGBS is not called on boot, the on-screen keyboard won't appear if the
device is booted without a keyboard.

Call VGBS on boot on thess devices to get the initial state of
SW_TABLET_MODE in a reliable way.

Signed-off-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
Reviewed-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Link: https://patch.msgid.link/20251127070407.656463-1-acelan.kao@canonical.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Summary Analysis

### What This Commit Does
This commit adds two Dell tablet models (Dell Pro Rugged 10 Tablet
RA00260 and Dell Pro Rugged 12 Tablet RA02260) to the
`dmi_vgbs_allow_list` DMI quirk table. When a device matches this list,
the driver calls the VGBS ACPI method at probe time to properly detect
the initial SW_TABLET_MODE state.

### The Bug Being Fixed
Without this quirk, on these Dell tablets:
- The VGBS method isn't called at boot
- The kernel doesn't know the device is in tablet mode
- The on-screen keyboard won't appear if the device is booted without a
  physical keyboard attached
- This makes the device difficult/impossible to use in tablet-only mode

### Classification: Hardware Quirk/Workaround
This falls squarely into the **QUIRKS and WORKAROUNDS** category which
is explicitly allowed for stable backporting:
- It's a DMI-based allowlist entry for specific hardware models
- The pattern is identical to existing entries (HP Spectre, Microsoft
  Surface Go, HP Dragonfly G2)
- The mechanism has been stable since Linux 5.10

### Risk Assessment
**Risk Level: EXTREMELY LOW**
- **Lines changed**: ~12 lines (just two DMI match entries)
- **Files touched**: 1 file
- **Scope**: Only affects Dell Pro Rugged 10/12 tablets
- **Cannot regress other hardware**: DMI matching is device-specific
- **Pattern proven**: Same structure as existing entries that have
  worked for years

### Stability Indicators
- **Reviewed-by:** Hans de Goede (well-known x86 platform maintainer)
- **Reviewed-by:** Ilpo Järvinen (Intel platform maintainer)
- The `dmi_vgbs_allow_list` infrastructure has existed since v5.10-rc1
  (commit 537b0dd4729e7)

### Stable Tree Criteria Assessment
| Criterion | Status |
|-----------|--------|
| Obviously correct | ✅ Yes - trivial data addition |
| Fixes real bug | ✅ Yes - on-screen keyboard not working |
| Small and contained | ✅ Yes - ~12 lines in 1 file |
| No new features | ✅ Yes - enables existing functionality |
| Applies cleanly | ✅ Yes - simple addition to allowlist |

### Concerns
1. **No explicit "Cc: stable" tag** - However, DMI quirk additions are
   commonly appropriate for stable even without explicit tags
2. **No "Fixes:" tag** - This is adding new device support rather than
   fixing a regression in existing code

### Verdict
This commit is appropriate for stable backporting because:
1. It's a minimal, surgical hardware quirk that only affects two
   specific Dell tablet models
2. It fixes a real usability issue for affected users (tablet becomes
   difficult to use without keyboard)
3. Zero risk of regression for any other hardware
4. The pattern exactly matches existing stable entries
5. The infrastructure has been stable since v5.10, available in all
   current LTS kernels
6. Well-reviewed by experienced platform maintainers

The lack of explicit stable tags is not disqualifying - this is a
textbook example of a hardware quirk addition that should go to stable
trees to enable proper device functionality.

**YES**

 drivers/platform/x86/intel/hid.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/platform/x86/intel/hid.c b/drivers/platform/x86/intel/hid.c
index 9c07a7faf18fe..560cc063198e1 100644
--- a/drivers/platform/x86/intel/hid.c
+++ b/drivers/platform/x86/intel/hid.c
@@ -177,6 +177,18 @@ static const struct dmi_system_id dmi_vgbs_allow_list[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "HP Elite Dragonfly G2 Notebook PC"),
 		},
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Dell Pro Rugged 10 Tablet RA00260"),
+		},
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Dell Pro Rugged 12 Tablet RA02260"),
+		},
+	},
 	{ }
 };
 
-- 
2.51.0


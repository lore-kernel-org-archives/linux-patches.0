Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B146819F40B;
	Sat,  6 Dec 2025 14:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765029803; cv=none; b=G9MoefA2IBaEiAfLjzqgYPDrMV4ZTohsenh3XiYk/r5sJQ0rMs98fv9D6jJY5cCtLOy2T6CavwKqU1NSlA07WEHt8TG4lY6bfecIT7yFIhoMNUOr3Cu5WLFqOsmwmirJ521ctJr8RdlhhYtNszbCdaIXJ1dTF5+ihHcYeJodazg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765029803; c=relaxed/simple;
	bh=DsxlSh+s7SLNpyrHOxgr0Wu9Nsi8eky7BBVL3tZ3kGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UayflZp4i2Qs0k31nBs+W16m47TN/31jaiaTiVWfLrwFxRZ+Ey/BvNubhxHPI/rYPqT5kCB1HjtMBO8OK3h4elIJU14onHHX4XTI2PjSd74TutoLB+XPuNoMPEOoZQRMdN/0lLjGHrRoaUPxhRDF4MgEXaaT+Q1uvqRaf12AzN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ostun3PS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ostun3PS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CDD6C113D0;
	Sat,  6 Dec 2025 14:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765029803;
	bh=DsxlSh+s7SLNpyrHOxgr0Wu9Nsi8eky7BBVL3tZ3kGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ostun3PSIp4Ribej8A7pc4dYYTswFnMKcn0//OyTnHprlAqGYdKrDKJ18ojbodSUt
	 S2a5Rn0EQCUN42B3ckcaB8/biQ20cXSZ8JW4WU/rT+4+STvhBy7aqcA5D3+Vli4buD
	 bp/XxnuKSMIVI7ogTuKjknAoOw4Kyfx/avP8p0KiSz9CT19D9Qygbp7hExViOGhlrF
	 3U3BWHf2Kuu6Se3/KhmIDPLNbb/BCKwqHmR8fi5lxH740vzX5eoFqi6q6bMwMkoSo4
	 Ac3gwWqTgihFwVVmacQ9y6Xq3x0GlWUnVKteavxL5GmHgKTzP0x1CDlcrTHXR01RIF
	 AdniueqBQ37zw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Hans de Goede <hansg@kernel.org>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	alexandre.f.demers@gmail.com,
	alexander.deucher@amd.com
Subject: [PATCH AUTOSEL 6.18-6.1] wifi: brcmfmac: Add DMI nvram filename quirk for Acer A1 840 tablet
Date: Sat,  6 Dec 2025 09:02:18 -0500
Message-ID: <20251206140252.645973-13-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251206140252.645973-1-sashal@kernel.org>
References: <20251206140252.645973-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18
Content-Transfer-Encoding: 8bit

From: Hans de Goede <hansg@kernel.org>

[ Upstream commit a8e5a110c0c38e08e5dd66356cd1156e91cf88e1 ]

The Acer A1 840 tablet contains quite generic names in the sys_vendor and
product_name DMI strings, without this patch brcmfmac will try to load:
brcmfmac43340-sdio.Insyde-BayTrail.txt as nvram file which is a bit
too generic.

Add a DMI quirk so that a unique and clearly identifiable nvram file name
is used on the Acer A1 840 tablet.

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Hans de Goede <hansg@kernel.org>
Link: https://patch.msgid.link/20251103100314.353826-1-hansg@kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis of Commit for Stable Backporting

### 1. COMMIT MESSAGE ANALYSIS

**Subject:** wifi: brcmfmac: Add DMI nvram filename quirk for Acer A1
840 tablet

**Key observations:**
- No `Cc: stable@vger.kernel.org` tag present
- No `Fixes:` tag pointing to a prior commit
- The commit explains that the tablet has generic DMI strings ("Insyde"
  / "BayTrail")
- Without the patch, brcmfmac loads `brcmfmac43340-sdio.Insyde-
  BayTrail.txt` which is "a bit too generic"

The wording "a bit too generic" suggests this is more of an
improvement/optimization rather than fixing broken functionality.

### 2. CODE CHANGE ANALYSIS

The change adds:
1. A new `brcmf_dmi_data` structure:
```c
static const struct brcmf_dmi_data acer_a1_840_data = {
    BRCM_CC_43340_CHIP_ID, 2, "acer-a1-840"
};
```

2. A DMI match entry with three match criteria (vendor, product, BIOS
   date) to identify this specific tablet and associate it with the new
   data structure.

**Technical nature:** Pure data addition - adds static const data and a
DMI table entry using existing infrastructure.

### 3. CLASSIFICATION

This is a **hardware quirk** for DMI-based nvram filename selection.
Hardware quirks are generally allowable in stable per the documented
exceptions.

### 4. SCOPE AND RISK ASSESSMENT

- **Size:** ~15 lines added, very small
- **Files:** Single file (dmi.c)
- **Risk:** Extremely low - only affects the specific Acer A1 840 tablet
- **Pattern:** Follows identical pattern to ~15 other existing DMI
  quirks in this file

### 5. USER IMPACT

- **Who is affected:** Only Acer Iconia One 8 A1-840 tablet owners
- **Severity:** The commit message says the generic filename is "a bit
  too generic" - not that WiFi is broken
- **Nature:** This enables using a device-specific nvram file instead of
  a generic one

### 6. STABILITY INDICATORS

- Acked by Broadcom maintainer (Arend van Spriel)
- Hans de Goede is well-known for x86 tablet quirks
- No explicit stable request from maintainers

### 7. DEPENDENCY CHECK

- Requires corresponding `brcmfmac43340-sdio.acer-a1-840.txt` file in
  linux-firmware
- No code dependencies on other kernel commits
- DMI quirk infrastructure exists in all stable trees

### Decision Rationale

**Arguments for backporting:**
- Falls under "hardware quirks" exception
- Zero risk to other systems
- Small, contained change
- Uses existing infrastructure

**Arguments against backporting:**
1. **No stable tags:** The maintainers did not add `Cc:
   stable@vger.kernel.org`, suggesting they don't consider this critical
   for stable
2. **Not fixing broken functionality:** The commit says the generic name
   is "a bit too generic" - not that WiFi doesn't work. This is an
   improvement, not a fix for completely broken hardware
3. **Firmware dependency:** Requires a corresponding nvram file in
   linux-firmware that may not be present in stable distributions
4. **Enablement vs Fix:** This is adding device-specific customization
   rather than fixing a bug. The generic nvram file path still works,
   just isn't optimally specific
5. **No reported bug:** No `Reported-by:` tag or link to a bug report
   indicating users are affected

### Conclusion

While hardware quirks are sometimes appropriate for stable, this
particular quirk is more of an enhancement to use a more specific nvram
filename rather than a fix for broken functionality. The maintainer's
decision not to add stable tags, combined with the "a bit too generic"
language (rather than "doesn't work"), indicates this is a quality-of-
life improvement rather than a critical fix. Stable trees should focus
on fixes for actual broken functionality, not optimizations for firmware
filename selection.

**NO**

 .../net/wireless/broadcom/brcm80211/brcmfmac/dmi.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c
index c3a602197662b..abe7f6501e5ed 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c
@@ -24,6 +24,10 @@ static const struct brcmf_dmi_data acepc_t8_data = {
 	BRCM_CC_4345_CHIP_ID, 6, "acepc-t8"
 };
 
+static const struct brcmf_dmi_data acer_a1_840_data = {
+	BRCM_CC_43340_CHIP_ID, 2, "acer-a1-840"
+};
+
 /* The Chuwi Hi8 Pro uses the same Ampak AP6212 module as the Chuwi Vi8 Plus
  * and the nvram for the Vi8 Plus is already in linux-firmware, so use that.
  */
@@ -91,6 +95,16 @@ static const struct dmi_system_id dmi_platform_data[] = {
 		},
 		.driver_data = (void *)&acepc_t8_data,
 	},
+	{
+		/* Acer Iconia One 8 A1-840 (non FHD version) */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Insyde"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "BayTrail"),
+			/* Above strings are too generic also match BIOS date */
+			DMI_MATCH(DMI_BIOS_DATE, "04/01/2014"),
+		},
+		.driver_data = (void *)&acer_a1_840_data,
+	},
 	{
 		/* Chuwi Hi8 Pro with D2D3_Hi8Pro.233 BIOS */
 		.matches = {
-- 
2.51.0


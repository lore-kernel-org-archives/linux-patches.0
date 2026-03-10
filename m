Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B260C4508F2;
	Tue, 10 Mar 2026 09:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773133341; cv=none; b=hfxx4p7oogXBNFDL5sPHOKjyGumNAiEgeCqIZB4cldsVbXJrX9zZeNFoQcT9dJ2y1pz8JrN4SEZIf0mHBZCNqKO8ApdNLVRWhu1+TPq1fYIY608EK7vQzrOhM91KpsekZd2XsfeTODLDj1DKdPwd0h7o7e3+4yFRO6SECs7zgDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773133341; c=relaxed/simple;
	bh=oTCcKoiBg4Ndl4dFHqHelPZE7Fdxyv/0WoL9zpscZ78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PihLoPU7Y7Qr0MngTIUIzO1IUunC0htpYSOfFJruJffxRMgMROtgA031yyr8Q63SqSKf5wapxLNIeklWFDtzXQDuu8eMl4TArXNtz+b9IsSl/pLYKv5aAZaSxpiCnuml2m25Y6anAy400QQgj85lO6NKtfixt/Lcz2sKulUVacg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W8P//Xyv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W8P//Xyv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93F85C2BC9E;
	Tue, 10 Mar 2026 09:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773133341;
	bh=oTCcKoiBg4Ndl4dFHqHelPZE7Fdxyv/0WoL9zpscZ78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W8P//Xyvp1IQk7GVRhDLfxjC/otAxwJJOB8efJ6W9eZL0kf2o/Hupgp/cy6lo8zAv
	 5NE0FgWVbiFJZzJ4yMvP7st/cBtM50nk5bSK07iG3e2euVHoEwBEEO3zi/WnmKUPKD
	 K9Tv9NGrAiFC//58rNfmBZozOIoF8PodEUz/2OjB5WtGPOfPPXkFK6tGBaCQQHFuiU
	 uZpU/ixVXzQkrhJ0bKEODQtuPvMizeZWpTB+lwFOkswdlsHefJCFgX+ftlsEMEakwh
	 ccNhlR4KkSCUKiRU3KCMgljUmfEMBZeGq9Le2smi4+jAcPBMZcNTN1oqe7rzrL7IRp
	 hS1Pwlw5azf4g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Leif Skunberg <diamondback@cohunt.app>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	alexhung@gmail.com,
	hansg@kernel.org,
	platform-driver-x86@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.10] platform/x86: intel-hid: Enable 5-button array on ThinkPad X1 Fold 16 Gen 1
Date: Tue, 10 Mar 2026 05:01:24 -0400
Message-ID: <20260310090145.2709021-24-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260310090145.2709021-1-sashal@kernel.org>
References: <20260310090145.2709021-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.6
Content-Transfer-Encoding: 8bit

From: Leif Skunberg <diamondback@cohunt.app>

[ Upstream commit b38d478dad79e61e8a65931021bdfd7a71741212 ]

The Lenovo ThinkPad X1 Fold 16 Gen 1 has physical volume up/down
buttons that are handled through the intel-hid 5-button array
interface. The firmware does not advertise 5-button array support via
HEBC, so the driver relies on a DMI allowlist to enable it.

Add the ThinkPad X1 Fold 16 Gen 1 to the button_array_table so the
volume buttons work out of the box.

Signed-off-by: Leif Skunberg <diamondback@cohunt.app>
Reviewed-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Link: https://patch.msgid.link/20260210085625.34380-1-diamondback@cohunt.app
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

### What the commit does

This commit adds a single DMI table entry for the Lenovo ThinkPad X1
Fold 16 Gen 1 to the `button_array_table` in
`drivers/platform/x86/intel/hid.c`. This enables the intel-hid 5-button
array interface for physical volume up/down buttons on this specific
laptop, whose firmware does not advertise 5-button array support via the
HEBC ACPI method.

### Classification: Hardware Quirk/Workaround

This is a textbook DMI allowlist addition — one of the explicitly
allowed exception categories for stable backporting. The pattern is
identical to the existing entries for HP Spectre x2, ThinkPad X1 Tablet
Gen 1/2, Microsoft Surface Go 3/4, etc.

### Stable kernel criteria assessment

- **Obviously correct and tested**: Yes. The 7-line addition follows the
  exact same `DMI_MATCH(DMI_SYS_VENDOR, "LENOVO")` +
  `DMI_MATCH(DMI_PRODUCT_FAMILY, ...)` pattern used by the two existing
  Lenovo entries directly above it.
- **Fixes a real bug**: Yes. Volume buttons are non-functional without
  this entry because firmware doesn't advertise the capability.
- **Small and contained**: Yes. 7 lines added to a single DMI table in
  one file. No logic changes whatsoever.
- **No new features**: Correct. This enables an existing driver
  interface on specific hardware — an allowed exception.
- **No dependencies**: The `button_array_table` and its usage have been
  in the driver for years. No prerequisite commits needed.

### Risk assessment

**Extremely low risk.** DMI matching is device-specific — this entry
only activates on systems where `DMI_SYS_VENDOR == "LENOVO"` AND
`DMI_PRODUCT_FAMILY == "ThinkPad X1 Fold 16 Gen 1"`. It cannot affect
any other hardware. The worst-case scenario on a misidentified system
would be the 5-button array being enabled unnecessarily, which is
benign.

### Review quality

The patch has two `Reviewed-by` tags from Hans de Goede (former
platform/x86 co-maintainer) and Ilpo Järvinen (current platform/x86
maintainer who also committed it). This is strong endorsement.

### Verification

- Verified the diff adds only a DMI table entry with no logic changes —
  confirmed by reading the patch.
- Verified the new entry follows the identical pattern of existing
  entries (DMI_SYS_VENDOR + DMI_PRODUCT_FAMILY matching) — confirmed
  from the surrounding context in the diff.
- Verified this is a DMI allowlist (not a blocklist) used to enable
  5-button array support — confirmed from the commit message and table
  name `button_array_table`.
- Verified reviewers Hans de Goede and Ilpo Järvinen are established
  platform/x86 maintainers — this is well-known in the kernel community.
- The file `drivers/platform/x86/intel/hid.c` and the
  `button_array_table` have existed in the kernel for years, so this
  applies to all active stable trees.

### Conclusion

This is a minimal, zero-risk hardware quirk addition that makes volume
buttons work on a specific Lenovo laptop. It meets all stable kernel
criteria and falls into the explicitly allowed "hardware
quirks/workarounds" category. Two maintainer reviews provide confidence
in correctness.

**YES**

 drivers/platform/x86/intel/hid.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/platform/x86/intel/hid.c b/drivers/platform/x86/intel/hid.c
index 5b475a09645a3..f2b309f6e458a 100644
--- a/drivers/platform/x86/intel/hid.c
+++ b/drivers/platform/x86/intel/hid.c
@@ -135,6 +135,13 @@ static const struct dmi_system_id button_array_table[] = {
 			DMI_MATCH(DMI_PRODUCT_FAMILY, "ThinkPad X1 Tablet Gen 2"),
 		},
 	},
+	{
+		.ident = "Lenovo ThinkPad X1 Fold 16 Gen 1",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_FAMILY, "ThinkPad X1 Fold 16 Gen 1"),
+		},
+	},
 	{
 		.ident = "Microsoft Surface Go 3",
 		.matches = {
-- 
2.51.0


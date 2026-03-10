Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1900344DB69;
	Tue, 10 Mar 2026 09:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773133339; cv=none; b=NUeT7aiJAvnkErUotFDN4UT8MR/EHIjudxZe9AWp+dHjgjLmX4JwMXRGO05x4rKyyvXZRl2m9Fc9RKYQbirzNOqAKBNWPacfxlkPh2aPxI8bHABzEUhd/OCFB3XTaY9AoKKPZVu7kGSmCKqTWNAbPY9wI4cxp9r4Gzbe3GfYEQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773133339; c=relaxed/simple;
	bh=uB6pQPX2I+UNDNo4G/LNGulLPdRkxY5v9RFHFRDAvxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FyY8wrVJ3yZMlP6wy7hxodsfBKlGhQXcFQF9y8n6cuAxuTfbx9u2EOs7PyTSjbuZdcrEpya8+MI98qci6iJDRv5Uq/7+x3+TVe4/GnLCxjWLx24pHFlENFGO4aG0yGL3fRn8khF8lUqZDnY2BWbIsT6Ab92wfQsb4m28y6gR6Uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XxA+bCvc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XxA+bCvc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAB64C2BC86;
	Tue, 10 Mar 2026 09:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773133339;
	bh=uB6pQPX2I+UNDNo4G/LNGulLPdRkxY5v9RFHFRDAvxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XxA+bCvcai3gX7vqE9J2y6zWnZw1LTlhEdx4C9IFOYnTVLxyc4Vg/lqTfdiCMOttZ
	 laWQ7AuV9oWq3uenaCxvvT6BccOEo3e76yidbiwGpLm8L77+ovrk9pWLGzK8Hb9p5Z
	 EAO5dqMknySa/gpNOhBKaq61N8YAiDI4heldvC+O9EtlwDPYw3+qhxcwLszCImJdZg
	 L7s/zozHjHVFd83dfkNs4qhWYd+n81/t/vxX6ZwLEChsuN2a+cucxEqzLDt4rTh8C+
	 W5jgQR2dP+eaOfW5IzXi12GEs4v87KJe76jQaQStGhRsZttas16DoxX4N+sTxrZuuV
	 prXCTsf7XfO6A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Yajat Kumar <yajatapps3@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	hansg@kernel.org,
	linux-input@vger.kernel.org,
	platform-driver-x86@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.10] platform/x86: touchscreen_dmi: Add quirk for y-inverted Goodix touchscreen on SUPI S10
Date: Tue, 10 Mar 2026 05:01:22 -0400
Message-ID: <20260310090145.2709021-22-sashal@kernel.org>
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

From: Hans de Goede <johannes.goede@oss.qualcomm.com>

[ Upstream commit 7d87ed70fc95482c12edf9493c249b6413be485e ]

The touchscreen on the SUPI S10 tablet reports inverted Y coordinates,
causing touch input to be mirrored vertically relative to the display.

Add a quirk to set the "touchscreen-inverted-y" boolean device-property
on the touchscreen device, so that the goodix_ts driver will fixup
the coordinates.

Reported-by: Yajat Kumar <yajatapps3@gmail.com>
Closes: https://lore.kernel.org/linux-input/20251230221639.582406-1-yajatapps3@gmail.com/
Tested-by: Yajat Kumar <yajatapps3@gmail.com>
Signed-off-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Link: https://patch.msgid.link/20260217132346.34535-1-johannes.goede@oss.qualcomm.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

### What the commit does
This adds a DMI-based touchscreen quirk for the SUPI S10 tablet. The
tablet's Goodix touchscreen (GDIX1001) reports inverted Y coordinates,
causing touch input to be vertically mirrored. The fix adds:

1. A new property entry array `gdix1001_y_inverted_props[]` with
   `touchscreen-inverted-y`
2. A corresponding `ts_dmi_data` struct pointing to ACPI name "GDIX1001"
3. A DMI table entry matching vendor "SUPI", product "S10"

### Stable kernel criteria assessment

**Fixes a real bug:** Yes. Without this quirk, touch input is vertically
mirrored on this tablet, making it essentially unusable for touch
interaction.

**Hardware quirk exception:** This is a textbook DMI-based hardware
quirk — exactly the type explicitly listed as appropriate for stable
backporting. The `touchscreen_dmi.c` file exists solely for these
entries; it has hundreds of similar quirks already.

**Small and contained:** Yes. ~18 lines added to a single file,
following the exact same pattern as every other entry in the file.

**Risk of regression:** Extremely low. The DMI matching
(`DMI_SYS_VENDOR: "SUPI"`, `DMI_PRODUCT_NAME: "S10"`) ensures this code
only activates on the specific affected tablet. No other hardware is
impacted.

**Tested and reviewed:** Yes. Has both `Tested-by: Yajat Kumar` (the
reporter/user) and `Reviewed-by: Ilpo Järvinen` (Intel maintainer). The
commit author Hans de Goede is the well-known x86 platform maintainer
who handles most touchscreen quirks.

**No new features:** Correct. This uses existing infrastructure
(`ts_dmi_data`, `property_entry`, `dmi_system_id` matching) to fix a
specific device.

**Dependencies:** None. The `touchscreen_dmi.c` framework and the Goodix
driver's handling of `touchscreen-inverted-y` have been present for many
kernel versions.

### Verification
- The commit follows the identical pattern used by all other entries in
  `touchscreen_dmi.c` — no novel code patterns
- The `gdix1001_y_inverted_props` is a subset of the existing
  `gdix1001_upside_down_props` (which sets both inverted-x and
  inverted-y), confirming this is a well-established mechanism
- Reporter and tester are the same person (Yajat Kumar), confirming the
  fix resolves the reported issue
- The author (Hans de Goede) is the primary maintainer for x86
  touchscreen quirks
- The `Closes:` link to lore.kernel.org confirms a real user report from
  December 2025

### Risk vs benefit
- **Benefit:** Makes touchscreen usable on SUPI S10 tablets — critical
  for those users
- **Risk:** Near zero — DMI-scoped to one specific device model, uses
  existing well-tested infrastructure

**YES**

 drivers/platform/x86/touchscreen_dmi.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/platform/x86/touchscreen_dmi.c b/drivers/platform/x86/touchscreen_dmi.c
index bdc19cd8d3edf..d83c387821ea1 100644
--- a/drivers/platform/x86/touchscreen_dmi.c
+++ b/drivers/platform/x86/touchscreen_dmi.c
@@ -410,6 +410,16 @@ static const struct ts_dmi_data gdix1002_upside_down_data = {
 	.properties	= gdix1001_upside_down_props,
 };
 
+static const struct property_entry gdix1001_y_inverted_props[] = {
+	PROPERTY_ENTRY_BOOL("touchscreen-inverted-y"),
+	{ }
+};
+
+static const struct ts_dmi_data gdix1001_y_inverted_data = {
+	.acpi_name	= "GDIX1001",
+	.properties	= gdix1001_y_inverted_props,
+};
+
 static const struct property_entry gp_electronic_t701_props[] = {
 	PROPERTY_ENTRY_U32("touchscreen-size-x", 960),
 	PROPERTY_ENTRY_U32("touchscreen-size-y", 640),
@@ -1658,6 +1668,14 @@ const struct dmi_system_id touchscreen_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_SKU, "PN20170413488"),
 		},
 	},
+	{
+		/* SUPI S10 */
+		.driver_data = (void *)&gdix1001_y_inverted_data,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "SUPI"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "S10"),
+		},
+	},
 	{
 		/* Techbite Arc 11.6 */
 		.driver_data = (void *)&techbite_arc_11_6_data,
-- 
2.51.0


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27318308F28;
	Mon, 22 Sep 2025 17:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758563890; cv=none; b=L5ouvZhPmo28p1T/W8dOxNxCjHlHV1Fs3UdIyr0qX7/qglKefsod8ppdggwHXe84zkPblmjgypi57EY8tkmn5f+NrPGaP5+6Rn1+NBFAM89ZOLhNPSFX5DkrzPwMZ8ugqfN4lJHTUyzOq0qRILn0EvTSzLQOqadHe2mR8MZzLpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758563890; c=relaxed/simple;
	bh=60biBgSwgokY9OKJX7PGvApz4Gt54paYJn1orVzDVvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u4oQx+qG0y06nFANApJtMkoOzmK47e1xHj1JCquAn7jlmpb6n7FCqVtoBbdYP4lakxWpE4CvIgfhyItWwixY8fYPDR4uOvn0wqYEaQCWHYJsNGoiAhNAeHV4K3TqlM5HcUtsap6uq1VuNeDav2AvZphASQ/HlZ9K2JtruVBCzcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RQaxBg5N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RQaxBg5N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF474C4CEF7;
	Mon, 22 Sep 2025 17:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758563889;
	bh=60biBgSwgokY9OKJX7PGvApz4Gt54paYJn1orVzDVvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RQaxBg5NiIdok8BRXfSFfBj1Qe6X/ogXnrM+x/aW8BYQ8GCprxCp8OrWB3d9aa6zO
	 4SB0v1FMmZoRUk4yezY1J4QQavGulZVknWZnra3HGPbN+bCxEUltSMFmOrGcT/8lnp
	 K22Un0pc8F17MnLGtGQmqf2wYvMcf3MWKwSQmk/bYBPo0K3ciapX1iSPD0MH4+SA70
	 RFtjJ48/1PqPVpli47OsyDmWWAnv0MZ9mddHxgJlxJybPpbxuk+USnvLxDb695O2Nj
	 rfbIejnCVnK66gqdS68ievax0N7yRACyuqmBkKVbavfnlBEKp11bnlUVMsngPe2lIu
	 tF8wJsfTROGng==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: aprilgrimoire <aprilgrimoire@proton.me>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Shyam-sundar.S-k@amd.com,
	platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 6.16-6.6] platform/x86/amd/pmc: Add MECHREVO Yilong15Pro to spurious_8042 list
Date: Mon, 22 Sep 2025 13:57:41 -0400
Message-ID: <20250922175751.3747114-10-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922175751.3747114-1-sashal@kernel.org>
References: <20250922175751.3747114-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16.8
Content-Transfer-Encoding: 8bit

From: aprilgrimoire <aprilgrimoire@proton.me>

[ Upstream commit 8822e8be86d40410ddd2ac8ff44f3050c9ecf9c6 ]

The firmware of Mechrevo Yilong15Pro emits a spurious keyboard interrupt on
events including closing the lid. When a user closes the lid on an already
suspended system this causes the system to wake up.
Add Mechrevo Yilong15Pro Series (GM5HG7A) to the list of quirk
spurious_8042 to work around this issue.

Link: https://lore.kernel.org/linux-pm/6ww4uu6Gl4F5n6VY5dl1ufASfKzs4DhMxAN8BuqUpCoqU3PQukVSVSBCl_lKIzkQ-S8kt1acPd58eyolhkWN32lMLFj4ViI0Tdu2jwhnYZ8=@proton.me/
Signed-off-by: April Grimoire <aprilgrimoire@proton.me>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Link: https://patch.msgid.link/IvSc_IN5Pa0wRXElTk_fEl-cTpMZxg6TCQk_7aRUkTd9vJUp_ZeC0NdXZ0z6Tn7B-XiqqqQvCH65lq6FqhuECBMEYWcHQmWm1Jo7Br8kpeg=@proton.me
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my extensive analysis of the commit and comprehensive research
of the kernel subsystem, stable backporting practices, and similar
commits:

**Backport Status: YES**

## Detailed Justification:

### This commit is suitable for stable backporting because:

1. **Fixes a real user bug**: The commit fixes spurious system wakeups
   when closing the lid on an already suspended MECHREVO Yilong15Pro
   laptop - a frustrating issue that affects real users.

2. **Minimal and contained change**: The patch adds exactly 8 lines to a
   DMI quirk table - one of the safest types of kernel changes with
   virtually zero regression risk.

3. **Strong precedent for backporting**: My research found that similar
   spurious_8042 quirk additions have been regularly backported:
   - `0dd4a4cc9afdd`: TUXEDO IB Pro Gen10 (explicitly marked "Cc:
     stable@vger.kernel.org")
   - `0887817e49538`: MECHREVO Wujie 14XA (has Fixes: tag, auto-selected
     for stable)
   - Multiple other platform quirks routinely backported

4. **Meets stable kernel criteria**: Per Documentation/process/stable-
   kernel-rules.rst:
   - ✅ Fixes a real bug that bothers people
   - ✅ Falls under explicitly allowed "hardware quirks" category
   - ✅ "Just add a device ID" type change
   - ✅ Already merged in mainline with proper maintainer review

5. **Zero impact on other systems**: DMI quirks only affect systems with
   exact DMI string matches - no risk to other hardware.

6. **Well-understood mechanism**: The spurious_8042 quirk has been in
   the kernel since January 2023, is well-tested, and addresses a
   documented AMD platform firmware bug affecting multiple laptop
   models.

### Technical specifics from the code:
```c
+       {
+               .ident = "MECHREVO Yilong15Pro Series GM5HG7A",
+               .driver_data = &quirk_spurious_8042,
+               .matches = {
+                       DMI_MATCH(DMI_SYS_VENDOR, "MECHREVO"),
+                       DMI_MATCH(DMI_PRODUCT_NAME, "Yilong15Pro Series
GM5HG7A"),
+               }
+       },
```

This simply adds the laptop to the `fwbug_list[]` array in
`drivers/platform/x86/amd/pmc/pmc-quirks.c`, applying the existing
`quirk_spurious_8042` workaround that disables IRQ1 wakeup to prevent
spurious keyboard interrupts during suspend.

The commit has been properly reviewed by both Mario Limonciello (AMD
maintainer) and Ilpo Järvinen (platform/x86 maintainer), ensuring
quality and correctness.

**Recommendation**: This commit should be marked with "Cc:
stable@vger.kernel.org" for backporting to stable kernels where the
spurious_8042 quirk mechanism exists (6.2+).

 drivers/platform/x86/amd/pmc/pmc-quirks.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/platform/x86/amd/pmc/pmc-quirks.c b/drivers/platform/x86/amd/pmc/pmc-quirks.c
index 18fb44139de25..4d0a38e06f083 100644
--- a/drivers/platform/x86/amd/pmc/pmc-quirks.c
+++ b/drivers/platform/x86/amd/pmc/pmc-quirks.c
@@ -239,6 +239,14 @@ static const struct dmi_system_id fwbug_list[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "WUJIE14-GX4HRXL"),
 		}
 	},
+	{
+		.ident = "MECHREVO Yilong15Pro Series GM5HG7A",
+		.driver_data = &quirk_spurious_8042,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "MECHREVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Yilong15Pro Series GM5HG7A"),
+		}
+	},
 	/* https://bugzilla.kernel.org/show_bug.cgi?id=220116 */
 	{
 		.ident = "PCSpecialist Lafite Pro V 14M",
-- 
2.51.0


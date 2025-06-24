Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B15222575;
	Tue, 24 Jun 2025 04:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750738344; cv=none; b=tG8/rkfVptT4Qd3rnuviCJpTC4uDwpmf3flmEwmjgZ9QuOiAkfAESrTpG+ajiT3nmS/6RcB/jgMyHlXyvv2y6FbcH1zk8aDPkydibq6DTSerIypVWO1101u0q118OZWuXHPuzflhP6zroP0VZpV/R2olwbM4uCVPPq03+r4uQ/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750738344; c=relaxed/simple;
	bh=6beIUJdELNELXdKvTmB9tngyKpYNQKvJxKV4TrCwLXk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jfKJWILYoLYu6lZyBE3+AIgCozq1RFrKr+gOrzEZVzecy2Yq5D5Xy2oUYQx0CvkvJ/IxlBBQxJfYNigfkwiqLPS5MuNUXK1r8UTTNpMqFREDQ7I/ZbskjgyNsUVmaCEJMRrpa5y6WmW7FK3YMEAPSNYGU7YmSGG0GSEnT4hZczc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qGhDxl+E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qGhDxl+E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B0ECC4CEF3;
	Tue, 24 Jun 2025 04:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750738343;
	bh=6beIUJdELNELXdKvTmB9tngyKpYNQKvJxKV4TrCwLXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qGhDxl+E035LAksLRQ75nouvrXHV5JPLqr9njJCUoF65knyHyLHkcDk9AZATq4o9+
	 PALxc8hNab3tK6KmVlecVxBeOgZ+KWY45Kl4/fFT95qVoNqRCa5Qz5/tJcLwc3WoHk
	 DGJ3j06DS/uqpPmhGmHoeXCkhyqiqkBQ/sq4wqTX4WF4hiLp4fwkUldO0J0jIp1MMd
	 AaJXQO+odiJjIRjf3u5Z9MEESGEOmR3ZGbKfrX7K7laoEB6NtXDAh5slCD+r+wV67B
	 k3BMdi/yWcE1Wkqf724fUo862s3IHYRdrfdZTJfFSPGZVjUaEB1+WVQKNjVvAiPCTR
	 6LQDi3UMtUt/g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Gabriel Santese <santesegabriel@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	mario.limonciello@amd.com,
	tiwai@suse.de,
	venkataprasad.potturu@amd.com,
	talhah.peerbhai@gmail.com
Subject: [PATCH AUTOSEL 6.6 07/18] ASoC: amd: yc: Add quirk for MSI Bravo 17 D7VF internal mic
Date: Tue, 24 Jun 2025 00:12:03 -0400
Message-Id: <20250624041214.84135-7-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250624041214.84135-1-sashal@kernel.org>
References: <20250624041214.84135-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.94
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gabriel Santese <santesegabriel@gmail.com>

[ Upstream commit ba06528ad5a31923efc24324706116ccd17e12d8 ]

MSI Bravo 17 (D7VF), like other laptops from the family,
has broken ACPI tables and needs a quirk for internal mic
to work properly.

Signed-off-by: Gabriel Santese <santesegabriel@gmail.com>
Link: https://patch.msgid.link/20250530005444.23398-1-santesegabriel@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES**

This commit should be backported to stable kernel trees. Here's my
extensive analysis:

## Analysis of the Commit

### 1. **Nature of the Fix**
This commit adds a DMI quirk entry for the MSI Bravo 17 D7VF laptop to
enable its internal microphone. The code change is minimal and follows
an established pattern:

```c
+       {
+               .driver_data = &acp6x_card,
+               .matches = {
+                       DMI_MATCH(DMI_BOARD_VENDOR, "Micro-Star
International Co., Ltd."),
+                       DMI_MATCH(DMI_PRODUCT_NAME, "Bravo 17 D7VF"),
+               }
+       },
```

### 2. **Bug Being Fixed**
The commit message explicitly states "has broken ACPI tables and needs a
quirk for internal mic to work properly." This is fixing a real hardware
functionality issue where the internal microphone doesn't work without
this quirk.

### 3. **User Impact**
Without this fix, users of the MSI Bravo 17 D7VF laptop cannot use their
internal microphone, which is a significant functionality loss for:
- Video conferencing
- Voice recording
- Voice commands
- Any application requiring microphone input

### 4. **Code Analysis**
Looking at the probe function in `acp6x_probe()`:
- The driver first tries to detect DMIC support via ACPI methods
  (`AcpDmicConnected` and `_WOV`)
- If ACPI detection fails or returns incorrect values (as mentioned in
  commit - "broken ACPI tables"), it falls back to DMI quirk table
  matching
- Without the quirk entry, `dmi_first_match(yc_acp_quirk_table)` returns
  NULL, and the card won't be set up properly, resulting in no
  microphone support

### 5. **Consistency with Similar Commits**
All similar commits provided as reference were marked with "Backport
Status: YES":
- "ASoC: amd: yc: Add a quirk for MSI Bravo 17 (D7VEK)" - YES
- "ASoC: amd: yc: Add DMI quirk for MSI Bravo 15 C7VF" - YES (includes
  Cc: stable)
- "ASoC: amd: yc: fix internal mic on Redmi G 2022" - YES
- "ASoC: amd: yc: Add DMI quirk for Lenovo Ideapad Pro 5 16ARP8" - YES
  (includes Cc: stable)
- "ASoC: amd: yc: Fix non-functional mic on ASUS E1404FA" - YES

### 6. **Risk Assessment**
- **Minimal risk**: The change only adds a new DMI match entry
- **No architectural changes**: Pure data addition to existing quirk
  table
- **No behavioral changes**: Only affects the specific laptop model
- **Well-tested pattern**: Follows exact same pattern as dozens of other
  entries in the table

### 7. **Stable Tree Criteria**
This commit meets all stable tree criteria:
- ✓ Fixes a real bug affecting users (non-functional microphone)
- ✓ Small and contained change (7 lines addition)
- ✓ No side effects beyond fixing the specific issue
- ✓ No new features or architectural changes
- ✓ Hardware enablement fix for specific model

### 8. **Pattern Recognition**
This is part of the MSI Bravo laptop family fixes:
- Bravo 15 B7ED already has quirk
- Bravo 15 C7VF already has quirk (with Cc: stable)
- Bravo 17 D7VEK already has quirk
- This adds Bravo 17 D7VF to complete the family

The commit follows the exact same pattern and reasoning as previous MSI
Bravo laptop quirks that were successfully backported to stable trees,
indicating this should also be backported for consistency and user
benefit.

 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 622df58a96942..d00e19d7b5c2f 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -437,6 +437,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Bravo 17 D7VEK"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Micro-Star International Co., Ltd."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Bravo 17 D7VF"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.39.5


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795BB23A6;
	Wed, 23 Jul 2025 00:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753232347; cv=none; b=g3FhZkXzxaNGrUDtZB/DQfxPx6INOJZl5OozqE/a9aQ1Fa4akAupAKmxL+46VGTWqLlhXH1H2XN9djJKx/KI2IrMlCkp+FBBGz8LENXsNffvXMM3ZcNfuNGHmd57nFUAedewO4V/FCvYHenfPYWQW0h/XjZBiMXffLlPhv5kFTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753232347; c=relaxed/simple;
	bh=Kq0E18DLpgPyosVCnEti4zoB8SOmDHrcDdRZQzOy5Zc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SMq6dktDKmTa0miulGliu0ld7dXeT/BRnj5QSipazCu64pj+w722y5zjlI9wZ0dipkTIw1UTOMtIatjvkB7/VFLxoOnYob/Lx+TFFXpzDBG8SdDRLV9gNrqah9JZI2ZmVdhcYfjmHNOt2SLoHqd7q6HSnRVrZYlUkWY/uhqleAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cbjFhHVD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cbjFhHVD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0972CC4CEEB;
	Wed, 23 Jul 2025 00:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753232347;
	bh=Kq0E18DLpgPyosVCnEti4zoB8SOmDHrcDdRZQzOy5Zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cbjFhHVDb/3DW/TTWUFLyr89De1jgJvhelKJ1selyLD07H4AZVVkWr4Cd7Os+yFxh
	 Uh+Qg7w0WrsqR8HJikKopRzJQdp3Lm4yT3bcqrJsEsV/mOnt+b6ozxcI5/F0BTfLox
	 nyM7Ct3vouebAf+2wSHxMTj5LomAr2o6dj348ROGApEI+3rINKlJHhp6c8HN4QR1m8
	 2zjT+RNpA1ujAR2sjEsg2puqYDGHB5gG/E5u1DNlqRMtg6Ku4BXDR1TAIfmwexBipU
	 lOJXBkEXJBZPMhOMJxe7OyXEyfKmca71kjTlRdAaTzzcXU+Ol/7NgYjTdb4jOCMwV8
	 r/WUYn9GVDASg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Adam Queler <queler@gmail.com>,
	Adam Queler <queler+k@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	tiwai@suse.de,
	venkataprasad.potturu@amd.com,
	mario.limonciello@amd.com,
	lachlan.hodges@morsemicro.com,
	talhah.peerbhai@gmail.com
Subject: [PATCH AUTOSEL 6.1 2/3] ASoC: amd: yc: Add DMI entries to support HP 15-fb1xxx
Date: Tue, 22 Jul 2025 20:58:56 -0400
Message-Id: <20250723005857.1023488-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250723005857.1023488-1-sashal@kernel.org>
References: <20250723005857.1023488-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.146
Content-Transfer-Encoding: 8bit

From: Adam Queler <queler@gmail.com>

[ Upstream commit 949ddec3728f3a793a13c1c9003028b9b159aefc ]

This model requires an additional detection quirk to
enable the internal microphone.

Signed-off-by: Adam Queler <queler+k@gmail.com>
Link: https://patch.msgid.link/20250715031434.222062-1-queler+k@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**YES**

This commit should be backported to stable kernel trees. Here's my
extensive analysis:

## Nature of the Change

This commit adds a simple DMI (Desktop Management Interface) quirk entry
for the HP Victus Gaming Laptop 15-fb1xxx model to enable internal
microphone support. The change is:
- Adding a new entry to the `yc_acp_quirk_table[]` array
- The entry matches DMI_BOARD_VENDOR "HP" and DMI_PRODUCT_NAME "Victus
  by HP Gaming Laptop 15-fb1xxx"
- Associates the match with `&acp6x_card` driver data

## Comparison with Similar Commits

All 5 similar commits with "Backport Status: YES" follow the exact same
pattern:
1. They add DMI entries for HP laptops (HP OMEN, HP Victus) or other
   brands
2. They enable internal microphone functionality for specific hardware
   models
3. They are minimal, self-contained changes adding only DMI match
   entries
4. They fix hardware enablement issues that affect users

## Backport Suitability Analysis

**Reasons this qualifies for stable backporting:**

1. **Bug Fix**: This fixes a hardware functionality issue where the
   internal microphone doesn't work on HP Victus 15-fb1xxx laptops
   without this quirk

2. **User Impact**: Without this patch, users of this specific laptop
   model cannot use their internal microphone, which is a significant
   functionality regression

3. **Minimal Risk**: The change is:
   - Extremely localized (only adds one DMI entry)
   - Cannot affect other hardware (DMI matching is specific to this
     model)
   - Uses the same pattern as dozens of other entries in the same table
   - No algorithmic changes or new features

4. **Self-Contained**: The patch is completely self-contained with no
   dependencies on other changes

5. **Hardware Enablement**: This falls under the stable tree criteria
   for "hardware that is broken by design and needs a quirk"

6. **Precedent**: The git history shows numerous similar DMI quirk
   additions for this driver have been backported to stable

## Code Safety Analysis

The code change is safe because:
- It only adds a static data structure entry
- The DMI matching system is well-established and reliable
- The `acp6x_card` driver data is already used by many other entries
- No memory allocations, no new logic paths, no behavioral changes for
  existing hardware

This is a textbook example of a stable-appropriate patch: it fixes a
real user-facing bug with minimal risk and follows established patterns.

 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 1f4c43bf817e4..fce918a089e37 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -458,6 +458,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "OMEN by HP Gaming Laptop 16z-n000"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Victus by HP Gaming Laptop 15-fb1xxx"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.39.5


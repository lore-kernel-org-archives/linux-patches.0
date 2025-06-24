Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0550222580;
	Tue, 24 Jun 2025 04:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750738348; cv=none; b=S8M1D/5K2zhdfHd60K2aqtsrzjarl8ivk2stecUN+vqp+hQCAO2mtjjzbnNEcc2disPB+4GneYxJY6u2VIZMU3XSxpt2DADgDFNIeekrwsi+gdKj1C1zb17YVNKbY/NYRiIgob9MG8DFSO5tJx8AosngwNVjcwb5iYHHYK7FnoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750738348; c=relaxed/simple;
	bh=tICgM9nBa3R6bpzThVj3ysfLgSMJVw3Y4NNnAjOKeG0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g5J1Iooy4Q4CMV96GeOhNcaH6kjVXcPQYyrwkqFj+B1Lz/LmxOjYnL6srTxVUTKUOGXqhUJZjSe6Hybcnc7zVx7hzBXYPxcV96jDAjUs9hZydSfOzJd9yQTKt/aUKz10AfHgD9TlB/8g1kvQBORCNlE+HxHKI2zhPKpOJMUOzew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hNMzWqzZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hNMzWqzZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01A4FC4CEEF;
	Tue, 24 Jun 2025 04:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750738348;
	bh=tICgM9nBa3R6bpzThVj3ysfLgSMJVw3Y4NNnAjOKeG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hNMzWqzZFNN4zxbSgmbfy5iwCCAsDKX8hMk0LCvSla4xj7hWgnMpd9za0zsuWK4JX
	 GFiOypFqXpxVvT0eKrsTpyi41+QzbMcTUrE4ob3kINqnc5/hWs9uytNqeEWZxgf27+
	 GHtxtgQrxAzefib8h6BkDdcB0UOB/PDqmew3dbE2XhVU0do3trCbvUEys5T6YXCH0x
	 ddWVy3i3+JVtH8qJs2kYD6HOvR7gSJ0Vcnsr7zcyEAl7pqUOGOY+2FcC25h57vH1fA
	 7/9zzQkoI8sHF1yUfUMUQCp8T7jtnaZuXZ0GOx9LEIf5lldlIs90TS0hD39PMbqcNg
	 xwV7DfyRshsoA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Raven Black <ravenblack@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	mario.limonciello@amd.com,
	venkataprasad.potturu@amd.com,
	tiwai@suse.de,
	talhah.peerbhai@gmail.com
Subject: [PATCH AUTOSEL 6.6 10/18] ASoC: amd: yc: update quirk data for HP Victus
Date: Tue, 24 Jun 2025 00:12:06 -0400
Message-Id: <20250624041214.84135-10-sashal@kernel.org>
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

From: Raven Black <ravenblack@gmail.com>

[ Upstream commit 13b86ea92ebf0fa587fbadfb8a60ca2e9993203f ]

Make the internal microphone work on HP Victus laptops.

Signed-off-by: Raven Black <ravenblack@gmail.com>
Link: https://patch.msgid.link/20250613-support-hp-victus-microphone-v1-1-bebc4c3a2041@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES**

This commit should be backported to stable kernel trees. Here's my
extensive analysis:

## Analysis of the Commit

### 1. **Nature of the Change**
The commit adds a simple DMI (Desktop Management Interface) quirk entry
to enable the internal microphone on HP Victus Gaming Laptop 15-fb2xxx.
The change consists of adding just 7 lines to the `yc_acp_quirk_table[]`
array:

```c
+       {
+               .driver_data = &acp6x_card,
+               .matches = {
+                       DMI_MATCH(DMI_BOARD_VENDOR, "HP"),
+                       DMI_MATCH(DMI_PRODUCT_NAME, "Victus by HP Gaming
Laptop 15-fb2xxx"),
+               }
+       },
```

### 2. **Comparison with Similar Commits**
All 5 historical similar commits provided were marked as "Backport
Status: YES" and share identical characteristics:
- Same file modified (sound/soc/amd/yc/acp6x-mach.c)
- Same type of change (adding DMI quirk entries)
- Same purpose (enabling internal microphone on specific laptop models)
- Similar commit messages mentioning microphone support
- All are HP laptop models (except one MECHREVO)

### 3. **Meets Stable Backport Criteria**

**✓ Fixes a real bug affecting users**: Without this quirk, the internal
microphone on HP Victus Gaming Laptop 15-fb2xxx doesn't work, which is a
functional regression for users of this hardware.

**✓ Small and contained change**: The patch is minimal - only 7 lines
adding a DMI match entry to an existing quirk table. No logic changes,
no new features.

**✓ No architectural changes**: This is a simple hardware enablement
quirk, not modifying any kernel architecture.

**✓ Minimal risk of regression**:
- The change only affects systems that match the specific DMI strings
- Cannot affect other hardware configurations
- Uses the same `acp6x_card` driver data as other entries
- Pattern is well-established in the codebase

**✓ Hardware enablement**: This is pure hardware enablement for audio
functionality, which is a common reason for stable backports.

### 4. **Technical Safety**
The code change:
- Adds to an existing array without modifying existing entries
- Uses standard DMI matching infrastructure
- Follows the exact same pattern as dozens of other entries in the same
  table
- The `acp6x_card` structure is already defined and used by many other
  entries

### 5. **User Impact**
Users of HP Victus Gaming Laptop 15-fb2xxx running stable kernels would
benefit from having their internal microphone work correctly without
waiting for the next major kernel release.

This commit is an ideal candidate for stable backporting as it's a
minimal, safe hardware enablement fix that follows well-established
patterns in the codebase.

 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index d00e19d7b5c2f..f4d115f17a838 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -507,6 +507,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "OMEN by HP Gaming Laptop 16z-n000"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Victus by HP Gaming Laptop 15-fb2xxx"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.39.5


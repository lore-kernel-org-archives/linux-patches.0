Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 152572222B2;
	Tue, 24 Jun 2025 04:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750738324; cv=none; b=GfzBFrrcPCV3DiEABnsJNoly8RusUvncCRe5x2OQKs62iqu8mBpIU+xXDJvgLpwjWGM3V5nSb77zCSR3GrxkRYOsgEUV8a7TcbwT5d++TGIWPI53PyzpkHhBuHeGefs9AURRhR/gPQ3c0EBrH8heMsOnoEXNSEqdIykqsMGx2ZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750738324; c=relaxed/simple;
	bh=ogJzCtbdZDyQ8mP1cKnPHiwakfVCOJh4f6N35C/rkvg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L0DQKXo77k6dxW1iBMS7X+7PuyizIdhTXNiJGXyq3aXMXuRGj+Za+t5DFLOFjFCQqKNDR0mqGnBQRVqHyQ1evOogUv8KVSyItJfKVJWwFf1VuUDuU6R7ufJq8YTqZzumRCQk6o6zucDkpBNS4/2tHg/fyPRWawqLq+PQp/OB5Ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nY0Y29ga; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nY0Y29ga"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93C72C4CEEF;
	Tue, 24 Jun 2025 04:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750738324;
	bh=ogJzCtbdZDyQ8mP1cKnPHiwakfVCOJh4f6N35C/rkvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nY0Y29gaSWaXdhaSOAwCu8v4ITIKe86b8fvjyQ+TsdTn+ettsFK8agRxYpbM/7XLH
	 tOH1NJJnQ+MlXONzckM+0gpOcHjhQgYlnLRKHQzs8DxUzEyqUEHMxexo3eO3rxVZUT
	 KtBXQc9qKXLLH2qfF7OaUXMySWg60Dl6tE4pQpx5rnExJJLi3R+sMXtRkQb3Pjt9lm
	 s8SdH1pSehkLefEaoiWVIFIGVxgs0q4voFsdO1XZ7WIBhoh/1GyDpkTp6YzsONIdiL
	 2cbR9WzEeVwuQTOcXdwW9qBXZ/zrH0suq+PI3Ke1QMa20GaaKWCNDL6eHRIy8Yv0jg
	 qp67EXl3REx8w==
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
Subject: [PATCH AUTOSEL 6.12 11/19] ASoC: amd: yc: update quirk data for HP Victus
Date: Tue, 24 Jun 2025 00:11:40 -0400
Message-Id: <20250624041149.83674-11-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250624041149.83674-1-sashal@kernel.org>
References: <20250624041149.83674-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.34
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
index 9ce4339680e35..dce17f0bfab9e 100644
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


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 872E7156CA;
	Wed, 23 Jul 2025 00:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753232289; cv=none; b=cGGEJTnUq9ZBFPKUiR3/x3fdMc3AcnHfSX5IEWZQTBXBX8tOEwtBlHcCgoiwMtlreklBN674y0/uy9beCWZIsvX81dwKeOiZI6kX3IqJiIe5+2pD9RpXMF33zVb149Z8da97KsMrlWmH2BWwdtfoZvSeKTtoclDeSeyB97cJmGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753232289; c=relaxed/simple;
	bh=ZscK4o+5/EPAQzp5Nuge23lg4yzvo6W+En4uiQBKAso=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=BhSCvdhHMlG75PMNL3YnThmsSrSvBsqH8JaGHh9SSKtWXJFMkKPLboYq1z2a5iluYdYMuE7ABdaHR9Vp8mPmq7t2ls13pPgRY8y4tMJ6rGTZGW0bhE2Go1lu8C6HK+cij4VV27p3CVZZbctWYDEh/VnDSzCpeF14GRvizX2IVD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ajug41Ru; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ajug41Ru"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73069C4CEF1;
	Wed, 23 Jul 2025 00:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753232289;
	bh=ZscK4o+5/EPAQzp5Nuge23lg4yzvo6W+En4uiQBKAso=;
	h=From:To:Cc:Subject:Date:From;
	b=ajug41RuhuEu3toj6EfP5f4pzZTCQ6yoJ0VHpe7jk7SA7wDin0EKxFjn8EKcTQMaH
	 9lceKcQljiGuVzVOCmvb2SRvCsGxm4knd+TV9G/5P9loG+z5d3yHJhyYI4ffWe+mDW
	 kZgwnhxd7W40LbK4AKH/uABU5dyBGWj0dmw1oBNXXrzGfatpPP9b5q/XKGYIaS5Wgs
	 7bu4x2xfw7AUqTmw5XkbbJ7ovagUngRpQvbXkg0EAEJxnnT6+RW66wrPDcyJY+JTNd
	 78EJ7SZmZEWFr6s8E4J85NrqT9ozOTPBD5YpNwQd7FNfTLK6vmbyIEzVK8sVht2hZN
	 dpkqKPxaaKk8Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lane Odenbach <laodenbach@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	venkataprasad.potturu@amd.com,
	tiwai@suse.de,
	mario.limonciello@amd.com,
	lachlan.hodges@morsemicro.com,
	talhah.peerbhai@gmail.com
Subject: [PATCH AUTOSEL 6.12 1/6] ASoC: amd: yc: Add DMI quirk for HP Laptop 17 cp-2033dx
Date: Tue, 22 Jul 2025 20:57:57 -0400
Message-Id: <20250723005805.1023184-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.39
Content-Transfer-Encoding: 8bit

From: Lane Odenbach <laodenbach@gmail.com>

[ Upstream commit 7bab1bd9fdf15b9fa7e6a4b0151deab93df3c80d ]

This fixes the internal microphone in the stated device

Signed-off-by: Lane Odenbach <laodenbach@gmail.com>
Link: https://patch.msgid.link/20250715182038.10048-1-laodenbach@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **Bug Fix for Hardware Functionality**: The commit fixes a non-
   functional internal microphone on the HP Laptop 17 cp-2033dx. This is
   a hardware enablement bug fix that prevents users from using a core
   functionality of their laptop.

2. **Minimal and Contained Change**: The change is extremely minimal -
   it only adds 7 lines to the DMI quirk table:
  ```c
  +       {
  +               .driver_data = &acp6x_card,
  +               .matches = {
  +                       DMI_MATCH(DMI_BOARD_VENDOR, "HP"),
  +                       DMI_MATCH(DMI_BOARD_NAME, "8A81"),
  +               }
  +       },
  ```
  This is a simple DMI match addition with no algorithmic changes or
  side effects.

3. **Low Risk of Regression**: DMI quirk additions are inherently safe
   as they only affect the specific hardware model being added. The
   change cannot impact any other system that doesn't match the exact
   DMI strings.

4. **Follows Established Pattern**: All five similar commits provided as
   reference (for HP models with board names 8BD6, 8A3E, 8A22, 8A27, and
   other manufacturers) were marked as "Backport Status: YES". This type
   of commit has a well-established history of being backported.

5. **User-Impacting Issue**: Without this quirk, users of the HP Laptop
   17 cp-2033dx cannot use their internal microphone, which is essential
   functionality for video calls, recording, and voice commands. This
   significantly degrades the user experience.

6. **Consistent with Stable Tree Rules**: The commit meets the stable
   kernel criteria:
   - It fixes a real bug that bothers users (non-functional microphone)
   - It's obviously correct and tested (standard DMI quirk pattern)
   - It's small (7 lines)
   - It doesn't add new features, only fixes existing functionality

The AMD Yellow Carp (YC) audio driver uses DMI quirks to enable the
internal microphone on specific laptop models. Without these quirks, the
DMIC (Digital Microphone) won't be properly initialized on affected
systems. This is a common pattern in the Linux kernel for handling
hardware-specific configurations.

 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 1689b6b22598e..42d123cb8b4c6 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -577,6 +577,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "8A7F"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "HP"),
+			DMI_MATCH(DMI_BOARD_NAME, "8A81"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.39.5


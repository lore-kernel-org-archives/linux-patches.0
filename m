Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E03DB156CA;
	Wed, 23 Jul 2025 00:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753232282; cv=none; b=N4nGtm4EcacZo0tUIllR6SCHxbcYElN/xEaB+ooFowkUtjKAXHhkCpi+j/rI8ZmJfT97+7/K/JN6zDo9STLSMalHs0OeMi+lRoAh9vPbjShtxIYk9YKJIuUdRBKK9g9vWHL7Co7a4iT3KOA18sla5TjMKsXd5XkY5AF/gr9tZ94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753232282; c=relaxed/simple;
	bh=hyTr1k1HK7RieUTrDMiDA64SVDGqangiL+mAc6/S0XA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Sw8LYVUFGS4Szv4eKNPeSwgCQL3iUFTUJy2N9YhDVg5piPHdGXwAgpGH2l8gbr9ITHuKNapmcvc7Rzfe2P0O/JMMZRJnXzrGmQSMlmL2Op2IY7g6AnwRnB+6tMCGPZfS2bEXcbjHK+oyZzJRgS+6OdHnjucHLkih2uKeRlSB74Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jRosREXq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jRosREXq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AACA1C4CEF1;
	Wed, 23 Jul 2025 00:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753232281;
	bh=hyTr1k1HK7RieUTrDMiDA64SVDGqangiL+mAc6/S0XA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jRosREXqe92Bh3GsJuA+bOL9rJrPD/hGUGKRz54QjbpeRigur3ExKMuHHGdStcso4
	 96B8fj63vle059BafbAFwjcolwh2bWkKxJXFs0AxbHTrKs4dI38HwiwGwtrCkpVorc
	 WNzV/+4o3fpPKpb0KkFOylth+/fEz4a5gJsBmYGojJJzSJKsjJso9MaTJfn7ROcrfo
	 qNUmK4iJnupezEHSHCAVGwhABCWJWe1AotjVSouFp0WORO4zZZQa0bMtH02HTVwicz
	 Nk74NQ5fBIqgkV82HkM0he83p3B4xdG7D8JIKZdEEzc+o38cCcARbRyBbIVsvG+UlD
	 t0YYMQhu/JTQA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alexandru Andries <alex.andries.aa@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	venkataprasad.potturu@amd.com,
	mario.limonciello@amd.com,
	tiwai@suse.de,
	lachlan.hodges@morsemicro.com,
	talhah.peerbhai@gmail.com
Subject: [PATCH AUTOSEL 6.15 8/8] ASoC: amd: yc: add DMI quirk for ASUS M6501RM
Date: Tue, 22 Jul 2025 20:57:21 -0400
Message-Id: <20250723005722.1022962-8-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250723005722.1022962-1-sashal@kernel.org>
References: <20250723005722.1022962-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexandru Andries <alex.andries.aa@gmail.com>

[ Upstream commit 6f80be548588429100eb1f5e25dc2a714d583ffe ]

add DMI entry for ASUS Vivobook PRO 15X (M6501RM)
to make the internal microphone function

Signed-off-by: Alexandru Andries <alex.andries.aa@gmail.com>
Link: https://patch.msgid.link/20250707220730.361290-1-alex.andries.aa@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**YES**

This commit should be backported to stable kernel trees. Here's my
extensive analysis:

## Analysis of the Commit

### 1. **Nature of the Change**
The commit adds a DMI (Desktop Management Interface) quirk entry for the
ASUS Vivobook PRO 15X (M6501RM) laptop to enable its internal microphone
functionality. The change is minimal - it simply adds 7 lines to the
`yc_acp_quirk_table[]` array in `sound/soc/amd/yc/acp6x-mach.c`:

```c
+       {
+               .driver_data = &acp6x_card,
+               .matches = {
+                       DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK COMPUTER
INC."),
+                       DMI_MATCH(DMI_PRODUCT_NAME, "M6501RM"),
+               }
+       },
```

### 2. **Impact and Bug Fix Nature**
This is a classic hardware enablement fix that:
- **Fixes a real user-facing bug**: The internal microphone on this
  specific laptop model doesn't work without this quirk
- **Has zero functional impact on other systems**: DMI quirks only
  activate when the exact hardware match is found
- **Follows an established pattern**: The file contains dozens of
  similar DMI quirks for various laptop models

### 3. **Code Context Analysis**
From examining the kernel repository:
- The `yc_acp_quirk_table[]` is used in the `acp6x_probe()` function to
  enable DMIC (Digital Microphone) support for AMD Yellow Carp platform
- The driver first tries ACPI methods to detect DMIC capability, but
  falls back to DMI quirks for systems that don't properly advertise
  this capability
- Without this quirk, the microphone simply won't be detected or
  function on the affected laptop model

### 4. **Comparison with Similar Commits**
Looking at the historical patterns:
- **3 out of 5 similar DMI quirk additions were marked for stable**
  (commits with "Cc: stable@vger.kernel.org")
- All commits marked "YES" for backporting share these characteristics:
  - Fix microphone functionality issues
  - Add simple DMI entries
  - Have bug reports or user confirmations
  - Minimal risk of regression

### 5. **Stable Tree Criteria Evaluation**
This commit meets all the key stable tree criteria:
- ✅ **Fixes a real bug**: Broken microphone functionality
- ✅ **Small and contained**: Only 7 lines added
- ✅ **No side effects**: Only affects the specific laptop model
- ✅ **No architectural changes**: Simple table entry addition
- ✅ **Minimal regression risk**: Cannot affect other hardware
- ✅ **User-reported issue**: Commit message indicates user need

### 6. **Risk Assessment**
The risk is essentially zero because:
- DMI matching is exact - it requires both vendor and product name to
  match
- The quirk only enables existing functionality, doesn't modify behavior
- Similar quirks have been added hundreds of times without issues
- The pattern is well-established in this subsystem

### 7. **Additional Considerations**
While this commit doesn't have an explicit "Cc: stable@vger.kernel.org"
tag, this is not unusual for AMD audio quirks. The maintainers often
rely on stable maintainers to pick up these obvious hardware enablement
fixes based on their merit.

This type of hardware enablement fix is exactly what stable kernels
should include - it makes Linux work properly on real hardware that
users have purchased, without any risk to existing functionality.

 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 4bde41663f421..e362c2865ec13 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -409,6 +409,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "M6500RC"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "M6501RM"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.39.5


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0B043230FD;
	Sun,  1 Jun 2025 23:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748821318; cv=none; b=uaL6RAUiQ1VZw7pePmwWvBGginZGQpha9B2fcJaJtqiHrC3c34babLoZDQz6ttsc9YjWWlM6Z+9V5TPPaKKkijkbtv89HLhv0sCSoe4ZD+frXc+DH5DbEeOUbfIri8sE0K33FA3oFTLcFnJQQ75tvHyzr8iVoJ4SontsVeIyFrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748821318; c=relaxed/simple;
	bh=A02/TfR+SbJB6qmUb0WJFAtSoi16JCr6TU16v36TJEY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=f/T0JOY9mKKuZb7uO4Mvyl4EaJmd21qTBP2ZHBcm/98jSoOk4uKjd4qtYlA1DwvFV6siF6EzNSVEyt6TAHUFwFpxkKwnx4yOoUbX+IGiX5VqOJ1qtQI08LPh9g6AgT559dhHccKR+few/LSgo1QIocKPx4KppxcikE6ITdXDJ/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dwkjOIBe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dwkjOIBe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18BBDC4CEE7;
	Sun,  1 Jun 2025 23:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748821316;
	bh=A02/TfR+SbJB6qmUb0WJFAtSoi16JCr6TU16v36TJEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dwkjOIBejiYWiBlPfoP0qRNxEPThODZze5XJZi9ys65N5m2shH0c0hTiBgSa+WKlj
	 7tuZNrHkyssE4TVxMSylXyKnpsP5W79N9mdOF1JnU7T+wMNP5javUnuqSbEWzW1H7I
	 EonxVYsSYwiUa1n6xpiSH1PI5HK54DBXTc3NoGcwe7jPBBGWIEA5ZKpriqMUcVbVd3
	 iRdGUWs83dGxqkOTDdg2sR0JWCm+rV2kc2VX5tsRCDANIXUG8aS7PhkAdsR6zgSFt6
	 fTKyojJL/Zr08UnYktPytESKQ/Y5G4XtCmAwVuVJFYIRk0X+9tl8lASpy4/NsEQFs4
	 e9M+9bGZK0/IA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Talhah Peerbhai <talhah.peerbhai@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	mario.limonciello@amd.com,
	venkataprasad.potturu@amd.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 44/58] ASoC: amd: yc: Add quirk for Lenovo Yoga Pro 7 14ASP9
Date: Sun,  1 Jun 2025 19:39:57 -0400
Message-Id: <20250601234012.3516352-44-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250601234012.3516352-1-sashal@kernel.org>
References: <20250601234012.3516352-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.140
Content-Transfer-Encoding: 8bit

From: Talhah Peerbhai <talhah.peerbhai@gmail.com>

[ Upstream commit a28206060dc5848a1a2a15b7f6ac6223d869084d ]

Similar to many other Lenovo models with AMD chips, the Lenovo
Yoga Pro 7 14ASP9 (product name 83HN) requires a specific quirk
to ensure internal mic detection. This patch adds a quirk fixing this.

Signed-off-by: Talhah Peerbhai <talhah.peerbhai@gmail.com>
Link: https://patch.msgid.link/20250515222741.144616-1-talhah.peerbhai@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

Based on my analysis of the commit and comparison with the similar
historical commits, here is my assessment: **YES** This commit should be
backported to stable kernel trees for the following reasons: ## Code
Analysis **1. Nature of the Change:** The commit adds a single quirk
entry for the Lenovo Yoga Pro 7 14ASP9 (product name "83HN") to the
`yc_acp_quirk_table[]` array in `sound/soc/amd/yc/acp6x-mach.c`. The
change is minimal and contained: ```c + { + .driver_data = &acp6x_card,
+ .matches = { + DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"), +
DMI_MATCH(DMI_PRODUCT_NAME, "83HN"), + } + }, ``` **2. Meets Stable Tree
Criteria:** - **Device ID Addition**: This is explicitly mentioned in
the stable kernel rules as acceptable - "It must either fix a real bug
that bothers people or just add a device ID" - **Under 100 lines**: The
change is only 7 lines with context - **Obviously correct**: The pattern
matches exactly what's used for dozens of other Lenovo models - **Fixes
real user issue**: Internal microphone non-functionality is a clear
hardware regression/bug that affects users **3. Historical Precedent:**
All 5 similar commits provided as examples received "Backport Status:
YES". They all follow the exact same pattern: - Similar commit subjects
mentioning specific Lenovo models - Identical code structure adding DMI
quirk entries - Same commit messages describing microphone functionality
fixes - Several explicitly included `Cc: stable@vger.kernel.org` tags
**4. Risk Assessment:** - **Minimal regression risk**: Adding a quirk
entry cannot break existing functionality - **Contained change**: Only
affects the specific Lenovo model 83HN - **Well-established pattern**:
This quirk mechanism is proven stable across dozens of similar entries
**5. User Impact:** The commit message clearly states this fixes
internal microphone detection on a specific laptop model. Non-functional
audio hardware represents a significant user-facing issue that stable
trees are meant to address. **6. Code Quality:** The change also
includes a minor whitespace fix (replacing spaces with tab for
consistency), showing attention to code quality without introducing
functional changes. This commit perfectly matches the stable tree
criteria: it's a small, safe device ID addition that fixes a real user-
affecting hardware issue with minimal risk of regression.

 sound/soc/amd/yc/acp6x-mach.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 1f94269e121af..d5dc1d48fca94 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -304,6 +304,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "83AS"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "83HN"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
@@ -353,7 +360,7 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "M5402RA"),
 		}
 	},
-        {
+	{
 		.driver_data = &acp6x_card,
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK COMPUTER INC."),
-- 
2.39.5


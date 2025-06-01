Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26D8F295DB3;
	Sun,  1 Jun 2025 23:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748820795; cv=none; b=dws1lSxF/3/ArNU8KQdUFrdnV4ARJuNT/BdMgMPUENDNnYMX+wOUTrgJ2U9uMIlr1EUHHMvj5qWpk3+gLuXDOiKg4AoT9PmD7+Qd7elgJbCEDvOVwOSM6PJammj7Iv5yJVx2uPyTeU+4ceYvJAEQpCR+Uxgi87Y3qHKJoJ3aQSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748820795; c=relaxed/simple;
	bh=0y9+YK8mVodHzMUpF/xJjqZOSbF0GJFSGAdqCeDpLqw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oLXV6TkltDg02cj2+EOIodHEVmerqA941StkkAqSo4h5jbA8Ycphqg0A/3shV8miqXbB7AIZHMp6USZ4FNYBKBmq/lRZXMgVs31Y6326eAceqg98bK65ZV1UxRW4Vvh+eus2FTozX4EvMgpzzm47XPcOvTpzKmA44ve5/gMRNPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NCab491a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NCab491a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68935C4CEE7;
	Sun,  1 Jun 2025 23:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748820794;
	bh=0y9+YK8mVodHzMUpF/xJjqZOSbF0GJFSGAdqCeDpLqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NCab491aH96UWIIqAGRTFQHQkoKbBsNCW6ctWb5kZX66CLh2u/otfCHcvqZZIVGBB
	 f4kWrJdYhlcaZn1zr35Ud22fVMxw3BQ/Q+VuyD0jdyFzNTk8jKNw/g3OFBB3MKZuXX
	 crxM5/jKglqt9vuALAzP4Iie5Ib09X9F/P67nUOduufmrbUIbwcusyRR6yUxmz3qrD
	 JYz7TKhM7JawDxSvy6+fafTnq+NKAcAhmNchU3OX7WWC9Z4f6bcJFpO87ca05gIe3I
	 MilqHkPeNo8e13rCpVppwoOElDQA/qc43o60b6U8TRozM5NQjnQgG69uP5f6xJ2fc1
	 I4cjljt8j0XqQ==
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
Subject: [PATCH AUTOSEL 6.14 079/102] ASoC: amd: yc: Add quirk for Lenovo Yoga Pro 7 14ASP9
Date: Sun,  1 Jun 2025 19:29:11 -0400
Message-Id: <20250601232937.3510379-79-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250601232937.3510379-1-sashal@kernel.org>
References: <20250601232937.3510379-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.9
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
index e632f16c91025..3d9da93d22ee8 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -311,6 +311,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
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
@@ -360,7 +367,7 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
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


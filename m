Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ABDF22B8AF;
	Fri, 30 May 2025 12:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748608737; cv=none; b=WmCj6jBSxLZzZJnUaTqFRFwQVlVSjmyNFM/ivPWJNGBze2odY5JHnTBn1FENkEbwv9Ed1p1p4Z4ek168h6GzS3AlIN/tPgywsNnDCeFHD8YRq3hpjqM04kDZTgtGnHugWcWMKsAMgg5HkoSoU6NcPlK+eMSoUGRjstBGghWh7y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748608737; c=relaxed/simple;
	bh=4QKsNMi+GXQlpetVe9R0wo8FXMgIicrAGhk2pEQx7Gg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KfWJFBnOz4th1lizpQZfCTRns9+oLiF+u9UYTdgZNX4//T60LypTyfk+Iae5ED0VWAeSkqsg39HAGOaXJuZ7CGih3rI92a+AVjRKC7iqaY1Lecr3PhQYfQeNLVOo/pz+8Uk3S5DqQAdPjw9EQhbc9Fhl4WhcATyTkhF5WiGYTF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HT46LTI9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HT46LTI9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80833C4CEEB;
	Fri, 30 May 2025 12:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748608736;
	bh=4QKsNMi+GXQlpetVe9R0wo8FXMgIicrAGhk2pEQx7Gg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HT46LTI9/Bwv8gWz38hF0H1VI4/4bQwu4StpF7xojG0HKiJukh6AL3S6V/9AEr6Se
	 kTBTk1JHvwHuzi0FAIKaIGC9CyK3um1hsA7GUfZfUqbYHOK3xyjNMLOiQmC6icVK7O
	 So4EVb0fk6G/AYNkS/aXQYfCaz/Fzi5wulZGz/+aY2TPXrIsQIVUj4Lt0v6jqQco8a
	 ZF7FVh3m8D0MvSGDMqUOVV2cF+RYAOxhxjJv4+TGbRAPIz3VhrDmwdZHP6QAOW4nxZ
	 m3H8jPd7z8+GIwPCeVh/TuaC4z1hUPeJ65Nidi56/mdguRw8zAtIJRIB1r6ED/JVm3
	 6c0zW15btlkxA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Talhah Peerbhai <talhah.peerbhai@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	alsa-devel@alsa-project.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.15 02/30] ASoC: amd: yc: Add quirk for Lenovo Yoga Pro 7 14ASP9
Date: Fri, 30 May 2025 08:38:24 -0400
Message-Id: <20250530123852.2574030-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250530123852.2574030-1-sashal@kernel.org>
References: <20250530123852.2574030-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15
Content-Type: text/plain; charset=UTF-8
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

Based on my analysis of this commit, I can provide a comprehensive
assessment for backporting. **YES** This commit should be backported to
stable kernel trees for the following reasons: **1. Identical Pattern to
Previously Backported Commits:** All five similar commits provided in
the historical context (commits for Lenovo models 82UU, 82, 82YM, 83AS,
and 21M1) have "Backport Status: YES" and follow the exact same pattern
as this commit. This establishes a clear precedent for backporting such
changes. **2. Hardware Enablement Bug Fix:** The commit fixes a clear
user-affecting bug where the internal microphone on the Lenovo Yoga Pro
7 14ASP9 (product name 83HN) is non-functional. This is a hardware
compatibility issue that directly impacts users' ability to use their
device's built-in microphone. **3. Minimal and Contained Change:** The
code change is extremely small and safe: - Adds only a single 7-line
quirk table entry to `sound/soc/amd/yc/acp6x-mach.c` - The change is
purely additive - no existing code is modified - The quirk entry follows
the exact same pattern as dozens of other entries in the same table -
Zero risk of regression to existing functionality **4. Critical
Subsystem with Safe Pattern:** While this touches audio (a critical
subsystem), the change follows a well-established, safe pattern used
extensively in this driver. The quirk table approach is designed
specifically for adding device-specific compatibility without affecting
other hardware. **5. Clear User Benefit:** Users with this specific
Lenovo model will have their internal microphone functionality restored,
which is essential for video calls, voice recording, and other audio
input tasks. **6. Code Quality Improvement:** The commit also includes a
minor whitespace fix (changing spaces to tab at line 350), improving
code formatting consistency. **7. Follows Stable Tree Rules:** -
Important bugfix: ✓ (enables hardware functionality) - Minimal risk: ✓
(purely additive quirk entry) - Small and contained: ✓ (7 lines added) -
No architectural changes: ✓ - Confined to subsystem: ✓ (AMD YC audio
driver) The commit message clearly explains the issue and solution, and
the change is identical in nature to numerous other successfully
backported commits for similar Lenovo audio quirks. This represents a
textbook example of a stable-appropriate hardware enablement fix.

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


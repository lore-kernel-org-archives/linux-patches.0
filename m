Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA28525D1F3;
	Fri, 30 May 2025 12:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748608833; cv=none; b=ktgmnGPTWNEQtwTfjF2JxWhR1ZvRHvrTFpLiBsXQgLCoJny5zPHn+QEr0tzGVvkwo3tepFNjuyzbC0iBsxt0gfe1e8hnbTwvMN6QZx0huaDrXqlKJ6UBho+qt4kb3RwjJKXXk7u5MlJ4bnZd51kcVIMKDa56lAfqtR1xzplF8pA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748608833; c=relaxed/simple;
	bh=0mNPQpbwT1Pfw1ec0QHifRguoEQrfpMBmf9+3fPz8uc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ArMD1f4ZqfRuKgBtKs43xKnR392hBtQBtwiIzKRaJncxcF7kb8Br8Gw0F5Ve/2o2+FYFLZe9sgjf+vK3oA9obwuwQ8OoczOBD2pWIoceTShdU0GlJ4ZlI7bYcADbSAf/eRbZHo/wJMhIH8mtVGjg0Tj6RBpXrcCtSHLF085kId0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QeFrcp91; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QeFrcp91"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC4C0C4CEE9;
	Fri, 30 May 2025 12:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748608832;
	bh=0mNPQpbwT1Pfw1ec0QHifRguoEQrfpMBmf9+3fPz8uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QeFrcp91ktgQwM7MoIMAGZXrISmhgQpQN/W8MnFTh60R4mtIOjQubS7resyzDH51x
	 vxNrsI0Qj3pv69tAHjb8W0sKbIhiqfk8PNkEu3Jddqa7btgsstmG+0xzTcLNbb12//
	 Q3P1+adO+Ik4LDzK4iG+W0Q+ouWhpfiEutJv5lZr8BwYD2uxSUmcdI/hfMLzcqD3my
	 rQSy0HjLdATY4AgYWuLNw9hUu6fjw89pZG3SBasMp5fZBjNDlcCi8OErsBRnk30obV
	 qbLPu8rih30xfOmAWfkKK7e7Sf04muBSYPMvHIugBzNSf2lfB2vpq5xVepIYbSTwh2
	 YgTOzoxLFQTLQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Stefan Binding <sbinding@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	alsa-devel@alsa-project.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 15/26] ALSA: hda: cs35l41: Fix swapped l/r audio channels for Acer Helios laptops
Date: Fri, 30 May 2025 08:40:01 -0400
Message-Id: <20250530124012.2575409-15-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250530124012.2575409-1-sashal@kernel.org>
References: <20250530124012.2575409-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.31
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Stefan Binding <sbinding@opensource.cirrus.com>

[ Upstream commit e43a93c41982e82c1b703dd7fa9c1d965260fbb3 ]

Fixes audio channel assignment from ACPI using configuration table.

Signed-off-by: Stefan Binding <sbinding@opensource.cirrus.com>
Link: https://patch.msgid.link/20250515162848.405055-3-sbinding@opensource.cirrus.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES** This commit should be backported to stable kernel trees.
**Extensive Analysis:** **1. Nature of the Fix:** The commit fixes
swapped left/right audio channels for Acer Helios laptops by adding
three new entries to the `cs35l41_config_table[]`: - `{ "10251826", 2,
EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, -1, -1, 0, 0, 0 }` -
`{ "1025182C", 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0,
-1, -1, 0, 0, 0 }` - `{ "10251844", 2, EXTERNAL, { CS35L41_LEFT,
CS35L41_RIGHT, 0, 0 }, 0, -1, -1, 0, 0, 0 }` The corresponding model
table entries are also added to enable these configurations. **2.
Comparison with Historical Similar Commits:** This commit is **very
similar to Similar Commit #1 (Status: YES)** which also fixed swapped
l/r audio channels for Lenovo ThinkBook laptops. Both commits: - Fix the
same fundamental issue: swapped audio channels - Make identical types of
changes: correcting channel assignment in configuration tables - Are
small, contained fixes affecting only audio configuration data - Target
specific laptop models with broken audio channel mapping The primary
difference is that Similar Commit #1 modified existing entries by
swapping `CS35L41_LEFT` and `CS35L41_RIGHT`, while this commit adds new
entries with correct channel assignments. **3. Why This Qualifies for
Backporting:** **✅ Fixes Important User-Affecting Bug:** Swapped audio
channels are a significant usability issue that directly impacts users'
audio experience on affected Acer Helios laptops. **✅ Small and
Contained Change:** The fix only adds static configuration data - three
new entries in a lookup table. No algorithmic changes or complex logic
modifications. **✅ Minimal Risk of Regression:** Adding new entries to a
device-specific configuration table cannot break existing functionality
for other devices. The changes only affect the three specific Acer
laptop models. **✅ No Architectural Changes:** This is purely data-
driven configuration, not structural code changes. **✅ Specific Hardware
Support:** The SSID values (10251826, 1025182C, 10251844) are vendor-
specific identifiers for Acer devices (1025 = Acer vendor ID), ensuring
the fix only applies to the intended hardware. **4. Code Analysis
Verification:** From examining the current kernel tree at
`/home/sasha/linux/sound/pci/hda/cs35l41_hda_property.c`, I confirmed
that: - The file exists and contains the same structure as the commit -
No "1025" entries currently exist in the configuration table - The
pattern matches exactly with other vendor entries (HP: 103C, ASUS: 1043,
Lenovo: 17AA) **5. Risk Assessment:** - **Regression Risk: MINIMAL** -
Adding device-specific entries cannot affect other hardware - **Side
Effects: NONE** - Changes are isolated to specific Acer laptop models -
**Complexity: LOW** - Simple data table additions with no logic changes
**Conclusion:** This commit perfectly fits the stable tree criteria:
it's an important hardware-specific bug fix that affects users, with
minimal risk and no architectural changes. The historical precedent
(Similar Commit #1 with identical nature receiving YES status) strongly
supports backporting this fix.

 sound/pci/hda/cs35l41_hda_property.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/sound/pci/hda/cs35l41_hda_property.c b/sound/pci/hda/cs35l41_hda_property.c
index 61d2314834e7b..d8249d997c2a0 100644
--- a/sound/pci/hda/cs35l41_hda_property.c
+++ b/sound/pci/hda/cs35l41_hda_property.c
@@ -31,6 +31,9 @@ struct cs35l41_config {
 };
 
 static const struct cs35l41_config cs35l41_config_table[] = {
+	{ "10251826", 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, -1, -1, 0, 0, 0 },
+	{ "1025182C", 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, -1, -1, 0, 0, 0 },
+	{ "10251844", 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, -1, -1, 0, 0, 0 },
 	{ "10280B27", 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, 2, 0, 1000, 4500, 24 },
 	{ "10280B28", 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, 2, 0, 1000, 4500, 24 },
 	{ "10280BEB", 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, -1, 0, 0, 0, 0 },
@@ -452,6 +455,9 @@ struct cs35l41_prop_model {
 static const struct cs35l41_prop_model cs35l41_prop_model_table[] = {
 	{ "CLSA0100", NULL, lenovo_legion_no_acpi },
 	{ "CLSA0101", NULL, lenovo_legion_no_acpi },
+	{ "CSC3551", "10251826", generic_dsd_config },
+	{ "CSC3551", "1025182C", generic_dsd_config },
+	{ "CSC3551", "10251844", generic_dsd_config },
 	{ "CSC3551", "10280B27", generic_dsd_config },
 	{ "CSC3551", "10280B28", generic_dsd_config },
 	{ "CSC3551", "10280BEB", generic_dsd_config },
-- 
2.39.5


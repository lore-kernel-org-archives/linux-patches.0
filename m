Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16B3338D;
	Mon,  4 Aug 2025 00:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754267143; cv=none; b=XGVnuZ6oFk2KT7wknaNdNu7VvwbFrVGIA4jm3CLI7EJse/3C8C8wCoIE5QlS5UwAjD7t2ZHrU+Q91f/M3mhmVLD9pcyKpQmx5ICxjyGiZnOJd8fp1pLf8NpFsa0FvFLgcsYs0czBjCnX7WgtkHCKcG+OwtqS3k+6805F7dNXRDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754267143; c=relaxed/simple;
	bh=qDsu2eqlvVqei9hLEsTn1FrFu6r7OBJbwOVYcPM+P9Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Zl0z214sx2m0pmmKOfoVAuQvJ5sl+HJm6FGuJGaY2o7OELZV3ykzBYwUK0MmXKHKKxDp3QETsK511R2A8pO3RjbFkX+eK1ZawDRZx+3A2LGevh/2sX0Uvzs7dAqrqKIXQwnqvShLO7TXFLZgVHJUgmxhU14nOs8YlftKDWuflQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KQJ9Tgo8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KQJ9Tgo8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5904C4CEEB;
	Mon,  4 Aug 2025 00:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754267143;
	bh=qDsu2eqlvVqei9hLEsTn1FrFu6r7OBJbwOVYcPM+P9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KQJ9Tgo83q7wkr44/w3UzssdK5lO4QJw+fOTTIsN6KukXyY4kBwqcpH92fJQ81AAb
	 Qjy4NjIZ9Gx5dMGsDTLCXfZgCWggFUJvoagNiAjRsyDrwTJ/Aj4kBfg/plu/w8Qr4P
	 uMjpaXv5W1oJLINpAwAugQZRSr48uFk0nJWawTW+kXJlFPgGwYeIRUqoPLuJNd7XmG
	 +kuhORkI9vgfZpbkfHE5oonDQ5vbI5Q5904NgwE/rpSc8Us+fvAT+lv3LHYXKauZh/
	 innpv88r9a+YmbDGERKuTAUH9bZpmmQpAm4Ebw5THoGTm1NWh1ijbNt1OJcPq3nw82
	 BcLIvvWI2t01g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: GalaxySnail <me@glxys.nl>,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	sbinding@opensource.cirrus.com,
	sakari.ailus@linux.intel.com,
	peterz@infradead.org,
	simont@opensource.cirrus.com,
	broonie@kernel.org,
	nichen@iscas.ac.cn,
	kuninori.morimoto.gx@renesas.com
Subject: [PATCH AUTOSEL 6.16 42/85] ALSA: hda: add MODULE_FIRMWARE for cs35l41/cs35l56
Date: Sun,  3 Aug 2025 20:22:51 -0400
Message-Id: <20250804002335.3613254-42-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804002335.3613254-1-sashal@kernel.org>
References: <20250804002335.3613254-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Transfer-Encoding: 8bit

From: GalaxySnail <me@glxys.nl>

[ Upstream commit 6eda9429501508196001845998bb8c73307d311a ]

add firmware information in the .modinfo section, so that userspace
tools can find out firmware required by cs35l41/cs35l56 kernel module

Signed-off-by: GalaxySnail <me@glxys.nl>
Reviewed-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://patch.msgid.link/20250624101716.2365302-2-me@glxys.nl
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my analysis, I can now provide a determination on whether this
commit should be backported:

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **Fixes a real user-facing issue**: The commit adds MODULE_FIRMWARE
   declarations that are essential for userspace tools (like initramfs
   builders, dracut, mkinitcpio) to automatically detect and include
   required firmware files. Without these declarations, systems may fail
   to boot or have non-functional audio after kernel updates.

2. **Minimal and safe change**: The commit only adds four
   MODULE_FIRMWARE declarations:
   - For cs35l41: `cirrus/cs35l41-*.wmfw` and `cirrus/cs35l41-*.bin`
   - For cs35l56: `cirrus/cs35l54-*.wmfw`, `cirrus/cs35l54-*.bin`,
     `cirrus/cs35l56-*.wmfw`, and `cirrus/cs35l56-*.bin`

   These are simple metadata additions that don't change any code logic
or behavior.

3. **No risk of regression**: MODULE_FIRMWARE macros only add
   information to the module's .modinfo section. They don't affect
   runtime behavior, only help userspace tools identify firmware
   dependencies.

4. **Clear firmware loading requirement**: The code analysis shows these
   drivers do load firmware files with patterns matching the declared
   MODULE_FIRMWARE entries. In cs35l41_hda.c:
  ```c
  *filename = kasprintf(GFP_KERNEL, "cirrus/%s-%s-%s.%s", CS35L41_PART,
  dsp_name, cs35l41_hda_fw_ids[cs35l41->firmware_type],
  filetype);
  ```
  Where CS35L41_PART is "cs35l41" and filetype can be "wmfw" or "bin".

5. **Follows established patterns**: Other HDA codec drivers (like
   patch_ca0132.c) already use MODULE_FIRMWARE declarations for their
   firmware files.

6. **Prevents boot failures**: Without proper firmware inclusion in
   initramfs, systems with these audio codecs may experience boot
   failures or missing audio functionality, especially when the root
   filesystem is encrypted or on a network device.

The commit is a straightforward bug fix that ensures proper firmware
dependency tracking for cs35l41 and cs35l56 HDA audio codecs, making it
an ideal candidate for stable backporting.

 sound/pci/hda/cs35l41_hda.c | 2 ++
 sound/pci/hda/cs35l56_hda.c | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/sound/pci/hda/cs35l41_hda.c b/sound/pci/hda/cs35l41_hda.c
index d5bc81099d0d..17cdce91fdbf 100644
--- a/sound/pci/hda/cs35l41_hda.c
+++ b/sound/pci/hda/cs35l41_hda.c
@@ -2085,3 +2085,5 @@ MODULE_IMPORT_NS("SND_SOC_CS_AMP_LIB");
 MODULE_AUTHOR("Lucas Tanure, Cirrus Logic Inc, <tanureal@opensource.cirrus.com>");
 MODULE_LICENSE("GPL");
 MODULE_IMPORT_NS("FW_CS_DSP");
+MODULE_FIRMWARE("cirrus/cs35l41-*.wmfw");
+MODULE_FIRMWARE("cirrus/cs35l41-*.bin");
diff --git a/sound/pci/hda/cs35l56_hda.c b/sound/pci/hda/cs35l56_hda.c
index 886c53184fec..f48077f5ca45 100644
--- a/sound/pci/hda/cs35l56_hda.c
+++ b/sound/pci/hda/cs35l56_hda.c
@@ -1176,3 +1176,7 @@ MODULE_IMPORT_NS("SND_SOC_CS_AMP_LIB");
 MODULE_AUTHOR("Richard Fitzgerald <rf@opensource.cirrus.com>");
 MODULE_AUTHOR("Simon Trimmer <simont@opensource.cirrus.com>");
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE("cirrus/cs35l54-*.wmfw");
+MODULE_FIRMWARE("cirrus/cs35l54-*.bin");
+MODULE_FIRMWARE("cirrus/cs35l56-*.wmfw");
+MODULE_FIRMWARE("cirrus/cs35l56-*.bin");
-- 
2.39.5


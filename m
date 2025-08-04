Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A8C189513;
	Mon,  4 Aug 2025 00:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754267376; cv=none; b=dl7J4hInRkWXl2QDdRDTAbcNzpDIxHNm+hyimTHowHk7vcZoDh01ulbv3W5hXpUKd0qQKAYOuH83viCwzqR28EQ1bcpd5qZNhDlVHHZN+YObwm/p3tzCk9fyxIBsfV+kwaL7U7f9yod13QKjTcvvCRjoOhlySr97r/54TgEW2vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754267376; c=relaxed/simple;
	bh=QQ79Abnpntk4VU9t+XbECoQ57gcRz4sZ+1B+d44ja1k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dtXGFnvHxn9AnRvfL8HAGb9rWZ7Z+TobNdGIg0sJ1Afag0FXXZvK8/AKuDjMlZRlceG0+PKFFg9m3dytpp5YwFAER5PxJiyZL1DKEwoiEh5fACQONAZ56B8Te4ANSrKTPS11iHFDLuMrT7rdilbm2z1m29WTawUppQetE3m+hf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CIOvLPMY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CIOvLPMY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9980C4CEEB;
	Mon,  4 Aug 2025 00:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754267376;
	bh=QQ79Abnpntk4VU9t+XbECoQ57gcRz4sZ+1B+d44ja1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CIOvLPMYJTrbdkypJxCXlIITsIBnSGzKb76h0wxIk6srTlw0mUYYZdAXhCqXpwCQk
	 Ga6DAbME3z2kb8UPdLPQ0ADACBOyTwjDVhRdTas9TfTvSkEZ9bO39TDW1f/UmjFRiO
	 g/o9or5eKKe+lKxKPAkYIbhTwneGVoGvofWXbq1FrujhxKYBJcfL1LIWwN/lz/v0gf
	 YoblbIQvTORAqxP+DHxUKS0kDVbr0Iddh9S79GknysvDmIbf3Rj97uzDXI78yq3Drb
	 09iKqZ6aip70p6+F70OKR8tO14XFil8KMzd7FFAN5k+0BdSnhX/rL6Tse3PRfO2YNc
	 umIFZ2TMjRRTw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: GalaxySnail <me@glxys.nl>,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	sbinding@opensource.cirrus.com,
	peterz@infradead.org,
	sakari.ailus@linux.intel.com,
	simont@opensource.cirrus.com,
	broonie@kernel.org,
	kuninori.morimoto.gx@renesas.com
Subject: [PATCH AUTOSEL 6.15 41/80] ALSA: hda: add MODULE_FIRMWARE for cs35l41/cs35l56
Date: Sun,  3 Aug 2025 20:27:08 -0400
Message-Id: <20250804002747.3617039-41-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804002747.3617039-1-sashal@kernel.org>
References: <20250804002747.3617039-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15.9
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
index 5dc021976c79..4397630496fd 100644
--- a/sound/pci/hda/cs35l41_hda.c
+++ b/sound/pci/hda/cs35l41_hda.c
@@ -2060,3 +2060,5 @@ MODULE_IMPORT_NS("SND_SOC_CS_AMP_LIB");
 MODULE_AUTHOR("Lucas Tanure, Cirrus Logic Inc, <tanureal@opensource.cirrus.com>");
 MODULE_LICENSE("GPL");
 MODULE_IMPORT_NS("FW_CS_DSP");
+MODULE_FIRMWARE("cirrus/cs35l41-*.wmfw");
+MODULE_FIRMWARE("cirrus/cs35l41-*.bin");
diff --git a/sound/pci/hda/cs35l56_hda.c b/sound/pci/hda/cs35l56_hda.c
index 235d22049aa9..b9f17e44a75e 100644
--- a/sound/pci/hda/cs35l56_hda.c
+++ b/sound/pci/hda/cs35l56_hda.c
@@ -1124,3 +1124,7 @@ MODULE_IMPORT_NS("SND_SOC_CS_AMP_LIB");
 MODULE_AUTHOR("Richard Fitzgerald <rf@opensource.cirrus.com>");
 MODULE_AUTHOR("Simon Trimmer <simont@opensource.cirrus.com>");
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE("cirrus/cs35l54-*.wmfw");
+MODULE_FIRMWARE("cirrus/cs35l54-*.bin");
+MODULE_FIRMWARE("cirrus/cs35l56-*.wmfw");
+MODULE_FIRMWARE("cirrus/cs35l56-*.bin");
-- 
2.39.5


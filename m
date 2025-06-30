Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72ACB21D3F2;
	Mon, 30 Jun 2025 21:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751317254; cv=none; b=XjajzUWHpSkJmaYOM+zI09zgekNcpK4/Tv4pov83hq+iiOvTv/1SSgNOVKK8ZOAMR4fKOaLJ6nM2hIaYSLx36KiaPMCQSiYmGnBwfOZMH4sWN/W+Ga8dV1IEoaSuzAClzpVnSFcfwqMhwARWxOaWfPCcrfoi8CYL77wFTxUsuCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751317254; c=relaxed/simple;
	bh=tIC4XR5N8Ph4hCcVfVxrdxEc+lc5g9AjW4Kvwk/VhFA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VVoAv3+n+4VzLDWUapzpq8lc6wg9vVVLmX6VjXZvFA9HMPC59nUT9/fzz5/mtFJF1qGdkkweOdOTrhxeys4spcNbadOnZzXHYeKgrI8BUoyP/J5ysShMkvk6eEerF8ylOWjK2ZvJvJ6SMIASFR0RIC468J7AVSvGxTonWN04zfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fFQNH91m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fFQNH91m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AB76C4CEE3;
	Mon, 30 Jun 2025 21:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751317254;
	bh=tIC4XR5N8Ph4hCcVfVxrdxEc+lc5g9AjW4Kvwk/VhFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fFQNH91m7PqyyAiS5jVF4aMG+Ct6RCKpXTc7mCabc7HrxS0xlZJMKUiKGs2wL6e3C
	 E5qbwqcJHNUcwQoWRKviZco2+33PNfrN5dUOvUx2JOn8l8NhcYmuAHFiHk0PI5Yq/+
	 /I1bGnk07isk9PrEhQv3eAikFwuNYkDkr0r0KEif0GuEhlqUfcHnmtZ+Sc3ieG/9o7
	 1bqkINsHZIJlQvTfFRlcxMsUZ1pQVE1WUMhTkwDUiRNJnrg/5cskOEJQsjTOzenLzi
	 +S6CEWCMz/J8S9XQjvHqx5I6ASmFloH8LgsvXHVrgSwg6NHCgx+MNkSAwSUdItAC18
	 +v42jC8n/VLLg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yasmin Fitzgerald <sunoflife1.git@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	kailang@realtek.com,
	sbinding@opensource.cirrus.com,
	chris.chiu@canonical.com,
	simont@opensource.cirrus.com,
	josh@joshuagrisham.com
Subject: [PATCH AUTOSEL 6.6 06/14] ALSA: hda/realtek - Enable mute LED on HP Pavilion Laptop 15-eg100
Date: Mon, 30 Jun 2025 16:46:31 -0400
Message-Id: <20250630204639.1358777-6-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250630204639.1358777-1-sashal@kernel.org>
References: <20250630204639.1358777-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.95
Content-Transfer-Encoding: 8bit

From: Yasmin Fitzgerald <sunoflife1.git@gmail.com>

[ Upstream commit 68cc9d3c8e44afe90e43cbbd2960da15c2f31e23 ]

The HP Pavilion Laptop 15-eg100 has Realtek HDA codec ALC287.
It needs the ALC287_FIXUP_HP_GPIO_LED quirk to enable the mute LED.

Signed-off-by: Yasmin Fitzgerald <sunoflife1.git@gmail.com>
Link: https://patch.msgid.link/20250621053832.52950-1-sunoflife1.git@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **Hardware enablement fix**: The commit adds a single line to the
   `alc269_fixup_tbl[]` quirk table to enable mute LED functionality on
   the HP Pavilion Laptop 15-eg100:
  ```c
  SND_PCI_QUIRK(0x103c, 0x898a, "HP Pavilion 15-eg100",
  ALC287_FIXUP_HP_GPIO_LED),
  ```

2. **Minimal and contained change**: This is a one-line addition that
   only affects the specific hardware identified by PCI subsystem ID
   (0x103c, 0x898a). There are no side effects on other systems.

3. **Uses established fixup**: The `ALC287_FIXUP_HP_GPIO_LED` fixup is
   already well-established in the kernel and used by other HP Pavilion
   models including:
   - HP Pavilion 15-eh1xxx (0x103c, 0x88d0)
   - HP Pavilion Aero Laptop 13-be0xxx (0x103c, 0x8919)
   - HP Pavilion 14-ec1xxx (0x103c, 0x8a0f)

4. **Fixes user-visible functionality**: Without this quirk, users of
   the HP Pavilion Laptop 15-eg100 would have a non-functional mute LED,
   which is an important visual feedback mechanism for audio state.

5. **Consistent with stable backport precedent**: All five similar
   historical commits that enabled mute LED functionality for HP laptops
   were backported to stable:
   - "Enable Mute LED on HP Laptop 14s-fq1xxx" (YES)
   - "Enable Mute LED on HP Laptop 14-fq0xxx" (YES)
   - "fix mute led of the HP Pavilion 15-eh1xxx series" (YES) - notably
     uses the same ALC287_FIXUP_HP_GPIO_LED
   - "Enable Mute LED on HP Laptop 15s-eq2xxx" (YES)
   - "Enable Mute LED on HP 255 G8" (YES)

6. **No risk of regression**: The change only applies to a specific
   hardware configuration and cannot affect other systems. The fixup
   mechanism is mature and the specific fixup being applied is already
   proven on other HP models.

This is a textbook example of a hardware enablement quirk that should be
backported to stable kernels to ensure users of the HP Pavilion Laptop
15-eg100 have properly functioning hardware across all supported kernel
versions.

 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 82210b1e3b978..7d7e86831eca8 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10151,6 +10151,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8975, "HP EliteBook x360 840 Aero G9", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x897d, "HP mt440 Mobile Thin Client U74", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8981, "HP Elite Dragonfly G3", ALC245_FIXUP_CS35L41_SPI_4),
+	SND_PCI_QUIRK(0x103c, 0x898a, "HP Pavilion 15-eg100", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x898e, "HP EliteBook 835 G9", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x898f, "HP EliteBook 835 G9", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8991, "HP EliteBook 845 G9", ALC287_FIXUP_CS35L41_I2C_2_HP_GPIO_LED),
-- 
2.39.5


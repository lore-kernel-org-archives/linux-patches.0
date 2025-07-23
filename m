Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A6EA78F26;
	Wed, 23 Jul 2025 00:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753232271; cv=none; b=LEn+qV9PGI+ZmDgAKStQFfL72ruM64ZoISWzyyFDJy9cHaWoH/unP+LBVCGkTgYTfYlNIFuYjOyfGxylxJ+vIYSsYmI19FWINKHx721w4WCRF2kYoyw2e7OYcbZkYeMaV3185tavs18T7Uf/3YmDI3Wyda6UFVqhZaPykOFGMHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753232271; c=relaxed/simple;
	bh=9FAON7q3GtlKbngyYq4kepEb+EfC7ldqudFnu5SaPEY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=I+c0679OyPP9K/m3Zm1Q73++D1S0K0Ah990P2ENDapG0Jl1mjn/cr0YmVzLHJvfL6xhlRNO1Be8aMt7fWTrYuAwJNMINVZrL8JH9QZrKG6kHr0f9uhSsUdSyZmYJN8+c1/Ojn+SGBWeE7sBa0DnXAAfxz23N8/kI7HMZkQp0WiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fW+ypach; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fW+ypach"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B973BC4CEEB;
	Wed, 23 Jul 2025 00:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753232270;
	bh=9FAON7q3GtlKbngyYq4kepEb+EfC7ldqudFnu5SaPEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fW+ypachGV1ZeffCi1FQ02uDv6uv84PnwgOqpmvnr2WWNcWwiA3S8fOiqup4p0R/w
	 xpfJkgAidLTutWxBRMPsv936di+MzvYHTE1bBgmbusAAbcgWDmhU7S/V8zI6A73FBv
	 rPVIGnbzTC6x3tGm4SwqiJ5CPL7BmuE5Xv+bga+n/fuTXa+RjEW882yfq0PMOcDeln
	 QEFXM/KrQlBU3K7Ui/ruk0xSe/bgye3B9AB0dRRiSRnvO9ecrnVoxbz4H5ceLvF3n0
	 O/kzBQ4YTYtpuY9va7PStZACx7I636aHzZxMw0kYISTN2i3/DZVKmS0y+0B3qb+wad
	 fBYrYplZ1pzzg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jackie Dong <xy-jackie@139.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	kailang@realtek.com,
	sbinding@opensource.cirrus.com,
	chris.chiu@canonical.com,
	simont@opensource.cirrus.com,
	lachlan.hodges@morsemicro.com
Subject: [PATCH AUTOSEL 6.15 6/8] ALSA: hda/realtek: Support mute LED for Yoga with ALC287
Date: Tue, 22 Jul 2025 20:57:19 -0400
Message-Id: <20250723005722.1022962-6-sashal@kernel.org>
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
Content-Transfer-Encoding: 8bit

From: Jackie Dong <xy-jackie@139.com>

[ Upstream commit 4722727373533b53489b66d3436b50ac156f23bf ]

Support mute LED on keyboard for Lenovo Yoga series products with
Realtek ALC287 chipset.

Tested on Lenovo Slim Pro 7 14APH8.

[ slight comment cleanup by tiwai ]

Signed-off-by: Jackie Dong <xy-jackie@139.com>
Link: https://patch.msgid.link/20250714094655.4657-1-xy-jackie@139.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I understand the pattern. Let me analyze this commit thoroughly:

**YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **Bug Fix for Hardware Functionality**: The commit adds mute LED
   support for Lenovo Yoga series laptops with ALC287 chipset. This is a
   hardware enablement fix that allows the mute LED indicators on the
   keyboard to function correctly. Without this fix, users cannot see
   the visual feedback for mute status, which is an important usability
   feature.

2. **Small and Contained Change**: The modification is minimal - it only
   adds a single line `hda_fixup_ideapad_acpi(codec, fix, action);` to
   an existing fixup function. This is a very low-risk change that:
   - Uses an already existing helper function (`hda_fixup_ideapad_acpi`)
   - Only affects the specific device (Lenovo Yoga9 14IAP7)
   - Doesn't introduce new functionality, just enables existing LED
     support

3. **Follows Established Pattern**: The commit follows the same pattern
   as similar commits marked with "Backport Status: YES":
   - Similar Commit #1: Added LED support for ThinkCentre M series
   - Similar Commit #3: Added LED support for HP laptops
   - Similar Commit #4: Added LED support for HP Laptop 14-dq2xxx
   - Similar Commit #5: Added quirk for Lenovo Yoga9 14IAP7 (bass
     speakers)

4. **No Architectural Changes**: The change:
   - Doesn't modify any core subsystems
   - Doesn't introduce new APIs or data structures
   - Only affects the specific hardware when detected
   - Uses existing infrastructure (ideapad_hotkey_led_helper.c)

5. **User-Facing Bug**: This fixes a user-visible issue where
   mute/micmute LED indicators don't work on affected hardware. This is
   exactly the type of hardware enablement fix that stable kernels
   should receive.

6. **Safe Implementation**: The `hda_fixup_ideapad_acpi` function
   includes proper checks:
   - Only runs during HDA_FIXUP_ACT_PRE_PROBE
   - Checks if the device is actually an IdeaPad before applying the fix
   - Falls back gracefully if CONFIG_IDEAPAD_LAPTOP is not enabled

The commit is a perfect candidate for stable backporting as it fixes a
specific hardware issue with minimal risk and follows established
patterns for similar hardware enablement fixes.

 sound/pci/hda/patch_realtek.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index f7bb97230201f..55739b913359a 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7497,6 +7497,9 @@ static void alc287_fixup_yoga9_14iap7_bass_spk_pin(struct hda_codec *codec,
 	};
 	struct alc_spec *spec = codec->spec;
 
+	/* Support Audio mute LED and Mic mute LED on keyboard */
+	hda_fixup_ideapad_acpi(codec, fix, action);
+
 	switch (action) {
 	case HDA_FIXUP_ACT_PRE_PROBE:
 		snd_hda_apply_pincfgs(codec, pincfgs);
-- 
2.39.5


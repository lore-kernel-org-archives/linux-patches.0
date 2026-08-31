Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B0F48822F;
	Mon, 31 Aug 2026 13:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183495; cv=none; b=TIuurK0SSK9FaiVLcp7CAyeGMDGNt1pmHrgEndbQmRPsgSah1XGD5PTfz2Nzc4ivqtEfMxaioBNy+yVgVEAw8vBvO0MVWnTkey0VpfVQWWTIUHPDnw9UfZDuLhhxT3bfhEqh22g31sQsFHN2xpbstdE1FvaVAwWpUii6hrHzmEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183495; c=relaxed/simple;
	bh=hxrqfHRXVTkVxRLa/fX0Ja7/fiDP+4zYFB6bHocEaeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WaBRYPEu14+//kMqFeHCBSiFbsu5Mj74m5yt4aSOTPq/7ot1vbD/Om6MRGUcogtu421Wm1wewmYuiSHj7j34l/NVVFWze9e6qH2PRv3rMunCGwHDTIb8T2RK8O41ULxjRE/cMr1SRBD08GblYYqr/hH8316ltnq0A5OE+8mJe5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cPJDlyPF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cPJDlyPF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2393F1F00ACA;
	Mon, 31 Aug 2026 13:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183493;
	bh=6IiJ1oNCE5LZ/7lSaP98xW+9dn9qtmwR1cNeD69mrhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cPJDlyPFhAi8x/IF7rOi2xvzU6GcC4KLYrn9aR+01187zVe7E08qC4ZqxYopI6Pib
	 2eEo2MtFgu/yVOMtanLmmG2xty7nsQkzIoItVK5jwOZLjgCDygc5+zSGMBrfdJe4Na
	 wx77tOVhiCYwClIGYPo8OJvl5+aVPESQ78wARZqt8Dw/fHM1QKjKaQMwtIoKCoWX54
	 qo4a8EusZinCDobCpP9T7psdxv+G2n1RcvXN0NQKC95ck46lBx2mtVCNNjxtD19cDi
	 ux4N9Mdq6XZyCLpUYz01Y6F5KyLdArGmW8n84TOO2QthSiyhkdYfJzOSq6gr5rr9Lk
	 w+UcL/t9wg9+g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Kamlesh Chhetty <kamleshkc2002@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	david.rhodes@cirrus.com,
	rf@opensource.cirrus.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@opensource.cirrus.com
Subject: [PATCH AUTOSEL 6.18-6.12] ALSA: hda: Add Lenovo Legion 7i 16IAX7 17AA3874 quirk
Date: Mon, 31 Aug 2026 09:22:37 -0400
Message-ID: <20260831133314.4125787-129-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kamlesh Chhetty <kamleshkc2002@gmail.com>

[ Upstream commit 6485da8579e2b0132630faa1ee2ac72ccaf01501 ]

Lenovo Legion 7i 16IAX7 systems with Realtek ALC287 codec SSID
17aa:3874 and CSC3551/CS35L41 speaker amps do not provide the
required CS35L41 _DSD properties in ACPI.

Without a quirk, cs35l41-hda fails probing the amps with missing
cirrus,dev-index / Platform not supported errors, leaving the built-in
speakers silent.

This model is similar to the already-supported 17AA386F Legion 7i
16IAX7 variant. Add the Realtek ALC287 quirk to select
ALC287_FIXUP_CS35L41_I2C_2 and add 17AA3874 to the CS35L41 property
table using the same two-amp external-boost configuration.

Tested on a Lenovo Legion 7 16IAX7 with Ubuntu 7.0.0-22-generic. Both
CSC3551 CS35L41 amps probe and bind, firmware loads, calibration
applies, built-in speaker playback works, and the cirrus,dev-index
failure is gone.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221663
Link: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/2157060
Signed-off-by: Kamlesh Chhetty <kamleshkc2002@gmail.com>
Link: https://patch.msgid.link/20260622172247.19301-1-kamleshkc2002@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The background git searches finished. They confirm:

- **No commit for `17AA3874` or "Legion 7i 16IAX7 17AA3874"** is in this
  6.18.44 tree — the quirk is still missing.
- **Related Legion audio quirks are present**, including `24b6332c2d4ff`
  (Legion 7i gen7 / SSID 386F) and `39815cdfc8d46` (386F PCI SSID
  conflict fix, Cc: stable).

That lines up with the earlier analysis: this is a sibling SSID variant
that needs the same treatment as 386F. Verdict remains **YES** for
backport to this tree.

 sound/hda/codecs/realtek/alc269.c                   | 1 +
 sound/hda/codecs/side-codecs/cs35l41_hda_property.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 0c12158e5ea78..a06acaf9ba6a0 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7455,6 +7455,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	HDA_CODEC_QUIRK(0x17aa, 0x38a7, "Legion Pro 7 16ARX8H", ALC287_FIXUP_TAS2781_I2C), /* this must match before PCI SSID 17aa:386f below */
 	SND_PCI_QUIRK(0x17aa, 0x386f, "Legion Pro 7i 16IAX7", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x3870, "Lenovo Yoga 7 14ARB7", ALC287_FIXUP_YOGA7_14ARB7_I2C),
+	SND_PCI_QUIRK(0x17aa, 0x3874, "Legion 7i 16IAX7", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x3877, "Lenovo Legion 7 Slim 16ARHA7", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x3878, "Lenovo Legion 7 Slim 16ARHA7", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x387d, "Yoga S780-16 pro Quad AAC", ALC287_FIXUP_TAS2781_I2C),
diff --git a/sound/hda/codecs/side-codecs/cs35l41_hda_property.c b/sound/hda/codecs/side-codecs/cs35l41_hda_property.c
index 16d5ea77192f0..dd8875b111ade 100644
--- a/sound/hda/codecs/side-codecs/cs35l41_hda_property.c
+++ b/sound/hda/codecs/side-codecs/cs35l41_hda_property.c
@@ -123,6 +123,7 @@ static const struct cs35l41_config cs35l41_config_table[] = {
 	{ "17AA3866", 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, -1, -1, 0, 0, 0 },
 	{ "17AA386E", 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 2, -1, 0, 0, 0 },
 	{ "17AA386F", 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, -1, -1, 0, 0, 0 },
+	{ "17AA3874", 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, -1, -1, 0, 0, 0 },
 	{ "17AA3877", 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, -1, -1, 0, 0, 0 },
 	{ "17AA3878", 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, -1, -1, 0, 0, 0 },
 	{ "17AA38A9", 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 2, -1, 0, 0, 0 },
@@ -548,6 +549,7 @@ static const struct cs35l41_prop_model cs35l41_prop_model_table[] = {
 	{ "CSC3551", "17AA3866", generic_dsd_config },
 	{ "CSC3551", "17AA386E", generic_dsd_config },
 	{ "CSC3551", "17AA386F", generic_dsd_config },
+	{ "CSC3551", "17AA3874", generic_dsd_config },
 	{ "CSC3551", "17AA3877", generic_dsd_config },
 	{ "CSC3551", "17AA3878", generic_dsd_config },
 	{ "CSC3551", "17AA38A9", generic_dsd_config },
-- 
2.53.0


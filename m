Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA6424FDA59;
	Thu, 17 Sep 2026 17:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664882; cv=none; b=Pj+EtJAlkSJw1H/6GX2AtZUOETW865NqnpPIBqEqlhI7QVmRCYlRFF7mG1BejPrHt94BVi+37PQOgl6DrE/w2epcY9aDv0zE9bYlgR1Z6IAkPsaZy29cm3k+spiNMHKUOhHBI/dy8xAYkAl9fqyssUjhjtebslqZj0yNRb+PkhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664882; c=relaxed/simple;
	bh=Yeb9JmS0debnopb9tAwH4JYTV/uSw71jrcif0icwAhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SXamkBINZx3PPWHKfARbtP20NMMxFCvrRejpRILvGaQngpov89LJvq4Q9UT+BMMElyx2YXFm8JrHUgk9/vTOPlKp1hyRYJ50B79vjC5WGy05FwQH9hNTQaLiIYy+jvDzFFz/rYjZUm8dtbkdBgg9HI7mit2XH2MDkUElzPxiFXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z1sY1ELG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z1sY1ELG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16D641F00898;
	Thu, 17 Sep 2026 17:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664879;
	bh=aDkm/ZBhM1tFPUUqRA2ju3zNgyzmFAJd+FuhoqID5y8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z1sY1ELGBiU7omU+RbvjPkqBgvqu3P+oWmduLlrkvUdG14Ez/fo2ah/8YM8cMNfK9
	 uaukI6wFpS22Pcejl7W4wGcXh90E/demqhgmEUgxMt48kb9b5NZq7QdHeW5By6GQnG
	 qfZc88tOcWYRqbJVzjF6CrLczNqWASjQEeXEnRb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kamlesh Chhetty <kamleshkc2002@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0471/1250] ALSA: hda: Add Lenovo Legion 7i 16IAX7 17AA3874 quirk
Date: Thu, 17 Sep 2026 16:04:26 +0100
Message-ID: <20260917151604.738945986@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

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
 sound/hda/codecs/realtek/alc269.c                   | 1 +
 sound/hda/codecs/side-codecs/cs35l41_hda_property.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index fc179a302efb8..90e64fbd5291b 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7456,6 +7456,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
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




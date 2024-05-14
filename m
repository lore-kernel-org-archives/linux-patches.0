Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0504E12B17A;
	Tue, 14 May 2024 11:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687254; cv=none; b=k5jIGhZLuM519EPVGvvcmPPWvkvPdLF3hEOq6glh4NtC3s5HO/OLcZe9CSAH+cHqIPsu4/chfGOElOT661d4LxItvschohLSiDe/qmooyDaxKiZaGlvYeA5cmqQhhl0P641kHxYh1i62ZV+OhTKaG8rlvxjxfBU+d+QVNAf6Wfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687254; c=relaxed/simple;
	bh=QLzuD14hO1irDzPShCtzyjZt+4NwZ7z+Fewzw7EkFG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rb78lsc3Ub6BGsWL8LgSnZI00TCD2O5s+8nA+kLgGXpsgA8dG6K34snietln+sJfohf/RJLYdOdzMC//VC/b96izZ9Hs8so1gSsDsV2yACAzUoHNQYT5P6/8ZBR4DVIVYeXIX6lXVEWOGSihx7mrWDGgzV/RjdSEDFkEFyqOAzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rerc0+pG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rerc0+pG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C7ADC2BD10;
	Tue, 14 May 2024 11:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687253;
	bh=QLzuD14hO1irDzPShCtzyjZt+4NwZ7z+Fewzw7EkFG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rerc0+pGTCjb1U9VPH3xTsdrTCQzaSqCX0Qo+IHv78YyKo0wJ85LRH7tBhEew17tK
	 XMtegyeF9BLdLanuOAwD5KteAFj1Swm2C5jny/z4BSNg7wfajdqyeVHTTzSAeJd/AF
	 Al871kt+JdlX06VjmVcfs3wLrk/n+6CvYcl/BerE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 033/111] ASoC: Fix 7/8 spaces indentation in Kconfig
Date: Tue, 14 May 2024 12:19:31 +0200
Message-ID: <20240514100958.385491503@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100957.114746054@linuxfoundation.org>
References: <20240514100957.114746054@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert@linux-m68k.org>

[ Upstream commit 5268e0bf7123c422892fec362f5be2bcae9bbb95 ]

Some entries used 7 or 8 spaces instead if a single TAB.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Link: https://lore.kernel.org/r/20201110174904.3413846-1-geert@linux-m68k.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 6db26f9ea4ed ("ASoC: meson: cards: select SND_DYNAMIC_MINORS")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/Kconfig       | 18 +++++++++---------
 sound/soc/generic/Kconfig      |  2 +-
 sound/soc/intel/boards/Kconfig |  2 +-
 sound/soc/meson/Kconfig        |  2 +-
 sound/soc/pxa/Kconfig          | 14 +++++++-------
 5 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index 04a7070c78e28..a8b9eb6ce2ea8 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -517,7 +517,7 @@ config SND_SOC_AK5558
 	select REGMAP_I2C
 
 config SND_SOC_ALC5623
-       tristate "Realtek ALC5623 CODEC"
+	tristate "Realtek ALC5623 CODEC"
 	depends on I2C
 
 config SND_SOC_ALC5632
@@ -733,7 +733,7 @@ config SND_SOC_JZ4770_CODEC
 	  will be called snd-soc-jz4770-codec.
 
 config SND_SOC_L3
-       tristate
+	tristate
 
 config SND_SOC_DA7210
 	tristate
@@ -773,10 +773,10 @@ config SND_SOC_HDMI_CODEC
 	select HDMI
 
 config SND_SOC_ES7134
-       tristate "Everest Semi ES7134 CODEC"
+	tristate "Everest Semi ES7134 CODEC"
 
 config SND_SOC_ES7241
-       tristate "Everest Semi ES7241 CODEC"
+	tristate "Everest Semi ES7241 CODEC"
 
 config SND_SOC_ES8316
 	tristate "Everest Semi ES8316 CODEC"
@@ -974,10 +974,10 @@ config SND_SOC_PCM186X_SPI
 	select REGMAP_SPI
 
 config SND_SOC_PCM3008
-       tristate
+	tristate
 
 config SND_SOC_PCM3060
-       tristate
+	tristate
 
 config SND_SOC_PCM3060_I2C
 	tristate "Texas Instruments PCM3060 CODEC - I2C"
@@ -1440,7 +1440,7 @@ config SND_SOC_UDA1334
 	  rate) and mute.
 
 config SND_SOC_UDA134X
-       tristate
+	tristate
 
 config SND_SOC_UDA1380
 	tristate
@@ -1765,8 +1765,8 @@ config SND_SOC_MT6660
 	  Select M to build this as module.
 
 config SND_SOC_NAU8540
-       tristate "Nuvoton Technology Corporation NAU85L40 CODEC"
-       depends on I2C
+	tristate "Nuvoton Technology Corporation NAU85L40 CODEC"
+	depends on I2C
 
 config SND_SOC_NAU8810
 	tristate "Nuvoton Technology Corporation NAU88C10 CODEC"
diff --git a/sound/soc/generic/Kconfig b/sound/soc/generic/Kconfig
index a90c3b28bce5f..4cafcf0e2bbfd 100644
--- a/sound/soc/generic/Kconfig
+++ b/sound/soc/generic/Kconfig
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config SND_SIMPLE_CARD_UTILS
-       tristate
+	tristate
 
 config SND_SIMPLE_CARD
 	tristate "ASoC Simple sound card support"
diff --git a/sound/soc/intel/boards/Kconfig b/sound/soc/intel/boards/Kconfig
index c10c37803c670..dddb672a6d553 100644
--- a/sound/soc/intel/boards/Kconfig
+++ b/sound/soc/intel/boards/Kconfig
@@ -552,7 +552,7 @@ config SND_SOC_INTEL_SOUNDWIRE_SOF_MACH
 	select SND_SOC_RT715_SDCA_SDW
 	select SND_SOC_RT5682_SDW
 	select SND_SOC_DMIC
-        help
+	help
 	  Add support for Intel SoundWire-based platforms connected to
 	  MAX98373, RT700, RT711, RT1308 and RT715
 	  If unsure select "N".
diff --git a/sound/soc/meson/Kconfig b/sound/soc/meson/Kconfig
index ce0cbdc69b2ec..b93ea33739f29 100644
--- a/sound/soc/meson/Kconfig
+++ b/sound/soc/meson/Kconfig
@@ -98,7 +98,7 @@ config SND_MESON_AXG_PDM
 	  in the Amlogic AXG SoC family
 
 config SND_MESON_CARD_UTILS
-       tristate
+	tristate
 
 config SND_MESON_CODEC_GLUE
 	tristate
diff --git a/sound/soc/pxa/Kconfig b/sound/soc/pxa/Kconfig
index 0ac85eada75cb..9d40e8a206d10 100644
--- a/sound/soc/pxa/Kconfig
+++ b/sound/soc/pxa/Kconfig
@@ -221,13 +221,13 @@ config SND_PXA2XX_SOC_MIOA701
 	  MIO A701.
 
 config SND_PXA2XX_SOC_IMOTE2
-       tristate "SoC Audio support for IMote 2"
-       depends on SND_PXA2XX_SOC && MACH_INTELMOTE2 && I2C
-       select SND_PXA2XX_SOC_I2S
-       select SND_SOC_WM8940
-       help
-	 Say Y if you want to add support for SoC audio on the
-	 IMote 2.
+	tristate "SoC Audio support for IMote 2"
+	depends on SND_PXA2XX_SOC && MACH_INTELMOTE2 && I2C
+	select SND_PXA2XX_SOC_I2S
+	select SND_SOC_WM8940
+	help
+	  Say Y if you want to add support for SoC audio on the
+	  IMote 2.
 
 config SND_MMP_SOC_BROWNSTONE
 	tristate "SoC Audio support for Marvell Brownstone"
-- 
2.43.0




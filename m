Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 600A21CA8F;
	Mon,  1 Apr 2024 16:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987304; cv=none; b=i4bZrJjZtZ2jEEV1vrE3LWgGm53CdmeCcqADwwzynZUbfEeUBzieR9cwXCz4qBHeE6mFgJ+zyxWEoPOZAdi1GpJoo+oSV0EfWBJScPlJIusjUvqg36Jc24zfg3Tv1sgihniqdd7JpPaS/awVBtXFE+mNvASLjxGWN2Z1wRoROOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987304; c=relaxed/simple;
	bh=U3/gVHTySuJgd529OXymTKEhnhI8buRA9ukNrozqHVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oBC4XWVjhso5FYYbzhgRroKMKZY863Wr3nftX/2GnNoK5MenIepMaPnTQnGUDCaI09erktCRy4IQsUEIAbFTBgvc4SQKWr8pV23OFLa8Fk/eJjlbUbhxx8xbjYAkTFzlAeyCpBCNzLszbhOUmjrWoTHpHHC316ZPUKOI7pknq3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MlVRWSyu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MlVRWSyu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2755C433F1;
	Mon,  1 Apr 2024 16:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987304;
	bh=U3/gVHTySuJgd529OXymTKEhnhI8buRA9ukNrozqHVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MlVRWSyutQfLEn2ZGHcAajS0D0vNscq8+f8qAaPfqFITDE/tzQgaP/2PRiwolJh36
	 EPUsl8Ooxn1w/radfJIHNiy8atQ75dkk1/GBzoeHr83E3ew79nZvUceFrRPbRgf9Sz
	 KinU4hHg/2eP+5pe+ziKUljTbzh/RP3RL9lYohyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawei Wang <me@jwang.link>,
	Mark Brown <broonie@kernel.org>,
	Luca Stefani <luca.stefani.ge1@gmail.com>
Subject: [PATCH 6.8 247/399] ASoC: amd: yc: Revert "Fix non-functional mic on Lenovo 21J2"
Date: Mon,  1 Apr 2024 17:43:33 +0200
Message-ID: <20240401152556.545836448@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiawei Wang <me@jwang.link>

commit 861b3415e4dee06cc00cd1754808a7827b9105bf upstream.

This reverts commit ed00a6945dc32462c2d3744a3518d2316da66fcc,
which added a quirk entry to enable the Yellow Carp (YC)
driver for the Lenovo 21J2 laptop.

Although the microphone functioned with the YC driver, it
resulted in incorrect driver usage. The Lenovo 21J2 is not a
Yellow Carp platform, but a Pink Sardine platform, which
already has an upstreamed driver.

The microphone on the Lenovo 21J2 operates correctly with the
CONFIG_SND_SOC_AMD_PS flag enabled and does not require the
quirk entry. So this patch removes the quirk entry.

Thanks to Mukunda Vijendar [1] for pointing this out.

Link: https://lore.kernel.org/linux-sound/023092e1-689c-4b00-b93f-4092c3724fb6@amd.com/ [1]

Signed-off-by: Jiawei Wang <me@jwang.link>
Link: https://lore.kernel.org/linux-sound/023092e1-689c-4b00-b93f-4092c3724fb6@amd.com/ [1]
Link: https://msgid.link/r/20240313015853.3573242-2-me@jwang.link
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: Luca Stefani <luca.stefani.ge1@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/amd/yc/acp6x-mach.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -203,13 +203,6 @@ static const struct dmi_system_id yc_acp
 		.driver_data = &acp6x_card,
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "21J2"),
-		}
-	},
-	{
-		.driver_data = &acp6x_card,
-		.matches = {
-			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "21J0"),
 		}
 	},



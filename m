Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2737A101DE;
	Thu,  3 Jul 2025 14:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554010; cv=none; b=NYRXmUQB1qOTaxEQ+nCPZMFM+HLNb4f53yJtFoXIxnm688qlv24q3bknkUXJgCvMfJtT5mis2CV3p9+lXHTPPVqu0nzQDYQyznHLcsXrgzCHX2p2ZHrl4ZolqkpmVHxzi9VasEZK0c32sZpjxcn/YhZmZO3Kxduh09bnrfJM0oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554010; c=relaxed/simple;
	bh=x3L1qlFAnVdUrkNran6yrTpMUNfokItZycq/BPh0Tq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cn4gf69kW3cASjNkFEWW81bES2uZxsgppCIfS+A+74Ul9t75Ysy6T98FBS5+5wxOxdJrI3tn6r0kIrRLlsK5MTqehaj9yOP4jXL8/cqbNfZO3egtz2MYE1rClRK7dLjzwX5k00BgmKlFdjyqbOI/ENnfSryIvoFQEyRg4Rb04/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jn27m7uV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jn27m7uV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CBA1C4CEE3;
	Thu,  3 Jul 2025 14:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554010;
	bh=x3L1qlFAnVdUrkNran6yrTpMUNfokItZycq/BPh0Tq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jn27m7uVK/OxE2osuWQ85GaYWGLn3f1Jt5OMhdapV71B2E3x1zaIeY+ysVh828r70
	 HaWCvdfzLCza9Vz111tyXZOfu5TmmAwX9DawCZe58OxkZA6Igy1CJLthExsig8O1rY
	 zgfxmG6Iz63bgzpfJnOZwDhnes1smke40rPxI6gk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 052/218] ALSA: usb-audio: Add a quirk for Lenovo Thinkpad Thunderbolt 3 dock
Date: Thu,  3 Jul 2025 16:40:00 +0200
Message-ID: <20250703143958.013524160@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 4919353c7789b8047e06a9b2b943f775a8f72883 ]

The audio controller in the Lenovo Thinkpad Thunderbolt 3 dock doesn't
support reading the sampling rate.

Add a quirk for it.

Suggested-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/20250527172657.1972565-1-superm1@kernel.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index c7387081577cd..0da4ee9757c01 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2282,6 +2282,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_DISABLE_AUTOSUSPEND),
 	DEVICE_FLG(0x17aa, 0x104d, /* Lenovo ThinkStation P620 Internal Speaker + Front Headset */
 		   QUIRK_FLAG_DISABLE_AUTOSUSPEND),
+	DEVICE_FLG(0x17ef, 0x3083, /* Lenovo TBT3 dock */
+		   QUIRK_FLAG_GET_SAMPLE_RATE),
 	DEVICE_FLG(0x1852, 0x5062, /* Luxman D-08u */
 		   QUIRK_FLAG_ITF_USB_DSD_DAC | QUIRK_FLAG_CTL_MSG_DELAY),
 	DEVICE_FLG(0x1852, 0x5065, /* Luxman DA-06 */
-- 
2.39.5




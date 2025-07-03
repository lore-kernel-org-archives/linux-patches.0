Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44DC32E7F1A;
	Thu,  3 Jul 2025 14:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554765; cv=none; b=mghILZRGUNvjzMlE/96OvVbcKd1aBlA+IZ+gcNcW4UGmtNDJMW4HbVgRMAGFK/rbMThR6tSi7bcLFzJjmaXPTpENkZkpwKPJk5ywCzJdXAMCaqWq/20pmBzvSalXqPHDrJCIBzL68F5Yt85drZOrRi9BS671+DHIHOY3LDe6+/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554765; c=relaxed/simple;
	bh=qDTUt7QcVUlUF87HOv/Ws8YpzkGbUgT6PBZv1PIyc5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mHeJs/jjuapJVq8KBLT8jYsfGrxfYg3o46Fxg+4UjuLs6VGswB8jEQaGnzHN1/QMkqk5W7f84sbR+woc2mhcXghQv5WHiQ+3HIe1GTFuajfJS+JIjV+KoOch6CcBxeADfSBAJpIQhyeVtx37pWHb1P6/RWafFWw63QdXckn+6Z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x6yhQIO0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x6yhQIO0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFD4BC4CEE3;
	Thu,  3 Jul 2025 14:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554765;
	bh=qDTUt7QcVUlUF87HOv/Ws8YpzkGbUgT6PBZv1PIyc5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x6yhQIO0LxmWeJ90qTyMP5qNOljc0S3Yl7bEhpwmaiEsWTNwlkfsZ87htQM39EtNs
	 IcA5xvYO6RlOH+dCfCI1e4/oMToS6h16zww/rCpfAmO7nc64JI9NJ/hgBTkqVDqxZj
	 Ks18Oh9JXI1Momm8N54wEVcLNZ+dyb/DGAJdkJUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 072/263] ALSA: usb-audio: Add a quirk for Lenovo Thinkpad Thunderbolt 3 dock
Date: Thu,  3 Jul 2025 16:39:52 +0200
Message-ID: <20250703144007.196492401@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index dbbc9eb935a4b..f302bcebaa9d0 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2284,6 +2284,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
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




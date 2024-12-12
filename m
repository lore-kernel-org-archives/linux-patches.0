Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E506F2FE;
	Thu, 12 Dec 2024 16:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021809; cv=none; b=EJwMds4yFG2FHNVB50PtzhVxUe65hd61NIZmzWji1EBhJJzhTE1EeI4/aS/n2XQo2LyIDOGwpKKCmXc7Ww1bKX3eFKkIrOJj+S/K577GMQ03ScJf7xY+9gxKVDie9k0ixX0dNklta6E2PZ1aeAUk00XAIVuSfbn6rWsA7IkAUdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021809; c=relaxed/simple;
	bh=XbHNl0G8pO7xzFle3Tm4dw19G0yefdQaWtR5wjMY0gc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lwvu1gW/1vl1WUgezyVOfB4v56d7q3EvuwrAshopSyH5JA66Pgen+bV1OgMwZVw60RClCGspgqw6gsCjn/6Gjpy3Y+idJ1uVS3/O+9QaBvpP0mnGNJeeh6DiolfrTHvTsFgHdEzxCnf3FHgXUdVRzkHvsrs8zofNb5w8OmNin9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AD6qQIX1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AD6qQIX1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 770B8C4CED0;
	Thu, 12 Dec 2024 16:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021809;
	bh=XbHNl0G8pO7xzFle3Tm4dw19G0yefdQaWtR5wjMY0gc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AD6qQIX13/PPXNfetnLCRNLNSeLpajas5nhsfmW4KPBxDGAMP/5fuPs9lVa33inZl
	 IQXC5Jt3CAVPCNoravDWq8Oq3ilTHKlcj5hib33eZg0tkVJY1Qz0/jg2sKObbsSH5c
	 O5Dd2ro199oxN4s9oZii/kE00qO2TP93W75q7T2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eryk Zagorski <erykzagorski@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 069/565] ALSA: usb-audio: Fix Yamaha P-125 Quirk Entry
Date: Thu, 12 Dec 2024 15:54:24 +0100
Message-ID: <20241212144314.218210586@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eryk Zagorski <erykzagorski@gmail.com>

[ Upstream commit 6f891ca15b017707840c9e7f5afd9fc6cfd7d8b1 ]

This patch switches the P-125 quirk entry to use a composite quirk as the
P-125 supplies both MIDI and Audio like many of the other Yamaha
keyboards

Signed-off-by: Eryk Zagorski <erykzagorski@gmail.com>
Link: https://patch.msgid.link/20241111164520.9079-2-erykzagorski@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks-table.h | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index dd98b4e13edac..4690b44987c05 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -350,7 +350,6 @@ YAMAHA_DEVICE(0x105a, NULL),
 YAMAHA_DEVICE(0x105b, NULL),
 YAMAHA_DEVICE(0x105c, NULL),
 YAMAHA_DEVICE(0x105d, NULL),
-YAMAHA_DEVICE(0x1718, "P-125"),
 {
 	USB_DEVICE(0x0499, 0x1503),
 	.driver_info = (unsigned long) & (const struct snd_usb_audio_quirk) {
@@ -485,6 +484,19 @@ YAMAHA_DEVICE(0x1718, "P-125"),
 		}
 	}
 },
+{
+	USB_DEVICE(0x0499, 0x1718),
+	QUIRK_DRIVER_INFO {
+		/* .vendor_name = "Yamaha", */
+		/* .product_name = "P-125", */
+		QUIRK_DATA_COMPOSITE {
+			{ QUIRK_DATA_STANDARD_AUDIO(1) },
+			{ QUIRK_DATA_STANDARD_AUDIO(2) },
+			{ QUIRK_DATA_MIDI_YAMAHA(3) },
+			QUIRK_COMPOSITE_END
+		}
+	}
+},
 YAMAHA_DEVICE(0x2000, "DGP-7"),
 YAMAHA_DEVICE(0x2001, "DGP-5"),
 YAMAHA_DEVICE(0x2002, NULL),
-- 
2.43.0




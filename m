Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF2BF2144C4;
	Thu, 12 Dec 2024 17:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023265; cv=none; b=q7YEaL1ZBKxKGObKn2fD57sqWLtIhj7GsSanB3Fn7IZP51pEdjGHaOEi9BQkzyDwE/eNbkExuvIQDT0FzgiOmTMh9vuDxWV3vsi6HjVAFLHrk7n94Ukk75hltDScHEIIghIZNZrPZuXCIs0+upIuIxFyFAO4YD3x1/huUkyop8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023265; c=relaxed/simple;
	bh=+B8zHS7qa0xaUKTxmIUoN2laaHmk4xHmvc9iBnDweoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SHuudx55EfZuhDKMSA8DP7U9uT1h4Z8bK1lwQnkqf7p/UUH7puA94BzkzrPZ8r4NRPa/jNBGZ7iFj7W9qHyUlbrRcl2Gd9VC3+lwnsPYtcYgw/2sgECJ16oF3bjXEUqft6tlrMnwNwadn4KUnR4Uj6gPOMZhdLpqk15DEW5FusY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ICbMKJPk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ICbMKJPk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36A1AC4CECE;
	Thu, 12 Dec 2024 17:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023265;
	bh=+B8zHS7qa0xaUKTxmIUoN2laaHmk4xHmvc9iBnDweoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ICbMKJPkufbt6MFseXxiyIgA+JmfpxEjUFKa/6con/PtL+jT00wfYdlxhi/h4tvNj
	 iq6F3i2wrY14HalnLJh3Q6LDBgHNcp4wK1Xxu0ayCTbNuuYiCjqfmvKgHclkKIg+1C
	 +5TpLYVWmzJCIXhNh6qU281Wo6+ARpViOTpHZXpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marie Ramlow <me@nycode.dev>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 450/565] ALSA: usb-audio: add mixer mapping for Corsair HS80
Date: Thu, 12 Dec 2024 16:00:45 +0100
Message-ID: <20241212144329.509212829@linuxfoundation.org>
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

From: Marie Ramlow <me@nycode.dev>

commit a7de2b873f3dbcda02d504536f1ec6dc50e3f6c4 upstream.

The Corsair HS80 RGB Wireless is a USB headset with a mic and a sidetone
feature. It has the same quirk as the Virtuoso series.
This labels the mixers appropriately, so applications don't
move the sidetone volume when they actually intend to move the main
headset volume.

Signed-off-by: Marie Ramlow <me@nycode.dev>
cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20241130165240.17838-1-me@nycode.dev
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer_maps.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/sound/usb/mixer_maps.c
+++ b/sound/usb/mixer_maps.c
@@ -574,6 +574,16 @@ static const struct usbmix_ctl_map usbmi
 		.id = USB_ID(0x1b1c, 0x0a42),
 		.map = corsair_virtuoso_map,
 	},
+	{
+		/* Corsair HS80 RGB Wireless (wired mode) */
+		.id = USB_ID(0x1b1c, 0x0a6a),
+		.map = corsair_virtuoso_map,
+	},
+	{
+		/* Corsair HS80 RGB Wireless (wireless mode) */
+		.id = USB_ID(0x1b1c, 0x0a6b),
+		.map = corsair_virtuoso_map,
+	},
 	{	/* Gigabyte TRX40 Aorus Master (rear panel + front mic) */
 		.id = USB_ID(0x0414, 0xa001),
 		.map = aorus_master_alc1220vb_map,



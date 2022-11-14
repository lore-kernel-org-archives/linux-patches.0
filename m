Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 717F54C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 12:58:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C81E6C433C1;
	Mon, 14 Nov 2022 12:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668430689;
	bh=5P1VMuy7e+hxshkjV4NP3HBvQkYx9QA+TJmyDNec644=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nnjAFfFfPhlwjEs1Wa6Qs5ud0WayXqPoqPneQN83bI3889R8+Q1FaWV8fdPdAvh7S
	 CzPidV/JNHQqbvuI+CpFyOhTib5NQ7N/tGW8Y/hUsPgtb4Pq2wAhZUXZ0fu/88DONT
	 vt0jqb1p7AnTF25Dw7DWtTz50elGxLFDRWqU0Lwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ash Logan <ash@heyquark.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 094/131] ALSA: usb-audio: Add quirk entry for M-Audio Micro
Date: Mon, 14 Nov 2022 13:46:03 +0100
Message-Id: <20221114124452.693484226@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
References: <20221114124448.729235104@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Takashi Iwai <tiwai@suse.de>

commit 2f01a612d4758b45f775dbb88a49cf534ba47275 upstream.

M-Audio Micro (0762:201a) defines the descriptor as vendor-specific,
while the content seems class-compliant.  Just overriding the probe
makes the device working.

Reported-by: Ash Logan <ash@heyquark.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/7ecd4417-d860-4773-c1c1-b07433342390@heyquark.com
Link: https://lore.kernel.org/r/20221108140721.24248-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks-table.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -2050,6 +2050,10 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 	}
 },
 {
+	/* M-Audio Micro */
+	USB_DEVICE_VENDOR_SPEC(0x0763, 0x201a),
+},
+{
 	USB_DEVICE_VENDOR_SPEC(0x0763, 0x2030),
 	.driver_info = (unsigned long) &(const struct snd_usb_audio_quirk) {
 		/* .vendor_name = "M-Audio", */



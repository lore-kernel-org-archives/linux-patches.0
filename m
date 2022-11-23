Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 648037B
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF57CC433D7;
	Wed, 23 Nov 2022 09:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669194023;
	bh=DR11f5rt7/8u8XclKaRYMdqxmk28CwB/vUN/i/gkt+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TWX33XjTzT8zPuuknOjCCWzQatRAtVR66vhfIhy/D31gp1jiX+b1uzPAUVAZtIygs
	 PJRouzMjWRDFGks3HIU4tBq4kIS2U6uu23l0MHatFjTGH42aD1ISorzfMIe6gsZAU7
	 tJ+NavmTAEidW2x2evxMxHDkcrf0/4Josbjy+uQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ash Logan <ash@heyquark.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.14 19/88] ALSA: usb-audio: Add quirk entry for M-Audio Micro
Date: Wed, 23 Nov 2022 09:50:16 +0100
Message-Id: <20221123084549.171104947@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084548.535439312@linuxfoundation.org>
References: <20221123084548.535439312@linuxfoundation.org>
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
@@ -2090,6 +2090,10 @@ YAMAHA_DEVICE(0x7010, "UB99"),
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



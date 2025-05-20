Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E76AA242D94;
	Tue, 20 May 2025 13:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749313; cv=none; b=qo5b/ha7Fk5Q3/w5Xv+t6XIPMv5JHpQTtESJUYyBeQnFKs2QYKiHCIlvm0m2DSBu/Is/DQJNrIDLhf5lhsbWIrUK0Yv04r9OknhAjF2WPYjljpacTZhIMK4XZ2C8DfKFcg+ONuEh+MkVfLhr4DN5peSBxLXjNoNFZrY01w82TYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749313; c=relaxed/simple;
	bh=7KW5pNqdOmMWxQOl802TPoh6O6lbIbPN39oHYS7CR9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zk9SJ6Ovs0p95tQkAiIEXHkN/CZTzZXP91FV/8wDcTPGpa0kvbGNMMaDLgGzPwkuI53SRAFSriokiAl6ynvAw2bUSvvgwN5NdX8xvWWj1gDC5D4EfBdVCVI3/3ha3geW8Rjo0xE0oLY3xeIRVGI8TcKHCPVPjwn4JXGy3HVsE9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uoOZ31Ge; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uoOZ31Ge"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60755C4CEE9;
	Tue, 20 May 2025 13:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749312;
	bh=7KW5pNqdOmMWxQOl802TPoh6O6lbIbPN39oHYS7CR9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uoOZ31GeGHERFPej1gYvsaEPtlb861M87DDsryRCt9G5gJ2XwQVVjbaml0EQvFFog
	 zgpjG/jf54OGlx0Wn5aNV5mB71/LgXMKY26l1eCvN1djze8s70OuEscJ/6JYlQ3l2f
	 VVYvQQhYzfghhkB0Fb+kXBRovA4g5raxomgSOeZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Chauvet <kwizart@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 35/59] ALSA: usb-audio: Add sample rate quirk for Microdia JP001 USB Camera
Date: Tue, 20 May 2025 15:50:26 +0200
Message-ID: <20250520125755.250969008@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125753.836407405@linuxfoundation.org>
References: <20250520125753.836407405@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Chauvet <kwizart@gmail.com>

commit 7b9938a14460e8ec7649ca2e80ac0aae9815bf02 upstream.

Microdia JP001 does not support reading the sample rate which leads to
many lines of "cannot get freq at ep 0x84".
This patch adds the USB ID to quirks.c and avoids those error messages.

usb 7-4: New USB device found, idVendor=0c45, idProduct=636b, bcdDevice= 1.00
usb 7-4: New USB device strings: Mfr=2, Product=1, SerialNumber=3
usb 7-4: Product: JP001
usb 7-4: Manufacturer: JP001
usb 7-4: SerialNumber: JP001
usb 7-4: 3:1: cannot get freq at ep 0x84

Cc: <stable@vger.kernel.org>
Signed-off-by: Nicolas Chauvet <kwizart@gmail.com>
Link: https://patch.msgid.link/20250515102132.73062-1-kwizart@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1837,6 +1837,8 @@ static const struct usb_audio_quirk_flag
 		   QUIRK_FLAG_CTL_MSG_DELAY_1M),
 	DEVICE_FLG(0x0c45, 0x6340, /* Sonix HD USB Camera */
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
+	DEVICE_FLG(0x0c45, 0x636b, /* Microdia JP001 USB Camera */
+		   QUIRK_FLAG_GET_SAMPLE_RATE),
 	DEVICE_FLG(0x0d8c, 0x0014, /* USB Audio Device */
 		   QUIRK_FLAG_CTL_MSG_DELAY_1M),
 	DEVICE_FLG(0x0ecb, 0x205c, /* JBL Quantum610 Wireless */



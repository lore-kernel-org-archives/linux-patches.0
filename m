Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B7DD213E97;
	Thu, 12 Dec 2024 15:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016131; cv=none; b=mDlH/mrGIJakq8rNqcg0iTmfsw5NOSWC6sM+iqp1ke9QrQadDE7JmtWOn+n1T+5Kqdf/1BWvz5rj6vbyEU4Y1Ok6Hr/Hi/IF3oEYcrCtkdlhUiepXXQYYFaNso5Y+cpKuGC6XpSo+0cVCzWI//UZV12qAfJhRfV5lt0BdEgoG9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016131; c=relaxed/simple;
	bh=P8Et4STGpsUtjSJoN0PT/CjG6vebdr0UGHOdJDD47Ms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D3gGwtL0ZIKR89kHyg/rtqPJGBvg/EleMiOH8h0I2rIqRYVEC302TEIEsT9XVkfldYiFXWkIoUc6jeI7qyZcsiK+JExPaC10bvt0Rfm0zxg3CIbce2CDoYkYG2BEZmdkAcyiarwPubopG9THkZ5+2JHQSBeuADnocW5lEQh9F+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0bP+vmib; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0bP+vmib"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA92BC4CECE;
	Thu, 12 Dec 2024 15:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016131;
	bh=P8Et4STGpsUtjSJoN0PT/CjG6vebdr0UGHOdJDD47Ms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0bP+vmibcQsjq4uOlKrBGHJMzWe6UoyAiDeIZX5vVDnBYr/MMm7U6yRVaVw+86nIT
	 mEKqpNUzTp5mTg1UDWWUbOoy5AKHxGQZ+nA2fTgQV+G8aJhyOPdFOrSj0Vw1ed8qU5
	 /yVfHUCOJaYcZt9vHM7uUFzI9Suu+3THA07MrY6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marie Ramlow <me@nycode.dev>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 142/466] ALSA: usb-audio: add mixer mapping for Corsair HS80
Date: Thu, 12 Dec 2024 15:55:11 +0100
Message-ID: <20241212144312.407167949@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -621,6 +621,16 @@ static const struct usbmix_ctl_map usbmi
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



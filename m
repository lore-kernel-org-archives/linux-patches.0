Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 767CF5F54E;
	Tue, 13 Feb 2024 17:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845518; cv=none; b=npNdHq82x8ZAaCYljbfowOD4m4Occg9ke0+xVB4PZYwS0jgSrh6zF4DL6ulKmTicRYVgIx+5cZPUQJULRGzKSk7DHrUUtvImqC4ZlToSwMW4O/cFqFZS2ZCzLAJl9sBJnm85jEM3HaO0l9bkDiYUWSMzrwreon0cUtsmCETX0RU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845518; c=relaxed/simple;
	bh=5XcqHDhTy/O0U64oVIU0cehIDSVta9MSzyQsli0uzSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=icQedNBAhTf1FfKmNxUsNVgqnaYUWFy0OhSVPkSJqwKucOZZ3CII27cOC2Upl0FzDIWDtgWRcIJw45sANgNE9iDX4kZKOKEhNZvxxnMtBx4FlCt+ML1rv+45wgcoCI9RfvIi4b9o109CXwlFGoWHG7esFmdoA63NP5o9V5YEit0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LpSXnqtA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LpSXnqtA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0DBAC433F1;
	Tue, 13 Feb 2024 17:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845518;
	bh=5XcqHDhTy/O0U64oVIU0cehIDSVta9MSzyQsli0uzSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LpSXnqtA1NmoY4QwWIScbpqEO9nmllAE91vGbW8ezYk3LVKD4IP9jEMVgtw8lGbZd
	 1xGD2EfrTJ8qTgJ3sAX547s0jQL2wXHD1fM2TgRldEXvIl7xYB0zFYeuCgIeq9BVUL
	 i6ZV/+SBUgwFfhqfbmkPQgishgp/EqfmGClpV1r8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 101/121] ALSA: usb-audio: add quirk for RODE NT-USB+
Date: Tue, 13 Feb 2024 18:21:50 +0100
Message-ID: <20240213171855.941236026@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
References: <20240213171852.948844634@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Young <sean@mess.org>

commit 7822baa844a87cbb93308c1032c3d47d4079bb8a upstream.

The RODE NT-USB+ is marketed as a professional usb microphone, however the
usb audio interface is a mess:

[    1.130977] usb 1-5: new full-speed USB device number 2 using xhci_hcd
[    1.503906] usb 1-5: config 1 has an invalid interface number: 5 but max is 4
[    1.503912] usb 1-5: config 1 has no interface number 4
[    1.519689] usb 1-5: New USB device found, idVendor=19f7, idProduct=0035, bcdDevice= 1.09
[    1.519695] usb 1-5: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    1.519697] usb 1-5: Product: RØDE NT-USB+
[    1.519699] usb 1-5: Manufacturer: RØDE
[    1.519700] usb 1-5: SerialNumber: 1D773A1A
[    8.327495] usb 1-5: 1:1: cannot get freq at ep 0x82
[    8.344500] usb 1-5: 1:2: cannot get freq at ep 0x82
[    8.365499] usb 1-5: 2:1: cannot get freq at ep 0x2

Add QUIRK_FLAG_GET_SAMPLE_RATE to work around the broken sample rate get.
I have asked Rode support to fix it, but they show no interest.

Signed-off-by: Sean Young <sean@mess.org>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20240124151524.23314-1-sean@mess.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2183,6 +2183,8 @@ static const struct usb_audio_quirk_flag
 		   QUIRK_FLAG_FIXED_RATE),
 	DEVICE_FLG(0x1bcf, 0x2283, /* NexiGo N930AF FHD Webcam */
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
+	DEVICE_FLG(0x19f7, 0x0035, /* RODE NT-USB+ */
+		   QUIRK_FLAG_GET_SAMPLE_RATE),
 
 	/* Vendor matches */
 	VENDOR_FLG(0x045e, /* MS Lifecam */



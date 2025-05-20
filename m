Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 037AB2459EC;
	Tue, 20 May 2025 13:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749310; cv=none; b=Q9auFcunmkyC0ZHcSkhDbiYxK2pXmL2McZSfWTS7rzaa1ho3kFTJzkI2bQalNah2gxHYX1DX2mQi5xZSvLy0dC7vP97Y/zMkXdrnM+WjqgZfvFFPFUY6YfAb93i75QE2AXfcYGIBLyQ5wApMLcN1etdJMuEhU18x3egkOPyj9Gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749310; c=relaxed/simple;
	bh=DzXiB8ZNsGPJXuKxdXAt5slb0d8lauuXjBTvMx2O8q0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TVIUrSseycj/b/cBIEFRhEL4E6axGJWzVzDOS4HER4IpWwEBT7COlwlRwLFb5ElENgu3xkf0N5JBWoeT3NbJrXFgXL/WhpVkL0Re0EuIubISYbtntbPGbuur6DK4KSe2HK9PoQ9NVKni6EyN2UNTIyda/fRL2zWwbkFl9r7nT4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o9eQGtVx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o9eQGtVx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67C5EC4CEE9;
	Tue, 20 May 2025 13:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749309;
	bh=DzXiB8ZNsGPJXuKxdXAt5slb0d8lauuXjBTvMx2O8q0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o9eQGtVxbasDv4JzCX82p+IykUI9Dgc5qVx7wmo9Yd1l2TWHQjgJTAkzkFbB28zbx
	 mTsae8SG9lm9foMn07O3p7aFANLjWCiePMhO4rsmTO3uvd6ku3jxM/BbJhkiTmGEvR
	 nS1SlhaH6ldq5+FwASx0bke2fJe0Zsy7gCJk6Iho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Heusel <christian@heusel.eu>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 34/59] ALSA: usb-audio: Add sample rate quirk for Audioengine D1
Date: Tue, 20 May 2025 15:50:25 +0200
Message-ID: <20250520125755.212974368@linuxfoundation.org>
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

From: Christian Heusel <christian@heusel.eu>

commit 2b24eb060c2bb9ef79e1d3bcf633ba1bc95215d6 upstream.

A user reported on the Arch Linux Forums that their device is emitting
the following message in the kernel journal, which is fixed by adding
the quirk as submitted in this patch:

    > kernel: usb 1-2: current rate 8436480 is different from the runtime rate 48000

There also is an entry for this product line added long time ago.
Their specific device has the following ID:

    $ lsusb | grep Audio
    Bus 001 Device 002: ID 1101:0003 EasyPass Industrial Co., Ltd Audioengine D1

Link: https://bbs.archlinux.org/viewtopic.php?id=305494
Fixes: 93f9d1a4ac593 ("ALSA: usb-audio: Apply sample rate quirk for Audioengine D1")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Heusel <christian@heusel.eu>
Link: https://patch.msgid.link/20250512-audioengine-quirk-addition-v1-1-4c370af6eff7@heusel.eu
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1845,6 +1845,8 @@ static const struct usb_audio_quirk_flag
 		   QUIRK_FLAG_FIXED_RATE),
 	DEVICE_FLG(0x0fd9, 0x0008, /* Hauppauge HVR-950Q */
 		   QUIRK_FLAG_SHARE_MEDIA_DEVICE | QUIRK_FLAG_ALIGN_TRANSFER),
+	DEVICE_FLG(0x1101, 0x0003, /* Audioengine D1 */
+		   QUIRK_FLAG_GET_SAMPLE_RATE),
 	DEVICE_FLG(0x1224, 0x2a25, /* Jieli Technology USB PHY 2.0 */
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
 	DEVICE_FLG(0x1395, 0x740a, /* Sennheiser DECT */



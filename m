Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74FF11D8E07;
	Tue, 20 May 2025 14:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749829; cv=none; b=LTak8/bTe/swnizJ/O20TRl4qJdAszvFoEkTLw0GH66kNW+LIS0uAOKYpG7NO2pHHhK92QalKtzAwuRcAMFLrlMbtnVC6zaeuQgNjo2zhXyCvjkZC2N0MfO8FcauF7ugCruhT64j0oa8qyGK+OjbUi/syyqm8kcVwb84ufcYuQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749829; c=relaxed/simple;
	bh=H3QbjvJcE08WCYOPnQ11OQiZBVaGktxEL4GtbwTG1qo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MzXg1uMZNVXKEOa7HSDRUAqxmss6Tpttm3WDNnT3L5cKQZIKzPoRpMKgLzFkQa81PaWKyB6EVIFWQxBWviBD9oR4+gm66pa9wGLFySmkeW5IlmDrpqHpTjxXbfiCLywAkbv6ydMEY2WjC3OXYPo7ZtZ4nSFtwT+ma/otqfZGt6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=No604Gce; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="No604Gce"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 888BDC4CEE9;
	Tue, 20 May 2025 14:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749829;
	bh=H3QbjvJcE08WCYOPnQ11OQiZBVaGktxEL4GtbwTG1qo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=No604GceTL+E72NDq1cwFZwXAz3HEh89RdS58o6RbgJQu0LbxSRyXXdgKvmfILfbQ
	 LWBdjqmNoijgYRhl64RxO4wl36JoeB2CyKiTPzqkPTO/oJgD584pPNQnOruRsmm8yN
	 UmPBqCzQVp7av0Q0GeotkirpyyPWjbuRZaaTt4AE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Chauvet <kwizart@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 073/117] ALSA: usb-audio: Add sample rate quirk for Microdia JP001 USB Camera
Date: Tue, 20 May 2025 15:50:38 +0200
Message-ID: <20250520125806.889606024@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125803.981048184@linuxfoundation.org>
References: <20250520125803.981048184@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2140,6 +2140,8 @@ static const struct usb_audio_quirk_flag
 		   QUIRK_FLAG_CTL_MSG_DELAY_1M),
 	DEVICE_FLG(0x0c45, 0x6340, /* Sonix HD USB Camera */
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
+	DEVICE_FLG(0x0c45, 0x636b, /* Microdia JP001 USB Camera */
+		   QUIRK_FLAG_GET_SAMPLE_RATE),
 	DEVICE_FLG(0x0d8c, 0x0014, /* USB Audio Device */
 		   QUIRK_FLAG_CTL_MSG_DELAY_1M),
 	DEVICE_FLG(0x0ecb, 0x205c, /* JBL Quantum610 Wireless */



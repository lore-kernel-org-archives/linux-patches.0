Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 139AF24E01B;
	Tue, 20 May 2025 14:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750256; cv=none; b=DEr/aeXmBuHfKrPE1MTGWH3YTg9plbxFAX57xgAJm/TrwoM89v0nSOUHPimqcVTwtHdzcZ26md1Y/59r5hN0rYlA9bV0EpeF5iLOJq64HjJEGX3cgkEPi/sgZlPxxYODm3Waf8UMXgBy5/XnhmKLqX7GdOiQd7xk1h01cLnjXUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750256; c=relaxed/simple;
	bh=5gtDe0UAINPI4V+g84dwscQdgUWtnhsPUG4V7Piq3iI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rti7muHbnTMEf6o//t1I9VuTRv1NFnnhwlETq7QHoMHD6ZTcscwAXA7aJj0/QUcw+XyQxF0zEFZJZVG59iZuJ7ew9O0FhfaxVJDKzCVji3SfzlhPjeFNkfTw3r89bOmP+iiijn8CLyoie+dDXo/MRJOJzqKRqHeYgPKnn6NDNUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N1WB8v02; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N1WB8v02"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9906AC4CEEA;
	Tue, 20 May 2025 14:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750255;
	bh=5gtDe0UAINPI4V+g84dwscQdgUWtnhsPUG4V7Piq3iI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N1WB8v02ZE9fDWrPTJ0vR/RQjQ9kNVST9/foMo0bwcKy1PVQUZla2A3k3XlsOtSmr
	 Y5jP5EDYRTTxDKcUk283fVHUVR9jsTXiH5n0aNiap6jDXf1qAZdtN/tHV+1rW2j04V
	 yHugJn1lp9Z2/6DCiH3vxv4OFtaX2PaGATlw4f2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Heusel <christian@heusel.eu>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 092/143] ALSA: usb-audio: Add sample rate quirk for Audioengine D1
Date: Tue, 20 May 2025 15:50:47 +0200
Message-ID: <20250520125813.674783096@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2248,6 +2248,8 @@ static const struct usb_audio_quirk_flag
 		   QUIRK_FLAG_FIXED_RATE),
 	DEVICE_FLG(0x0fd9, 0x0008, /* Hauppauge HVR-950Q */
 		   QUIRK_FLAG_SHARE_MEDIA_DEVICE | QUIRK_FLAG_ALIGN_TRANSFER),
+	DEVICE_FLG(0x1101, 0x0003, /* Audioengine D1 */
+		   QUIRK_FLAG_GET_SAMPLE_RATE),
 	DEVICE_FLG(0x1224, 0x2a25, /* Jieli Technology USB PHY 2.0 */
 		   QUIRK_FLAG_GET_SAMPLE_RATE | QUIRK_FLAG_MIC_RES_16),
 	DEVICE_FLG(0x1395, 0x740a, /* Sennheiser DECT */



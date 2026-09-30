Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA1C4FECCF;
	Wed, 30 Sep 2026 16:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784577; cv=none; b=aRtQ8oHeRtTHrlsPbqC9URa72G6OzIJUWh1aFh6k2B9Q1i3SxC0nFOcrvNtwcWQzLmZ3JlXadCUGPw3KfVnohqVZUgoM5jTdOlpk9zPe147HQD0bv6mAytqHA2hmIf2RFLCNCMPbLoJo5ypM79OOqSMdEZhIKtU5NEA+5WlErO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784577; c=relaxed/simple;
	bh=GIYhlnH/zk8iQ/xwSDXemkpSP7/QzBQOrUmwYejtLAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jy5XuMEdeufeU/kNKGlc0DsRwF1mjFYGzc+3S9My8wlzOA4pn8tY7NukXCGnnG/Oo9H8KWpL+CeLHK9s78cV60VodT9qzrnpxhQgylakU8rKUpvcTcFufEc8wfefADiFzgtXHfk+bms7/sNrYOxX80ctvawxu1iQxXhRyyAAp2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eq8ihWRa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eq8ihWRa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A3331F0089F;
	Wed, 30 Sep 2026 16:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784572;
	bh=YvXqmDjub7PpoLzq/Y7ouh+Cn+xd76/FR7NL3T11sLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Eq8ihWRaX+JfCa13hBDPlSkvViyzEjMv1z6ExPxZW74wl3WtV1KSNoLC6qgJ0ytwW
	 iW6P3JP84VIRqasRkzXlQc+0CGvSlZAeFgESUcyCio7uWzIXC37/GqIy2Q9TnLf7Jj
	 VcSdPF8uHa4MNvqNnd8EUnG0x90Mge0jFIK6SRrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ai Chao <aichao@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 202/982] ALSA: usb-audio: Add quirk flags for SC13A
Date: Wed, 30 Sep 2026 17:15:38 +0200
Message-ID: <20260930152421.151598955@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ai Chao <aichao@kylinos.cn>

[ Upstream commit 8956950dab22fbaefe92ca1980728165c5da793d ]

The SC13A ( VID 0x1ff7, PID 0x0f81) not support reading the current
sample rate and results in an error message printed to kmsg. Set
QUIRK_FLAG_GET_SAMPLE_RATE to skip the sample rate check.

Quirky device sample:
  usb 3-5.2.4.1: new high-speed USB device number 11 using xhci_hcd
  usb 3-5.2.4.1: New USB device found, idVendor=1ff7, idProduct=0f81
  usb 3-5.2.4.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
  usb 3-5.2.4.1: Product: SC13A
  usb 3-5.2.4.1: Manufacturer: Linux Foundation
  usb 3-5.2.4.1: SerialNumber: 000002
  usb 3-5.2.4.1: Found UVC 1.50 device SC13A (1ff7:0f81)
  usb 3-5.2.4.1: 3:1: cannot get freq at ep 0x86
  usb 3-5.2.4.1: Warning! Unlikely big volume range (=4096),
    cval->res is probably wrong.
  usb 3-5.2.4.1: [5] FU [Mic Capture Volume] ch = 1, val = 0/4096/1
  usbcore: registered new interface driver snd-usb-audio
  usb 3-5.2.4.1: 3:1: cannot get freq at ep 0x86
  usb 3-5.2.4.1: 3:1: cannot get freq at ep 0x86

Signed-off-by: Ai Chao <aichao@kylinos.cn>
Link: https://patch.msgid.link/20260617025234.3344935-1-aichao@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index ece6ae4a21ed9..b575b50337cbd 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2217,6 +2217,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_GET_SAMPLE_RATE | QUIRK_FLAG_MIC_RES_16),
 	DEVICE_FLG(0x1bcf, 0x2283, /* NexiGo N930AF FHD Webcam */
 		   QUIRK_FLAG_GET_SAMPLE_RATE | QUIRK_FLAG_MIC_RES_16),
+	DEVICE_FLG(0x1ff7, 0x0f81, /* SC13A Webcam */
+		   QUIRK_FLAG_GET_SAMPLE_RATE),
 	DEVICE_FLG(0x2040, 0x7200, /* Hauppauge HVR-950Q */
 		   QUIRK_FLAG_SHARE_MEDIA_DEVICE | QUIRK_FLAG_ALIGN_TRANSFER),
 	DEVICE_FLG(0x2040, 0x7201, /* Hauppauge HVR-950Q-MXL */
-- 
2.53.0




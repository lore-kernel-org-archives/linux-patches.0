Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A89C25392E;
	Tue, 20 May 2025 14:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750686; cv=none; b=lN0MyX0sqQGrmKFheyAoL8iVv1aAdMN+PnezaK9NCEkn5JW9PDHSzOA0pd5FDkLfFmJlmRxqdhxVj8XFvkrIwPVhE+JIFkvGlVCamc42EFnPn8CBmfpBMSWms5E5Y0dw9umSeD5Xa0oOBKQ13k49dzF5so+zB4JsMoOHrDpdlvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750686; c=relaxed/simple;
	bh=qwyDE2XhTKm3peViDY1F/XzFdH+IS/Lm1ch6idx2C7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gh3eQRCoxNlR/ITFk023lFDsCKh0SedVybcG63wU5HPIDyD9JNrt7nms7h8SrsDF4PISBnokcc27P6RSZlvO5xc8LvHh7pj5RR+ikSScBo0sr6RI2CXgpIrmNT05eLr4DqsogBrQmlS/G1tt4CkHRuD9X70UpT7T6gr9BumcalY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QY9w1gUP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QY9w1gUP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 109B4C4CEE9;
	Tue, 20 May 2025 14:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750686;
	bh=qwyDE2XhTKm3peViDY1F/XzFdH+IS/Lm1ch6idx2C7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QY9w1gUPq73vvxOzqrpnRYIbPF4GiTc8yyGVB9X6oSf49J0VyGtB6UyoPC1RNz3w3
	 QPXC0cmtFsxq5+elKA325yoCf2Qop92KUU1BU70zBAwFhpqP9Mw/V53uFq944MkNy5
	 qDYivwLg12dyx+C+CrgVBfYKDz+23k9jLk2a+i2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Heusel <christian@heusel.eu>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.14 089/145] ALSA: usb-audio: Add sample rate quirk for Audioengine D1
Date: Tue, 20 May 2025 15:50:59 +0200
Message-ID: <20250520125814.059420339@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AEBA7482;
	Thu, 30 Jan 2025 14:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247455; cv=none; b=q2lTxbY4ADp37Ky+wrOUWwq41O1DHs4IZmVkbrgWrniXe0Md5lBcmvdN9MEgT9zaJqW2I66D4fhEyFge5H759w4KYqsbcFbCKGyweJV4gHD7Li0asKdELzmiRF6iy5vb87w5j83RhYlLzcH8bFMBNeGtQT4L1+PlFBH+CUn7B9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247455; c=relaxed/simple;
	bh=3FKsD6PS4dpkfg4HIuSorQF5ldiVCedH0WAjoaC505o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NmDFCnax8y4fRevyEmG3pdMQzzfxWL9XR0G6tufqKVRUxF+Wb4e7V6RpHb4qA2qyN6NodHD+feqFvLv/k0uqWXgldpM4bY0ylAUhYf5h8l5F95W8iRMNvljJ6ToddYgGaw2K8c6+ZdTEWJ+gvfq8ig6Kz+9ZszC8svo7605V9lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A1lXkaX6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A1lXkaX6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B64F2C4CED2;
	Thu, 30 Jan 2025 14:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247455;
	bh=3FKsD6PS4dpkfg4HIuSorQF5ldiVCedH0WAjoaC505o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A1lXkaX6+v1EfWT72dU3+AgEmIHfbtFiKZmModB2VbRf75t85QcWfIN8OsirgMu/Z
	 IiTtdCdRVGolHayRZ+8e91A6f+FsEndwAFrNWv17Pg37VjB+rU3oCYHLwmObaWHGzG
	 Arac6ppzjka1uTUhc/z/yI1NSjP2BPuaoh+1Pqak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lianqin Hu <hulianqin@vivo.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 44/49] ALSA: usb-audio: Add delay quirk for USB Audio Device
Date: Thu, 30 Jan 2025 15:02:20 +0100
Message-ID: <20250130140135.595408029@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.825446496@linuxfoundation.org>
References: <20250130140133.825446496@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lianqin Hu <hulianqin@vivo.com>

commit ad5b205f9e022b407d91f952faddd05718be2866 upstream.

Audio control requests that sets sampling frequency sometimes fail on
this card. Adding delay between control messages eliminates that problem.

usb 1-1: New USB device found, idVendor=0d8c, idProduct=0014
usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-1: Product: USB Audio Device
usb 1-1: Manufacturer: C-Media Electronics Inc.

Signed-off-by: Lianqin Hu <hulianqin@vivo.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/TYUPR06MB6217E94D922B9BF422A73F32D2192@TYUPR06MB6217.apcprd06.prod.outlook.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2137,6 +2137,8 @@ static const struct usb_audio_quirk_flag
 		   QUIRK_FLAG_CTL_MSG_DELAY_1M),
 	DEVICE_FLG(0x0c45, 0x6340, /* Sonix HD USB Camera */
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
+	DEVICE_FLG(0x0d8c, 0x0014, /* USB Audio Device */
+		   QUIRK_FLAG_CTL_MSG_DELAY_1M),
 	DEVICE_FLG(0x0ecb, 0x205c, /* JBL Quantum610 Wireless */
 		   QUIRK_FLAG_FIXED_RATE),
 	DEVICE_FLG(0x0ecb, 0x2069, /* JBL Quantum810 Wireless */



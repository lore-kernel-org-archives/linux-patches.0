Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 784371BD9D3;
	Wed, 19 Feb 2025 09:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956734; cv=none; b=ZqRlC/t0/rLXRgcqY2TEURfWupbJAQQWAMe4T2sr4mkbIEMcUrsH/nr3WOByFgvWAlDk+qPcZj2lNn9BBVaCBZpfiUNNf3z53L2FmWHQRD/xS8Ri1CAuKPuA7aqZZICw/oWaz5bEEmpX7ONHN01A8ydGfdbespOUFwbLaLqpfRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956734; c=relaxed/simple;
	bh=3LN0bZfBVqE2hLpkxI56UsP6rAUqBi5xoEpRnXPYKMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U+wf4VON+V6L+OoXcfmZT+YFJww5Wy/fcwcBN9Q7Xa0mf5oakK+0BrrOmIbAta19AIZXrUVoaMOCkmlN4Acnl1giQJ+6d9cASVzP6rWH4LawK1myWwGk9AHxefEukuqP+UpDmtW+fI5y6I8fDneQU+ffv55glZVvS6Us+lDy8qE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vky4KqxM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vky4KqxM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2140C4CEE7;
	Wed, 19 Feb 2025 09:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956734;
	bh=3LN0bZfBVqE2hLpkxI56UsP6rAUqBi5xoEpRnXPYKMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vky4KqxMszHc80FTcPfHKWUAGMi4P6HPbu0YKCj3mXhgMCZ9Y9/xAP31oLWR9dHTP
	 l+jCDKLeCEhebTdtSHCcFpMnywjco4HwVMiqm/HOPsgxhYAq782GXKlujeM6Thb7tK
	 x97rx4ThjuklKSi6nt+b0r8a2jWIjev1PTyF9Szw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lianqin Hu <hulianqin@vivo.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 250/578] ALSA: usb-audio: Add delay quirk for iBasso DC07 Pro
Date: Wed, 19 Feb 2025 09:24:14 +0100
Message-ID: <20250219082702.862946484@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

commit d85fc52cbb9a719c8335d93a28d6a79d7acd419f upstream.

Audio control requests that sets sampling frequency sometimes fail on
this card. Adding delay between control messages eliminates that problem.

usb 1-1: New USB device found, idVendor=2fc6, idProduct=f0b7
usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-1: Product: iBasso DC07 Pro
usb 1-1: Manufacturer: iBasso
usb 1-1: SerialNumber: CTUA171130B

Signed-off-by: Lianqin Hu <hulianqin@vivo.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/TYUPR06MB62174A48D04E09A37996DF84D2ED2@TYUPR06MB6217.apcprd06.prod.outlook.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2241,6 +2241,8 @@ static const struct usb_audio_quirk_flag
 		   QUIRK_FLAG_CTL_MSG_DELAY_1M),
 	DEVICE_FLG(0x2d95, 0x8021, /* VIVO USB-C-XE710 HEADSET */
 		   QUIRK_FLAG_CTL_MSG_DELAY_1M),
+	DEVICE_FLG(0x2fc6, 0xf0b7, /* iBasso DC07 Pro */
+		   QUIRK_FLAG_CTL_MSG_DELAY_1M),
 	DEVICE_FLG(0x30be, 0x0101, /* Schiit Hel */
 		   QUIRK_FLAG_IGNORE_CTL_ERROR),
 	DEVICE_FLG(0x413c, 0xa506, /* Dell AE515 sound bar */



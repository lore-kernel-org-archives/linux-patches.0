Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EFDC1D89F8;
	Wed,  5 Feb 2025 15:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768657; cv=none; b=hWlWhySfzWNWf5dJC/hsEzxXfE7c8UFC6zhfHBsOna+N8dbzmFcJTd/a5KO/OPH1OiyvPmJ7b6dzTnSfOl1Q2tDZe0gqEc3l9gDoJ4qr14xje9bCAHp55IWzTrGCLGjiez5JpkI2AGqkUqFe0adza0kAYaEndrn6Dqy5dMaVNcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768657; c=relaxed/simple;
	bh=anMvIjPKpswV/EUbXc4W1YSLmgSchPYO8sRhBTDzq+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TNm681KlU9aVx5pv0K/E7fzIw4HVeeZjw7g9/dNB5XvVG6LdH9ToTfKvQJA/JxX391MEuUEiLhaWVCIWCHAE5UiHiPAHqOuzcaDHCAFdL25kAmM0bWuVczg+wXDn0/VkUFCdmCHlm0kiXM9+eXI2wkFzAADkkvv0RZN2kxt832w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c1S5WyvW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c1S5WyvW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FE4BC4CED6;
	Wed,  5 Feb 2025 15:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768656;
	bh=anMvIjPKpswV/EUbXc4W1YSLmgSchPYO8sRhBTDzq+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c1S5WyvWC3ynj1q65wXA+5HYGTKHbmYXKIkkr7EmpwokUScrC2sKGdPLs8Ukip7w2
	 Cyhl3O4IFpgQwS+nL1aq1XuFdihpEzvTxCtuCMOrpoGHCMVMjaubDoDT6Og1eaO9WM
	 3ugYPk2U4l/1bnDZwOzZYuR1y8LV6nF2tUwh9DdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lianqin Hu <hulianqin@vivo.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.13 588/623] ALSA: usb-audio: Add delay quirk for iBasso DC07 Pro
Date: Wed,  5 Feb 2025 14:45:30 +0100
Message-ID: <20250205134518.721337046@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2343,6 +2343,8 @@ static const struct usb_audio_quirk_flag
 		   QUIRK_FLAG_CTL_MSG_DELAY_1M),
 	DEVICE_FLG(0x2d95, 0x8021, /* VIVO USB-C-XE710 HEADSET */
 		   QUIRK_FLAG_CTL_MSG_DELAY_1M),
+	DEVICE_FLG(0x2fc6, 0xf0b7, /* iBasso DC07 Pro */
+		   QUIRK_FLAG_CTL_MSG_DELAY_1M),
 	DEVICE_FLG(0x30be, 0x0101, /* Schiit Hel */
 		   QUIRK_FLAG_IGNORE_CTL_ERROR),
 	DEVICE_FLG(0x413c, 0xa506, /* Dell AE515 sound bar */



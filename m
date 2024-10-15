Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DAF71D1512;
	Tue, 15 Oct 2024 12:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993731; cv=none; b=Bk6Dcop6pMk+MoUVpa42Z5aQ8hAk7iIyDpJozQxmJHCnCB6Y69HVNBstwWLiM32dnaMNibR5kw5IxTjCK+vVSMN3HZoIh4BKoaHNm6im42Q7jn9g5rGH8//k6h1+3g3Bvycvnhf4KKa8I24PLxVUu4DZMJWrBVTWDV1ilHmoC3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993731; c=relaxed/simple;
	bh=gbTxLpUFHNDZOJlZdQq+UpERTO2ZH9Df3ntFZztjcZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AO41TZRJKeYuH/RYWojVjUJEy5sG3OFzzrq68odOvSYUrgUdR5zp3G8q9EVNz6FCyRKunLiueVCUUEr7NZdh+nGxbqFhGsOxLaP5BK0xO1GWl7ly7Tc05WhSrgj4+roEd0M8yX7Rm+7PJURZNj5iOeUZg+InBypjRMnEMQ9S0yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wE7U+Fl+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wE7U+Fl+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2F47C4CEC6;
	Tue, 15 Oct 2024 12:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993731;
	bh=gbTxLpUFHNDZOJlZdQq+UpERTO2ZH9Df3ntFZztjcZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wE7U+Fl+TJNLECLmaHGyqPObFAqBwbtHY4Ccxe9GsOtaz9uJiH+VZLnC5EXLQyxKm
	 3hKibTAHu+aKoAhGayeRhVb10jW3j4gq76LmQl8oIVsnrPwaBFnb49o5EzCPv8G7yQ
	 28nUEhtHv9dUzAGZDGNpmeuq2lzNfAVD3Jd1ZPoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lianqin Hu <hulianqin@vivo.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 499/691] ALSA: usb-audio: Add delay quirk for VIVO USB-C HEADSET
Date: Tue, 15 Oct 2024 13:27:27 +0200
Message-ID: <20241015112500.149610302@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lianqin Hu <hulianqin@vivo.com>

commit 73385f3e0d8088b715ae8f3f66d533c482a376ab upstream.

Audio control requests that sets sampling frequency sometimes fail on
this card. Adding delay between control messages eliminates that problem.

Signed-off-by: Lianqin Hu <hulianqin@vivo.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/TYUPR06MB62177E629E9DEF2401333BF7D2692@TYUPR06MB6217.apcprd06.prod.outlook.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1900,6 +1900,8 @@ static const struct usb_audio_quirk_flag
 		   QUIRK_FLAG_GENERIC_IMPLICIT_FB),
 	DEVICE_FLG(0x2b53, 0x0031, /* Fiero SC-01 (firmware v1.1.0) */
 		   QUIRK_FLAG_GENERIC_IMPLICIT_FB),
+	DEVICE_FLG(0x2d95, 0x8011, /* VIVO USB-C HEADSET */
+		   QUIRK_FLAG_CTL_MSG_DELAY_1M),
 	DEVICE_FLG(0x2d95, 0x8021, /* VIVO USB-C-XE710 HEADSET */
 		   QUIRK_FLAG_CTL_MSG_DELAY_1M),
 	DEVICE_FLG(0x30be, 0x0101, /* Schiit Hel */



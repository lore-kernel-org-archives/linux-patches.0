Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A0F383;
	Thu, 30 Jan 2025 14:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246569; cv=none; b=Ft7eb5NADuSGNjo5CZVBEPkOtqKB40jvUEYShYVGjPGSAd0Iw1j4YOf1IPGUfKjbx2pM/og+epDfHLW4HT8zgeONXkNaJi5nd0uKhrq1+ZPAYiuGKp3CVBblo4FrIwO+tV9E63yUTLZI/45UR2ehCHoyGWSYQSJhgfOyU71NWrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246569; c=relaxed/simple;
	bh=fVdw0WSD6ymYFgMN/guWEsGJNBAScUEZmdbCKAC886w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GzAcelNL7HuFC7uK5dFnuoSDgtY35ByLJez72szVgZdUwby5V5wuw3raOt9JTc0iY2SuUix+BcfJXkkFtLpUziCiRToZ5/+KkHUMUeokvHt1HZAyX+Qp92YVuew7vnuz5eRQv/giI4HTSlEWyIeeZWCN3FfzXehJp4BenYatPQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MRY/bYCF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MRY/bYCF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84A27C4CED2;
	Thu, 30 Jan 2025 14:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246568;
	bh=fVdw0WSD6ymYFgMN/guWEsGJNBAScUEZmdbCKAC886w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MRY/bYCFEWHGacj1N2J2XTYvbROMeA0cSocjGE1TeYx5GkC1BT+LQb/d+OaQKVgxR
	 olDU2VIkfTm6NYazQp4LmT3oaWQvwOIldTQ1R1jnhK8p4u+mjo6rpi5DtXgzf3geYL
	 tpvBqyV2qXA3eUODBcZjPZhcadtFvUpY6ctNqpI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lianqin Hu <hulianqin@vivo.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 36/43] ALSA: usb-audio: Add delay quirk for USB Audio Device
Date: Thu, 30 Jan 2025 14:59:43 +0100
Message-ID: <20250130133500.354319607@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130133458.903274626@linuxfoundation.org>
References: <20250130133458.903274626@linuxfoundation.org>
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
@@ -2139,6 +2139,8 @@ static const struct usb_audio_quirk_flag
 		   QUIRK_FLAG_CTL_MSG_DELAY_1M),
 	DEVICE_FLG(0x0c45, 0x6340, /* Sonix HD USB Camera */
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
+	DEVICE_FLG(0x0d8c, 0x0014, /* USB Audio Device */
+		   QUIRK_FLAG_CTL_MSG_DELAY_1M),
 	DEVICE_FLG(0x0ecb, 0x205c, /* JBL Quantum610 Wireless */
 		   QUIRK_FLAG_FIXED_RATE),
 	DEVICE_FLG(0x0ecb, 0x2069, /* JBL Quantum810 Wireless */



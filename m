Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 961E02222B2;
	Mon, 23 Jun 2025 22:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717582; cv=none; b=AU47/2SJ6GxX7RyZ3Iyb3lQ0R987nxiJ9TSr8IiimXBxeeuVji+ZTdO4Y7vx0fGQzTUgYLmKwk2/DgpcWam7AbjWPDgb0JebZ0b3SJZQUgzAygyPxOKemghc3oRq33VP310/opyQ+FIij6UcspTP52yaCLPQshTFKkK6p3eWSsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717582; c=relaxed/simple;
	bh=RTxtZboRNILakiDdcSWAzegc0A8hwCq4GzjUXtRwLTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sfmW17qDRjY+7YNJ5FubzON8uhvgfUu8bMNF8YrfnKy+8sCv0PVSXesS3XfOGYAEPPJyUf//EZar3Esmkx+0Ax6Y5buYn8S6xvuYjAOXKR0ukTpTmpNk75wD1D+mrF8XeJ3nHPv+hAYWKP1nIjJ16XYnysQT1yTOz79Q2C9A/Ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zoh+zJd8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zoh+zJd8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EDE8C4CEEA;
	Mon, 23 Jun 2025 22:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717582;
	bh=RTxtZboRNILakiDdcSWAzegc0A8hwCq4GzjUXtRwLTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zoh+zJd8u50o8pfVwDUfazmpDTmjzKhdBOwqFKcBAG03UKdlv42prZxTdcdAAgXja
	 Qddbj1B8MPw8Kogcss+c1ZdkIzC8ylGpNFFKPIaPQcqd3PXv97cwkKWfqxdDsHMWl1
	 kf4HUS+QKgZqIJg5W98a1jpvATXIaELuFJiJj14s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wangdicheng <wangdicheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 459/508] ALSA: usb-audio: Rename ALSA kcontrol PCM and PCM1 for the KTMicro sound card
Date: Mon, 23 Jun 2025 15:08:24 +0200
Message-ID: <20250623130656.421561455@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

From: wangdicheng <wangdicheng@kylinos.cn>

commit 93adf20ff4d6e865e0b974110d3cf2f07c057177 upstream.

PCM1 not in Pulseaudio's control list; standardize control to
"Speaker" and "Headphone".

Signed-off-by: wangdicheng <wangdicheng@kylinos.cn>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20250613063636.239683-1-wangdich9700@163.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer_maps.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/sound/usb/mixer_maps.c
+++ b/sound/usb/mixer_maps.c
@@ -383,6 +383,13 @@ static const struct usbmix_name_map ms_u
 	{ 0 }   /* terminator */
 };
 
+/* KTMicro USB */
+static struct usbmix_name_map s31b2_0022_map[] = {
+	{ 23, "Speaker Playback" },
+	{ 18, "Headphone Playback" },
+	{ 0 }
+};
+
 /* ASUS ROG Zenith II with Realtek ALC1220-VB */
 static const struct usbmix_name_map asus_zenith_ii_map[] = {
 	{ 19, NULL, 12 }, /* FU, Input Gain Pad - broken response, disabled */
@@ -692,6 +699,11 @@ static const struct usbmix_ctl_map usbmi
 		.id = USB_ID(0x045e, 0x083c),
 		.map = ms_usb_link_map,
 	},
+	{
+		/* KTMicro USB */
+		.id = USB_ID(0X31b2, 0x0022),
+		.map = s31b2_0022_map,
+	},
 	{ 0 } /* terminator */
 };
 



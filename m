Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 757EF3FB1B;
	Mon, 23 Jun 2025 21:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715746; cv=none; b=Cyhe5aCDwwHYuQ2PKWJLTyp1I4Pakn4/EYhtCSwZ9i0vb2gwEyH8CgMJ+HDSKxgtoVIkb5YdD1sMcqVHy9VOmYg0Y3uz0qSgm6N6M/UZZvvKH/2n1O01e322TzZt4tCOXjCZmIQSeHRGYwnlpTVkX2A/IPpSvd1r/KzlwpP4Myw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715746; c=relaxed/simple;
	bh=jy3hTWsIwzmXN4dQulGp4mb4oIrMWJ8R98RY2fvBQag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dKqMnl34r6GLykr5U5CX/pahWtuxngjlrnWJz6uBf2ufhttSj57Jx12BNEwWn2yG6qR+CwH8WfLztyuB8mm3rbu/EN88GYX7W1h2VChk2H/qHBAsmQlobzzTVYvF+9Aai/zMcaXxf9SXFpQD6KOQQqYrQU/AhI5+gDpN/7YCKI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v4NTJOwo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v4NTJOwo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B6E6C4CEEA;
	Mon, 23 Jun 2025 21:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715746;
	bh=jy3hTWsIwzmXN4dQulGp4mb4oIrMWJ8R98RY2fvBQag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v4NTJOwo3uB3hPsOn6DueBg/iXdkk5hWFJNfaEW3So83HkSb4eCKScLWCPkGWhkDv
	 M+L3g0KY+N31dw+gmjAz0VXyqVTzbL1d4Oou9FG00tM/Ezfo4z952+eKJjN/KKDtfT
	 wFhUnX4yQgrWRff+er0qp7Z9WeV+pkykbS05350g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wangdicheng <wangdicheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 294/355] ALSA: usb-audio: Rename ALSA kcontrol PCM and PCM1 for the KTMicro sound card
Date: Mon, 23 Jun 2025 15:08:15 +0200
Message-ID: <20250623130635.615214763@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -367,6 +367,13 @@ static const struct usbmix_name_map cors
 	{ 0 }
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
@@ -649,6 +656,11 @@ static const struct usbmix_ctl_map usbmi
 		.id = USB_ID(0x1395, 0x0025),
 		.map = sennheiser_pc8_map,
 	},
+	{
+		/* KTMicro USB */
+		.id = USB_ID(0X31b2, 0x0022),
+		.map = s31b2_0022_map,
+	},
 	{ 0 } /* terminator */
 };
 



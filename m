Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A9C9334C2A;
	Wed,  3 Dec 2025 15:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777188; cv=none; b=Wm5XJ5SYIKp0pkXdKeVWFpLpn/xULAJfSsli4cVNZs99Yq+aqwqK8jS43LPOvRhYk1ZSuYIx2yMiQKDaYFXfrLXNLGV2QqeWA0pQmXju5r8HzGKW2oObZXL/+UNnJlLbAEHWswdzSJQp/ZMIutX6+/0IfM13R85mjf1jksSfzzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777188; c=relaxed/simple;
	bh=nNAXRvyP8aeMQIUjwLdhkk++z7DRWvGkMZqBNGdVipw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n4EHaSnXr/si8gKQKmU45Ga9/UXcDjXNJFviCDPT7r5rm1PObWZuUssvYurozVpRWmmSGMfsWdFSsvZA+QCi4JIsNkwtoIJqOZlUTfYILwXwjVrbysCjOxA9z2Ye8oJoud9csp3TqUgcctS5zGujR7oV8y53P1loFA2Jd2axnOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y9g/PQy8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y9g/PQy8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3216C4CEF5;
	Wed,  3 Dec 2025 15:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777188;
	bh=nNAXRvyP8aeMQIUjwLdhkk++z7DRWvGkMZqBNGdVipw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y9g/PQy8hsuEc+b0N+gBeuVAtURd8Vtxrqu72Dhcp/NOSHv7PDbvLb1VKT8AYUw+l
	 FZAVZd2XyyYpRw8UaqczoHkocq5dTXX5zX4rxb5tcwOz7ke4+2uF+xOQEZ3r7Gwx3A
	 brkfQIeA3egDdZXcsX2j8JC78jO4GjihI0tsakfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Zhaldak <i.v.zhaldak@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.17 076/146] ALSA: usb-audio: Add DSD quirk for LEAK Stereo 230
Date: Wed,  3 Dec 2025 16:27:34 +0100
Message-ID: <20251203152349.247202922@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Zhaldak <i.v.zhaldak@gmail.com>

commit c83fc13960643c4429cd9dfef1321e6430a81b47 upstream.

Integrated amplifier LEAK Stereo 230 by IAG Limited has built-in
ESS9038Q2M DAC served by XMOS controller. It supports both DSD Native
and DSD-over-PCM (DoP) operational modes. But it doesn't work properly
by default and tries DSD-to-PCM conversion. USB quirks below allow it
to operate as designed.

Add DSD_RAW quirk flag for IAG Limited devices (vendor ID 0x2622)
Add DSD format quirk for LEAK Stereo 230 (USB ID 0x2622:0x0061)

Signed-off-by: Ivan Zhaldak <i.v.zhaldak@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20251117125848.30769-1-i.v.zhaldak@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2028,6 +2028,7 @@ u64 snd_usb_interface_dsd_format_quirks(
 	case USB_ID(0x249c, 0x9326): /* M2Tech Young MkIII */
 	case USB_ID(0x2616, 0x0106): /* PS Audio NuWave DAC */
 	case USB_ID(0x2622, 0x0041): /* Audiolab M-DAC+ */
+	case USB_ID(0x2622, 0x0061): /* LEAK Stereo 230 */
 	case USB_ID(0x278b, 0x5100): /* Rotel RC-1590 */
 	case USB_ID(0x27f7, 0x3002): /* W4S DAC-2v2SE */
 	case USB_ID(0x29a2, 0x0086): /* Mutec MC3+ USB */
@@ -2411,6 +2412,8 @@ static const struct usb_audio_quirk_flag
 		   QUIRK_FLAG_DSD_RAW),
 	VENDOR_FLG(0x25ce, /* Mytek devices */
 		   QUIRK_FLAG_DSD_RAW),
+	VENDOR_FLG(0x2622, /* IAG Limited devices */
+		   QUIRK_FLAG_DSD_RAW),
 	VENDOR_FLG(0x278b, /* Rotel? */
 		   QUIRK_FLAG_DSD_RAW),
 	VENDOR_FLG(0x292b, /* Gustard/Ess based devices */



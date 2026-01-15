Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95E0E3A7F43;
	Thu, 15 Jan 2026 16:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496386; cv=none; b=KYGVPq5LyqtebfQZGNNgcB+dIJb0WHmpxA/jGvOetksTCoN66Vn+P/IFn45RaeFwxbcbwfVei29g6wrhNt/1EWuyOQTnDN+bYUXJcSBny5h+gz7fogUdxEEvMiNDfrZJ52xdBMPros1fp28UeCCYJKrUu0XcxVHwtRLUuyRl1uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496386; c=relaxed/simple;
	bh=T5DGKortasLn4zlEHsrDA3MOteJj7vKCVgOJRhbo4vE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ft5sW0sz5RPm2zoucJjFGXN+Qs6fi5pZb3RiQC81kxShtVavrdvN+2jFu/NnrjdcklPVKwJoLvHeajWHbFu2gqXj81XrPvvQNamMS/lMQXC5pYhyyddCplE9mS1Bri8BMkO2cXWjuyilHR426uCtSa6hMJuQGQc2zYqOIfcHMKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yZkFZ/sp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yZkFZ/sp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 247E9C116D0;
	Thu, 15 Jan 2026 16:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496386;
	bh=T5DGKortasLn4zlEHsrDA3MOteJj7vKCVgOJRhbo4vE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yZkFZ/spjiS6Vpc6wWR53Q3XVCcFwx8brXGQ5ABXhqZtJLCzKSlby3t0S0PSdilLq
	 1OI4UM+hzpl2K6c4V2CHH2YZFObYQJRpr0KK3Q/yFwGwxhrhYAZMOn3Pa1ZGSF3ZDE
	 fxwpA1W3t5x4viYxcylr3BcA3a2gRH0z0psi37Yg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jussi Laako <jussi@sonarnerd.net>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 176/181] ALSA: usb-audio: Update for native DSD support quirks
Date: Thu, 15 Jan 2026 17:48:33 +0100
Message-ID: <20260115164208.668058862@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jussi Laako <jussi@sonarnerd.net>

[ Upstream commit da3a7efff64ec0d63af4499eea3a46a2e13b5797 ]

Maintenance patch for native DSD support.

Add set of missing device and vendor quirks; TEAC, Esoteric, Luxman and
Musical Fidelity.

Signed-off-by: Jussi Laako <jussi@sonarnerd.net>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20251211152224.1780782-1-jussi@sonarnerd.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 61bd61ffb1b23..94a8fdc9c6d3c 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2230,6 +2230,12 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 	DEVICE_FLG(0x0644, 0x806b, /* TEAC UD-701 */
 		   QUIRK_FLAG_ITF_USB_DSD_DAC | QUIRK_FLAG_CTL_MSG_DELAY |
 		   QUIRK_FLAG_IFACE_DELAY),
+	DEVICE_FLG(0x0644, 0x807d, /* TEAC UD-507 */
+		   QUIRK_FLAG_ITF_USB_DSD_DAC | QUIRK_FLAG_CTL_MSG_DELAY |
+		   QUIRK_FLAG_IFACE_DELAY),
+	DEVICE_FLG(0x0644, 0x806c, /* Esoteric XD */
+		   QUIRK_FLAG_ITF_USB_DSD_DAC | QUIRK_FLAG_CTL_MSG_DELAY |
+		   QUIRK_FLAG_IFACE_DELAY),
 	DEVICE_FLG(0x06f8, 0xb000, /* Hercules DJ Console (Windows Edition) */
 		   QUIRK_FLAG_IGNORE_CTL_ERROR),
 	DEVICE_FLG(0x06f8, 0xd002, /* Hercules DJ Console (Macintosh Edition) */
@@ -2388,6 +2394,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_CTL_MSG_DELAY_1M),
 	DEVICE_FLG(0x30be, 0x0101, /* Schiit Hel */
 		   QUIRK_FLAG_IGNORE_CTL_ERROR),
+	DEVICE_FLG(0x3255, 0x0000, /* Luxman D-10X */
+		   QUIRK_FLAG_ITF_USB_DSD_DAC | QUIRK_FLAG_CTL_MSG_DELAY),
 	DEVICE_FLG(0x339b, 0x3a07, /* Synaptics HONOR USB-C HEADSET */
 		   QUIRK_FLAG_MIXER_PLAYBACK_MIN_MUTE),
 	DEVICE_FLG(0x413c, 0xa506, /* Dell AE515 sound bar */
@@ -2431,6 +2439,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_DSD_RAW),
 	VENDOR_FLG(0x2622, /* IAG Limited devices */
 		   QUIRK_FLAG_DSD_RAW),
+	VENDOR_FLG(0x2772, /* Musical Fidelity devices */
+		   QUIRK_FLAG_DSD_RAW),
 	VENDOR_FLG(0x278b, /* Rotel? */
 		   QUIRK_FLAG_DSD_RAW),
 	VENDOR_FLG(0x292b, /* Gustard/Ess based devices */
-- 
2.51.0




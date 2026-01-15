Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1A9F396B7D;
	Thu, 15 Jan 2026 17:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496717; cv=none; b=m2EN6e26JQ1M1UumQWnc5W4IWuVuFSlif1YlIIKUSqHFCOyBI2ininygvCFriDe0xngBJObWCX+9YUnA1zxve/f6BuwbL0P/Z9kWNR4o9ZUmS02g/1ciTXWqQayGxRRrR5yB402Vdry2kMULv3aUaGUAl55fjH/1m+fAvMv1nf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496717; c=relaxed/simple;
	bh=1j6R2RG3EfUnKpIFkfefW7OytIvaB/eFbyHMJNq+GV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J9MXT0AjVgChrrscP3t3tQYHvmukxp2tcy0uLc56eyrgWdxqH+NgWERjTQ3pUJJ0y4QjQAHBT44em/QqroCVplodFMew3+QFX2vCtrTA5b0ZyLds1GlR2+Zi21mlY7pOu6WBP0Q3IyuI/27tRq9ai1Clk6tnEJzEs55RKIghXNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yecJswUX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yecJswUX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E403C116D0;
	Thu, 15 Jan 2026 17:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496716;
	bh=1j6R2RG3EfUnKpIFkfefW7OytIvaB/eFbyHMJNq+GV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yecJswUX2beFQPuLpKMJmZikpxz/i2m4ZItyZO4qgO8DnKjEt6z01s8Q1tojeyBXj
	 cq1brTR61p6XVMGZDOQYIqITMyyDY2taYUJSlYr0Q2DqFE3OM4/W642/fMHGc/r6Z4
	 cb30NaUYhpvp7f7+3L45jDPRUuBLz4DjLkv2hmXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jussi Laako <jussi@sonarnerd.net>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 111/119] ALSA: usb-audio: Update for native DSD support quirks
Date: Thu, 15 Jan 2026 17:48:46 +0100
Message-ID: <20260115164155.966739097@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a74bb3a2f9e03..8fa840df46210 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2225,6 +2225,12 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
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
@@ -2377,6 +2383,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_CTL_MSG_DELAY_1M),
 	DEVICE_FLG(0x30be, 0x0101, /* Schiit Hel */
 		   QUIRK_FLAG_IGNORE_CTL_ERROR),
+	DEVICE_FLG(0x3255, 0x0000, /* Luxman D-10X */
+		   QUIRK_FLAG_ITF_USB_DSD_DAC | QUIRK_FLAG_CTL_MSG_DELAY),
 	DEVICE_FLG(0x339b, 0x3a07, /* Synaptics HONOR USB-C HEADSET */
 		   QUIRK_FLAG_MIXER_MIN_MUTE),
 	DEVICE_FLG(0x413c, 0xa506, /* Dell AE515 sound bar */
@@ -2420,6 +2428,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
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




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF064D7D26;
	Wed, 30 Sep 2026 15:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782828; cv=none; b=c/DE7cx3Vo8SB+/S3IskwYTAx4DGCCmobj+jAr0rB6Rs0BDWZBKI4p2qfc+ybDoOsoWwxMspqd0oUvrEGgwJd4nWkJQzzfXjOtWsGyPNzugAb0Iw/uGPQ7e9TLk6zZUCSAiowU8Pawy06axDnO0GDkahLq91hPW83MjARB3AdvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782828; c=relaxed/simple;
	bh=BYIpwELDfXJ6aWVU4RR0N8m8UHd3LUNJKagrS/PHqrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MX4XaXCN8MyKPO1HVY96sLeN89psxPr5vU0fAjS/bbEcai4YGwdOwpLNpOVyIsI69iHet4ZhFA5Z2QXCslmT7DoKiWMgGDu/GdQEq+snCqNOPWUge9QdsXqSRNWbX0PE96I5vRDer5PK3l8+rmnVnevEOGcRDYtlN8t2eOd99Z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pN/UD9g/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pN/UD9g/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4A5E1F000FF;
	Wed, 30 Sep 2026 15:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782820;
	bh=kF6j06DETdMyO0lthZZ7CJoFJa8KUBDUSgSbdigl3O0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pN/UD9g/62sVFcEzr6Nhaurk10N2T7ayOGCyl2ZPeonuzLKjv30k+Ir+qmC+4su0j
	 LDxOS2qRHo7Tg8+Jeb0djdlgWQrUhasbf+lpUFjBohrpSTM6//GlkQ4WBgfHm04zYh
	 /UOCWI4RkDJosZFBlJzrwOdRQQ8gnaoo1rObvOoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Abrahamse <denobyte2@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 181/595] ALSA: usb-audio: Add quirk for Corsair Virtuoso (later revision)
Date: Wed, 30 Sep 2026 17:21:14 +0200
Message-ID: <20260930152351.633638618@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robert Abrahamse <denobyte2@gmail.com>

[ Upstream commit cee046679655b4822f76efc9658f19efee9ac979 ]

Add USB mixer mapping quirk for later revisions of the Corsair Virtuoso
headset with USB IDs 0x1b1c:0x0a43 (wired) and 0x1b1c:0x0a44
(wireless). These devices exhibit the same mixer label collision as
earlier Virtuoso variants: all controls are labelled "Headset", causing
applications like PulseAudio to move the sidetone control instead of
the main playback volume.

Signed-off-by: Robert Abrahamse <denobyte2@gmail.com>
Link: https://patch.msgid.link/20260728140314.11601-1-denobyte2@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_maps.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/sound/usb/mixer_maps.c b/sound/usb/mixer_maps.c
index 08082fdf82187..5e8c91c9f1528 100644
--- a/sound/usb/mixer_maps.c
+++ b/sound/usb/mixer_maps.c
@@ -603,6 +603,16 @@ static const struct usbmix_ctl_map usbmix_ctl_maps[] = {
 		.id = USB_ID(0x1b1c, 0x0a42),
 		.map = corsair_virtuoso_map,
 	},
+	{
+		/* Corsair Virtuoso (wired mode, later revision) */
+		.id = USB_ID(0x1b1c, 0x0a43),
+		.map = corsair_virtuoso_map,
+	},
+	{
+		/* Corsair Virtuoso (wireless mode, later revision) */
+		.id = USB_ID(0x1b1c, 0x0a44),
+		.map = corsair_virtuoso_map,
+	},
 	{
 		/* Corsair HS80 RGB Wireless (wired mode) */
 		.id = USB_ID(0x1b1c, 0x0a6a),
-- 
2.53.0




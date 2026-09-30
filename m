Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7ECA2AEEB;
	Wed, 30 Sep 2026 18:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794791; cv=none; b=tiNnMxC/LEngzmL/ieUqGQSc3v8LZUawmVQDDKnPG65WuYeoplDqb99PLy55mA+vd2s5Oie+sZdFFZOqRyREUz2Pg2c+wy02v5IZjPePNzh5PKesheYeaP6venvpuGh4247+kRx9vzEFZtr1bqz7F2mXcOvprjA+4WtGcj2MHMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794791; c=relaxed/simple;
	bh=53mris9uZaT8kdJKcBbs1oOcQaKAfBCzJ+yBf3YM74o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hFuMQZFgQLNmi6zg4tdPmvRknusyVMPIB7WF2NvPG3F17QeAHKvU8rqkY2D5Rxb2O7iQ8zCZGRpgCowOJzaiSAkLNFeG5aV3i+rBlMQo48MwbXTGoYC3UFnJ9uqFA/3+/Gldv88dFQY7HringTNK6aNw8pRYnQFs6+2UzXni8qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kD/3V9cc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kD/3V9cc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D5D81F000FF;
	Wed, 30 Sep 2026 18:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794790;
	bh=42p3Xk3bek/3PRZyxtumYEkt9HoLNcmIpRfGhkLJ2iI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kD/3V9ccVIZ1FoPJvx4RtWIwC3VOJLqwcubNqB4Wt6FGh4TOIXBKyk+K6jpdKzRBi
	 Ux3xnoT5u7YXpMDlmDZoT/zDnPCETKZJx9MoDbiakYYfkMqSClH0HzLRFouMKKiOSt
	 7sEHtRAU/s5t34YJtYFElfZCCyBb5dbqwCMYtC+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Abrahamse <denobyte2@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0336/1193] ALSA: usb-audio: Add quirk for Corsair Virtuoso (later revision)
Date: Wed, 30 Sep 2026 17:17:00 +0200
Message-ID: <20260930152441.620918299@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4d8dca04f87d0..ce27fc871f513 100644
--- a/sound/usb/mixer_maps.c
+++ b/sound/usb/mixer_maps.c
@@ -638,6 +638,16 @@ static const struct usbmix_ctl_map usbmix_ctl_maps[] = {
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




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A981A49D594;
	Thu, 17 Sep 2026 18:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668520; cv=none; b=FrwRL5GIqVN4RHJeueYlLI23k20Hgf//6Sh7VeZH/5YEvS9FxGnNZUc8bmyhN10ZWNd2K2BcdmsDIFZ0jWbcGEkDQdoH0uQhMjA7WWSpzPQUpkqlXC5C4o4qYARZDV1p3M5b1csSGzLAQ0ge3RpsXFP1cNZ2WR70b7PUGzTjPp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668520; c=relaxed/simple;
	bh=76X7mwoGDoX84FG13YxYuufNePsBlGSE988thA07iVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eyhMGZgH42DOVw7HU7lbzefdxkrWh3sWBdPAktZ+/JkE5ulcaIKXFm/SCla+8EAOwv9ngDaALyNj43QKYaBd4ZRQVpGA0LiWjEhcje1WpIUsK3av1MJ/pNAnlQny6bEBlUFQYHdPmPDvBhopAHdU1ticQDx4o9EQObBm3TYVrKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EKj2yB+5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EKj2yB+5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05D751F000FF;
	Thu, 17 Sep 2026 18:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668519;
	bh=kpzPdGA+yeShLJUEP/6kbty98DTzpyZsxuXuXWWY61Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EKj2yB+5uPkycmhGmf+RcNLBXPo7fyz3zSBvGHfOe/z4wu9gxp8oxQbsErUC0EuzT
	 sE6ZTCj4hOJZieyA5qV+cQyYDd0d1W9o1/N5zINlWdQuKSwLmRiTJggfucAoOcb+yo
	 l8kUsT+QQTjfNSXK2V6TaJXGhQsL0qMDxSz8oRJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Abrahamse <denobyte2@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0450/1102] ALSA: usb-audio: Add quirk for Corsair Virtuoso (later revision)
Date: Thu, 17 Sep 2026 16:06:33 +0100
Message-ID: <20260917151550.983292916@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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




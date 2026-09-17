Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96E4751C04E;
	Thu, 17 Sep 2026 17:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664988; cv=none; b=K9lh9GlS5IrVIQdrdHoPPKIB1JLYw1tdVGYgRTFuTU6oqUjl4lhc6e/XFc3G7skxp5Lp2cmrqRwwJxVcHivKCb1CRZ//b1wqvE/8AfUhZsNo1wiF1YZ1brMkQMk5J36j74PBspL2kRFsjoxbLviqNIeuugPWxzX/B3d/qDQ8khc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664988; c=relaxed/simple;
	bh=Y7u74SRs0XCLxGuuocjmHQ+RAbhz4JAGMDMLgPSpaaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cHAKXAAov2k25mc11gZqZzUX8aAQWmqrFn8JhSad+0dA1cqwNHFILBQT/hYD3CBs4o6bagvl24odDQlr/yvjGVD2HgWHc1gx2OxtJku9ICK9qKV1HxtjC7CFdHlY1WrMBRKWmBttTmosqe2+QU8WBreOuS3yst4Y8RCz7WHiw3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ugw74uJU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ugw74uJU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7C431F00899;
	Thu, 17 Sep 2026 17:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664987;
	bh=uYoXfukwVuPSbX2lSbTbUzofZBKZ7Ka+4wrd+n5bIdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ugw74uJUHj5+iZ/RUobPSr/QpRUtgpD4tZ28wva5YXeM2gnKYD4o3lakdCw0sAzvP
	 hE7ZttcSqEV/g8os4V95hKVA4dTDCWRXIVRpv5kcPuY+gZ7G4QuGGymrsRDjKl0dLv
	 u+34BrR2U4UtrFz24JE6Z4Qe6dztXbWv3aSOscHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Abrahamse <denobyte2@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0553/1250] ALSA: usb-audio: Add quirk for Corsair Virtuoso (later revision)
Date: Thu, 17 Sep 2026 16:05:48 +0100
Message-ID: <20260917151606.920735440@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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




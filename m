Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D9D515976;
	Wed, 30 Sep 2026 18:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791325; cv=none; b=l2GIaoDbcLJh6CZWWdkGFGMFG7lWsKZ98bLzleIXuf4UOTaNg6oHn5NxiTxYccwxw7n4MzYR12eQwhdyNBPwCRNKmuR57QTq0DIyFAZ4WP6h0MzyA41qLbYPUoLGSKzBzFOeMOGy8mZQL8B7iW/uIJiAvChbKkLaXVqUP/KfLyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791325; c=relaxed/simple;
	bh=61PT2sh400HOSQe/msr1dN6GUmxoRSMS2mkg80Y81uE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X6FrMc9dMJVZhLJKet8YT1HOOqTcc8bxmt96HtwWLuK7oPQSm13OInmzO8aATno+v9HFPUJNBievnvkZSWg0n20kjhIyLKRKouEBMjOLgHzEAT+2Lg3kupdRmo0s8FPYJmFEoRW16gVfJ1E0d4WSCKILMwcl4B1kWcKGAtsU0Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NNsaOwgm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NNsaOwgm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64C011F000FF;
	Wed, 30 Sep 2026 18:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791323;
	bh=NVO0k+6HYwrIeaI9C0YWW3/NhoKVBlpQG5Z06kn6LY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NNsaOwgmcA9eVzU8+tR6lKm9pEJrphiPpMLcR6LediRbFmcYE9lhNVmi+vDsuCaID
	 1VDEgcfyP52CqXeBNuFKGtPabbLA1d08rHl/ng/ueFMhxLAVt1ayxgeyxmapnXMil1
	 DMYuxZoFtGO0rA+Ej911JVsjh6HLev5Wbm9zHbXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Abrahamse <denobyte2@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 225/752] ALSA: usb-audio: Add quirk for Corsair Virtuoso (later revision)
Date: Wed, 30 Sep 2026 17:21:35 +0200
Message-ID: <20260930152403.125011200@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index c6fb2aa9f3702..dc2a5491e554c 100644
--- a/sound/usb/mixer_maps.c
+++ b/sound/usb/mixer_maps.c
@@ -581,6 +581,16 @@ static const struct usbmix_ctl_map usbmix_ctl_maps[] = {
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




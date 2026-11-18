Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021867;
	b=WX5EWp+UWEXn3530qh1XwLesZ81dTePzt3Zo4i1YaWh8n1tX2TeBwvAdv0GdXSItTSfj
	 bR32K9Tbwv5J2I4ksV+o92aq5fucaXjuql97T24EYRfSHHBQ3g/SgTnQcLUeuU20Yr423
	 NePurTxWJ4XtzGoLI8ofD5rprsr1uiFUBohR9UG7rS2njhYvvGxwOEwCIoFTtjsjCkc8u
	 3YrjL1xqUjLNL9NhWI0r+8WkkHRfNDYmhzywP0/xQoixIbpjjGJ39GPEaGnlRpDTJbxkJ
	 YhWwQ13K06qy7F5a0jZJz/PHEEGKCou8Tk0L1cR9ArajCIswtNFCby8NR9VoDcUbhIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021867;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zfA7+m2BvB7g4S8ZRA3T6Ol08+h6RULN1ZgFGkHI/aY=;
	b=jV/bx6ArofGK9CEGAw94vjwynQvln47leWspfQDvuoxxrvkqRPjE2NKJIScjDeq1ZXeA
	 VhLXVDLPb6zfbkYae4SKGOvK42COYoqJVZ0wku+ffW45WVbjCs00Y5oOSKnjU+OGkxNwS
	 hU4vYIcEw13a8O50k+J628v1Yt6P914nlrHp16lEbKaKLx0sc1ZzwpjNpNBEw43fH0fRx
	 p45SkyeaZg7k70JmbH7MufyCeckUtXJvPy/ViYGgwwxwBU4RRoWpPEd2Eh279uikCsw3A
	 O5GyLOhiy8SCwEMyubYLk4OdjkZyo6yRRFmgYe8+8v0dIfcRLCuF3U3K3YbcgqnoOtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SuOkAmop;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B977606A31C;
	Wed, 18 Nov 2026 17:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SuOkAmop
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E9CF1F000C4;
	Wed, 18 Nov 2026 17:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021866;
	bh=zfA7+m2BvB7g4S8ZRA3T6Ol08+h6RULN1ZgFGkHI/aY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SuOkAmopE9yLO3IlZE/8T7F7b3c0RfnSbachrBlu9KpS4y1sNe6/8ao3P+tP7eCow
	 oNJhq9XD7uA0TXgE3fRJEGdFndCowplCORIoAIRnTjsKiFGOn34QZHlDER6DwrqXEt
	 byPO61DKsI2keL9DUVfH8GUaXJC2ec0jzEnNNMEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sally Marcher <me@gry.sh>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2460/2651] ALSA: usb-audio: Add correct datainterval in the quirks-table for Microbook II
Date: Wed, 18 Nov 2026 16:01:40 +0100
Message-ID: <20261118150413.614015631@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sally Marcher <me@gry.sh>

[ Upstream commit a09c2f3b267e47767b8937f65930567edbb88d44 ]

This patch fixes playback issues on the Microbook II.
The correct value was in the older driver for this device
(https://github.com/manuel-rhdt/snd-microbookii/blob/dd304c097bb6a9d52276ac29c6969fa02bc7674a/audio.c#L914).

Datainterval needs to be set explicitly.

Fixes: a634090a0f24 ("ALSA: usb-audio: Add quirk for MOTU MicroBook II")
Signed-off-by: Sally Marcher <me@gry.sh>
Link: https://lore.kernel.org/d5dfd044-69f6-4fc3-9884-6599d88afb55@student.tugraz.at
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks-table.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index 0426cbda314b0..4c0bc2dd7d3eb 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -2813,6 +2813,7 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 					.rates = SNDRV_PCM_RATE_96000,
 					.ep_attr = USB_ENDPOINT_XFER_ISOC |
 						   USB_ENDPOINT_SYNC_ASYNC,
+					.datainterval = 1,
 					.rate_min = 96000,
 					.rate_max = 96000,
 					.nr_rates = 1,
@@ -2835,6 +2836,7 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 					.rates = SNDRV_PCM_RATE_96000,
 					.ep_attr = USB_ENDPOINT_XFER_ISOC |
 						   USB_ENDPOINT_SYNC_ASYNC,
+					.datainterval = 1,
 					.rate_min = 96000,
 					.rate_max = 96000,
 					.nr_rates = 1,
-- 
2.53.0




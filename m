Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056852;
	b=3hcwp0+PBpeEAURuM6m4cP7bONYjNhQeytM5FQv1DQvG0tp+igrMsWhLXU/ftWorb72k
	 z8kOO61zVb7slDOzxDh403pQM3q/hwKmpjuG+gwx70tlZm/Qeg2b3XtgmAqBsfKuaV+54
	 fKfdIT5AWVr4eVvQsqBLGzm3zftwZos9IzEFn/SZUO5jmiUoX6tzo+3b6SvZ3q4aFoZjr
	 7iFl8tl0fDXj4kpEq/UCChbULh5lvWVOb7j3yeD662vwXzIKiEHz5RumQEhWibb3MyQWe
	 Wjo4Mrl3ekPA9sjKEaVo2amENhPHhkv/reHe66govaNnBhplCmFCuHwlklP0N8EO0GA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056852;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xm2FQooHwpWcl3bbG24+UYu3fKv0T3aOvRUOjnuYcHQ=;
	b=eKCPr1kNct8pZEBnzp78+4vUvApgd+P31bcT2lV8NKjq40lfQUi1moPtmeq5Zfz0wx2Q
	 GGB3kiHglW6xQtKSU4T5KIl5BHS9ASu+fajEVkjqnUwvKmKljf5UnY6AmCLvKe/BXF4hz
	 1dZgqNpZnWSW2LXvqJkPZ3+v8aQ2IPdp/gkQAvXiu8R2eAJy0rY3Cu0WqjiOW5cOTsNbF
	 FS83hfiHnRfcawI1ODk7WmD4saU4qOZupPPXm0PVTpvsk+ExU7Xj13MP3fu/VizJa8hAF
	 RO1bvrVQ0O4hSsjicw0DDr4MkMZimbyRXVHmxnROmYA8Vw9zUP1cwu5B4XasVvglXwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LK6OIlP+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78A6D606A31C;
	Thu, 19 Nov 2026 02:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LK6OIlP+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CD5A1F000C4;
	Thu, 19 Nov 2026 02:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056852;
	bh=xm2FQooHwpWcl3bbG24+UYu3fKv0T3aOvRUOjnuYcHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LK6OIlP+Wf8Rh9Tmj1FnzYUNsPW9vb8sTOvq8y27z1NEIhb+zaipAwiEIvR2pTpAG
	 LpqAOf27b5SHqUdAu5wM/V1u1Rh8C0mdl/Q4DoqTcw9do+i9qB8dj8NhJs2zNHE+s5
	 9Q97m90MIB5x7FuDGStXQl2GN65a9txV4xBVzfHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sally Marcher <me@gry.sh>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2136/2214] ALSA: usb-audio: Add correct datainterval in the quirks-table for Microbook II
Date: Wed, 18 Nov 2026 16:03:32 +0100
Message-ID: <20261118150135.972415935@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 941d9bef67e4b..331aaf6e9f85d 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -3522,6 +3522,7 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 					.rates = SNDRV_PCM_RATE_96000,
 					.ep_attr = USB_ENDPOINT_XFER_ISOC |
 						   USB_ENDPOINT_SYNC_ASYNC,
+					.datainterval = 1,
 					.rate_min = 96000,
 					.rate_max = 96000,
 					.nr_rates = 1,
@@ -3546,6 +3547,7 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 					.rates = SNDRV_PCM_RATE_96000,
 					.ep_attr = USB_ENDPOINT_XFER_ISOC |
 						   USB_ENDPOINT_SYNC_ASYNC,
+					.datainterval = 1,
 					.rate_min = 96000,
 					.rate_max = 96000,
 					.nr_rates = 1,
-- 
2.53.0




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050554;
	b=xVdXTW0B5+CzYgU0DDpyebV1tSecmWzb+lSH5/jd9U+BotfBPM/vwlygS61woBeiw0ip
	 ZYSllImPG8Vg3r90sEGr4OZ4bHhuHVkmj7zvxzwol3HMB8pPtL+5ow9BdS12VEp031OxK
	 +nODCHS3jgRL5fHuluOcJvTIavqiJdHJRQT7Q1LjMNBYtXJe1sP/0r5qQ2w8HP9LuFQHA
	 bXQ5fFA7Pq3B+0nfFEf34LApFD3psyXOzyE+qasJWnYaHKXQXv6gtIKwZFiJYaVqzcHC9
	 JecWT3Xo6SwnjL3Vf2jz24/0JVRADrbIbH8EuCfFEhotsd4n3YJ6auA/45f77nzxaUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050554;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FMjLPyauRipDFh69cImD6rp+ecNiJdqT5BnomdE9iLU=;
	b=JNcP8f/ebzCo6bflZ9a8tS5cjfJx+RYbFmy1InHXo+TXaHCbUcgcxvjDf0tYN2p0oFF6
	 NCQ9wNctg+O/h9hQEs77yMNtqcpLbiUUm2ZH+yLMf9eWUUGKpdTvCbVtK1knuRnbOD4Vu
	 6QCcJOBrteZTSukKncxNrWuGVdWCWOsEzuhwdb9d5TIZJj8J6cVRY9r2Rf2bevYAaHrim
	 XL5/tsr1nB0F8IiqrI6NUPLI7VN3enS5zyJWAeq+EU6gbJZ8CsOWLkr+w+gxbOaIR0zYx
	 pwROpIJjsQKTD5MTeqF0ANec6puYb/QfeHVGXAxDb5zB0s81GkOgjHPfgqp2disNh8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QfkXJ25o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9F04606A320;
	Thu, 19 Nov 2026 01:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QfkXJ25o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4639F1F000C4;
	Thu, 19 Nov 2026 01:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050553;
	bh=FMjLPyauRipDFh69cImD6rp+ecNiJdqT5BnomdE9iLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QfkXJ25oRY1WJ0eBzUQJEjRF5h1U1ady6XJVLVRkf96OOP6GVsYYrboCQhIubzahJ
	 7mXKWVQqNEShMO4npFMNxM3zMnbHvlApDTwoFQiHMCVxWY7zDXxtqnNIRob7oifvNj
	 3EUucvcjGVVIvdO7myC9124UCXzmcOmpCMorzwaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sally Marcher <me@gry.sh>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2748/2857] ALSA: usb-audio: Add correct datainterval in the quirks-table for Microbook II
Date: Wed, 18 Nov 2026 16:03:02 +0100
Message-ID: <20261118150340.556421186@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b505ec63f199d..def8645937def 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -2743,6 +2743,7 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 					.rates = SNDRV_PCM_RATE_96000,
 					.ep_attr = USB_ENDPOINT_XFER_ISOC |
 						   USB_ENDPOINT_SYNC_ASYNC,
+					.datainterval = 1,
 					.rate_min = 96000,
 					.rate_max = 96000,
 					.nr_rates = 1,
@@ -2765,6 +2766,7 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 					.rates = SNDRV_PCM_RATE_96000,
 					.ep_attr = USB_ENDPOINT_XFER_ISOC |
 						   USB_ENDPOINT_SYNC_ASYNC,
+					.datainterval = 1,
 					.rate_min = 96000,
 					.rate_max = 96000,
 					.nr_rates = 1,
-- 
2.53.0




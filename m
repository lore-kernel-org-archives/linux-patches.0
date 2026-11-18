Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042493;
	b=f23ciF0ssHmFFLWhZG8UlvnFGOMyZNjozuMKnXyUzRoKgtVK2cakhc8Uvs6jLN6e1M8R
	 QAAO2+mujMGihum8nNhNrM2VBCIRHuflyod5YjVgwJLIeTfoYb3FhDxnE0a0nUb5KSU9Y
	 yHSvnJ2eYIH8jNHGNS1bdJgiZzv7P/PKZtICAEQAlWE+g/8pGLKE+OqZTsjJo7UYnrsVl
	 mPMqSbpsqPIWPgGdV9xFKI0VYZ61geNw74+NGQEAD4KUyPq0hK+VvKZwJDq1kmU0ykFXs
	 zZfTWfqdN9Pqhz2rTg/iq6PE4jGDLweT3mkO12uzEGKXQ0VoQC9GDXnEjLIK7qo2lLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042493;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=78QyNCbzjVKrOp5NfxrCSvD9/Z1CDYHSHnmrLNu2drQ=;
	b=hIHfMVk002qvd/bVJdQ70tQ91Ca5oKpgbIY3Ddyd5bTstALDXTahKsGFKHDf+PqyYq13
	 X5ENwMqOKCOBdXRwqrREVNsKVaXw7HYYh+QIrYod7JYdremLvv6KHAmMu0apr0K4UqZN1
	 W0UVqoXLt0v4qhX892VOrmnL2CIGCbsf5f9mNgRf2hd3ds5WiLYJyV3LcVvlOwBpGAWGB
	 JBm7xJJQjy9SGhNBNgmCzXsxlnz9Ol+EfhBXypFyu7WzGlQY6EtnpamanfVHVLXKOv5ks
	 ELUlzmnyzUGj6KRwKKVVbXXCr2lhma7l2WHuCT9/dcqagCeEwUfd8mFmhKKixl4YKeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t4NIZ2kF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A57606A325;
	Wed, 18 Nov 2026 22:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t4NIZ2kF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DCF71F000C4;
	Wed, 18 Nov 2026 22:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042493;
	bh=78QyNCbzjVKrOp5NfxrCSvD9/Z1CDYHSHnmrLNu2drQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t4NIZ2kFMbqzXWKVum6s6iiWQwZY+amqYN8fdBGHWQzw17gy44SBjV5m87xJahCfC
	 MDFCgi9ayShcwhHlV6HMaGiFLZq3e0dFRPK59YenGLXAvwZAQshgNAGayZY6Pn3I3F
	 ylc/ym0FCGmbENo/9SgWlVJazxWUaaOg+L4GlEM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sally Marcher <me@gry.sh>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3189/3318] ALSA: usb-audio: Add correct datainterval in the quirks-table for Microbook II
Date: Wed, 18 Nov 2026 16:03:31 +0100
Message-ID: <20261118150455.460759330@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062085;
	b=xXddyyDt5qf9L1uIyo+y4MV+mtxToEfIj5H3dWUpnfaRdi6QjK5jYTVZLkBnCFh5COUO
	 thkLsIGniaXY940FU79mSDg5OIRa3fvhtglcKqga4MkxnE5hwAERO5sjHPeb5kKSZT2do
	 bY1vdD7xffp08yIAeZ4FycVw3IRuI7XDFtjn6ppwp/mrKZkFZ8Hp7YmtAmN/kqR+0cs9t
	 LrDW8FzyGSU2P8esMyHIXZ9Ow3kvxehsCri73v7ZJL9nx13ucJRjO2tAWdBDwlTTWVCu8
	 lmyt4Y61ZGMXxYoqGEBT2w1l2ypGbi4U3mTljIQ9oiDkhsU8VPSOdPEz5kRyJnOy9Dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062085;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VGI/55mOj8yC52O05YW6J7nSn4SySFk46aIamBp8kYQ=;
	b=dQESHDgnOQafGKCs/I2fBPNBeKaTwmoUEoi4ccscdZxKv2twx1jg/ADz1wqTS+4B4OXf
	 qgg+1+yHtcBifZqspqTRKARPqzH9eyI3VAYWRRYEyiVwaahtYuiKW7Z750JQsUCfwuubv
	 SmNrZWgyu8/557b4e4ELqLC7T/o4xHhEaVXTgrdzey+kLREQI08IXpudQcB0rVyRvLFq9
	 yhlKv+6vfXc05BRwXxg87Nos0wd65bsn7+fXCUN1cgkw/KRwZ4BgqXNu/x1J6L6GtEdq1
	 OoE6D45VaPhxTHQ3M8r/3J5G+DfUHjnZgHaUYRyJ8bjgrvdTP2nDuBGqmf6RrgtgAtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NNWClI17;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADAAF606A320;
	Thu, 19 Nov 2026 04:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NNWClI17
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BE271F000C4;
	Thu, 19 Nov 2026 04:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062085;
	bh=VGI/55mOj8yC52O05YW6J7nSn4SySFk46aIamBp8kYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NNWClI17M485HXjV75MXw4wUODUsW6desTtrBCJtmDFplrCO1dXP2CxW+spS2GxRh
	 W3P4OkSSbQhIn9ETqaF91ROEL3nKChK3T90vd9o7MRJFG6oGoyU3kSfKw8TVTO0LrC
	 FQ3adw570AvInor2TC4L3iWUg/qqxCDhgGbTKIpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sally Marcher <me@gry.sh>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1785/1848] ALSA: usb-audio: Add correct datainterval in the quirks-table for Microbook II
Date: Wed, 18 Nov 2026 16:03:43 +0100
Message-ID: <20261118150034.048433893@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 3ae8f8cd22d94..65d733c4ef546 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -3496,6 +3496,7 @@ AU0828_DEVICE(0x2040, 0x7270, "Hauppauge", "HVR-950Q"),
 					.rates = SNDRV_PCM_RATE_96000,
 					.ep_attr = USB_ENDPOINT_XFER_ISOC |
 						   USB_ENDPOINT_SYNC_ASYNC,
+					.datainterval = 1,
 					.rate_min = 96000,
 					.rate_max = 96000,
 					.nr_rates = 1,
@@ -3519,6 +3520,7 @@ AU0828_DEVICE(0x2040, 0x7270, "Hauppauge", "HVR-950Q"),
 					.rates = SNDRV_PCM_RATE_96000,
 					.ep_attr = USB_ENDPOINT_XFER_ISOC |
 						   USB_ENDPOINT_SYNC_ASYNC,
+					.datainterval = 1,
 					.rate_min = 96000,
 					.rate_max = 96000,
 					.nr_rates = 1,
-- 
2.53.0




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032968;
	b=Umo7HYAr7AyYZ2XXHQyWJ18ixQTQpntYC38P4LKlUeQNfMPQdBcVu+LLs4NguIJvEJFU
	 myI3xQi5M5nv0hJKsabMPKtVFlzfzqEFwT3cfJLEPCth0zwHOe/TUWNu2lS/G798AhUGc
	 smcvyny7lbPQykzJhVMofesAcAMC35REjd1NnbMvPtfaZPoy10XSZp87vNP+NofN47bvt
	 AULhH3hN4jGSiYpb3uX8DgeKg+g2M2+5vuR+9MC2TJcC++k8JJEqLo33FOXkPTz5gc0Dd
	 L8ReRTBYcPhWopHLij2kxpKDQbY9WHg9E1m1ShP3DG2DyU4fyX78CTUiIs1HkUkLHSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032968;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ajLEohxiGQw4HFZ88OZj7oXp+FeqYpSUtAIHm4SIjLE=;
	b=hM/Ol9xYXHhjoW4QqVARN+DraX0+gQ0frwioC+A4jDSyNFKdHDkmIWr6xunWv0gsO5Ca
	 CvnA4YIqy0qijErZt/enjBXyusG5gx7/+QTaWbMz1YLHrUBXtFtHF6jD8/4wrO5Ywdj4i
	 /e1qFoutgV+PGEIrrlOVtSEWQHy1H65BFNQTz1kYyHHz+6o4+sTHjzRehvIgbGBIH8k/x
	 lK6E5XrjRruwLQDzc6B6aJJAp9PO7kRtgbxYROjPHAUGCrL1SDId/nZrl4mcK5oDBKgKn
	 MX1LWpGHMLKofOZsU0Gbs8J41irRJ7feZ4qV1h1wBOd0Jn5YBycHlyEVH1rgCq75R9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VMFn4pM7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31CCE606A31C;
	Wed, 18 Nov 2026 20:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VMFn4pM7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C98E1F000C4;
	Wed, 18 Nov 2026 20:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032968;
	bh=ajLEohxiGQw4HFZ88OZj7oXp+FeqYpSUtAIHm4SIjLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VMFn4pM7/i/5BRdCOaM3Fqp9FKJEripLsYYZUWmPo4tXAx98xSPKSXbzsSSGQr4rx
	 8gaK/comryDpzDPVknJwRr8Cm2+0CB6dwrIGcSzjZ8vd/dra2VO7zarlrOBpDABbj0
	 3HA883jAOordDNTHU8JA0WisH1NHVCOEfsCIOdn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sally Marcher <me@gry.sh>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1598/1756] ALSA: usb-audio: Add correct datainterval in the quirks-table for Microbook II
Date: Wed, 18 Nov 2026 16:02:05 +0100
Message-ID: <20261118150113.525602512@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 5dcbd85a25112..9e7f29d099818 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -2753,6 +2753,7 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 					.rates = SNDRV_PCM_RATE_96000,
 					.ep_attr = USB_ENDPOINT_XFER_ISOC |
 						   USB_ENDPOINT_SYNC_ASYNC,
+					.datainterval = 1,
 					.rate_min = 96000,
 					.rate_max = 96000,
 					.nr_rates = 1,
@@ -2775,6 +2776,7 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 					.rates = SNDRV_PCM_RATE_96000,
 					.ep_attr = USB_ENDPOINT_XFER_ISOC |
 						   USB_ENDPOINT_SYNC_ASYNC,
+					.datainterval = 1,
 					.rate_min = 96000,
 					.rate_max = 96000,
 					.nr_rates = 1,
-- 
2.53.0




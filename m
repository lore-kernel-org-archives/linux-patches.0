Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773773;
	b=aKX9LBzvVZnJNxZrIQU3izNSlX/yQgS1t9eh/UH3le/aqUfRz6RK0YK+RfydfVmsyOzD
	 EMpnIGd6OmUwDTz5pU1KwdHGCq3poPOVWBjcUz+KQFUBd/ghJQGH3NUt74QXPZeBrWC5x
	 5vEDBXOz69B1El9WnFKlPzp8QYGpyuqRP4OLInIxhRVOUvWX8Bc7JefxBEQULvU89Duuw
	 T/3eNJm9lzoykHELOPNFM3JMAMobSStWfMxg5MrPlOlU374S4BElIfsMQVIft7mVbLIat
	 mRXBBcwk8RhKhmq4xFd+pLvfGwmLmwxUGlRi0/6LpXiT+KHNkkAqFcBgUCT0zURa2HQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773773;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2K6yB267avJDagWuAQXhz3x8OwPVfZF8oEbBOe3LW5g=;
	b=0h9X/YZY9vw/KUhFPBWOuyFpFZq/4FLpAqpWOyEi/+DWmZY/FzTFKmQfCw8AgV8agSTM
	 JLhrrzuyy5ojSWnA0JrHE6FXBSbpZcFx6aLmUkhHOXltadeSVRxW1XCmMAIHj7/16b9Ym
	 J/oG7KZfjLZ7hWGgWMSEUaQMIU0yVY+Rr6HsyUoC/Snd7qbbtUauqwoFTO+c8V+nAsZza
	 1t71O+rlV9e8VzLMjAEu2o6PsI+cvvj7ijcb1zf9pmAZHMbge7YGZQa0uifB0D+5OAqWG
	 opxflT5/dyEu6cEllxR1uXXCdAj5m2VkxO0MSHSj4jIugKD977RqD0WL8O6kzMZXMBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mlM8rbyz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6738606A31B;
	Fri, 23 Oct 2026 16:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mlM8rbyz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C242F1F01828;
	Fri, 23 Oct 2026 16:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792773772;
	bh=2K6yB267avJDagWuAQXhz3x8OwPVfZF8oEbBOe3LW5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mlM8rbyzJY7Qk62BtqLqVm7lWNNRmqcMn/UcgFFph29hcH+yK7HrKCh9Jjxs+4b7T
	 LKXPgqp8XCmuU8odPRya7B9ywlMlAsHZdO64MjvLq5KFO1z+3f0v2R1gecuKuXgCFg
	 wXUKbVAvh1xM0+axBMPMu4k433J5UX4kEgUByK9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harin Lee <me@harin.net>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 003/193] ALSA: ctxfi: Rename SPDIFI1 to SPDIFI_BAY
Date: Fri, 23 Oct 2026 18:34:40 +0200
Message-ID: <20261023163714.284317396@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harin Lee <me@harin.net>

[ Upstream commit c6cd83cceec5f2a1e2dd319d98640b1f0007d668 ]

Rename the SPDIFI1 enum value to SPDIFI_BAY to better reflect its
purpose as the S/PDIF input on the internal drive bay, as opposed to
the S/PDIF input via Flexijack or optical (SPDIFIO; not SPDIFI-zero).

Signed-off-by: Harin Lee <me@harin.net>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260401090159.2404387-2-me@harin.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/ctxfi/ctatc.c  | 4 ++--
 sound/pci/ctxfi/ctdaio.c | 6 +++---
 sound/pci/ctxfi/ctdaio.h | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/sound/pci/ctxfi/ctatc.c b/sound/pci/ctxfi/ctatc.c
index 79dc4aed736cd..5f2eef00009c5 100644
--- a/sound/pci/ctxfi/ctatc.c
+++ b/sound/pci/ctxfi/ctatc.c
@@ -1401,10 +1401,10 @@ static int atc_get_resources(struct ct_atc *atc)
 	daio_mgr = (struct daio_mgr *)atc->rsc_mgrs[DAIO];
 	da_desc.msr = atc->msr;
 	for (i = 0; i < NUM_DAIOTYP; i++) {
-		if (((i == MIC) && !cap.dedicated_mic) || i == SPDIFI1)
+		if (((i == MIC) && !cap.dedicated_mic) || i == SPDIFI_BAY)
 			continue;
 		if (atc->model == CTSB073X && i == SPDIFIO)
-			da_desc.type = SPDIFI1;
+			da_desc.type = SPDIFI_BAY;
 		else
 			da_desc.type = i;
 		da_desc.output = i < LINEIM;
diff --git a/sound/pci/ctxfi/ctdaio.c b/sound/pci/ctxfi/ctdaio.c
index fe40fcee36739..55d9c5c3d9bd3 100644
--- a/sound/pci/ctxfi/ctdaio.c
+++ b/sound/pci/ctxfi/ctdaio.c
@@ -35,7 +35,7 @@ static const struct daio_rsc_idx idx_20k1[NUM_DAIOTYP] = {
 	[LINEIM] = {.left = 0x1b5, .right = 0x1bd},
 	[SPDIFOO] = {.left = 0x20, .right = 0x21},
 	[SPDIFIO] = {.left = 0x15, .right = 0x1d},
-	[SPDIFI1] = {.left = 0x95, .right = 0x9d},
+	[SPDIFI_BAY] = {.left = 0x95, .right = 0x9d},
 };
 
 static const struct daio_rsc_idx idx_20k2[NUM_DAIOTYP] = {
@@ -105,7 +105,7 @@ static int daio_device_index(enum DAIOTYP type, struct hw *hw)
 		switch (type) {
 		case SPDIFOO:	return 0;
 		case SPDIFIO:	return 0;
-		case SPDIFI1:	return 1;
+		case SPDIFI_BAY:	return 1;
 		case LINEO1:	return 4;
 		case LINEO2:	return 7;
 		case LINEO3:	return 5;
@@ -119,7 +119,7 @@ static int daio_device_index(enum DAIOTYP type, struct hw *hw)
 		switch (type) {
 		case SPDIFOO:	return 0;
 		case SPDIFIO:	return 0;
-		case SPDIFI1:	return 1;
+		case SPDIFI_BAY:	return 1;
 		case LINEO1:	return 4;
 		case LINEO2:	return 7;
 		case LINEO3:	return 5;
diff --git a/sound/pci/ctxfi/ctdaio.h b/sound/pci/ctxfi/ctdaio.h
index b337da2de8b50..cc2e93a3edda9 100644
--- a/sound/pci/ctxfi/ctdaio.h
+++ b/sound/pci/ctxfi/ctdaio.h
@@ -31,7 +31,7 @@ enum DAIOTYP {
 	LINEIM,
 	SPDIFIO,	/* S/PDIF In (Flexijack/Optical) on the card */
 	MIC,		/* Dedicated mic on Titanium HD */
-	SPDIFI1,	/* S/PDIF In on internal Drive Bay */
+	SPDIFI_BAY,	/* S/PDIF In on internal drive bay */
 	NUM_DAIOTYP
 };
 
-- 
2.53.0




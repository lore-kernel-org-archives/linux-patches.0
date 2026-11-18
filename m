Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020073;
	b=kiWj8/mDDVehBXzL2aHRmWu58Kz2Ei/5st7lslp/aorFGdEZcrDhHX3vR5twKOLG6edI
	 5cvfXY/Ar0YqjVBd9GWBcjUcTN967k+cLCIFenUr+bI4bvT7qtb5cjyKrNuqkmcDag2cr
	 kxg9iA0PtII0CwtyAa/4wVKohrU13dCB0ARUTE+z2F7GpNWQ/KDT4y/jdGNPkyKbS1AUM
	 j/BMgz/1albP8HKgUc34LDvF1Q/FYtOdA7K4aiS+ilq6cKwrghFvd1xywe/4Pf9lJnEqx
	 VD+ZrSWhEOhhX6RIIRF/9OmtQiZLZCaj0L//nEgWmHJp8mQv97ZB+1ixD8l/rJxM+lg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020073;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bs1puzf81asd9175JMnN9Ea2HaafFJFQDgGneZjpHTY=;
	b=xBy4Cj/d3uWEDdN7QGv489s06t9M92NXaNVUNkJmn27RR3nnSQtw7V5Ktmmg5UT5/Jpp
	 dTlfx0vylBKHxqQE22QE4GvtBxUwApGc41zTzIbvVaSXWB90Xswyd5cLZ2cXx5MNan6Ft
	 x2D/YCf4S1vwCEYQLxl0F7sFYClQtAYBp3Eongl9DfRS7w2LT3W2eL/8DI4XrrzIV0nzn
	 nk75aTMKPI5cHeVsdYxqCLhoqf+fO5b70O3NM1Bv/jMIohLThGd5up2Yp6+sgsnGdG2cm
	 TODPqcTIOKnXFgL8fmWwVSrbEg21H27pGc349RNaMN+AJ5MYp2uR0i4bkt/Ufl0+zQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dhn9Ot8e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D29606A31C;
	Wed, 18 Nov 2026 16:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dhn9Ot8e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBC791F000C6;
	Wed, 18 Nov 2026 16:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020073;
	bh=bs1puzf81asd9175JMnN9Ea2HaafFJFQDgGneZjpHTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dhn9Ot8eP0kHBTOgDYUFy1cl/0wkWV/x9SudmdRIa8OgjJOUEyr/1an0KTNmHi8rl
	 mS543BI9ZFbVOKKJgFLF4zt9ZOCcp+yXcIzKVuxeRvLW6d/2s8xdUDiM2q176gEnv8
	 gHYl+xtGVgniupJwwcnWl6S2ulgK7XCi5R4jiHHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1821/2651] ALSA: line6: Use kzalloc() for PCM buffer allocation
Date: Wed, 18 Nov 2026 15:51:01 +0100
Message-ID: <20261118150352.737642308@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 9ec633573c1d162bfc82cae52d14c220c875612f ]

LINE6 driver allocates the PCM buffer via kmalloc(), and this might
leave some bytes uninitialized that are out of the actual ring buffer
size, while it's still exposed via mmap.

For avoiding the leak of the uninitialized kernel memory, simply
replace it with kzalloc().

Fixes: 705ececd1c60 ("Staging: add line6 usb driver")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://patch.msgid.link/20261013120528.52586-5-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/line6/pcm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/usb/line6/pcm.c b/sound/usb/line6/pcm.c
index f30d82cc0fc1b..d17baf7761c67 100644
--- a/sound/usb/line6/pcm.c
+++ b/sound/usb/line6/pcm.c
@@ -155,7 +155,7 @@ static int line6_buffer_acquire(struct snd_line6_pcm *line6pcm,
 	/* Invoked multiple times in a row so allocate once only */
 	if (!test_and_set_bit(type, &pstr->opened) && !pstr->buffer) {
 		pstr->buffer =
-			kmalloc(array3_size(line6pcm->line6->iso_buffers,
+			kzalloc(array3_size(line6pcm->line6->iso_buffers,
 					    LINE6_ISO_PACKETS, pkt_size),
 				GFP_KERNEL);
 		if (!pstr->buffer)
-- 
2.53.0




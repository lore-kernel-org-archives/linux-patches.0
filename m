Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061434;
	b=gtOgEXuozgJBgvbhyBw9Kj/LB0uRswE7Ry2XciQO4ltaTywaKqqbxZRleGDcVA0F5EW+
	 yddodVluDa95m6wrJDZXGze5NnuAj88gVzJAmWfxe/69Fr1N99haizPNQAgpekKZKXAVZ
	 3B4ZqLkwcaWzFn5o9spgNajNMlPfj3eYPqP0H4g2oLBLyUQxf670srwqhpWCbqKXonx6I
	 RlNRtICSFypX1yoh+6gF12QGj5BFweaaNxEale7Blnr4BI7ZOe8EwYFajNcj7nMJfCJkA
	 uW23bP1wkIPPQpYDYIhSXhb2RfhGcH7simBUhO/AnuXhZjFI0Ropvi9+yw9mqGU3xrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061434;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BlTJmDTvKJ0+r8Oec3nmyg8W2QADys4MtKR6Tr8Dy3w=;
	b=gWuI0epX/pyXSbc8jOnn0+9NLqp+J4gZoT1VMxwRDlHI7n0wgB0G3PA+fU+5Uzt9B6I5
	 2CsH8tO9eXBl0KTRrMrSt1kp5cC0fE6VkednSZibhM/vOi6Las/KmxfqGL3qlpifO5l2F
	 0Owaq+klz/cmIzyaYDqxqzAyahPUT9UbT+uM/qjmPa5vsR2r/19Wd2QctTKnKQcu+XYte
	 jxMYdHydUXnXVIscCbD7VyO9bR4C/lJ+KLrS1trPqWplB+x4foCbQmvRKyZOvGOuZPZw4
	 KKiJOmUSW3b6X/cyHxTzFv9e56rVs7crqV7d2Fe5q1uEdzO7f/6fjdnz3zpz9bRLLeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Seg6isXf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB671606A330;
	Thu, 19 Nov 2026 04:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Seg6isXf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 196751F000C4;
	Thu, 19 Nov 2026 04:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061434;
	bh=BlTJmDTvKJ0+r8Oec3nmyg8W2QADys4MtKR6Tr8Dy3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Seg6isXfQ8XmJ/rADh4LDGOwQaMv1pHsnwctT3J9wk1tp23ZiDaTGjE0QhMhnjIwv
	 2ePaCyJ4GhFoJ42ZDNi6j1IgLKOYvjCaoLOa9thpeak5qCrp5d+sPebXSLbTzHwIKx
	 SkjMSSoyZrRCpBCw+A7ilS2C4F5Zc656p55zblmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1549/1848] ALSA: line6: Reject too small max packet sizes
Date: Wed, 18 Nov 2026 15:59:47 +0100
Message-ID: <20261118150024.475268323@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit e2ef553dfe923959632e580bcad8583d922868ac ]

Although the LINE6 driver has a sanity check for the given max packet
sizes, it still has an implicit requirement of the minimal size being
bytes-per-frame; e.g. the impulse test signal assuming the fixed size,
and when a too small size is specified by a malformed USB descriptor,
this may lead to an OOB access.

Change the sanity check conditions to reject too small max packet
sizes for avoiding the scenario above.

Fixes: 3450121997ce ("ALSA: line6: Fix write on zero-sized buffer")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://patch.msgid.link/20261008192553.300025-10-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/line6/pcm.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/sound/usb/line6/pcm.c b/sound/usb/line6/pcm.c
index 7325482dcaebb..59b7c6beef6c5 100644
--- a/sound/usb/line6/pcm.c
+++ b/sound/usb/line6/pcm.c
@@ -564,7 +564,11 @@ int line6_init_pcm(struct usb_line6 *line6,
 	line6pcm->max_packet_size_out =
 		usb_maxpacket(line6->usbdev,
 			usb_sndisocpipe(line6->usbdev, ep_write));
-	if (!line6pcm->max_packet_size_in || !line6pcm->max_packet_size_out) {
+	/* reject max packet sizes smaller than bytes-per-frame;
+	 * (the magic number 6 is taken from the playback case)
+	 */
+	if (line6pcm->max_packet_size_in < 6 ||
+	    line6pcm->max_packet_size_out < 6) {
 		dev_err(line6pcm->line6->ifcdev,
 			"cannot get proper max packet size\n");
 		return -EINVAL;
-- 
2.53.0




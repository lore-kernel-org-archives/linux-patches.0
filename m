Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026021;
	b=0ykoESJeEuuiUhog9AJd+M9UBCVgWlyuy1atT7LG8NsVLU44TWrNtzI/KBcM0ZnWTLNM
	 DVqpcDJjnVO5yLz/W70FJIoos0fpHmtIopBFgbIXRV/mdWcIkVnDxVAg365ybIB2UaF+4
	 KbNpGGKj7j2xNsYDSLkLgE7qyucQgGZf2xAQXNWyLmkwNa2yV9knulLptTNFza1/grwM/
	 Jr+bR8S1SN4Ql0uNTcnNbMEqJneq7nWdQm0xHTtskJgYPz4kQdDavpmb4znIPPfGy34E+
	 q7QhifsqoTeJEyp2BWU+UfmNUMiE7gnD05/Us9Rt/sra+VGhWTqKly5VfkzwMVW2T+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026021;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rYWyvKVSgG23dIjeot8qM+96jfnqtOiHgZVe5TaAhNs=;
	b=RFwH5IpBKYGDj13yeyC8hCtCIih8/u+Z4N1Qi0gtQWYh62MmNjCW/d48t+XCJsSSNPG1
	 UfCOCmTir7Y2gQ91+eTYZkJ9Ap7GWJ7WCSiCLhmpWbm/G3BGhbAGFWdPSqMR3fUiUzReX
	 IGwNKKOkhCH8VtC8LnDs1xWoOlpCST59ouTdIE9ZzqpHK3pvliHI3JOIjInwvYwEb03mp
	 hy8CGzKZfat7mW62UyKiG4scgphfpFYmyhNQo8tGnZeV47385jKXFVM7xJOm8VTF2B4kn
	 aznPdpPd4h0G191h79ze5gS79Xn0XbCXZ6UXzyrusxkm+U1aMDipKlk+KamJrTM4GOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xcpyokLQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63754606A31C;
	Wed, 18 Nov 2026 18:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xcpyokLQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA3851F000C5;
	Wed, 18 Nov 2026 18:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026021;
	bh=rYWyvKVSgG23dIjeot8qM+96jfnqtOiHgZVe5TaAhNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xcpyokLQkXeA3l/WNBh4hU729+WvEM+FjnvLFPYYf2nSzQ18zBKDzTURTdReQiQ1I
	 PwDNDP74RCjWLC3JOGd0T1gH07veFErc0fiJyjum+hwhYDZNP+ltzyV+92Lubid7z1
	 hbXgNOvNUmjPIf/NOCJx/itg3gEz7jhBDmsxPq54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1284/2151] ALSA: line6: Reject too small max packet sizes
Date: Wed, 18 Nov 2026 15:50:19 +0100
Message-ID: <20261118150208.913570109@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 8f4b47b6b7190..f46e20ba58435 100644
--- a/sound/usb/line6/pcm.c
+++ b/sound/usb/line6/pcm.c
@@ -562,7 +562,11 @@ int line6_init_pcm(struct usb_line6 *line6,
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




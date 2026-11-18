Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055973;
	b=drJlgunZn3SELfdZNsxUeqADsidZvKHuiS4s15u474dZHPVKopI4ZgZ9QC2anJggg29E
	 ExIXAw+hGpd7+rKS2jHCi7Pw51mUetJ2QeZV5mOyHrRxqtbeqb554OYMbToc7F+SfYsie
	 DslTeXfTzz7LVw7aloTSGhlPvfbHP9h0top95oa8hQaIaspIK6kPVIf7gQcxapto7Kj1z
	 1j0cCZllE7I4keUEPHyuxMJGuvGEEs/ZI2xd4kwX4ZkCZ3TcU67ShHocsz6Vz2XhyIwic
	 NFcmOoHhMJc+A+Dk1e9acoBA6GWFGRKnxJyUxWLcgdTB0VrJlLvGSHJs7N/qU6NCKiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055973;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h7tDqggmQ+FK6QWBcH3ss7U0zAQnClKhtKueabWIwV4=;
	b=QIVc3BheR5jU8kG1Yn/FHZ6K7JCIYR1rZRWQ/V56LOJ1hZd2wlhTZMGZ+/33qETK37hD
	 AvFl1G7mwaNRUzBxy0/qbLE+yH7yycScFgOBfLNg1vei+dvACBPfTzKr6SaZulrX19wmm
	 c6nTcUtQzW7n8UwR7p4yE9raFVXhAj8tacZoOXD2R8FB2mzxeyD9GnKZ/QFkBMPiy/VRr
	 C941FE3dL5JR25Y/La2TeHSrJGhdRfcWEFv7JIEu28zJKFkw8rc/dg0kgg78vFsUDvr+L
	 J7Rn9EWdHFmz2EWlYD4q4pk5nkyawPIioBE0xO/25VBnqlHvfA6mNAzNflIEZ532P5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GBndupEL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF697606A31C;
	Thu, 19 Nov 2026 02:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GBndupEL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D63051F000C4;
	Thu, 19 Nov 2026 02:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055973;
	bh=h7tDqggmQ+FK6QWBcH3ss7U0zAQnClKhtKueabWIwV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GBndupELuI5I1WnGWd7tuUP0v/ro1hRAzkajj/RzT+6UqbA5X0XlbRcNHzKU6xGpB
	 tKjO1v/GwGyRSo140jpU+OHPYhQebgbqJ+zUkXekk4z+GpbCgSFYsOBzfeOSaqzFp1
	 YV5OPjwDAG91HwPM6q4rkGr0jLLsk4Gk7fmvzoeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1823/2214] ALSA: line6: Reject too small max packet sizes
Date: Wed, 18 Nov 2026 15:58:19 +0100
Message-ID: <20261118150124.384134990@linuxfoundation.org>
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




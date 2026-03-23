Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFB083B0ADD;
	Mon, 23 Mar 2026 14:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275172; cv=none; b=aAAPLWQUnImfm+uopsMbV/89yGO7wWA7r4gXjU8z5hsbqroGpBprUDgljdbvG8T1KDIRiXpgXUgJzhjh/84PUlZJjov+ZLyyzGAiQ+eN2i+h/Vch1JxbSpCl67+gMjCRczhD0g+J4jt2RkRJ8q2aTHy2cMPhjdkxFGkdH+ryizY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275172; c=relaxed/simple;
	bh=TzlsoUXW2C6ystWlxtS3vq7dZAJIp0dLQd+PQrbZjXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hE0zb6l3US/imny/5kJn+THwL8KEo45MXvNIv9ecg0/dX1bkfDzc3xuXWNHBZ4tkhgHrV5op6ShWn6cUNsz4+EynYtFp2diicnP1Iu7r2y8tJakJTjZVHp+T69h85nw7jxCuiKnKhV+QlgizaKg29vI/qCbZ7P7dEhskcqJ1QcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zVPtFSuh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zVPtFSuh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 435F0C4CEF7;
	Mon, 23 Mar 2026 14:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275172;
	bh=TzlsoUXW2C6ystWlxtS3vq7dZAJIp0dLQd+PQrbZjXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zVPtFSuhMnBU38zytjx9Yq7Vw+Q1hQCpOg0YKLoALa9tvb1vxH9ZXgbBUrRI08lCz
	 m3IMliMt9TdYqDjBoLaGm0ldmEDhyBy9Lp30yt2Rb68kL9aqGSwKNBAjdhq30FINrI
	 DUQ5fIUKrtTfsUK4ux++sHvN42vlIBIm53DDZjjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 011/481] ALSA: usb-audio: Use inclusive terms
Date: Mon, 23 Mar 2026 14:39:53 +0100
Message-ID: <20260323134525.527808972@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 4e9113c533acee2ba1f72fd68ee6ecd36b64484e ]

Replace the remaining with inclusive terms; it's only this function
name we overlooked at the previous conversion.

Fixes: 53837b4ac2bd ("ALSA: usb-audio: Replace slave/master terms")
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260225085233.316306-5-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/endpoint.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/usb/endpoint.c b/sound/usb/endpoint.c
index 8f486c5c938f2..b5af8dc1e48de 100644
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -160,8 +160,8 @@ int snd_usb_endpoint_implicit_feedback_sink(struct snd_usb_endpoint *ep)
  * This won't be used for implicit feedback which takes the packet size
  * returned from the sync source
  */
-static int slave_next_packet_size(struct snd_usb_endpoint *ep,
-				  unsigned int avail)
+static int synced_next_packet_size(struct snd_usb_endpoint *ep,
+				   unsigned int avail)
 {
 	unsigned long flags;
 	unsigned int phase;
@@ -230,7 +230,7 @@ int snd_usb_endpoint_next_packet_size(struct snd_usb_endpoint *ep,
 	}
 
 	if (ep->sync_source)
-		return slave_next_packet_size(ep, avail);
+		return synced_next_packet_size(ep, avail);
 	else
 		return next_packet_size(ep, avail);
 }
-- 
2.51.0




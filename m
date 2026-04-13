Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA3027280A;
	Mon, 13 Apr 2026 16:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097141; cv=none; b=qiw1QE3TpwQe7OnTMIIHpO+xDSY2Ws47gA5ha45CZckeVPYseXLEPo4YYgGQ8nJZSAo3qoLa1C8rUksCIc58RH+KkYGb8K7c2Imke6hYro+5XoEoLE1PzWBEH3/v/LvT3kdgZjVfFbesptnecr6b4nBW1bXvpaZA18ireQt8rbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097141; c=relaxed/simple;
	bh=KiGjngqI0X3eh2dUWAJ+uDuFXzj57rrBaLjCeyOv3LM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h4p9Cw5bowRzukjApiIdAZnvs3xe7mJTE3RHS2HxCH+MqqeE9C9yPcDlBQPr0iVerAQZ7rwQ0ZBwzKOAHhg0qo1MLFInmsAmsII7eQwHVfoSeYvVG7ML927DIatNoYOG6WMh+VXHY1GhVYYcvTWe1mUjgpzw65hhoRWJsRGVbXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pOHbmOss; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pOHbmOss"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99A0EC2BCAF;
	Mon, 13 Apr 2026 16:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097140;
	bh=KiGjngqI0X3eh2dUWAJ+uDuFXzj57rrBaLjCeyOv3LM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pOHbmOssccj0T3s5wHWVFYpHK8QEHzZTJYCXPxyrkXlAtk039MXZRm+ESvfz66O/Z
	 1/c4k3iSYqLtNqF+X/Fbo0mvAueP7jF2Uc5+OoqfKxeqhOyYc5T1CWGrxJVVzLpijL
	 hoh8yp0yrBCYFtjky7KHYHbNEuNuZoNtqrH2Dw9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 009/570] ALSA: usb-audio: Use inclusive terms
Date: Mon, 13 Apr 2026 17:52:20 +0200
Message-ID: <20260413155830.748031368@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a861915e07f3b..6ba99ff2cefcf 100644
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -159,8 +159,8 @@ int snd_usb_endpoint_implicit_feedback_sink(struct snd_usb_endpoint *ep)
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
@@ -229,7 +229,7 @@ int snd_usb_endpoint_next_packet_size(struct snd_usb_endpoint *ep,
 	}
 
 	if (ep->sync_source)
-		return slave_next_packet_size(ep, avail);
+		return synced_next_packet_size(ep, avail);
 	else
 		return next_packet_size(ep, avail);
 }
-- 
2.51.0




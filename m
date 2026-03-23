Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C1663B19CD;
	Mon, 23 Mar 2026 14:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275201; cv=none; b=QSFVRnPvBGbXCq55cgvaQEyuFpTOapPscVZoGCWZrhBoDemNJraYMDhX4FcGjfbvVqP63WADatwr5s4+Z9+vFQ1ZidAzItISPraWO0V92TFjLQgJzd/OccS6kPlmGZeTkSl4hDvnvPGE+U/KRQvL10/mBjuvcW+mOdGR8CrlHuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275201; c=relaxed/simple;
	bh=Ixnh3lCdv9+50M4EWU1/BwvMdTFp/Bh9d305QOmj75k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WUEc/ABfRYs5k2caK7/fwFK986oRwP+HQZxBy2DT2CNqleIfK5YOag0ppjiyFT43IyL1hQ6JcDzSMCW5Vy7n37GZJN3uB8WAso4sP/IcvBS0B7SrnOJd2VKOGbC4XZBwJsiZyBZsNPr95jwcjEN/z26b5+os4WAnatfvnFu+9Mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SeTw+eLE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SeTw+eLE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AFC5C2BCB6;
	Mon, 23 Mar 2026 14:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275201;
	bh=Ixnh3lCdv9+50M4EWU1/BwvMdTFp/Bh9d305QOmj75k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SeTw+eLEGNLF5oBFtr0RSiofB9az++/6gFaptdmXcWx/EfLaQqpZiObTA2JIeNr40
	 N5zWko7hy7T2bMldvk0aKcQLyUY3JP6i44z0ApIf7svM/SyH6DhEivU7Y+Pe2CKsq2
	 CfxnfDjXxOs6oJEVIzBzF3nVJVF9n5wkY0Cxv8O0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 011/567] ALSA: usb-audio: Use inclusive terms
Date: Mon, 23 Mar 2026 14:38:51 +0100
Message-ID: <20260323134534.038633265@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d035b25f67b64..806755a65fc05 100644
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




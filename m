Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB5C640242E;
	Thu, 12 Mar 2026 20:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346474; cv=none; b=dfC+hHKnOynzS7CoRv2BxK/ZGwrCNZsxoYSlFgqJs3eLdgRJMxbQod83Z9aIsOoy7OWkFZ8SqMqRY1nZJjiU7LdWMoWX52LRYnMVPJpr9JI1ZN0Ze7Zqj/uj6TpuOSCw2MLRz3dLXn74nuq44H+ikXC8FICeQF8znJOBDHk4mo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346474; c=relaxed/simple;
	bh=7y1F11DABD3IM1+e5unJxhvLmSON1bq6LMz7AypSe0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sQltV+yAFo11DZ8PCsGEmNVPKSk9sbgoho2ZTiMLBCia8TOaShFJMxhOC9kQsejaForX2tuvaVTY/XrPTpYBXOO3n2+nmwVZp2Vj2JTg0j58/VVFYJMYDoqV3YGm6FOVxmlpThY6cYLdNJS7By+Pt+SjH9VZX8j+GmqvBmBj7AE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mgdpzy2/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mgdpzy2/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D973C4CEF7;
	Thu, 12 Mar 2026 20:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346474;
	bh=7y1F11DABD3IM1+e5unJxhvLmSON1bq6LMz7AypSe0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mgdpzy2/VT06rIjFkxwsGJTz8zCBoKAPeYgoS+7XtJSaH+us53kL88lhvjX+l9tl9
	 Kw7OHMdXs2dl4mvYni4tB1BeG/CQEvVUZq5uVwe/0CTDLuNe5dRAGkJUwPBtwvIA7k
	 8o0OfqQiWTFzOPuXTFy1+SWN8nMsHi/6F7M6iS6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 019/265] ALSA: usb-audio: Use inclusive terms
Date: Thu, 12 Mar 2026 21:06:46 +0100
Message-ID: <20260312201018.873743466@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 729d86fffab4c..9d22613f71e24 100644
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




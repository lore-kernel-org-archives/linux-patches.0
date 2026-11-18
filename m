Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018901;
	b=vp+SnC8oNtP1mWHfgPkVZW+cl45mGE8EMXYOtBvuqS6xnt85SanhFKjKti/Gl/xPrhkL
	 TRRKuJkjocSUdv7fGpndX7pLISPNcqfJLXDrJ891PR4/FT/3spMwjRult3lJ9kDt0rg0Y
	 tEUK8wvWcwvd//W402miuDQhCvOe8VhkWYrBOUtJxbcg+Sbbgv26sTnRb9m2ThoTBAyBX
	 Snum4FskN1+oBPhkaJAjOzvrvaioJRX1V4FC3UFVA2askmFyYyoj1tiuT6ScbYZnLa9xn
	 c7HTdrGJU3bs5GUIFqMp9pF9leyM+yPB2IJWO0SglV/tZFtJpXXrKq7iVgEeJm89GQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018901;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w4bk3mYX23h02xF/jGxDPqoWyH8pWxXEk/bVHVQx5EI=;
	b=E0dIhg5giECa8E7kxkOrv8KVxRS5GEqDNB2VddWS4kZSWTMZZTVTUzBCeopDTzYwLG8V
	 E04DBvsSxUEcY96CqW40bnfGAtSWd8darvXh8Gl8lwwxcn+J/GseTUL61Mj02sTHC3Is0
	 2KiAK4nF1jn+sl/9IA7rg+tRUdANFSNBGDB7nZzBkQMpMCIPMCsvfdfeuY8eCIRCOpWvQ
	 ow2mhTpQQk218lWl9JmoJWhbKx0p/J5uJRMMK0wYyjGbpdPV3vd/fqCkolLFdtNoBdRHq
	 8doQS6FYdyE2c1DAHy4wJQzmPSYacXw9ilS6qAaOn4GczofKJLjJ+m7kd7KGrtJeK1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l7nLFKqx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB7F4606A31C;
	Wed, 18 Nov 2026 16:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l7nLFKqx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25A3B1F000C4;
	Wed, 18 Nov 2026 16:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018901;
	bh=w4bk3mYX23h02xF/jGxDPqoWyH8pWxXEk/bVHVQx5EI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l7nLFKqxIwuFkRblElWzARqklCiWcmS6XNmA/dDJcWJu0/IwaUnFk/bGUh4zMCyD0
	 x4yb33DZoo+Qf+pyJCWzKGp0UBphFU1xuyYWv7T31dusEcPS7DG9XryHkPA2Md89uQ
	 bRqff5Uw/nm1hSOBZpDY0PJv2FvBA/t65BMDomM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1406/2651] ALSA: caiaq: Allow zero-length packet handling for EP1
Date: Wed, 18 Nov 2026 15:44:06 +0100
Message-ID: <20261118150338.631189433@linuxfoundation.org>
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

[ Upstream commit ccfe6ab672c020fca56988e634088bfb7764e2a7 ]

The recent fix to avoid OOB access for malformed packets added a
packet length check and returns immediately if it's too short.
However, this can be lead to a regression because the completion
handler doesn't resubmit the packet, while a zero-length packet itself
is valid, per se.

For addressing the potential regression above, change the handling for
a zero-length packet to just resubmit without processing the incoming
contents.

Fixes: aba30af07d4f ("ALSA: usb-audio: caiaq: validate EP1 reply lengths")
Link: https://patch.msgid.link/20261006134405.479603-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/caiaq/device.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/usb/caiaq/device.c b/sound/usb/caiaq/device.c
index e8619bb743581..993858d18b680 100644
--- a/sound/usb/caiaq/device.c
+++ b/sound/usb/caiaq/device.c
@@ -142,7 +142,7 @@ static void usb_ep1_command_reply_dispatch (struct urb* urb)
 		return;
 	}
 	if (urb->actual_length < 1)
-		return;
+		goto resubmit;
 
 	payload_len = urb->actual_length - 1;
 
@@ -192,6 +192,7 @@ static void usb_ep1_command_reply_dispatch (struct urb* urb)
 		break;
 	}
 
+ resubmit:
 	cdev->ep1_in_urb->actual_length = 0;
 	ret = usb_submit_urb(cdev->ep1_in_urb, GFP_ATOMIC);
 	if (ret < 0)
-- 
2.53.0




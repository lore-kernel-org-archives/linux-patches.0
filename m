Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049282;
	b=1Mt6IdktBUgaCQ2ZzF3cd4d8ni+MMyvL7rl2zIjmS9/VCZPG2jyzcZeVnrGBKeTNj1sw
	 rTMB9rBQK3o5bKy/HqCV9wbwY6aJNaE984Ao3UkD4Uvjz1eg2pPE4/CEHhWY6bi8oKXLF
	 mATlKOUNdLJu752trVS6sYWLCf6dYgrfNvfUmYFybZf3b0uaUsk1HtaCC367yJQLdkNFO
	 /urZ3Xov1a2MMQ6Hs8Oiok/JajJoRjEc2TF3VCMrOnEOZs+f4QRIi5zfclK0ri8+XIGLB
	 MA3Sz2sQ++cLr87C6ZSBkLxcuHl9w7D8sj6X76ihmc9VqyU7iYgANbizvufGX7eLXUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049282;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nOUBmdLF/pzNPjTwUu7yg4DF9tBwKD3AypX6tmY0aIE=;
	b=mo961O6pbBt4EB1WzOMguc3TRfNFUvYm2zqBvljSp+V5hJTUodYBMZeuaRYIxSSJgC+E
	 yIbc36PdaMEYBL7FqJd3Bbp2oE2PxdOQInzRr4mQJPnpnhIpyItu6C084sINZmqihRO/b
	 dErvVEDYbpN6xb4mt8CLBVq/zGwUbiyIh5LMyXnFUi6yqf85wCArL0LkBckv9QVRsDTYL
	 pF0G5mTrmlvYJtMAv5SJvLtqmRUc9fg62UImzPNsWJ3kIQw1oIO6digWCWwUg3gIcYLbl
	 lwa7lex9kz1kUQD2PudHslhELohgXcyB2efnpCs/Xzk3uWH7y411AAkRDNGFeF5iKpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l+knfzbE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A79E606A32A;
	Thu, 19 Nov 2026 00:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l+knfzbE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F05EB1F000C5;
	Thu, 19 Nov 2026 00:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049282;
	bh=nOUBmdLF/pzNPjTwUu7yg4DF9tBwKD3AypX6tmY0aIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l+knfzbEyKuNWQYapa9AXDzEmCJrBeAyJnrznx1h5ZImtbgYMX1nlbQKJytEHNB8v
	 bQ++kBUD9x5EkSb8RP6NZgQKR4k267mXFZXU1NT2THAkA99DkzltuIKX7gFNbEXd1I
	 CNlMu5hrZMHjnnTxAfDMifcJV1woKjDpYmkCabyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2296/2857] ALSA: caiaq: Allow zero-length packet handling for EP1
Date: Wed, 18 Nov 2026 15:55:30 +0100
Message-ID: <20261118150324.151325208@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 68eaf1deb8888..0f056d155a47b 100644
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




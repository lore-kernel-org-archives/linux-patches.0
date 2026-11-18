Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031118;
	b=1QSa7+mCR9rF11cUP9YpabxD50UliWdweCZ+u3i8T/oT5ACN5+l6l0tT/7VsI1SkFDFb
	 Jllwbh9+X3U/qdkEGOxTD0cQpuR6eUMRQPeiHyIhG+ncvHIX+9dB/oa3S2/LWYqscImaJ
	 e2416j3gIh9dINr17AUlSveLP9PBTDJVxZGA//5Bls+hult/SFkyokQW2K4SpKVYkRBkq
	 Y2IQhfpdgKVLl76p+Pg3lBVEdB/QRiEKX4eZlos/McqMnuQqHg67/xtdw2jMDvKi7WXvW
	 KNkMVsyoTzszdH/G9gCu3/42dAfp5W/qRHlU5HGoiK1z6e6iO1UnU6+xRQBu/CwAr5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031118;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0ptzLfgV+eWOoSOlovXfAcEACnM9Vxf4iGeUanuLUKM=;
	b=A30fdcxGjj4C2lQXwRSM1LLWw5uYZ15yJ/oQGeGMyR8/hhj6hBis/aGmMnQZQj1EVcik
	 9Vck/E97z3/baVf1jQA1iIut4nTrqRHFDvl2hldbKMnPFY97ipGADcst/uj7OskuH4FSY
	 qGZy2zsF8FBGjYtl732I51tbLLXOSzKvcQ243nWpqjAtELrOFnyfRly5F2jLyWcCqOhhb
	 xkOSO7bhWs5/lCPARwEM2rBDnILLVzBogVOSvzu/oKADVTAAdL3mQ7DXjyio4CKqRwbYG
	 mxTTUUeDLjZvpligpMxLUtGHUpRfTcPvs4KV2mmhTsAjPLmWq1wpATTG15fuzqibA/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NbQ3u4nZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2940606A338;
	Wed, 18 Nov 2026 19:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NbQ3u4nZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D97B21F000C5;
	Wed, 18 Nov 2026 19:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031118;
	bh=0ptzLfgV+eWOoSOlovXfAcEACnM9Vxf4iGeUanuLUKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NbQ3u4nZiDOZdbBapauDpe+K5s+A+sBfywdP4hqUIkgc2kKgxMv61aymJRXbJbMUQ
	 wlYMcjBT8591PpaST5SSqLxF/f0JB6rOwA2HbFeu1vj/MpKKWkfoYD/QEoJ02kCCKF
	 nrgopZUHpkLD4ZVkW+CTy+81CR6VkTRNwHhjCfCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0945/1756] ALSA: caiaq: Allow zero-length packet handling for EP1
Date: Wed, 18 Nov 2026 15:51:12 +0100
Message-ID: <20261118150047.690744297@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040984;
	b=0lUefcNZd1uqhi5TAgDqJj3/ls1ZN8vWA/0E/hgDI4gmU+NtLrwTpS9BwhI/tlYBXqRd
	 WcZdtC3Fwv3Ap1CZci6uyOUJfGimhdmGQ6lIXqVxVtyMIjkOEy692aBo76/5T6AbhrGNe
	 YGGJevVD01q2CP753glRPdDSHGlrhQrrEjj/Tt2QOcrsMemd9kJ4NDN4JzJF5UExpmM04
	 MNKsAxc8YHUE2pNWAC9oqzIYbH0QDAkkFlddPAiXDj839HRkFkWldFkn70UF4El1i307+
	 pGQXFgnIb83gyxFXEidXGBTp7kZu1y09a5nf7Wvn3+nlxIkkko1+kKOMn/s2Qw14Kog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040984;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iksYTY0DK5hKi7DGi25iwpbWwMIkGoy4cLzT56qaOxg=;
	b=WO3R1P+5BsGkQU4Na9nyeG8BUP3sM2pNsG2SehcwWby27JkKSEU+UxOFAcxPgiK34s/o
	 wDSb1clADH1p/V/lWScQnKJtte8FU2N1YGTPOw3OdrzgmDH1n0QSAkYotmsVr+WJ6wvnc
	 9HR9xL1/Ys+Z6v/7hNGMHrgMCTylJpROP+xlCXekppiwZBxusuk8I0d7rp6OtWRGJXY+N
	 saCfeEvShQy9Dmb4TcCVgQYbQGfbYBdvHihFi5EcLTTc4t/fq3/OQUoutmTvzf0mhurUc
	 6N4zzQUJnSpQFWYyrzwxTdtVTWxjjJGFU38LBqk+jtwVxl9aRBBRtROF0r3rZfxVVuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j5JfCnYb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EDEB606A325;
	Wed, 18 Nov 2026 22:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j5JfCnYb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F11C1F000C5;
	Wed, 18 Nov 2026 22:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040983;
	bh=iksYTY0DK5hKi7DGi25iwpbWwMIkGoy4cLzT56qaOxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j5JfCnYbO/FgEnEGaXZj8S0ImUoId2E6aq9HQaiLCoJXO9j1dPeGuaJJs4CpynWPK
	 3H8cDqyY9A24XilbvzCj78iSRyEicSZrKV0+er8S6+XJuxl6XuBBKSbfmcQknaJyr7
	 BJfYuu/kUw94fFwm/hXbT0fgiGonOtFsHvFEXWnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2651/3318] ALSA: caiaq: Allow zero-length packet handling for EP1
Date: Wed, 18 Nov 2026 15:54:33 +0100
Message-ID: <20261118150440.575153893@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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




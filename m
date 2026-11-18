Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055885;
	b=Y/h6oaqbhTxbYcPcQtEUJOFLje8UCz50TT5sjLN5TqZXbELNMn2R/uzD18hOdr+yQFFT
	 cb1MxJr34xMI1xBVKoQoXVnB4CHxK4vjvRcomh3qKn8vmPjdXhoq8g8c6J9LtjQtH5zrn
	 RcG632V1OotMYMcX2cjq4QZ0wPRz6/V1wjxPHFs1x21NHuH4aUWVIPNPtkGA9WEy6Jufr
	 MK6AUC1sPUue458Age48CwXTDlfaTsyPaI9Hakmf2H4YF1zc+oFdEc8OU0mvPUO+pEbFc
	 ZX+5XvSJ7nSUlm1Hv4S2qni4P4eI3VEasKmIJ5MU6htUYXExJZFc7GBrUpHdrRLLnwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055885;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ztOxYpMT+8Zvdi3WSySngYa8C+uvRooS04SATwJKvqQ=;
	b=DWbBQFt8E8rJBQFk+d60UOLd2CfmhN3yd3D6MInDB5ccT2jmT6lwswXEqhmNEfiVjpVU
	 2HhmmmLlq4tR1svX3WtHIGAmZr9JfHpQAA1nCfYyP2aYYHYh5HDQJ02KaAs7E7tuROPKc
	 YBgOnigoWg20md2Q7UlE60yez5XhKWK5HppwYRdu+6jSQsepA2mKq88iQGRtPCNOhmFF1
	 Ce3bDNaqGD0d1UsfPtm7CXBHcp01T59LTb2RrOoJog9X0dm+VAMKa3FjbGyYbRlXmAErz
	 0T25qw0fD31hhutvo73H8tAI5Uh3AfFtkb8HR3+7xUnxniDLYp0raAp9d3i3NWiUV5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nJZJuXPl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A0D606A32C;
	Thu, 19 Nov 2026 02:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nJZJuXPl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5684E1F000C4;
	Thu, 19 Nov 2026 02:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055884;
	bh=ztOxYpMT+8Zvdi3WSySngYa8C+uvRooS04SATwJKvqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nJZJuXPlzVz6CHLoIvo9wypLonWe9a/ySr+dlr9mH3XwGItt5o19leyzS9BcoSPwe
	 4yjQ/SOtpWWjaJG1AC2tJvII8wIHXTJs9W/xq2D0mSdlQpA6+vkMJY2+9GlT5cEW7m
	 gzklnpsbFWViHGI5YqDXZ9mrqF2QwXCUhwBCeVjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1791/2214] ALSA: caiaq: Allow zero-length packet handling for EP1
Date: Wed, 18 Nov 2026 15:57:47 +0100
Message-ID: <20261118150123.151420963@linuxfoundation.org>
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
index bc35c36148ac9..39b88f5fc481b 100644
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




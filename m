Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061355;
	b=HB6sCnXTUDcwwlr4kDfVbKDz0HorPoWsdumtpCw85x7sSrXZWBPmLt40hQx1j3y5kVF8
	 ME/Y8IEiUHE1tPLKzasLELqY5s7siwAj0ATnK00lD9pooF7gwM9DD8MyTRalmD4fX4Rzz
	 iJVvFJdWlJhflIFvbShSrdK75uJTp+RZaKduoZoUonHrACHYIHzS4VJQYtrAk26f0PBPl
	 V+d7gPt8Nw2dVcRU7Qeve9qUJYsFiQdgQy4ksCfiPtkfn2RR9pagmGsEyIQKLjsjHdnBj
	 RprA8PmSWQzXKt+ZRRgsM8DvT0QG0cliowQq+ayyPAik8Q/HxaEpDfLrfCXIB5dDQEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061355;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kmUko552ZbBebr1hlMqcIjj1DgvjjvFcSJGBVqV3Hh0=;
	b=m1yDdaWRw3LLbh8CpemJ0cVKci+sbdhpkuDBbXpy8RJcbrRY07sgy23jdrKej+ZotDVD
	 VdTOmcJbHtMPdnnCmKMbIOY7u8Pue3bTH4+hTlF3BB0MQwErweVV1nGQSYhs1hNJ9/bMZ
	 cGwx3BDAWv5aWZrYxc77DjqfgFndgDQ/vjlARsqeb0nti9ZWuiBfMTGgYks1sNy0StPAu
	 iuyFTlhpvPldmamsAwlLxHxcKNaHY+c7Z+kJZ1f6cK+TKW6ILBIE93s8A+x4rqfrc7rJ0
	 ja8EhZx5t15fU9zd0+F7nAImk+6q1L/yYzI2wyeeMKv4Bkf14+tji1MuQzZmsAHZXyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GpUyCGsB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 863A7606A325;
	Thu, 19 Nov 2026 04:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GpUyCGsB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD3121F000C5;
	Thu, 19 Nov 2026 04:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061355;
	bh=kmUko552ZbBebr1hlMqcIjj1DgvjjvFcSJGBVqV3Hh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GpUyCGsBeFvTH+bYBGBqSSt4KlUt3VuXzmxptanlXkVYvDtj3y/5ViRmDIKzpE8eU
	 2LheM10n594iCsujhvpup/KHw+CjY5XHDJhqEvV72ZpWXtAAOHueej95HaEKecw0yx
	 v54GBiWoCjVpS3fqwkTfQDYRj4+SMnwcI7FVKKG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1524/1848] ALSA: caiaq: Allow zero-length packet handling for EP1
Date: Wed, 18 Nov 2026 15:59:22 +0100
Message-ID: <20261118150023.177728576@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index ef5bf6936958a..cfcbd403a1720 100644
--- a/sound/usb/caiaq/device.c
+++ b/sound/usb/caiaq/device.c
@@ -156,7 +156,7 @@ static void usb_ep1_command_reply_dispatch (struct urb* urb)
 		return;
 	}
 	if (urb->actual_length < 1)
-		return;
+		goto resubmit;
 
 	payload_len = urb->actual_length - 1;
 
@@ -206,6 +206,7 @@ static void usb_ep1_command_reply_dispatch (struct urb* urb)
 		break;
 	}
 
+ resubmit:
 	cdev->ep1_in_urb->actual_length = 0;
 	ret = usb_submit_urb(cdev->ep1_in_urb, GFP_ATOMIC);
 	if (ret < 0)
-- 
2.53.0




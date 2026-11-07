Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064939;
	b=BMVldq6dAQ4JM/P3W9a1rjCuFBFeg7yu6oNYTqf0+qLy2sqhrB/9idtVRnU/83VgFooS
	 ExLw9VJYnG2F2jkZ2k70jW1iGZrvCjzMKFYB4HpAfdo0tPgHLaEyDp+pVWkgiONlg7sWH
	 2kB+4wSjFcinQzKd92gvF7SQim5uPxWpAaSk3gpkPuNAyh6qEURMzYJzy/F7u66LPaEMi
	 4rybblek1WGpMVk5TbA74glq9HGTV1yzfE1D1V0TkKStBcUFuQYm6yAJwGbbNBe5UZhPe
	 uxryQuiOu47usYP07TleLOX3LF9glwO31448LzHUeULv0E+64Ms1MjATZzFYdUUc13Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064939;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7Tst3MTUvrnQq0GFXqC+5PHkWTahIT0qdckqetOpdFI=;
	b=BrXcB1U5iJsLlBGYzQ73pv6qEGhO0yywzPjo16oLVneQbE2JutbYEa5xi9ZcTHA40ier
	 1Der/sRB/xZE3QkAqgEmxbR/ZuK5Ek0trfDdSu9y4Th24GWzQHmkOyl7ksSGLTmefFhGD
	 1c8Pvfu0Ocgq+sEQtWFthtbVdog+gM2FrIEOL6PTi9Zp8xl6Oz/5xfu2dfQfUBU5g6QnK
	 COKC3oK6aE1rcGMf7589w111WK8IPei+8G5TfHH03u8VzmTCe4Q7SDDlVVU06cEocP3PB
	 Ezoxop6S/CkwGLqfYkW4K/+prgvz82/FN35WsseqU8iB1heWZBIIveNAJNr0PQqm6vw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="FUiFz5R/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10178606A339;
	Sat,  7 Nov 2026 15:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FUiFz5R/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B44E51F0089F;
	Sat,  7 Nov 2026 15:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064938;
	bh=7Tst3MTUvrnQq0GFXqC+5PHkWTahIT0qdckqetOpdFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FUiFz5R//8fgAh41kxOXe6+28gp6Hu50F3pjfe6XQsrbrXt/DcE1Milo7nQtYDdip
	 tX7Ug8deJl0SyPhIOmF1dQ7SxATtwL0zg9SQQuIGIUf8g1D+9VE+mZBy2FcfOcFhVd
	 iary2gBqAxgQZvuZkrSkv1NGhZD11EwF24eOaUYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0793/1257] ALSA: ump: Correct return size of fill_rpn()
Date: Sat,  7 Nov 2026 08:51:29 -0500
Message-ID: <20261107135001.230664967@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

[ Upstream commit 85e8c5f933ee3dbc9d061e121237797e9fa05315 ]

The RPN/NRPN conversion in fill_rpn() is supposed to return the number
of bytes of the resultant UMP packet, but it returns boolean values.
This would result in the incorrect ump_bytes in the converter, which
will confuse stream processing.  Correct to the right value 8 as a MIDI
2.0 UMP packet.

Fixes: e6ce8a28c768 ("ALSA: ump: Transmit RPN/NRPN message at each MSB/LSB data reception")
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20261015075439.50088-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/ump_convert.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/core/ump_convert.c b/sound/core/ump_convert.c
index 85cc67de63306..0a7972d91ec52 100644
--- a/sound/core/ump_convert.c
+++ b/sound/core/ump_convert.c
@@ -323,7 +323,7 @@ static int fill_rpn(struct ump_cvt_to_ump_bank *cc,
 					      cc->cc_data_lsb);
 
 	reset_rpn(cc);
-	return 1;
+	return 8;
 }
 
 /* convert to a MIDI 1.0 Channel Voice message */
-- 
2.53.0




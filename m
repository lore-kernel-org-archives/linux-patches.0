Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032778;
	b=JEzMP22eTAjNN1E39Bvv8DLwaz5mGWDSQnd3LNeBtyxTI+qZMJvoycl67eCV5+fxknTH
	 tkBBplRREpEV4yZiGR3vviCFZKCiQEaCWs5b+RIKiqOWAX9vP3UoCUEOE3ZCbiUoAr0oP
	 OKlDoxigH4F4LhWKrBIrLe+S6opyy+IFctVkp9lymrkORUCYMr1O9zutGULcdr17/RxgW
	 U5RU2/0CaPsleVoTfADC5O/ugDJynbBRIf1jftiZx4z1SBUqaqBsndDp+pL7nHePQrQn1
	 ktvRvRdxVenGGJwILhqCYyr2WGunD3JcOW4Wz/Vc9J2AR1PAhS/qTnd1nUh1xv/zEbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032778;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=czjk04GUBWmyW2xQqFzy/RYslBn48ZyEMZnUwPfvJ0M=;
	b=XlleDfbLIIpDbtRuVjWPJhqh9yvyhSiA6WQQeiyPSODu8RZdIWs4TmPPvE+0F679Oi2A
	 TXvvJlYI8Aorr/PwNWqZ2xPJUsb5f1WvE9aLvhWHD7+2fFM61GpUX9CLUZiDUuyVaLj4O
	 xlGAUxG533TErhUIFjRqgGSCI45ekDfqjpM6HBzMAs5f14Ff9uqd8/piykRR1/+Dt8RBQ
	 kvdPC0c81Mim3sP1+aV0Q9TwyOSbLfwEEGG7AdXBEjRweOkIqlPg6ooNUyzd1rPUkreJf
	 fy/vDX1YFry9ZgibX8Vr4PToIk3AjPiytOE9dd4ouU8Mdsv0LxkWJNKXyCbJtl/hlMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rKQGyYcc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742D6606A320;
	Wed, 18 Nov 2026 20:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rKQGyYcc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CB4F1F000C5;
	Wed, 18 Nov 2026 20:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032778;
	bh=czjk04GUBWmyW2xQqFzy/RYslBn48ZyEMZnUwPfvJ0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rKQGyYccKj90eOj05QyiW4DZ+TzrV1+wRks/qOY8gnrBAONLGMGbOIFOpAT7V4Y7/
	 w4Wx1I8GU26+wMt27rP817J7oforPjTf7VY8glcfKR+gWJtFXHVV//GsoZxFjvgYtw
	 QMSfWkuLFNE+B53PkPt9ZWNncm54OuAufMhDHCjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fuchs <fuchsfl@gmail.com>,
	Adrian McMenamin <adrianmcmenamin@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1532/1756] ALSA: sh: aica: Fix spu_memset() stride
Date: Wed, 18 Nov 2026 16:00:59 +0100
Message-ID: <20261118150109.961684555@linuxfoundation.org>
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

From: Florian Fuchs <fuchsfl@gmail.com>

[ Upstream commit 0d01f90b07e877ef31f9959e9b0bc6bcca9b99df ]

spu_memset() writes one 32-bit word per iteration, but advances the
destination offset by only one byte. spu_reset() calls it with
0x200000 / 4 words to clear the 2 MiB of sound RAM, so:

 - three out of four writel() calls target an unaligned address. The
   SH4 can't do that. Each one traps and is emulated by the unaligned
   access fixup. This call to spu_memset() causes 393216 unaligned
   accesses, visible in /proc/cpu/alignment.
 - the clear covered only about 512 KiB of sound RAM, not 2 MiB.

Advance the offset by the size of the written word, to clear the full
sound RAM using aligned writes.

Fixes: 198de43d758c ("[ALSA] Add ALSA support for the SEGA Dreamcast PCM device")
Signed-off-by: Florian Fuchs <fuchsfl@gmail.com>
Acked-by: Adrian McMenamin <adrianmcmenamin@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20261022163241.2504922-1-fuchsfl@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/sh/aica.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/sh/aica.c b/sound/sh/aica.c
index 936cd6e91529c..503c9812bf413 100644
--- a/sound/sh/aica.c
+++ b/sound/sh/aica.c
@@ -94,7 +94,7 @@ static void spu_memset(u32 toi, u32 what, int length)
 		local_irq_save(flags);
 		writel(what, toi + SPU_MEMORY_BASE);
 		local_irq_restore(flags);
-		toi++;
+		toi += sizeof(what);
 	}
 }
 
-- 
2.53.0




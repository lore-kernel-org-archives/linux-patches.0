Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056783;
	b=Ewl+C17JheiYRwhuLkUccplhdhu1vXpQ3O9XomBhBqWX+1omKn68JKi2lPOdAXLluHmw
	 bzLWiBmTjzBJgjDRegosUAKOQXQs1t/s2Mm0w2Ag3x4cobVzrGxSsWRMZNdAdwbBV24VW
	 7IYsRf6yZ3kSxtatVJDGGl9eQ9QZ7bkCYVGBnXz+THhdbJEqWPZYGe4v7D6booRUcEV0D
	 wf7P0LdeRPuqqZROMiKOiA3qqbltdMSHjMA/hFI5iXfPZa6oqd8mCJ9rrlPlCK0YziQ7I
	 j95h7tyyto+fc1yxYfX55MpMICq71LcL4MLVUzzX12f6+1dApxi+2Tz/WRiS3kbATDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056783;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=276I1ugvSfYNByhKpk3D8ImbWOPAgoLtU8CVSFX1UdM=;
	b=eX+szTMhS72AS8pH90BzGj6tVBy4gtMbp+8g41hQH1bBWn4ypAZg3m4PJ/d0ukEg2zqo
	 /vyfpd94MMIWhw1iUgDvKVWapkR0v0CWtX6O52EUuG9sxQhMU4rcq88ESkva8F3/8hIVg
	 uHfne7lTkYhPc/GJvLL1FGLzVPUF8dkG0SNCV6qOq8FS+GlNzQW53azcRqcqUMd8BANTV
	 4yBE1lIEDasYB7Rj8R4saIcmn8IBQmV9HThh30d6JPB2+20x0NqkF+BJogyygCGs/kC41
	 GldYy9VLN2vqrSpqyp2A+LgLOQICa+eTbmNRGmCTwDcQXhUmMD4ot3YG08Pt+YzSBEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MTY+yjJ9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE12606A31C;
	Thu, 19 Nov 2026 02:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MTY+yjJ9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D7751F000C4;
	Thu, 19 Nov 2026 02:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056783;
	bh=276I1ugvSfYNByhKpk3D8ImbWOPAgoLtU8CVSFX1UdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MTY+yjJ9eDaLxr16V0b31kb+aNdpLOXmjKk1UzFTEq3SKDa9IKGUZcph4CigWYu4T
	 AQPC2bDqDPMzrz+ffpkcdD1IbagwAIzVS0jSNX7VsEvYCeLZA7rFViu9/TfF/HZ3IU
	 gJlpZzHGZnw5KtTBVeZre4IHlcRuJb1UukgvEg/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fuchs <fuchsfl@gmail.com>,
	Adrian McMenamin <adrianmcmenamin@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2110/2214] ALSA: sh: aica: Fix spu_memset() stride
Date: Wed, 18 Nov 2026 16:03:06 +0100
Message-ID: <20261118150135.027242183@linuxfoundation.org>
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
index 8b47bfcd90318..2ed2f5cc84447 100644
--- a/sound/sh/aica.c
+++ b/sound/sh/aica.c
@@ -95,7 +95,7 @@ static void spu_memset(u32 toi, u32 what, int length)
 		local_irq_save(flags);
 		writel(what, toi + SPU_MEMORY_BASE);
 		local_irq_restore(flags);
-		toi++;
+		toi += sizeof(what);
 	}
 }
 
-- 
2.53.0




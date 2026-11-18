Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016926;
	b=dNpObuLe68ycOYbb97KMaAB7TZW/1PfkDr6r4eKtfBONc1VgAuuWNHw9zw3sWPE0VR/c
	 I33tU8hofOC1PCOkk0Qnu+g5etGBU5j7PyKzKMOyW7jjp3iia+bkUdY+3tWl8uirVAUsA
	 +VZQOvAprco11+7kQx/21zivPRtYdDIt7FSIyJhMz8dc5o02WKoD/4eRonrQuEWQFxag2
	 4KuV3mBQzqMee6pkw7J8eAA+jIPSeFcp138X0Ae75IJIMgRsmiIc1QMyAlHQ7HENRdt41
	 U3NjR7rpL5Z4N7oSd524odVZ3n2gLRxDGAOxwNXkAF3tDWkww9rg+ILqz/xTtzQwV9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016926;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VWDNwued9IzZcqLCOuxGyMps9xOmJuzlkoOVI9DCD5k=;
	b=GyEqfN4m1bbRpZl4uu2UPdOko7rQnidkqWuC22XGdHESHxT90mDp+EkQlqSN/nDN5SqY
	 JW8OmR+7exKI4PaHcQ0tmVNRCGHCdj18ukz7WYM00ofRz7i1JZZCoiNtdM9L+fRkZSGAF
	 eSIaTximKbPnU54kKgR+gmd3y4tFUEGJwf/ZyXlppVdfqRwz04EbGs1dsV2AQBD1p+pjw
	 Z4dpwm34hzeQsBaPBMlI/LR8dfa8MFWFzEwd0YfDNg3s0feDrpqgm7CjRODlzQg1g2nWc
	 U7nUL+z02So0AkVyIXRSGPhuNPfttkYWoVIsH7ChX3xxn+eThFw653uYUSMpfc2734w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ElXCiteP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F7B606A32A;
	Wed, 18 Nov 2026 15:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ElXCiteP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09E0B1F000C6;
	Wed, 18 Nov 2026 15:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016926;
	bh=VWDNwued9IzZcqLCOuxGyMps9xOmJuzlkoOVI9DCD5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ElXCitePcqSAuFPnFpMYkxXFJpfhFhuK1UOAhmgtddgcaEyAVQXDlBG3tdRH4SVjK
	 5jUxL9fgilSY5UrvXdP2BPg9mMl8dLM6XEYcaYl6XLAtRVIvoohuCR6KrtSo1cOigu
	 YoQDaF1wEbdvptirw4p4pKrew9DJrcLqzHVELcKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0703/2651] swim: Dont disable drive after every sector
Date: Wed, 18 Nov 2026 15:32:23 +0100
Message-ID: <20261118150313.141028215@linuxfoundation.org>
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

From: Finn Thain <fthain@linux-m68k.org>

[ Upstream commit 05a7c4b197279cfb3ec3df26146ce085a2438aec ]

This fixes multi-sector reads on a Sony drive. The Mitsubishi drive
doesn't seem to care either way.

Reviewed-by: Laurent Vivier <laurent@vivier.eu>
Fixes: 8852ecd97488 ("m68k: mac - Add SWIM floppy support")
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Tested-by: Stan Johnson <userm57@yahoo.com>
Link: https://patch.msgid.link/fc511e72753ae18b6f021701aa00d480335b0caf.1788513996.git.fthain@linux-m68k.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/swim.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index 4ddb87977fe1f..3f92677ad127a 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -473,8 +473,6 @@ static inline int swim_read_sector(struct floppy_state *fs,
 	short i;
 
 	swim_track(fs, track);
-
-	swim_write(base, mode1, MOTON);
 	swim_head(base, side);
 	swim_write(base, mode0, side);
 
@@ -490,8 +488,6 @@ static inline int swim_read_sector(struct floppy_state *fs,
 	}
 	local_irq_restore(flags);
 
-	swim_write(base, mode0, MOTON);
-
 	if ((header.side != side)  || (header.track != track) ||
 	     (header.sector != sector))
 		return 0;
-- 
2.53.0




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024199;
	b=eFKUmkse2EZHBlJom4Cl/SVVZoevRa1Pb7aItprqE+443PW8DLR+plnyXmMpDoMFhMa7
	 /f/WZsX8VLmuKdFZTBwIGQPg7ULvqG4j2QN2jxksNN/n53O9Hr/BgDyiygHXqC2ugzBx+
	 hCAmo6whsqcw3C39BdVGopQicdGQpTsSJ71DO8DLi30ObrZewqjjuuQo91cDD4lFiLF3q
	 F/LwACLdFPC7L+uXQFj0nROoUV3vghWaghYfxTBSFCB5AUe+ecqirX/RAaqTZc00qRM4g
	 1sr91fYxii84YHs4iay/qt8TrYw/hxZbdRVwQA+cO/yKMgokGSIMyJBiv32gMa63B2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024199;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eMfYpBeJBtAcRZhqhS0rcMd3uk0uO0MUT5qIC+oi8a4=;
	b=up9PwwzDi/FD515oanAAilp+Fk05dLQbCPeKNFOnZ1LvkGI2WqJ4HMyt1c3GfPX/mhNc
	 kOyyUkDAo2xR49p+19ocsOCnR1ydLZgMHUMX0tkExf4rrHNhyjtc6jB8bO4bBI/NThZO0
	 CYbvpehk5mK4bBuZMpcMySTyYd515quUx6zGEkwuj3KKJlOKnSvLkWAWMC5t6TvX4ulpi
	 7i/d2XktKdBdV7suPiyt0CF+Bnbax+NC90bqq6PQZTxlTJss73Pm8PKH/Nif1/WdgoYtB
	 lRWlD/la5Q7gjfJXNyQ2SlT0RcXlqtQnboVVPK6lmI3Ve7iI2TUV/uwR8RQ5x3OQJ8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OBXIFAeJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67DE1606A31C;
	Wed, 18 Nov 2026 17:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OBXIFAeJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B91AF1F000C4;
	Wed, 18 Nov 2026 17:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024199;
	bh=eMfYpBeJBtAcRZhqhS0rcMd3uk0uO0MUT5qIC+oi8a4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OBXIFAeJ9ihfjd/c7Q552IY+s5e4cJcwYbJrJi2TTSHPJlXmryYsCGWyPnl2VIfx/
	 2Xak0kOrRUjwcizGjtOdIdHCClaxJhJJp6JP6bx9Z3p532eqmxDyRUrNQ9/kR/QVox
	 kg6s0DjF8RJOepsCOIczAEYKylTRwkqky92ORtvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0639/2151] swim: Add track zero recalibration delay
Date: Wed, 18 Nov 2026 15:39:34 +0100
Message-ID: <20261118150145.150200468@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Finn Thain <fthain@linux-m68k.org>

[ Upstream commit b9c1095048537cc9563f12d0a24f2f0df129e4d5 ]

The UPD72070 spec indicates that the track zero sensor can take 3 ms
to stabilize following a STEP command so add a call to msleep().
Remove the duplicate swim_readbit() call as there's no need for that
once the sensor signal has stabilized.

Reviewed-by: Laurent Vivier <laurent@vivier.eu>
Fixes: 8852ecd97488 ("m68k: mac - Add SWIM floppy support")
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Tested-by: Stan Johnson <userm57@yahoo.com>
Link: https://patch.msgid.link/6d17ca20a7286c1d74833b29510c506a66d96e6f.1788513997.git.fthain@linux-m68k.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/swim.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index 4915b5e1ceaec..178f270ef24e7 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -402,16 +402,15 @@ static inline int swim_track00(struct swim __iomem *base)
 	for (try = 0; try < 100; try++) {
 
 		swim_select(base, RELAX);
+		msleep(3);
+
 		if (swim_readbit(base, TRACK_ZERO))
-			break;
+			return 0;
 
 		if (swim_step(base))
-			return -1;
+			break;
 	}
 
-	if (swim_readbit(base, TRACK_ZERO))
-		return 0;
-
 	pr_err("swim: track zero recalibration failed\n");
 	return -1;
 }
-- 
2.53.0




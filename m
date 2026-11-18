Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055272;
	b=paaU4f03tDXF/SEtdHvnBFHYif+qaHMisTMWJ1CDN8padUWv+Dz94hGE0BGWeNKqAiPR
	 eWOiPoQ73Sbe3blTTl+O6u5JxhL7Y1r1RDKb32TZD/XJZjDBe8A2WxaeqXhknXVGuDOdf
	 XfA1JGv47xUrdORLWcemKgSpvWceOCPbMdtInVtQ1nHEYYLDK82RjU4/TzgYqbPqbYy0f
	 iulS07K+W8bpQTYH/Vv2fHf+G5giVe6GY3Mn3pvDTkddGPrWm7iniiqroIhVQ8TqGyiF3
	 KtI2O1wl5ftyfDUdf8VdBijcwbfA3KtyWt2FhYaDG8GVqDo85gcRWujIh+SAU2LBMsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055272;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aR6nYRkZg187cnvHtnUl61QnDDBGPTpObmdctsoOrOQ=;
	b=wvWx40FPILF0DKkY9/rsdskjUlr0Nkj07PufoPfcoH/BuJUm5bcLdTp8nhWdlYVHiOzi
	 dfyBQga1B4cKZG+qYtM8JDvWdyB54xqx66/XVDA43p8H0lzqZApkL4ItZz1UgpLh5fOjA
	 juFJ6ui3qdJ2We0IV7vIUPPBLxScg0veMOlq815KMXY3DJUpzux+/bOWqwZqcINIu6Jke
	 m9+1wDCJrGpCGxyn3BcG6NaeRJl60uvOsd8UD1Nc2MD4Cu0Vpnzr/YUl6IVT9m1iMSgzX
	 tDR5hYJnKn0+or3vbURXUAwDHSMLPDFbuX4HGPp5LCgv7M+vcMd5sjx/TEEJtCDgj8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ri3h8z91;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D85B606A32F;
	Thu, 19 Nov 2026 02:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ri3h8z91
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EFE91F000C4;
	Thu, 19 Nov 2026 02:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055272;
	bh=aR6nYRkZg187cnvHtnUl61QnDDBGPTpObmdctsoOrOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ri3h8z91FMQ0YSrScZXnaaWMINceT3vP07j5rYhpfiD51rbmIG8wIQ0wsEpzxsiLC
	 +6iXjUBBrRdYDzqz+BuCA9gyC4gGoT+yPfbSPRHECeLxA1otUtJy7+C2Hrzs1gNvvI
	 My0tPnNaiFrWDtv3o+Mb1tiCTFFdOvU4xCPfWPuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1572/2214] swim: Add track zero recalibration delay
Date: Wed, 18 Nov 2026 15:54:08 +0100
Message-ID: <20261118150114.936456772@linuxfoundation.org>
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
index 6fdfcfc5f05ef..066cceafd9d70 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -401,16 +401,15 @@ static inline int swim_track00(struct swim __iomem *base)
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




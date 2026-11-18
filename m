Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016946;
	b=dfguuA3uoOuGxRpaiflCPC35JyWuPurratJiHQ0HgoCcs2Z0KEGqjDBkUMhXJ6IgTyJm
	 /dc6rrlOphY8Tx9ziM3qp3OGteJWuwBp/b9TJxn3TSbP5CAOISrVvQ5e96OmXmAgOdP/R
	 v1hPYKmtGFvGxiZ3oM8nvL2Z28hDxuLhYsPFPKvKM+tDlJyx1W3H+1sn8taW1nbw9bcSV
	 8WkhE9Ksv2gNKVq6TRx9UeuXz3OBVAcacSoyjB48HoTrNUH8j1IVLIiBl6IlfDVHqxJGX
	 Qz11J2hUiZ82Zir+T/RlHu++apiLPbb97SB989Hlk7Er6MaDmBwrgrh4P3jBEdRMbnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016946;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iODpDu7fW8Ytun7C+yleQi2P/oglquHRsjJzKQ9w+yA=;
	b=N4Pi/c1CdSX5QOk/NV5AwWcOZaRTNJ6mVZA1bl9awnsXXd9AFjHobQwqBuIepcHQ9RPG
	 Bmc1ahAAZLTS5Z2RgPYUVdlGnKKtTDj7W38uuxABdInQgsPJLrwLyTgK4JddPfTvcXsLd
	 0Xb+gescvRwbdN6ZQm2pVoLVqrmhfPOnB6x5Jrszea7/AgCVkCk0Wzl9/2N+Wg3uf11Cc
	 bWyFgQtXgkvLQSwLfjCtHzcrTPGIePY84uY7gH+h2MX6AGTiTIItn1XD3yz7VkKfV0XaB
	 0qSozledtBkuXzOAdnV+TfcClcCivKBgZccr+M9ozI2mrb2F7u8ktI9qukNhtL8XB8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t7jHFEhn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39FAD606A31C;
	Wed, 18 Nov 2026 15:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t7jHFEhn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 934051F000C4;
	Wed, 18 Nov 2026 15:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016946;
	bh=iODpDu7fW8Ytun7C+yleQi2P/oglquHRsjJzKQ9w+yA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t7jHFEhn0D/mF8ZKEXsHFRE7h663qiEcjzsQM8JLc67dmY9bEcHII0H20mxQ9iGo7
	 M0Ly07zGcplKNvtjjVJH5ZseHoaetA5/ZJOacMdhszEWNtDMF595Dk2Yk8l9QzcGhY
	 psyKTfWQJJcNGHLfX2WUmJqGMis6Z1HDxfqZTk7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0710/2651] swim: Add track zero recalibration delay
Date: Wed, 18 Nov 2026 15:32:30 +0100
Message-ID: <20261118150313.383933105@linuxfoundation.org>
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
index 5daa60938505c..cf5470cfd775b 100644
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




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040059;
	b=v8D/LlVzDvML0TPCiNcH4xQ8spYr7yUX9/wTjEjfjMoQIV9YW/WgPCvu3dlO8MjM8O1m
	 EIIi4960sFBiSGxiGrUgrNzl+XLt8EYTBeCeDp/ncQTZ5ylgPs2pyZnzLLFdFj2Mu3xjp
	 Fb0dimAtNqvAHvXNvvs/jYOS/PJH4l/aiYURRFEUlQjyoMGI+DX1dgabbxgN54mcr+Fy2
	 Pjy5nhIY/L1HhkhluKyU/aep5PELFdLVYGKxgExJhlTUKHzb4RVlintTNYNvNFw74sV6J
	 pLmDXZI3wig1hIER6iTmJTP+s2d29lbxamL8aBQxIIsYu/vNvqesnuT0JidPjkfqeEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040059;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hbYcoIkJ2B+VyYSn/P+C9WzvPzfb2Ubtb8/sf7OazmE=;
	b=hMv0YldF9qVRboJglMaymUKMm802KG72qzN7jguDYbzZFvjdL1XjNC989vqJCzcVeyJo
	 qODZqFcuulHC8nsdaYs2fBbH0S6f+UfF55t4Brw6ebm+5nlLMeyZ/CLC7bQfaCcqFjrqm
	 R86snmdXz5/dfCk/86FJ8TL41Hsk3mw/1kcEeopezqjM+OJtuJP1WHDIBvNrqkugRZKZw
	 nQa/wSiNkcc+rZ9PDaNZ3pLLHjFNx1ifAL/JVygUCpKYD2RQqbM3WQn1zzL/6UE30yPRl
	 5A85nZ5ijIOlBbAKR/4lXVrCFvQt+8AMgQ0a9zTiExMveEDu0Wr0nqeygXyt+mGWV6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fe3YdvsC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A468A606A31C;
	Wed, 18 Nov 2026 22:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fe3YdvsC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0126F1F000C4;
	Wed, 18 Nov 2026 22:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040059;
	bh=hbYcoIkJ2B+VyYSn/P+C9WzvPzfb2Ubtb8/sf7OazmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fe3YdvsCffTF3XyOf/XKjTHesB00YC/JVcQJjuRmLODfjivcxen7d7WhYuxbVQImW
	 cWN7YgF8SXXJazmcWbf/e6uBMxO3LDPvIDB6InCLltWHnJpUY57XleahgHnD7FhUON
	 uBXQq86GyXzCW7L3Nm6Pk3N56GR9aX88E22VoNqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2315/3318] swim: Add track zero recalibration delay
Date: Wed, 18 Nov 2026 15:48:57 +0100
Message-ID: <20261118150431.140373796@linuxfoundation.org>
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
index 70b5d5dfb6079..83be8293e445a 100644
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




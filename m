Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029411;
	b=UHkl4VoU5f1rvMWLpgZPS3JMEADu6wCvYuoTK/qNVB4GL+q65DsJV97Vd+3bFRKfSjPd
	 Z3doztO/Ova0xVyrzko1uEKA2pB73/YNFZbBGfiOlFDxK1+dEND8n1fvTwduG3dbwaplD
	 GQlgsnm2RLTP4ADnLZ9tFVEaiNHE11RGz4UrgAO6Sjzc7wbb0xJTnHo0efMrMsZn7ukiJ
	 dWD4LVHNNt52yJ/YytQDGrdbLuTk12f8jgVBn4KLuBcDkGRhK6eTymcC/YnjtaJWlWMEi
	 RmOktxvYqUDImxnsX5UibNAWjdRhz4cLfAaRVRJ1YSiRQRo/osQN5W5gI0VehKKv6Yg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029411;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DTSwyu8Iuw6jOwv83MjANLCq17UrZihrwVjihAGclHc=;
	b=wMtKk5yVevHDJ8r2y7iyzm4iFRc76L5dod81C389IyiZpcNFmbJuV5rrQ7SoDXnsHqw8
	 dAbx7/YPNfETTHA4fid/LgKQhCH2purQbbi7We9a4IlR8r4+HKjCvlEpDBAK+pzYioDr/
	 zRuWCjOAt5zRb99ATbt+GMgjaG7XHbIf4FeNeUT8faxx/UkhC6aDKwGN3Pb7v+xj8sYHT
	 4pTs3SwHcxg2e0vaMNXo9urQbfaZwWPHxTA5mfM+2O2PRKm/sGOpeX6p27TrxseX7/x9h
	 /7kEwKT7OIR/RCnsRgH2QedSfwnVXnEjhejaTzeQyUsa1uh7+tPkHh4a6cvX/fthC1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XR6P0r2k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58379606A32F;
	Wed, 18 Nov 2026 19:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XR6P0r2k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 619D71F000C5;
	Wed, 18 Nov 2026 19:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029410;
	bh=DTSwyu8Iuw6jOwv83MjANLCq17UrZihrwVjihAGclHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XR6P0r2ktn/XE3X70LMLLZIMSbd2EyAZm4U52lsBCLn4zP3MW4M9TSH+LY/Ei+BB7
	 piTja3VwSVANy+NKiGn0dz1sgqoEyw7DHGmMQBqo3OOq/ae9IUfkLx3OyWdSHsMj1/
	 78klp5UEkC3NwQvW3VQjqRrNbyiLzhx5V08j+2+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Wang <wangjia@ultrarisc.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0340/1756] dmaengine: dw-axi-dmac: Fix LLI dump out-of-bounds access
Date: Wed, 18 Nov 2026 15:41:07 +0100
Message-ID: <20261118150021.796542978@linuxfoundation.org>
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

From: Jia Wang <wangjia@ultrarisc.com>

[ Upstream commit e6b49f8016ee8b642e8e495d1704342ee0b35d72 ]

axi_chan_list_dump_lli() uses the channel-wide descs_allocated count to
walk the hw_desc[] array of a single transaction. If multiple
transactions have allocated LLIs, the channel count can exceed the
transaction-local nr_hw_descs and make the DMA error path read past the
end of hw_desc[].

Use the descriptor-local nr_hw_descs count when dumping LLIs.

Fixes: ef6fb2d6f1ab ("dmaengine: dw-axi-dmac: simplify descriptor management")
Signed-off-by: Jia Wang <wangjia@ultrarisc.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260902-dma-fix-v3-2-414c6449fbcc@ultrarisc.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
index 4d4052845534c..b6d4798068ffc 100644
--- a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
+++ b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
@@ -1054,10 +1054,7 @@ static void axi_chan_dump_lli(struct axi_dma_chan *chan,
 static void axi_chan_list_dump_lli(struct axi_dma_chan *chan,
 				   struct axi_dma_desc *desc_head)
 {
-	int count = atomic_read(&chan->descs_allocated);
-	int i;
-
-	for (i = 0; i < count; i++)
+	for (unsigned int i = 0; i < desc_head->nr_hw_descs; i++)
 		axi_chan_dump_lli(chan, &desc_head->hw_desc[i]);
 }
 
-- 
2.53.0




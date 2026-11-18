Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048121;
	b=eYcYIPFDsSodS64fBfk6+rTPv8we0u8m4L9D8BpQUiNDkV6V0a+3eVlDK8dP/fm/6z7D
	 tTdL05euaS6Hv5MOzsUuvNIEtT38Dp1U4rG8uQsi47bamUiIfhFm2p7KKnTh84EXqyRAW
	 2Cd6XYkRFdjzr2EFoAPdPGjq33Yz3LTxlQHlap+3ybHhhFAshBvau3wOZ8UsMRO6uLoFl
	 0CvkF2aACC6Nc/06Ws1LQ1gAoHsQTWq48bmtJuAg4Lop0CwF+PWu7f8mmyN+Zi5/VVtLy
	 /e15twIKIwisUEPdzc59u1XwsZ0oCIZcoi+CiSm/Wqvjqhs0dbQ7L7IIbd6dteCWw0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048121;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QN3Xs13mQwvFH4dJoeFC1gs/wJ6S8ZX/uo3i5XdYkMA=;
	b=J9dwFgdJ6+jKlBmGEA8IDMAUBA+z9SiUsydgdk2YmR5jrayM2ggcTmph3AIY3eQLVdUw
	 /DVZLQIMPRLWfR/Etco+ybz5zCiZLA0XcNFcKsTYg97WQ99v0pvZU/XUj6ylEuFSAIhBc
	 CakL7rSz97Fx3VJN0U4fIMrjSDp9ofHPuU2LvgVBb9hmxXBy+a8MHCa8tnyHCI/juQA+N
	 WDj1YGWsqIFGXXomBzuXToLlDMbNGr1yTvXgaMdL1jT6nF+l5lDdqVxOSjw7DRZle0sAT
	 uqy6KpxKihrGjisggOOhLJcbFCB4FaZqQ72vO8jiYy3krhWiTsZpZYb2n6emTvVpKIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TD1oCUK8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CDB2606A325;
	Thu, 19 Nov 2026 00:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TD1oCUK8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABD151F000C7;
	Thu, 19 Nov 2026 00:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048121;
	bh=QN3Xs13mQwvFH4dJoeFC1gs/wJ6S8ZX/uo3i5XdYkMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TD1oCUK8bB1+WgrUXotjliU7NVes/P0x5SFvwxaQjSMI/41iQgyS58yzTEqbt7eF8
	 5kagHYoP3fOTa5zSX8Zlt+HSLp+pbrgKQUgVvKB0cVXz4yfyGvHYOhoPc8nSay6tjl
	 vN31rDo1FqTRQ9RpmxLCWEe8qgjVV2yjSVpdn2OM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Wang <wangjia@ultrarisc.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1882/2857] dmaengine: dw-axi-dmac: Fix LLI dump out-of-bounds access
Date: Wed, 18 Nov 2026 15:48:36 +0100
Message-ID: <20261118150308.999520289@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 73e8754342a08..499d5672dbb2a 100644
--- a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
+++ b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
@@ -1009,10 +1009,7 @@ static void axi_chan_dump_lli(struct axi_dma_chan *chan,
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




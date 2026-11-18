Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039593;
	b=XX7UVKIkN7JbfRGYngIlie6gm260Pc+4dvY+SJM0fQw/JAQp/uK2Lrsw+3EtebJw/6xc
	 puaBHOcGo7xwuaieMrP9BS4fQQ26pm3w89m7g5UakN4UnetEMFLOsTX1ZqpiarKvR1USl
	 H7+7r6BGG2VT8guGl9aU7B5EQJuzfIoU8EGiMiWg5iDOn9zIq8YZc+nv14G9M9Rc5uUeK
	 Vc0vVC/5VfQisg/lj/TwpdHl4eoM3+Si7wZeSkGTo7E8DiWTVL3QG3KRd68T+R3J85rQh
	 JIIgM3YCK+Kfm26T9eZT4JwkD7f+ky+w3zn0HuGl8h4SBhdiFxyeZEUBITqc4zNPGEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039593;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GHrb/D58zzEKaUBR9bymsZdr1P4jiwmnXPC6+sOmQ2U=;
	b=wC+CA9fFfrH9O91xkvNTeXGCuQ+mIdZQm0AWsOXESOxqSe8okcLufJ1WYfg2OAOlqn9c
	 Xpfh+sRWIlJcX2sdhufz5NpNAe5enl8x+OdbLFP2L6QKCoUNKZeNX97xElV4k73K14FD7
	 G3m+u8fXtaiLpZseFnlPs2SMCkJlrXkdGk+kwRtfLOYDu+wlXMN+ZBlEDuhB8RsEHbPAN
	 rxbb2fL6xITPETJ/A4IMmoSnZXNoMlKwomjbHbJCZlnQNplifhBtx0awuZeRmMUjoQTwV
	 5I3uXHM32z4JvmWHeYn1dFm4+76WQGrwzAZ7rdsXcSukpfHamuWBI0weM+cdVzsCMmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uv6M3Sqm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B08606A31C;
	Wed, 18 Nov 2026 22:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uv6M3Sqm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 949BE1F000C4;
	Wed, 18 Nov 2026 22:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039593;
	bh=GHrb/D58zzEKaUBR9bymsZdr1P4jiwmnXPC6+sOmQ2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uv6M3SqmUXuWn1EmHnHHD8Sld/PnuvVbXydah78PgfwrCoOpFUx3rMWYxeBOkN43y
	 Nxd/+XNylS+iRwyaAaTm9LVJk3pcw5DPQiefLTHyBxP3F9ASKp33mtLcJG81x/J1zL
	 UVfGDz+Xq8xWZXQsXZ07mOpB1+Gv6OYxbnmkQn/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Wang <wangjia@ultrarisc.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2157/3318] dmaengine: dw-axi-dmac: Fix LLI dump out-of-bounds access
Date: Wed, 18 Nov 2026 15:46:19 +0100
Message-ID: <20261118150426.731666163@linuxfoundation.org>
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
index ac3d7600c3af7..9758dffe249e0 100644
--- a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
+++ b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
@@ -1008,10 +1008,7 @@ static void axi_chan_dump_lli(struct axi_dma_chan *chan,
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




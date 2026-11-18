Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023437;
	b=cmLrA7oAMUmT3QZI+/ZZd/WSgOV4l5ProWUpm/XJZM6Lo0IaxANt7rfPUSFCcDg67v6n
	 +Mqqiwf/ZhBi+7wOhp4kOkM6hrF9ibAEDZpjTUcPHjnn/Op5YNJ1I8Aq1493c0SWh4Jb1
	 z0ifHD2WsSJ4rwaa48lAXVLKkBFbvrFeQ3ngznxaj9tANCDU1aUR7dS44j6yugGUD9gbf
	 SIM7PdRDEmKhCGjkDJVKTGPize2Y+ZK6bZS4EFmFdoor/82EvbsgU/jDbjsLDYsJ6Frtp
	 B/0Bm0FWf21J3/hyleHRUbf4WYsRoVOLKNxxPFEQ2UVQYoFWcGMbaLiGU/qHdcO6Jaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023437;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xNxdtnszc6lzipuJi8tNv+k9AdtQReNX46YWL5EdxYc=;
	b=F+yefu1W1ljGYQ4n0qEaiHUAS9KLtr/TUyy7hHKNgMdurrABSC3V87oGmnT8syjLxJQ5
	 uEd9/lHx0zl3cqkP89onm/+n+Fou/c5Zk0OnM5DOdWOkav3FD0cdFANIfEnM24WW+rtQy
	 n8ANMB3xIv85922SFAfZZa8nTHZqWviGk5SxmqKJXPRm5TgiApHKkCXzS3UdxoI6c0Bbz
	 CLI4oN/Z5KToOJRDqdl7TJ/6M3MC5j/mJx9nTm+jNl9NcRUUnjxLp+4B7Ia8pSt3JPdkf
	 Upk+O3Y36GxaeOwBME68Guhrs5AxIqPj9/NS9nvOuQfyp2Hl2qhvVxhBE2HKz3LRRfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2lSnxghB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6488606A325;
	Wed, 18 Nov 2026 17:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2lSnxghB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 482C31F000C8;
	Wed, 18 Nov 2026 17:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023436;
	bh=xNxdtnszc6lzipuJi8tNv+k9AdtQReNX46YWL5EdxYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2lSnxghBaTg6kTeD44pcbicnYm2KfdzSNTFJApJywiSOWM11nSNK3EIO5N/mDJpfo
	 KPoAtvyP+UjqQFDjB811jwtLOQBH4AbvTNZ6ZPbaPj9yQfvUuTVv+Mt2CWf8Rxfx6e
	 m8PYGPJEnCTZCJfqFiwxXw2GyJrzZXDPwor/VAlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Wang <wangjia@ultrarisc.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0368/2151] dmaengine: dw-axi-dmac: Fix LLI dump out-of-bounds access
Date: Wed, 18 Nov 2026 15:35:03 +0100
Message-ID: <20261118150135.496097361@linuxfoundation.org>
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
index d4313d0a2a048..c6c54d0b21e69 100644
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




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029630;
	b=b0q/emm/9zrU4ymuZYzU9VL+f24KiscRzl4FMPYIiQ75nOJQCwWJWgBNjz9YQx5jNd2N
	 e6IfzBkn//8rvdQ2UI7RyNwff9BKzUQ9xfm40d7wEjMy2n6vE/V+hSeNhkRQ4iPZOwN0w
	 hM58sGcZ08AM5zy9PVWLaOq4khWgo3dl42RWF1cQzKpFrfhCUsHBTLwWmt6Q5nf4Q4OBX
	 DCak/S/QBRDS+rOX0HmKGtam3Tx66IMisZpeU+HHuLWQFJdPEyFnQuTr0X6naotbQ36XH
	 fUgyeTUIgKyaouWJ2U9vXYqC1qpWteb9uBG0B7Tuj4egJ2gwVdPr8knok+QogyTGDOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029630;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BMJxYyFYZSMkTXeIEG8n0xAg9sT1Ygl8kEW650nRWMI=;
	b=LHF5KT3/WDU3UJRUT3iPNOjuPsZfwZo3U2du2HdffSoQobKeahgQSwyB5ir/72MH3yZc
	 a0SCihrFwud0OfHVAluZ9tk4U1xOM6pvk/mw6vWVxAphFbz2bM1hYzkdTZNj+Qz3HWnEE
	 qhxA9vBQWbDba3bl8uKxHZbBA7dRQNCQFMpYDQIkOCTRga4rc+Z08j1B8UwO76DpabJmV
	 iDK7pLQfza62bCnjXewRlcVQHDrDWAlfcz7kLXvGqaYlpqNXOQ9MqRlrQUtXgKJesJUmK
	 gt7rPoBNy0w8ubQmylxwOFNvqqYN+su1XpiaZWOsIaFiC+eWNRuZ+rDizODB62OWiQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DOZSOR+g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 052FF606A334;
	Wed, 18 Nov 2026 19:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DOZSOR+g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B6C61F000C6;
	Wed, 18 Nov 2026 19:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029629;
	bh=BMJxYyFYZSMkTXeIEG8n0xAg9sT1Ygl8kEW650nRWMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DOZSOR+grjxEmqLH+MF2ndflF81ClKKhPzWHf1UM6d2UCLnWCoKbtHCpU1WDBjLOd
	 L5Y6uWJso/VDEtBvJTOuZ4w3zpLaAo8Hnx8mqCqdpR5cvDc88RpkvSboN/ukiKzoPf
	 nAEZdoW8X2t6+p5MihatO0VeSbLwd/53Y0HbwlnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0416/1756] dmaengine: mv_xor: kill tasklet on channel add error path
Date: Wed, 18 Nov 2026 15:42:23 +0100
Message-ID: <20261118150025.288906534@linuxfoundation.org>
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

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit bcb4d469b19d53dc21e4a1da12d4438e7489e150 ]

If request_irq() succeeds but a later step (self-test or device
registration) fails, the error path at err_free_irq frees the IRQ
but does not kill the tasklet.  A previously scheduled tasklet can
still run after the channel is freed, accessing freed memory.

Add tasklet_kill() after free_irq() on the error path.

Fixes: ff7b04796d98 ("dmaengine: DMA engine driver for Marvell XOR engine")
Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260909234601.101883-1-rosenp@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/mv_xor.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
index 33716794d50e2..c03b31a2b8453 100644
--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -1162,6 +1162,7 @@ mv_xor_channel_add(struct mv_xor_device *xordev,
 
 err_free_irq:
 	free_irq(mv_chan->irq, mv_chan);
+	tasklet_kill(&mv_chan->irq_tasklet);
 err_free_dma:
 	dma_free_wc(&pdev->dev, MV_XOR_POOL_SIZE,
 			  mv_chan->dma_desc_pool_virt, mv_chan->dma_desc_pool);
-- 
2.53.0




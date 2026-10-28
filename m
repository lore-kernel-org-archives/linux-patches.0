Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215789;
	b=K5XwXmJj4CwxVddVeJzROZBSdLxsliCul6vkIi9axO4iPIj/dHmqSZLwb/T4mzZ1Zt9Q
	 roZFMDUJ0gJDeHza/JO6vjPOkKbM/6C1Yr5TEOj3m2AqlCY6N5UxLGd2K+6yZyUW5qXa0
	 rKOkmvvKr/z7/uSVSyeN/vqqSEDoB9/dfBOHlvBFk2yLja3YaDSGjmhtny6GPFT8SEZHL
	 0bf63o9rHeST4KbxmhPgPeqpgue/r04RIxAtZKZfpHPjoqSotETABoyVyPB5RUbIQbKCW
	 tD4rqiqNVMYrVOPeB6QDYielyWjWLWizs87Vx95UINDNA35g3ickSF398zb2/gEyrKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215789;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3Cyxwuk8MqaZlax4IF9Z1HYITa5drcX+bf2Mqdudr7g=;
	b=X74e7jL8Oagun8M6C11XMYjJ2c0rh/qFuTbQMmMXN5T+u3vrNy73DXdXK+Reu+Zs1kkk
	 5vSDnsHriMfnWMIsTbiKzUqCcoAcsi+fZmRyROIK/KRmM8JUxPMH1OzqwlCH64x8WfI0O
	 NkpQEFBs8N73geFzn7YLQ8t/BBuqt2CCUXBDvhsftTQbyIxVL5WiIwOTcO+EhiPMip9u/
	 wMVnb9VlNb8YU39asO9VwgLr5LDa769QOOLTs/4aYXt8HPhs3D2sgZEoJbILR9ZmV5Amy
	 avHiS5o78v5MKh53NqFRvMbvTI42M0ZIHZtGvaWAxG6YHLJDXJNmDUxdcb4vMAQ+ZpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lzkMQ7mk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D84E606A31E;
	Wed, 28 Oct 2026 19:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lzkMQ7mk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 426F51F01825;
	Wed, 28 Oct 2026 19:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215788;
	bh=3Cyxwuk8MqaZlax4IF9Z1HYITa5drcX+bf2Mqdudr7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lzkMQ7mkQjNHZGajnBoaardmvjWQBeToxpLMON8iN7yJx8NCot+adlrsLSB0gtKg2
	 7Mz0Ib2LVUpanrj1MrlaJM1sd7pMb7tPVw97brMOSpgzHs/aDXfP0qVZkqoLe5lF3c
	 9oU+Zfv54tDhArLQP1U3vzAk33wIfmPmnftDIsjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenguang Zhao <zhaochenguang@kylinos.cn>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1334/1887] net: ethernet: mtk_eth_soc: pass eth to mtk_handle_irq_rx in poll_controller
Date: Wed, 28 Oct 2026 17:57:10 +0100
Message-ID: <20261028170529.792210969@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Chenguang Zhao <zhaochenguang@kylinos.cn>

[ Upstream commit e095f249e2209674f6366f6db0383a2b96e19239 ]

mtk_handle_irq_rx expects a struct mtk_eth * (matching the request_irq
cookie), but mtk_poll_controller incorrectly passed the net_device *.
Calling ndo_poll_controller with CONFIG_NET_POLL_CONTROLLER enabled
would then crash.

Fixes: 8186f6e382d8 ("net-next: mediatek: fix compile error inside mtk_poll_controller()")
Signed-off-by: Chenguang Zhao <zhaochenguang@kylinos.cn>
Link: https://patch.msgid.link/20260723055735.885112-1-chenguang.zhao@linux.dev
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 20d14e3ae6efd..a65d6b1317771 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -2916,7 +2916,7 @@ static void mtk_poll_controller(struct net_device *dev)
 
 	mtk_tx_irq_disable(eth, MTK_TX_DONE_INT);
 	mtk_rx_irq_disable(eth, eth->soc->txrx.rx_irq_done_mask);
-	mtk_handle_irq_rx(eth->irq[2], dev);
+	mtk_handle_irq_rx(eth->irq[2], eth);
 	mtk_tx_irq_enable(eth, MTK_TX_DONE_INT);
 	mtk_rx_irq_enable(eth, eth->soc->txrx.rx_irq_done_mask);
 }
-- 
2.53.0




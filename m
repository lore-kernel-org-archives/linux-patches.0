Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048476;
	b=D8Uo6XB34mcRzC+HNYYikLLysYync/ZE00695op6TqeU47gTQLsmxA9MDlpL5I7Diq0f
	 1W7BLyaNbCO0C0HhMWV2WAmU5uYuUwV1vwQZ4tzXi1+mie1cKR4ZKpfdM8QNiJY4K4Q7O
	 0WMP2BkJO1VxKg3ye9Yl22GBQ2dQPJ++SsVvjAjhYXQGu4l0dpdqNYNSyjUBid7klZiyv
	 7jNWEdoo5H0EPhXdMqCsIeq3F2bBau7z55es31VEbFYdYG1kg5wTu2b8xIvaybkFb4oee
	 A4Aq+4ZvQr3Q3DUoAxi9QwgLcT2IrWhD7IdWbu8cBSsO8ZTTb7Txn6Kj+G5UyEOHZoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048476;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DhNK9zP8a5DOxYhBzgA4miMd22b6+e6yJbBPHEu6zjA=;
	b=xUxMkZFr39ae8M2IVkzwTFjC5/JqaiHYziIGzP8pBbA34BuzoIkDVsYRdr/duJCeFNRb
	 FZdy+Q7+fuGPcLC0rk1P2DOTCY/YqwLpqL46FtTNfjIqYJ9TV9cay6wLVQ0yVXFTIC184
	 rwEqWOWRLUegjXojN/Ulh/x3dd2KwyUAA7EnE2o359mc5NwfDUTZV4oAmegl1JPCYGNA9
	 QZKsosKRyXL2pRDeROEKjhXn2xLH2Wsb78m016y8PQvKG8Q6a33Lf22RjZIqjsM3LbRd7
	 58RQaa9y4SphIhEvE2ZylMG/8WfxuC5nTcgjTVnjJpGpH+JcjLIQkpjchJZY2ADMfdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aD3MrF1W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 745E0606A320;
	Thu, 19 Nov 2026 00:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aD3MrF1W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C847B1F000C4;
	Thu, 19 Nov 2026 00:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048476;
	bh=DhNK9zP8a5DOxYhBzgA4miMd22b6+e6yJbBPHEu6zjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aD3MrF1Wcl6bgC8SO7HZseo2lFwN2E8IkmvQAlvfb6t8EB5CkJkxTM8RhrChbSSN5
	 HwyWWqeFLsYvGAC4EDSR4R6JvyAR2mywc+7KytTJ6x78wGuFZ1TsDvJOF6wEPpQhVz
	 kfzB8Lzz6qkfyERS/TJ0gR+aT9jNexjx989fzw/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2008/2857] crypto: ccp - kill v5 IRQ tasklet during teardown
Date: Wed, 18 Nov 2026 15:50:42 +0100
Message-ID: <20261118150313.697883815@linuxfoundation.org>
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

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit 67aefeccc4101a93627f36abbd049f191b54f903 ]

On PCI devices using MSI-X, ccp5_irq_handler() schedules irq_tasklet.
The teardown paths release the IRQ but do not drain a tasklet that was
already queued, so it can access ccp after the device-managed allocation
has been released.

Kill the tasklet after releasing the IRQ in both the initialization
error path and ccp5_destroy().

Fixes: 6263b51eb319 ("crypto: ccp - Change ISR handler method for a v5 CCP")

Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/ccp-dev-v5.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/crypto/ccp/ccp-dev-v5.c b/drivers/crypto/ccp/ccp-dev-v5.c
index 7b73332d6aa1a..4235be5df546a 100644
--- a/drivers/crypto/ccp/ccp-dev-v5.c
+++ b/drivers/crypto/ccp/ccp-dev-v5.c
@@ -995,6 +995,8 @@ static int ccp5_init(struct ccp_device *ccp)
 
 e_irq:
 	sp_free_ccp_irq(ccp->sp, ccp);
+	if (ccp->use_tasklet)
+		tasklet_kill(&ccp->irq_tasklet);
 
 e_pool:
 	for (i = 0; i < ccp->cmd_q_count; i++)
@@ -1046,6 +1048,8 @@ static void ccp5_destroy(struct ccp_device *ccp)
 			kthread_stop(ccp->cmd_q[i].kthread);
 
 	sp_free_ccp_irq(ccp->sp, ccp);
+	if (ccp->use_tasklet)
+		tasklet_kill(&ccp->irq_tasklet);
 
 	/* Flush the cmd and backlog queue */
 	while (!list_empty(&ccp->cmd)) {
-- 
2.53.0




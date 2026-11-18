Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055238;
	b=1qEXl1zC2/KVun5VnaPSObN8k9uETGzpF4vhC7y/1fgAhUKcpQESWH/7goAbzs0B+Iog
	 YNUE1oEjehrsXniuDoZWZpeaVdqW38orgowCrXznw8p1WxYFFRY8ugZgYkAX5dyfGruof
	 RkWiTsDF5imZAlG83hQavTiGvkiYkCOBk5b9FgP+Y1u9Kr2bty+7yRn5t07nnvoLCtzbI
	 3hajgAvdQ6nDqw8aBZB/ygvOXhzWCTciykVM6axT/iJa+ff123wYfFFFAtJr7ZRjoKjUP
	 v1gUsI1IiXYZ7Rfhw5qP+fvvWEEc1Kxpk5v3IOaa/tiLlVAfcT92rfakg1ueggWDbxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055238;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y5P/Cju2m6MKbup37i2DhG9YAm5hiayAufqs69FNvjc=;
	b=fJ4dAvhx7jjuySx1DdYumwz1EQezcuepmndH4UaX6Nqp77h0KbcXbo2NwkDKZizNk0jm
	 iSANQzIarFft2T4xWxOkkqqMzOThtE1SxSxeOROTbtMUNfUN7Ohkn3SP6twLk4eczxJ8T
	 GTOHKA4ZURTnGNbpYW5/sNa+r23XhYGoJ7LwkjswpeJpnB+igSufJGf4WJPAoTxuKNucw
	 xPz0F2QgIPjBnnCFec4B6MBx/8FhnG65n8KFjcT07fxAzGFjHH1sX69YKZMvwY7hJj8PM
	 5s211hAL0oR0YIYQooeZmEVr808FZYpq0WoUvETx7OEtzCIcL8lGjIjhTX5YWDAnEbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MZwHZl3N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4998F606A32F;
	Thu, 19 Nov 2026 02:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MZwHZl3N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98DF81F000C4;
	Thu, 19 Nov 2026 02:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055238;
	bh=y5P/Cju2m6MKbup37i2DhG9YAm5hiayAufqs69FNvjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MZwHZl3NfSUK5c5gL0vanrgtDhqNHEeEK3adycNdm/26ArCwPzHBWwrnNkFpoD4PT
	 V8NMHwQ2LN1Mbbn871evmOmL2HPza5p8cF48fkkPNv+oQD6zcJKfaVwlXdwBiMet8B
	 rYODSr7YRL8iR88Gsm7dvY4BOU3dvn9+3jdNOjkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1561/2214] crypto: ccp - kill v5 IRQ tasklet during teardown
Date: Wed, 18 Nov 2026 15:53:57 +0100
Message-ID: <20261118150114.521288787@linuxfoundation.org>
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
index 7838f63bab32c..e1966f43b9f7c 100644
--- a/drivers/crypto/ccp/ccp-dev-v5.c
+++ b/drivers/crypto/ccp/ccp-dev-v5.c
@@ -996,6 +996,8 @@ static int ccp5_init(struct ccp_device *ccp)
 
 e_irq:
 	sp_free_ccp_irq(ccp->sp, ccp);
+	if (ccp->use_tasklet)
+		tasklet_kill(&ccp->irq_tasklet);
 
 e_pool:
 	for (i = 0; i < ccp->cmd_q_count; i++)
@@ -1047,6 +1049,8 @@ static void ccp5_destroy(struct ccp_device *ccp)
 			kthread_stop(ccp->cmd_q[i].kthread);
 
 	sp_free_ccp_irq(ccp->sp, ccp);
+	if (ccp->use_tasklet)
+		tasklet_kill(&ccp->irq_tasklet);
 
 	/* Flush the cmd and backlog queue */
 	while (!list_empty(&ccp->cmd)) {
-- 
2.53.0




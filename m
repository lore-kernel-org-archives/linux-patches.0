Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048473;
	b=iTwcHbKZO5xmAUnB5TWV96+QP3zsmFDpA1Aadzd+CqWcC9ouIBEdA4OVcoeSVFJFo7XK
	 YRHaYISpjoYfpcH+j8pz3ozuXdUIeu224v1p7BxoS3SrWV8+28dLViI0ykgJNJMx/GI1B
	 nlv/RskqvuV+nN4ZZbpwD4O5RyUbrr98Q7Vmey0cKhOvE+GqSQuSxe+L4B2WkzmEV4WSR
	 Oo2vnKot1dKYP6JDEK5wOijp9yWbJREOu2WiL3bcd1EO0N2MwKCyuARFOx5TBj5KKvpcv
	 CGVFEm6FyLJiZnNYAoI6poolTCzMkKh/hN3DKquviOu4zDFSCevkuxZI1aZrgbnxYvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048473;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KjyDRFgpWdQDqZqYBmGzyEGl+gsI9IoWeo/3WzYgP08=;
	b=BX6FUiLjTlXu2C4dCeyon5GujgQy8DTbXjUxKsAt9Wj5yon05UmXLAcXNJ0jht71NQ85
	 0ZACJ2ehzY480vmJtPX3kSdeU232mVJIWt4Zo/3TwjnxrC6kaXeEa5xy3RRRs/b7M49Op
	 eHbZOY7qQPcx89p1ZKeaghzu3vbIloaE0T+EtErb8wnGW3ocvcCke88NQeJJq0PkprGsT
	 D0U8RYQ4pnMeXYJvtTjSOkkONzX3moVuFulExTbog2/MHAk0L1k7/a3BeNcgiYTQHNcCO
	 QcqLTlqjWWJYfIvsBb9JZYFi7sF0wkLbdvI87+j2fu6vtrhCd/3gOvdpVFeFCIhgiEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gadtIrjB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B09E0606A31C;
	Thu, 19 Nov 2026 00:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gadtIrjB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DDD61F000C4;
	Thu, 19 Nov 2026 00:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048473;
	bh=KjyDRFgpWdQDqZqYBmGzyEGl+gsI9IoWeo/3WzYgP08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gadtIrjBATaOCwe44+cQen+5SG7P9YcmdAt+1WN61tbgnNfpXdp5abBpiMLKygccg
	 Rgaw8bVaefoyT2libJPqhfaONS+Tprk3VOB9L8wNf+rzsFVgTNVgs1upty978WaHlF
	 bLz8NPUzCoJWyd42MIvPnwyJT5p2vCh6YAwpU5Ew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2007/2857] crypto: ccp - kill v3 IRQ tasklet during teardown
Date: Wed, 18 Nov 2026 15:50:41 +0100
Message-ID: <20261118150313.662321045@linuxfoundation.org>
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

[ Upstream commit b72a639bdee6e07d8091718ac3e451d9c5cba1b5 ]

On PCI devices using MSI-X, ccp_irq_handler() schedules irq_tasklet. The
teardown paths release the IRQ but do not drain a tasklet that was
already queued, so it can access ccp after the device-managed allocation
has been released.

Kill the tasklet after releasing the IRQ in both the initialization
error path and ccp_destroy().

Fixes: 7b537b24e76a ("crypto: ccp - Change ISR handler method for a v3 CCP")

Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/ccp-dev-v3.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/crypto/ccp/ccp-dev-v3.c b/drivers/crypto/ccp/ccp-dev-v3.c
index fe69053b2394d..e85b4ded417aa 100644
--- a/drivers/crypto/ccp/ccp-dev-v3.c
+++ b/drivers/crypto/ccp/ccp-dev-v3.c
@@ -506,6 +506,8 @@ static int ccp_init(struct ccp_device *ccp)
 			kthread_stop(ccp->cmd_q[i].kthread);
 
 	sp_free_ccp_irq(ccp->sp, ccp);
+	if (ccp->use_tasklet)
+		tasklet_kill(&ccp->irq_tasklet);
 
 e_pool:
 	for (i = 0; i < ccp->cmd_q_count; i++)
@@ -545,6 +547,8 @@ static void ccp_destroy(struct ccp_device *ccp)
 			kthread_stop(ccp->cmd_q[i].kthread);
 
 	sp_free_ccp_irq(ccp->sp, ccp);
+	if (ccp->use_tasklet)
+		tasklet_kill(&ccp->irq_tasklet);
 
 	for (i = 0; i < ccp->cmd_q_count; i++)
 		dma_pool_destroy(ccp->cmd_q[i].dma_pool);
-- 
2.53.0




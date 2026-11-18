Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029976;
	b=A42/2SJhL25sWuKxqw94IoAq2Lv0kdgn4E1s7Dr+jWj+/dyoEDooUZjlCVW1r32sjbDJ
	 J0X907qJ5sF6u2akw5ZLCMKKoPbzqvLq86trOdlTRw+kwRj5FwXO6KtdcBTqWY+y5IDDY
	 J6NMM3Is+RKxKBwl3/Y2QQFyNSRxO4w8edAPMIx/FbkBxvUpo0T5dPbuu5RBvbJQ3lnYk
	 TVebv48b8lvBES4ySQcUpWei7ni/wjAFuTkkNHlazfKpfMNpLaq5/vvjIVUXgXtvnhy2Z
	 F33IvXIcpSRUATgkAh7MHPOusyk4radZn5qyTCZYDInzUAg/bT9TXHQnHv0220AiSkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029976;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YhtJi7syA7OEuqFGHOaju3lhRbwvYR5SYeXUVFSvcq0=;
	b=oyJtQNUtJcZ3xvLx3yz2jH2Xha5aJXFHuFlG+EXdwkBUc+OYfFx8RHUmkdNeYYGl7N9W
	 f22m80dYV67Dvi8jOQs5gDuQEdq1ld47DyARvlsrFTiYLE++lMKPColhUROI9WVm2SUtQ
	 9PRK+q+jZAjJM2Ld3pjhMn7YfAzcG5RIwuq/IbnfcXCQQ6Hm7OYCzgBSrc3H3qSvCItiy
	 0peTzXPHDbPVIt7LMIqdiDaeDBUID7bB6DjqCFJoPU4t5jnqxoKXABuNDQpDfbi8P6Tpl
	 S7CzMvlP0Rx3b8ba3TOnhSkhcULA71994KgZY5B9PHyMCCX8nV1mMaUmlGxK0zyUYQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BkDu1OeN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 425D7606A320;
	Wed, 18 Nov 2026 19:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BkDu1OeN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97EC71F000C4;
	Wed, 18 Nov 2026 19:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029976;
	bh=YhtJi7syA7OEuqFGHOaju3lhRbwvYR5SYeXUVFSvcq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BkDu1OeNUV7tAGz4BFtryjuxIkYBQEDU+fiegz4EjUsTQjVKwFcRzHICBGK1o/QRk
	 kltC6kaeZMI2tGtM1sceSdAAqtR8ZfV34MK3JLe46X5Mukt0pdpUdnRETXuGpOO1Xm
	 CElZhoIAp7PktkkUlh/scfFnujxLJBOKdVltRxxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0514/1756] crypto: ccp - kill v3 IRQ tasklet during teardown
Date: Wed, 18 Nov 2026 15:44:01 +0100
Message-ID: <20261118150029.636015434@linuxfoundation.org>
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




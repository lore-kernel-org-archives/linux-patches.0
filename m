Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040015;
	b=uzYt5L81SguqXIPUSC6s7WPYfEhWuq7AVVlLPJmZucz6R4LcXSPwyxzH+8Svz5Ss/4TR
	 w2wA6++Jc87EfTrOsHObG+GrDrq7Aj4gdMKfy9mWas1JUK9EWwbfc7hzcFQdrcP7pb4SQ
	 8Eqefo2j7zKSrJNdcFwXrUuimQp/DEkZ9FwwYRcLCr3dYW9tWRmatOU6PILoYzP1I/R/d
	 Gfu8vRrjmtFtEaBeoy9ZNMxMoqxf6suD0pQNlW4Tn2UVA6QhfDOW5sATHA5U1lROSdBvo
	 qvmyICLcvm9cwZM3avF87PwXRjFu76GxmCBjXrngCXosnI0hbQNu8KzTX8ddqYwCZLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040015;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nxosLXTWSRU89jriFGCWFi02gd3Z2R2wdfbC8t6BlDs=;
	b=ZAalHooGtVzgyYYlru3+GIBLDzqRfmTP62PTsTUqGQQb2dEkejNmfuT+yALPaQksiuLr
	 2mLjHUJKC+ltTKIG1WlFbGBh7EQgqFw3G8amq/3/KCvM/cWgJCcxt4l7IU2i/ivZKHdD2
	 /zYrGgmwWvRTO2doNSDsYFARJxYhoJuADqmB6V9L2tcgvAgu4kl7F3665crnP6VS3Pc5i
	 qBsK8wvuWSHGMA+axlQ4AnrNj9zVEvVyKg3QKak5aPBIZWCGEnP+SgLE5xAoqTLWAlNao
	 OzagJVozvEKg6aC/AjV/zY+qnWqj76pW4movryJ3WqoyZFp0j4gtXj7JX5UASqGDHmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sN45N7wm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20764606A320;
	Wed, 18 Nov 2026 22:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sN45N7wm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 716FB1F000C4;
	Wed, 18 Nov 2026 22:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040015;
	bh=nxosLXTWSRU89jriFGCWFi02gd3Z2R2wdfbC8t6BlDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sN45N7wmzKaQ4U1kssM1vHSxK9/GGvlixhLbdE8NKZEkDQTzNUVLPx4EiKkHMUikP
	 aIM4CXiSWlF9BmdLJURG3GqoDp8Xh1aq4D2CksNM8LOxcovFvK6SVOlBk5/Ao2FWB3
	 CWok0KCodrHRLdiAIurxhTfOjaennQtGh+7Mn7j0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2305/3318] crypto: ccp - kill v5 IRQ tasklet during teardown
Date: Wed, 18 Nov 2026 15:48:47 +0100
Message-ID: <20261118150430.851703875@linuxfoundation.org>
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




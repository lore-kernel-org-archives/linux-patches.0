Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060717;
	b=Zh5YlDNOPGFr+PLgm1ZExJFOr+e8aW+mjAy/NDZE9d/Z1RebPq8qOWIDOSDLaEIIciZI
	 IOscGV9KMx5QHGUdaigfKTe1KsuhnMjiinX1ON1RqEdtMDuemlGj2y80IBDuvhnSReOvg
	 Mq8uvETYlwJOFGv4Ggbz/4yLVsYGQBsm3vmBNzeMi+F7qfyAOlBSKxH6yU0mVdhlOqXfX
	 YqAsPlwmTJxAJE9SXnaw5jHLIqaotQwzR+hpLA4JZ56DWDBlF0RHWxmZBlfscEAp3ZcTh
	 T5pgI4aMWjdbO5IqqBjgYo92DEcHjZlFE5UFw3VpxnwlRvYrOysM5IuxcMI5SaVSs/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060717;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8KWorRelt4gojibe7SOqa7Q8BlqXxkQRx7hzUQuZgl0=;
	b=p5rsmFa7YVzPLl+YFwndIZDMReklllU61dYiWRPFInnAtHJeyGyZeQUTro1l85hxY2l0
	 TtEPZNzqy56OQJFcyZQaCpbXI7p1ZAIZgyZWuZ7Om3WxCWnNMTu5sq3sM+04kYFaQEazb
	 yk30h2y9ABTRCIVBqQYwzGKA77T8jZpFtFZFwCgQAgfCaRssxFcf3clNyQDAmHcTD449F
	 gicZ731Ezxg6s7wVrHjRRieWyUcJLuivE+YjVX4LonIXK57HaMmGdUZN2r6N7gsDwVOQ0
	 6tgWc3TaNVAbAlCRz6631pq199Qxw+Ajfh0TERPgIjl0PmE8SqBpwkyEyGqGpb3rBdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WEohszD+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA9B606A325;
	Thu, 19 Nov 2026 03:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WEohszD+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BADEE1F000C4;
	Thu, 19 Nov 2026 03:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060717;
	bh=8KWorRelt4gojibe7SOqa7Q8BlqXxkQRx7hzUQuZgl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WEohszD+hlwbEchvZjPZyxIVCNg84+FeDjlF/Z/v032yPXY6clf0VUdcgO/Ums98j
	 L2kAwC10ejoDLiBvl40hg4dsZ3AhYEtTEdWtZP10KtyNLDCNb+dnlCMlX0aWexRq1X
	 PX2XmkNXAe8YdMhMQTfCTGnRIUB4zV+kxMJleTf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1300/1848] crypto: ccp - kill v5 IRQ tasklet during teardown
Date: Wed, 18 Nov 2026 15:55:38 +0100
Message-ID: <20261118150013.931044332@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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




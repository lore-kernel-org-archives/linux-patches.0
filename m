Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024161;
	b=p1M9MGA8qNzB8HtFV0bPOS9uU2XPaqXru8uIncgRk5h0S6Wxa+vvEmr95mMcr0MZGSDF
	 0MIgMlm/WajDiEPlgZgiWi6riPtXmMej5Ig5BXtr9wbdsTCWofSil11XT0DCQp5u+O0PE
	 0FDoOUPayTc9ZmK7Va1BsX8eik2RGXyKYApxaRIFuAfZwkekB+1eXM/hpkBE5icLLnQCh
	 /W57/RvAuguAfbMaPRcjV0rNhgAnwS04ZAqeUtFs13weVFSWVNRwJQsMfD9Zp/GLHA5Hp
	 JZ11wak2RwSWu4V5Yoe7u2hPjxurPlm1pKUftPiHCd7yrig6Lki7zKnDGk5im/SHWeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024161;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KD8gRHNuMYd5brgqqWxPzoomaSKzNopUX2KLGKC0t88=;
	b=y3NaoTFyl/5JLYWn7cxosjYQFM+kgfgugK3cSCaBeimlaxAb1HGk2fRueyvlahi+o3u3
	 369yXsb5uAmGGZ1ustNyu1YiKnz2CxCwV8JBnl77hIkpLALGeccNoxUDhIQmSD02uY9AG
	 9+nY/xgp0BzG3Zi2y7OTAFzftbtWpkIv1I38fbA8w4xPSTFsMQqKt0vw+JXj1wNNKkM4t
	 hxMiALJtqYVPUnKqHO+qYgQiDPU8bsLgNreE3aVUAWireekF4JQm2siCJjoCojw9Lr2Kf
	 xP2PCuZgQb29aGX/oCIWUkAr7kwPegD5jGjGfWVbzqZ8aHt7N9I6rkLLSm/YzRhSnlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NXSc1Iac;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31F2A606A31C;
	Wed, 18 Nov 2026 17:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NXSc1Iac
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C7A51F000C4;
	Wed, 18 Nov 2026 17:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024161;
	bh=KD8gRHNuMYd5brgqqWxPzoomaSKzNopUX2KLGKC0t88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NXSc1IacXbrsp+YPzHcxdqHSwyb7L0pBitwk/+2ZVHyzpuoPdisUzC+vCk7Qln5Vh
	 W6O1MQy/UugOq+ynffYjU3T49RjEqOgp9bs2pZ7f53TZgYO9bvzagvA8YdIHSk5+u6
	 H/h+WjI4+eeYhEmBwCQhL+yDOTTk+CvAkuetOpDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0627/2151] crypto: ccp - kill v5 IRQ tasklet during teardown
Date: Wed, 18 Nov 2026 15:39:22 +0100
Message-ID: <20261118150144.737512412@linuxfoundation.org>
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




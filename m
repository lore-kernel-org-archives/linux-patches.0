Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060714;
	b=ufUIzyUHepGLGMNra8dK2oi6f27Om1E5w9LpbVctJzUeMd9Zx/BcRc49cwAGpoHeVwLH
	 rGYvkBNx8F4herH6kn3QgrFp92Lj7DjGZjh3IHZNENcWo2JwhZiB6e4PB3CjbJ+5ySthk
	 dr2stX6I9O4Pd1AxN4J+Yjl85LIU9ZglvCBv334GawZ9VlnqECvzuGzm/JFYosP7WxJa0
	 xczhNhLjBPbJcVtQIi2Szt0UnJCZ03ywEqeTlFrcWXihjmLGHC5xzgnmteW7BX7HHIczk
	 xKnbnK7MFyMmPDz4FhWGAZFVqiFzGj8x9F0DZJCKIqC3G4xHKgbcNm6r4TFyENw4eVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060714;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Pr158sekw0OT273/0MH4ZpWFBKpO+fIp/Gu5z0dK0E8=;
	b=QtOlMoVI0qBVa9bweiUDL4IISlXLHLzH1Us3/RP0P8IGtlqWhrZKGuFoTzA2hoKjtgRg
	 Xf6WulwPQhJ2dwyWRU4ac0LRDCwbaHgIsQvplsz4UNTisFsudQ3KuvnKgedLekAOj+9yP
	 wdn00a+lOHuyNSJtM3FM9xa1NEDbZjLPxi4uNqNxsW4X3ooGHMixiwM2PKNays452ZYhM
	 2d9A791voAjxWGSTEDyfjbqvlDCRucHFXZzZx/nKoJOC0MnUasExq1dduaWyx1AsPPeZ8
	 ev1OCePVNfkWTGO7HVSx0J4W5K1fBC50QSMm2mdsyX0Hv4mVf9+oc8ytN2dGeHz+4Mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n8VBWgVU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F40606A320;
	Thu, 19 Nov 2026 03:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n8VBWgVU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D78DB1F000C4;
	Thu, 19 Nov 2026 03:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060714;
	bh=Pr158sekw0OT273/0MH4ZpWFBKpO+fIp/Gu5z0dK0E8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n8VBWgVUxNk7Nt8EQMWsmohPnRgPFrBCEqWpUJI8t4K2LXmi8Xv1rFt7K/RvMgIFq
	 rf8tqmirvKD9qTKOfLhIHAF3O54LF8aT1awZoHaJkl/aa6P+Ghhm2oA6iyy/umpcu2
	 mOqUy/CRKQzh8vDjHDZoNbru46zsS85OzoUM/K40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1299/1848] crypto: ccp - kill v3 IRQ tasklet during teardown
Date: Wed, 18 Nov 2026 15:55:37 +0100
Message-ID: <20261118150013.895225659@linuxfoundation.org>
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
index 0d5576f6ad216..b3d12f46aedf2 100644
--- a/drivers/crypto/ccp/ccp-dev-v3.c
+++ b/drivers/crypto/ccp/ccp-dev-v3.c
@@ -507,6 +507,8 @@ static int ccp_init(struct ccp_device *ccp)
 			kthread_stop(ccp->cmd_q[i].kthread);
 
 	sp_free_ccp_irq(ccp->sp, ccp);
+	if (ccp->use_tasklet)
+		tasklet_kill(&ccp->irq_tasklet);
 
 e_pool:
 	for (i = 0; i < ccp->cmd_q_count; i++)
@@ -546,6 +548,8 @@ static void ccp_destroy(struct ccp_device *ccp)
 			kthread_stop(ccp->cmd_q[i].kthread);
 
 	sp_free_ccp_irq(ccp->sp, ccp);
+	if (ccp->use_tasklet)
+		tasklet_kill(&ccp->irq_tasklet);
 
 	for (i = 0; i < ccp->cmd_q_count; i++)
 		dma_pool_destroy(ccp->cmd_q[i].dma_pool);
-- 
2.53.0




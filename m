Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024158;
	b=uqtO9tLUxngfwPs5tnDctyvepHR6THlPTEbV2V3/tpW6wDooxC1NHbPhLPYUpUA0ZAK7
	 oq9qfLVFOw1O08jG2mN8vGTa/9OIFe5O174ZlCEzakmkZnMno1pmkzaZlNsNR3i8ACFyu
	 lafVvme4ah1VT5Zh+UWwwIPjFth3pHXOkYuSqW4J4pRnCcdQ+Lnzzyb9Obxs1KRBBakw3
	 SuYlaHhCf/wM/iPNJcnqL5ftyuwOKy8qjMc3Tzk/iPmouOdes3czZJUHtbpW6k3YMarB5
	 MbcAjTg1F41GAisX0s2+wCAyMMIwgd8fXgmUl3XeAzswiIXMQJcfQRFqRuFPx8pF1TA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024158;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2gq4WGGT6xxJ1/V8i47MMp9pNDcFBYJrrMMKmteXr+Q=;
	b=kX9AOZyz2LU2YqrDn7s+Sbe15uATr1hvse7U4erpGsKglj5o0FBl5fa4Hz/fy1KybJko
	 lJ886o/rE/iQdysKZcPtjRUDBE8x+9ZY+VypBK7hqggW8wSzNGjeDgPHIj8r51vkGKJeu
	 zlrw26B5qFS+fs4N7hU6aohq63mN1XxK04JSie8X6vDTgWHiRH5Ggm7NkFFF9aolOuofB
	 G/nxohuUp7L/3MEoZghzthSDnfid6YpwOPVBfeAgJRl4Nt6/szrokS8awIxT4+G9mRjhH
	 VDH16gWssP3SfBNKbpy1/KXQSQR4Q0suphQUfgoFWGzbCh6J/OQV2vL4CBzCqCD8kSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rVeh+G3I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 809E4606A320;
	Wed, 18 Nov 2026 17:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rVeh+G3I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2E701F000C4;
	Wed, 18 Nov 2026 17:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024158;
	bh=2gq4WGGT6xxJ1/V8i47MMp9pNDcFBYJrrMMKmteXr+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rVeh+G3IhpDnb0SHdNq2cAfKh0pjU6Hw8y6yswMRm++XZqLmA6NsFIzHYzo0/qGT1
	 Unj8UjQ/qmAb7jiURhvBZ/pmsMXB3uicA1F1spdGHJHaJlKbcKQ0kBHYHdmlhSUYLB
	 AzmZAbTQ0FzG+Z94JLynEIxIylfCLu70KwCJ5xU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0626/2151] crypto: ccp - kill v3 IRQ tasklet during teardown
Date: Wed, 18 Nov 2026 15:39:21 +0100
Message-ID: <20261118150144.708166562@linuxfoundation.org>
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




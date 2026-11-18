Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017025;
	b=N0rC104K8n1zAI6Vh/vdVyML1CicHbH50gbEOSs0e6b5LFE4z/nnn1C2DqG5GiLYiJVb
	 PzCyfXcIdNZtrPAn6cIyW/EaaftQ7kEgqbYwI8nT8xN5jRQ5wCavkMeblsZhRehvu7mHW
	 RvjGEx71kzIufFByvDV3RrCCVSn5mavzRpoQLfjjiDZyNVUN4VHFddsamVV+NhdaQr1/1
	 xkR7WBuQBU8PMugUboqxMnu6JMCoyI9mXirZXllddVE+jzvUR52eAzFKrZNiCcqda+r4X
	 nCgBJo6tv9+Ftl7nY5jrqZijsEANM8WLfEpGIDXZ+uI5ylcTVVNBh+9+TINDQtmJdPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017025;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T2epQPFKqJB7GlBzoTHqHF6gK9NRr6tXiWZKQR083mM=;
	b=DtDKRsUsDtKvjNvIwbQuMMn1QF9jsu9iyLRzNGKNF7OjolozHwxEe5qz3H3Jnsul1iR2
	 W7VCwSmu9/HD/tqYeETVmofxHzYmosZuTX9FsTnDNDxWKUq7O3RDohavEoXpD0p3I3+KN
	 jO2u83QJaPtz9/Sf7Om0yZ/uxs9RgLX80rJTERvYzGFq5cG7ugWVxaPwBmNa0r280HwdN
	 /mjK9qAmQhDjjt+DC20RTE6e25LNj10PeyF8/ZknKnUinaKNYPwF3MwBsoJ64b644i1dB
	 reeBiwzTir0bRH2Rj/dR0OMPyAxHqq32R9j7vKv62UQigfFtRqerhPrw92Fxk25kduA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ENIzMC4Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B64606A320;
	Wed, 18 Nov 2026 15:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ENIzMC4Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B1FD1F000C4;
	Wed, 18 Nov 2026 15:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017024;
	bh=T2epQPFKqJB7GlBzoTHqHF6gK9NRr6tXiWZKQR083mM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ENIzMC4QxPGw/FyxXGM/Icafk6+dya2lB1PM0flu9e3BO0fv/opsxyOtxYoWhyiYr
	 8ZfH5Sby17YHM04MWd5v7m+5c1Nl7LnkShf8fohPWqq/E/bvDpkPqUIzWfl8HWqkBO
	 cEpbvfI3JSZAj7EIKIlYnmUQaqw3alLadG2SsFJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0697/2651] crypto: ccp - kill v3 IRQ tasklet during teardown
Date: Wed, 18 Nov 2026 15:32:17 +0100
Message-ID: <20261118150312.932045539@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 60a133e23e5f5..d92de4ad31ac5 100644
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




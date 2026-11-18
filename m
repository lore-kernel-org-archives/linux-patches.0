Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017028;
	b=ihjClUcxnmY+glirz02lznD986/vyA2vKPk6SdYb4jYEqHwJ4HAhaS+JzfVl+JgLTwWp
	 sANYNhoqXhKGSS61AwOmm+mLEs3Gc/GuLwL6gDqPpSv8sKNkK6coVUyYBJcCol3BFAtsn
	 jem3P44Vi0ftBS5J1UIIcvwCsi5gWWftgsFN3W5GHVpscwIqszKRLZoBVhk6fAL990Lk+
	 29AcBJavuszyhmcKyGDRV+4/twLGt5HJgMRqLqU8jOaTsLb4j5raTysFa2H1/OuKqIrpG
	 Zk87dzgQFEtoASgme6uBBCEBX3WQrvBDeZGKfXpeZ3OCxxlL/+VLwPzOEQDLC2ZPQIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017028;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7dJw6UiZxmOMW3ABizgsvA4PnE2DCGbeM0sCDqbuQNY=;
	b=V3JgvQ7gTLG7gq7Ho3SfNJsivRA7pkL/y8c+kAKy6b+niDoIyBT560Mg6FWIKKo/MpCa
	 OXXwjKvdY5NcjO2BFRpp6pBSx9dChw9QDDxoZ0tnbKQeVfeuJkB0L58aUVAkLvu18S8kq
	 WsgqkdivDVdF1iNj0BVb7v2fmdlxw5GmMvgx9NJwvWkeJwoO+Qeuefm23/phkFZrDmaWP
	 Aaq+v+19PUjfBxHKd0eSBq2uRW+wlQHOP7McixqJAyubYeBV7sOTJ9ZAbqPlU4riS+4O2
	 pEapmGhcSBrvim/12uX6O7Dbjk4sjV0YO1BEZyz8sT2g6ENBUrnSmX8AonEz14uTMLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="I/qpZINF";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC5D606A32A;
	Wed, 18 Nov 2026 15:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I/qpZINF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 390971F000C4;
	Wed, 18 Nov 2026 15:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017027;
	bh=7dJw6UiZxmOMW3ABizgsvA4PnE2DCGbeM0sCDqbuQNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I/qpZINFU/AGn9sJjtU2Pjca4wP9+hPer2tGAG2iDE0nsKv0M5CwxQtGuYso5EHo9
	 9opemLR6Hc2vQCX/qTQpDmqQBuEs1V5+m6BEfLXhPh70l9g+RY++QBnqEMpk2/Tp/S
	 gzzSbzcIAr1cTWxHHHhRJjy29xfqpg2pza8Fu5BY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0698/2651] crypto: ccp - kill v5 IRQ tasklet during teardown
Date: Wed, 18 Nov 2026 15:32:18 +0100
Message-ID: <20261118150312.964614920@linuxfoundation.org>
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
index dcd6aab51e476..dacde9614e8a7 100644
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




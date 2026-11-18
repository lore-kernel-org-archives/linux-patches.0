Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030009;
	b=QFN6HVvXksbGV0TkKtkFRGT89kD5Mp2pi3rG0Af+DOtbTzWmCQLGFPPnwyO678gJPany
	 qJkTXX8ATYhUTAW9kftKpf3kOXKU1AdNRHdxqh06a/B69AeYRx+WSLxxejNXnyXHMJQz8
	 D6RazbxTXXdXZWb02r7xSwd5zEMNKd8AoKjfK/q7+Fj67+pxKTzO0pY3aDMltwo0n245O
	 NkXWIL5ezIyf4HLrtyuEGr3Y+ujmhlZQu55f46g9C4YFmp7SaNyws+nvHeNprL1/NERCn
	 wotLgcC8yLRyFDcqk9f7OBj1xbwoxiuub6jOddYmykBgokQluHshR09HKcZBcWsK/1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030009;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gMwOInc4eFfxqirNtyEfRjPuviHl9TWGVoCQqQo3gRQ=;
	b=qjcZaELk0kPvzzeFgxN0uywOyTD8ExxT+3X+QDU5cke3iQ47vN6/d0ko+9xUU7MBKT1I
	 VBVgyyJVlW68ciIObMNHyQ6pxCTnhekl8M0aBdvsJYdu4klHE1Z4qzlCD2JbjW5Xnh+pU
	 MaqnnNTx8Jj8My4Ix2Fi0lflFB/NBA2Clor3xea11ixU9waALwfsUUmoOgIiyfvtxjL8v
	 HINELZsZmB/y5aoxaSuYgV0/i3XNlmzUGDOqemU3YT9H1NC4sy+S6ZdfGFfNIfr3JhoFp
	 bGAbqLFBRf1+57nUgBnibO7mYRy2Ce1c+C7WdVaPEA+jJW8hX1R9ZHc8ff5IhC+IqDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DvBpoZen;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC1E606A31C;
	Wed, 18 Nov 2026 19:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DvBpoZen
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D83A1F000C5;
	Wed, 18 Nov 2026 19:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030009;
	bh=gMwOInc4eFfxqirNtyEfRjPuviHl9TWGVoCQqQo3gRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DvBpoZen4h5teJT/pieaYgm3lJsAuzvUioiqkKlTZD+K24tOGG4Wi1G925wGrx38c
	 x5NYagkvsokVOCzHAFuspLvFFeHVvzgFGq5BrtwPWNd05OrYUGI20EoQWk+P7t1/2f
	 5HFJ29crAa5fI06t/hL+BuVsoQ5etMy0bV+xa3E4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0515/1756] crypto: ccp - kill v5 IRQ tasklet during teardown
Date: Wed, 18 Nov 2026 15:44:02 +0100
Message-ID: <20261118150029.677105370@linuxfoundation.org>
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




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040012;
	b=GdQfg3ThLiDbfCOy4P1q9IsNLnxURCL+G8XINV1pl5hhGLQ86+ZrkYxizls+rpjzcsn3
	 okL1ODDKRrH84AHC08X7orYTnvrWGy6C7K5qhZguD8LsyScd62ZwbjXnvsEhT1aYcQ64y
	 tnIhZzlaHBDLV61YDqR2w1CUMb3Yud9jnFMUUJswzS+cmVkiAm+qrGhbcl1+PoCJShFUs
	 +hWVRYk3auLt+8smKj6sC2GaTBL1sdDD1NKurJPx1ahiwcnyy/ZL5qWhajqtSUBVNOkXL
	 5cb5aBHzwsx/kq7/ZcqM4Y8U3b0GmA9uFbr2okk/uytBfYz0uJ6Km6z0qdnRyCUqUJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040012;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=equNl/+RepRMSi07ZtnaS6IZ06EMwk4YYhDjoS7J6Nw=;
	b=UIWnVWKtd9QOC/gr4pb8KMYZX8M8ka49nzpM3bsug7E/NysLE380ND1+kN9shgPB1k4m
	 sUgYMqtAWpX/2O9fOtqLzDrwBJzvV6IfS9zbAPzeYqx/Dg+piNyZ3Wc7aMiDhLZzTrdYJ
	 WGgYo6nBKu7qbaTrPRSB+UftfGza4hvSnoPzemSrB4hDnmQ7ivHZ5X+SMZV4CCEB9LaZP
	 GPEMKuk8tOgO6BacNY1S0fM1LTLDW2b5IqiEJSchpfFRN0h9uGVoJjexhjQruoWfVRxyj
	 91Sh8BJZeZ5yQ20ez32ba7sYvsru/sC/PYUlzeCt5/7ok0wg2zusNLmxaNozHAHlv6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zUppQgA7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B990606A320;
	Wed, 18 Nov 2026 22:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zUppQgA7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A14221F000C5;
	Wed, 18 Nov 2026 22:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040012;
	bh=equNl/+RepRMSi07ZtnaS6IZ06EMwk4YYhDjoS7J6Nw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zUppQgA7llsLN6NIdhaixW/ckpGGdzk/a5PwptgGwxf7eWAh+qrH6ioPwVIsXLSAe
	 TH1IckPMhwTLCMpRJVPReytQflPYj+r9O+baqZw50vOpJDxYFHrs/7oUMnYDkYgM6j
	 Bx5aeYx39UdZubRGg6TtlEl844d4glTPg6FSoNK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2304/3318] crypto: ccp - kill v3 IRQ tasklet during teardown
Date: Wed, 18 Nov 2026 15:48:46 +0100
Message-ID: <20261118150430.823543968@linuxfoundation.org>
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




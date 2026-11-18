Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055235;
	b=yoYEmXzQ0iiPvvvmNUijW/ImHcIKc/KgBbQGTXFpOHWhn2/crSMJvcfoRy4lrWgwUo32
	 kLBdCgw3D0GG0IBBYZpAG3uJ0R4MYk5FHDcl2u+/anothdsR6pO0ozEqY2T9TauYEFahf
	 A63V+lBG0Q+fMPwvsXMASKvD2AN17H5+loS5G0W529pDDXhEdvkddMxwo+hw77zoZNeum
	 NHVMi2aH9lLiiJ3rKCTh9+dv7lVKMYvfKfIEa1F0zMm1lIyYtmscxptzdy61wVR2igpHi
	 A2qLHW89gmna9uoSbxc8Lc3x3Uy2srgYQQXGRUqtDhuL6qN8zWokGIAsgFW2UMIFSNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055235;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QvCZp7HmW27e8eRkdYlRoKCWkaRm3m2yhp/nsqmXLdE=;
	b=V5pVED2522l/kXoIy6fUj3j94KL15uYMylTyIfvE2N2/0hvXLaMUxRSFYmA6Aflxgv/w
	 oUxYzVj3+nupjRsYzJ78BbD8op70zSSItUMUJVmaY5HtjzA1D6qfy8ZfxD9o5imSyY6oq
	 I7f8dENxFJyObaOk/gxudPwURye/LOtUjN+1MIefbiFHwrDVq6bzywt88FwyXUUnyA0aG
	 c89o6SSGsmSpCNgergTmMqxZGG4WG8CA2txr/xK1wA/lVrBZFjZTf713KCffJMkV7IlHO
	 hgw/yxUErbZ1rZMjW/ySliGqxbd+OH0sCQzNobAwLx7XPIHrp+DvkIFZgn8Z+5zA+TQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZUUnKxvD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68887606A31C;
	Thu, 19 Nov 2026 02:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZUUnKxvD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C141E1F000C4;
	Thu, 19 Nov 2026 02:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055235;
	bh=QvCZp7HmW27e8eRkdYlRoKCWkaRm3m2yhp/nsqmXLdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZUUnKxvDLUwMIkU1kRxVpugvRkGOoX9J0XNCYJXt3yVaJm3ezfoCJF2TCCHaKrRSO
	 03YEU6Be9GFDpV1kURoiUoE/3H21N2O2bkh05QQ684Qjuesbi7L8o8nxefZ76gZCmp
	 4ImjPNzPHJN3x09t9/J6kbPLuEiLefxRaYFCScdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1560/2214] crypto: ccp - kill v3 IRQ tasklet during teardown
Date: Wed, 18 Nov 2026 15:53:56 +0100
Message-ID: <20261118150114.485730535@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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




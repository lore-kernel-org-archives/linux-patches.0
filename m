Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027708;
	b=5bGfK5AvYMUt37wDicyPiQo46Xogd0BT0QHKv3OHHlDKgEYPUx5QP0a/F0sFwT5tvMPP
	 ZKynrFQakHktVjJeiGKC/STiJ+qnOX5kF5Hou9rbosxLlY8tkUfje6Mt9idaeZHBDfKIJ
	 tkh1fPzlNlPhkXUu7VKsp5+4IPfxYpHDAVaAXPO3G1c4wkRuRfTFGWzi4hvqF/nDcYqMt
	 dnnkv5LEoTMTRmKd9xK3VY2squhS9/WHxZKhPigRuFbPrZssF+koZf8ANb13GWmaQqlhT
	 VK/yIcJS32cF5i+zQikuGQSUl1lU04ARos76TuvCVjKEyXDpEnkNBLJMToe+CAfmA8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027708;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ox/g2l/UFnlxErRUsgiIzVI5PBqw9U87+82cWKV8GoY=;
	b=Ze94AUG22RjUaYSFoTmQEnJllc2AYTkeVC0SPCkxa18Uh+uyN3sNwg4pvXaOiRZsluTG
	 Y6UBGRblePZCBrmBvAP5mmYnYwhW7ZLK/PyYZGJ7psPmFOGDrNbVFXFXhW627Ny6gLnAv
	 QKzW4dCGTiiwSQXUDJSHsVVOGuZqtpmX+c4aShP0xGRZKIMdvYp8+loQXjyD6m/eNLhFa
	 rSxihWXDKldMuM00c13ONEM2BPMMyoGGTgK8qyu82+gTPq2/ZrS5zx6SlNsVf2agIy91+
	 ckPrBwIq4alWoO/33yxojHz2NAaAonCzNJcPj21h7P1dURUmBvm3bQZeYiSdtMEqMFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R5uczzUH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C1F1606A33A;
	Wed, 18 Nov 2026 18:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R5uczzUH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB81B1F000C4;
	Wed, 18 Nov 2026 18:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027708;
	bh=ox/g2l/UFnlxErRUsgiIzVI5PBqw9U87+82cWKV8GoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R5uczzUHoHsLXgTR4mginyrzeepy57LGgnxD9g2OfgCIOWNKCbZd9ml3zys+UohDi
	 B49r2gYGe4HxW61AUnRuiu8EJCRqG7Kkbkh7FtEixVqSu3AoARnSIauUzR76G//jrp
	 2ko8820jZk1nT9CwLnzFAKe8giKQShjYDvagJx7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sivansh Gupta <sivansh.gupta@oss.qualcomm.com>,
	Sibi Sankar <sibi.sankar@oss.qualcomm.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1885/2151] mailbox: qcom-cpucp: read mbox hardware register using readq()
Date: Wed, 18 Nov 2026 16:00:20 +0100
Message-ID: <20261118150230.463933980@linuxfoundation.org>
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

From: Sivansh Gupta <sivansh.gupta@oss.qualcomm.com>

[ Upstream commit 74f1cf02d9fe0fd32ca299cd4d71bc29d3bf2a54 ]

Mailbox hardware registers are 64 bit wide, but the interrupt handler
currently reads only 32 bits with readl() at offset 0x4 (upper 32
bits). This returns an incorrect value, while reading using readq()
returns the expected value.

Use readq() to access the 64 bit register and pass the expected value
to the mailbox client.

Fixes: 0e2a9a03106c ("mailbox: Add support for QTI CPUCP mailbox controller")
Signed-off-by: Sivansh Gupta <sivansh.gupta@oss.qualcomm.com>
Reviewed-by: Sibi Sankar <sibi.sankar@oss.qualcomm.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/qcom-cpucp-mbox.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mailbox/qcom-cpucp-mbox.c b/drivers/mailbox/qcom-cpucp-mbox.c
index 515d2d12c01be..b88ea2527265a 100644
--- a/drivers/mailbox/qcom-cpucp-mbox.c
+++ b/drivers/mailbox/qcom-cpucp-mbox.c
@@ -61,7 +61,7 @@ static irqreturn_t qcom_cpucp_mbox_irq_fn(int irq, void *data)
 	status = readq(cpucp->rx_base + APSS_CPUCP_RX_MBOX_STAT);
 
 	for_each_set_bit(i, (unsigned long *)&status, cpucp->mbox.num_chans) {
-		u32 val = readl(cpucp->rx_base + APSS_CPUCP_RX_MBOX_CMD(i) + APSS_CPUCP_MBOX_CMD_OFF);
+		u64 val = readq(cpucp->rx_base + APSS_CPUCP_RX_MBOX_CMD(i));
 		struct mbox_chan *chan = &cpucp->chans[i];
 		struct mbox_client *cl;
 		unsigned long flags;
-- 
2.53.0




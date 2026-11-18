Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032715;
	b=WzP238WkdGCjKEHXBYKnAdi1lAgpqOYdY/t/pbtpE+LX6SIMYylbXRiSHk+PEaoamiFO
	 Ljg7Zdd8Q4gW+kZ52dAIEhSyAkRHFqT2+dMUAXDj72/ItJUtSU+yueqpvJb2W8qczdlAu
	 TndY8wQy7i37U4E2P0LibqvT9xXOGWaixLSkUbNJju6VxhHeYrrFNi7s6XHmMe6CM5NEB
	 siKLfIQwtne+ZZMDcM5CHqPdns/Zs/ZpUoLmMV//ambSJIscX2cUdMnq9+EPlDBRAkPgK
	 iXX7294GOxCI2FNmP5+LRmsCdIwtnSCta7AjEv6QYIL2cXeDTcPF3mPfYYAimZssQ8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032715;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hsoNDJwW5cexEC2aITL1UNcxL0De+8mlZqU7AVQs58k=;
	b=P335DX6y1FPxXScm3pL8LhetrAYTNlsfmOF60dwcnT6UjmUaLILE4Bs8473iwPFL6n/U
	 2iwUv1OAxUCB34ZJlboByDL48kVQgpwudL98zRMKYovEj14iZrrW1epEFJn+llQeT595N
	 Ka7/yO3YEU6T4VzrRmjCvE2E+sJdcSsBT2C2iuErWvH/3aYPCiGcDuMARazClgW19f9Tz
	 wZLwP/ZW5g5164F+GIlC0YV7H0IeTdlJA9lKi38iYB/qWSeHGBqRE15smBQhUuIeiffvS
	 /x5gCj+sY3Qu9W3KqvlNQh1Cy77aWEYpNc3YMtRx76ROzGgyiLfS6+oVUoeeSpqQarg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YOTOSXAL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EC24606A33F;
	Wed, 18 Nov 2026 20:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YOTOSXAL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D9EB1F000C4;
	Wed, 18 Nov 2026 20:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032715;
	bh=hsoNDJwW5cexEC2aITL1UNcxL0De+8mlZqU7AVQs58k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YOTOSXALygzVOybcbCfhOGHeBwSjG7YCZWGC3/0092yqnY9e/a5iIPbdlqcU6wXPy
	 R+f8VVKJInInNkT7Zr5/bmFzfq4d+5htIyxeFc7ydjLVpUIlWTq8Qv94FlcRohgHWS
	 sWCUl8d3IrIBcG+OmWNg2HuLYRapsq0c5Z3FI1p4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sivansh Gupta <sivansh.gupta@oss.qualcomm.com>,
	Sibi Sankar <sibi.sankar@oss.qualcomm.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1508/1756] mailbox: qcom-cpucp: read mbox hardware register using readq()
Date: Wed, 18 Nov 2026 16:00:35 +0100
Message-ID: <20261118150108.938984976@linuxfoundation.org>
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
index 298b357c0f9a6..7e11ce4f16e98 100644
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




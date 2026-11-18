Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021511;
	b=WbmqMQXSc8WEPaeukYGUfo/DPxninGdPSuLemgKeZyTGvq1oEYxD5Zs7S/m3AeUywV4N
	 i9jU/Y5C7oen0/qNzcm/+h/VqoZ4J/Ruc5RAoIMOkzx91yWO/3QUBx2ES4j0/P4sTf9hT
	 XDZR/7R3G1vrZwo8otAYt8w3XxB9qBi3pOIEmjdAAEVsQfymEn45K1VJ0bwMqtv6juWgq
	 9+xG2anYMVhJOK6oOo4NqUEcxu21kGfNKfB60rLuXinkNtfaogbmEJ8WcccwJEDpTGBIR
	 AfVI1aBRrfynk2heA/IvQiNRLRI+ETUOGuMh1fnpy6x+OLMLFt0diF5wNGWV1GWFG2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021511;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Td6KndiyakhBSI0iRmm5N3RU7gp1SjoX1jlOsOwB8qQ=;
	b=1mvJ/Es/Av+ruFkINXa0BLdenTFdVO8G4jofB9PuKoH4TDXwNm5xYa49nWogv5PBgLKq
	 pInYpG6hVtffmim3E1fk8p+OJiK1MSdfJQy4kI//U2y1nElzpWoiD3vuEBrBriJYGNI+I
	 M66MFU3ZWViLGzbsGSBHqjujCje3CDAqVvmX08Q8WsxcTOMEwVKu25BVsfomm0zzclR7W
	 OT2NxroBxfDTaOiq/1ouAKHbAe5j6E0KGOdVZvslsTVhqrHG6nrxTqTAmOMwbiYRbVGfo
	 Yr0x3D/IhlvPjrgRjevSCgUot17Gne66r8FBjNtzC44ol84TO+5If9QUh52KpUgzH8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LgEmxRBD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 753AF606A320;
	Wed, 18 Nov 2026 17:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LgEmxRBD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C94301F000C4;
	Wed, 18 Nov 2026 17:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021511;
	bh=Td6KndiyakhBSI0iRmm5N3RU7gp1SjoX1jlOsOwB8qQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LgEmxRBDwafxj96hPE3cA3qWBFAiE+LALbP9mbrnuwXio7cVkmJsp22lJEhPpSPoq
	 /t4R2DA4iaAePCaQG5901TNRV+9J/wAtt1kVm5kW8t9HzmDi1HHCKnCApJ9czuXzjV
	 pN+92OcDW/zjxngI/c2TWtw1x2MBj27aUrptshuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sivansh Gupta <sivansh.gupta@oss.qualcomm.com>,
	Sibi Sankar <sibi.sankar@oss.qualcomm.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2334/2651] mailbox: qcom-cpucp: read mbox hardware register using readq()
Date: Wed, 18 Nov 2026 15:59:34 +0100
Message-ID: <20261118150409.145973006@linuxfoundation.org>
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




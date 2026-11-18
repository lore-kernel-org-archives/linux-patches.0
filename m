Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053853;
	b=gUI7g1pSylzCn1v5hdPMaaIzpzvCIaWWgprYLQG6tTPLs2hOCg3PQcbRCLU1Ys9EdRDm
	 M+bVNxfxGhWBtLbcrYhGwCfZpsUpbzgJo5gih2wzU9bXvErO7wA22mZOYubT7vzPEywUs
	 FBkXW/1U8EV/TwNlWU++DU6FsEjl2JBzyBIAmeDLQhLzv+dx+Bh6ll2t9DAnqmAKBBp5Y
	 5bmD/kga/VAmdvivJuWGHiBuV8x7LDaB9We0um/3mBS20ZVaXFdWs3oivHyS2VS81K94r
	 iM1yikckOTAlbQkbbBQN/B+16LRuLWVxHyIkUhyWQ9kX+2yVAE7Oa2mo1OzBzk71u5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053853;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oHcykKdbWCCf6KXfotvmo/7+xKu39VwDXCAK77zuqkY=;
	b=r9lHylWN95WWCHjQ4FZfmTTwD/ri+UyA26WTr7i2NZAWZ7Hq4xjMS1Mb7KnC0og1Vbpg
	 MwXjzi7igtzxNYpmqE2XXs3Y3c09CFXnRtp9k5hIML+ga3k+Y1+5Yr+jL3wFpMoM0Fy9B
	 vd97a5WDne3EGasH0EiyP6RJf0M9YE+7zToPSC+gyKsjZVk3JHr2mpjxHeJ/3r8uisIXu
	 1WJUE64vr7wSUAG6QbNCJK0OM97bI1/mI8Sw9nF/W5MheLEK+9GlILySy4mexp4YbUTse
	 KzwdyJuL4cRjCcQuY3LGvhqHwGnIK8XboruO7aW/3EZImQ9dLHKgHymAYNngkE9Eepg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JcWYWNMR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E96D0606A325;
	Thu, 19 Nov 2026 02:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JcWYWNMR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DDCC1F000C5;
	Thu, 19 Nov 2026 02:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053852;
	bh=oHcykKdbWCCf6KXfotvmo/7+xKu39VwDXCAK77zuqkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JcWYWNMRAY2ceh7v3Vzb71RvIgG8GGCQyTNAAbT4ihRpowXijJ87g0kdlb5Es8+EU
	 0Db0WnYInB/NBubP/6ktnQ62/i7m1xBSJzmQ513EZyb0op2YZaL6cwv01ud1eSd0Y2
	 CDVYR12Ye7o8fFhrEA6GCu9O996lVcOKXPmIbU4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tobias Schumacher <ts@linux.ibm.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1064/2214] s390/pci: Add error cleanup in zpci_directed_irq_init()
Date: Wed, 18 Nov 2026 15:45:40 +0100
Message-ID: <20261118150054.852347805@linuxfoundation.org>
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

From: Tobias Schumacher <ts@linux.ibm.com>

[ Upstream commit 769f66f595c11185c66913ea5d96420504bfebc3 ]

If per-CPU airq_iv allocation fails in the loop, previously allocated
vectors and arrays leak. Add proper error path to release all resources
on failure.

The error path frees zpci_sbv, but SIC_IRQ_MODE_DIRECT has already
programmed its address into the hardware. Set the directed interrupt
mode only after all allocations have succeeded, so a failed init leaves
no freed memory registered with the hardware.

Fixes: e979ce7bced2 ("s390/pci: provide support for CPU directed interrupts")
Cc: stable@vger.kernel.org
Signed-off-by: Tobias Schumacher <ts@linux.ibm.com>
Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
[ sashal: adapted the changes to existing zpci_ibv naming and older s390 allocation and IRQ-control interfaces ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/pci/pci_irq.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/arch/s390/pci/pci_irq.c b/arch/s390/pci/pci_irq.c
index 3823e159bf749..5281772424e86 100644
--- a/arch/s390/pci/pci_irq.c
+++ b/arch/s390/pci/pci_irq.c
@@ -411,15 +411,10 @@ static int __init zpci_directed_irq_init(void)
 	if (!zpci_sbv)
 		return -ENOMEM;
 
-	iib.diib.isc = PCI_ISC;
-	iib.diib.nr_cpus = num_possible_cpus();
-	iib.diib.disb_addr = (u64) zpci_sbv->vector;
-	__zpci_set_irq_ctrl(SIC_IRQ_MODE_DIRECT, 0, &iib);
-
 	zpci_ibv = kcalloc(num_possible_cpus(), sizeof(*zpci_ibv),
 			   GFP_KERNEL);
 	if (!zpci_ibv)
-		return -ENOMEM;
+		goto out_free_sbv;
 
 	for_each_possible_cpu(cpu) {
 		/*
@@ -431,13 +426,30 @@ static int __init zpci_directed_irq_init(void)
 					       AIRQ_IV_CACHELINE |
 					       (!cpu ? AIRQ_IV_ALLOC : 0));
 		if (!zpci_ibv[cpu])
-			return -ENOMEM;
+			goto out_free_ibv;
 	}
+
+	iib.diib.isc = PCI_ISC;
+	iib.diib.nr_cpus = num_possible_cpus();
+	iib.diib.disb_addr = (u64) zpci_sbv->vector;
+	__zpci_set_irq_ctrl(SIC_IRQ_MODE_DIRECT, 0, &iib);
 	on_each_cpu(cpu_enable_directed_irq, NULL, 1);
 
 	zpci_irq_chip.irq_set_affinity = zpci_set_irq_affinity;
 
 	return 0;
+
+out_free_ibv:
+	for_each_possible_cpu(cpu) {
+		if (zpci_ibv[cpu])
+			airq_iv_release(zpci_ibv[cpu]);
+	}
+	kfree(zpci_ibv);
+	zpci_ibv = NULL;
+out_free_sbv:
+	airq_iv_release(zpci_sbv);
+	zpci_sbv = NULL;
+	return -ENOMEM;
 }
 
 static int __init zpci_floating_irq_init(void)
-- 
2.53.0




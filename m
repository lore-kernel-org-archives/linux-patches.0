Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591456;
	b=5rYKBUejme2UrCJ/ruo8uCd9w1nczIccUzJ+MpGIbe17yTDgk8C2lILrESSZIKR75uP2
	 YukyXCgZXp/uOc7RqFQz3zCjI8ZAguMhGvr56yhDRNqCa7sX64xajJt3+QdXmv1k6hqIz
	 SJP5QwYk3bTCLi2CbMVjFQZbmRQe+fc6euRz6AQf6p6tnexl7Xb3Nr3+KIE6xXhqVX8PL
	 GoXqL03+fF7a2MHEBuqFu9sx7nsN2qQR5Qg/6//dUs2tAKSkQHUZHQj/6Vt+lUdB7xYCa
	 RFExxv0qXAP0EbB0pknWYVpfUzl2oZz0r5yPAKMcEf7iRNyRmKWUnwTDgGDpNIXFDHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591456;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=glTo4CLXjDdxBk/SaLvYVAg0yZNWLQIAOTKdb0HxaSA=;
	b=L1yxB7n+9UBYykxSK7cP8rTHuxGfFOjFFMsb8M1hkJ7fKnHnQKSgMf1wC3bGMpNoHadv
	 1iW93EpvjZHPLvW5UL3Pab83O0EyqscEAWyMf2tkc3DtGyYqdIWGAF6J7gyi4EwkOu39X
	 J5wKD2vE6BILbDIreIOhyqgBWUvoP8DEkN2u26NlUhWCc33chfyEKa6qqwmpQJo7oAuRr
	 jbn5p1c8pvAHbwYdLmtAOx48EwRz6zZw5UCwzCDTCtzADjVKKIM3NDS/FM1HFuZoikIYY
	 HXsl2GC/v38AYKwaFR+bx4jlFKoOMevr9HOQ88nrdRDeHKatviESUsXVa1oU0JIY+og==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ROGV26ZU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F03D607C356;
	Fri, 13 Nov 2026 17:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ROGV26ZU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDDB01F000C4;
	Fri, 13 Nov 2026 17:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591456;
	bh=glTo4CLXjDdxBk/SaLvYVAg0yZNWLQIAOTKdb0HxaSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ROGV26ZU+QZ0CChGcl2Tb9eU3iMPUz0c8GwIcoliNUtO1Y9J53VhEQYu5DFSfbxnp
	 fMvCt1fR5ZpJNLyLvV8oaWzMjCBtU4jLvLYlnv1Kgr/nzIPYxV7Z60mUVAiHFtuoAh
	 ZfAwcz3/BVN8UrMIsNRQuIa2ALJWzyvG76Tq74lc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tobias Schumacher <ts@linux.ibm.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 543/670] s390/pci: Add error cleanup in zpci_directed_irq_init()
Date: Fri, 13 Nov 2026 10:51:47 -0500
Message-ID: <20261113153830.295125868@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
[ sashal: adapted cleanup to use zpci_ibv instead of zpci_dibv ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/pci/pci_irq.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/arch/s390/pci/pci_irq.c b/arch/s390/pci/pci_irq.c
index e73be96ce5fe6..836db17f4e8f6 100644
--- a/arch/s390/pci/pci_irq.c
+++ b/arch/s390/pci/pci_irq.c
@@ -450,15 +450,10 @@ static int __init zpci_directed_irq_init(void)
 	if (!zpci_sbv)
 		return -ENOMEM;
 
-	iib.diib.isc = PCI_ISC;
-	iib.diib.nr_cpus = num_possible_cpus();
-	iib.diib.disb_addr = virt_to_phys(zpci_sbv->vector);
-	zpci_set_irq_ctrl(SIC_IRQ_MODE_DIRECT, 0, &iib);
-
 	zpci_ibv = kcalloc(num_possible_cpus(), sizeof(*zpci_ibv),
 			   GFP_KERNEL);
 	if (!zpci_ibv)
-		return -ENOMEM;
+		goto out_free_sbv;
 
 	for_each_possible_cpu(cpu) {
 		/*
@@ -470,13 +465,30 @@ static int __init zpci_directed_irq_init(void)
 					       AIRQ_IV_CACHELINE |
 					       (!cpu ? AIRQ_IV_ALLOC : 0), NULL);
 		if (!zpci_ibv[cpu])
-			return -ENOMEM;
+			goto out_free_dibv;
 	}
+
+	iib.diib.isc = PCI_ISC;
+	iib.diib.nr_cpus = num_possible_cpus();
+	iib.diib.disb_addr = virt_to_phys(zpci_sbv->vector);
+	zpci_set_irq_ctrl(SIC_IRQ_MODE_DIRECT, 0, &iib);
 	on_each_cpu(cpu_enable_directed_irq, NULL, 1);
 
 	zpci_irq_chip.irq_set_affinity = zpci_set_irq_affinity;
 
 	return 0;
+
+out_free_dibv:
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




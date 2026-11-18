Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038338;
	b=gLyI0WfbylOAHjtKzpbFvpEk7EHVIA9QXWoAncqL6ej/3R9fQnzFc2Q+h/GLuQUDYGjl
	 d9JLML423EFP9ev+PW2wPRp1HBMy12UT6WWA6tV5aNcyys/hIqhJbeFvwSvMC37ar8Erp
	 Cbh93Pmh1akYxrzM512NapezJuZ/y8kOrRVQJglpuZH27rIUDkgWx/oG9RPyFAuFnkhBF
	 RoWOrx7u10MQQu1LWo2H+1cKEpSO82JKEHa8pApUsvmIM/FHTWRL+WUOsqNzvZAJtu7Z0
	 SlKM9WVdfoXTH8VGtCLMJaDcCGSBvcjkJwxzDh5FXZ+tqmaN60ztxcyBo4JdLBt02Bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038338;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CTZovRdjJE/g8jRXyl9zsnTyUAOodfBQL4/V0vkCK8Q=;
	b=naZNJRus4jqWDdjicRFzJm2ZUzylTMVgfjp/ykajxwa9uCnMlyfC4gBt3KB8ZYgzYBiv
	 BpXbaeywHiy4FF6Hco3aKRXU3Lyz5NdGvNWC68r8sGD4tsJjlEsvkbNi3mFPqdV6O3q1T
	 pXTE5/tKWYqwwdeGjJH3tdY05PkJDoWGrEDiDvVOyPhJxVSzdb0bMiXg7AQ5uhJHQ9Vqt
	 GK9ZYL2Pr4btEcyaQQqbHR01tVJc3qpBf2WxkXcFRlI3KOCOvADLKiWaPD52ymK8HqpV1
	 Y9cy1l2zxmMyda+ylv8In786tS5cRjWU6QoGdF5Wi65daYfS4L2ZWny+X9YxLFSOhGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1hGuPEOd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60517606A325;
	Wed, 18 Nov 2026 21:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1hGuPEOd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD2B41F000C4;
	Wed, 18 Nov 2026 21:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038338;
	bh=CTZovRdjJE/g8jRXyl9zsnTyUAOodfBQL4/V0vkCK8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1hGuPEOdtW/+TYcKcANzD/E6m/IXjJJkRB9EqDRSY0Ve8tq2gPhYMluqj0Dbo1J/L
	 rGb31UYdJTz/MGQ8U3JSBMQMMQIBkQCmRFAMBVMBqTQWx4i97WrwFWAi0XQb0OBx4N
	 +uCWn/FXuFQJzvgk71Jb+7W3JF315QW+7hl2a2jc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tobias Schumacher <ts@linux.ibm.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1710/3318] s390/pci: Add error cleanup in zpci_directed_irq_init()
Date: Wed, 18 Nov 2026 15:38:52 +0100
Message-ID: <20261118150413.168054839@linuxfoundation.org>
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
[ sashal: Adapted cleanup from zpci_dibv to the existing zpci_ibv array allocated with kcalloc(). ]
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




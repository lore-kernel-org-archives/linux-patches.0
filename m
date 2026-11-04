Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827066;
	b=WUXFgQuGlFiRxv6hWV+ueV6TatElwT4UcCGjnTbPPasPAIbAqoQoI70YINuxSYfzwVOD
	 W14SKh5ecPp5wKmDFh9SeDU6RXygrLhSYVhwweXOWbTx+qHBK93DKyLHgFQOWzNF+NcG8
	 RLPhdUWCkJGKoRYLu/jW80Z8gJLAsDQ6Qgu3zG7iYwFjZl6bVguQaHO1ORlIvAktj+wW3
	 5R8a/aHTvshPm4RKa1Hty+EBiSy0a+IkHOv3t1RUbX3C2ToEcGNb/2C8cvCpa2EPyDndL
	 VfQBXLr/5wisIH9DQ1nfOidDRfJWdKtj8OEPWccODFO+8UhvrzHGCRHiFNbfwI9CGog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827066;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UZAUxdPi+AKcJ8klcZoPfP3Qk1XZN5ZJkSiTOlwFI0g=;
	b=ZQ9EnuM7Jeu6dYsqHAR/XyIuSSEi5eQWloi8Nhq+1+y8/TmLsWev0YDVJqftd9Lo96RH
	 xh7xC0v4YOdfRQADsTfR3qg6Vu/ByMrLVMt46OcP53VZFpflrH8V6FH9hNtHLCv5sOdoY
	 /qi72Co1Vuj2ubr9AI7gdziPOu97WgybDMCGisjvR2/8L9BZ9r8JmTkCm7z+/8uhzsOLP
	 9eYvUAGMn+i+0iwT+CDJ3152Pq91jxoy4UuV6McVa0Sdo4ru9WbCR3wc//ucUjFnnn2Z1
	 rr8SkIH+U3BHWoRE9mAtyXg2v6F/AWX71FhpKMF42R16Xm+ineiG0RhfQ5RqSwUuvNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bMpQlobJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92876606AE3D;
	Wed,  4 Nov 2026 21:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bMpQlobJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D66441F00A17;
	Wed,  4 Nov 2026 21:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827066;
	bh=UZAUxdPi+AKcJ8klcZoPfP3Qk1XZN5ZJkSiTOlwFI0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bMpQlobJE/EFH4S0IQFUVrMBbCmq6/RT6jjv3IKac49Yo3yoKs0HPfRBjawMWK6X8
	 tnJXHYH7FaKJIElNEWxNIkGiNga2LrAgajXrVodWvVH8giPz9ZQWHz1KEZ8P+S0/WV
	 oyb22+QSJDOueij3qguAgHpzsd5ppUbJVPh0m3ts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tobias Schumacher <ts@linux.ibm.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 7.3 173/547] s390/pci: Add error cleanup in zpci_directed_irq_init()
Date: Wed,  4 Nov 2026 16:05:57 -0500
Message-ID: <20261104211043.063605750@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

From: Tobias Schumacher <ts@linux.ibm.com>

commit 769f66f595c11185c66913ea5d96420504bfebc3 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/pci/pci_irq.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/arch/s390/pci/pci_irq.c b/arch/s390/pci/pci_irq.c
index c5fabad38139..bcf11585df8d 100644
--- a/arch/s390/pci/pci_irq.c
+++ b/arch/s390/pci/pci_irq.c
@@ -569,14 +569,9 @@ static int __init zpci_directed_irq_init(void)
 	if (!zpci_sbv)
 		return -ENOMEM;
 
-	iib.diib.isc = PCI_ISC;
-	iib.diib.nr_cpus = num_possible_cpus();
-	iib.diib.disb_addr = virt_to_phys(zpci_sbv->vector);
-	zpci_set_irq_ctrl(SIC_IRQ_MODE_DIRECT, 0, &iib);
-
 	zpci_dibv = kzalloc_objs(*zpci_dibv, num_possible_cpus());
 	if (!zpci_dibv)
-		return -ENOMEM;
+		goto out_free_sbv;
 
 	for_each_possible_cpu(cpu) {
 		/*
@@ -589,13 +584,30 @@ static int __init zpci_directed_irq_init(void)
 						AIRQ_IV_CACHELINE |
 						(!cpu ? AIRQ_IV_ALLOC : 0), NULL);
 		if (!zpci_dibv[cpu])
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
+		if (zpci_dibv[cpu])
+			airq_iv_release(zpci_dibv[cpu]);
+	}
+	kfree(zpci_dibv);
+	zpci_dibv = NULL;
+out_free_sbv:
+	airq_iv_release(zpci_sbv);
+	zpci_sbv = NULL;
+	return -ENOMEM;
 }
 
 static int __init zpci_floating_irq_init(void)
-- 
2.56.0




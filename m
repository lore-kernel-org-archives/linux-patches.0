Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046932;
	b=qtOSkGH9pK/Q8gEBnzngZKvJ503hmkKJDSnBZsZFlb3EJNEO69pNZcvs/h8ij6T3SKnc
	 skLspQeQYlHwMMHhm1l+eAAGhmk3q1/XynA0rz6FKTH2wDbOOlfyZy7pmYfke10h1Xs7l
	 Qd0+UgFk2uv5xopDffBJQdgEHlYFe0JPUS9M4Og5L1jr9mzANfkfTJu2RYzAn0MTCINMn
	 Yz1XRaO1Ff/mPlCH7eeSOrfD9/mH9+CFpihA4UTqq18Izwy9Z4aSEPYRhg1yTVKmvTrrq
	 nYnXqip6z9cLnLuGCMt9blH2Inb8AZ/nHpmHnaOTWKssX+BclOY0zjqkRLxT3c0e5Wg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046932;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hTzprIN3ul6A9NWR0bvgxM41tMmrF5dVehGLruzkxCI=;
	b=nzH+mwVEqA2Hc6XDKhR8f4N6twG1PqtBc+wktglY9wQyByc1f2P0nhzsJSFDw4mfweES
	 M0XUVytyaSZEHLQG4ghXQrVPlB6KUFXh/nMmjg+1zZuFKw+BZuqiFH7nUDPhZ8QuFyDUz
	 KqBhxwg+/WTT1rOoZhRJmrJnpYMT1LCuMPvGim5JbeYDrrDKK2O6rAhBatdY1CP/xUxxW
	 lsJXp79fjTWHtMM2AXCSbaQB61VrOWmZy/8mlsnLOIsuS20iRudd9kiwb/ef/TJmH4W7+
	 KiPvw+I5CGSyS2vpHtZsMFXgOY9pDFPXAGs4BvyJsud+EWZs5meUNASOV/swcsfnInQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EPn2QtmL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94B27606A32C;
	Thu, 19 Nov 2026 00:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EPn2QtmL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E70C51F000C5;
	Thu, 19 Nov 2026 00:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046932;
	bh=hTzprIN3ul6A9NWR0bvgxM41tMmrF5dVehGLruzkxCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EPn2QtmLHSwbNjoZTyEBXS6u7DArNI0zY6Bp/85DdMunHpX74nJSlPDHdWNG7HtXT
	 NE1ytbdsBqcPSxyZI8u28l3OKYTWOuOfQqurzZUpKd4pZ7ERYhrX99ANSepOIpfLfd
	 VvMlDMY7dvKLbU4h6SdRuyMIZlI3WRMxDJMcMm0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tobias Schumacher <ts@linux.ibm.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1457/2857] s390/pci: Add error cleanup in zpci_directed_irq_init()
Date: Wed, 18 Nov 2026 15:41:31 +0100
Message-ID: <20261118150253.776323969@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted cleanup to the existing zpci_ibv array allocated with kcalloc() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/pci/pci_irq.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/arch/s390/pci/pci_irq.c b/arch/s390/pci/pci_irq.c
index 69c5e4f9f10ea..24b8e95d03f4d 100644
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




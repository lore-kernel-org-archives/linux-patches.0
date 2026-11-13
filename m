Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590669;
	b=XIVvGyVUKi2cmggUwzF7cZUwASxr3GLW9cuXKqWP313GW2wdEHnud/u3ENPgugmNSqfD
	 p4LDzEvOx5u3MqYKKDVOD9zBrpIS4RF7QPFEy9HOUxlD0Gr3U0uZlt7FKysK9jiPAVrYs
	 7o2ehuSsa8c4goSC3uag0Mi5YhrhRrBCUAnYVwnNh8CPYu20/W5cc6YyaMa6TezNUfh3i
	 xdfyENmZ2qOEVnCzKTAr38VEi2lQApP1TXO/mAH/oNXcsbGwl3dboH0YfuxsVYMEn4GpV
	 PAeVcvSDknIwfBRgP2miXtYd5xMRTAYKfL7aeCasMmu5JSJ7BEsQjIqM7kSK6cqsaCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590669;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iG+MwLvPbBeexQFaSi3cbhnYDIQJbVZRpL/gh94RLiY=;
	b=AIVlU7ECIGB5NIk7fKm4ISEvKYRHSB4Scd0VC0RH/lAGQP544Xd4Z86dxMehAQp1qHS2
	 K12HE6L9IbQpPsWKJGycIuz4fDLadag2+eCGjfjv5k4ZnFV0dZwbJSmfKtLDC5876ZUAr
	 FhttDKvmxjnq4ssX5i5UXm0pf0KFa8W6FW41bYmGY6b4gRQ6Etzz3J7oj2Os9LTIp24Qr
	 OTobERB/5JxGnqtFOMmCzoWRqmjUgpnXPkeOECFbOztX86IrDLPwhJxBevFOZ+w8FX6y2
	 jE9NkQQabuoV6Bh90JUcXnDOuvi5+dFMcWf3C+87SNbzsYS8F1FTKkDzIboVC9Sp1Dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hgVKZ6cI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 405B660776F0;
	Fri, 13 Nov 2026 17:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hgVKZ6cI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0F561F000C4;
	Fri, 13 Nov 2026 17:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590669;
	bh=iG+MwLvPbBeexQFaSi3cbhnYDIQJbVZRpL/gh94RLiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hgVKZ6cIWOgw7HdMHiyX2NGJ2wQCQcjeyZXRnDoRVwAr7glBn1XDie1BCFm98CbQ/
	 U2qQf3RKSfPMDheJ6uILr/A28eABuyIa9Bk03ZVhx07MKddRqO2gPPi5L8CueuqZ2C
	 miqjtcLXmVjg0VOnYUnvft6TqrZjyMpjHfTYOtqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tobias Schumacher <ts@linux.ibm.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 584/686] s390/pci: Add error cleanup in zpci_directed_irq_init()
Date: Fri, 13 Nov 2026 10:51:57 -0500
Message-ID: <20261113153841.603805092@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
[ sashal: Adapted cleanup references from zpci_dibv to the existing zpci_ibv array. ]
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




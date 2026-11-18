Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059589;
	b=zhYFdIXY6eZ3+o/yqlF8HIZZfU/HMRUak8F2QJPxakz68ey0fhBFCIH0UfhxNiUafyW7
	 kZu0lac3dfAoBB9MykzUBGQhbRsekVlgFKP3UsyrR5BS9fAJttHUvP6IweY6U+zieg1YY
	 h+qLKSNL8GaSrNvFWip6SAw+PsbdIJmjGr/5LB50yiOCvSJ9AUYFJGOFSrjurX1hYRW5Y
	 PpTbkzf7ifIWQ7F9xyk5iKYRigkyFKRBMuPpnZSSLT1H0MylXbGFz6b6P1WJxTPY1FpUk
	 pbL25J+xDR5BHWungtz9H9xKvswxrwN2peJ39NuyTkK6o5VI/eJuHWXr218Az5g8tGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059589;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J7N1trMHMvaukC9SiJ/1mBhEqpKLOyjWvR6CgpRLNv4=;
	b=C/HnHYA5gJHwsAXOsYRNXUwJAb442TGwpvAcqNDXpAMCJQHZpfs1Pw1jXFvLn6jwlP3h
	 smN9JHypV8P/9P93aMcI2YsxCCui0Av1rvEuXEpdekuzx5zKQl+r7pjlbzi8kAvLi53Oa
	 d2uityLernS5rp13O6kFMRSNmG/qiQp/TwN4DixqjCKS3GlP+jNT5hioa6eClk1cVZMef
	 1RpxcK2FyjFRrPIRHNXmM8LyioOQBlZjumpcxBIwIkmWjXVHX+L5Pw1w4t1fGj28oA1Uv
	 c+qKtT1cZl4sm+BFxWoUwHUpsBwTV4ofY8hQnmXPcjjDlzIZlob4U9atW4dA9w/p/Jw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=faLwxV7m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04EDD606A333;
	Thu, 19 Nov 2026 03:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=faLwxV7m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 530941F000C7;
	Thu, 19 Nov 2026 03:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059588;
	bh=J7N1trMHMvaukC9SiJ/1mBhEqpKLOyjWvR6CgpRLNv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=faLwxV7m3rH+ZWuSSe+68PipbL7pyymT9P0YNKrH2N+g8VnlYgLXo61alHjZY4O2n
	 yAbdUKqlhKK9UcBoYtQzRY1brdTAUnBtSGfgmiLSp8LxRZkgU26DpXtnupXHjmILPY
	 c5dXtBcdRJOcN+BGEzk6noj2yynizRl1wkxckh9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tobias Schumacher <ts@linux.ibm.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0896/1848] s390/pci: Add error cleanup in zpci_directed_irq_init()
Date: Wed, 18 Nov 2026 15:48:54 +0100
Message-ID: <20261118145954.169954156@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 75217fb63d7b3..f29ac95d4d278 100644
--- a/arch/s390/pci/pci_irq.c
+++ b/arch/s390/pci/pci_irq.c
@@ -391,15 +391,10 @@ static int __init zpci_directed_irq_init(void)
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
@@ -411,13 +406,30 @@ static int __init zpci_directed_irq_init(void)
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




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028513;
	b=XY7pSAWyjyc008HFq0+BKuPi2/boO5xN8jTAg6RM8sfEHYqHrI5AC7PyhVF5t/+akXor
	 xByULRHKdqj8bReNgUvBV1jumFW8rKmF79ydg19il57M/fp7bdtFLLZSnNwmnqxtmRgJl
	 tFnSB8vx5a8D4AwvH8p9NB0QndtIociDnyKEq4bcnWmG1eyG3vykNH5w3ApeqLkccpv0f
	 y1RTstzBS7C0pz9hgidlAOzm0eWOUY4KzZzSgtzO95UYSqapnhHimbwhjBpA1KnhCNzcq
	 LMz4dPZpe0ZZzFgM2OAovPmDLQMOUxStAkgHukkETqCUHQKOXqX5E0oCpXJF9dyEzyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028513;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uHdSt4hUGN+9p2kOuK2O3fHKYuOK0vkl+nPljEqHGVY=;
	b=uQJYeU25+qL2uT3y11T2ne+Y2USr6y78QPCLtWnH/qF/WgWKsyQPee4i4V3XYpp7dGRl
	 Lz80swsTsj8IRT9AsSgXaJCvFJnZGtGSTuo4Biyct7ub2BqVtsDYcSfv+N/XbOpNroVmF
	 0C1xa13tx1oFJI1KG/zS45d7EAHf1WX1sVEAuD4cb0O8MLdJudzboJJOj2/U2mU2Hf19j
	 zPZbXGJPFI5kWAWwniMgSlZMKTlmwz5KTtqMGe+RjrrVFnS+U94KP02oxQguHuHcauz4u
	 uDTIu3ZjqJ8ovOj+Bxf1gT2EGvse5Yi0Ct+Lt7XMq+D62KSvRK+gB6FkJgjRP7EhQHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1BN3qhE0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54FFC606A339;
	Wed, 18 Nov 2026 19:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1BN3qhE0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65DC71F000C4;
	Wed, 18 Nov 2026 19:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028512;
	bh=uHdSt4hUGN+9p2kOuK2O3fHKYuOK0vkl+nPljEqHGVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1BN3qhE0fVwXpsjRygztuokLw/DARc5EtFGFYA61ifd8fmnGkPG3LrIwMXiAtij9F
	 Sl+FyvBtwTWAF+dHUd/l9kiDWzJyD+FDLLF3xaaLoohlaLX5XbB+nIBGaCFWh3hgOb
	 +U8pX/VJlV2iq1kP8NVdI7MQI2Sz5rm2vAvN2sTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Priyank Rathod <rathodpriyank@google.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0009/1756] PCI/AER: Fix memory leak in aer_recover_work_func() when pci_dev is missing
Date: Wed, 18 Nov 2026 15:35:36 +0100
Message-ID: <20261118150008.337877312@linuxfoundation.org>
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

From: Priyank Rathod <rathodpriyank@google.com>

[ Upstream commit d4c842c3af5bc52b3ca0b8a7f116114e43b6ba44 ]

When ACPI APEI/GHES processes PCIe AER error records, it allocates memory
for aer_capability_regs (entry.regs) from ghes_estatus_pool and queues the
entry into aer_recover_ring.

In aer_recover_work_func(), items are popped from aer_recover_ring via
kfifo_get(). If pci_get_domain_bus_and_slot() fails to find a matching
pci_dev, the code previously executed 'continue', bypassing the call to
ghes_estatus_pool_region_free(). As a result, the memory allocated for
entry.regs from ghes_estatus_pool was leaked.

This is reachable whenever the device reported by firmware is not (or is no
longer) present in the PCI device tree, e.g. after hot-removal or when
firmware reports an error for a device the kernel never enumerated.

Refactor aer_recover_work_func() to ensure ghes_estatus_pool_region_free()
is called unconditionally for every dequeued entry, releasing the pool
memory even when pci_dev is missing.

Fixes: e2abc47a5a1a ("ACPI: APEI: Fix AER info corruption when error status data has multiple sections")
Signed-off-by: Priyank Rathod <rathodpriyank@google.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260928-b4-fix-aer-memleaks-v5-2-ba6b94c9c9a6@google.com
[ sashal: Adjusted patch context to preserve existing pr_err() logging instead of upstream pr_err_ratelimited(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/aer.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/pci/pcie/aer.c b/drivers/pci/pcie/aer.c
index 229853e9d565e..44fac6c2f437e 100644
--- a/drivers/pci/pcie/aer.c
+++ b/drivers/pci/pcie/aer.c
@@ -1150,13 +1150,12 @@ static void aer_recover_work_func(struct work_struct *work)
 	while (kfifo_get(&aer_recover_ring, &entry)) {
 		pdev = pci_get_domain_bus_and_slot(entry.domain, entry.bus,
 						   entry.devfn);
-		if (!pdev) {
+		if (!pdev)
 			pr_err("no pci_dev for %04x:%02x:%02x.%x\n",
 			       entry.domain, entry.bus,
 			       PCI_SLOT(entry.devfn), PCI_FUNC(entry.devfn));
-			continue;
-		}
-		pci_print_aer(pdev, entry.severity, entry.regs);
+		else
+			pci_print_aer(pdev, entry.severity, entry.regs);
 		/*
 		 * Memory for aer_capability_regs(entry.regs) is being allocated from the
 		 * ghes_estatus_pool to protect it from overwriting when multiple sections
@@ -1166,13 +1165,15 @@ static void aer_recover_work_func(struct work_struct *work)
 		ghes_estatus_pool_region_free((unsigned long)entry.regs,
 					      sizeof(struct aer_capability_regs));
 
-		if (entry.severity == AER_NONFATAL)
-			pcie_do_recovery(pdev, pci_channel_io_normal,
-					 aer_root_reset);
-		else if (entry.severity == AER_FATAL)
-			pcie_do_recovery(pdev, pci_channel_io_frozen,
-					 aer_root_reset);
-		pci_dev_put(pdev);
+		if (pdev) {
+			if (entry.severity == AER_NONFATAL)
+				pcie_do_recovery(pdev, pci_channel_io_normal,
+						 aer_root_reset);
+			else if (entry.severity == AER_FATAL)
+				pcie_do_recovery(pdev, pci_channel_io_frozen,
+						 aer_root_reset);
+			pci_dev_put(pdev);
+		}
 	}
 }
 
-- 
2.53.0




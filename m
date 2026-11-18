Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015016;
	b=0DYUw5ogKggEGzZzG2OKXWTb3KHKxGtTPk/CSf1rL+/R01iwRrUG0EsaQLp5reoSnmqq
	 OXm/w5NOxLDP+k1GgwF/1hNxC0+9Cf82ZCtnw/VgCaOAxKgVM0gr6MNB3u+xVgVh2d6gO
	 FvkJNk1TAQNUP1fU3HKc/WVUjX6ZuP0kmGI2f9iblbefJcOlsiSS/PvGO+gx6vW9KI7dL
	 WcpsfH1y6l2hen+uZKXDTwUqU48wDPvUTNX7gdLZwUXcgSqKVvGuw64CMDOIqSRvj5aW8
	 UyA0I3hocGPtsPvJElq254n7fYARmxP59nPbbm1b21Mhwb1wN2RHlfcpYnbIGfOFkug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015016;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3P2OqtjZ4zRXPSYmKTM8N0EDHl89rz5QY/1As0MvWxk=;
	b=yxMS3PO8S9EgIAgcHsE3rNpoBe7qJDBPvukbIYftIEJkQKVvlQtc/8VPEoXeVtXt09Gy
	 tyO4cN1eb4ZmOrQKYWxCAugXA7wm+ePQqRr2sX4NL1RtNPRixIdaWgqAGHSpW87be+GhF
	 n0b7GWSvAVB7LNkX3Rd38+5vx9Zl2BCtk9RZRbKi03ZLARASg0lJcp+sBWCiU750kSKhy
	 2AW2qMryOar4fub9J2vSqwzDYXmveZksk3l8fMwFe8rer6V12nNheQAkwp2kQNs5ksuMC
	 LKgof/iDv6qT6qhtwQ9fxIt0h3Ccsx03gvJ8ZqssJmYQ8jEpe+pXMfDs64EycpDcTSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QxxnKRSI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE1B606A31C;
	Wed, 18 Nov 2026 15:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QxxnKRSI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAAD51F000C4;
	Wed, 18 Nov 2026 15:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015016;
	bh=3P2OqtjZ4zRXPSYmKTM8N0EDHl89rz5QY/1As0MvWxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QxxnKRSIjvHjoyPHwkuY1INqxWf2IuxsFs90ikpdOG+zjC6AozhxP8cwQ9BgcY9O5
	 IoG5MCyNNGLlFGHqil6X9q717C3CGTqlAHzAEC2WefKWYeubE/Xa5OJ8O+MfGHCaOv
	 tWtOKvwnqnoCjLPtrAjoj1f5A0d/YG5J/ehpsdto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Priyank Rathod <rathodpriyank@google.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0005/2651] PCI/AER: Fix memory leak in aer_recover_work_func() when pci_dev is missing
Date: Wed, 18 Nov 2026 15:20:45 +0100
Message-ID: <20261118150248.197317143@linuxfoundation.org>
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
[ sashal: Combined the upstream pdev recovery guard with the existing err check to preserve false-alarm filtering. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/aer.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/pcie/aer.c b/drivers/pci/pcie/aer.c
index be332d3f106cb..490f096cfe91c 100644
--- a/drivers/pci/pcie/aer.c
+++ b/drivers/pci/pcie/aer.c
@@ -1369,14 +1369,13 @@ static void aer_recover_work_func(struct work_struct *work)
 	while (kfifo_get(&aer_recover_ring, &entry)) {
 		pdev = pci_get_domain_bus_and_slot(entry.domain, entry.bus,
 						   entry.devfn);
-		if (!pdev) {
+		if (!pdev)
 			pr_err_ratelimited("%04x:%02x:%02x.%x: no pci_dev found\n",
 					   entry.domain, entry.bus,
 					   PCI_SLOT(entry.devfn),
 					   PCI_FUNC(entry.devfn));
-			continue;
-		}
-		pci_print_aer(pdev, entry.severity, entry.regs);
+		else
+			pci_print_aer(pdev, entry.severity, entry.regs);
 
 		regs = entry.regs;
 		if (entry.severity == AER_CORRECTABLE)
@@ -1394,7 +1393,7 @@ static void aer_recover_work_func(struct work_struct *work)
 		ghes_estatus_pool_region_free((unsigned long)entry.regs,
 					    sizeof(struct aer_capability_regs));
 
-		if (err) {
+		if (pdev && err) {
 			if (entry.severity == AER_NONFATAL)
 				pcie_do_recovery(pdev, pci_channel_io_normal,
 						 aer_root_reset);
-- 
2.53.0




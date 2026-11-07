Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064845;
	b=xG1Mv1C9S1CQ+upP+FePoCejMqSXQDCEmX20FTfLzXRh+P0Ku6QKunux6cFFPkbhS79x
	 Sr6Vv4AYL2W5S7nYMuzBvPOWDmhYS9hP/GmTNQR8t7Wx+6AuMOIrs2RGRSVk33I1MquLa
	 vRBK5HcqCD3jDVmSQ3xBclowKF5UCYbdgNDssCqo1Q98vyWQi+4UUFwNH5+gKKag9iUa5
	 rzf/bp/Ivv3retE0yQedqdfXhyNLiBA122wwLUbzkNZwa2X+jVwsCPp+QdWKZyLkgNydv
	 8JjQcTRPi8xxPqtk0h9sLV7p61/7ESu+3AGuDDkKjO2WeMRcbk53Dn6vUq1IydssJug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064845;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VmA3YtmMEDM1Y8Ea/efsIU64W0L1kWwX3MYGzx7Se1c=;
	b=VOMXDOcxquWl2THuFOx9Yczd9o7S9qir17EyMzCi3koEzhSJBwA90BZN316/LPHQ5RK4
	 W3gYr/I8jVMZ/jAMftOuF9ATX9X1qu2LyTJ5yRc7/iKVTzQetWjDzmjVgFPoualQqTsZ5
	 mXKVxWxqg1I98Wo65pQK2A6+4YNZwcnBe0SgjOPTyk3Y3gC6ZJuQLFOE4m3325CIcFGyt
	 1wys9SIxVKCNkqmr71Ns/nMScKlvTfKZC/4pKeUHe4l2Xgn0ZUMspknPqVIuCXDHnMKS9
	 9l3FQjPtqUaRiv+BfIbcoIPyBBg0zRc3eTpnpL8UBpl8Rz2YQrx8pKsS444s3W7QaWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TKizY9fr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB724606B8AD;
	Sat,  7 Nov 2026 15:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TKizY9fr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DB9B1F008A1;
	Sat,  7 Nov 2026 15:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064844;
	bh=VmA3YtmMEDM1Y8Ea/efsIU64W0L1kWwX3MYGzx7Se1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TKizY9frjwZL4UFasDeGKNOVbeYSfqith9dfBQNhMoLar9Xy64ubTA+jKTZn/HJMr
	 DsAGezlnkpjwppFD8rbmfrfkTKqcDWlt9Wv8MO85C4URsV49REBLL3on/DKYVUPIgt
	 TXwLFm18CuWuX/8L5LXZO4BjMXQlzhjKgbBFmCj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stian Halseth <stian@itx.no>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Tony Rodriguez <unixpro1970@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0770/1257] PCI: Set supported_speeds in set_pcie_port_type()
Date: Sat,  7 Nov 2026 08:51:06 -0500
Message-ID: <20261107135000.562022778@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Stian Halseth <stian@itx.no>

[ Upstream commit 926767a9be8866d26cc27ca46c46c03d921e2193 ]

sparc64 and powerpc create PCI devices from the device tree in
of_create_pci_dev(), which calls set_pcie_port_type() but not
pci_setup_device(). Since d2bd39c0456b, supported_speeds is only set in
pci_setup_device(), so it stays 0 for these devices.

pcie_get_speed_cap() then returns PCI_SPEED_UNKNOWN, the sysfs
'max_link_speed' attribute reads "Unknown", and the failed link retraining
quirk passes PCI_SPEED_UNKNOWN to pcie_set_target_speed(), which warns on a
SPARC T7-1:

  WARNING: drivers/pci/pcie/bwctrl.c:125 at pcie_set_target_speed+0x284/0x2e0

Set supported_speeds in set_pcie_port_type(), which all three paths call.

Fixes: d2bd39c0456b ("PCI: Store all PCIe Supported Link Speeds")
Closes: https://github.com/sparclinux/issues/issues/109
Signed-off-by: Stian Halseth <stian@itx.no>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Tony Rodriguez <unixpro1970@gmail.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261007131304.309511-1-stian@itx.no
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/probe.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 27008e2ea5afc..52a79b033b069 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1651,6 +1651,8 @@ void set_pcie_port_type(struct pci_dev *pdev)
 		pdev->aspm_l1_support = 1;
 #endif
 
+	pdev->supported_speeds = pcie_get_supported_speeds(pdev);
+
 	parent = pci_upstream_bridge(pdev);
 	if (!parent)
 		return;
@@ -2074,9 +2076,6 @@ int pci_setup_device(struct pci_dev *dev)
 
 	set_pcie_untrusted(dev);
 
-	if (pci_is_pcie(dev))
-		dev->supported_speeds = pcie_get_supported_speeds(dev);
-
 	/* "Unknown power state" */
 	dev->current_state = PCI_UNKNOWN;
 
-- 
2.53.0




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064648;
	b=1ZdoCjHlcVNPTY4Da1t95EDN1uwsI25qeMoRV6rRokIa3hrKxxyQrYtgJVsEhB5flRR/
	 oMz1nXizcxKLSNM7K7iz5Js0PxGvRzMAGmkNxEHODalJ29NP4a4pHsacw2eYxkCUmCu5b
	 EJ+EGz9bc7ytQsWzFP00PwlFGbqsyj+u96XwT1dz49WuyPEWzcAI9uBuPYO3eCDQc39lK
	 ans08g1uzWToGaoT+WkGZAphgMY69rQqG7H/paogOUjaXdLimhPclHA6geFGsAx52WMrI
	 2LUaer3yQqXtBV4VJGRaY/qOXCPV+flLLye06biJUIC9IAtdGKnDwM129jyKq3w7biA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064648;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=AQnfB3TgEpzKsAEmLAw22U1Z7bIiMBLFrn9wBLcTN0k=;
	b=4P2Ym33BfUj2NTEI/odpHKP+2mzE7bfehZ+I0e/38kPqdqRTOGPBziVh8meERQmC78Ih
	 SCsJjFNPeDcTZDgvS693D2/QjRetCXf8ZXjerszqcb4t7Y5ElR5qLlGVaUBiH4ztF7x9L
	 CsjIOC2LeedCRwdBVDd6g0Fkz7kADCBZjZkG6qOl0UnN4bYu8xb7O8pLqwscZALSwtPon
	 ZaEQw4eJffS0T2No6uFvnlh/Hq+z67Hx1irf6zgZvQRJ4WIoGT6fP9mxfBwY8H69O6CWD
	 +qCWnsnN/6UO5/LKDAQk2lb3WdjfHwJxSQUKbMdwiq5AeHDYXoDMLNYOdfJX/Q3n8AQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vajgAxSY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A827606A9CA;
	Sat,  7 Nov 2026 15:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vajgAxSY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC57E1F0089F;
	Sat,  7 Nov 2026 15:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064648;
	bh=AQnfB3TgEpzKsAEmLAw22U1Z7bIiMBLFrn9wBLcTN0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vajgAxSYaNqTbaTZH7cpHgSvbpYFDg0z06J2QonbyGYXWnowEarna/yE/hIg6ttcy
	 6AtSCWL6PyC+Y0bJQnOdRT2gzUajvspF3r3a/ezp8rY5owgKDs6AaoWVFiAPS8f3Ug
	 cIx3ACzViz5ilnSsz8wCEyVCeT605gt8BIw7fTCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Nedoshivin <gvozd188@mail.ru>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0651/1257] PCI: vmd: Flush DMA writes before handling MSI on Arrow Lake
Date: Sat,  7 Nov 2026 08:49:07 -0500
Message-ID: <20261107134957.245930879@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Nedoshivin <gvozd188@mail.ru>

[ Upstream commit 2c88c2dc18528489b403fe95741f5731e292f7ba ]

Per the Intel Core Ultra Processors (Series 2) Specification Update
(ID 834774 of 9/1/2026), the Arrow Lake VMD device 0xad0b is affected by an
MSI erratum:

  ARL004: MSI from VMD-Owned Device May Pass Memory Write

  Problem      When the storage subsystem is configured to operate in RAID
               0 or 1 mode, a Message Signaled Interrupt (MSI) from an
               Intel® Volume Management Device (Intel® VMD) owned device
               may interrupt a core before a previous write from the device
               is completed.

  Workaround   None identified. The VMD MSI interrupt-handler should
               initially perform a dummy register read to the MSI initiator
               device prior to any writes to ensure proper PCIe ordering.

The existing VMD_FEAT_INTERRUPT_QUIRK implements Intel's documented
workaround by issuing a configuration-space read to the MSI initiator
before dispatching the interrupt.

Enable the existing quirk for 0xad0b as well as 0x7d0b and make the
comments describe both MTL016 and ARL004.

Tested on an MSI Vector 17 HX AI with Intel VMD 8086:ad0b and an NVMe
device behind VMD. With the quirk enabled, the NVMe completion stalls
observed without the workaround are no longer reproduced.

Link: https://bugs.launchpad.net/bugs/2166325
Signed-off-by: Vladimir Nedoshivin <gvozd188@mail.ru>
[bhelgaas: include erratum source and text, cc: stable]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260910200539.10862-1-gvozd188@mail.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/vmd.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/controller/vmd.c b/drivers/pci/controller/vmd.c
index e45ef8cb16e47..9d97a832785ee 100644
--- a/drivers/pci/controller/vmd.c
+++ b/drivers/pci/controller/vmd.c
@@ -94,7 +94,8 @@ enum vmd_features {
 	VMD_FEAT_USE_BIOS_INFO		= (1 << 6),
 
 	/*
-	 * Meteor Lake VMD (device ID 0x7d0b) is affected by erratum MTL016:
+	 * Some Intel VMD devices are affected by interrupt ordering errata,
+	 * including MTL016 (0x7d0b) and ARL004 (0xad0b):
 	 * the VMD may signal its MSI before the posted writes that carry the
 	 * child device's DMA data have landed in memory.  The demuxed handler
 	 * then runs against a not-yet-coherent completion queue and misses the
@@ -131,7 +132,7 @@ static DEFINE_RAW_SPINLOCK(list_lock);
  * @enabled:	true if driver enabled IRQ
  * @virq:	the virtual IRQ value provided to the requesting driver.
  * @flush_addr:	config space address of the initiating device, read before
- *		demuxing to flush its posted writes (MTL016); NULL if the
+ *		demuxing to flush its posted writes; NULL if the
  *		VMD is not affected.
  *
  * Every MSI/MSI-X IRQ requested for a device in a VMD domain will be mapped to
@@ -1300,7 +1301,7 @@ static const struct pci_device_id vmd_ids[] = {
 	{PCI_VDEVICE(INTEL, 0x7d0b),
 		.driver_data = VMD_FEATS_CLIENT | VMD_FEAT_INTERRUPT_QUIRK,},
 	{PCI_VDEVICE(INTEL, 0xad0b),
-		.driver_data = VMD_FEATS_CLIENT,},
+		.driver_data = VMD_FEATS_CLIENT | VMD_FEAT_INTERRUPT_QUIRK,},
 	{PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_VMD_9A0B),
 		.driver_data = VMD_FEATS_CLIENT,},
 	{PCI_VDEVICE(INTEL, 0xb60b),
-- 
2.53.0




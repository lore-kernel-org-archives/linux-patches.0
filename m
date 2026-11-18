Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033791;
	b=vAvKsucxf9ZgLeWJ/EKEtNHS7MTIMFoNNQpDX1UGoDEy7RYTs4sK3NRaOA0U4UhXmihi
	 6zywdi1GhVgrLtZ6Qkmn+hCIxOUIPBciDdN6BnC4Nss3tDuXzN1hzK7ubTIzImtGtA889
	 2QupyvymH0JB5JaE+Xt2mM5zyRoa2TTWjFxU1aUxt+7cqX3X4Ixvmn8BHWPp2KluNSdCk
	 duOd6l0OZNQ+YUbu9bvR6+jTpy8URPLEQrqr5QX0A/kGCqt9SW6n4EVoJLi0ocHzZOje+
	 Kk7i299M43sD5t2B8XkzDocmoGaOKYosg4AWfZz8+rbxLnsJPA7MMG3CjnIUUWEM7Kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033791;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Nqkz/Q1XsIp+gB4XK6u8r7t/GU8bNIgSQxbhCO1mh4E=;
	b=GQl589LUD7VRHMuaf2PMcAvn2Zh8NQNigVbmDoLr1QR7WSXqheExc8bRbSNRr1heclfQ
	 FvgkL4NwwF+/Co+5TaOak94pXkCNTUabL01PnOXfdCeb0DrsTaKblyOzybfITKgS+dTLx
	 1dA0yISNWhdBMWSKvPS00KP4jzOT5tRrlpxbVNjn2M6Ur+duQxV+9DXFfw4uG+eE6mvBf
	 Qx+OkCRsaXlQDefnyP9YuAOQpeGqrrnU1THFjqMxYgbSrIKFQHW0F4+DsQcaiW48nFECs
	 WjT0UZR5k/QLSdXLmIRvPGHyNREwbwCY69TYc2oyaKwfNZOjCQiSL0qm8KjKwDp4ioA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=em3FVeAP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A23F8606A320;
	Wed, 18 Nov 2026 20:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=em3FVeAP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFE251F000C4;
	Wed, 18 Nov 2026 20:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033791;
	bh=Nqkz/Q1XsIp+gB4XK6u8r7t/GU8bNIgSQxbhCO1mh4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=em3FVeAPmBn9+gT/oLAL+HlDlRPTMsPMRVFGDc5hfgNWiUB5o4vlumxKsfmETehs+
	 Alo7qfQyf1n4hZrBezbDdLH5Dgy2sZfhMiD6bZFwjt5B5zmACUL62+6mzbeC5/PnNU
	 GscX3rvzOvmFID+aGfJSNbgKJiHb08rxKC92mlYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Logan Gunthorpe <logang@deltatee.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0140/3318] PCI: switchtec: Add Microchip PCI1008 device ID
Date: Wed, 18 Nov 2026 15:12:42 +0100
Message-ID: <20261118150318.654183032@linuxfoundation.org>
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

From: Logan Gunthorpe <logang@deltatee.com>

[ Upstream commit 0d8a6306c680ee534be131e360f0cafa2bada7be ]

Add the Microchip PCI1008 device ID to the core switchtec management
driver's PCI ID table. Without it, the management endpoint on a PCI1008
switch is not bound by this driver, preventing userspace tools from
configuring or monitoring the switch and leaving NTB functionality
unavailable.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260714212010.230606-3-logang@deltatee.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/switch/switchtec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/switch/switchtec.c b/drivers/pci/switch/switchtec.c
index 89e7bcbdece1c..40eda5231d2c3 100644
--- a/drivers/pci/switch/switchtec.c
+++ b/drivers/pci/switch/switchtec.c
@@ -1873,6 +1873,7 @@ static const struct pci_device_id switchtec_pci_tbl[] = {
 	SWITCHTEC_PCI100X_DEVICE(0x1004, SWITCHTEC_GEN4),  /* PCI1004 16XG4 */
 	SWITCHTEC_PCI100X_DEVICE(0x1005, SWITCHTEC_GEN4),  /* PCI1005 16XG4 */
 	SWITCHTEC_PCI100X_DEVICE(0x1006, SWITCHTEC_GEN4),  /* PCI1006 16XG4 */
+	SWITCHTEC_PCI100X_DEVICE(0x1008, SWITCHTEC_GEN4),  /* PCI1008 16XG4 */
 	{0}
 };
 MODULE_DEVICE_TABLE(pci, switchtec_pci_tbl);
-- 
2.53.0




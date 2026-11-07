Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064646;
	b=Rm8mbBt4GhyliO2kDRKsYV2O2BKnze7cfLywZX0ZUp2JqQcWivpqKvKcRGAPO4Q27IHp
	 exk/uEuYnN4LNUlMwWmhha5l6qWowmgycXEDt7e02LCQTTcDbVetkOlA+/WStGbdNJ+Kk
	 mUbvsT1D3QEKEX6f+jLFEUdYbS8oIRM4DmYyYmkKkQcrtkE+0p9Q2EiUp3RyKVSRxykYK
	 1AuVMGWvOHfJ2AZjrEXDBblBXUU/y07445tTWTAlCkipgOIqIrHmQW4D/XOEJqMHxwYHH
	 Mx5PD9r5Y6cZl+xX8N9qzmeb/RD6YHlLKxlgNxrHcOOjHVk8i4AQ6LpB2IWqubrHglw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064646;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Rns5Zb0b0MMLMB33rJLRYmDxvlWt4gXgPrdoNkvKQAo=;
	b=k+JFKew/8hI8+q7RgtZMSZKX4whAsIKu67K5iLkEVegRja23OC/Gfi9y/zSZC9yX4Wfp
	 NvBuaXWRModerZMiKNGGM8xCSSVtpzPo4xnsmkD+3byAcyFzKw5QE7FKyH+FyF+bRbqYD
	 XXVfmOtU7DEtU3BZ/AWzX5XJmACaDqP3u5RhXueGzvW6BA72TrHTbbS2yghx0b1V30odK
	 noVPMv7riMHC0AxWSnqK7LCDzWjWBekS0ligCmwWyBT91i3FmNG9UOqsU2YJ6Rgng2JcK
	 10RJ4mIZ3kziM//oVWfJeFo63VR3bEx9IG0waUWKPxAgVjMZX60MV95U141CA4e3iXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=acrQ+oLr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C80D4606A9FF;
	Sat,  7 Nov 2026 15:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=acrQ+oLr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76F8B1F0089F;
	Sat,  7 Nov 2026 15:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064645;
	bh=Rns5Zb0b0MMLMB33rJLRYmDxvlWt4gXgPrdoNkvKQAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=acrQ+oLrZO6lCA646S0WjNSvZtPtoZjOG+764qQC0NYqhOZe8JAIomJW0f/owPCbv
	 l795D5VJyHQAaczDXol4o5HiD4HfiqO8/+cx2LeQxH12WxttG8BgvNXjEtm8gmSVdr
	 JmAzxCtoTU86ESRI6OzUOUlAcWex5rx92KXy44H0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Kaloz <kaloz@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0649/1257] PCI: Avoid D3 on PLX PEX 8532/8533/8548 downstream ports
Date: Sat,  7 Nov 2026 08:49:05 -0500
Message-ID: <20261107134957.194446037@linuxfoundation.org>
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

From: Imre Kaloz <kaloz@kernel.org>

[ Upstream commit 8e923e51892c7da91687dd5b8081ddb1f0fb395a ]

Runtime PM suspends an idle downstream port of a PLX/Broadcom PEX
8532/8533/8548 switch to D3hot, but that takes the whole switch down
with it: any device behind another port of the same switch then
faults with a fatal bus error on its next access, e.g. mptsas probe
on a Sun Ultra 45.

This surfaced on sparc64 once commit a5fb3ff63287 ("PCI: Allow PCI
bridges to go to D3Hot on all non-x86") let bridges enter D3hot. Keep
these downstream ports out of D3 by setting PCI_DEV_FLAGS_NO_D3.

Fixes: a5fb3ff63287 ("PCI: Allow PCI bridges to go to D3Hot on all non-x86")
Signed-off-by: Imre Kaloz <kaloz@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Magnus Lindholm <linmag7@gmail.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260927105609.8813-1-kaloz@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index edf035d251cc2..d4fcc336bc2a9 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2387,6 +2387,24 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9050,
 DECLARE_PCI_FIXUP_HEADER(0x1402, 0x2000, quirk_plx_pci9050);
 DECLARE_PCI_FIXUP_HEADER(0x1402, 0x2600, quirk_plx_pci9050);
 
+/*
+ * An idle downstream port of a PLX/Broadcom PEX 8532/8533/8548 switch
+ * autosuspends into D3hot, and that takes the whole switch down with
+ * it -- any device behind another port of the same switch then sees a
+ * fatal, non-recoverable bus fault on its next access. Keep these
+ * ports out of D3 entirely.
+ */
+static void quirk_plx_pex_no_d3(struct pci_dev *dev)
+{
+	if (pci_pcie_type(dev) == PCI_EXP_TYPE_DOWNSTREAM) {
+		dev->dev_flags |= PCI_DEV_FLAGS_NO_D3;
+		pci_info(dev, "avoiding D3 on this downstream port\n");
+	}
+}
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_PLX, 0x8532, quirk_plx_pex_no_d3);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_PLX, 0x8533, quirk_plx_pex_no_d3);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_PLX, 0x8548, quirk_plx_pex_no_d3);
+
 static void quirk_netmos(struct pci_dev *dev)
 {
 	unsigned int num_parallel = (dev->subsystem_device & 0xf0) >> 4;
-- 
2.53.0




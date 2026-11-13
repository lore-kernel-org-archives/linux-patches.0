Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590903;
	b=MR2Psjy4ktN2ccGYVtGXHOUmI2horthbBA7ieHDOBVrElzVLqXlkwJ2wT/MflqGQNW/J
	 I0Er+0y/qouDfcYZe8rxPRNqJaysO+AVUDoVyAhQgDe06hUaGiRxOdV2l0mRJS/TPISt6
	 eUNCefq//T3PFxQyFmrIDpOBmkPxJPgDri2qpod1vFQbdSjaCtMtS/LgXq6wdiLGk+SYt
	 +3QIxcV2K28spX5As6TY6yIZmlRFiimo/pw8O5j84uhu+EfDfgnjFtlhvUe3uU4TQpZyW
	 1yROeaW+KfuO9C5ivvpK716NOVihXFySmIuSHjMdAwymNPwuRbdoRj9ktKU3NMPraTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590903;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=mxdjXHTQCKOI3taExnIxeJdGUVLVmHDglogs+llPz/8=;
	b=rwHzJ+U2SuXUORTFj+JUIY6HoCd7+H6L/vN5guyhYATiXJ8zC3ENYfX1GSR2I1+Igiee
	 60e6vYAnSb87om3UD5ic1t5RtuCNuZnOtL9XCLaM38CanS2UgIs10kCzxLU1+VmvGY4Pi
	 ldxbXypCXdOd8z6BR6S2QriGbkCnegMqLD9YUiLR6fsfuOro/B5O0DlecApKkE3Fc9AKA
	 noFDNLUgAMugC9IEJoxYdrt6146kVQpJVtDo86fWbp01S8TCiUT0hSAuefSTXe10PLx/U
	 vvWI2ZnR+4wNlW9RqB0+PihXBpjlcxLJQAWI3Cf7B0b87jcW1SF6AMvNW1hH915AnLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wDVbeRd3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D9C606E236;
	Fri, 13 Nov 2026 17:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wDVbeRd3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58DE41F000C4;
	Fri, 13 Nov 2026 17:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590903;
	bh=mxdjXHTQCKOI3taExnIxeJdGUVLVmHDglogs+llPz/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wDVbeRd30/KbcCB7wxnGvgFxtXORbdGLn0ZCS48MLAaft7qIpsLZoJTAFCdpaq7xL
	 8YbVGt4gGVUjRubNymIfjdjI4uZySuNqRzuvAy/7IAVfwTR5Eq9UnRV7YcbjOJESSB
	 GlrG94yCXEBWXgIYbZ6LNQaAjgpL2iMREGS1+HCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 092/670] PCI: Add enable_device() and disable_device() callbacks for bridges
Date: Fri, 13 Nov 2026 10:44:16 -0500
Message-ID: <20261113153815.023282178@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Li <Frank.Li@nxp.com>

[ Upstream commit a3751212a8eeece59d2018c455000f30ed7e5bb7 ]

Some PCI host bridges require special handling when enabling or
disabling PCI devices. For example, the i.MX95 platform has a lookup
table to map Requester IDs to StreamIDs, which the SMMU and MSI
controller use to identify the source of DMA accesses.

Without this mapping, DMA accesses may target unintended memory, which
would corrupt memory or read the wrong data.

Add a host bridge enable_device() hook the imx6 driver can use to
configure the Requester ID to StreamID mapping. The hardware table isn't
big enough to map all possible Requester IDs, so this hook may fail if
no table space is available. In that case, return failure from
pci_enable_device().

It might make more sense to make pci_set_master() decline to enable bus
mastering and return failure, but it currently doesn't have a way to return
failure.

Link: https://lore.kernel.org/r/20250114-imx95_lut-v9-1-39f58dbed03a@nxp.com
Tested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
[kwilczynski: commit log]
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Acked-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.c   | 36 +++++++++++++++++++++++++++++++++++-
 include/linux/pci.h |  2 ++
 2 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 2f575af94e094..b53ee0920bdcf 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2090,6 +2090,28 @@ int __weak pcibios_enable_device(struct pci_dev *dev, int bars)
 	return pci_enable_resources(dev, bars);
 }
 
+static int pci_host_bridge_enable_device(struct pci_dev *dev)
+{
+	struct pci_host_bridge *host_bridge = pci_find_host_bridge(dev->bus);
+	int err;
+
+	if (host_bridge && host_bridge->enable_device) {
+		err = host_bridge->enable_device(host_bridge, dev);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static void pci_host_bridge_disable_device(struct pci_dev *dev)
+{
+	struct pci_host_bridge *host_bridge = pci_find_host_bridge(dev->bus);
+
+	if (host_bridge && host_bridge->disable_device)
+		host_bridge->disable_device(host_bridge, dev);
+}
+
 static int do_pci_enable_device(struct pci_dev *dev, int bars)
 {
 	int err;
@@ -2105,9 +2127,13 @@ static int do_pci_enable_device(struct pci_dev *dev, int bars)
 	if (bridge)
 		pcie_aspm_powersave_config_link(bridge);
 
+	err = pci_host_bridge_enable_device(dev);
+	if (err)
+		return err;
+
 	err = pcibios_enable_device(dev, bars);
 	if (err < 0)
-		return err;
+		goto err_enable;
 	pci_fixup_device(pci_fixup_enable, dev);
 
 	if (dev->msi_enabled || dev->msix_enabled)
@@ -2122,6 +2148,12 @@ static int do_pci_enable_device(struct pci_dev *dev, int bars)
 	}
 
 	return 0;
+
+err_enable:
+	pci_host_bridge_disable_device(dev);
+
+	return err;
+
 }
 
 /**
@@ -2305,6 +2337,8 @@ void pci_disable_device(struct pci_dev *dev)
 	if (atomic_dec_return(&dev->enable_cnt) != 0)
 		return;
 
+	pci_host_bridge_disable_device(dev);
+
 	do_pci_disable_device(dev);
 
 	dev->is_busmaster = 0;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index c65de9e8aa8af..63c24b5bdce56 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -602,6 +602,8 @@ struct pci_host_bridge {
 	u8 (*swizzle_irq)(struct pci_dev *, u8 *); /* Platform IRQ swizzler */
 	int (*map_irq)(const struct pci_dev *, u8, u8);
 	void (*release_fn)(struct pci_host_bridge *);
+	int (*enable_device)(struct pci_host_bridge *bridge, struct pci_dev *dev);
+	void (*disable_device)(struct pci_host_bridge *bridge, struct pci_dev *dev);
 	void		*release_data;
 	unsigned int	ignore_reset_delay:1;	/* For entire hierarchy */
 	unsigned int	no_ext_tags:1;		/* No Extended Tags */
-- 
2.53.0




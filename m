Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F9B3ED13E;
	Wed, 30 Sep 2026 19:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796948; cv=none; b=gMjrNd4rvXqPgziioNGRu/n/poqjDGdN1cJQmpnHrjRkw5GdQxor81qkeGAcRqx6l7tgBFUrdabT9POLcxJLXZOHkiMg59VgW141sNAo2aGJhKXTJjdXVizu9Pol8r74gfa95LHMFhDedhdN5uIRkgiwNdgCww//2s0Pf1xaaiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796948; c=relaxed/simple;
	bh=FsvJXlaEKHIKmyPxp50hw6krxzuMrGEyp2r48OOFBgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dRfOfFkpalewPNNwaPqXKZJUZ5bfq+szavfSupaWdlLpBLjd14ufu/F2Gq2eOuhJlfj8wJtPxiTecIr5A9gof2I+5NLl9siofY2Z7Lyxwi4HPZoingzCxpxGZil8Ok+IIDYUsMvS3wxI/XTl/Je++P1++vd+HptTITjENT+xax0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rtbm6PKK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rtbm6PKK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 277581F000FF;
	Wed, 30 Sep 2026 19:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796946;
	bh=mziziFIwdMFfgLaoRN1hxZJVjKoxvDFQkmjAezE8l5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rtbm6PKKVXjClMiI0LjVzAHIm9ummRJJxpJ1eZ7j+Nfup5EDQbnAeHvPA1UYSxokh
	 ZmUIwdfiFgr1IJs6XIObRasw029KuymHaLVDZfCh14ioaUvkjmRn+i9Px5q9Hi3XVY
	 pugX4Yd7Opsp5v6DumWDsdIY3iSUm4ONbWK1HbfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikael Etienne <mikael1022bzh@gmail.com>,
	Arthur Husband <artmoty@gmail.com>,
	Alvin Lim <alvinwylim@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	David Laight <david.laight.linux@gmail.com>,
	John Smith <imjohnsmith4000@gmail.com>,
	Lennert Buytenhek <kernel@wantstofly.org>,
	Niklas Cassel <cassel@kernel.org>,
	Roland Waltersson <roland.waltersson@netinsight.net>
Subject: [PATCH 6.6 1091/1193] x86/PCI: Disable enhanced atomics on AMD NBIO 7.7 and 7.11
Date: Wed, 30 Sep 2026 17:29:35 +0200
Message-ID: <20260930152458.473421618@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit 4fde448225123442c5796f54b7a4400e2d3cbaf6 upstream.

Multiple users report data corruption during 64-bit DMA transfers on
systems with AMD NBIO 7.7 and 7.11 controllers.

This occurs when BIOS enables AMD "enhanced atomic operations" on PCIe Root
Ports. When enhanced atomics are enabled, any 64-bit DMA access may be
corrupted.

Disable enhanced atomics using SMN for NBIO 7.7 and 7.11 based models.

Reported-by: Mikael Etienne <mikael1022bzh@gmail.com>
Closes: https://lore.kernel.org/178789300872.392066.15963676631650361573@gmail.com/
Reported-by: Arthur Husband <artmoty@gmail.com>
Closes: https://lore.kernel.org/20260406222335.379935-1-artmoty@gmail.com/
Reported-by: Alvin Lim <alvinwylim@gmail.com>
Closes: https://lore.kernel.org/20260621100844.1224301-1-alvinwylim@gmail.com/
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
[bhelgaas: commit log, s/IOVA/DMA/ in comment]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org
Cc: David Laight <david.laight.linux@gmail.com>
Cc: John Smith <imjohnsmith4000@gmail.com>
Cc: Lennert Buytenhek <kernel@wantstofly.org>
Cc: Niklas Cassel <cassel@kernel.org>
Cc: Roland Waltersson <roland.waltersson@netinsight.net>
Link: https://patch.msgid.link/20260908190600.226485-2-mario.limonciello@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/pci/fixup.c |   99 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 99 insertions(+)

--- a/arch/x86/pci/fixup.c
+++ b/arch/x86/pci/fixup.c
@@ -846,6 +846,105 @@ static void quirk_clear_strap_no_soft_re
 	}
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, 0x15b8, quirk_clear_strap_no_soft_reset_dev2_f0);
+
+/*
+ * Enhanced atomic operations can cause corruption with 64-bit DMA
+ * on these devices.
+ */
+#define RX_ENH_ATOMIC_EN		BIT(8)
+
+static const u32 nbio_7_7_pcie_smn_addrs[] = {
+	0x111401d0,
+	0x111411d0,
+	0x111421d0,
+	0x111431d0,
+	0x111441d0,
+	0x112401d0,
+	0x112411d0,
+	0x112421d0,
+	0x112431d0,
+	0x112441d0,
+	0x112451d0,
+	0x113401d0,
+	0x114401d0,
+};
+
+static const u32 nbio_7_11_pcie_smn_addrs[] = {
+	0x112401d0,
+	0x112411d0,
+	0x112421d0,
+	0x112431d0,
+	0x112441d0,
+	0x112451d0,
+	0x113401d0,
+	0x113411d0,
+	0x113421d0,
+	0x113431d0,
+	0x113441d0,
+	0x113451d0,
+};
+
+static void quirk_amd_nbio_enhanced_atomic(struct pci_dev *host_bridge,
+					   const u32 *smn_addrs,
+					   size_t nr_smn_addrs)
+{
+	bool changed = false;
+	size_t i;
+	u32 data;
+	int ret;
+
+	for (i = 0; i < nr_smn_addrs; i++) {
+		ret = amd_smn_read(0, smn_addrs[i], &data);
+		if (ret)
+			continue;
+		if (!(data & RX_ENH_ATOMIC_EN))
+			continue;
+		data = data & ~RX_ENH_ATOMIC_EN;
+		ret = amd_smn_write(0, smn_addrs[i], data);
+		if (ret)
+			continue;
+		if (changed)
+			continue;
+		ret = amd_smn_read(0, smn_addrs[i], &data);
+		if (ret)
+			continue;
+		if (data & RX_ENH_ATOMIC_EN)
+			continue;
+		changed = true;
+	}
+
+	if (changed)
+		pci_info(host_bridge, "enhanced atomics disabled\n");
+}
+
+static void quirk_amd_nbio_7_7_disable_enhanced_atomic(struct pci_dev *dev)
+{
+	quirk_amd_nbio_enhanced_atomic(dev, nbio_7_7_pcie_smn_addrs,
+				       ARRAY_SIZE(nbio_7_7_pcie_smn_addrs));
+}
+
+static void quirk_amd_nbio_7_11_disable_enhanced_atomic(struct pci_dev *dev)
+{
+	quirk_amd_nbio_enhanced_atomic(dev, nbio_7_11_pcie_smn_addrs,
+				       ARRAY_SIZE(nbio_7_11_pcie_smn_addrs));
+}
+
+/* Phoenix, Hawk Point (NBIO 7.7) */
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, 0x14E8,
+			quirk_amd_nbio_7_7_disable_enhanced_atomic);
+DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_AMD, 0x14E8,
+			quirk_amd_nbio_7_7_disable_enhanced_atomic);
+
+/* Strix, Krackan, Strix Halo (NBIO 7.11) */
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, 0x1507,
+			quirk_amd_nbio_7_11_disable_enhanced_atomic);
+DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_AMD, 0x1507,
+			quirk_amd_nbio_7_11_disable_enhanced_atomic);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, 0x1122,
+			quirk_amd_nbio_7_11_disable_enhanced_atomic);
+DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_AMD, 0x1122,
+			quirk_amd_nbio_7_11_disable_enhanced_atomic);
+
 #endif
 
 /*



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A59279DDB;
	Tue, 21 Oct 2025 20:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077047; cv=none; b=Eb4BDD/HQMdypBvTle2lKjInlEu8CPMz0eLhebyQ2iPU0zx9ZNtisGOU+RWcVcowM1hfBJzGAgRP4MG+ixZUMzvIQIohwPIb4Td8I+J8mopWv85ZCt0G6dp6R+jtHrjRra+vlKqxYAwYZuXoTE07G4vnNpxcVBISP0W6WlMhAq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077047; c=relaxed/simple;
	bh=AQXn4jtcHUaBsmMm2CQ7CGYkTS8i8e0j1u8rjljk2cw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tKVwPYY049bj1Ls6MhMIOy+Pmh4sw5EgbFf30EpechPh/X6H5R9ieT1u2nxNDh7w8CAjWfYSjRo8KB3n5YPdmEtXflp/5vQqVY5QZqRNqKg+Nr+EYhPFR3VM6IPfoML4+KZGEuu/MtFMa9rAVAxrn05LP6JiRYjAXwALcgVzPc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SdsI+Tx5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SdsI+Tx5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 115BDC4CEF5;
	Tue, 21 Oct 2025 20:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077046;
	bh=AQXn4jtcHUaBsmMm2CQ7CGYkTS8i8e0j1u8rjljk2cw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SdsI+Tx5dg78BMuKxhj/GV7xKfng1KOMVdAxxosLDeyFixm7fmCKXGpUJrNmfiEwH
	 C3NsTx7X5freb1GnwkODRL/kvSIcGQZEU9RIv4PVa046Bl3WWDpAllZNxhN0pcWTLF
	 YljVdKCqkYjKY9hnS5RBOFHbXrg8fC9MX+Np2Er8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Piotr Kwapulinski <piotr.kwapulinski@intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 119/136] PCI: Add PCI_VDEVICE_SUB helper macro
Date: Tue, 21 Oct 2025 21:51:47 +0200
Message-ID: <20251021195038.834757428@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Piotr Kwapulinski <piotr.kwapulinski@intel.com>

[ Upstream commit 208fff3f567e2a3c3e7e4788845e90245c3891b4 ]

PCI_VDEVICE_SUB generates the pci_device_id struct layout for
the specific PCI device/subdevice. Private data may follow the
output.

Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Signed-off-by: Piotr Kwapulinski <piotr.kwapulinski@intel.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Stable-dep-of: a7075f501bd3 ("ixgbevf: fix mailbox API compatibility by negotiating supported features")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/pci.h |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1067,6 +1067,20 @@ struct pci_driver {
 	.subvendor = PCI_ANY_ID, .subdevice = PCI_ANY_ID, 0, 0
 
 /**
+ * PCI_VDEVICE_SUB - describe a specific PCI device/subdevice in a short form
+ * @vend: the vendor name
+ * @dev: the 16 bit PCI Device ID
+ * @subvend: the 16 bit PCI Subvendor ID
+ * @subdev: the 16 bit PCI Subdevice ID
+ *
+ * Generate the pci_device_id struct layout for the specific PCI
+ * device/subdevice. Private data may follow the output.
+ */
+#define PCI_VDEVICE_SUB(vend, dev, subvend, subdev) \
+	.vendor = PCI_VENDOR_ID_##vend, .device = (dev), \
+	.subvendor = (subvend), .subdevice = (subdev), 0, 0
+
+/**
  * PCI_DEVICE_DATA - macro used to describe a specific PCI device in very short form
  * @vend: the vendor name (without PCI_VENDOR_ID_ prefix)
  * @dev: the device name (without PCI_DEVICE_ID_<vend>_ prefix)



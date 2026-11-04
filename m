Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793804706;
	b=py9uMV7aMaTC/ki8Pgl8/8LrtQUL8SBQ1OLNa1tGDt6/4FI9Wryux6V60YIIZYQ7o6mA
	 4e2yUh/mc2vI7yesW+qu/zmKyGUKYaY1WPek6H3uy9hi1hj9znyVCto2g+AytPbfZLIVb
	 qLPrprbSOwail6LR56qEQaSsr2MZacENApMTW7xxPrO9gHqiQufW1kL57v/3dIo8Re/8v
	 6NsgIrx/h1xv9BIbHKDzF8abiYIjeALyOr13ttmr6Ol7NgJW3UkkW5gCsVi6gnaiwaykj
	 16WTpO+4tVdXx0mMjNj4IXZTT5+v7MptSXfx7pHzgi0HbVHY2skTg5Y3lK9KNxGEuGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793804706;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=/jO2+yG7mR8PKDjRNrY9hRdNgBZtsEVpFuVsq1VkCI4=;
	b=QHtQb7ntY0iym0toNueLYiLuCc1OBAGz7aSZsXMBnTOvRNhOPNSfj0utGdzLUs4I4DPl
	 UoOhAOm96MR7C28tCPi8r9Fce4Syr0y3MtP0kj+d+lSPlrh0qUnOIj/y49EK0iL/7c/vH
	 sCxlWBzkCJnmpTjtZ5QmLzlBgHUH5NyaD8L1X/wpo/yBF8O26ZyqfRy60/yf4Nst9wabz
	 5meZuM7TQOhlh2cYLZSHi61vUNsBBvxAYvrfTdD9fzmxR0YPC9f6pGJj2VOCCaaLwSxGQ
	 Zt/21qAFqqZ5aRP8ilCNrfqum4SMsd+2W357s6j+DGtXm+KvI3ZU09mRVtYZmwhKoJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jrc6DC2o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88EE8606D818;
	Wed,  4 Nov 2026 15:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jrc6DC2o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF1A31F0093A;
	Wed,  4 Nov 2026 15:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793804706;
	bh=/jO2+yG7mR8PKDjRNrY9hRdNgBZtsEVpFuVsq1VkCI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jrc6DC2okMgM8e9RVx6DxUOTfOdAM0MtwmPBXDJzQ+g+uDDrl3e+NndA2PjQiC4RU
	 wT4P3D3YKMPjLXk64HaK72ptjBBW4AIu4dAmaY2Ii7gi8XoqxlHEJNmE0iz7m5qEB8
	 +Wu37BYgFdDybsFytrtpPhgd4gSHWsWcG9i1Zk4rh64LzqoIl2n9MtaFNlI49m5U/s
	 JIMgaIC+4WD++AohZF0q3dtiW4LPBLsXLt8+WVqJjGerLJ4yUBGvqMnKJpuVy7NYZ5
	 PwbppPJrKri/OfLyXWdlWSdqcbC6Qj7O+CJ1hEc34aZjqA45tQM1S4POYn241o1Kb+
	 FIdQ7Vhj3agNQ==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Alex Williamson <alex@shazbot.org>,
	David Woodhouse <dwmw2@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sean Christopherson <seanjc@google.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Fred Griffoul <griffoul@gmail.com>,
	iommu@lists.linux.dev,
	kvm@vger.kernel.org,
	patches@lists.linux.dev
Subject: [RFC PATCH v4 15/25] vfio/pci: Check command enable changes before updating device state
Date: Wed,  4 Nov 2026 20:33:12 +0530
Message-ID: <20261104150322.3516320-16-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261104150322.3516320-1-aneesh.kumar@kernel.org>
References: <20261104150322.3516320-1-aneesh.kumar@kernel.org>
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

Add checks in vfio_basic_config_write() for changes to Bus Master Enable
and Memory Enable. Move the existing acquisition of vdev->memory_lock
before reading PCI_COMMAND so the read, checks and updates all occur
while the lock is held for write.

Read Bus Master Enable from hardware and Memory Enable from vconfig,
which also tracks the setting for VFs. If vfio_pci_bar_state_change_allowed()
returns false, reject changes to either bit with -EBUSY before updating
hardware or vconfig. Allow writes that leave both bits unchanged.

Memory Enable controls BAR decoding, while Bus Master Enable controls
device-initiated DMA. Later patches reject changes to both while the
device supplies guest_memfd backing. The check currently returns true,
preserving existing behavior.

Cc: Alex Williamson <alex@shazbot.org>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/vfio/pci/vfio_pci_config.c | 64 +++++++++++++++++++++---------
 1 file changed, 46 insertions(+), 18 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 9914f3ac69ae..5b97f64ab3ba 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -568,19 +568,49 @@ static int vfio_basic_config_write(struct vfio_pci_core_device *vdev, int pos,
 	struct pci_dev *pdev = vdev->pdev;
 	__le16 *virt_cmd;
 	u16 new_cmd = 0;
+	bool zap_bars_required = false;
 	int ret;
 
 	virt_cmd = (__le16 *)&vdev->vconfig[PCI_COMMAND];
 
 	if (offset == PCI_COMMAND) {
 		bool phys_mem, virt_mem, new_mem, phys_io, virt_io, new_io;
-		u16 phys_cmd;
+		bool enable_bits_changed;
+		u16 phys_cmd, old_cmd;
+
+		new_cmd = le32_to_cpu(val);
+		new_mem = !!(new_cmd & PCI_COMMAND_MEMORY);
+		zap_bars_required =
+			vfio_pci_bar_state_change_allowed(vdev) && !new_mem;
+
+		if (zap_bars_required) {
+			ret = vfio_pci_begin_bar_state_change(vdev);
+			if (ret)
+				return ret;
+			vfio_pci_dma_buf_move(vdev, true);
+		} else {
+			down_write(&vdev->memory_lock);
+		}
 
 		ret = pci_user_read_config_word(pdev, PCI_COMMAND, &phys_cmd);
-		if (ret)
-			return ret;
+		if (ret) {
+			count = ret;
+			goto out_unlock;
+		}
 
-		new_cmd = le32_to_cpu(val);
+		/*
+		 * Check BME and Memory Enable changes while holding memory_lock
+		 * for write, before updating hardware or vconfig. Return an
+		 * error rather than silently masking a rejected write.
+		 */
+		old_cmd = (phys_cmd & ~PCI_COMMAND_MEMORY) |
+			  (le16_to_cpu(*virt_cmd) & PCI_COMMAND_MEMORY);
+		enable_bits_changed = (old_cmd ^ new_cmd) &
+				      (PCI_COMMAND_MASTER | PCI_COMMAND_MEMORY);
+		if (enable_bits_changed && !vfio_pci_bar_state_change_allowed(vdev)) {
+			count = -EBUSY;
+			goto out_unlock;
+		}
 
 		phys_io = !!(phys_cmd & PCI_COMMAND_IO);
 		virt_io = !!(le16_to_cpu(*virt_cmd) & PCI_COMMAND_IO);
@@ -588,14 +618,6 @@ static int vfio_basic_config_write(struct vfio_pci_core_device *vdev, int pos,
 
 		phys_mem = !!(phys_cmd & PCI_COMMAND_MEMORY);
 		virt_mem = !!(le16_to_cpu(*virt_cmd) & PCI_COMMAND_MEMORY);
-		new_mem = !!(new_cmd & PCI_COMMAND_MEMORY);
-
-		if (!new_mem) {
-			vfio_pci_zap_and_down_write_memory_lock(vdev);
-			vfio_pci_dma_buf_move(vdev, true);
-		} else {
-			down_write(&vdev->memory_lock);
-		}
 
 		/*
 		 * If the user is writing mem/io enable (new_mem/io) and we
@@ -614,11 +636,8 @@ static int vfio_basic_config_write(struct vfio_pci_core_device *vdev, int pos,
 	}
 
 	count = vfio_default_config_write(vdev, pos, count, perm, offset, val);
-	if (count < 0) {
-		if (offset == PCI_COMMAND)
-			up_write(&vdev->memory_lock);
-		return count;
-	}
+	if (count < 0)
+		goto out_unlock;
 
 	/*
 	 * Save current memory/io enable bits in vconfig to allow for
@@ -632,9 +651,18 @@ static int vfio_basic_config_write(struct vfio_pci_core_device *vdev, int pos,
 
 		if (__vfio_pci_memory_enabled(vdev))
 			vfio_pci_dma_buf_move(vdev, false);
-		up_write(&vdev->memory_lock);
 	}
 
+out_unlock:
+	if (offset == PCI_COMMAND) {
+		if (zap_bars_required)
+			vfio_pci_end_bar_state_change(vdev);
+		else
+			up_write(&vdev->memory_lock);
+	}
+	if (count < 0)
+		return count;
+
 	/* Emulate INTx disable */
 	if (offset >= PCI_COMMAND && offset <= PCI_COMMAND + 1) {
 		bool virt_intx_disable;
-- 
2.43.0


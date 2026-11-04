Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793804700;
	b=XWwo2Yphm49N8iytCvcXv92IqOku4gWEGNup/ZlYJ5KjJoe5T4JGCrxMBAF18drLEBSa
	 MUgu2C/WbVjzd+geMTuq+cnoQ6FCBfsv+N2X/Bo5wCOI6bSGGQJpwhRTc8Ouun3ns5YE/
	 rxsdsW2f3HyEpNZ8U2Eaaiy3wGv0eEY2x738BABxcHXeZwanyZzOvrPpCgIoC/Z1eAwcn
	 /q3cpUmuPgh25YtknGcAA7Z08MK7NhMGUraw1rDEbxjMQ1zOF/spwZUXlEXyGtLugLzHq
	 OB9fsFMD9gyRw7HdfaoUtfNroDxhPkb2XIoPNYkM16AFH9Xo/DXg0+QRxcBzO3M1wbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793804700;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=EKP4DTD309tHMKd0ry1eHcsj3cMGURG0sNGypb1ziDM=;
	b=ybb52ZupfPEe9UArq25M6bRiaGXD9qCyHkfq4RFyl7eZUHPBe9T7N2WK5W+feXU22TWo
	 VCwXpRDlGCxx2gcUMDadmlufmPPnRUC3Fk5jpZk6NBbNHuK/V6l9hFcpfPGLicn8zHppJ
	 QkdYIAWGIfNd7vXweakWB2sFGCsSEMX+x0R0SYpDzmUdtInOwBlfXTjW2Bqk4Nl1jPI03
	 plzvRTanl5sUeYRUolmetYC1M7u/GPtCQvc+6C4XQGP0vHTFC8BeZVVNRB5XoyQagy0yd
	 gDaBlKhXTYeqlMlVT41ivaKDQmMfWG6mwZnYLDiJCsXaE+a7CRnKQyYjoh40g9/pd+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=liSetdsK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1616606EE82;
	Wed,  4 Nov 2026 15:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=liSetdsK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C13561F000C1;
	Wed,  4 Nov 2026 15:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793804700;
	bh=EKP4DTD309tHMKd0ry1eHcsj3cMGURG0sNGypb1ziDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=liSetdsKSqWdd0U3yRaSUI0RsrQAYb+Z6deM9fVZXaUR/yrGfg92W7rmQsX1BiZL6
	 CeWDlDUXBWMjjugHzgUilCOk4I/NetPjZEC+ZXExVL2iAdrZnw1t1pQuoAWT27O07j
	 hLbbuQgPRNoDf7QIf39tJ3MPKdoZBA8kTJekc1OfXFQNrC5/7HH2ammrLZKU5yznkA
	 HObvfkObsgMKVgcb7AWfC/xw8G7EyBu/owSLXjy5Y7csiIvhVtrZ+T1rvgbc7SCcva
	 WSQQX2PyeHin9WLUB9Sybrw7aVTlaQI7dCFMo+uMIJ6IzTb3B+vA/z4u7ESps/87sG
	 3Ova+1k8hG5bg==
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
Subject: [RFC PATCH v4 14/25] vfio/pci: Add helpers to check and serialize BAR state changes
Date: Wed,  4 Nov 2026 20:33:11 +0530
Message-ID: <20261104150322.3516320-15-aneesh.kumar@kernel.org>
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

Add vfio_pci_begin_bar_state_change() to check whether a BAR state
change is allowed before taking vdev->memory_lock for write and removing
existing BAR mappings with vfio_pci_zap_bars(). Return -EBUSY if the
check fails, before removing mappings or changing hardware.

Keep memory_lock held on success until the caller finishes the hardware
operation and calls vfio_pci_end_bar_state_change().

vfio_pci_bar_state_change_allowed() initially returns true. Later
patches use these helpers for command-register writes, reset and power
changes, then reject those operations while the device supplies
guest_memfd backing.

Cc: Alex Williamson <alex@shazbot.org>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/vfio/pci/vfio_pci_core.c | 15 +++++++++++++++
 drivers/vfio/pci/vfio_pci_priv.h | 10 ++++++++++
 2 files changed, 25 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index fcbb2da860e2..99778cf0cc3c 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1709,6 +1709,21 @@ void vfio_pci_zap_and_down_write_memory_lock(struct vfio_pci_core_device *vdev)
 	vfio_pci_zap_bars(vdev);
 }
 
+int vfio_pci_begin_bar_state_change(struct vfio_pci_core_device *vdev)
+{
+	if (!vfio_pci_bar_state_change_allowed(vdev))
+		return -EBUSY;
+
+	down_write(&vdev->memory_lock);
+	vfio_pci_zap_bars(vdev);
+	return 0;
+}
+
+void vfio_pci_end_bar_state_change(struct vfio_pci_core_device *vdev)
+{
+	up_write(&vdev->memory_lock);
+}
+
 u16 vfio_pci_memory_lock_and_enable(struct vfio_pci_core_device *vdev)
 {
 	u16 cmd;
diff --git a/drivers/vfio/pci/vfio_pci_priv.h b/drivers/vfio/pci/vfio_pci_priv.h
index 4e7162234a2e..0af93f6d9a8a 100644
--- a/drivers/vfio/pci/vfio_pci_priv.h
+++ b/drivers/vfio/pci/vfio_pci_priv.h
@@ -11,6 +11,13 @@
 /* Cap maximum number of ioeventfds per device (arbitrary) */
 #define VFIO_PCI_IOEVENTFD_MAX		1000
 
+/* Later patches reject BAR state changes while guest_memfd uses the device. */
+static inline bool
+vfio_pci_bar_state_change_allowed(struct vfio_pci_core_device *vdev)
+{
+	return true;
+}
+
 struct vfio_pci_ioeventfd {
 	struct list_head	next;
 	struct vfio_pci_core_device	*vdev;
@@ -69,6 +76,9 @@ int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev,
 			     pci_power_t state);
 
 void vfio_pci_zap_and_down_write_memory_lock(struct vfio_pci_core_device *vdev);
+/* Success retains memory_lock through the hardware operation. */
+int vfio_pci_begin_bar_state_change(struct vfio_pci_core_device *vdev);
+void vfio_pci_end_bar_state_change(struct vfio_pci_core_device *vdev);
 u16 vfio_pci_memory_lock_and_enable(struct vfio_pci_core_device *vdev);
 void vfio_pci_memory_unlock_and_restore(struct vfio_pci_core_device *vdev,
 					u16 cmd);
-- 
2.43.0


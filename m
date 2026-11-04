Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793804749;
	b=eH1qUbB93abiAIg4cTo04SoUFPssdpdNcC8UCyWgkjuLERjgg++ux5CXgpCDYGSrNTqB
	 bIcCw9Mrrq/Qn1K+o29cyLlo2fr/i9nzi2I3iKwhWOVtUQj7vOYP7WXer7nb2lbTmeddK
	 hOplsKfv0EYNoUlUnpAbL2oF1VFHaYlYb56x2B19GO+EC2MzR6KUC8cgPb4zC4+SLh2N7
	 UwFNso2V4f6efE+Gnaa23kmG422EpQdyZQBTfo8gOuMxffKS81qCZA6jdcCCBgc+Y6N7s
	 0C9wnvM62l8LC5QqXuEKLuU55ZjONQkdjiflFL6gGnrz5QHnfl0UxPoJ32hG4Kf5HhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793804749;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=1LPHBfzTrwalEQ3C0P9CuC32/x2LdGF3F3JzlLtj2JM=;
	b=ldzPmMtabrxgp7om7RmPGF9l2D9Fxl8KDgk7PtIFg0050ZkBXeclFPOgkJP72ZfeLVD9
	 f+87DE9J589svyN5atbN+SqfH6XsWV6KZrNjvKYVn0a45zIxe/N5xUgmjYLzLMKUHUnj6
	 6G1IBujsLtDk4NyZwssPHmo34etBmoLB+5JOk3uNcT/Ru1se/x4HYGbzt/1+AG30IFxZ4
	 hnC1UaZF5mbtjZtXmOyAo1u9VBwn/X+PNlwX4emQwSQn6BqRLtpH76KFoMpcmkjV9w+Ti
	 ubkO++0Vl+8N1ayIJ1LUcIEOENb5+IEQpieH2FiEVLzMV1VZ8qpOMG2Teg/k9MaD+Vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BwOwtQFP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DDEE606A31B;
	Wed,  4 Nov 2026 15:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BwOwtQFP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1E7E1F00919;
	Wed,  4 Nov 2026 15:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793804749;
	bh=1LPHBfzTrwalEQ3C0P9CuC32/x2LdGF3F3JzlLtj2JM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BwOwtQFPTdNVRiIeyaG+v129nL1rrkGFH5++ljM3lzLp25PiGGENlp4Wzxv2U7lnU
	 ilFq7Dgb7Jv6YoIPtuyGSoEGVphBv2n8tVofRaYPX+ItZ2RLchFiMPcQI759V5ZV7l
	 AKo/qH5qjTvr/AMHLkr0GeRv4HNx9q7BoQ2pc7EjBG5Uf+Ucptc4hdRLtExDN2SSzK
	 kZ1IrixSQTnn06JRNul1MABRjgcbhmbL/gGJHF5nsSSJ0EJYUMw8arIu1qFz53H5IR
	 xWh0mnlhNUpp2m7bc+PoL6mpuQi6fp7VzkG/ypL3Z+JIP1Z842WCw/oVdzxpTyREil
	 gEYvOBM+rT9qw==
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
Subject: [RFC PATCH v4 22/25] vfio/pci: Require D0 before providing guest_memfd BAR backing
Date: Wed,  4 Nov 2026 20:33:19 +0530
Message-ID: <20261104150322.3516320-23-aneesh.kumar@kernel.org>
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

Guest_memfd needs the device in D0 while its BARs supply backing memory.
Lower-power states can limit device operation or make BAR accesses
unavailable; D3cold removes power from the device entirely.

Add vfio_pci_core_pm_pin_d0() to resume the device and retain a
runtime-PM reference. Check current_state under memory_lock and return
EBUSY unless the device is in D0. An explicit PMCSR write can leave the
device in a lower power state even when runtime PM considers it active.

The retained reference prevents runtime suspend. The caller must also
prevent explicit power-state changes and drop the reference with
pm_runtime_put() when finished. The following provider patch holds it
until provider release.

Cc: Alex Williamson <alex@shazbot.org>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/vfio/pci/vfio_pci_core.c | 28 ++++++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_priv.h |  2 ++
 2 files changed, 30 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index b8e574194f07..1c606da81879 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -370,6 +370,34 @@ int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev, pci_power_t stat
 	return ret;
 }
 
+/**
+ * vfio_pci_core_pm_pin_d0() - resume a device and retain runtime PM
+ * @vdev: device whose runtime-PM reference is acquired
+ *
+ * Require D0 after resuming: explicit PMCSR writes can leave a
+ * runtime-active function in a lower power state. The caller must exclude
+ * explicit power-state changes while relying on this reference.
+ *
+ * Return: 0 with a reference to release using pm_runtime_put(), or a negative
+ * error with no reference held.
+ */
+int vfio_pci_core_pm_pin_d0(struct vfio_pci_core_device *vdev)
+{
+	int ret;
+
+	ret = pm_runtime_resume_and_get(&vdev->pdev->dev);
+	if (ret < 0)
+		return ret;
+
+	down_read(&vdev->memory_lock);
+	ret = vdev->pdev->current_state == PCI_D0 ? 0 : -EBUSY;
+	up_read(&vdev->memory_lock);
+	if (ret)
+		pm_runtime_put(&vdev->pdev->dev);
+
+	return ret;
+}
+
 static int vfio_pci_runtime_pm_entry(struct vfio_pci_core_device *vdev,
 				     struct eventfd_ctx *efdctx)
 {
diff --git a/drivers/vfio/pci/vfio_pci_priv.h b/drivers/vfio/pci/vfio_pci_priv.h
index a2501759e805..43d74c46e841 100644
--- a/drivers/vfio/pci/vfio_pci_priv.h
+++ b/drivers/vfio/pci/vfio_pci_priv.h
@@ -78,6 +78,8 @@ void vfio_pci_uninit_perm_bits(void);
 int vfio_config_init(struct vfio_pci_core_device *vdev);
 void vfio_config_free(struct vfio_pci_core_device *vdev);
 
+int vfio_pci_core_pm_pin_d0(struct vfio_pci_core_device *vdev);
+
 int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev,
 			     pci_power_t state);
 
-- 
2.43.0


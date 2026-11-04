Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793804719;
	b=kVc94U0IM/Yy58CgXsrKByAsPism2DhAfpfVdhQgZgBg5t7UlbkunqZTDFNxIod+UbcH
	 yvnxmPCb4Z8P6RvBHf0KPkzpRikCTaKR+iOKJIrqwaivifdyKuK0370WvgkROtGfQerF1
	 d12LKv8aAUrUcK+U6MvEbuskpQyhM489665wr2QXlVGyQ4GgoeTY8A184iStyDJhddlo0
	 fnxQlYU1w3Z8Eltnf5xzrGkZBB85qNkPs2mmmXrPpD9W46aSjIuNMuzRRTYiuR/ryDscY
	 pqETSVjVGt33OfDjXOSJwix4pl0zEDpJIbe54KOtr+7W4Qx+DhDcZEdfgUcMW2qKEDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793804719;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=yEOAYpdsXgUQ+4ToTTCgX4AT9YMGXDyDncVK6pNXM2Q=;
	b=r/2nVK5b5TVJQl/QQzjT3U1E5GdeF2i5DTMke4mcDYriQbiL2Y28pnxzxP4Ib9Uap1v4
	 HS9VOjoqziHvNdlMtBtH8T3mUIP0VysH8tXHP9uynVUbRc2nD1G/l4H+R9AeraR66l1E5
	 1dI6hdv+i5uFXZvLB17nRo0vLzGg1wLnJr/yV+lVrzzcvqmA7KHmtKmxD1XWk0d/zMn35
	 wnVWJ89fTndaJthY7NMfsWS4hTOXAQJmzLFtcM9jYlKj9b8pJUEIi/iBFXe6pK5riLHxU
	 xT1fka9a0RkLjr2u0n89b/lTvgMrLjPI0RaC31XTYeYtVdI6fDnPiEqbPSJd/OJZyAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Iqvx1CRl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E41606A331;
	Wed,  4 Nov 2026 15:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Iqvx1CRl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18F9F1F00A02;
	Wed,  4 Nov 2026 15:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793804718;
	bh=yEOAYpdsXgUQ+4ToTTCgX4AT9YMGXDyDncVK6pNXM2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Iqvx1CRlN5QsMmowZd82bWm23biyoxv2z8ieQd6NZGIwNmCxaOCjImtkWu6mm4vEA
	 bvQEEZigN2nNph3rLxeZL6di9ZqwNf2mx48oUzQ3J9lHXPb90HXKTCRPbK6IvfUT1Z
	 oX9kopILynROiua6Y4UAmAyFyhS7db/2VB6RxXLUM3T0QKGNZaZ2ybkQICa3mXli7f
	 /XoDNAqNRDxqi7nXnau8KduyOhZo2WlJSJZI5XQ9XjtPajrxilAQJ3QFKApd3eIQ4g
	 dC/CtphNOP/mWruV5id69GaWl8n9DqFgcUjvLjbAUzEGJ4ftgeesA1BfgMFq2d18Js
	 a7y0MzEKaC5GQ==
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
Subject: [RFC PATCH v4 17/25] vfio/pci: Check low-power requests before updating device state
Date: Wed,  4 Nov 2026 20:33:14 +0530
Message-ID: <20261104150322.3516320-18-aneesh.kumar@kernel.org>
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

In vfio_pm_config_write(), check requests for D1, D2 or D3hot before
vfio_default_config_write() updates vconfig. Return -EBUSY if
vfio_pci_bar_state_change_allowed() returns false. D0 requests and
writes to unrelated PMCSR fields retain their existing handling.

Use vfio_pci_begin_bar_state_change() for D3hot transitions in
vfio_lock_and_set_power_state(), and return its error to the config
write caller. On success, retain the existing behavior

In vfio_pci_runtime_pm_entry(), reject explicit low-power entry before
removing BAR mappings or dropping the runtime-PM reference.

These checks currently allow all requests. Later patches reject
low-power requests while the device supplies guest_memfd backing,
because entering a lower power state can make mapped BAR PFNs
inaccessible.

Cc: Alex Williamson <alex@shazbot.org>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/vfio/pci/vfio_pci_config.c | 30 ++++++++++++++++++++++++++----
 drivers/vfio/pci/vfio_pci_core.c   | 30 +++++++++++++++++-------------
 drivers/vfio/pci/vfio_pci_priv.h   |  1 -
 3 files changed, 43 insertions(+), 18 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 537e7f8bc884..014f865c1eaf 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -755,11 +755,15 @@ static bool vfio_af_flr_requested(int offset, __le32 val)
  * It takes all the required locks to protect the access of power related
  * variables and then invokes vfio_pci_set_power_state().
  */
-static void vfio_lock_and_set_power_state(struct vfio_pci_core_device *vdev,
+static int vfio_lock_and_set_power_state(struct vfio_pci_core_device *vdev,
 					  pci_power_t state)
 {
+	int ret;
+
 	if (state >= PCI_D3hot) {
-		vfio_pci_zap_and_down_write_memory_lock(vdev);
+		ret = vfio_pci_begin_bar_state_change(vdev);
+		if (ret)
+			return ret;
 		vfio_pci_dma_buf_move(vdev, true);
 	} else {
 		down_write(&vdev->memory_lock);
@@ -768,19 +772,34 @@ static void vfio_lock_and_set_power_state(struct vfio_pci_core_device *vdev,
 	vfio_pci_set_power_state(vdev, state);
 	if (__vfio_pci_memory_enabled(vdev))
 		vfio_pci_dma_buf_move(vdev, false);
-	up_write(&vdev->memory_lock);
+	if (state >= PCI_D3hot)
+		vfio_pci_end_bar_state_change(vdev);
+	else
+		up_write(&vdev->memory_lock);
+	return 0;
+}
+
+static bool vfio_pm_low_power_requested(int offset, __le32 val)
+{
+	return offset == PCI_PM_CTRL &&
+	       (le32_to_cpu(val) & PCI_PM_CTRL_STATE_MASK);
 }
 
 static int vfio_pm_config_write(struct vfio_pci_core_device *vdev, int pos,
 				int count, struct perm_bits *perm,
 				int offset, __le32 val)
 {
+	if (vfio_pm_low_power_requested(offset, val) &&
+	    !vfio_pci_bar_state_change_allowed(vdev))
+		return -EBUSY;
+
 	count = vfio_default_config_write(vdev, pos, count, perm, offset, val);
 	if (count < 0)
 		return count;
 
 	if (offset == PCI_PM_CTRL) {
 		pci_power_t state;
+		int ret;
 
 		switch (le32_to_cpu(val) & PCI_PM_CTRL_STATE_MASK) {
 		case 0:
@@ -797,7 +816,10 @@ static int vfio_pm_config_write(struct vfio_pci_core_device *vdev, int pos,
 			break;
 		}
 
-		vfio_lock_and_set_power_state(vdev, state);
+		ret = vfio_lock_and_set_power_state(vdev, state);
+
+		if (ret)
+			return ret;
 	}
 
 	return count;
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index f31fbd980f3e..6612728a21a4 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -373,24 +373,30 @@ int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev, pci_power_t stat
 static int vfio_pci_runtime_pm_entry(struct vfio_pci_core_device *vdev,
 				     struct eventfd_ctx *efdctx)
 {
+	int ret;
+
 	/*
 	 * The vdev power related flags are protected with 'memory_lock'
 	 * semaphore.
 	 */
-	vfio_pci_zap_and_down_write_memory_lock(vdev);
+	ret = vfio_pci_begin_bar_state_change(vdev);
+	if (ret)
+		return ret;
 	vfio_pci_dma_buf_move(vdev, true);
 
 	if (vdev->pm_runtime_engaged) {
-		up_write(&vdev->memory_lock);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out_unlock;
 	}
 
-	vdev->pm_runtime_engaged = true;
+	WRITE_ONCE(vdev->pm_runtime_engaged, true);
 	vdev->pm_wake_eventfd_ctx = efdctx;
 	pm_runtime_put_noidle(&vdev->pdev->dev);
-	up_write(&vdev->memory_lock);
+	ret = 0;
 
-	return 0;
+out_unlock:
+	vfio_pci_end_bar_state_change(vdev);
+	return ret;
 }
 
 static int vfio_pci_core_pm_entry(struct vfio_pci_core_device *vdev, u32 flags,
@@ -445,7 +451,11 @@ static int vfio_pci_core_pm_entry_with_wakeup(
 static void __vfio_pci_runtime_pm_exit(struct vfio_pci_core_device *vdev)
 {
 	if (vdev->pm_runtime_engaged) {
-		vdev->pm_runtime_engaged = false;
+		/*
+		 * Guest_memfd provider setup reads this flag with READ_ONCE()
+		 * without memory_lock; runtime resume can clear it concurrently.
+		 */
+		WRITE_ONCE(vdev->pm_runtime_engaged, false);
 		pm_runtime_get_noresume(&vdev->pdev->dev);
 
 		if (vdev->pm_wake_eventfd_ctx) {
@@ -1705,12 +1715,6 @@ static void vfio_pci_zap_bars(struct vfio_pci_core_device *vdev)
 	unmap_mapping_range(core_vdev->inode->i_mapping, start, len, true);
 }
 
-void vfio_pci_zap_and_down_write_memory_lock(struct vfio_pci_core_device *vdev)
-{
-	down_write(&vdev->memory_lock);
-	vfio_pci_zap_bars(vdev);
-}
-
 int vfio_pci_begin_bar_state_change(struct vfio_pci_core_device *vdev)
 {
 	if (!vfio_pci_bar_state_change_allowed(vdev))
diff --git a/drivers/vfio/pci/vfio_pci_priv.h b/drivers/vfio/pci/vfio_pci_priv.h
index 0af93f6d9a8a..f7b3178cc890 100644
--- a/drivers/vfio/pci/vfio_pci_priv.h
+++ b/drivers/vfio/pci/vfio_pci_priv.h
@@ -75,7 +75,6 @@ void vfio_config_free(struct vfio_pci_core_device *vdev);
 int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev,
 			     pci_power_t state);
 
-void vfio_pci_zap_and_down_write_memory_lock(struct vfio_pci_core_device *vdev);
 /* Success retains memory_lock through the hardware operation. */
 int vfio_pci_begin_bar_state_change(struct vfio_pci_core_device *vdev);
 void vfio_pci_end_bar_state_change(struct vfio_pci_core_device *vdev);
-- 
2.43.0


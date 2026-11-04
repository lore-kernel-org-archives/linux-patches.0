Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793804694;
	b=eMI3W/8f2HVAEiacPnC6UmP/4qf6+A8XXhg5Wk+f8Yz549zKuGUKlsSXugTZcVfATGzo
	 xzDrt06mN7EAb5jqR2Hhg8hfGD3XXhfrDZQwULUOdNWt6gALKcwa9uEBf9cyORRgGkDNp
	 EqtP0UG5X/CYQdWJYiW02QZdvVLedn4aSMBZKK939p4OVTVwLbgFtd5/OcBU0aKuw6joS
	 c3w+/XMhMGPtJfYioHVWL76qKbWA8enowxFKubWkxuDaeFrfEewPzebGWXUaCYY82Tq17
	 TPxatQR34QrLgaZSvwOOj2EnQAWBam7SFhoUipY+1vsgMCveAV5leL3l5plLRHR7nOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793804694;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=VIHbFakvtRYmrKmEheBsDAQ67RJgya9s4SAj1gMN2CQ=;
	b=gf5f9v0+DQRGzzKKvIxm8OInUi25SVNeAW8WxPegNZDSogrtQOYmAx0UC7xQlNnV7GcA
	 7JkSElNMc8nkgyNELsVnNX7APihjnk9qzUijZTfUGE23qZmWnSdKAG3UdQi0CXiSLqCfr
	 C9S96VIgedI53tteseoUtl2llaSHLyQgMcf9csM2xPyw/VugrNJsCFpkZd5MO5JmODYzN
	 8ukPasEzM9B/x+N2uuTbSKTyDWqzmHoegxNXoNj1yY72rJgAvVjevcuh9zPFwbe0/qy8D
	 CgbBoCzbU7R5qhanl8GD1ANnuBT7qSkNuxC87plqMAeGq523OH1HR6JXGIvb5DkQn2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QY+SIf8F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D90E606A338;
	Wed,  4 Nov 2026 15:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QY+SIf8F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A68501F0093A;
	Wed,  4 Nov 2026 15:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793804694;
	bh=VIHbFakvtRYmrKmEheBsDAQ67RJgya9s4SAj1gMN2CQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QY+SIf8FWvjX5QhUGC7LINeUhwJrVmbPkU0gCVOhMDy9fy7S6ffhBW7GPIIPwxIKb
	 Zm/nhsWza68aq3T8tn8ysDgd1jo/G1POvKqtvYj4GADAc1LVE5SEDoMgLVRYDCjyUS
	 DyfsGfW4HQp4SXXCCa8YiP1QMykhRbL6LrWJWz84oaIFJ69Xk+5AnPrIrfMQKPevLt
	 mMGTm5jPA1V/yVTiUJoo/Eofyq2fB/ZSDZbBWyEyKqODIaGu6bsFysxErv+lbLntyV
	 36ruBV4U0Y950wikEcNK3PX4H2lYdSxU+Wel8y0X7I4S5BmwrC7BwPFUnBqWaEMHdz
	 z6BRRVgMtqc5w==
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
Subject: [RFC PATCH v4 13/25] vfio: Track device use by guest_memfd
Date: Wed,  4 Nov 2026 20:33:10 +0530
Message-ID: <20261104150322.3516320-14-aneesh.kumar@kernel.org>
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

Add gmem_attached to record whether a device supplies guest_memfd
backing, and initialize gmem_lock.

Changing gmem_attached requires both gmem_lock held for write and
dev_set->lock held. This lets device file operations check the flag
under gmem_lock for read, while reset checks use dev_set->lock.

This patch adds the flag and initializes the lock. Later patches set
the flag after successful provider setup and clear it after provider
cleanup.

Cc: Alex Williamson <alex@shazbot.org>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/vfio/vfio_main.c | 1 +
 include/linux/vfio.h     | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 4e5d738ccf4b..ff49f2fdb602 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -290,6 +290,7 @@ static int vfio_init_device(struct vfio_device *device, struct device *dev,
 		return ret;
 	}
 
+	init_rwsem(&device->gmem_lock);
 	device->index = ret;
 	init_completion(&device->comp);
 	device->dev = dev;
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 0cc91c6f96d2..2436b8bd600a 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -37,6 +37,13 @@ struct vfio_device_set {
 };
 
 struct vfio_device {
+	/*
+	 * Serializes guest_memfd provider setup and teardown with device file
+	 * operations.
+	 */
+	struct rw_semaphore gmem_lock;
+	/* Updates hold gmem_lock for write and dev_set->lock; either permits reads. */
+	bool gmem_attached;
 	struct device *dev;
 	const struct vfio_device_ops *ops;
 	/*
-- 
2.43.0


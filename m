Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793517653;
	b=eQ3gVMJkU9DNdRV+bx54YFvTSWKPPfI4WCzAW/NB+gkW6oc7vsEnIT5LKZ+YyPkGy1vq
	 4rEqXcL6ZLjsxxMPee9PgslU9yRD9kPYnASDfYfgmciw4ruMcUCD95OY/xjhSCTqHr5Pi
	 GxdGy+EkfoH0MxaqrWmUVXYK93t2GpeDT4WcxRirQTpzsXTK+Zw6FL9YjqTjTcHhZkhWY
	 9RN6ODsHsyCcq57AvP2ITP645/KuywHrPg99+Aq8Z/zjfrq0HcMz1sl8SvJHzFNmcX6Km
	 OT680rbJcpw/TQpwEi43AtVedPN86aJKol2Oxw67p8ZmkSOOqbqZn2HLy9sg0+piaxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793517653;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=OIH8u8cHvk9eCLl7Fc4Rcyfd0REhWze1TpO0WPerFwQ=;
	b=JvPrMjgHpkbxj9OfEvNKTmTTHVFYzee4nEA5lPm3VGIIKTT0DdjGiOxyjJOppA+FmRNF
	 nvCYHOStS5/TCQtuN2yR4X53TFr9jovlUSAvS8omrdoudu+M35vZWdDV5zkE6l/OaKaY7
	 rFZKd5yl4OdGgNmz02Jk6crrtiIVjSmurENtz94oXwOPRs1vtPIfmVT2dfKo8iZLmLfKR
	 8+flM731gXZoVQ3vAFA3TXDhP00DaOVIrAI5NFO5txS2UZTQXqNWLn9ofRH/ATHeM5Ob1
	 y/ubjiSHdcqLnlfhhyVPebyovaOvAgQdEzRmBQexT/ylraGBxm0PWkMAW4ivkYoi9XA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VUe9aFfC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D10D606A327;
	Sun,  1 Nov 2026 07:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VUe9aFfC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CAFE1F000C1;
	Sun,  1 Nov 2026 07:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793517652;
	bh=OIH8u8cHvk9eCLl7Fc4Rcyfd0REhWze1TpO0WPerFwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VUe9aFfChFX8vrLUQ2+0wt+PyMuQ+MDFGECPV/V+XNAFuWzfktQBobXxE7ZCcYNO/
	 5zhNXBlbnUmBztCEAKTwxs+zWpY0pd03Cydah8+YoCwo+Sf9ESy/MLTeoAUMXMOTA3
	 U6bK/o+lY+IId/Np8XEjO3Ei3bldm8r9Dtd/j8yafF6Zqj9tp1TAKI0cB4Rn4dOyYT
	 cegcE3mMbY+YWrbDZsAQNgjgnse0rQCtbgr2XL1wHfMK6D82a9WFhfKDN3r4EpGAAF
	 fq7jksgx6GEfUPf+6GF2HTzIR2fq52kzYOhYcAtlh7upTYLH5+jjsBnTUXveJYD3j8
	 mDbnzfk1S4C1w==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Alex Williamson <alex@shazbot.org>,
	David Woodhouse <dwmw2@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sean Christopherson <seanjc@google.com>,
	Will Deacon <will@kernel.org>,
	Alexey Kardashevskiy <aik@amd.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Fred Griffoul <griffoul@gmail.com>,
	iommu@lists.linux.dev,
	kvm@vger.kernel.org,
	patches@lists.linux.dev
Subject: [RFC PATCH v3 09/13] KVM: guest_memfd: Expose device provider private state
Date: Sun,  1 Nov 2026 12:49:23 +0530
Message-ID: <20261101071928.2462549-10-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261101071928.2462549-1-aneesh.kumar@kernel.org>
References: <20261101071928.2462549-1-aneesh.kumar@kernel.org>
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

Expose a callback to query whether private ranges remain. Initialize it
before attaching the device provider so the vDEVICE can coordinate
protected cleanup. Keep the summary inode-owned and valid until release;
providers may access the VM only during attach and core callbacks.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: kvm@vger.kernel.org
Cc: patches@lists.linux.dev
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 include/linux/guest_memfd.h |  7 +++++++
 virt/kvm/guest_memfd.c      | 10 ++++++++++
 2 files changed, 17 insertions(+)

diff --git a/include/linux/guest_memfd.h b/include/linux/guest_memfd.h
index 8a93004aa9e7..5e5725398ab0 100644
--- a/include/linux/guest_memfd.h
+++ b/include/linux/guest_memfd.h
@@ -24,12 +24,19 @@ struct guest_memfd_device_binding {
  * @flags: GUEST_MEMFD_FLAG_* creation flags
  * @binding: Mapping owner and device ID set by attach(), with the underlying
  *           resources pinned until release()
+ * @has_private: Check whether any committed private ranges remain
+ *
+ * The VM is valid during attach() and core-initiated callbacks. Providers
+ * must not use this pointer for asynchronous VM access.
+ * release() may run after the VM reference has been dropped. Inode-owned
+ * metadata, including the private-range summary, remains valid until then.
  */
 struct guest_memfd_device {
 	struct kvm *kvm;
 	u64 size;
 	u64 flags;
 	struct guest_memfd_device_binding binding;
+	bool (*has_private)(struct guest_memfd_device *gmem);
 };
 
 /**
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index af1e4798ace1..1322576350b8 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -85,6 +85,7 @@ static bool gmem_provider_is_device(struct gmem_inode *gi)
 
 static void kvm_gmem_device_update_attributes(struct inode *inode);
 static int kvm_gmem_device_make_private(struct inode *inode, pgoff_t start, pgoff_t end);
+static bool gmem_device_has_private(struct guest_memfd_device *gdev);
 
 struct guest_memfd_device *kvm_gmem_get_device(struct inode *inode)
 {
@@ -176,6 +177,7 @@ static int kvm_gmem_attach_resource(struct kvm *kvm, struct file *file,
 			gi->device.kvm = kvm;
 			gi->device.size = i_size_read(inode);
 			gi->device.flags = gi->flags;
+			gi->device.has_private = gmem_device_has_private;
 		}
 		provider = ops->attach(inode, resource_file);
 	}
@@ -1510,6 +1512,14 @@ int __weak kvm_arch_gmem_device_map(struct kvm *kvm,
 	return -EOPNOTSUPP;
 }
 
+/* The attribute tree owns mapping state; this summary is read under provider locks. */
+static bool gmem_device_has_private(struct guest_memfd_device *gdev)
+{
+	struct gmem_inode *gi = container_of(gdev, struct gmem_inode, device);
+
+	return READ_ONCE(gi->device_has_private);
+}
+
 static void kvm_gmem_device_update_attributes(struct inode *inode)
 {
 	struct gmem_inode *gi = GMEM_I(inode);
-- 
2.43.0


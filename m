Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794469349;
	b=DbIyVEvH0TwXXJQqyj0grxb+QRbvS2O/MwK9p4XQd5At9/GsMAYhmGSQR7c+h42wUeny
	 7EV2PLu3iG3r/DcJIpPCR/jsB/MymF5JL6kI90jmpfHNyWVM7PQ6w8794By8ASu8MLLBo
	 zBXJc0fQBMniF4YuRiYD/Gq0mFG+K8hivRTRa1p7pRbqZUUdC/WgT94pNs70eI/vbELgN
	 Q4VJe9jHqn7+owRhTLERcFCFwylUPvZuSuP+ZNNkQxjZPRE3ihGHtm2x05GWl4OS9z21P
	 jQzmQUFCzSXXAadaHq/VmxtISk1yy3ZiYEUMKpRxI9jNmOTBwa3kwLBssgG8upQKHYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794469349;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=MZgf085JstJXuimawUrtWcrm+ZiPNmAehafJK7eNR/s=;
	b=rniAxWoZiAq+P/rIdcFQfeHpWa6Tn4pu83VWP6URKdY2WB2E7eUsqNawoJgLqOwvT0By
	 i7EgvL11ArB1/07b8sZqONxKkviTmAyWvkDC9QnSsnXZHesOjkAKDHzv87EW1RRcNP4Fg
	 JAkjt7auMFhvtXA8c062sDvWLQ6mF6bEPVj8KotZDyHhXkPGiMh4N99fCIZnBkmUPyh+M
	 cEiLbk/OZN8xDIoY0CQS/bRIjG9tqmhdKC93jjdR6JnBPAAUZj8hinUt3S0EchicLJMb4
	 oefxy5v3dhrPUp8ZoE9x7FMvAmd4uiNjZg0e4WP/c4+kTU3IQn6PvdubOiHfnJyxBdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nwi1GVYw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F875606A327;
	Thu, 12 Nov 2026 07:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nwi1GVYw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DFA11F00A05;
	Thu, 12 Nov 2026 07:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794469349;
	bh=MZgf085JstJXuimawUrtWcrm+ZiPNmAehafJK7eNR/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nwi1GVYwV1kiU8cGn+GY1lQClz26qMesckZMcJpNRfBwLrj9Zb59iAur4jKJKQtHo
	 9Sl737WJO8FNUVcC3HraZEJ5iggjbwIqMsvugG5V/O7eRqOR7WMWdyrR3Va32E9F2i
	 6OJY4Y1IOUVhEjugQyIVpNwN7hrwUdkF/GmU1cETf73Vrsx8J5B52NNfWFf1ObXH9X
	 1S4iYI4l+7eaSSA5mHENApg6Xz5AtpQZr8lJ5xL4BOiTkMeHt0V6Ab2LiS2xgqrG+Q
	 BzFC7PkzkoIcMEZtDdrsYXPEVPwt4wFeJGxSFVbZlcqjnOgredyt2JrQk49q+COfJp
	 nsh+18I/LcRmw==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Ackerley Tng <ackerleytng@google.com>,
	David Woodhouse <dwmw2@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Kevin Tian <kevin.tian@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
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
Subject: [RFC PATCH v5 11/16] KVM: guest_memfd: Pass KVM explicitly to provider attach
Date: Thu, 12 Nov 2026 13:11:15 +0530
Message-ID: <20261112074120.1570072-12-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261112074120.1570072-1-aneesh.kumar@kernel.org>
References: <20261112074120.1570072-1-aneesh.kumar@kernel.org>
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

Pass the attaching VM to the resource-provider attach callbacks. The
argument is valid during attachment and must not be retained. This
avoids storing the VM in the device binding context introduced next.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 include/linux/guest_memfd.h       | 3 ++-
 mm/shmem.c                        | 2 +-
 samples/kvm/mem_provider_sample.c | 2 +-
 virt/kvm/guest_memfd.c            | 9 +++++----
 4 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/include/linux/guest_memfd.h b/include/linux/guest_memfd.h
index 79e2983c3b26..012174ad8ef8 100644
--- a/include/linux/guest_memfd.h
+++ b/include/linux/guest_memfd.h
@@ -12,6 +12,7 @@ struct file;
 struct folio;
 struct inode;
 struct mempolicy;
+struct kvm;
 
 /**
  * struct guest_memfd_handle - PFN information and an optional folio reference
@@ -110,7 +111,7 @@ struct guest_memfd_handle {
  * Used by filesystems and device drivers that provide memory for guest_memfd.
  */
 struct guest_memfd_provider_operations {
-	void *(*attach)(struct inode *gmem_inode, struct file *resource_file);
+	void *(*attach)(struct inode *gmem_inode, struct file *resource_file, struct kvm *kvm);
 	void (*release)(void *provider);
 	int (*prepare_memory_region)(void *provider, u64 offset, u64 size,
 				     u32 flags);
diff --git a/mm/shmem.c b/mm/shmem.c
index a1c1cc92515b..f652a6c1009f 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -5462,7 +5462,7 @@ static const struct inode_operations shmem_special_inode_operations = {
 
 #ifdef CONFIG_KVM_GUEST_MEMFD
 static void *shmem_gmem_attach(struct inode *gmem_inode,
-			       struct file *resource_file)
+		struct file *resource_file, struct kvm *kvm)
 {
 	struct inode *inode = file_inode(resource_file);
 	struct shmem_sb_info *sbinfo;
diff --git a/samples/kvm/mem_provider_sample.c b/samples/kvm/mem_provider_sample.c
index 4b7a8f760fdf..2eb9748cec5b 100644
--- a/samples/kvm/mem_provider_sample.c
+++ b/samples/kvm/mem_provider_sample.c
@@ -152,7 +152,7 @@ static long mps_file_ioctl(struct file *file, unsigned int cmd,
 }
 
 static void *mps_gmem_attach(struct inode *gmem_inode,
-			     struct file *resource_file)
+		struct file *resource_file, struct kvm *kvm)
 {
 	struct mps_info *info = resource_file->private_data;
 
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index ffecc4b19a17..178ac5ad123f 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -86,7 +86,7 @@ static bool kvm_gmem_is_pfn_mode(struct gmem_inode *gi)
 }
 
 static void *gmem_native_attach(struct inode *gmem_inode,
-				struct file *resource_file)
+		struct file *resource_file, struct kvm *kvm)
 {
 	return GMEM_I(gmem_inode);
 }
@@ -193,7 +193,8 @@ static void gmem_provider_init_ops(struct gmem_inode *gi,
 
 #define GMEM_RESOURCE_FD_NATIVE (-1)
 
-static int kvm_gmem_attach_resource(struct inode *inode, int resource_fd)
+static int kvm_gmem_attach_resource(struct kvm *kvm,
+		struct inode *inode, int resource_fd)
 {
 	struct gmem_inode *gi = GMEM_I(inode);
 	const struct guest_memfd_provider_operations *ops = NULL;
@@ -212,7 +213,7 @@ static int kvm_gmem_attach_resource(struct inode *inode, int resource_fd)
 	}
 
 	if (gmem_provider_ops_valid(gi, ops))
-		provider = ops->attach(inode, resource_file);
+		provider = ops->attach(inode, resource_file, kvm);
 
 	if (resource_file)
 		fput(resource_file);
@@ -1619,7 +1620,7 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags, int resour
 	 */
 	smp_wmb();
 
-	err = kvm_gmem_attach_resource(inode, resource_fd);
+	err = kvm_gmem_attach_resource(kvm, inode, resource_fd);
 	if (err) {
 		fput(file);
 		put_unused_fd(fd);
-- 
2.43.0


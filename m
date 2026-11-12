Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794469371;
	b=FJ0Dd3wMVGS1jBKNYJMvAYdAOPNKoXLN9WssKsH1gjDNkzH/9Bs7VIpWN7fs4j4Ipco8
	 HkO8lE/ANlmz0WGpH00DDiM4HZWmpJDsQbkWW9vFF+5FijP9RpyflKHyLMk4hvxluanCo
	 NayANLbfp8jgBW+QuzEazJlii6Awm3KRQX1MaUNTkijemSqM/12zeHE9Bl8Zh1oPip0OP
	 noYKKjH+qakguRFQP5f3xTHGpOAJ0Q9YbT+ZyDMJT3r7g7/3JBo9FQHatppuFleHWRGra
	 kzhypDHFxQAkMCGITJAbS8n4hWdO7AZZEQv5pLw2ETqod8HAtUosvGzOHGKtGce6qbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794469371;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=2hEc7j+3dZpIM0BbkPz5XVJm5OcV8IeH+pucDwQ3oZ8=;
	b=FGBngIKAnePi+xSGy0GaodYIKAtviISAqgViZugAhMs7o+1VWSn2ZZ6ishY5IsnA9dzM
	 XjQKxi95zxu6g70/y48g5bvg2g7/wBKvs7G0Ii8ntdEX+HJraHL80gCvBz2gw+hue5xo3
	 G5xc2lnOMW4eAInruFe0hYouyBBYXw4tLmqDW93xy2wp3nG0ZEHtmRuExUk2S/bDnCRxN
	 PdJ766+qePxPw3U9g5+JitAvS0/I5Il9gCg3RUAjQq3nZUGZ6tzqGJ4Bu/hIf3YJMHL46
	 hOH3b9T1RI6Cq16n/DbNyJ2QBzsopBbFFBaDfSFdx5o9NBfsSKrhkHEHDMxtb7pVoAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="b5nR/ny4";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B948606A327;
	Thu, 12 Nov 2026 07:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b5nR/ny4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F30691F00A0A;
	Thu, 12 Nov 2026 07:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794469370;
	bh=2hEc7j+3dZpIM0BbkPz5XVJm5OcV8IeH+pucDwQ3oZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b5nR/ny4Lki6mzS7aWcCt7kalchRCzheJFmBGHUcwG0WVyAUqpbKam3p+PnplAKrF
	 dg+kysTvAY7LBTqTvjCZBOZfzKlC22V1tFJ30caOczRSYn/Yl5dM0nWA8AwKwSP2fX
	 nG3LgqQLx2PoY3Vcu8xHV9lIu8x+d69WCzbiM69VjKQ9V2+epiKf3L/36eBL8FS8F8
	 GcVnmdsZkkQcN/o5qhEWrtPG2s/G8k5vZbKlzK8sJsMI7ikegljKj9fS1zCLZPhd7N
	 2z8la2hsjaQaFcz50vxiXzR1szQ0SvWZFPuEge/Owsorpu/lv2bdO79LW3mpS8H87A
	 tl8f4qZNb1pmw==
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
Subject: [RFC PATCH v5 15/16] KVM: guest_memfd: Notify providers during file release
Date: Thu, 12 Nov 2026 13:11:19 +0530
Message-ID: <20261112074120.1570072-16-aneesh.kumar@kernel.org>
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

When releasing the last file associated with an inode, invalidate its
mappings and notify the provider that no private ranges remain. Hold the
provider lock across both operations so device unlock waits for cleanup.
Skip notification if provider attachment failed.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 virt/kvm/guest_memfd.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index d3ae01aa6fe6..bdee42ff6b26 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -87,7 +87,6 @@ static bool gmem_provider_is_device(struct gmem_inode *gi)
 	return gi->provider_ops && gi->provider_ops->device_memory;
 }
 
-
 static bool kvm_gmem_is_pfn_mode(struct gmem_inode *gi)
 {
 	return gi->flags & GUEST_MEMFD_FLAG_PFN_MODE;
@@ -904,12 +903,28 @@ static long kvm_gmem_fallocate(struct file *file, int mode, loff_t offset,
 	return ret;
 }
 
+/* No file users remain, so private attributes cannot create new mappings. */
+static void gmem_provider_release_views(struct inode *inode)
+{
+	struct gmem_inode *gi = GMEM_I(inode);
+
+	/* File release also runs after a failed provider attachment. */
+	if (!gi->provider_ops)
+		return;
+
+	if (gi->provider_ops->update_private_ranges &&
+	    list_is_singular(&gi->gmem_file_list))
+		gi->provider_ops->update_private_ranges(gi->provider, false);
+}
+
 static int kvm_gmem_release(struct inode *inode, struct file *file)
 {
 	struct gmem_file *f = file->private_data;
+	struct gmem_inode *gi = GMEM_I(inode);
 	struct kvm_memory_slot *slot;
 	struct kvm *kvm = f->kvm;
 	unsigned long index;
+	enum kvm_gfn_range_filter filter = kvm_gmem_get_all_gfns_filter(inode);
 
 	/*
 	 * Prevent concurrent attempts to *unbind* a memslot.  This is the last
@@ -922,6 +937,8 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
 
 	filemap_invalidate_lock(inode->i_mapping);
 
+	gmem_provider_lock_updates(gi);
+
 	/*
 	 * Note!  synchronize_srcu() is _not_ needed after nullifying memslot
 	 * bindings as slot->gmem.file cannot be set back to a non-null value
@@ -975,9 +992,10 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
 	 * Zap all SPTEs pointed at by this file.  Do not free the backing
 	 * memory, as its lifetime is associated with the inode, not the file.
 	 */
-	__kvm_gmem_invalidate_start(f, 0, -1ul,
-				    kvm_gmem_get_all_gfns_filter(inode));
+	__kvm_gmem_invalidate_start(f, 0, -1ul, filter);
 	__kvm_gmem_invalidate_end(f, 0, -1ul);
+	gmem_provider_release_views(inode);
+	gmem_provider_unlock_updates(gi);
 
 	list_del(&f->entry);
 
-- 
2.43.0


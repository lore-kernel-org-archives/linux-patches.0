Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794469360;
	b=zGaFleIT5RsE1a7wMIPdyNHqlPjjajOHrKWdCBDpILMqIQWyUu+0ZYFNGy2iDKROqM46
	 OH/472tgugZhismlNsqdGD6Ch6asNPRJcz4hPyjiBpYaCwprx8bw2qFlL25g1f7up67V3
	 syWDA9CxrgRGirTflWy8Tj3crZfJENbPMgEjvLC5C6GFHxkDEgb2IcbWX+bVMitaAcgCM
	 EVf9RX698lrXgA3saGhtXpU2UFiDgyqUoZCMqypBWB4SOjvAPaGgnNfk/6hIk9JNGJjhO
	 51ZlDHgGyTECPMgwGP3hwESGTp9VUKHKPvUQLP9JciUE1AbUbbhFjJBsRg46vDo5drA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794469360;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=h5mxLIA6wuIhRhqnfx47bs5pEX58scKu+h1It6PDayY=;
	b=Fvm+9llU1qngzQR2IwvF8JA2vp0E2nXnjYocWV29+9IQ5C4QPhNWZyNGjYiSeFO/iTKA
	 vs8x1cO66Q+zkIv3QBQEHBwbGOKxmPtnVHmGK0E9UJTXQE5QCZkyYR8DVW0lEHAl1rlHc
	 FNPC4vDWOrLl9ViEG1YGOf+gMjZuDcDveRVMe/SqlGNgY6AdbogQiiDE9VDP/ETIv46K8
	 yk4jGgFbVq3luhLFdqfH8khBvU4qKh6Uh5gNqF/tW6tytKcDM4e2Tpqbp+fXw/uSiteXy
	 dd+y3RcWv9SWmtnP2CHKEzFnoSN+D/TwpYuhx8KbRd/mO2d89QNss6VYxVDBs/wD6Ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KsqVyCM0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA32606A32D;
	Thu, 12 Nov 2026 07:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KsqVyCM0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3392D1F00A14;
	Thu, 12 Nov 2026 07:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794469360;
	bh=h5mxLIA6wuIhRhqnfx47bs5pEX58scKu+h1It6PDayY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KsqVyCM0Sye0xfiLpDrLjZ17AXFBVnKP//KB3zMT+IV1Z3MQxzflOF2FSycxXS1zK
	 ebIggIUuWQyhHMOwM5Bf/R+/Q6SGgyyB47w6/Wexjt5CZRdxxSaORrurLmKRHHyzJ0
	 LNMPnswUk9PyHlFtUJ8G9znhQZQBM4NGePmblSnNb3HquwYprpj4zq3sjILCsoPFol
	 10MW7Lj6jaOA9c7V2A/sC2UTU3/TTLRajUtO5PGYMGvSkmhqp9rAqaad5mRbKzZpy3
	 XmVAkXeXisrB8MpFVAZ9jrb0O+nOvDNmN5NAj72HpN9vm6CaG1dMP0lL933umcW3B3
	 Mv4/Ij0NehrUA==
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
Subject: [RFC PATCH v5 13/16] KVM: guest_memfd: Notify providers after private attribute updates
Date: Thu, 12 Nov 2026 13:11:17 +0530
Message-ID: <20261112074120.1570072-14-aneesh.kumar@kernel.org>
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

Publish whether committed private ranges remain through an optional
update_private_ranges() provider operation. Scan the attribute tree
after successful publication while holding the inode invalidate lock and
any provider lock.

Keep the cached summary in the provider that uses it. Providers
initialize their summary during attach() before exposing access checks.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 include/linux/guest_memfd.h |  5 +++++
 virt/kvm/guest_memfd.c      | 25 ++++++++++++++++++++++++-
 2 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/include/linux/guest_memfd.h b/include/linux/guest_memfd.h
index ebfb3199a302..31cd5142e5f1 100644
--- a/include/linux/guest_memfd.h
+++ b/include/linux/guest_memfd.h
@@ -76,6 +76,10 @@ struct guest_memfd_handle {
  * @unlock: Release the provider lock taken by lock(). Called after guest
  *          invalidation ends and any successful attribute publication, with
  *          the inode invalidate lock still held.
+ * @update_private_ranges: Optional notification of whether committed private
+ *                         ranges remain. Called after attribute publication,
+ *                         and with false after final file cleanup, under the
+ *                         inode invalidate lock and any provider lock.
  * @prepare_attributes: Optional memory validation before conversion, under
  *                      the inode invalidate lock for write, before taking
  *                      the provider lock or starting guest invalidation. Host mappings have
@@ -144,6 +148,7 @@ struct guest_memfd_provider_operations {
 				     u32 flags);
 	void (*lock)(void *provider);
 	void (*unlock)(void *provider);
+	void (*update_private_ranges)(void *provider, bool has_private_ranges);
 	int (*prepare_attributes)(struct inode *inode, void *provider, pgoff_t start,
 			size_t nr_pages, u64 memory_attrs, pgoff_t *err_index);
 	int (*allocate_range)(struct inode *inode, void *provider,
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index a9609ddccafd..1c90f59f480e 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -1317,6 +1317,27 @@ static int gmem_provider_make_shared(struct inode *inode, pgoff_t start,
 	return 0;
 }
 
+static void gmem_provider_update_attributes(struct inode *inode)
+{
+	struct gmem_inode *gi = GMEM_I(inode);
+	void *entry;
+	bool private = false;
+
+	MA_STATE(mas, &gi->attributes, 0, 0);
+
+	if (!gi->provider_ops->update_private_ranges)
+		return;
+
+	mas_for_each(&mas, entry, ULONG_MAX) {
+		if (kvm_gmem_get_attributes(&gi->vfs_inode, entry) &
+		    KVM_MEMORY_ATTRIBUTE_PRIVATE) {
+			private = true;
+			break;
+		}
+	}
+	gi->provider_ops->update_private_ranges(gi->provider, private);
+}
+
 static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
 		size_t nr_pages, u64 attrs, pgoff_t *err_index)
 {
@@ -1369,8 +1390,10 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
 	if (!to_private)
 		r = gmem_provider_make_shared(inode, start, end);
 
-	if (!r)
+	if (!r) {
 		mas_store_prealloc(&mas, xa_mk_value(attrs));
+		gmem_provider_update_attributes(inode);
+	}
 
 	if (r)
 		mas_destroy(&mas);
-- 
2.43.0


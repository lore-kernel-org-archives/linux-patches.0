Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794820373;
	b=ICAOCvsC92dTTEDw90x9CqZAvMVAYJxWKkXOXaLzb5gcuU/lttIxvnoBaoRlZ2KraZlM
	 AaCzJchOMnBxtldlqOZAZwo1Cll+KWWDHNGbc70pWZViwb04DmC5gOEO//uSw8/Twnug5
	 uggs3ds94PcMV0sUFeBnT9xPG57K0vJzHUHT1ULcde+0oH9r64j6nPKq3JIsc1YZPMq1L
	 8rdT+5HHQZBTg2mlpKzQprwoQKpooovF4rxkTF3s3B7h9jHW85Y1J68xfSTCpC1EhrI/X
	 uGek6snk+twKgyJQQ5tUjrE77Kh0mprvdPcd4THxD5oJx9WiEYD2s5kF3HbXdKupSMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794820373;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=l9LcwR3Z/eNN8ZlPPbJDNHds/9Tisn7NID8zuHRV4hs=;
	b=uPjpkDu/VtFp19kVKuFFdFjb0MymY4L724ftrIcz9aRrFp6L3peNhvmCpWzI65a1lRcW
	 OQjtlW6Z6srZb+Fjs/iGkVvYQwW6RNF8xtHZji+xzcYfP0aIjW/VXBAFB6+F6YtoUu3GR
	 zTK00zqyGhiqYrfKN8vh5CbZA7YsPpFQfjei7jGBNKcTeCS1AVagl0BPo9Zhdxwac6oEf
	 I5o+9og/WuPDEt6BGs46rjGneAqsETNYIwwsibFVonuyviOKVW1/WLtViW5QFFoHK9K0s
	 osZbSSx+bQjzXOHJ6Lp7TbNELC+JcYKblEIPDkOz6qqm/1DTVtbcADXYC2X7zBCS1IQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PJ+QNQ5G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 928E2606A32A;
	Mon, 16 Nov 2026 09:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PJ+QNQ5G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4F3D1F000C6;
	Mon, 16 Nov 2026 09:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794820373;
	bh=l9LcwR3Z/eNN8ZlPPbJDNHds/9Tisn7NID8zuHRV4hs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PJ+QNQ5G2P1gSIBkhfmpc1W7iorPgwxExm4Dc2nzbkdybUShh02bugWbL1rVqzYtJ
	 oVx74CTFnI2YB12OP1B81F1ewU+tKyxAeDAKg4ZaeKs4D0WhduhsEuoLqfrXd5ls/v
	 aZ8XddYxe/HDF8Q30NG7tGR8IJWjB6j0UKsaqIWpBLP02VB4OQXhWXoLQWxBZvIKJx
	 EjhJyakAS3o+XkwFOR+F0yR/MzaQwCN3rgA70NgFKZ49QW6yZqm698t/LjuruNtzLD
	 6hyEto4bvHfZQMUv0vOOHKQY2JMwSYNrhDFDnJxFbgxmSrVs7XKzQiFI4N2bRW0Xs2
	 6Z6HttzdehPKg==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Joerg Roedel <joro@8bytes.org>,
	Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Will Deacon <will@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Radu Rendec <radu@rendec.net>,
	"T.J. Mercier" <tjmercier@google.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	dri-devel@lists.freedesktop.org,
	iommu@lists.linux.dev,
	linaro-mm-sig@lists.linaro.org,
	linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org,
	linux-mm@kvack.org,
	kvmarm@lists.linux.dev,
	patches@lists.linux.dev
Subject: [PATCH v10 03/13] irqchip/gic-v3-its: Resolve the default NUMA node explicitly
Date: Mon, 16 Nov 2026 14:41:26 +0530
Message-ID: <20261116091137.94252-4-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261116091137.94252-1-aneesh.kumar@kernel.org>
References: <20261116091137.94252-1-aneesh.kumar@kernel.org>
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

alloc_pages_node() resolves NUMA_NO_NODE to numa_mem_id() internally. In
preparation for switching ITS allocations to the CoCo shared memory
allocator, resolve the default node explicitly in
its_alloc_pages_node().

The CoCo shared memory allocator interprets NUMA_NO_NODE as a request to
apply the current task's memory policy. Resolving it to numa_mem_id() in
the common ITS allocation helper preserves the existing
nearest-memory-node placement for all callers

This patch does not change the current allocation behavior.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Radu Rendec <radu@rendec.net>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index c952c069f937..ada5c30af41e 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -32,6 +32,7 @@
 #include <linux/set_memory.h>
 #include <linux/slab.h>
 #include <linux/syscore_ops.h>
+#include <linux/topology.h>
 
 #include <linux/irqchip.h>
 #include <linux/irqchip/arm-gic-v3.h>
@@ -218,6 +219,9 @@ static struct page *its_alloc_pages_node(int node, gfp_t gfp,
 	struct page *page;
 	int ret = 0;
 
+	if (node == NUMA_NO_NODE)
+		node = numa_mem_id();
+
 	page = alloc_pages_node(node, gfp | gfp_flags_quirk, order);
 
 	if (!page)
-- 
2.43.0


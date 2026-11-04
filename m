Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793810864;
	b=SkpsY3wFj8mmc70PTksHyse6tBUnK7SCIugybHqGUZmynZnGPZ/66noBH961ejr1AbEf
	 5Gc5mf7xfaLO+v/n1i3z9++9uT5jG5O/MDbxE3Dp3wOb7HFc5/zy3pPnk/+Ds204gCqPJ
	 rOls531qyz6mmF4oLFxdlOor+hP3T7sBNOg4zWhGRqTZrr9sU2BhE4+kwCtPs359Clg+u
	 /dNxqgXqykBc0jwTO6ajBIjjqmm1xekjodYNI1q9G2xR8QQhKFfpNcBbiXx8rjBQZCUg7
	 LF9qxYYNPa6qYroPUNmx1uMK9nXIg35n8TPM6HceNoIZ0FFHvnNwVIPm02qisUfjvIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793810864;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=U3vZfY93R3yPndxcyRJU8aru1CXbMAARSgBFj8w2VEI=;
	b=3ixgZ16a409zN/Vt2LFh+PPQPxPVvs1W8KflFC5I0vwmDbxY2l2060iClUhyoVbQZOMo
	 DzyKoYHrgQZMbGLOjm5Bt1031xIXV83tGEF5turwQYn7v9DW6c/hGvQGtk+In5Jk25Wr+
	 pAqvAxHZwu2IccpBScXapwHTSHahtsBDwZ97L9xuL+CoqBiELs/VcPuFO+kTjhKf5nCYs
	 8POCCJ6jf3/Q6moo/tWgLDcBrO4kfyaY8AMQSWQ/YIGgJFfP7CuPx7Aw9+o9O+D3+A0xd
	 xjTzRSwtgAXtQaexoI39GLDXhq9kvaBbBOksp8AobCLF9FakHZiO54TJ2EwEZsxuldA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eDfSsIwQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C367606D817;
	Wed,  4 Nov 2026 16:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eDfSsIwQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 485C21F00A28;
	Wed,  4 Nov 2026 16:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793810864;
	bh=U3vZfY93R3yPndxcyRJU8aru1CXbMAARSgBFj8w2VEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eDfSsIwQllbKNfu8DPUj0PjDLs36B68oX/2t0DEiKyJs1Bycq2PKml8/U4hJ4NUlF
	 iLV8+8DmuMLTQznHOB/PPCcN+/QQlvUpKiQ/fXmx/tx2UucZW9FO35qnXbj81cM/NZ
	 7uZsSWTjob4DS8Qk3nF6e5W0Cepz/C9QgyyhZf2F0U+uN1HM6vFzt3h0OgInewUns7
	 PvdS/75ok+ufon4EaZTEPefxtkX5BsXadUc2P8xOX+Shqe7MRuVCgIqYBh+srNQlSy
	 f0ggImRAke8XNmPBESs0qf0Zc3Z5Q0olSJefC8k1GGQf07z6qsqaRO8meG0q8xLzOD
	 zJRkRrQv7oatw==
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
Subject: [PATCH v9 03/14] irqchip/gic-v3-its: Resolve the default NUMA node explicitly
Date: Wed,  4 Nov 2026 22:15:44 +0530
Message-ID: <20261104164555.3555725-4-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261104164555.3555725-1-aneesh.kumar@kernel.org>
References: <20261104164555.3555725-1-aneesh.kumar@kernel.org>
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
index 282e4bafb084..a8860aaadf90 100644
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


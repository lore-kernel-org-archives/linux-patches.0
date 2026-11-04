Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793811029;
	b=N+VrRVMCJAJ+j3UQnScTeqjeKsUbfOMLeG7L3Pzr6INwcuQmpNTfA01FxzFJUHgUlAeQ
	 f/P7giypLY64TBvoqXlgNvHX0Dy+Nx62TXAqMbFSsYyb3h+MUKk2OSlMt/dcgqfxQ7uqE
	 0T/Iwpsum/DdtjZBaUk+vA5mgbPlvBc4SfaL4LzDxaUsHrE52JkoYnSvIcH22U3eASbdb
	 xzeHTIfOfPFB+h+yNVKVQnDXlRLzkDcviiHOUBgHISOCmgBbanXKUiX5CkKOUv4qWSEbe
	 5XCDX/xmSGrSY7FO9IJ9v4i1osKqhlIhBxjloQr4iHB8NuRErW5Vq1JKKT2a5Er54vQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793811029;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=WRcEmA8t5SF2n7O8yFpnu4RLNkBYJrrcArfzz4S7jNs=;
	b=bhFPOyUl8hjRgrmuVdYYu1Nppl3xaMsJac4SptD28mIrtHea2qQewfR30/ncpFDrGNVF
	 AtFD8ZiIgQORUAeKTLW0+ND6g9M4vrhI6VHo2pcykNr4tro5zAK+sBtV8hlvbuBJB4iF9
	 +GwnRV0GwbshdTTO8j8vensjyWkE+6SVLz6n0P2XZlJoel3XBD5i+TTJE6ZpX23uCO7G2
	 QxocTT7dXp9FUu0xSJrmhQj5BUFsmk8gS7bGIsAJZ3eErQxeVbaK+F7lUTECe0tEGIdO4
	 41LSQQGrGfZ/HO3kXMD5EHNKCDPerxJAhN9INU+7ok6kqpX280iqkiFScYEYs7zDn7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PNHISvmm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 333C5608361B;
	Wed,  4 Nov 2026 16:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PNHISvmm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBD141F000C1;
	Wed,  4 Nov 2026 16:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793811028;
	bh=WRcEmA8t5SF2n7O8yFpnu4RLNkBYJrrcArfzz4S7jNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PNHISvmmuWjnQ+7HEMPvfWz7APstuBwKvr1lPLt9SDxVD52Vkc79+yVtOnwJmbyNC
	 kF3VIBOQN8Tv/NCYUFGkB1Ewlk8dNuqsqTFNCvdi/M8s0mqa4qJbvFMf2QdSogLylC
	 ThlzcIiqi5pt78dU2OO7HwbdrO2irxa0n2otgDaR2QqXqHJrXJxDl9msL9PSIy7Qwa
	 Sf08ADUUdKytxN4QMa4AMfeT3c7TchiL7bLh4pChwjEKQv3xIwVie+GbtUsWpCCdU1
	 DoA0s2U7su4v/sRB0t2KrIZ4x0ji+QvFqAQqB4xvWBnTdKepiQyTfwIEP0Ghi9AV1G
	 hBXp3vzGdOQIA==
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
Subject: [PATCH v9 13/14] mm: Assert CoCo shared allocations may sleep
Date: Wed,  4 Nov 2026 22:15:54 +0530
Message-ID: <20261104164555.3555725-14-aneesh.kumar@kernel.org>
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

On platforms with memory encryption, alloc_cc_shared_pages_node()
transitions the allocated memory to the shared state.
set_memory_decrypted() may sleep, so the transition must run from a
sleepable context.

Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 mm/cc_shared.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/cc_shared.c b/mm/cc_shared.c
index 40c130cce74b..e70c26df2d06 100644
--- a/mm/cc_shared.c
+++ b/mm/cc_shared.c
@@ -8,6 +8,7 @@
 #include <linux/errno.h>
 #include <linux/export.h>
 #include <linux/gfp.h>
+#include <linux/kernel.h>
 #include <linux/log2.h>
 #include <linux/mm.h>
 #include <linux/mem_encrypt.h>
@@ -106,6 +107,8 @@ static int __alloc_cc_shared_pages_node(int nid, gfp_t gfp,
 	unsigned int order;
 	int ret;
 
+	might_sleep();
+
 	ret = cc_shared_calc_layout(requested, &layout);
 	if (ret)
 		return ret;
-- 
2.43.0


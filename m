Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794820553;
	b=m1bZH0UUq28ECxAmgtmCZbhTcdqkZMK+O+InQVidXH67O4vksf9ajeFVYGZk4oEmSecP
	 WPOOjduynQj0Tmd1Roxv9WQzOZu+/lITac0bwttdVbpHS69g3SvuRIp0GeEaw/zH6uDCy
	 Ut0yvdBsEcucp7GazdK+yLGWNM2tMWnn5iSdK8yjn6rHDY6Ndxw1mk7P9A0Rh5FlZ+e54
	 b6/7vEdjRAF7Hk9EJXssckM4A/B1LxMq+6kOFD6iqYz6zMPGt1hQPNxzoysaNKqk1J/8H
	 2S9S81fwdmB0Xknz85GG1Lt59bwkISHZlkrFMQkUaWKIoNYKTgUNtpZIr6+a2QBxOMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794820553;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=vl/C5jn+1tPTrCTsFhPelusdvJCp3xW8fwCUnP8k0/4=;
	b=X2wPRakWaqyi5WtzKPe3RM2diQp/7aa56n3JGGmdx8WzNIWnihrUEvRfTgkaTURhSd2+
	 wWFKaG7+9AKku+fjBlE52+RUDa7nUjwAt8zK8wC027/fWd8VhVFtmmzZj/xigghCxd4oP
	 cUsNM968c7jVGM6sSxPwIhnAJSMA1MJ9D/m5dhf7AUuoC/0XUCFp22suTQoqxQPnA3lU6
	 NzsBL66uU397nyRn5TdNMSqd69hISw1AtVw2WGwDWZcP64gQVNJTlGfy5XGefCkjykdaw
	 CF1gwtTJB/dMBkSXsj7eX4Nh9XFpE3Bv/ZNjaku8xyOLUfGgmhSXGwwePxa5cALQuQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cHKJSbPk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98453606A323;
	Mon, 16 Nov 2026 09:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cHKJSbPk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23C371F000C4;
	Mon, 16 Nov 2026 09:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794820553;
	bh=vl/C5jn+1tPTrCTsFhPelusdvJCp3xW8fwCUnP8k0/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cHKJSbPkOmS/vgJzoXZ32XAOeuVSd+4AR7wQLkrcipLJYDsoZKVmhqWehLYzXMbaw
	 R3B/AWlh1S33BLxY0EBupbn4erb2GjPok1Jk/A55GVWK5wNLgVoyr2G0xYzkPsQqrS
	 gEcKCWeL+Dx8daRQR7LlmEGmvbevX+pW1mWsLtDL+aO8GHfANkZfhz3lX/pcDnwZbc
	 UHkMOWPm7+qImQLYnPoIXD7VjI+BnQheFEUtLhUtYGPZ9yo3CCvw5jJbAJwFim9sxs
	 Sn+0K23n/zloQoNpUknUCmfvqa20zhvkh18bHTM68vSbFX62rWnlkpstGAqA6zLKhe
	 SJxi6oLHRkgQw==
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
Subject: [PATCH v10 13/13] mm: Assert CoCo shared allocations may sleep
Date: Mon, 16 Nov 2026 14:41:36 +0530
Message-ID: <20261116091137.94252-14-aneesh.kumar@kernel.org>
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
index c9b4e3dfe06a..b30b8e78da32 100644
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


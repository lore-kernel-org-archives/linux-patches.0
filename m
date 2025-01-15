Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5738248BAF;
	Wed, 15 Jan 2025 11:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938880; cv=none; b=oiL+qaqYx2VFMybN7+N/Dnqf/l4maVXV9B48azvQNWt13ow++JGrzpeau23ZheIaw4lUdUxDNemCZ9FU7N2dNRKKetlIBnz2G0frp/NwbfVawdp42ouI7U8VV/yLNRRJoxd9bcU5BNLgYWLh7YWBw9v+kOsuUKYRfmFn5OCcdwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938880; c=relaxed/simple;
	bh=QJ/NhoJsx+CtvPbG6rK5HVzOy3TnZPoi/EI/38d45X4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lJJtrzBnxyqDGqDARNBSzZv5DYUvuncsK1ikuqkNdy6IQk+NraRBaMLlROs35hWrD/N7AmYDhaq9Z8x+4F7opIIfKjOOI26qdvTWyt3t4bNKcWYaH/u8hfipWstC5LES5XQ/Lb7IrCPzgMYDCtVQ6xWsG3KTlopq2jsi79YtGE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zENuh3Ce; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zENuh3Ce"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2E24C4CEDF;
	Wed, 15 Jan 2025 11:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938880;
	bh=QJ/NhoJsx+CtvPbG6rK5HVzOy3TnZPoi/EI/38d45X4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zENuh3CeKvgDAFjGHTA8Gk8R1JCztT7xOViaKcqd+WZwYaZwy0R1p0QZBXMD4ROaz
	 IaLiLHra3aM+QgKDt5dCbr2ZQkskQhpZ3hUlSoWS4OeYnC4fVQWp6a17f58Eknzvke
	 zOAuLRCecYdtZ8qurZ/1LIuS81ZoW+D5Pw8Td0pA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Xu <peterx@redhat.com>,
	Muchun Song <songmuchun@bytedance.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 125/129] fs/Kconfig: make hugetlbfs a menuconfig
Date: Wed, 15 Jan 2025 11:38:20 +0100
Message-ID: <20250115103559.336327000@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Xu <peterx@redhat.com>

[ Upstream commit cddba0af0b7919e93134469f6fdf29a7d362768a ]

Hugetlb vmemmap default option (HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON)
is a sub-option to hugetlbfs, but it shows in the same level as hugetlbfs
itself, under "Pesudo filesystems".

Make the vmemmap option a sub-option to hugetlbfs, by changing hugetlbfs
into a menuconfig.  When moving it, fix a typo 'v' spot by Randy.

Link: https://lkml.kernel.org/r/20231124151902.1075697-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 59d9094df3d7 ("mm: hugetlb: independent PMD page table shared count")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/Kconfig | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index aa7e03cc1941..0ad3c7c7e984 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -253,7 +253,7 @@ config TMPFS_QUOTA
 config ARCH_SUPPORTS_HUGETLBFS
 	def_bool n
 
-config HUGETLBFS
+menuconfig HUGETLBFS
 	bool "HugeTLB file system support"
 	depends on X86 || IA64 || SPARC64 || ARCH_SUPPORTS_HUGETLBFS || BROKEN
 	depends on (SYSFS || SYSCTL)
@@ -265,22 +265,24 @@ config HUGETLBFS
 
 	  If unsure, say N.
 
-config HUGETLB_PAGE
-	def_bool HUGETLBFS
-
-config HUGETLB_PAGE_OPTIMIZE_VMEMMAP
-	def_bool HUGETLB_PAGE
-	depends on ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP
-	depends on SPARSEMEM_VMEMMAP
-
+if HUGETLBFS
 config HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON
 	bool "HugeTLB Vmemmap Optimization (HVO) defaults to on"
 	default n
 	depends on HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 	help
-	  The HugeTLB VmemmapvOptimization (HVO) defaults to off. Say Y here to
+	  The HugeTLB Vmemmap Optimization (HVO) defaults to off. Say Y here to
 	  enable HVO by default. It can be disabled via hugetlb_free_vmemmap=off
 	  (boot command line) or hugetlb_optimize_vmemmap (sysctl).
+endif # HUGETLBFS
+
+config HUGETLB_PAGE
+	def_bool HUGETLBFS
+
+config HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+	def_bool HUGETLB_PAGE
+	depends on ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP
+	depends on SPARSEMEM_VMEMMAP
 
 config ARCH_HAS_GIGANTIC_PAGE
 	bool
-- 
2.39.5




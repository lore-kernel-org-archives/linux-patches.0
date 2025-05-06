Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B44A6222580;
	Tue,  6 May 2025 21:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746567377; cv=none; b=iGCNX3Oo3haZEujLXuFm8h8Gv8s4voj8J7aqdspWCtRxa4nGOSpvVpTOXKMH2HizmtUiR1WpuDkBxTTxF2wE2tYO0KxmyhCqS/8lsVIHbb8DT61nVB7aj6rvW2y8hM5LatAsvALZns8/m/t/mR07iRMVPdOp/OdO01WOefqDRB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746567377; c=relaxed/simple;
	bh=n+v9BOhh3isrjokrbTClmyh8lyR9UdQtGmiOV/8lRJM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GSACfA7ez564QMbcLvaHWp/TxGn+gNh4Tf32eRUn4UVyzzU593UWD3fqBah02/RnBG25TaFyyhQ5goGss1wx7OKJCSl8FmnptWs3lxV8mUBM6QWcsVhJrp7uf7eeNRIt4Xhsun50Ub8R6nNKBfHfft5MBCjytEYeR6GTAZmCMzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=saX2FzS8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="saX2FzS8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86E53C4CEEE;
	Tue,  6 May 2025 21:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746567377;
	bh=n+v9BOhh3isrjokrbTClmyh8lyR9UdQtGmiOV/8lRJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=saX2FzS8/kjzOFD42D2ZClX0nGDbVMgN/lWaup/pVLK/8PVkKjfT3Jp6n3RKiHbxh
	 8zr2Jt09APMnMkOmWufp3k3OzrnR8M9yfh1eNa1Rluq+MVcpO+bWjR5J4OyVcaC27Q
	 /2txdsU9JV23ZYgssjtllOD3jlDurR4NzdlMXrElU8LS+8mSZpY7gU7kWbiB5cg1vd
	 8rB6+o2qrKLwc852b1xmsm9qufMHOxjYCzVIc99rhuhFs6gbd9m5uA8UK9gjsobRYF
	 D81LYoWeSQucJcJBsfB74gbuGe2moBXKu/kCSjUzsxPJvGrORccfz2NqwQToEkTMJh
	 anHt5LzDafkBw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Donet Tom <donettom@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>,
	mpe@ellerman.id.au,
	hbathini@linux.ibm.com,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 02/18] book3s64/radix: Fix compile errors when CONFIG_ARCH_WANT_OPTIMIZE_DAX_VMEMMAP=n
Date: Tue,  6 May 2025 17:35:54 -0400
Message-Id: <20250506213610.2983098-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250506213610.2983098-1-sashal@kernel.org>
References: <20250506213610.2983098-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.27
Content-Transfer-Encoding: 8bit

From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>

[ Upstream commit 29bdc1f1c1df80868fb35bc69d1f073183adc6de ]

Fix compile errors when CONFIG_ARCH_WANT_OPTIMIZE_DAX_VMEMMAP=n

Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/8231763344223c193e3452eab0ae8ea966aff466.1741609795.git.donettom@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/book3s64/radix_pgtable.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index b0d927009af83..633d500ea7ab6 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -988,7 +988,7 @@ int __meminit radix__vmemmap_create_mapping(unsigned long start,
 	return 0;
 }
 
-
+#ifdef CONFIG_ARCH_WANT_OPTIMIZE_DAX_VMEMMAP
 bool vmemmap_can_optimize(struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
 {
 	if (radix_enabled())
@@ -996,6 +996,7 @@ bool vmemmap_can_optimize(struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
 
 	return false;
 }
+#endif
 
 int __meminit vmemmap_check_pmd(pmd_t *pmdp, int node,
 				unsigned long addr, unsigned long next)
-- 
2.39.5


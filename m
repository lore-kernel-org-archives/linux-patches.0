Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E32F22D9E9;
	Tue,  6 May 2025 21:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746567416; cv=none; b=BswMtbNJFKM4byR6D9cEzTFrTsFcjswYxg8bzQARFW1fnhcU2YFhFdWTpn7J8Mrt7XW8Trl/c+L+dfR+g3a7whV2imPvECT2yB3+duRVErvUMBlqaoR/MKwAkamSkUYrFqdKdY5fe096KjDnQ2zajJj9aF+HR6Th7t5SYxLWwwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746567416; c=relaxed/simple;
	bh=3kJx4RrF/TV+86iMY/0XpKRaCCjS+kWAD0tKlrf/ejc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eqHMyCqs6hbibRpwrVqveZNLHazt4gNVQhwswt+sDbaLBMTWbYxcTZI+KNyAb/lV7aGTEvz/7sl81vUcqDlalqdmJtcOehWsOrOL1Ua9ZzbbawD1B3mPNWIXHfY/H+OkB55KBpqxNabkv3QAb06fQ3T2o7mNsX4WikzDITidv/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uxOo2WeV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uxOo2WeV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56A8DC4CEEF;
	Tue,  6 May 2025 21:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746567415;
	bh=3kJx4RrF/TV+86iMY/0XpKRaCCjS+kWAD0tKlrf/ejc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uxOo2WeVO5cbuQv7FwSXiMQiSnuYVoT8R1gohIxtSRzzph1JoP+oERYtdvr6M7BHW
	 5mu1VfbEgY/zLniy5B7+AklyWBo0x/Kxn2zOALJwSFt/iqUQS8dsFLb41VqPOs5c7M
	 wfVkoWB3CZYtWIA2h77yQNt3RJxq85cpjs80hq3sWHu3VecQUVTkdZjUTyvos/VGrd
	 w5sKmUWoW+AvkzZfMjIhuf00jK1+i7FPlgSrTVuz9jPVUgsg4tkzVCRItO7T37pzFA
	 wF4OGJQYtAK/iceMMJPTKDO1MzAlbq/T1O+VrO1YAZ54CTBU2aRhKYrtSEfEYhcX2p
	 QHxrB+zkyetmw==
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
Subject: [PATCH AUTOSEL 6.6 02/12] book3s64/radix: Fix compile errors when CONFIG_ARCH_WANT_OPTIMIZE_DAX_VMEMMAP=n
Date: Tue,  6 May 2025 17:36:37 -0400
Message-Id: <20250506213647.2983356-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250506213647.2983356-1-sashal@kernel.org>
References: <20250506213647.2983356-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.89
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
index c6a4ac766b2bf..425b1a9eed8f0 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -912,7 +912,7 @@ int __meminit radix__vmemmap_create_mapping(unsigned long start,
 	return 0;
 }
 
-
+#ifdef CONFIG_ARCH_WANT_OPTIMIZE_DAX_VMEMMAP
 bool vmemmap_can_optimize(struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
 {
 	if (radix_enabled())
@@ -920,6 +920,7 @@ bool vmemmap_can_optimize(struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
 
 	return false;
 }
+#endif
 
 int __meminit vmemmap_check_pmd(pmd_t *pmdp, int node,
 				unsigned long addr, unsigned long next)
-- 
2.39.5


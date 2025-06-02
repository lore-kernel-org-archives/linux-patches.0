Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDBCB22259C;
	Mon,  2 Jun 2025 14:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873966; cv=none; b=h6xflDm7lazlIvoRZOAacCsNOTaPk4LzYV9Gn1wFgCoQJ3GkVQ/Vs5FW7tnCvm78Sqf8heZB/69H7Zc9dXph0hSd9v89WxvGifBtVEuo2VOKWdftB6E/kGox8L0Dzoyl4Ld9iNcp2oBMs7KzWdDoe72Bzw8bSxFP9g2sKXjEoUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873966; c=relaxed/simple;
	bh=wux90AhSUybHxPzR0ElyAjFOa45C0fWaXA8sA0jng50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g1PAFWLx80bwQkOkAAzAOsFHz2qPhB1EpYv5s1mg9VxEqSWIna1nu5Hf4PXSzuwLcsaZRWq5xZvP1dGwTjnVDbgmAsyufRsAyC81iF/AX3uhX8Y/+TV27Z9sTwpcSoSXgBXdGSRifpz7dM2nLROWPVxxN7QFFhQ+4UwrsC5hbmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zDqnnpaP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zDqnnpaP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4560C4CEEB;
	Mon,  2 Jun 2025 14:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873966;
	bh=wux90AhSUybHxPzR0ElyAjFOa45C0fWaXA8sA0jng50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zDqnnpaPrYLVSXkHai7e8VjtCPjrj7i+zKj7kSD3eUO1t5iMmy+tbUDLVIv741+bo
	 +jLlOfy8olZYmeyYLkyUoqUULaOqR3m3tBSjRmPyuEiRWnstr9UYrL+YpzrsmaxQaR
	 KnWrwiZi1t7QhIyUoVeZ31eIjuNHJsIiIcLwz3kU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Donet Tom <donettom@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 313/444] book3s64/radix: Fix compile errors when CONFIG_ARCH_WANT_OPTIMIZE_DAX_VMEMMAP=n
Date: Mon,  2 Jun 2025 15:46:17 +0200
Message-ID: <20250602134353.641751272@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

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
index 28460e3340808..aff3b37e32d64 100644
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




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06137215F52;
	Tue,  6 May 2025 21:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746567332; cv=none; b=lhLAgAknRdLDV0HmeZXx5z+rR33lx1BMsUnqLEG9uqnoIzSO9AJ1ESu+E6MQto316lEctgSvxyGuI5W5UL+48Chx8lpPOSLQ/hQ2UDrAmJYr3yHlBJlGcsi1xM2T1ssb8cRtwevJvwATS8/zohzczEs0Dfx9UYeXahAWE3mvzF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746567332; c=relaxed/simple;
	bh=Jm5WhIlJxrkHokatjuS6LYXj+etWscX/nFFkAt3oKKg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SzIsX/kkwzT0Ba7azLY3fl5Q44DRyygAFdznzYgYhoaOby276q5c21I1MpXw/dM1LAbAYu8KFo8BxBBMWME+1LVUGYoN5DrpX5aKAPfhH8uatHDr+9YuXlovvfEUFIb0B/3zq8TaEoZUQU5/qa4BTPb1WtUilxPR9liJ3yIHaEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s723eAEO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s723eAEO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1912C4CEF1;
	Tue,  6 May 2025 21:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746567331;
	bh=Jm5WhIlJxrkHokatjuS6LYXj+etWscX/nFFkAt3oKKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s723eAEOCJAhUsf+O/0fuvlOBF/IOgzZ/OSnqiAlJq47enTr/rbt9sFC0MDwTtDvQ
	 HkZ9GBgvcP1QFIKFfrStj871aFCmnOQ/6Pmw+bv0LYPvWF1XyoO2hCu+W175ka0onH
	 FVm3iiQScYxXLNPR4bl+beuDEUx9tSqHSDMhZu5EDsdshQZKns5um50bj4S5rw+F+c
	 CWlFK9KMqXoLwOxJxpPUbLSCEcDqqOUa+MceoUp26wRiF8HMA8eIVjz101joFmqElF
	 9UhX9MTnuos6Kbg89jzomdN1ZrMWD3cKo+BVvGxYRbg6yBJVauww8dgkYg3DXb7vDK
	 gwazZrH0mNHaQ==
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
Subject: [PATCH AUTOSEL 6.14 02/20] book3s64/radix: Fix compile errors when CONFIG_ARCH_WANT_OPTIMIZE_DAX_VMEMMAP=n
Date: Tue,  6 May 2025 17:35:05 -0400
Message-Id: <20250506213523.2982756-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250506213523.2982756-1-sashal@kernel.org>
References: <20250506213523.2982756-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.5
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
index 311e2112d782e..bd6916419472c 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -976,7 +976,7 @@ int __meminit radix__vmemmap_create_mapping(unsigned long start,
 	return 0;
 }
 
-
+#ifdef CONFIG_ARCH_WANT_OPTIMIZE_DAX_VMEMMAP
 bool vmemmap_can_optimize(struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
 {
 	if (radix_enabled())
@@ -984,6 +984,7 @@ bool vmemmap_can_optimize(struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
 
 	return false;
 }
+#endif
 
 int __meminit vmemmap_check_pmd(pmd_t *pmdp, int node,
 				unsigned long addr, unsigned long next)
-- 
2.39.5


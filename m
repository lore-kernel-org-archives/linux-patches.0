Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E44FD512
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:33:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 759DCC433EF;
	Mon, 15 May 2023 16:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684168438;
	bh=EpYlJNF+0s0XmcTZ4AMNPOfFki33Ky44iAcvkzFITKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q/YOwMOFlz/lHPrusWYvQzC1vO+rpQ3WC9IQzhryAqjxCjStnqMkbQ3PKHRxF7+p6
	 7cTAFXqUbIYRbyAa5BHO406BoJAm+Je4OjEULaQFQfVFcfhOaV7eCaM4bzv9pLk1UR
	 e/c473se5x6wVfgPQavx1eEIg8okLhOio2M2KnKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 049/116] ia64: mm/contig: fix section mismatch warning/error
Date: Mon, 15 May 2023 18:25:46 +0200
Message-Id: <20230515161659.893798511@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161658.228491273@linuxfoundation.org>
References: <20230515161658.228491273@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 58deeb4ef3b054498747d0929d94ac53ab90981f ]

alloc_per_cpu_data() is called by find_memory(), which is marked as
__init.  Therefore alloc_per_cpu_data() can also be marked as __init to
remedy this modpost problem.

WARNING: modpost: vmlinux.o: section mismatch in reference: alloc_per_cpu_data (section: .text) -> memblock_alloc_try_nid (section: .init.text)

Link: https://lkml.kernel.org/r/20230223034258.12917-1-rdunlap@infradead.org
Fixes: 4b9ddc7cf272 ("[IA64] Fix section mismatch in contig.c version of per_cpu_init()")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/ia64/mm/contig.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/ia64/mm/contig.c b/arch/ia64/mm/contig.c
index 52715a71aede0..179d354e02321 100644
--- a/arch/ia64/mm/contig.c
+++ b/arch/ia64/mm/contig.c
@@ -129,7 +129,7 @@ void *per_cpu_init(void)
 	return __per_cpu_start + __per_cpu_offset[smp_processor_id()];
 }
 
-static inline void
+static inline __init void
 alloc_per_cpu_data(void)
 {
 	cpu_data = __alloc_bootmem(PERCPU_PAGE_SIZE * num_possible_cpus(),
-- 
2.39.2




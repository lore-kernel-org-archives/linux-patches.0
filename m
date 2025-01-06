Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AF7F16D9B8;
	Mon,  6 Jan 2025 15:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178314; cv=none; b=ooAjpLrllov0clhU0v2kCyI/z5Fm4vSlBJHZG+Xp4uuCZJDpFI3hOEghZ254TuOaSl56SKvz0hly5ke9m9l2OGTY0FZEjWruvNI0c6FLFbB+BK5funx4O+hgspf/6Om5hZhR9iRFRDqMeQbVFyiwDGZyET5jtSSEvM2G/BYCpCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178314; c=relaxed/simple;
	bh=KqiZ0w1gkXaAgKKCZ06HRzKJ3tUkrNSfM3RHo+GRWIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bfZVgFNtLdECM0aFfu83O0/LHf+bSC9Z0mOyPPJhpne76qaMKczfkDtEu7cdTSXot5SeK7pJalhWFPuhJSlhdf57VkA170bJrBPX+yUjdxD0oE5Tf0O/B3yy2yHWaHN0TENwMcfNQU+GZoS+V5DWZegmuDRlQv/6Qauchtd35yQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z5EIMlxN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z5EIMlxN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF27EC4CED2;
	Mon,  6 Jan 2025 15:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178314;
	bh=KqiZ0w1gkXaAgKKCZ06HRzKJ3tUkrNSfM3RHo+GRWIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z5EIMlxNRI/KsKqw4A29g4wFRzcEdYrb9kpYto7KxYmjIc3Q54Jrkj9TD5l96PFQV
	 +mTs/pFQzSzfLzccwhu2YHBUdHta8G+bmUZcaadV7e+INhOY121f2vdmyitJSlHLK6
	 kg6y/qteeNr807h9hb03HUlC1mSbS2CYq2+svOak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunfeng Ye <yeyunfeng@huawei.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 076/138] arm64: mm: Rename asid2idx() to ctxid2asid()
Date: Mon,  6 Jan 2025 16:16:40 +0100
Message-ID: <20250106151136.110027089@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yunfeng Ye <yeyunfeng@huawei.com>

[ Upstream commit a3a5b763410c7bceacf41a52071134d9dc26202a ]

The commit 0c8ea531b774 ("arm64: mm: Allocate ASIDs in pairs") introduce
the asid2idx and idx2asid macro, but these macros are not really useful
after the commit f88f42f853a8 ("arm64: context: Free up kernel ASIDs if
KPTI is not in use").

The code "(asid & ~ASID_MASK)" can be instead by a macro, which is the
same code with asid2idx(). So rename it to ctxid2asid() for a better
understanding.

Also we add asid2ctxid() macro, the contextid can be generated based on
the asid and generation through this macro.

Signed-off-by: Yunfeng Ye <yeyunfeng@huawei.com>
Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Link: https://lore.kernel.org/r/c31516eb-6d15-94e0-421c-305fc010ea79@huawei.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Stable-dep-of: c0900d15d31c ("arm64: Ensure bits ASID[15:8] are masked out when the kernel uses 8-bit ASIDs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/mm/context.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/mm/context.c b/arch/arm64/mm/context.c
index 001737a8f309..171f2fcd3cf2 100644
--- a/arch/arm64/mm/context.c
+++ b/arch/arm64/mm/context.c
@@ -35,8 +35,8 @@ static unsigned long *pinned_asid_map;
 #define ASID_FIRST_VERSION	(1UL << asid_bits)
 
 #define NUM_USER_ASIDS		ASID_FIRST_VERSION
-#define asid2idx(asid)		((asid) & ~ASID_MASK)
-#define idx2asid(idx)		asid2idx(idx)
+#define ctxid2asid(asid)	((asid) & ~ASID_MASK)
+#define asid2ctxid(asid, genid)	((asid) | (genid))
 
 /* Get the ASIDBits supported by the current CPU */
 static u32 get_cpu_asid_bits(void)
@@ -120,7 +120,7 @@ static void flush_context(void)
 		 */
 		if (asid == 0)
 			asid = per_cpu(reserved_asids, i);
-		__set_bit(asid2idx(asid), asid_map);
+		__set_bit(ctxid2asid(asid), asid_map);
 		per_cpu(reserved_asids, i) = asid;
 	}
 
@@ -162,7 +162,7 @@ static u64 new_context(struct mm_struct *mm)
 	u64 generation = atomic64_read(&asid_generation);
 
 	if (asid != 0) {
-		u64 newasid = generation | (asid & ~ASID_MASK);
+		u64 newasid = asid2ctxid(ctxid2asid(asid), generation);
 
 		/*
 		 * If our current ASID was active during a rollover, we
@@ -183,7 +183,7 @@ static u64 new_context(struct mm_struct *mm)
 		 * We had a valid ASID in a previous life, so try to re-use
 		 * it if possible.
 		 */
-		if (!__test_and_set_bit(asid2idx(asid), asid_map))
+		if (!__test_and_set_bit(ctxid2asid(asid), asid_map))
 			return newasid;
 	}
 
@@ -209,7 +209,7 @@ static u64 new_context(struct mm_struct *mm)
 set_asid:
 	__set_bit(asid, asid_map);
 	cur_idx = asid;
-	return idx2asid(asid) | generation;
+	return asid2ctxid(asid, generation);
 }
 
 void check_and_switch_context(struct mm_struct *mm)
@@ -300,13 +300,13 @@ unsigned long arm64_mm_context_get(struct mm_struct *mm)
 	}
 
 	nr_pinned_asids++;
-	__set_bit(asid2idx(asid), pinned_asid_map);
+	__set_bit(ctxid2asid(asid), pinned_asid_map);
 	refcount_set(&mm->context.pinned, 1);
 
 out_unlock:
 	raw_spin_unlock_irqrestore(&cpu_asid_lock, flags);
 
-	asid &= ~ASID_MASK;
+	asid = ctxid2asid(asid);
 
 	/* Set the equivalent of USER_ASID_BIT */
 	if (asid && arm64_kernel_unmapped_at_el0())
@@ -327,7 +327,7 @@ void arm64_mm_context_put(struct mm_struct *mm)
 	raw_spin_lock_irqsave(&cpu_asid_lock, flags);
 
 	if (refcount_dec_and_test(&mm->context.pinned)) {
-		__clear_bit(asid2idx(asid), pinned_asid_map);
+		__clear_bit(ctxid2asid(asid), pinned_asid_map);
 		nr_pinned_asids--;
 	}
 
-- 
2.39.5




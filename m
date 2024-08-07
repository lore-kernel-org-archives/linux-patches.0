Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 339C023CE;
	Wed,  7 Aug 2024 15:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723042878; cv=none; b=oK4pB+MeKcS0f7LqEaO1ZcmUyHpc0Xhpuk8NkWw+cf0Z83z2QqRIna3yLiQT5/9+wMhQVJs2litHviEIdg/ncJdSdo6MzslGxRTO7kTDtPl+c/BQ+yMIcZQIaVBM8CtKB2O97dwSzpb4uNGssyKMTZiud7rwF5k8F2aJdgElKlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723042878; c=relaxed/simple;
	bh=nYioU82t9lfE3WySzwYOWeabhB9zLoQw5phfoAiXnYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u8/XIqWIydg6/noNVCp7qFhUtOcuKihkpYFqtaxLq+gYHmBNXvAl9RnvPM/2e8kmy7TW32dOD2biPMi87eRJz660aua63GJl9u2PfMt6gSFvLP8lfVjxnqlMmNv6cAFWDQqySw+BrlwRoM39OT7G1ZpGSICQQl74NSQeM8O+Ovk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MRrh3A4L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MRrh3A4L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D43DC4AF0D;
	Wed,  7 Aug 2024 15:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723042877;
	bh=nYioU82t9lfE3WySzwYOWeabhB9zLoQw5phfoAiXnYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MRrh3A4LMTtI4PUEd8dBBlmkR5a4XvyesxWo1Qt2c7Hefc2i6PFekdfMeKNZsoyai
	 CRS5hZLituHIie01foBClkRjZqk284caEOpNE6HiUQrinMNRwvh8OT0nWSg8Ij0ciW
	 tOTeRo1oj3keCB5ikj32hF8cL9CoC4mN/bhBXDGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ran Xiaokai <ran.xiaokai@zte.com.cn>,
	David Hildenbrand <david@redhat.com>,
	Lu Zhongjun <lu.zhongjun@zte.com.cn>,
	xu xin <xu.xin16@zte.com.cn>,
	Yang Yang <yang.yang29@zte.com.cn>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Yang Shi <shy828301@gmail.com>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 001/123] mm/huge_memory: mark racy access onhuge_anon_orders_always
Date: Wed,  7 Aug 2024 16:58:40 +0200
Message-ID: <20240807150020.834416694@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ran Xiaokai <ran.xiaokai@zte.com.cn>

[ Upstream commit 7f83bf14603ef41a44dc907594d749a283e22c37 ]

huge_anon_orders_always is accessed lockless, it is better to use the
READ_ONCE() wrapper.  This is not fixing any visible bug, hopefully this
can cease some KCSAN complains in the future.  Also do that for
huge_anon_orders_madvise.

Link: https://lkml.kernel.org/r/20240515104754889HqrahFPePOIE1UlANHVAh@zte.com.cn
Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lu Zhongjun <lu.zhongjun@zte.com.cn>
Reviewed-by: xu xin <xu.xin16@zte.com.cn>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 00f58104202c ("mm: fix khugepaged activation policy")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/huge_mm.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index c73ad77fa33d3..71945cf4c7a8d 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -140,8 +140,8 @@ static inline bool hugepage_flags_enabled(void)
 	 * So we don't need to look at huge_anon_orders_inherit.
 	 */
 	return hugepage_global_enabled() ||
-	       huge_anon_orders_always ||
-	       huge_anon_orders_madvise;
+	       READ_ONCE(huge_anon_orders_always) ||
+	       READ_ONCE(huge_anon_orders_madvise);
 }
 
 static inline int highest_order(unsigned long orders)
-- 
2.43.0




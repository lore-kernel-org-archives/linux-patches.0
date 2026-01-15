Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA98C3BF30A;
	Thu, 15 Jan 2026 17:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498303; cv=none; b=YQUy2pkExEOvBQkmJX0FbY2FsDlCDRovRtzSQcp3yxRvwcR8QbvdgZyDCr1+JB3CZKmpuynlYwjI2mSqihLcjctTYfDjXSwWocg0gxri4mt8qsc718dDaqqkKDTui2IbjgLtTpp0Ausf4oQxgP89lD0B7onyFQa0ELjSpksgxLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498303; c=relaxed/simple;
	bh=HZiwmnMTYHZ1bU2FMD+c/mAxGuQDx0AwvDiRBMvZUTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GP6mfBjpSj/ecDQI8WpL69+07dUA4Pi8qWzvLmK0dtYFjgrFjv4napzmzntERnSS7R4zK1UH40XX1HTTTozfDTylb6EShULqGxf9zyF9vVJN6zuOi3Zhkjak15NrTf+B2BWt0waN2kCzQbT2WzmYAs/6YCeNrXkgGvYVtAY5hKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NIZyXcna; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NIZyXcna"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3066CC116D0;
	Thu, 15 Jan 2026 17:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498303;
	bh=HZiwmnMTYHZ1bU2FMD+c/mAxGuQDx0AwvDiRBMvZUTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NIZyXcnaB+7rPDhqjdnIgXSm9Jk9omfitWKrfK6N4CyTr9P2m2Bvh+qw0heYMsIE7
	 juc/jZdGCurbxFkRTcr9DuUjS8cqq1lN5yL6Thrdy7JUChHTT5HUwLlgI111c93S0G
	 RGW7+kUkhS2i9kTbH5+DtMCQukB/WT4UlTghOUQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Randy Dunlap <rdunlap@infradead.org>,
	Alexey Skidanov <alexey.skidanov@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 351/554] genalloc.h: fix htmldocs warning
Date: Thu, 15 Jan 2026 17:46:57 +0100
Message-ID: <20260115164258.933190562@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Morton <akpm@linux-foundation.org>

[ Upstream commit 5393802c94e0ab1295c04c94c57bcb00222d4674 ]

WARNING: include/linux/genalloc.h:52 function parameter 'start_addr' not described in 'genpool_algo_t'

Fixes: 52fbf1134d47 ("lib/genalloc.c: fix allocation of aligned buffer from non-aligned chunk")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Closes: https://lkml.kernel.org/r/20251127130624.563597e3@canb.auug.org.au
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Alexey Skidanov <alexey.skidanov@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/genalloc.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/genalloc.h b/include/linux/genalloc.h
index 0bd581003cd5..60de63e46b33 100644
--- a/include/linux/genalloc.h
+++ b/include/linux/genalloc.h
@@ -44,6 +44,7 @@ struct gen_pool;
  * @nr: The number of zeroed bits we're looking for
  * @data: optional additional data used by the callback
  * @pool: the pool being allocated from
+ * @start_addr: start address of memory chunk
  */
 typedef unsigned long (*genpool_algo_t)(unsigned long *map,
 			unsigned long size,
-- 
2.51.0




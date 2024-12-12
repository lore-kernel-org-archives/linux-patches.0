Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EAB520967D;
	Thu, 12 Dec 2024 16:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020913; cv=none; b=hFKYLMBL+xCgI5Z7qP3kPiRUxM/Ao26+E3BYbMx1ENG5I83pCkeXDt2vIsEB3dCx/pcM4vxWRqrSwut4oZwF5yar3Cp+hXcFYCKEHuZzeiBBVipy2SJIOuIuBDVO0lRf/CpZfEB71Qplw/77h3y4t5MEvvp6dAooDksj4I9d7bM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020913; c=relaxed/simple;
	bh=il2esbmc0Wag3FE7s8X/lbm9Gf1SzW8WEPjuhRki73M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JJtvnuTTSRvbWik5YoEcwa7rK+Q7gwBNOFFzjIfVzSh/rUCyX8nIX0qDv2iIzUP+duZpkUSx2RQ4ikBi9cqWeVwVBspFTUuaDp3cu/tv5JooEP2ydatr7o4m6awl4bnaY+tm6NqCQZz+KDYqK3BeTY731b1TRjF3bSV8Mm8GD9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0WCiyO+s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0WCiyO+s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72089C4CED0;
	Thu, 12 Dec 2024 16:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020912;
	bh=il2esbmc0Wag3FE7s8X/lbm9Gf1SzW8WEPjuhRki73M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0WCiyO+sBq+F7/me4WJzWaxTFxfEQxa7EBo0yqUp3j8GHmxUFr+gGA6RRhDj8yOt+
	 zr7uLwsOvF4Iz1JQ41NK7Oh5y6QgaKpCan19LM1x10De/sAUcLE64wCsnGeBBv/1Wz
	 B0xfxVvDhYoCviJ1OjpTMz6aHxkB9qJ8/YyWeHxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Logan Gunthorpe <logang@deltatee.com>,
	Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 596/772] scatterlist: fix incorrect func name in kernel-doc
Date: Thu, 12 Dec 2024 15:59:01 +0100
Message-ID: <20241212144414.557581465@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit d89c8ec0546184267cb211b579514ebaf8916100 ]

Fix a kernel-doc warning by making the kernel-doc function description
match the function name:

include/linux/scatterlist.h:323: warning: expecting prototype for sg_unmark_bus_address(). Prototype was for sg_dma_unmark_bus_address() instead

Link: https://lkml.kernel.org/r/20241130022406.537973-1-rdunlap@infradead.org
Fixes: 42399301203e ("lib/scatterlist: add flag for indicating P2PDMA segments in an SGL")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/scatterlist.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index 375a5e90d86ac..02cdcd3c31fb4 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -288,7 +288,7 @@ static inline void sg_dma_mark_bus_address(struct scatterlist *sg)
 }
 
 /**
- * sg_unmark_bus_address - Unmark the scatterlist entry as a bus address
+ * sg_dma_unmark_bus_address - Unmark the scatterlist entry as a bus address
  * @sg:		 SG entry
  *
  * Description:
-- 
2.43.0




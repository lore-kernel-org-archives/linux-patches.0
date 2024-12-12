Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 393092135C1;
	Thu, 12 Dec 2024 15:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017969; cv=none; b=liv6HpMAB9p+8bj4iZK0pgYWdPSWkrUP5ntEIT2eWt2gkF/zXrCwMWQckrANQ7sznhbdt4n6zutus7ggBwWH2WEu5Fyg8iGUZEAujHcMGkMmvI3aE51G4AdOaos1Mm882OPstwwU3dOL3XV+6B2Q9yUVrQ5y+pFsbxH+pljVQ3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017969; c=relaxed/simple;
	bh=kCegjJ3Z0+aF4LCVedvb8DmUEppJ3XS40KzPl3SUQfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dAiuZvofUwMLm+Aje0+KqDwIaSTuuumc9M+wjLC+X9AIqrOPihPBwCozhYN/VFzXOhaS7riu9yYvPsFZCBf/HDBDad1qSe1W/qrEc4vxw4bTauMH/o8M4MAzj1lWeSsiipKBfwx8Y3mSHDoPM+8UkD87JZYVBgs6w0XBl7IVAdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D5t+DYuC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D5t+DYuC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50C12C4CECE;
	Thu, 12 Dec 2024 15:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017968;
	bh=kCegjJ3Z0+aF4LCVedvb8DmUEppJ3XS40KzPl3SUQfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D5t+DYuCiC6ruIBLTHVaKj/ku+LpmLmrU7s4KUUm39DtXnLU/pEzU45nBBS1oL1HI
	 m+DilkJ3VEmnrcNxc3SXYdI1JPE+L6KLt6JHLbYKvb13fsgi3luzygb5qZz7p4dxTv
	 v6KODvNOFppRB60YcZjgJfdc2M1iz0svmVX08Bbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Logan Gunthorpe <logang@deltatee.com>,
	Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 131/356] scatterlist: fix incorrect func name in kernel-doc
Date: Thu, 12 Dec 2024 15:57:30 +0100
Message-ID: <20241212144249.826944485@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 77df3d7b18a61..d45529cbd0bd5 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -313,7 +313,7 @@ static inline void sg_dma_mark_bus_address(struct scatterlist *sg)
 }
 
 /**
- * sg_unmark_bus_address - Unmark the scatterlist entry as a bus address
+ * sg_dma_unmark_bus_address - Unmark the scatterlist entry as a bus address
  * @sg:		 SG entry
  *
  * Description:
-- 
2.43.0




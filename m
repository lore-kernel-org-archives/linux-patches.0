Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E745FC08
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:37:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AF51C433EF;
	Mon, 15 May 2023 17:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684172278;
	bh=B2SqBvsUfqeh+ovbdkk5C9PKmMYKiO0F3vLolar1sq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bUa/CTarsgPdzXxJ+ZTsaKse5wqim3JWRUZLSEkybLlA63PLOflYMFlXJGHgGW3Xz
	 MXNKMRokLRrg3UovhGGcn+06K7TSXbdzi8jUmiJJOzRuyYbNtejWcPNTs0Foq0WWuy
	 6Q86yYtInc+4rdTkQMX12jiABF7FskXxsShXBxdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jingbo Xu <jefflexu@linux.alibaba.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Chao Yu <chao@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 072/381] erofs: fix potential overflow calculating xattr_isize
Date: Mon, 15 May 2023 18:25:23 +0200
Message-Id: <20230515161740.075936332@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161736.775969473@linuxfoundation.org>
References: <20230515161736.775969473@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jingbo Xu <jefflexu@linux.alibaba.com>

[ Upstream commit 1b3567a1969b26f709d82a874498c0754ea841c3 ]

Given on-disk i_xattr_icount is 16 bits and xattr_isize is calculated
from i_xattr_icount multiplying 4, xattr_isize has a theoretical maximum
of 256K (64K * 4).

Thus declare xattr_isize as unsigned int to avoid the potential overflow.

Fixes: bfb8674dc044 ("staging: erofs: add erofs in-memory stuffs")
Signed-off-by: Jingbo Xu <jefflexu@linux.alibaba.com>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Link: https://lore.kernel.org/r/20230414061810.6479-1-jefflexu@linux.alibaba.com
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/internal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index 67a7ec9456866..ce52f708a403d 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -232,7 +232,7 @@ struct erofs_inode {
 
 	unsigned char datalayout;
 	unsigned char inode_isize;
-	unsigned short xattr_isize;
+	unsigned int xattr_isize;
 
 	unsigned int xattr_shared_count;
 	unsigned int *xattr_shared_xattrs;
-- 
2.39.2




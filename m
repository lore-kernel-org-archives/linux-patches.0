Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FAFD3A641D;
	Thu, 30 Jul 2026 15:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426691; cv=none; b=UFJna9PQ75kcfsBAkU0wlXdK7HyrtQib2WW+LNA6DR42aDPAiQJ6pKeDNEk7OMbBUxK8E5OzQlZWWF7XABf9e4rM2/AaCG5SFKU9MV8k75AOOir4O3eUrbs9rX1uuT2EOLbDO2nc26a2PC7EBMjXPq9y3CYz1eCbfF1IQLA8Z1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426691; c=relaxed/simple;
	bh=G05Rk8FGGH97qqreOd51wI2KRZ+yy3HpheirrgZvWaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ANOcFCZIJgILm6Zt1UvXgKPpAZb83RDeOQ4IF2TsxS55c9nHKNknfA8+NcJJhw8LN72wg+s92SBhAgk23T4E6E5LDhJDyT6d9u/KPG7+/FPXBUmbgwql3Cjon/dvO7s9f95fyKcjnpA2Cl4ylltQhNRc0iPA53EIOzh5VBLDRgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UR7bOEaq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UR7bOEaq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63F111F00A3A;
	Thu, 30 Jul 2026 15:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426689;
	bh=8EznQPqGLRg0Q3X6LRIvaiwMIWGGCh1u1yDzE0lsr0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UR7bOEaqMVP97EEYaMAxMg++l+1ad3VR5tWvqLdy7nU7ZsfSIYeF/iNhn1YIIDzYn
	 ZGIo2w+TjUzKvinA8valyG6i48gtLxgLv67CalRBH1Uof1a4mWYLVrKPAR+/QR5udc
	 8Hx6AJD184n2MdTxR6X4h/J7a0JipxwmJh0T4xAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yue Haibing <yuehaibing@huawei.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 507/602] netfilter: nf_tables: Remove unused nft_reduce_is_readonly()
Date: Thu, 30 Jul 2026 16:14:59 +0200
Message-ID: <20260730141446.643029513@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yue Haibing <yuehaibing@huawei.com>

[ Upstream commit bf6788742b8d6c73de441e088a71de7154f0d4aa ]

Since commit 9e539c5b6d9c ("netfilter: nf_tables: disable expression
reduction infra") this is unused.

Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: d07955dd34ec ("netfilter: nft_fib: reject fib expression on the netdev egress hook")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/netfilter/nf_tables.h |    5 -----
 1 file changed, 5 deletions(-)

--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1954,11 +1954,6 @@ static inline u64 nft_net_tstamp(const s
 #define __NFT_REDUCE_READONLY	1UL
 #define NFT_REDUCE_READONLY	(void *)__NFT_REDUCE_READONLY
 
-static inline bool nft_reduce_is_readonly(const struct nft_expr *expr)
-{
-	return expr->ops->reduce == NFT_REDUCE_READONLY;
-}
-
 void nft_reg_track_update(struct nft_regs_track *track,
 			  const struct nft_expr *expr, u8 dreg, u8 len);
 void nft_reg_track_cancel(struct nft_regs_track *track, u8 dreg, u8 len);



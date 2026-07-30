Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D15E385D7B;
	Thu, 30 Jul 2026 16:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428196; cv=none; b=MXT6y+fNbDGMEY4/stdSfXRnsMye4XWOzpaQLUTIaOvddo2lerhSz/3168xDYNMKTl1zEiUcFItrVVztP74gvUxpkCwzVdCbMiSQ4PekvG6IWIVgA9LG2ZmWGw0ythA5DTEz/Q+vdqXLuKnRpriRadHpWUcR6yFOZK5qfM7QrRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428196; c=relaxed/simple;
	bh=eor4fX34NktNt8rEUhH/UXJNZxR1HPmghFeHWrK5S5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rDYbzQTutI8eVnsNmjY1tSuMCJoBGCBQdPEauG40kj5spjFXghWHhtArPjD+7u12LloESHfdYrPzfwtjK3ikJovAIyJMBz/BXs7KhxuDoFAcMZpLDypheCIP0QLH8nMkDutw+RCu7ermG6IdAJ10pN1468dD1uRopM11IFrC5wA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OR10bVOh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OR10bVOh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 487211F00A3E;
	Thu, 30 Jul 2026 16:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785428187;
	bh=3VkTnXhar/T6zoJ68wzosnwTkO/OJTpQDhFgz5nnQ6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OR10bVOh02GUlPrkU298N6emNAAo/ovECiezPMU4W0myDnrnd9AS3Vql9YozBisfg
	 xKbMh2nTMAR1A3qwR9IwrSsNzyC2VcKBB5bvbD7HOp8ieBIdOK5aeFN37gKGKzV0m/
	 B9n54LLIsnmFH31+S2i2hxcCkF9DBiOQ8a7tFxmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yue Haibing <yuehaibing@huawei.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 417/484] netfilter: nf_tables: Remove unused nft_reduce_is_readonly()
Date: Thu, 30 Jul 2026 16:15:14 +0200
Message-ID: <20260730141432.536305727@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1851,11 +1851,6 @@ static inline u64 nft_net_tstamp(const s
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



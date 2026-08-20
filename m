Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 494D835DA68;
	Thu, 20 Aug 2026 17:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248121; cv=none; b=nM0ztpoDOS+ecppi5hNAxmqjeyrw8/S/y5ZPnOv/WrY9Aov2FWeIp1B8MihgR3JCVlP27cEucSDOZDr26vOPGFW1BLPJfC+bbqUGfXu9qO1AW9bSMIxifwf2A9OazR1pTkbd4teUf78aOc3QY6ECXorNyShNSdZnwL3LdHPocrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248121; c=relaxed/simple;
	bh=bZrVYoG3hxZwE8+7QWSSaGvC2lt/yQu/HfnOSogvPJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pONWLQqYUdd3MLhXUCTew1Lo1/QoChh+2BG5mMuh81L8zkFTfcEfGPSZERjto8LE98HEQ4JVP7gN9ktVF76QlkvLVSFyoBmIXf6ASWnsnRuazWhEprTD+vxVLQ//ULxshysipzmA04AlYzKdQDd/5IFp1t6EnuaVYOqTu5tvd38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=StA5mlzo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="StA5mlzo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A54241F000E9;
	Thu, 20 Aug 2026 17:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248120;
	bh=k/fhq1MnPNfh+hvrYYBS7NRcapBCEnWCSagzv7e0iV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=StA5mlzoANgavSnvYLC8jlBsSwHPglCzJaSXtxhQAdvNViGFcmku24qqKk15rk//B
	 cl1Eu4d2/ffv12gT9Tw3I9ycVbqCY4WmPZ3IZRpj6DPbhjMYXKB5wFt/fMUYUBSLTh
	 F3+US5KpDgdQyWnxE1P7kvT9ii6MxX0Y2XcEeMSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yue Haibing <yuehaibing@huawei.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 118/303] netfilter: nf_tables: Remove unused nft_reduce_is_readonly()
Date: Thu, 20 Aug 2026 16:54:14 +0200
Message-ID: <20260820145256.826842904@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1773,11 +1773,6 @@ static inline u64 nft_net_tstamp(const s
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



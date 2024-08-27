Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B8701C5783;
	Tue, 27 Aug 2024 14:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769881; cv=none; b=JAyttDRgMJT2UMvm2O6sBRNB0BR3jTHY/h+1oWFnvqBiYw9lZsn46vQfq/O3UjZATuOOBNdOvlvbrK3LRXD5bFjyRg98wtVqX0y/3nhGLEhDg+C82gATQ2gQrPyS2KT9DhrrYN8ohHnHA/k7vq3mFOT4ZLN4i9e2aZS5qFqCLKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769881; c=relaxed/simple;
	bh=7q5nFvXJPbUGyVFbzLHMHpMGus7nP4qYLWTDcyIgRgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TAMOWi6w6betpuBM6+GMvH2OxKGr614BU6Z2e+bw7ZzfvG/Lbc7qowLsyIIuElsTBSbgJxJDm1ftmhDZBMY+DyTyN0vWZpnpQbjq0x+1MOnI3s+TcaSTOFD919E+pe4WUmqh7nsIQUAJRI8tWED70MA7khhHsqqRfJXDkxCY2bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XQkcgL4D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XQkcgL4D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4538C6105D;
	Tue, 27 Aug 2024 14:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724769881;
	bh=7q5nFvXJPbUGyVFbzLHMHpMGus7nP4qYLWTDcyIgRgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XQkcgL4D92Z9Kw88fEczcODpvmRQ/y+06CO+nezfOYRra7ytnn59L14sbNuYfWjwi
	 RSFwdsF23YS0RRM4uQoExvR6StS1Yn6+74egVCnaglVyzk9sNV8cShRhhPbffMUfr0
	 BMLKPf7u+8QcpUWVc8SSJS2iZM1oBGFgjB55apdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donald Hunter <donald.hunter@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 064/341] netfilter: flowtable: initialise extack before use
Date: Tue, 27 Aug 2024 16:34:55 +0200
Message-ID: <20240827143845.849630286@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

From: Donald Hunter <donald.hunter@gmail.com>

[ Upstream commit e9767137308daf906496613fd879808a07f006a2 ]

Fix missing initialisation of extack in flow offload.

Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_flow_table_offload.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index a010b25076ca0..3d46372b538e5 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -841,8 +841,8 @@ static int nf_flow_offload_tuple(struct nf_flowtable *flowtable,
 				 struct list_head *block_cb_list)
 {
 	struct flow_cls_offload cls_flow = {};
+	struct netlink_ext_ack extack = {};
 	struct flow_block_cb *block_cb;
-	struct netlink_ext_ack extack;
 	__be16 proto = ETH_P_ALL;
 	int err, i = 0;
 
-- 
2.43.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 842491EB5B;
	Sun,  1 Sep 2024 17:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210039; cv=none; b=PCgrAOcwMvRJ9u81nqb38LRP6UdCNe7P7zIiJOa+JIHuZ+2P5ClonwrOJiTjIklB5h1a1p52yOEI7znSeC1krYUQRbrAVShHb2xF6X3ytGFXIDZhGL+WZD/9jK9sV6xVLU/b9IX8Xvb67XWY1Rg9ap2CHfelBpgjHa/mmtF5jyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210039; c=relaxed/simple;
	bh=66fagODpiNL59eEycdHbyAzinQ0G+P/UqamjwLvPKF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IwPB8bMR3INmHIp/FRypCIrmwXO3mUO1lSN7rcTr74RHggSRVyR4FdKDxANvRLUX8QdfdHFN1fwQAjVKKaVdoLNnlqADBS3PJPxdlLeJYfZTRU0b6ezZyTRFzFvQyR+XhdoUR7TzIaSvG3NNLy3f0bV4+Hz7ncNEsoXl2rjoVtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sx+RIvAe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sx+RIvAe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CAF8C4CEC3;
	Sun,  1 Sep 2024 17:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210039;
	bh=66fagODpiNL59eEycdHbyAzinQ0G+P/UqamjwLvPKF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sx+RIvAeEwlTL76axsqvnNF5wATmj/1ZAijCTwLFAc/eAixATkRruHnvXzvoSTVUn
	 COBAbseYd5U2JTFfuvaRlo7sZLkKa0IwAr0OBiZPtMoVQLx7BFw9966hLsH/DM44mE
	 +ARU1dT1iM56+kJi1TzovriItA3ta1bDW2vfV7W4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donald Hunter <donald.hunter@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 038/215] netfilter: flowtable: initialise extack before use
Date: Sun,  1 Sep 2024 18:15:50 +0200
Message-ID: <20240901160824.784860087@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6ac1ebe17456d..d8cb304f809e5 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -830,8 +830,8 @@ static int nf_flow_offload_tuple(struct nf_flowtable *flowtable,
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




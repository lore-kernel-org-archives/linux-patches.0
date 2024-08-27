Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E76BE19EEA2;
	Tue, 27 Aug 2024 14:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769892; cv=none; b=Qkhre6ellH/xTP+nlkuK9BINE9Cga5SFoHIATtL0fQpAy1/j8gJ+it4OISbfriAsRLHtcZA44fNz6YN63Dzhx3KwerWEtGK89Kqqh2WZh6jxhJDGIAbGSiH1lYYWAHNKqZCiYxA2fKplV/VlcUQc61KrJNFMeMgQp7k2gKhW/1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769892; c=relaxed/simple;
	bh=WgYq6tdz4UZuhx+Z1g6lqesD2YvecLOKdCLpUMC+IVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oWJntNIYKUQrVPsdMbpdDwyjK8eeDCoOz3juXdfODrfk1LjUU/JllxQD4qNG1b9NhzJpe2B0qeQkkE7dTMqkrJcIJ/TsX3Tkw4McOzJKoeeDHeLOe0X6P8vBZhrGVJHnmgmPPdwncQsv6W9E2L0w5FXRzaCOXg/bOBvRGyioaUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m7maV15n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m7maV15n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56D08C61068;
	Tue, 27 Aug 2024 14:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724769891;
	bh=WgYq6tdz4UZuhx+Z1g6lqesD2YvecLOKdCLpUMC+IVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m7maV15nL6T+eGFC0QzUItvlWLM6mDDbOfmRwCRkdJ1UwDyxIsoMFI+cbpSr8juD7
	 HaMJXi7pqcY952PaLCfo+Z6nKiGv0duq8gDswbIBMCen1ty5VR2Vn2cEZNfZkOX7T5
	 qWZhz+w+CybZSMyi2aeEmpU0IHNNiJt0nGaLQ+Qk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 067/341] netfilter: nf_tables: Drop pointless memset in nf_tables_dump_obj
Date: Tue, 27 Aug 2024 16:34:58 +0200
Message-ID: <20240827143845.963823758@linuxfoundation.org>
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

From: Phil Sutter <phil@nwl.cc>

[ Upstream commit ff16111cc10c82ee065ffbd9fa8d6210394ff8c6 ]

The code does not make use of cb->args fields past the first one, no
need to zero them.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: bd662c4218f9 ("netfilter: nf_tables: Add locking for NFT_MSG_GETOBJ_RESET requests")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c6296ffd9b91b..d29c5803c3ff0 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7753,9 +7753,6 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 				goto cont;
 			if (idx < s_idx)
 				goto cont;
-			if (idx > s_idx)
-				memset(&cb->args[1], 0,
-				       sizeof(cb->args) - sizeof(cb->args[0]));
 			if (filter && filter->table &&
 			    strcmp(filter->table, table->name))
 				goto cont;
-- 
2.43.0




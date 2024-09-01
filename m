Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6129F183092;
	Sun,  1 Sep 2024 16:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209433; cv=none; b=Teosah1vFXALS8bvFoEHjn+Hpj68kBd14BxHi5V/6QpwEJ/4zh31rM2hJY5JkM5I3TqHBy4sHfnqzKv6z+haXN8f3CBh9mllyFYyhNVf9R6HpYGLUNzPGW1V4sfRyCsWc9uDNhmEsfiN68lMUJBRiCtRvwYSS4AW2Q+1lR2GnHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209433; c=relaxed/simple;
	bh=I2Z10wmpbl1i225CmYxXqO9mw8WtBwbK0Apushs6ynM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O3rJ5rKMOE3sIUoMFhEQAHfoRKtDdX8o8OSr9cJKLJ+IHqt5luDqVqORxLOb7Rxbo+m1Ir72uc2a1rkLz7WTuc881l1D6RHVs86XwU7jVt7XHKmPhGCIDtztqUWh9sp2VYeC5FlmVHW7OtFxQeNf9tTOBnpnMxNymvGwqPvFXSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H9RBz7g4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H9RBz7g4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC665C4CEC3;
	Sun,  1 Sep 2024 16:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209433;
	bh=I2Z10wmpbl1i225CmYxXqO9mw8WtBwbK0Apushs6ynM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H9RBz7g4oABc5CmGCGoh6wt63nBWFL1i2nZUAwQeKTYz/TqdQM+pL90paqsklq/td
	 AUeW+rlTWGuYwITmlWsGtbuS1hng6qLRZX0y4WInrtM5dzvw0hce/vhQBxv3FzoFU+
	 5K54vs79z1bjrGZCObF/2XpiFCrCa1W/WYFNCdJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donald Hunter <donald.hunter@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 027/151] netfilter: flowtable: initialise extack before use
Date: Sun,  1 Sep 2024 18:16:27 +0200
Message-ID: <20240901160815.118353020@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 746ca77d0aad6..f6275d93f8a51 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -682,8 +682,8 @@ static int nf_flow_offload_tuple(struct nf_flowtable *flowtable,
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




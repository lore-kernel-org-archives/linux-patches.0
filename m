Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214788;
	b=hg3QERnv7nGsafo9vVfVzPFcQiOXrIm4qx6TKofbuKHGJFnVJ0L3pwE3hh8660W/CPO2
	 C7YHverewUElvf/nla0ifmrdr14yBRPrAm2r4LvyuJIx7Mb2gjKsBTmHWiw1jyulFszH7
	 w28VgJv9Gw4pgYhuEijtm4D+xaPTr7Si3qetemR8/Tvwr9tEFoX4S3u5Z/fBIBKF4S2Lf
	 Z0iWfRklq73Y8BMRes/XCoeO3vC3kpGm7jNuqd0M9A8HYLh2+DfZYyXR+KIAlHzpZMx6O
	 fMgro1RQza70FjOoaMSfTAmHd2M3cshNRYYtoGM899q8+QAnUyqLhlA20hpqjDJHtTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214788;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IoSUEMXqhd2/0y+Z0blyqUe+vGH3WhEoBQNb+9rM3cc=;
	b=ns6SnOLblsZW0ktwCrW+F2fUc9zX9Me5r20IlywHhMqSW0f6zqePrJu2wt4KNaUed+VI
	 VnUDAcC3P7Xk8MYcr9YdSKUhBRuQIH9WkWG0D+Sz+oE14kPfGNI2qosETjKNhpOlLf1qI
	 VvO5ouoJFL6jWf8QX7SkGKb4tX+sHIzSrTVhN1+JY+4M5doQIu5Y0aJwi+LQlHQMLESc6
	 Z/68b9vVy0UTlhzwVbMneM+ESI7BH299XpuqCrjSW6/UuMuqrWzlVB6+LYvX889+D2i2a
	 2sTpnpi8uYQ4J6DUsM5XG66D5xafuQhFGW8gzpWCNIaz8KsO/vQmeSanRz27gh48ZGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RNMR+amP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB987606B7E1;
	Wed, 28 Oct 2026 19:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RNMR+amP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4666E1F01825;
	Wed, 28 Oct 2026 19:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214787;
	bh=IoSUEMXqhd2/0y+Z0blyqUe+vGH3WhEoBQNb+9rM3cc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RNMR+amPhNCDwoFQvCOLX/VIWbB+2tL2CRTf0uAnsBEct8YA7ZFGK/zogn4pBCgkI
	 pMDOwKaPPA9jMgj7YH/JGDDWSK7eJaFiTP6Jt/gq5M2d1Td994JDsx2R/vMh11mveP
	 1roKN3DNYm6CfKC6ib7yxVsKE8+RINCxjY5Fy3z4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0981/1887] xfrm: Wait for RCU readers during policy netns exit
Date: Wed, 28 Oct 2026 17:51:17 +0100
Message-ID: <20261028170521.734217649@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steffen Klassert <steffen.klassert@secunet.com>

[ Upstream commit 069daad4f2ae9c5c108131995529d5f02392c446 ]

xfrm_policy_fini() frees the policy_bydst hash tables after flushing the
policy work items and deleting all policies, but it does not wait for
concurrent RCU readers to leave their read-side critical sections first.

The policy_bydst tables are published via rcu_assign_pointer() and are
looked up through rcu_dereference_check(), so netns teardown must also
wait for an RCU grace period before freeing the table memory.

Fix this by adding synchronize_rcu() before freeing the policy hash tables.

Fixes: e1e551bc5630 ("xfrm: policy: prepare policy_bydst hash for rcu lookups")
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_policy.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 76b7b94132c00..7ababb73d08e3 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -4142,6 +4142,8 @@ static void xfrm_policy_fini(struct net *net)
 #endif
 	xfrm_policy_flush(net, XFRM_POLICY_TYPE_MAIN, false);
 
+	synchronize_rcu();
+
 	WARN_ON(!list_empty(&net->xfrm.policy_all));
 
 	for (dir = 0; dir < XFRM_POLICY_MAX; dir++) {
-- 
2.53.0




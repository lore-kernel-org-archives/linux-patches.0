Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12781B81D2;
	Thu, 29 Aug 2024 18:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724955302; cv=none; b=N0Fub5acp+efaOQRAB21IuFtYLpIATBMWDPkNS2FPrzNa5X8kSiQMvbQ2jAQoIhfYSI2Rr6FqIgEa9eUnNo1FaqLZcbkeiHen4OzYbnh7i98o7+fCNyqnvnzdF696WZLbn1FWUJfEwSHIiJ5RzqNO7hgjP3ej3V6u1IzCUsyzHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724955302; c=relaxed/simple;
	bh=68pjJN/T0s4pW9PljETJv3LnYCfdZMsgv4u+jY3JAdg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=uwQFVWQxAJtBUB5wuilO/Gqhz9RF0/um4D6JXU/uIyOfPbf/Te6O4ab+EqfzSFa73QMfIBqArD5H9MonGpImVLziaBQNnm/H91VopkoGF2jTgjN+gv2laA2q4Z5IXMCNUNPQJwLR+P6Jftzc/vk6jpNOvSdyfvOOmAWw02IFWeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cu7LbsvN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cu7LbsvN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E35ECC4CEC1;
	Thu, 29 Aug 2024 18:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724955301;
	bh=68pjJN/T0s4pW9PljETJv3LnYCfdZMsgv4u+jY3JAdg=;
	h=From:Date:Subject:To:Cc:From;
	b=Cu7LbsvNjAZ86rPytatnX8nYGVP3n6pMecH2okCGZfYDGY2MKMH98ctmOqmy3zVgl
	 qgZNCMgw3zBDYJglGk56ZAKcu5YSmJoBbiwuv1EdzgtWBcMiBbAox0radj6Df4IhWm
	 9bC8YegzzXi04GNknISxgpiI14A0yWU3kghnbZVXmq+0hJAtx4Vd4OL9iszkqC+FUB
	 edH61e1adfRNIp0XJTbVcExh/CCQscKUO7sP9fpLVFjHjAntekXU81dRPxZpmHMkHf
	 QtpeF3iYd824/5kyhdGt0IMxe5nwvjqbl4+gR9EkCcHc7XEKIjzLmhmyXODfkc7tyZ
	 Loks/GklY4stA==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 29 Aug 2024 11:14:54 -0700
Subject: [PATCH ipsec-next v2] xfrm: policy: Restore dir assignments in
 xfrm_hash_rebuild()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240829-xfrm-restore-dir-assign-xfrm_hash_rebuild-v2-1-1cf8958f6e8e@kernel.org>
X-B4-Tracking: v=1; b=H4sIAJ260GYC/52OWwqDMBBFtyLz3SlJ8Nmv7qOIRB11qI0ysWIR9
 16bJfTzPrjn7uBJmDzcoh2EVvY8uVOYSwTNYF1PyO2pwSgTq9wUuHXyQiG/TELYsqD1nnsX/Gq
 wfqiE6jePLWZx0Vhj0jjJNZx7s1DHW2A9gGdPDTraFijPbODf4CfcWHVo/EFcNWq0Rqk8TeIiq
 /X9SeJovE7SQ3kcxxdkDi3W7wAAAA==
To: Steffen Klassert <steffen.klassert@secunet.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.14.1
X-Developer-Signature: v=1; a=openpgp-sha256; l=2489; i=nathan@kernel.org;
 h=from:subject:message-id; bh=68pjJN/T0s4pW9PljETJv3LnYCfdZMsgv4u+jY3JAdg=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDGkXdi3ZyrnuT7B26DeJ5YoRnRsn7Ktc6eDio6V14dyN8
 19v2fSmdZSyMIhxMciKKbJUP1Y9bmg45yzjjVOTYOawMoEMYeDiFICJiOoyMnzav0Zrcfr+ZRu/
 bd7b3J5ufm7a2tJftQde+rM/WPDBP/Upw3+PCO7FE36snXeQ+7mE+3PbWefFdn19Yv1N8c7PV7z
 fzJdxAQA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Clang warns (or errors with CONFIG_WERROR):

  net/xfrm/xfrm_policy.c:1286:8: error: variable 'dir' is uninitialized when used here [-Werror,-Wuninitialized]
   1286 |                 if ((dir & XFRM_POLICY_MASK) == XFRM_POLICY_OUT) {
        |                      ^~~
  net/xfrm/xfrm_policy.c:1257:9: note: initialize the variable 'dir' to silence this warning
   1257 |         int dir;
        |                ^
        |                 = 0
  1 error generated.

A recent refactoring removed some assignments to dir because
xfrm_policy_is_dead_or_sk() has a dir assignment in it. However, dir is
used elsewhere in xfrm_hash_rebuild(), including within loops where it
needs to be reloaded for each policy. Restore the assignments before the
first use of dir to fix the warning and ensure dir is properly
initialized throughout the function.

Fixes: 08c2182cf0b4 ("xfrm: policy: use recently added helper in more places")
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
Changes in v2:
- Restore another dir assignment in
    list_for_each_entry_reverse(policy, ...
  loop, necessitating a value reload to avoid a stale value (thanks to
  Florian for the review).
- Reword commit message slightly based on above change.
- Pick up Florian's ack.
- Add 'ipsec-next' subject prefix.
- Link to v1: https://lore.kernel.org/r/20240829-xfrm-restore-dir-assign-xfrm_hash_rebuild-v1-1-a200865497b1@kernel.org
---
 net/xfrm/xfrm_policy.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 6336baa8a93c..63890c0628c4 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -1283,6 +1283,7 @@ static void xfrm_hash_rebuild(struct work_struct *work)
 		if (xfrm_policy_is_dead_or_sk(policy))
 			continue;
 
+		dir = xfrm_policy_id2dir(policy->index);
 		if ((dir & XFRM_POLICY_MASK) == XFRM_POLICY_OUT) {
 			if (policy->family == AF_INET) {
 				dbits = rbits4;
@@ -1337,6 +1338,7 @@ static void xfrm_hash_rebuild(struct work_struct *work)
 		hlist_del_rcu(&policy->bydst);
 
 		newpos = NULL;
+		dir = xfrm_policy_id2dir(policy->index);
 		chain = policy_hash_bysel(net, &policy->selector,
 					  policy->family, dir);
 

---
base-commit: 17163f23678c7599e40758d7b96f68e3f3f2ea15
change-id: 20240829-xfrm-restore-dir-assign-xfrm_hash_rebuild-749ca2264581

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>


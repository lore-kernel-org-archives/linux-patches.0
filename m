Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208186;
	b=kGr088+Yz58zSlsFQJ7dBqP/zLAHGMWjpBxaYhvMLGaKJQZr084q1TOxfB1XDnXpAzBO
	 ISTWQMfTNENxSVYRL+udiaV38lDHSye58Qb34VjYlZLMzPKfhsWlrG498/DAtRuNWW7xV
	 qE/j5g3/BeOQxFqDGtPG8bTqT/dSJaoFLfC+5xVih+ztqZrM5oLln+W9qljmd9Y6o7uOJ
	 WoMvBmg8v/f2f8xRh0urDscSw5kK5jciKtqjQX+7NBSdM27GHal/HBWfVQ2VeqbO9g5iG
	 lpzlpqe34wMFqgKoI1xADCmizK++K+e/h4y7usUkuswfkdlMKeLSwPMF3msvErnhcLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208186;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zsdxyGCzGrls6+w+u7qteWwGuGqpw1kxn7CTju1AE44=;
	b=Iplf8UU416GFeWYZ/064oO8rh7wqcBju7Somvx2VZYgou13AD2X860CX2PaCCwm5nA19
	 cEcaIVQD0QFAePgUfLRzeKFaDLYzvHBOLtVg6HjGEIFWAOKFqA7r8e+WYrWL2XSc7dHCy
	 qYmaezgyn1yun7KLZdQ0Vk29JQ+w5rXvim4nySQzIpjPSt99KsFboarQwjfF4zdQLIrxh
	 YGVZh8zsdXr368tGE5xormvuGl2I6HueR0YeaIz03qMOFfJ/mfUfdg6N4A2Edr9mO1Zc2
	 iuMVLt8ye6uy1yUsfpBYpVtmU2H+/y6sfTq4cFOvCUhsOBrt/ycV8tqscWoGfULHQ3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="U/ab4Yq6";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FBAA606A31A;
	Wed, 28 Oct 2026 17:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U/ab4Yq6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF4D01F01828;
	Wed, 28 Oct 2026 17:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208186;
	bh=zsdxyGCzGrls6+w+u7qteWwGuGqpw1kxn7CTju1AE44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U/ab4Yq6lRzOz4zTV45KpBp2wFGXEukJq8jcpl5QsMhgVc8x99MxcNrqCH5jVSWww
	 fDvIw9k1Lz73uNy7L9FHmP6uB+YogbJR9SEdiMutK3uG0RCJ04ju6PBLSUSR1k66ut
	 AOFu3NC7Hpi9yfSuuBvFqDyvymSyJgh2E1fV3qQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	XingWang Xiang <v3rdant.xiang@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 031/516] genetlink: pin family module during policy dump
Date: Wed, 28 Oct 2026 17:53:03 +0100
Message-ID: <20261028170004.267124202@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: XingWang Xiang <v3rdant.xiang@gmail.com>

[ Upstream commit 6a1094c34d176827b2b173e163dcc964a13af93f ]

The generic netlink controller's policy dump keeps pointers to the target
family's operation and policy tables in its callback state.  A dump may be
split across multiple skbs and remain pending after the initial request.

Netlink pins the module which owns the dump callback, but in this case
that is the controller's owner rather than the target family's owner.  The
target family can consequently be unregistered and its module unloaded
while a policy dump is pending.  Advancing the dump then dereferences
policy memory from the unloaded module.

Take a reference to the target family's module when the dump starts.
Drop it from the error and done paths.  This matches the lifetime for which
the dump context retains the family and policy pointers.

Fixes: d07dcf9aadd6 ("netlink: add infrastructure to expose policies to userspace")
Cc: stable@vger.kernel.org
Signed-off-by: XingWang Xiang <v3rdant.xiang@gmail.com>
Link: https://patch.msgid.link/20260902084317.4092542-1-v3rdant.xiang@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ adapted split-operation iterator handling to the older genl_ops and opidx interfaces. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netlink/genetlink.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index e085ceec96a4c..e5c4f1d8f0fba 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -1109,6 +1109,7 @@ static int genl_ctrl_event(int event, const struct genl_family *family,
 struct ctrl_dump_policy_ctx {
 	struct netlink_policy_dump_state *state;
 	const struct genl_family *rt;
+	struct module *owner;
 	unsigned int opidx;
 	u32 op;
 	u16 fam_id;
@@ -1152,6 +1153,9 @@ static int ctrl_dumppolicy_start(struct netlink_callback *cb)
 		return -ENOENT;
 
 	ctx->rt = rt;
+	ctx->owner = rt->module;
+	if (!try_module_get(ctx->owner))
+		return -ENOENT;
 
 	if (tb[CTRL_ATTR_OP]) {
 		ctx->single_op = true;
@@ -1160,14 +1164,19 @@ static int ctrl_dumppolicy_start(struct netlink_callback *cb)
 		err = genl_get_cmd(ctx->op, rt, &op);
 		if (err) {
 			NL_SET_BAD_ATTR(cb->extack, tb[CTRL_ATTR_OP]);
-			return err;
+			goto err_put_owner;
 		}
 
-		if (!op.policy)
-			return -ENODATA;
+		if (!op.policy) {
+			err = -ENODATA;
+			goto err_put_owner;
+		}
 
-		return netlink_policy_dump_add_policy(&ctx->state, op.policy,
-						      op.maxattr);
+		err = netlink_policy_dump_add_policy(&ctx->state, op.policy,
+						     op.maxattr);
+		if (err)
+			goto err_free_state;
+		return 0;
 	}
 
 	for (i = 0; i < genl_get_cmd_cnt(rt); i++) {
@@ -1182,12 +1191,16 @@ static int ctrl_dumppolicy_start(struct netlink_callback *cb)
 		}
 	}
 
-	if (!ctx->state)
-		return -ENODATA;
+	if (!ctx->state) {
+		err = -ENODATA;
+		goto err_put_owner;
+	}
 	return 0;
 
 err_free_state:
 	netlink_policy_dump_free(ctx->state);
+err_put_owner:
+	module_put(ctx->owner);
 	return err;
 }
 
@@ -1322,6 +1335,7 @@ static int ctrl_dumppolicy_done(struct netlink_callback *cb)
 	struct ctrl_dump_policy_ctx *ctx = (void *)cb->ctx;
 
 	netlink_policy_dump_free(ctx->state);
+	module_put(ctx->owner);
 	return 0;
 }
 
-- 
2.53.0




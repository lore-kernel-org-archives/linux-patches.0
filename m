Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210452;
	b=ZJLn9f1qQSt2c5p7wS+qiX1K2AS6ZEf8fEcx3DpZQA57GtZ881HHrx8pQimRth+jkXk+
	 DccSqb7KPa4uhchzEY0HsrL/SyItesRvyq02OvTJPTPeKrAT7IPWkS8ge6T7oqxtHNlUG
	 eHPYiefbTcwIekAXFv3xuAQoifeYa7+v2ysZ3YA3Bt6hbKIlIrfFH2A5HsWtzkhGhPXMo
	 hdGTlkvqmWBGPwQhNh7qlkC9u5iZJoHCX1+Yk6Yv3Qh6DnuEFAoxgZR3+ZA6fcKjKLipI
	 1IfrGPTj4EUWFj+RC7RRArs0+H9BtgJLbkqGmwijW0t883liSYcke18A57ihAobZreg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210452;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pWzXYWx1tKUXYaIVFpQS0ECvUe/IoEWouoQ0SxTUIKw=;
	b=qioCIye++w5uP+25Qq9EyvqJpRdA+uusC/oRIz2aQpWB6vXZfH4+MXDmC6UwxfcvGoc2
	 vLdyydn9aKB9ZFg5eHjSXZcgYXuhth81X4b5h2c7hirMQBzVAe7qWH2CEXnFxvnxWCYId
	 v3D3pR0CjAqLKEUqFcveD5RSemhuG/7LT2tTkmVzFzvJHXJf+rr4fFxFPHzvUhtn+dNG7
	 9oXfFiLoMvKogpSqmIAMzCz8MkD9zRSW+dgogoiQ+LSU0XJ8Z3FskU0TwWzoYlhP8GRV3
	 JCMtYs993KoR2hm8SrUxQiNplZ30B7g14QZJ+EwHqmnuZAVTPLz/0+/OEvs7PPviwLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lJXrgLK3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 430FE606A31A;
	Wed, 28 Oct 2026 18:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lJXrgLK3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FDA51F01825;
	Wed, 28 Oct 2026 18:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210452;
	bh=pWzXYWx1tKUXYaIVFpQS0ECvUe/IoEWouoQ0SxTUIKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lJXrgLK3h5H8gUmHPvaIh58D+lLzVFNOJN3/267vmapyZ4QgyLbBbiugHVrMb10+l
	 tUUGycKBVPYes/5MmGmofcJcHf32pKHCYVc+0gj39rPa53DTXp1WnsUGnUvS22eCJx
	 wJ+acRaLgh6UHefjGR54wZOmodjK10+sHKd/RHoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	XingWang Xiang <v3rdant.xiang@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 030/571] genetlink: pin family module during policy dump
Date: Wed, 28 Oct 2026 17:52:57 +0100
Message-ID: <20261028170008.737531799@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 7a568292e0d10..c0d6950e21651 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -1101,6 +1101,7 @@ static int genl_ctrl_event(int event, const struct genl_family *family,
 struct ctrl_dump_policy_ctx {
 	struct netlink_policy_dump_state *state;
 	const struct genl_family *rt;
+	struct module *owner;
 	unsigned int opidx;
 	u32 op;
 	u16 fam_id;
@@ -1144,6 +1145,9 @@ static int ctrl_dumppolicy_start(struct netlink_callback *cb)
 		return -ENOENT;
 
 	ctx->rt = rt;
+	ctx->owner = rt->module;
+	if (!try_module_get(ctx->owner))
+		return -ENOENT;
 
 	if (tb[CTRL_ATTR_OP]) {
 		ctx->single_op = true;
@@ -1152,14 +1156,19 @@ static int ctrl_dumppolicy_start(struct netlink_callback *cb)
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
@@ -1174,12 +1183,16 @@ static int ctrl_dumppolicy_start(struct netlink_callback *cb)
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
 
@@ -1314,6 +1327,7 @@ static int ctrl_dumppolicy_done(struct netlink_callback *cb)
 	struct ctrl_dump_policy_ctx *ctx = (void *)cb->ctx;
 
 	netlink_policy_dump_free(ctx->state);
+	module_put(ctx->owner);
 	return 0;
 }
 
-- 
2.53.0




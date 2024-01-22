Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 074707F1;
	Tue, 23 Jan 2024 00:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968198; cv=none; b=spMm0fDCpKE8rGULP4Or+fp+ETLTh59VjiSYWikxcO9N13+SY4ZKR5LBVFIvVs8+vrIzmu71gbGBGMdxr7S4A5h+Wt2m7bI8IEAin1SW+eVv1PAQ26o2F6hz7Bc43MblrfIWm5dS57DMCqHKWG4bfb+ZikYQBhWag9HCOT2rOgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968198; c=relaxed/simple;
	bh=J3DewA7JJXawoVZi3nWlRFAaQHn4MRXbx4AS7RB4W/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GPhD/KyFEdcBT26nDIwJOgUWJV3q7RTd2PfjMOYFMEuxnNvMost4fTcgnyYgs3l52kIe01jqR/MZv7MGTpeVuCaYcDdNjyRsa314dc9/yrGLvPUOrDPWMgZXWSltoGCi8Pip82OcDGSRp9P7QpMu+GEAPD53rKBHI9g/bQPPMH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GR/8HbVV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GR/8HbVV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36BA5C433C7;
	Tue, 23 Jan 2024 00:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968197;
	bh=J3DewA7JJXawoVZi3nWlRFAaQHn4MRXbx4AS7RB4W/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GR/8HbVV4bKt6dkfXtc9cpbjZABH5PJgQHshzO+8gZUD3rWIz0zRkrxmtL9vVL9Xy
	 wGnvJ8e/92NqzK49f8nIaFXfzOHitkSYe2dIa6FlsXKyc6ha5CX/k6qf+h1PDKxOHA
	 Ta8P96cWIK06X5kci1eq12hcggmUpEdl/wzgYj80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Yejian <zhengyejian1@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 041/148] netlabel: remove unused parameter in netlbl_netlink_auditinfo()
Date: Mon, 22 Jan 2024 15:56:37 -0800
Message-ID: <20240122235714.070459514@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zheng Yejian <zhengyejian1@huawei.com>

[ Upstream commit f7e0318a314f9271b0f0cdd4bfdc691976976d8c ]

loginuid/sessionid/secid have been read from 'current' instead of struct
netlink_skb_parms, the parameter 'skb' seems no longer needed.

Fixes: c53fa1ed92cd ("netlink: kill loginuid/sessionid/sid members from struct netlink_skb_parms")
Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: ec4e9d630a64 ("calipso: fix memory leak in netlbl_calipso_add_pass()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netlabel/netlabel_calipso.c   |  4 ++--
 net/netlabel/netlabel_cipso_v4.c  |  4 ++--
 net/netlabel/netlabel_mgmt.c      |  8 ++++----
 net/netlabel/netlabel_unlabeled.c | 10 +++++-----
 net/netlabel/netlabel_user.h      |  4 +---
 5 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/net/netlabel/netlabel_calipso.c b/net/netlabel/netlabel_calipso.c
index 5ae9b0f18a7e..5363e07dbf65 100644
--- a/net/netlabel/netlabel_calipso.c
+++ b/net/netlabel/netlabel_calipso.c
@@ -119,7 +119,7 @@ static int netlbl_calipso_add(struct sk_buff *skb, struct genl_info *info)
 	    !info->attrs[NLBL_CALIPSO_A_MTYPE])
 		return -EINVAL;
 
-	netlbl_netlink_auditinfo(skb, &audit_info);
+	netlbl_netlink_auditinfo(&audit_info);
 	switch (nla_get_u32(info->attrs[NLBL_CALIPSO_A_MTYPE])) {
 	case CALIPSO_MAP_PASS:
 		ret_val = netlbl_calipso_add_pass(info, &audit_info);
@@ -301,7 +301,7 @@ static int netlbl_calipso_remove(struct sk_buff *skb, struct genl_info *info)
 	if (!info->attrs[NLBL_CALIPSO_A_DOI])
 		return -EINVAL;
 
-	netlbl_netlink_auditinfo(skb, &audit_info);
+	netlbl_netlink_auditinfo(&audit_info);
 	cb_arg.doi = nla_get_u32(info->attrs[NLBL_CALIPSO_A_DOI]);
 	cb_arg.audit_info = &audit_info;
 	ret_val = netlbl_domhsh_walk(&skip_bkt, &skip_chain,
diff --git a/net/netlabel/netlabel_cipso_v4.c b/net/netlabel/netlabel_cipso_v4.c
index e252f62bb8c2..a0a145db3fc7 100644
--- a/net/netlabel/netlabel_cipso_v4.c
+++ b/net/netlabel/netlabel_cipso_v4.c
@@ -420,7 +420,7 @@ static int netlbl_cipsov4_add(struct sk_buff *skb, struct genl_info *info)
 	    !info->attrs[NLBL_CIPSOV4_A_MTYPE])
 		return -EINVAL;
 
-	netlbl_netlink_auditinfo(skb, &audit_info);
+	netlbl_netlink_auditinfo(&audit_info);
 	switch (nla_get_u32(info->attrs[NLBL_CIPSOV4_A_MTYPE])) {
 	case CIPSO_V4_MAP_TRANS:
 		ret_val = netlbl_cipsov4_add_std(info, &audit_info);
@@ -715,7 +715,7 @@ static int netlbl_cipsov4_remove(struct sk_buff *skb, struct genl_info *info)
 	if (!info->attrs[NLBL_CIPSOV4_A_DOI])
 		return -EINVAL;
 
-	netlbl_netlink_auditinfo(skb, &audit_info);
+	netlbl_netlink_auditinfo(&audit_info);
 	cb_arg.doi = nla_get_u32(info->attrs[NLBL_CIPSOV4_A_DOI]);
 	cb_arg.audit_info = &audit_info;
 	ret_val = netlbl_domhsh_walk(&skip_bkt, &skip_chain,
diff --git a/net/netlabel/netlabel_mgmt.c b/net/netlabel/netlabel_mgmt.c
index 71ba69cb50c9..43c51242dcd2 100644
--- a/net/netlabel/netlabel_mgmt.c
+++ b/net/netlabel/netlabel_mgmt.c
@@ -447,7 +447,7 @@ static int netlbl_mgmt_add(struct sk_buff *skb, struct genl_info *info)
 	     (info->attrs[NLBL_MGMT_A_IPV6MASK] != NULL)))
 		return -EINVAL;
 
-	netlbl_netlink_auditinfo(skb, &audit_info);
+	netlbl_netlink_auditinfo(&audit_info);
 
 	return netlbl_mgmt_add_common(info, &audit_info);
 }
@@ -470,7 +470,7 @@ static int netlbl_mgmt_remove(struct sk_buff *skb, struct genl_info *info)
 	if (!info->attrs[NLBL_MGMT_A_DOMAIN])
 		return -EINVAL;
 
-	netlbl_netlink_auditinfo(skb, &audit_info);
+	netlbl_netlink_auditinfo(&audit_info);
 
 	domain = nla_data(info->attrs[NLBL_MGMT_A_DOMAIN]);
 	return netlbl_domhsh_remove(domain, AF_UNSPEC, &audit_info);
@@ -570,7 +570,7 @@ static int netlbl_mgmt_adddef(struct sk_buff *skb, struct genl_info *info)
 	     (info->attrs[NLBL_MGMT_A_IPV6MASK] != NULL)))
 		return -EINVAL;
 
-	netlbl_netlink_auditinfo(skb, &audit_info);
+	netlbl_netlink_auditinfo(&audit_info);
 
 	return netlbl_mgmt_add_common(info, &audit_info);
 }
@@ -589,7 +589,7 @@ static int netlbl_mgmt_removedef(struct sk_buff *skb, struct genl_info *info)
 {
 	struct netlbl_audit audit_info;
 
-	netlbl_netlink_auditinfo(skb, &audit_info);
+	netlbl_netlink_auditinfo(&audit_info);
 
 	return netlbl_domhsh_remove_default(AF_UNSPEC, &audit_info);
 }
diff --git a/net/netlabel/netlabel_unlabeled.c b/net/netlabel/netlabel_unlabeled.c
index 0067f472367b..ff52ff2278ed 100644
--- a/net/netlabel/netlabel_unlabeled.c
+++ b/net/netlabel/netlabel_unlabeled.c
@@ -827,7 +827,7 @@ static int netlbl_unlabel_accept(struct sk_buff *skb, struct genl_info *info)
 	if (info->attrs[NLBL_UNLABEL_A_ACPTFLG]) {
 		value = nla_get_u8(info->attrs[NLBL_UNLABEL_A_ACPTFLG]);
 		if (value == 1 || value == 0) {
-			netlbl_netlink_auditinfo(skb, &audit_info);
+			netlbl_netlink_auditinfo(&audit_info);
 			netlbl_unlabel_acceptflg_set(value, &audit_info);
 			return 0;
 		}
@@ -910,7 +910,7 @@ static int netlbl_unlabel_staticadd(struct sk_buff *skb,
 	       !info->attrs[NLBL_UNLABEL_A_IPV6MASK])))
 		return -EINVAL;
 
-	netlbl_netlink_auditinfo(skb, &audit_info);
+	netlbl_netlink_auditinfo(&audit_info);
 
 	ret_val = netlbl_unlabel_addrinfo_get(info, &addr, &mask, &addr_len);
 	if (ret_val != 0)
@@ -960,7 +960,7 @@ static int netlbl_unlabel_staticadddef(struct sk_buff *skb,
 	       !info->attrs[NLBL_UNLABEL_A_IPV6MASK])))
 		return -EINVAL;
 
-	netlbl_netlink_auditinfo(skb, &audit_info);
+	netlbl_netlink_auditinfo(&audit_info);
 
 	ret_val = netlbl_unlabel_addrinfo_get(info, &addr, &mask, &addr_len);
 	if (ret_val != 0)
@@ -1007,7 +1007,7 @@ static int netlbl_unlabel_staticremove(struct sk_buff *skb,
 	       !info->attrs[NLBL_UNLABEL_A_IPV6MASK])))
 		return -EINVAL;
 
-	netlbl_netlink_auditinfo(skb, &audit_info);
+	netlbl_netlink_auditinfo(&audit_info);
 
 	ret_val = netlbl_unlabel_addrinfo_get(info, &addr, &mask, &addr_len);
 	if (ret_val != 0)
@@ -1047,7 +1047,7 @@ static int netlbl_unlabel_staticremovedef(struct sk_buff *skb,
 	       !info->attrs[NLBL_UNLABEL_A_IPV6MASK])))
 		return -EINVAL;
 
-	netlbl_netlink_auditinfo(skb, &audit_info);
+	netlbl_netlink_auditinfo(&audit_info);
 
 	ret_val = netlbl_unlabel_addrinfo_get(info, &addr, &mask, &addr_len);
 	if (ret_val != 0)
diff --git a/net/netlabel/netlabel_user.h b/net/netlabel/netlabel_user.h
index 4a397cde1a48..2c608677b43b 100644
--- a/net/netlabel/netlabel_user.h
+++ b/net/netlabel/netlabel_user.h
@@ -42,11 +42,9 @@
 
 /**
  * netlbl_netlink_auditinfo - Fetch the audit information from a NETLINK msg
- * @skb: the packet
  * @audit_info: NetLabel audit information
  */
-static inline void netlbl_netlink_auditinfo(struct sk_buff *skb,
-					    struct netlbl_audit *audit_info)
+static inline void netlbl_netlink_auditinfo(struct netlbl_audit *audit_info)
 {
 	security_task_getsecid(current, &audit_info->secid);
 	audit_info->loginuid = audit_get_loginuid(current);
-- 
2.43.0




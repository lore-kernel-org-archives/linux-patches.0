Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23F9412A141;
	Tue, 23 Jan 2024 00:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971015; cv=none; b=Eb3HbBmX04NEbjK659BXHnegg1G8DEBwQZAfWy3lyAn+hc306qW5jrOmq7JqwNbjQ/xAfFhFnJZ8+vt7IXZ9O8jEi1nt9do67khsVln5WOV7DdQoVbzm8p/DDr2wJLZzxTS6tD78DF4xEW1FKqgir0E/4QPKFQfRkYYFOYBjSR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971015; c=relaxed/simple;
	bh=rScder62wd9cbutK/rZ4AK1LaziY8Z/HQMhcMSb320Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pCBaIxmV/LOsdB9BrGHfwg5OV6v1PQPWMj+POdhSfrtJcVGL5iGuImEbvt5/8cdw7hiQ64WQNaCkorxFO6MMPZfKm9mCKTPfbZyeNW9AzQCECOyuCSmofNUNepA6vnTgRbpUvlUV7uOc9lCTkD5OPJgDsKa7fEY/6AyCDvhTFNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nLk/F8hA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nLk/F8hA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B505C43390;
	Tue, 23 Jan 2024 00:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971015;
	bh=rScder62wd9cbutK/rZ4AK1LaziY8Z/HQMhcMSb320Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nLk/F8hAlFYRzN78yt86qYPuk7kPZiG4t89BQBdtq5vBlbxLeLkP0A4m6nc9eHYPl
	 jvW4VBVkguJKBw9GQ4sa2wUIR59ykNxfsvIX0QDGYEnc/YZBIwF98hPz2t7u2vIFpP
	 UZ4bmELgn0x+VlS7L421WKL5gXqFbyPalQOzXcKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Yejian <zhengyejian1@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 070/286] netlabel: remove unused parameter in netlbl_netlink_auditinfo()
Date: Mon, 22 Jan 2024 15:56:16 -0800
Message-ID: <20240122235734.714901775@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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
index f28c8947c730..91a19c3ea1a3 100644
--- a/net/netlabel/netlabel_calipso.c
+++ b/net/netlabel/netlabel_calipso.c
@@ -105,7 +105,7 @@ static int netlbl_calipso_add(struct sk_buff *skb, struct genl_info *info)
 	    !info->attrs[NLBL_CALIPSO_A_MTYPE])
 		return -EINVAL;
 
-	netlbl_netlink_auditinfo(skb, &audit_info);
+	netlbl_netlink_auditinfo(&audit_info);
 	switch (nla_get_u32(info->attrs[NLBL_CALIPSO_A_MTYPE])) {
 	case CALIPSO_MAP_PASS:
 		ret_val = netlbl_calipso_add_pass(info, &audit_info);
@@ -287,7 +287,7 @@ static int netlbl_calipso_remove(struct sk_buff *skb, struct genl_info *info)
 	if (!info->attrs[NLBL_CALIPSO_A_DOI])
 		return -EINVAL;
 
-	netlbl_netlink_auditinfo(skb, &audit_info);
+	netlbl_netlink_auditinfo(&audit_info);
 	cb_arg.doi = nla_get_u32(info->attrs[NLBL_CALIPSO_A_DOI]);
 	cb_arg.audit_info = &audit_info;
 	ret_val = netlbl_domhsh_walk(&skip_bkt, &skip_chain,
diff --git a/net/netlabel/netlabel_cipso_v4.c b/net/netlabel/netlabel_cipso_v4.c
index f3f1df1b0f8e..894e6b8f1a86 100644
--- a/net/netlabel/netlabel_cipso_v4.c
+++ b/net/netlabel/netlabel_cipso_v4.c
@@ -410,7 +410,7 @@ static int netlbl_cipsov4_add(struct sk_buff *skb, struct genl_info *info)
 	    !info->attrs[NLBL_CIPSOV4_A_MTYPE])
 		return -EINVAL;
 
-	netlbl_netlink_auditinfo(skb, &audit_info);
+	netlbl_netlink_auditinfo(&audit_info);
 	switch (nla_get_u32(info->attrs[NLBL_CIPSOV4_A_MTYPE])) {
 	case CIPSO_V4_MAP_TRANS:
 		ret_val = netlbl_cipsov4_add_std(info, &audit_info);
@@ -709,7 +709,7 @@ static int netlbl_cipsov4_remove(struct sk_buff *skb, struct genl_info *info)
 	if (!info->attrs[NLBL_CIPSOV4_A_DOI])
 		return -EINVAL;
 
-	netlbl_netlink_auditinfo(skb, &audit_info);
+	netlbl_netlink_auditinfo(&audit_info);
 	cb_arg.doi = nla_get_u32(info->attrs[NLBL_CIPSOV4_A_DOI]);
 	cb_arg.audit_info = &audit_info;
 	ret_val = netlbl_domhsh_walk(&skip_bkt, &skip_chain,
diff --git a/net/netlabel/netlabel_mgmt.c b/net/netlabel/netlabel_mgmt.c
index 02a97bca1a1a..750a7a842ab9 100644
--- a/net/netlabel/netlabel_mgmt.c
+++ b/net/netlabel/netlabel_mgmt.c
@@ -435,7 +435,7 @@ static int netlbl_mgmt_add(struct sk_buff *skb, struct genl_info *info)
 	     (info->attrs[NLBL_MGMT_A_IPV6MASK] != NULL)))
 		return -EINVAL;
 
-	netlbl_netlink_auditinfo(skb, &audit_info);
+	netlbl_netlink_auditinfo(&audit_info);
 
 	return netlbl_mgmt_add_common(info, &audit_info);
 }
@@ -458,7 +458,7 @@ static int netlbl_mgmt_remove(struct sk_buff *skb, struct genl_info *info)
 	if (!info->attrs[NLBL_MGMT_A_DOMAIN])
 		return -EINVAL;
 
-	netlbl_netlink_auditinfo(skb, &audit_info);
+	netlbl_netlink_auditinfo(&audit_info);
 
 	domain = nla_data(info->attrs[NLBL_MGMT_A_DOMAIN]);
 	return netlbl_domhsh_remove(domain, AF_UNSPEC, &audit_info);
@@ -558,7 +558,7 @@ static int netlbl_mgmt_adddef(struct sk_buff *skb, struct genl_info *info)
 	     (info->attrs[NLBL_MGMT_A_IPV6MASK] != NULL)))
 		return -EINVAL;
 
-	netlbl_netlink_auditinfo(skb, &audit_info);
+	netlbl_netlink_auditinfo(&audit_info);
 
 	return netlbl_mgmt_add_common(info, &audit_info);
 }
@@ -577,7 +577,7 @@ static int netlbl_mgmt_removedef(struct sk_buff *skb, struct genl_info *info)
 {
 	struct netlbl_audit audit_info;
 
-	netlbl_netlink_auditinfo(skb, &audit_info);
+	netlbl_netlink_auditinfo(&audit_info);
 
 	return netlbl_domhsh_remove_default(AF_UNSPEC, &audit_info);
 }
diff --git a/net/netlabel/netlabel_unlabeled.c b/net/netlabel/netlabel_unlabeled.c
index ccb491642811..3049fff0b7f8 100644
--- a/net/netlabel/netlabel_unlabeled.c
+++ b/net/netlabel/netlabel_unlabeled.c
@@ -814,7 +814,7 @@ static int netlbl_unlabel_accept(struct sk_buff *skb, struct genl_info *info)
 	if (info->attrs[NLBL_UNLABEL_A_ACPTFLG]) {
 		value = nla_get_u8(info->attrs[NLBL_UNLABEL_A_ACPTFLG]);
 		if (value == 1 || value == 0) {
-			netlbl_netlink_auditinfo(skb, &audit_info);
+			netlbl_netlink_auditinfo(&audit_info);
 			netlbl_unlabel_acceptflg_set(value, &audit_info);
 			return 0;
 		}
@@ -897,7 +897,7 @@ static int netlbl_unlabel_staticadd(struct sk_buff *skb,
 	       !info->attrs[NLBL_UNLABEL_A_IPV6MASK])))
 		return -EINVAL;
 
-	netlbl_netlink_auditinfo(skb, &audit_info);
+	netlbl_netlink_auditinfo(&audit_info);
 
 	ret_val = netlbl_unlabel_addrinfo_get(info, &addr, &mask, &addr_len);
 	if (ret_val != 0)
@@ -947,7 +947,7 @@ static int netlbl_unlabel_staticadddef(struct sk_buff *skb,
 	       !info->attrs[NLBL_UNLABEL_A_IPV6MASK])))
 		return -EINVAL;
 
-	netlbl_netlink_auditinfo(skb, &audit_info);
+	netlbl_netlink_auditinfo(&audit_info);
 
 	ret_val = netlbl_unlabel_addrinfo_get(info, &addr, &mask, &addr_len);
 	if (ret_val != 0)
@@ -994,7 +994,7 @@ static int netlbl_unlabel_staticremove(struct sk_buff *skb,
 	       !info->attrs[NLBL_UNLABEL_A_IPV6MASK])))
 		return -EINVAL;
 
-	netlbl_netlink_auditinfo(skb, &audit_info);
+	netlbl_netlink_auditinfo(&audit_info);
 
 	ret_val = netlbl_unlabel_addrinfo_get(info, &addr, &mask, &addr_len);
 	if (ret_val != 0)
@@ -1034,7 +1034,7 @@ static int netlbl_unlabel_staticremovedef(struct sk_buff *skb,
 	       !info->attrs[NLBL_UNLABEL_A_IPV6MASK])))
 		return -EINVAL;
 
-	netlbl_netlink_auditinfo(skb, &audit_info);
+	netlbl_netlink_auditinfo(&audit_info);
 
 	ret_val = netlbl_unlabel_addrinfo_get(info, &addr, &mask, &addr_len);
 	if (ret_val != 0)
diff --git a/net/netlabel/netlabel_user.h b/net/netlabel/netlabel_user.h
index 3c67afce64f1..32d8f92c9a20 100644
--- a/net/netlabel/netlabel_user.h
+++ b/net/netlabel/netlabel_user.h
@@ -28,11 +28,9 @@
 
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




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015055;
	b=helOsqXLH4ut+1SsGVhASaN+g5kF6b5XuB2vedB29BgPSws9NiNO7rUuMrryD/czM/Di
	 yAy+mPCQKYl9B/aWS0rOiU7sOhOydxKVLEh7a5R0vU0/EmS6B3Dg2uHaoknZCt0pXv2Zt
	 zrn9AsrEHIj1R0GCMXb2ub5NaFYkHX7puTuiwSh7jcAm/sAn20Rv27KJYB78Fus6VmEmt
	 nU0SxMsU49mL+0Ht260COD8Z6GOrpslgEX+B9yQR90r457nfBMJll163tgxDBQ++y0aKG
	 FWcNacISYXtr5Jh+79Z3cR69UtgsVlFElS2OHhGiEOE5spnfemQXDtw/WsyVbJ6BTEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015055;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SMsZdHpZ+hwiPuSrtnJpKOod1v++0b2p96F3SpIZErQ=;
	b=LeHsegUUzXm/FL2s5CITIwib1SVHoef6oXLFfxNZQn/OR8hdkp/H4UUrqrsRAMwg9TmO
	 MJQY2t2dRbQYH6H7L9H280YYVULuO2yMzeE88TrEZ+ihBUQV8Z8pcZCN0kEqwTAllCKh0
	 cCdAXznk/fjj4mjculswcWFmrzimrTwxJp5nEX4Vsm3LP5kt8+HU69qhXuiXBgJaxAXkA
	 OHrxaHq8Kc3IN4yWDgs05jSMeJyphdVMRFfHdQKZwjVf0fOhw1+PuhKSRH5xVBAv6cvRW
	 mCHfL9AAf+gip98H7NINJOXwzxLRlS1k26BBRxPydWQUNVjvlV/54MGFsnhqLtkaaTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="HifD1Va/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86B40606A320;
	Wed, 18 Nov 2026 15:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HifD1Va/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94C781F000C4;
	Wed, 18 Nov 2026 15:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015055;
	bh=SMsZdHpZ+hwiPuSrtnJpKOod1v++0b2p96F3SpIZErQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HifD1Va/1pCBaBFqXF8pk5kB2UzAT8pGwkmobG6uaFOiH2wTb/YodupqDUHV38y3W
	 8VuVN6pazRSALqUcCUBP6AdL0x0dIYwXLuviW3RCMViwgv4l3AJ3h6hm9+HIbVqofV
	 yXvC4HIpfwfEiqdgbomkMIvxzqTJYKj/tSS6Q5lA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Paul Moore <paul@paul-moore.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0037/2651] cipso: stop modifying live ip_options_rcu
Date: Wed, 18 Nov 2026 15:21:17 +0100
Message-ID: <20261118150249.306867345@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jann Horn <jannh@google.com>

[ Upstream commit 1f2c5183fc0902892648f0453e38c0951cef3fec ]

cipso_v4_delopt() operates on the ip_options_rcu of a socket or a request
socket, and tries to remove CIPSO options from the middle by moving all
subsequent options.
That's not allowed - ip_options_rcu can be read locklessly and must always
be consistent. For example, ip_options_undo() reads trusted offsets and
length values from the options buffer.
Fix it by doing the modification in a copy.

The core change is in cipso_v4_delopt(), the rest is ugly plumbing to
propagate memory allocation failures.

Triggering this bug requires that the system is configured to use CIPSO.
(Setting up CIPSO requires privileges in init_user_ns.)

Fixes: f6d8bd051c39 ("inet: add RCU protection to inet->opt")
Cc: stable@vger.kernel.org
Signed-off-by: Jann Horn <jannh@google.com>
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Acked-by: Paul Moore <paul@paul-moore.com>
Link: https://patch.msgid.link/20261106-cipso-rcuopts-v1-1-31ae931d7a0f@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/cipso_ipv4.h     | 11 ++++++-----
 include/net/netlabel.h       | 11 ++++++-----
 net/ipv4/cipso_ipv4.c        | 16 +++++++++++++---
 net/netlabel/netlabel_kapi.c | 24 ++++++++++--------------
 security/selinux/netlabel.c  |  5 +++--
 security/smack/smack_lsm.c   | 14 +++++++++-----
 6 files changed, 47 insertions(+), 34 deletions(-)

diff --git a/include/net/cipso_ipv4.h b/include/net/cipso_ipv4.h
index d6780d7903f4a..b41672221797b 100644
--- a/include/net/cipso_ipv4.h
+++ b/include/net/cipso_ipv4.h
@@ -185,12 +185,12 @@ int cipso_v4_sock_setattr(struct sock *sk,
 			  const struct cipso_v4_doi *doi_def,
 			  const struct netlbl_lsm_secattr *secattr,
 			  bool sk_locked);
-void cipso_v4_sock_delattr(struct sock *sk);
+int cipso_v4_sock_delattr(struct sock *sk);
 int cipso_v4_sock_getattr(struct sock *sk, struct netlbl_lsm_secattr *secattr);
 int cipso_v4_req_setattr(struct request_sock *req,
 			 const struct cipso_v4_doi *doi_def,
 			 const struct netlbl_lsm_secattr *secattr);
-void cipso_v4_req_delattr(struct request_sock *req);
+int cipso_v4_req_delattr(struct request_sock *req);
 int cipso_v4_skbuff_setattr(struct sk_buff *skb,
 			    const struct cipso_v4_doi *doi_def,
 			    const struct netlbl_lsm_secattr *secattr);
@@ -221,8 +221,9 @@ static inline int cipso_v4_sock_setattr(struct sock *sk,
 	return -ENOSYS;
 }
 
-static inline void cipso_v4_sock_delattr(struct sock *sk)
+static inline int cipso_v4_sock_delattr(struct sock *sk)
 {
+	return 0;
 }
 
 static inline int cipso_v4_sock_getattr(struct sock *sk,
@@ -238,9 +239,9 @@ static inline int cipso_v4_req_setattr(struct request_sock *req,
 	return -ENOSYS;
 }
 
-static inline void cipso_v4_req_delattr(struct request_sock *req)
+static inline int cipso_v4_req_delattr(struct request_sock *req)
 {
-	return;
+	return 0;
 }
 
 static inline int cipso_v4_skbuff_setattr(struct sk_buff *skb,
diff --git a/include/net/netlabel.h b/include/net/netlabel.h
index 02914b1df38ba..f896b9d52ed16 100644
--- a/include/net/netlabel.h
+++ b/include/net/netlabel.h
@@ -477,7 +477,7 @@ int netlbl_sock_setattr(struct sock *sk,
 			u16 family,
 			const struct netlbl_lsm_secattr *secattr,
 			bool sk_locked);
-void netlbl_sock_delattr(struct sock *sk);
+int netlbl_sock_delattr(struct sock *sk);
 int netlbl_sock_getattr(struct sock *sk,
 			struct netlbl_lsm_secattr *secattr);
 int netlbl_conn_setattr(struct sock *sk,
@@ -485,7 +485,7 @@ int netlbl_conn_setattr(struct sock *sk,
 			const struct netlbl_lsm_secattr *secattr);
 int netlbl_req_setattr(struct request_sock *req,
 		       const struct netlbl_lsm_secattr *secattr);
-void netlbl_req_delattr(struct request_sock *req);
+int netlbl_req_delattr(struct request_sock *req);
 int netlbl_skbuff_setattr(struct sk_buff *skb,
 			  u16 family,
 			  const struct netlbl_lsm_secattr *secattr);
@@ -626,8 +626,9 @@ static inline int netlbl_sock_setattr(struct sock *sk,
 {
 	return -ENOSYS;
 }
-static inline void netlbl_sock_delattr(struct sock *sk)
+static inline int netlbl_sock_delattr(struct sock *sk)
 {
+	return 0;
 }
 static inline int netlbl_sock_getattr(struct sock *sk,
 				      struct netlbl_lsm_secattr *secattr)
@@ -645,9 +646,9 @@ static inline int netlbl_req_setattr(struct request_sock *req,
 {
 	return -ENOSYS;
 }
-static inline void netlbl_req_delattr(struct request_sock *req)
+static inline int netlbl_req_delattr(struct request_sock *req)
 {
-	return;
+	return 0;
 }
 static inline int netlbl_skbuff_setattr(struct sk_buff *skb,
 				      u16 family,
diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
index e65a3f29d2caf..ee0c72fbc8773 100644
--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -2004,11 +2004,16 @@ static int cipso_v4_delopt(struct ip_options_rcu __rcu **opt_ptr)
 	if (!opt || opt->opt.cipso == 0)
 		return 0;
 	if (opt->opt.srr || opt->opt.rr || opt->opt.ts || opt->opt.router_alert) {
+		struct ip_options_rcu *old_opt = opt;
 		u8 cipso_len;
 		u8 cipso_off;
 		unsigned char *cipso_ptr;
 		int optlen_new;
 
+		/* ip_options_rcu must not be modified in place, use a copy */
+		opt = kmemdup(opt, sizeof(*opt) + opt->opt.optlen, GFP_ATOMIC);
+		if (!opt)
+			return -ENOMEM;
 		cipso_off = opt->opt.cipso - sizeof(struct iphdr);
 		cipso_ptr = &opt->opt.__data[cipso_off];
 		cipso_len = cipso_ptr[1];
@@ -2036,6 +2041,8 @@ static int cipso_v4_delopt(struct ip_options_rcu __rcu **opt_ptr)
 
 		memset(&opt->opt.__data[optlen_new], IPOPT_END,
 		       opt->opt.optlen - optlen_new);
+		rcu_assign_pointer(*opt_ptr, opt);
+		kfree_rcu(old_opt, rcu);
 	} else {
 		/* only the cipso option was present on the socket so we can
 		 * remove the entire option struct */
@@ -2055,7 +2062,7 @@ static int cipso_v4_delopt(struct ip_options_rcu __rcu **opt_ptr)
  * Removes the CIPSO option from a socket, if present.
  *
  */
-void cipso_v4_sock_delattr(struct sock *sk)
+int cipso_v4_sock_delattr(struct sock *sk)
 {
 	struct inet_sock *sk_inet;
 	int hdr_delta;
@@ -2068,6 +2075,7 @@ void cipso_v4_sock_delattr(struct sock *sk)
 		sk_conn->icsk_ext_hdr_len -= hdr_delta;
 		sk_conn->icsk_sync_mss(sk, sk_conn->icsk_pmtu_cookie);
 	}
+	return (hdr_delta < 0) ? hdr_delta : 0;
 }
 
 /**
@@ -2078,9 +2086,11 @@ void cipso_v4_sock_delattr(struct sock *sk)
  * Removes the CIPSO option from a request socket, if present.
  *
  */
-void cipso_v4_req_delattr(struct request_sock *req)
+int cipso_v4_req_delattr(struct request_sock *req)
 {
-	cipso_v4_delopt(&inet_rsk(req)->ireq_opt);
+	int hdr_delta = cipso_v4_delopt(&inet_rsk(req)->ireq_opt);
+
+	return (hdr_delta < 0) ? hdr_delta : 0;
 }
 
 /**
diff --git a/net/netlabel/netlabel_kapi.c b/net/netlabel/netlabel_kapi.c
index 3583fa63dd01f..c0eddb6afef3c 100644
--- a/net/netlabel/netlabel_kapi.c
+++ b/net/netlabel/netlabel_kapi.c
@@ -1045,18 +1045,18 @@ int netlbl_sock_setattr(struct sock *sk,
  * ensuring that @sk is locked.
  *
  */
-void netlbl_sock_delattr(struct sock *sk)
+int netlbl_sock_delattr(struct sock *sk)
 {
 	switch (sk->sk_family) {
 	case AF_INET:
-		cipso_v4_sock_delattr(sk);
-		break;
+		return cipso_v4_sock_delattr(sk);
 #if IS_ENABLED(CONFIG_IPV6)
 	case AF_INET6:
 		calipso_sock_delattr(sk);
 		break;
 #endif /* IPv6 */
 	}
+	return 0;
 }
 
 /**
@@ -1156,8 +1156,7 @@ int netlbl_conn_setattr(struct sock *sk,
 		case NETLBL_NLTYPE_UNLABELED:
 			/* just delete the protocols we support for right now
 			 * but we could remove other protocols if needed */
-			netlbl_sock_delattr(sk);
-			ret_val = 0;
+			ret_val = netlbl_sock_delattr(sk);
 			break;
 		default:
 			ret_val = -ENOENT;
@@ -1185,8 +1184,7 @@ int netlbl_conn_setattr(struct sock *sk,
 		case NETLBL_NLTYPE_UNLABELED:
 			/* just delete the protocols we support for right now
 			 * but we could remove other protocols if needed */
-			netlbl_sock_delattr(sk);
-			ret_val = 0;
+			ret_val = netlbl_sock_delattr(sk);
 			break;
 		default:
 			ret_val = -ENOENT;
@@ -1234,8 +1232,7 @@ int netlbl_req_setattr(struct request_sock *req,
 						       entry->cipso, secattr);
 			break;
 		case NETLBL_NLTYPE_UNLABELED:
-			netlbl_req_delattr(req);
-			ret_val = 0;
+			ret_val = netlbl_req_delattr(req);
 			break;
 		default:
 			ret_val = -ENOENT;
@@ -1255,8 +1252,7 @@ int netlbl_req_setattr(struct request_sock *req,
 						      entry->calipso, secattr);
 			break;
 		case NETLBL_NLTYPE_UNLABELED:
-			netlbl_req_delattr(req);
-			ret_val = 0;
+			ret_val = netlbl_req_delattr(req);
 			break;
 		default:
 			ret_val = -ENOENT;
@@ -1280,18 +1276,18 @@ int netlbl_req_setattr(struct request_sock *req,
 * Remove all the NetLabel labeling from @req.
 *
 */
-void netlbl_req_delattr(struct request_sock *req)
+int netlbl_req_delattr(struct request_sock *req)
 {
 	switch (req->rsk_ops->family) {
 	case AF_INET:
-		cipso_v4_req_delattr(req);
-		break;
+		return cipso_v4_req_delattr(req);
 #if IS_ENABLED(CONFIG_IPV6)
 	case AF_INET6:
 		calipso_req_delattr(req);
 		break;
 #endif /* IPv6 */
 	}
+	return 0;
 }
 
 /**
diff --git a/security/selinux/netlabel.c b/security/selinux/netlabel.c
index d51dfe8923122..24b11d1891d85 100644
--- a/security/selinux/netlabel.c
+++ b/security/selinux/netlabel.c
@@ -557,9 +557,10 @@ static int selinux_netlbl_socket_connect_helper(struct sock *sk,
 	 * is set to AF_UNSPEC, if that is what is happening we want to reset
 	 * the socket */
 	if (addr->sa_family == AF_UNSPEC) {
-		netlbl_sock_delattr(sk);
+		rc = netlbl_sock_delattr(sk);
+		if (rc)
+			return rc;
 		sksec->nlbl_state = NLBL_REQSKB;
-		rc = 0;
 		return rc;
 	}
 	secattr = selinux_netlbl_sock_genattr(sk);
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 8e88ac65fd7fc..3dd6c1ec15cad 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -2653,22 +2653,26 @@ static int smack_netlbl_add(struct sock *sk)
  *
  * Remove the outbound smack value from a socket
  */
-static void smack_netlbl_delete(struct sock *sk)
+static int smack_netlbl_delete(struct sock *sk)
 {
 	struct socket_smack *ssp = smack_sock(sk);
+	int rc;
 
 	/*
 	 * Take the label off the socket if one is set.
 	 */
 	if (ssp->smk_state != SMK_NETLBL_LABELED)
-		return;
+		return 0;
 
 	local_bh_disable();
 	bh_lock_sock_nested(sk);
-	netlbl_sock_delattr(sk);
+	rc = netlbl_sock_delattr(sk);
 	bh_unlock_sock(sk);
 	local_bh_enable();
+	if (rc)
+		return rc;
 	ssp->smk_state = SMK_NETLBL_UNLABELED;
+	return 0;
 }
 
 /**
@@ -2708,7 +2712,7 @@ static int smk_ipv4_check(struct sock *sk, struct sockaddr_in *sap)
 		 * Clear the socket netlabel if it's set.
 		 */
 		if (!rc)
-			smack_netlbl_delete(sk);
+			rc = smack_netlbl_delete(sk);
 	}
 	rcu_read_unlock();
 
@@ -4545,7 +4549,7 @@ static int smack_inet_conn_request(const struct sock *sk, struct sk_buff *skb,
 	if (hskp == NULL)
 		rc = netlbl_req_setattr(req, &ssp->smk_out->smk_netlabel);
 	else
-		netlbl_req_delattr(req);
+		rc = netlbl_req_delattr(req);
 
 	return rc;
 }
-- 
2.53.0




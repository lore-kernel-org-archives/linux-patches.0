Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C251025BEE5;
	Wed,  3 Dec 2025 15:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776386; cv=none; b=CmnF6EC8CjurxDarAeMeQfFcot4Ciz6gPUrPvmBH6Zun+S00cgIXVC8S7fnDyZE0Hh4stvSFZdxik9Wwg9jlW9D93GG3kKuW0Oeql36Jr6lYPzIsxkuzto2ZN8CYSIVe0j9ij7zSpDkUvymkOsbIahTKcWcji5uwfzrWNmkxgmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776386; c=relaxed/simple;
	bh=vyeJTlh4dPlIPI6Ret//IOE+Dv3hmMgTOIuJcvM2rQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kDm6NqkAA/FOgdfKEUOTNXWBikYdqa7JY03o8+AfrHypban7qwLp9UErn8hJzsExej3ry5kcJhe5WuPLcQDEm1HXZzWjPX2FbzNxUPNCem26ycSGfy93KjmboDYE8NTlCbQwwb2j6HOSQOVLSlO0AOH0V0abXdaOpwPnqRSutl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oJDajl6g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oJDajl6g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3055EC4CEF5;
	Wed,  3 Dec 2025 15:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776386;
	bh=vyeJTlh4dPlIPI6Ret//IOE+Dv3hmMgTOIuJcvM2rQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oJDajl6gkzWO6yMuTFsEsqA0S6Z3/FnXiDzHyN+2pKgzVD0f+zF5pPMGyhnE3XLgQ
	 o35AUhir2MjWS4Hmv9oHiy32hujAUePFereRm45lkF+F8gaTZU4OwphOBb6TVgHV2G
	 aTnMGDKqIEbweM8QjH8KB2AAssHDCgyAwrAQ9TIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yajun Deng <yajun.deng@linux.dev>,
	David Ahern <dsahern@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 166/300] net: Use nlmsg_unicast() instead of netlink_unicast()
Date: Wed,  3 Dec 2025 16:26:10 +0100
Message-ID: <20251203152406.768990877@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Yajun Deng <yajun.deng@linux.dev>

[ Upstream commit 01757f536ac825e3614d583fee9acb48c64ed084 ]

It has 'if (err >0 )' statement in nlmsg_unicast(), so use nlmsg_unicast()
instead of netlink_unicast(), this looks more concise.

v2: remove the change in netfilter.

Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: f1fc201148c7 ("sctp: Hold sock lock while iterating over address list")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/fib_frontend.c  | 2 +-
 net/ipv4/inet_diag.c     | 5 +----
 net/ipv4/raw_diag.c      | 7 ++-----
 net/ipv4/udp_diag.c      | 6 ++----
 net/mptcp/mptcp_diag.c   | 6 ++----
 net/netlink/af_netlink.c | 2 +-
 net/sctp/diag.c          | 6 ++----
 net/unix/diag.c          | 6 ++----
 8 files changed, 13 insertions(+), 27 deletions(-)

diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index f902cd8cb852b..e35e7793c0e47 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -1400,7 +1400,7 @@ static void nl_fib_input(struct sk_buff *skb)
 	portid = NETLINK_CB(skb).portid;      /* netlink portid */
 	NETLINK_CB(skb).portid = 0;        /* from kernel */
 	NETLINK_CB(skb).dst_group = 0;  /* unicast */
-	netlink_unicast(net->ipv4.fibnl, skb, portid, MSG_DONTWAIT);
+	nlmsg_unicast(net->ipv4.fibnl, skb, portid);
 }
 
 static int __net_init nl_fib_lookup_init(struct net *net)
diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
index b9df76f6571cd..611f45da24f82 100644
--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -572,10 +572,7 @@ int inet_diag_dump_one_icsk(struct inet_hashinfo *hashinfo,
 		nlmsg_free(rep);
 		goto out;
 	}
-	err = netlink_unicast(net->diag_nlsk, rep, NETLINK_CB(in_skb).portid,
-			      MSG_DONTWAIT);
-	if (err > 0)
-		err = 0;
+	err = nlmsg_unicast(net->diag_nlsk, rep, NETLINK_CB(in_skb).portid);
 
 out:
 	if (sk)
diff --git a/net/ipv4/raw_diag.c b/net/ipv4/raw_diag.c
index 1b5b8af27aafa..ccacbde30a2c5 100644
--- a/net/ipv4/raw_diag.c
+++ b/net/ipv4/raw_diag.c
@@ -119,11 +119,8 @@ static int raw_diag_dump_one(struct netlink_callback *cb,
 		return err;
 	}
 
-	err = netlink_unicast(net->diag_nlsk, rep,
-			      NETLINK_CB(in_skb).portid,
-			      MSG_DONTWAIT);
-	if (err > 0)
-		err = 0;
+	err = nlmsg_unicast(net->diag_nlsk, rep, NETLINK_CB(in_skb).portid);
+
 	return err;
 }
 
diff --git a/net/ipv4/udp_diag.c b/net/ipv4/udp_diag.c
index 1dbece34496e5..ed69d1edfd099 100644
--- a/net/ipv4/udp_diag.c
+++ b/net/ipv4/udp_diag.c
@@ -77,10 +77,8 @@ static int udp_dump_one(struct udp_table *tbl,
 		kfree_skb(rep);
 		goto out;
 	}
-	err = netlink_unicast(net->diag_nlsk, rep, NETLINK_CB(in_skb).portid,
-			      MSG_DONTWAIT);
-	if (err > 0)
-		err = 0;
+	err = nlmsg_unicast(net->diag_nlsk, rep, NETLINK_CB(in_skb).portid);
+
 out:
 	if (sk)
 		sock_put(sk);
diff --git a/net/mptcp/mptcp_diag.c b/net/mptcp/mptcp_diag.c
index f1af3f44875ed..7f900b58c71da 100644
--- a/net/mptcp/mptcp_diag.c
+++ b/net/mptcp/mptcp_diag.c
@@ -57,10 +57,8 @@ static int mptcp_diag_dump_one(struct netlink_callback *cb,
 		kfree_skb(rep);
 		goto out;
 	}
-	err = netlink_unicast(net->diag_nlsk, rep, NETLINK_CB(in_skb).portid,
-			      MSG_DONTWAIT);
-	if (err > 0)
-		err = 0;
+	err = nlmsg_unicast(net->diag_nlsk, rep, NETLINK_CB(in_skb).portid);
+
 out:
 	sock_put(sk);
 
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 552682a5ff243..42b7b8574f099 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2470,7 +2470,7 @@ void netlink_ack(struct sk_buff *in_skb, struct nlmsghdr *nlh, int err,
 
 	nlmsg_end(skb, rep);
 
-	netlink_unicast(in_skb->sk, skb, NETLINK_CB(in_skb).portid, MSG_DONTWAIT);
+	nlmsg_unicast(in_skb->sk, skb, NETLINK_CB(in_skb).portid);
 }
 EXPORT_SYMBOL(netlink_ack);
 
diff --git a/net/sctp/diag.c b/net/sctp/diag.c
index da00a31e167d7..b1e672227924a 100644
--- a/net/sctp/diag.c
+++ b/net/sctp/diag.c
@@ -288,10 +288,8 @@ static int sctp_tsp_dump_one(struct sctp_transport *tsp, void *p)
 		goto out;
 	}
 
-	err = netlink_unicast(net->diag_nlsk, rep, NETLINK_CB(in_skb).portid,
-			      MSG_DONTWAIT);
-	if (err > 0)
-		err = 0;
+	err = nlmsg_unicast(net->diag_nlsk, rep, NETLINK_CB(in_skb).portid);
+
 out:
 	return err;
 }
diff --git a/net/unix/diag.c b/net/unix/diag.c
index 7066a36234106..486276a1782ed 100644
--- a/net/unix/diag.c
+++ b/net/unix/diag.c
@@ -299,10 +299,8 @@ static int unix_diag_get_exact(struct sk_buff *in_skb,
 
 		goto again;
 	}
-	err = netlink_unicast(net->diag_nlsk, rep, NETLINK_CB(in_skb).portid,
-			      MSG_DONTWAIT);
-	if (err > 0)
-		err = 0;
+	err = nlmsg_unicast(net->diag_nlsk, rep, NETLINK_CB(in_skb).portid);
+
 out:
 	if (sk)
 		sock_put(sk);
-- 
2.51.0




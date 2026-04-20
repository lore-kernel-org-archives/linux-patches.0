Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91CD33A63E8;
	Mon, 20 Apr 2026 13:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691599; cv=none; b=Vl4ClrcBzTmQZZ6YcKVaC6GF9dGhVY3uWJ/ePgJqJsCWD4seLAiz1cfr7uxFUxh/Td/xOH/p8wyeu0SkRZG7r7EyNa5dUU0cAohiEXTcWkkcT2Rfz5W02TSgacrXIuT3O+InW5Lp/S0jd26M6mQbp53QT28NXffH1sq7pI3MBLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691599; c=relaxed/simple;
	bh=MBUI7aOKHRe8BiUU0y7rB8VvsEBoFmLmKdnrYb++wWE=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=n9ur33w4uzi/ORtlX84lKU2nPKz20lQveAqKHFDQvzlgU0TzV+cQut1in3sNnUmdxRh1MGvfWa25P9hEzdzgq072jSv6Zqaej5WXNGFUOrwD4CF9DeCM9jW9k9nEaqbYAti2ixA3Odl73PE06b71UbeCUlE7B4d8Rt2Ys2Mx0gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I3/GE62n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I3/GE62n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4A38C2BCF4;
	Mon, 20 Apr 2026 13:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776691599;
	bh=MBUI7aOKHRe8BiUU0y7rB8VvsEBoFmLmKdnrYb++wWE=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=I3/GE62nh65co3nJoPC5mxKhI6l9RyvaFexVwqDMupjmeZjqcxjkTUzUyxHsdZGwx
	 thUi/OJfvQ6e3St0ZfabBaCBu8CcoLAvQt+aBBwM3x/Z2WSxRMesCgNPD2fRuKgqnT
	 uBLZWfrmtQDW9GXDUV7Hm/EbthLP13tvaoy8S9ps=
Subject: Patch "netfilter: conntrack: add missing netlink policy validations" has been added to the 6.18-stable tree
To: 1468888505@139.com,coreteam@netfilter.org,davem@davemloft.net,edumazet@google.com,fw@strlen.de,gregkh@linuxfoundation.org,horms@kernel.org,imv4bel@gmail.com,kaber@trash.net,kadlec@netfilter.org,kuba@kernel.org,pabeni@redhat.com,pablo@netfilter.org,patches@lists.linux.dev
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Mon, 20 Apr 2026 15:24:02 +0200
In-Reply-To: <20260414033129.48460-1-1468888505@139.com>
Message-ID: <2026042002-pep-blunderer-6148@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 


This is a note to let you know that I've just added the patch titled

    netfilter: conntrack: add missing netlink policy validations

to the 6.18-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     netfilter-conntrack-add-missing-netlink-policy-validations.patch
and it can be found in the queue-6.18 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-237711-greg=kroah.com@vger.kernel.org Tue Apr 14 05:31:44 2026
From: Li hongliang <1468888505@139.com>
Date: Tue, 14 Apr 2026 11:31:29 +0800
Subject: netfilter: conntrack: add missing netlink policy validations
To: gregkh@linuxfoundation.org, stable@vger.kernel.org, fw@strlen.de
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org, pablo@netfilter.org, kadlec@netfilter.org, davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, kaber@trash.net, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, netdev@vger.kernel.org, imv4bel@gmail.com
Message-ID: <20260414033129.48460-1-1468888505@139.com>

From: Florian Westphal <fw@strlen.de>

[ Upstream commit f900e1d77ee0ef87bfb5ab3fe60f0b3d8ad5ba05 ]

Hyunwoo Kim reports out-of-bounds access in sctp and ctnetlink.

These attributes are used by the kernel without any validation.
Extend the netlink policies accordingly.

Quoting the reporter:
  nlattr_to_sctp() assigns the user-supplied CTA_PROTOINFO_SCTP_STATE
  value directly to ct->proto.sctp.state without checking that it is
  within the valid range. [..]

  and: ... with exp->dir = 100, the access at
  ct->master->tuplehash[100] reads 5600 bytes past the start of a
  320-byte nf_conn object, causing a slab-out-of-bounds read confirmed by
  UBSAN.

Fixes: 076a0ca02644 ("netfilter: ctnetlink: add NAT support for expectations")
Fixes: a258860e01b8 ("netfilter: ctnetlink: add full support for SCTP to ctnetlink")
Reported-by: Hyunwoo Kim <imv4bel@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Li hongliang <1468888505@139.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_conntrack_netlink.c    | 2 +-
 net/netfilter/nf_conntrack_proto_sctp.c | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 879413b9fa06..2bb9eb2d25fb 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3465,7 +3465,7 @@ ctnetlink_change_expect(struct nf_conntrack_expect *x,
 
 #if IS_ENABLED(CONFIG_NF_NAT)
 static const struct nla_policy exp_nat_nla_policy[CTA_EXPECT_NAT_MAX+1] = {
-	[CTA_EXPECT_NAT_DIR]	= { .type = NLA_U32 },
+	[CTA_EXPECT_NAT_DIR]	= NLA_POLICY_MAX(NLA_BE32, IP_CT_DIR_REPLY),
 	[CTA_EXPECT_NAT_TUPLE]	= { .type = NLA_NESTED },
 };
 #endif
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 7c6f7c9f7332..645d2c43ebf7 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -582,7 +582,8 @@ static int sctp_to_nlattr(struct sk_buff *skb, struct nlattr *nla,
 }
 
 static const struct nla_policy sctp_nla_policy[CTA_PROTOINFO_SCTP_MAX+1] = {
-	[CTA_PROTOINFO_SCTP_STATE]	    = { .type = NLA_U8 },
+	[CTA_PROTOINFO_SCTP_STATE]	    = NLA_POLICY_MAX(NLA_U8,
+							 SCTP_CONNTRACK_HEARTBEAT_SENT),
 	[CTA_PROTOINFO_SCTP_VTAG_ORIGINAL]  = { .type = NLA_U32 },
 	[CTA_PROTOINFO_SCTP_VTAG_REPLY]     = { .type = NLA_U32 },
 };
-- 
2.34.1



Patches currently in stable-queue which might be from 1468888505@139.com are

queue-6.18/netfilter-conntrack-add-missing-netlink-policy-validations.patch

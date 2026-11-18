Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061975;
	b=STzkLYHk+VWuFH/fqk9cTZFlEPFWP/nocjSeompZFaA49hUFklFH9YR5XvBlrCUrsqY2
	 a14i7Hp1/pEFVIavXuxqkgONTSwtJrONxt55MhiabkATatBnKMoizmOctQQnU8bUWqQZI
	 WjS49z4iIgVSK09I0MmpMUHA/J6PSE+Lv2jEFAsMqfgD0oOGLTSsDA89RJBFHpS3wrtAa
	 CeccRTXw+k0Xpk7YXtQpoCjHCiTayQfIUjR01Ctj+2hIiD8JeyfMvGzeUvblxI9s3KfEg
	 +N4g+wtJe59u/od5iruOe/dgqvHbb5Rtic1XoEifeUAGmO0f+GYB3hmXNi6s1gKWdcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061975;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SMieMC1DNueFGhcuuzHkPZrHzIvfdn3yMWyGezZhGiA=;
	b=s4rru3Kv8G8I6BlCFdpx/bRPodsZXi+7C33y7U3JJF7UXgBIsiQUXhLCimLIzgKJ2KIR
	 TqppmzEnKWRElygtKYwfwwWHVxyfZXVsp6xSYDDH0kY1im4Sa9Y43+CshauEiaKyBes06
	 /z7Bc2VzyJHosZqrrmCiqTOugdeI/KJKsVTNFwCiDcoBZ5IKg1WGhLT4StA50UHab81Mi
	 nIBckCGXQrL1l/6KlGusz9KYXkcvtPbyKvDPil++GyscW0yBeDPVHIzqzVFrQazIILVWE
	 s5RJyczGHsBj8S6tlwD4mZmU7c6qpmiH6EIy8WXPxr27SD2/TGytbF4pYodbSKJj4Zw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1CDOYUXD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A46606A320;
	Thu, 19 Nov 2026 04:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1CDOYUXD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06BC51F000C4;
	Thu, 19 Nov 2026 04:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061975;
	bh=SMieMC1DNueFGhcuuzHkPZrHzIvfdn3yMWyGezZhGiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1CDOYUXDUCYI4i9Z2pdS/fijRIey//Eryv7Yr7iNM3wVbeqS0iMRZ+ixOMJYAvp/5
	 6ThC5QHWK0Jo9nwIrmv/pBbw/6WwlYi+1NzmSifU3YCX+YE10FL6s/WZdWMjW/rGTC
	 uIQhVG+0Lau3m0UNiTnDoKJA1gXgqN2aO6Pgb5z0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anil Kaushik <anilkaushikwireless@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1746/1848] gtp: set a valid genl command in PDP context get and dump replies
Date: Wed, 18 Nov 2026 16:03:04 +0100
Message-ID: <20261118150032.599523973@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

From: Anil Kaushik <anilkaushikwireless@gmail.com>

[ Upstream commit 758d8928d2c5d6703da827577cef86d643155236 ]

gtp_genl_fill_info() stamps the reply with the command its callers pass
in. gtp_genl_get_pdp() and gtp_genl_dump_pdp() pass nlmsg_type, which in
a genl message is the dynamically assigned family id rather than a
GTP_CMD_* value, so replies to a PDP context get or dump carry a
meaningless command number.

libgtpnl ignores the command and is unaffected, but parsers that check
it (for example the ynl tooling) treat the reply as an unknown command
and discard it. Pass GTP_CMD_GETPDP, as gtp_tunnel_notify() already
passes a real command on the notification path. No uapi change.

Fixes: 459aa660eb1d ("gtp: add initial driver for datapath of GPRS Tunneling Protocol (GTP-U)")
Signed-off-by: Anil Kaushik <anilkaushikwireless@gmail.com>
Link: https://patch.msgid.link/20261016093225.1036375-2-anilkaushikwireless@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/gtp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 89f46e50d817b..4112bec371024 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -1283,7 +1283,7 @@ static int gtp_genl_get_pdp(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	err = gtp_genl_fill_info(skb2, NETLINK_CB(skb).portid, info->snd_seq,
-				 0, info->nlhdr->nlmsg_type, pctx);
+				 0, GTP_CMD_GETPDP, pctx);
 	if (err < 0)
 		goto err_unlock_free;
 
@@ -1330,7 +1330,7 @@ static int gtp_genl_dump_pdp(struct sk_buff *skb,
 					    NETLINK_CB(cb->skb).portid,
 					    cb->nlh->nlmsg_seq,
 					    NLM_F_MULTI,
-					    cb->nlh->nlmsg_type, pctx)) {
+					    GTP_CMD_GETPDP, pctx)) {
 					cb->args[0] = i;
 					cb->args[1] = j;
 					cb->args[2] = (unsigned long)gtp;
-- 
2.53.0




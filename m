Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042271;
	b=v+nfyJEK1YwlVi1jMZUCtG7ZtYjOKlK+yvMwadsyFnidj7rAYPm/UXiNl0tYJPKsFdhF
	 U/XruyefdDhkefeQCJYFxUBOq3dFUB1lh/hr5L1Un+RBgkHZZ/3nFPeWRFO+GWe/zz+w8
	 vuF/lwChHdsD3QVJdPF1E1bY0LtXYHIdER0otu7K6WYBC9uelQmwsSE14q6JOH5TPMe9/
	 zaVHqAUKeQBlVqyUM3SB1elg6LhQnNnbybrF0VyRdFVMq5p+AS7hfmgASzDFBpNDs9/cZ
	 sspdtu29D3+UrQAD8ZcaYTKW06JmCApB869LmYn8By1Sr6hZPsKG7am8Pu88NJQNDxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042271;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0JyHCLkekIXNqeML7WdDik1JbJhwTPHY5tf7539Af1Q=;
	b=UZ7X003gRDt2A/9x1WXTqLizBbJgldHCx2dM+MOalymmTAUWSMhslTHOLmdYAxhePrp6
	 hhH5Hf2+aCYTU8lzJrW5a1Q92bg71hlntwzs1fI5UOoDhOEKJu1A2lFVovNnldSzN29EP
	 rUc61Ku74PcfHRLLRI3ZggKfVqGqthFspZx0SBLwYjmmfZmlOCFWnrjxTpN81dcdE/V8y
	 L4IFX+b7OBhoSDKKMRNyJrF2YGSyfzaGlx5NIUdJv0EbSOavgcAkaGTrPXc7eWiMO71VB
	 iQY+BC8+MrysjNUIenRdbCTdDT3uguPWuHjjbYxpnT5bPOPS9dD0YfL3HnSa/dfQIJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GwWIWi3e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92274606A320;
	Wed, 18 Nov 2026 22:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GwWIWi3e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAB0D1F000C4;
	Wed, 18 Nov 2026 22:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042271;
	bh=0JyHCLkekIXNqeML7WdDik1JbJhwTPHY5tf7539Af1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GwWIWi3e/xKvNjWXeevFoUaYcH51Yxp/XMpbGj4PGrdwjlJ+hGs50WZ6yxnF8zyFn
	 SketaRqx29d5nKgNSqxxfa8SbQ6PFCIpdh2azWquTdMsWOcysLVUIADHKmderImjLR
	 fwOpMAZvEQ1XSDIhFk5CYKUIhdrT7Ajc/4wqhhWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anil Kaushik <anilkaushikwireless@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3109/3318] gtp: set a valid genl command in PDP context get and dump replies
Date: Wed, 18 Nov 2026 16:02:11 +0100
Message-ID: <20261118150453.246311779@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 39515aba86e68..bb9f284aac455 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -1685,7 +1685,7 @@ static int gtp_genl_get_pdp(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	err = gtp_genl_fill_info(skb2, NETLINK_CB(skb).portid, info->snd_seq,
-				 0, info->nlhdr->nlmsg_type, pctx);
+				 0, GTP_CMD_GETPDP, pctx);
 	if (err < 0)
 		goto err_unlock_free;
 
@@ -1732,7 +1732,7 @@ static int gtp_genl_dump_pdp(struct sk_buff *skb,
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




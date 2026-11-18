Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021461;
	b=1Jq5JcyO5crRP0KnJ6teS1KhK+wY1XU6PCJq/9bWkDBsEiSofVmbWd7B2YcSlAF/5aJl
	 NVtdjJroc79+ZsczkNX+5ntVqIk+3w5Cdftd99/QC6OJDvUcwOdCJoNiudkQ9ptdAZJEA
	 UDi5+i5Z5sS2Gm0qOI5x2IiKDDkZnxAQEos6t38VRdttIkeJEfAvf29GqV9rQ2xwJezex
	 b/tXu+6rgR/19VTl13N4rkOYI/dFfCsjRoHsypBhoTgUYKlYg/mDrEPR3Mo7byhSbx2gu
	 0+YmtkwmL8bfghEkYpp5sw+CPT9weM+IKhdptOTGIxgZv00PkcGjkHkXc7hSs2GGpnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021461;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HdDrbeDpkcXegxLKmbuNC30pQce1T0a/t8g0OVRiq8Q=;
	b=GU6hdy2qLTqUtw7UnKufKRJtX4F75OsIwlxlSB65AMOK1NqgFDBpO7nc1kXkqliixA43
	 Ni/dVUNokyXZtgL4rZBVELxDJ2zLrtn0CtDR0RflPMKesIWuzg2FR6Z9m/jsGw37iygyO
	 TmYkfRKCGHFkhK2twy6WvN2Y+sadFP64bfHfXmi6OEuLGJe3KJG1KVIuo7j8mV8wmucri
	 ZPVWCDGsLGkyQhshMjMpGUrFXz8vDdltIbdrrDdCoPWSBS/eBJ4bdXrxr8lDWM08gMzk1
	 iQZzi+5vRdoTjGxB/IeSKeEnAgdRihucqd1qWmv/P6hLNFAgPspB2imLd+9esjJN9Cw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="fFQBwif/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25CC560A3810;
	Wed, 18 Nov 2026 17:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fFQBwif/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A7EC1F000C8;
	Wed, 18 Nov 2026 17:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021460;
	bh=HdDrbeDpkcXegxLKmbuNC30pQce1T0a/t8g0OVRiq8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fFQBwif/kbOTxg7u750QgN9YMmSrK5FR1ssg8m0gUXSsWwKNzdR9jYnSTZ55rBho2
	 jx8/Ckd7kd5QiakBUQSbJh0hPF0SYgsEj/jb2qVJDoq4js2VT8zUckW8oPZZVI2JJw
	 3dhZY48H+lOKgFV3N6MycZmSBXIZ/o1aiVSxgBZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anil Kaushik <anilkaushikwireless@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2313/2651] gtp: set a valid genl command in PDP context get and dump replies
Date: Wed, 18 Nov 2026 15:59:13 +0100
Message-ID: <20261118150408.484892568@linuxfoundation.org>
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
index 69fe5717846b5..3dd97d75551ce 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -2279,7 +2279,7 @@ static int gtp_genl_get_pdp(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	err = gtp_genl_fill_info(skb2, NETLINK_CB(skb).portid, info->snd_seq,
-				 0, info->nlhdr->nlmsg_type, pctx);
+				 0, GTP_CMD_GETPDP, pctx);
 	if (err < 0)
 		goto err_unlock_free;
 
@@ -2326,7 +2326,7 @@ static int gtp_genl_dump_pdp(struct sk_buff *skb,
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




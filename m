Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032667;
	b=aSxWnhMZ5QoubpeP9fzIERn8NvxHurXutU4p1ihR1e6QYBGKb0s8NjnumF6UWJTIyrqu
	 r2XfBp9RcCUqkOjjKnZUtJzSiHlCMguxfViOLTTL3B9ONkqT0EftfRWZt3zeOlh9sda6Y
	 nUBojQDcbx2m804TC2uW6XyIS96d8j/ilzZGHyn4S+qW/lGVqnD/KUPyUX6nqpIG0lFA4
	 DW5ExuzJA0AjY/se15UCdyT3x9S6KqbQfG97FJwXcYFDssixNG+eL+RGCoPUpPEMPBQzJ
	 6zCF4HmzZe6uTNUFyJRoRhGSngOOnQW67038Z/ZtYuBkAtB+Nyoo8zfzc1FsFUgAmeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032667;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WgfCbweJqSjv/JD2YI/BjNCO+Z4N5xBB6lCbO1ndjdk=;
	b=pLv5VOlhgn08cR3LpSC86EHTgC1eJKoohkJDwDZ6lhaf62tG0yFuaaMwC/LDciSQGdB0
	 FyLHdEUuuGwUhXnX11PXqv7A4YiGX+NdfuLtuWRaPHNGgyKkuQ/Bs81B1RuzWt3rY6Vww
	 kGc+dH0KiYF50296cw46Buh80QDd/JqvY4MtKMr8qRo2B807wctD6TVn29lOc+bbS1Oms
	 Kqpu7ePw2BsLRRiwPgSeQ9owWcrxlWgwzYWiFuf6hZXux4DYMOVSS0aWp6Xgfv5tYX1+v
	 QgV4GaNw8NImWyUvxYw1hHxSGFDd42jyFxLL59BtGZJzO7RmdX8Q3j4asKe76BwT3Xg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eeopBkeF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B27606A31C;
	Wed, 18 Nov 2026 20:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eeopBkeF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A01A1F000C4;
	Wed, 18 Nov 2026 20:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032667;
	bh=WgfCbweJqSjv/JD2YI/BjNCO+Z4N5xBB6lCbO1ndjdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eeopBkeFV+xOMHgEPNCzLQdXcURaJeAcZDhBB8yEaubGAz/FKEvn67LCvZhNvTsJq
	 cHs/zyDqmiovKM5nddGmDkzqxiyTGANlRTCn9HTKlbaoc9ptzV9rgVRALeVLIwfLpX
	 XXxY0tH8mBgMu0AVV7aHmmVtFVN1WM2iKftnhf4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anil Kaushik <anilkaushikwireless@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1492/1756] gtp: set a valid genl command in PDP context get and dump replies
Date: Wed, 18 Nov 2026 16:00:19 +0100
Message-ID: <20261118150108.342354202@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index cac997254ad6a..7978389c45a4c 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -2280,7 +2280,7 @@ static int gtp_genl_get_pdp(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	err = gtp_genl_fill_info(skb2, NETLINK_CB(skb).portid, info->snd_seq,
-				 0, info->nlhdr->nlmsg_type, pctx);
+				 0, GTP_CMD_GETPDP, pctx);
 	if (err < 0)
 		goto err_unlock_free;
 
@@ -2327,7 +2327,7 @@ static int gtp_genl_dump_pdp(struct sk_buff *skb,
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




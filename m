Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056824;
	b=uKy3PHPwsa0wwDLy4/IBzHkMEXQeOuF9cWAnmIdsvMlKOAKBhxH0RgvAgrKbqXjnqEwQ
	 cY15kYCMAMFODCmq8jbntWEV0ZAooe/vHdGBcqPH76YbC8Y3MNIzeop1pAeL6hpXEGlnl
	 y5KEAUhQAuh6qikRbbSFEVLtDi1vrSEXtffx2kp3DGe0mhPvofogeJZYrHw2TEkidS9jI
	 8Xh4zdCd0EIsDjSdH3GIv0fz8/M8xreUX3SXbvnI+oA/+wnbqnWS+chHe5492VtebqXNP
	 JOtokFnEpHssCZwsnCEev6ThzEdkNLwoKJkgCj5kk0eFeDE39mlLyhSWPSTDchbXmwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056824;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D2+2bGfDodCGEH1aDRrCdFG8acO24hPMl+0FLW9O4M8=;
	b=GDMDjJoD2HZfY+zyIRQyLcLiEi/zocty7pgQsHYr7BFQe6px8zWPG4z9rSwojCMJELjb
	 yWUUjfkq6Znxd8bOmuMeLv9OzGnaEeXpRRkNGbvp9K5NldVC98yvBZF3dxbaytGjof2rE
	 NaAxbiyHxCv6uSdKQ8vl1iCJ95rsqQ30izMDVEytcqXKvd4QsSw2r5nO2XQ+7tNqrwI3S
	 LfIyVZstlE7fILDwVazva8mzFI3K1uZTChQEhPGjOuwb7ab/MFissOLQzwii7TMewZY6j
	 BcuzF5JWJ3nOFkaI1dWgBkULoGbtDTuIeSJhfVJoRZRqGnddymhO6Zxrttvu7+5EJtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="TZci/Dh7";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AC18606A339;
	Thu, 19 Nov 2026 02:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TZci/Dh7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A2F01F000C5;
	Thu, 19 Nov 2026 02:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056824;
	bh=D2+2bGfDodCGEH1aDRrCdFG8acO24hPMl+0FLW9O4M8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TZci/Dh7ha5ba0/HsWiv1p+bykOFWLp5ck16Xxy9x4hZEHWnOjDvoTWsALtjRgC2X
	 raxsu7ccj9X5jLZZgsGUAbY0n1Hyt2TU2VYJ6xV5zvsUigz08MF2Dy1mUIW57GhDVK
	 T8rqfDyFqRM28qMf8/Dt2cxVADX+f42wimOGndhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anil Kaushik <anilkaushikwireless@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2084/2214] gtp: set a valid genl command in PDP context get and dump replies
Date: Wed, 18 Nov 2026 16:02:40 +0100
Message-ID: <20261118150134.006570837@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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
index d38def0f2d53e..18ce889f5619f 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -1299,7 +1299,7 @@ static int gtp_genl_get_pdp(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	err = gtp_genl_fill_info(skb2, NETLINK_CB(skb).portid, info->snd_seq,
-				 0, info->nlhdr->nlmsg_type, pctx);
+				 0, GTP_CMD_GETPDP, pctx);
 	if (err < 0)
 		goto err_unlock_free;
 
@@ -1346,7 +1346,7 @@ static int gtp_genl_dump_pdp(struct sk_buff *skb,
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




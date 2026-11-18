Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050448;
	b=W+DD3cFgUd0dJvKOvzftGIWgCU+a9pWOW++tZh2ulyzoicWIOukInpwDmm7k+JdaIPt4
	 +oXcMpqVmyoi8eYiMzEjCwzU+dOWoJBJHFAvb0Z373KYwlFIxQuQYY80pDHD+mE7TY+Ck
	 wiQpYkoArRt2JJS3GzlQq1qyZuLGi3kPO8YexV+ZSYd24n+EHT2kx+bAtPN7IP3pJ49NT
	 /PN3cWsW26E+HwKbU8PY6hBCvV3fGdb9gdTBDdcgW/cIfm82mu/2fK4Pq/1L76hPCBinY
	 xyiluI7eHjsZWkPqAmv3EpxqJXzyqqKZU+Dk6ELnRy+XUlaQvxMz8b0qwmjLcWHg1tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050448;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kOjOF9WKpZeVlme1FtE2y6rNU0siYnupBWvprOBxKv8=;
	b=zFRLG8GGmc16bxMt1/yftFYxWenlPGHthFH0Sjjwvd9owL5EYw3AGxHpmpp9l9uROGRw
	 AA0G5xD9rGSo9UEZaCh6EmS98VghngjRUXr+tfyYDboFPiJBk2jrfR/r8WE7tROhGsvT8
	 JCzWianwi9QvqKPLJFGQiLMySPO4TGGgUB+kCdnI6QAxD7d6z5eLjpyHQqIPSgqtdMmT7
	 kGwWZagVPFYd/fHZZHq0EemD4fMbcumcDdFhr1gKDTtnEIlWprEnU4+atUp7ov7ZKXZZb
	 w2fFmmrui1/YdsUaZXD+dxtNBJj7apE/NpJpzUMjR9r2b9SX2CEOzjHaGaXPfhlxcNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UE+9P7Og;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C21606A320;
	Thu, 19 Nov 2026 01:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UE+9P7Og
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53A501F000C4;
	Thu, 19 Nov 2026 01:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050447;
	bh=kOjOF9WKpZeVlme1FtE2y6rNU0siYnupBWvprOBxKv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UE+9P7OgEnKeGnfEUDRiUT0kUhlgbRKYckI3LJGWYbv4GwewE4lbXneCf4xy5ApdE
	 IiGSc1uPqJYohxIkHrmXSxwV7+5V4Xjkwa557yuxSurL5IU0qGJHk7zxDdf/S7ynln
	 9WH0hfeNU72mQcdkzDXPE8ZfSdcuq3P9IpOAv1dE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anil Kaushik <anilkaushikwireless@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2671/2857] gtp: set a valid genl command in PDP context get and dump replies
Date: Wed, 18 Nov 2026 16:01:45 +0100
Message-ID: <20261118150337.748270149@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 501dbfa917408..ea5d1cb255f33 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -1684,7 +1684,7 @@ static int gtp_genl_get_pdp(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	err = gtp_genl_fill_info(skb2, NETLINK_CB(skb).portid, info->snd_seq,
-				 0, info->nlhdr->nlmsg_type, pctx);
+				 0, GTP_CMD_GETPDP, pctx);
 	if (err < 0)
 		goto err_unlock_free;
 
@@ -1731,7 +1731,7 @@ static int gtp_genl_dump_pdp(struct sk_buff *skb,
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




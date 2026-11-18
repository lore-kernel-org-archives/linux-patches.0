Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027767;
	b=sxUeoK+nKJ5i96OudIti/ykv2d4gBpQ95H6A7atxuYry0bK0Hbf5g+vgYWP9l9iCpZkl
	 8AaweHTRtdH7DYQv0y2yq7eEXtbM+DyR4aoncRayeZLxf+4melBwnuhUjMjDAuA6UmnJr
	 1jw0vlkrsVsjwHMFDx+JzTPj934f0rHZaEpJmeeaMrHi9hsYMrJeK9tAyUO6YCek/M3Nl
	 EwVdJ3Fj9hF9sFH29pcBzrdV3ldFwFnEYyluWuLlMl0q364W4/V2N5xPr82QzlOqcGLk4
	 XLN4ayGzBWcwg3fmGG3GWSxxBJHv1L4BDGdakHluIBZVahDw88eBqFYT/WwtAqwElyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027767;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q433UYxyJUGxUNZUPWsBjKiS1O2M8Kj9Mk2TSCMXbz0=;
	b=ng2VoxlOB3EH0aDjpOgv1P8k7miAB1C77eAL7WcisA+tkQWvyaHrBoQvI//yzcDcK6Sm
	 DuOqgbQ6onMgeb2BGx66C1Ebaty4y1XPpeZ2jSK4bf7kf7BnqaYwaYE9vwo8r69CN8Ebm
	 C2efeRKIZRRWzlzvwFNqKToQLi43LP7H7OQm93yBfbvyyxdTDBM2DCesxPG66Z2wb2cym
	 8j+KOb1gEQQuQc41JqteO8a/2IsxuTOGk5QTCVfX9HFNGW7B+cx8Wx76oP+iXEeaiUeP2
	 4hntwGT3UghLoH9Pg64ePFRHIVvQE6R6SSx6ZVdxMPtO8ro5OEk5GOolJAm12iT7XyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ntCIZ2Uj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FF9F606A32F;
	Wed, 18 Nov 2026 18:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ntCIZ2Uj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 945801F000C4;
	Wed, 18 Nov 2026 18:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027767;
	bh=Q433UYxyJUGxUNZUPWsBjKiS1O2M8Kj9Mk2TSCMXbz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ntCIZ2UjLIOyBe+kbkEKxIkMv8A2rckETIj8iV+STNc/r21nIuSLflJ0VeVKdtU+L
	 v2srRd28B+P92Rz+TtHfFJYYpqQTzZKfiyxvleCGHbgwRuxaTFFZAs/qCfetrzEhWI
	 WuSVTeon+jPa9WAyJo8orAg0M31xZTtE1yKqPRMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anil Kaushik <anilkaushikwireless@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1869/2151] gtp: set a valid genl command in PDP context get and dump replies
Date: Wed, 18 Nov 2026 16:00:04 +0100
Message-ID: <20261118150229.881745151@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 184cb367bbe13..ecc9e0f088caa 100644
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




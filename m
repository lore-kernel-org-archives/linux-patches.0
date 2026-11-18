Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022140;
	b=gxj7Fx4vTPPIYb1CoOqN2KB1k23ctxZYXuuDRaIDPofUuGlbIDPnbdssaiK6qF28g4ZS
	 FDMEt45TvJrrc/g1w1wDXsyZH1QTf2eFED8s+qnrhH5SBFi0xqqY8A4v6a8qh5coKC10N
	 Q1XIr3u8pCU0Km5GB2Rf11ulTWl542HbI3fs4VDKoHLVQQEujbnrRMV9ZeGRt504xP7X7
	 ZU60KZbRMO9kMwpSYjrVQpfsDlC7+4/xem0BkaQ+zKZBj5ZEyxrO0ry9DSHfQ1SYQTahf
	 M0n22SVsSkRSy0eWf8p3KywFeMRdJL+aVP+T7F7knt4xFj8I9nDIRV/8OzXow3NMMlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022140;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8ZMN7dd59rO6zC5mZRM7v5FpiCIpBBT6UPTv4R19mbA=;
	b=wNv0dJaCPLmNpr6AnyLlEkGzrbArQjBsLOrexqNDbNQcd1bckodU5ysIdl45O4ZtWVjq
	 1a5N80YkDm+doGNgg6LQSqePCufHeX12ypz0stAlajpXfdaaKKl2DcAcgQMM0gb0qkOxJ
	 jvsq4qwOdi5TU5VfvkvFCrYKgpvxutzsdjRNb6BzqiX3hXlxeuQPbKpfOxD252xhxiWiD
	 jtBpQ9lL3+B+DRMAC+p1cpE9PWHBU3XfZg2IUSnU1jZQS6P6+q4gxs9sfjDvYpebNBEqv
	 MqIHIp549XkViVPYtvfWIj4x4YG1ykNC1H8+tWfRwvLnC1xkH7KV9Q/iS215P/1/jOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hb8gBzKE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 528EE60A2607;
	Wed, 18 Nov 2026 17:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hb8gBzKE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1B381F000CC;
	Wed, 18 Nov 2026 17:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022140;
	bh=8ZMN7dd59rO6zC5mZRM7v5FpiCIpBBT6UPTv4R19mbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hb8gBzKE6mBneaDwXA3Q3B0SxCrxLPrTGGyRhhvGfnKvPN1Z0BaYOup4gYH6fSie/
	 IO0z+ru1hAoVbPAwyEV7MsqEMch577Z/lc4uzAoTZqxaKj2K6ApN1rINcDUPn14Veh
	 tu4QjjwQvBCPS1qniqgeIW0qlfYMdzBjDzvcWl6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joas Antonio dos Santos <joasantonio108@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2556/2651] net: dcb: initialize PFC value before calling getpfccfg
Date: Wed, 18 Nov 2026 16:03:16 +0100
Message-ID: <20261118150416.493024379@linuxfoundation.org>
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

From: Joas Antonio dos Santos <joasantonio108@gmail.com>

[ Upstream commit ca87a2dffbb550fc934647d5e8d1c4ae85590132 ]

dcbnl_getpfccfg() and dcbnl_cee_fill() pass the address of an
uninitialized stack u8 to the driver's getpfccfg() op and then put it
into the netlink reply unconditionally.  The op returns void, so the
core cannot tell whether the driver wrote the value.

i40e_dcbnl_get_pfc_cfg() and ice_dcbnl_get_pfc_cfg() return without
writing *setting unless the DCBX agent is host managed and in CEE mode.
Both drivers normally run with firmware managed DCBX
(DCB_CAP_DCBX_LLD_MANAGED), and i40e with FW LLDP disabled runs host
managed in IEEE mode, so on a DCB capable i40e/ice port the PFC values
in DCB_CMD_PFC_GCFG and DCB_CMD_CEE_GET replies, and in the CEE part of
RTNLGRP_DCB notifications, come from uninitialized stack.  The same u8
is reused for all eight priorities, so this is one byte per reply.

dcb_doit() only requires CAP_NET_ADMIN for RTM_SETDCB, so the GET
commands are available to unprivileged users.

Set the value to 0 before each call, like the PG config path already
presets its outputs to DCB_ATTR_VALUE_UNDEFINED.  0 is also what the
reply contains today on kernels built with CONFIG_INIT_STACK_ALL_ZERO,
so nothing changes for those.

Found by code inspection, compile-tested only (W=1).  I don't have
i40e/ice hardware to check the reply.

Fixes: b94b013eb626 ("ice: Implement DCBNL support")
Fixes: 5effa78e7c94 ("i40e: Add netlink callbacks support for software based DCB")
Signed-off-by: Joas Antonio dos Santos <joasantonio108@gmail.com>
Link: https://patch.msgid.link/179289284460.50470.572724041164324949@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dcb/dcbnl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/dcb/dcbnl.c b/net/dcb/dcbnl.c
index 35164bfa563d1..593c9d89d36a0 100644
--- a/net/dcb/dcbnl.c
+++ b/net/dcb/dcbnl.c
@@ -281,6 +281,7 @@ static int dcbnl_getpfccfg(struct net_device *netdev, struct nlmsghdr *nlh,
 		if (!getall && !data[i])
 			continue;
 
+		value = 0;
 		netdev->dcbnl_ops->getpfccfg(netdev, i - DCB_PFC_UP_ATTR_0,
 		                             &value);
 		ret = nla_put_u8(skb, i, value);
@@ -1395,6 +1396,7 @@ static int dcbnl_cee_fill(struct sk_buff *skb, struct net_device *netdev)
 			goto nla_put_failure;
 
 		for (i = DCB_PFC_UP_ATTR_0; i <= DCB_PFC_UP_ATTR_7; i++) {
+			value = 0;
 			ops->getpfccfg(netdev, i - DCB_PFC_UP_ATTR_0, &value);
 			if (nla_put_u8(skb, i, value))
 				goto nla_put_failure;
-- 
2.53.0




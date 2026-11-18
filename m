Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050654;
	b=jCGeAHkAP1AMk5yNnPiYyv5MqAn+nLiTbiqL45ypl3ndEDS75InXclWVbt6AV62NmDWW
	 Jhn/ZWO1SJhW9ZwMZNTGhWJnjhhIb9vK3CFPSLRBfUlk5/5W1tmO4iaKb3w6lX6w46fLy
	 +DKKlu+mP9dbYOcFtem8NG6eJtZbetp/8aBAv24P/uCg8b+5iw8HA/PpFueciz+Cxq6En
	 y1CMZKLnR5Wew6gTEktJtHvrO0BYJOtxfLH9Ts5+BXjW68VRdv12vmZJm2CgfxLSproIl
	 qMzTMR9uic0pvCpeAbJLbP1V215HypfRAMhum8uS34Tvskqae7eukYWGZwuoYeObbJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050654;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+bsbRl2c4SzEuOqrdr6SwY8XYW4LBTdO7C92zQ8or6I=;
	b=C8D3MqOf2ialy6PTa1JCW3nojbSjaaMUXGUdVp9pW0yUcYMTtHzqK4aVyewotNIMIwjk
	 EJezAsFP4W5G4VhwE3Z2FFw49MXWUXxN9KR/BBH+81LSuXf+VCAoUusBREZ8HxJp/nRyq
	 4cHVOgcYLEUxINrZq7e3Cy/8hHFKwFC26GrNpKVWc8S6asWL9bt993/KZYnFfLhIdCSmy
	 Uuot0TV5mUu/jd4Y//CrgWeBHMnqkzeBEtmw3yOlCgCIN3crpgbkY+x+orkNx2rcx4w9A
	 MVGWZW8yPJs308UlBZ5hA9SubjfVm/ohrnifcuUb+LZ9Xdrwvof+GpNGwWQTgOm6cWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M+xv+4N6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BADC5606A325;
	Thu, 19 Nov 2026 01:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M+xv+4N6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B2521F000C5;
	Thu, 19 Nov 2026 01:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050654;
	bh=+bsbRl2c4SzEuOqrdr6SwY8XYW4LBTdO7C92zQ8or6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M+xv+4N64OZvm15quchLpww6K1OIf2rUdyqYc8s+WJDqxk4mEWuWyJjW/IlWVeLZk
	 h3RjJVvIakRtDo60WvwgMREzcDDIFUYo4gF6gft1CSs8+dPEQypR+/02dLzm56ULRM
	 iEuAE6V7F6HDTCBTtffupzVhZXzRVQWnXFB8ZGQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joas Antonio dos Santos <joasantonio108@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2784/2857] net: dcb: initialize PFC value before calling getpfccfg
Date: Wed, 18 Nov 2026 16:03:38 +0100
Message-ID: <20261118150341.848739548@linuxfoundation.org>
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
index d2981e89d3638..fc7956ea13863 100644
--- a/net/dcb/dcbnl.c
+++ b/net/dcb/dcbnl.c
@@ -247,6 +247,7 @@ static int dcbnl_getpfccfg(struct net_device *netdev, struct nlmsghdr *nlh,
 		if (!getall && !data[i])
 			continue;
 
+		value = 0;
 		netdev->dcbnl_ops->getpfccfg(netdev, i - DCB_PFC_UP_ATTR_0,
 		                             &value);
 		ret = nla_put_u8(skb, i, value);
@@ -1260,6 +1261,7 @@ static int dcbnl_cee_fill(struct sk_buff *skb, struct net_device *netdev)
 			goto nla_put_failure;
 
 		for (i = DCB_PFC_UP_ATTR_0; i <= DCB_PFC_UP_ATTR_7; i++) {
+			value = 0;
 			ops->getpfccfg(netdev, i - DCB_PFC_UP_ATTR_0, &value);
 			if (nla_put_u8(skb, i, value))
 				goto nla_put_failure;
-- 
2.53.0




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021660;
	b=zyhLf1iVFN0KOtvecZn/hafTjll69H0Z1xyaC1beATeG6ZPtsziw8cTg47BBoBRvB1gr
	 vR1Tye+Rojc3SMA8Vb+gDpYnA76C+BEyJt9pqba1/FxRjkI5Hsfpp931F64fAYhfwybaq
	 WitUMAMpjA6RSX8Io63joBDgqlYz+r0J6zU6Tb8Bdd6MGYP3qpisMlAM1UzpLwlL7yss8
	 d8hTZcfdwamGydmyGqQgNkbCRt0yPtqtGA3SMJEmIQ7pz1F7Vm7tZBuLIXb2Ua4nDjVi2
	 NGwSONnIheh4DMFLMn7m4OZlqE2N2kMIj2axp3aA/TT5XNLl0273Ts7gq2lFmLfAVkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021660;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OOVAmNL2c/t3Q40jbZWf/XMWvQcV1Q5vFnHrkQLCwss=;
	b=fqEs+Cb/ydd6VJ3T/tSex2O/dkB57TxIExYA1FAEENOyidJkAs3d4szSJMzIYq5wj/PZ
	 SHFAhB7tWSo7glzHQPD4/0hOVU+Uezqs9yz5A57uegasM3OFO6pw8b7pdVvamdQxiSiLq
	 HdYc++oVKQtW1givSR1UPtTzsR5FN6hZNp0F0ZS2SScqRiBr9hD66ZFUJ5t+KjleU+KXS
	 9fuvk/M55b3f2pbnFevwa0k57PpeorolLDwN/vHDt+jZzzIWCaQr4Lu750uUbmoI3jNKz
	 3L98G4GbAExBHNKVFM6rit0LPR+jyCjise5XLf4LyZ3vd1k7U5+E+sH4/xbAn3SPqhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tgh4dJtD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0683E606A31C;
	Wed, 18 Nov 2026 17:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tgh4dJtD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5150D1F000C4;
	Wed, 18 Nov 2026 17:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021659;
	bh=OOVAmNL2c/t3Q40jbZWf/XMWvQcV1Q5vFnHrkQLCwss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tgh4dJtD1G8sWSIp4vDkOKBGebVV1IDJT8N7QEC3ybwADSZw8mFHtecRGpr6CV8DG
	 7X23PXzbqznj7KEe807ujMdy2eGO3ry7keCuKtfgturcNxpILUKkJEQfb0DQNbB98r
	 NiLHOA7V+FmgO0LduiUh5fcOIqIQywHRa+2xlMO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dudu Lu <phx0fer@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2386/2651] net/sched: etf: initialise the sock_exterr_skb before filling it
Date: Wed, 18 Nov 2026 16:00:26 +0100
Message-ID: <20261118150411.320310072@linuxfoundation.org>
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

From: Dudu Lu <phx0fer@gmail.com>

[ Upstream commit 7076f684d5132e6a6145e1da2fa74771ecd052e5 ]

report_sock_error() clones the transmitted skb, overlays a
struct sock_exterr_skb on its control block and fills in the seven
struct sock_extended_err fields, but never clears addr_offset and port.
skb_clone() copies cb[] verbatim, so the errqueue entry carries the TX
skb's stale control block to the receive side, and the ipv4 error-queue
reader trusts those bytes:

  net/ipv4/ip_sockglue.c:556
	sin->sin_addr.s_addr = *(__be32 *)(skb_network_header(skb) +
					   serr->addr_offset);
	sin->sin_port = serr->port;

The gate that is supposed to guard that read only asks whether an
address was requested at all:

  net/ipv4/ip_sockglue.c:484
	return serr->ee.ee_origin == SO_EE_ORIGIN_ICMP ||
	       serr->ee.ee_origin == SO_EE_ORIGIN_LOCAL || serr->port;

SO_EE_ORIGIN_TXTIME is neither ICMP nor LOCAL, so for sch_etf the gate is
decided by serr->port alone -- by the stale byte pair.  When it is
non-zero the reader dereferences skb_network_header() + addr_offset with
an arbitrary offset.  On the TCP path cb[40..44) is not zero: the
transmit path stored delivered_mstamp there (tcp_rate_skb_sent()), which
is exactly where addr_offset/port sit in the arm64 struct layout.

Reached with an unmodified 7.3-rc4 (arm64, KASAN, in-tree modules): a TCP
socket enables TX-timestamp error reporting (SO_TXTIME with
SOF_TXTIME_REPORT_ERRORS), a sch_etf qdisc drops the packet, and a
recvmsg() reaches ip_recv_error():

  BUG: KASAN: slab-out-of-bounds in ip_recv_error+0x970/0xa0c
  Read of size 4 at addr ffff0000158ffdd5 by task A-227-A227-1_S2/113
  ip_recv_error+0x970/0xa0c
  inet_recv_error+0x94/0xdc
  tcp_recvmsg+0x378/0x408
  ...
  The buggy address is located 149 bytes to the right of
  allocated 704-byte region

Zero the whole overlay rather than the two fields individually: the
errqueue entry is handed to the receive side as a self-contained record,
which is what every other producer in the tree already does (sch_etf was
the only error-queue producer that cleared neither field).  This does not
change what the in-tree selftest observes -- so_txtime.c reads only
ee_origin/ee_errno/ee_code/ee_data/ee_info, never msg_name or sin_port.

Fixes: 4b15c7075352 ("net/sched: Make etf report drops on error_queue")
Signed-off-by: Dudu Lu <phx0fer@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20261021155401.65997-1-phx0fer@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_etf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sched/sch_etf.c b/net/sched/sch_etf.c
index ada87a81da6ac..aaafcf640bc7e 100644
--- a/net/sched/sch_etf.c
+++ b/net/sched/sch_etf.c
@@ -147,6 +147,7 @@ static void report_sock_error(struct sk_buff *skb, u32 err, u8 code)
 		return;
 
 	serr = SKB_EXT_ERR(clone);
+	memset(serr, 0, sizeof(*serr));
 	serr->ee.ee_errno = err;
 	serr->ee.ee_origin = SO_EE_ORIGIN_TXTIME;
 	serr->ee.ee_type = 0;
-- 
2.53.0




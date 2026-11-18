Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032811;
	b=XPHqsLzdAV9YXfItY5aaKSYo2thghlB08c+gUq85Iijv0nCXteGj6pKltwTHRLVuelPr
	 tAilyk/vXNIuLmYe27+Y7ATpWmibAR3r2mKfePO0jwSkqWtNVdNqj+RhJt60OSVw1UucM
	 q84XRbywPGhgq3zA5gHOJodGUkS5i2kQhijXfsTi0zWX1eZt80G3JUCmG1RQS9c7g11s1
	 AJ+O0aYG73Ojg8K5B5pXmoPPZLZIdNHOSwUMIOBzxRI2caityQ5HlX7ArPg3c+rWX64vz
	 D/k/ounGAOAYyEs7FaUcLyAk2/vqU9al0Sk7ui8VZPLsyS+ni/D6xN28nkiUAi6cdgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032811;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QQNux4QsH0yMS6f32vCEPYNxIDzREUCxZIk90xwSaws=;
	b=5Mex6Aj8ygdA1vgrM208JBRXWe5KCtLANv0r5YlG/eedlPZEKl6+UkVbJpwM33YJNMZO
	 oRkXIlaLvwU+sqAFe2/sagtaFNCG/Rxl8EQ4ifKUomZIz4fCUbxNdE/eZXVLcUsP7TkBK
	 +ULus6BqkvN/A2AQhPNPSys5gefN3OpIkPai5Tp58DFXQ4i0iFHbwXlKF6JumnhoelNnF
	 JrSePap+JE+CQmF5djzPhHz+yVq0aefRZ/SqVK2WoCBimc94pEm/Z2UfeAKOT68kbT+X9
	 M2fLfpyitFr5jOpldaXOtrDjuMVTpPlGWYgx9ok2owngSGkrrDqtcsk8stCsRxl52xg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="PB+ZR/WR";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25114606A31C;
	Wed, 18 Nov 2026 20:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PB+ZR/WR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F60E1F000C5;
	Wed, 18 Nov 2026 20:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032811;
	bh=QQNux4QsH0yMS6f32vCEPYNxIDzREUCxZIk90xwSaws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PB+ZR/WRvaDgfrqyDlpZvfs/nCKKDL6pWOGf2CUNyOYPH873WJ1oIYEWUM1MtYSgw
	 eqPxdGDbQzk7gqb9Uvaq9qTX93qiWKmhw5FP12a0KL6SyUP5eV9hQu4qxX+gwU8Mzl
	 jA1gj4CSCZcuj6OAq5WXzVWm2dsESRSHTSIkSRHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dudu Lu <phx0fer@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1543/1756] net/sched: etf: initialise the sock_exterr_skb before filling it
Date: Wed, 18 Nov 2026 16:01:10 +0100
Message-ID: <20261118150110.360527047@linuxfoundation.org>
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
index c74d778c32a1e..c4bf7dc3ec86f 100644
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




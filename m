Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027839;
	b=epUx93GCLwMtywTiRoLKTS+20lZE1x2OvSHlz5MAMG/TMKib6GFXhFoBGCGIxyqqUjp7
	 Eu+f9g4WmKWLMg+/hhqiSM39PvT8IHCwYCiV/fEmJiSLxlT8HBZwx8plb7F69MFBp5x3x
	 uNnwtwImVWB2e/T8VgbvuBt4jj667+CFdTvZ7ZBKvfAqSktO/ax4Z3N3QOPfC0IpW2lbC
	 0tIao1JcT6xI0YqAQzAkXrBGIVI/1LFQM794r6a9qjUNmP8ULMg/cWeV47pl0jZgYCh+t
	 qynVUVRU8WaoxcZaWW1YyuseqDBlwV9zzBY6qqS3VS7L/DL+2ePzYAh7YbljFhMckPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027839;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dpNBj7/JpkjCkuTZRHJxB0bm4MUcYWwQo8UqKT6bAb4=;
	b=yk+2Hvx8FJp0hsv6scWY5FpCC8Uj1BBq5ktYVQlfZAxXWlcWIqmEkUVTk2TirCxzn6+c
	 wor7uG491QetYgrTg8LmaAYyF4YRc+EZotRiebpurorfxlHtiL30svmN2zxk/jzQZDIeV
	 NBOtgDxwRgcZyUSIN2Lx5K0NIN9a5y+jSR8UYTmYZ2bf2r5ZfJbTEenkXlDT7+WO2tVSv
	 hUxl3ww9MejVGYIxULyWbZ3KMIcSDrFdNFN28EHa20akl0fz4IXy91YnzveyvDgwzWnde
	 xIclLjtg5QLYkNF+O4q26IPjmKoTvNmomM991Yr4AxY5BpxcjL8eKTS9260NTnoElUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wNbMlaQC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE30606A333;
	Wed, 18 Nov 2026 18:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wNbMlaQC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 290FF1F000C6;
	Wed, 18 Nov 2026 18:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027839;
	bh=dpNBj7/JpkjCkuTZRHJxB0bm4MUcYWwQo8UqKT6bAb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wNbMlaQClwCpjvRHQEHkKegNB66Y4KQOPnoaU7sdvYCPWvIcurdPSpFMQoyROU3QT
	 kGzmzlhV3ZsvXVp5nvJQVT/0nUQOCXRL5jlMd9XP8Po/4wp6O0DSNL66KxMDZuzx3W
	 c//zTgd+cBHw0uCwgUyLjjm/ZVITCafTiMFpXIaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dudu Lu <phx0fer@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1932/2151] net/sched: etf: initialise the sock_exterr_skb before filling it
Date: Wed, 18 Nov 2026 16:01:07 +0100
Message-ID: <20261118150232.156645074@linuxfoundation.org>
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




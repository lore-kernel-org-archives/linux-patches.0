Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032475;
	b=p80lsvjCn0B3f+lE5mw5SHP8aauh1HJkrcpmskrH2a04BdVOMKyq9k4jQg9qOHoLOb0X
	 keA6lkHpRZQ1PgpdYbSkEXkLJr/jPnDVDPxX8hYvaALuA0pGDjQdavrjQbdEWQzC787AG
	 oa3LeRhVmjtMwFCz/oEKRNfPryhHk4zbrosfXnAxR1mCfKbhWQZsVrg/gMF9cOjFovOsE
	 2lbOh9eedQEh55P8M4bRdoX6E5xWykwnzjin6Pjx+eEgn0r8EkJURMaJ9A4u3FL+kYIXO
	 RwedsaFq3UF8TOz0cUlvR7w/168fqD1/MY2oDAGMA5r1Y2K7yULu9S74BAVmRxUKQNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032475;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uon+Evm4hITU/Om95mNujAXPRzTNJseQ6QW46hGBaRE=;
	b=DtVmR0xYR4urAt4wD3okDnf5BQMcWUQpa4MGRYZaAqujh+0cYUgJiv4SkFRRx2Edbjkq
	 pJAylPXCL7286n3qQNRfuzs4/YXIRuFR/H8srHaQEKeBHR5Vow6XTkLnzXU6mwKdKESoI
	 S4fGZnw1aVumJ4gXKadgS4wtTx0TjbnmUqCJ2Bvr14c4brEVfMWBo5m2Dq79Y/ZYGl6ol
	 fXuysW0Xmxhs4JoNfDGoqXouLnB6GrtzDcAeqgjIcF5On3Jm8VF1/UpR7SARTlHbpJFLP
	 R65ggp7ySYLJsquojD/0LDUrWG1FYDFXQ5ITglHQI/YMmU0xgUN2IKg9adHyqz9sqPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OQ3cUXdr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3EE1606A32C;
	Wed, 18 Nov 2026 20:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OQ3cUXdr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F04421F000C6;
	Wed, 18 Nov 2026 20:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032475;
	bh=uon+Evm4hITU/Om95mNujAXPRzTNJseQ6QW46hGBaRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OQ3cUXdrNGCCK+0w4bDyo2swoQ82ifKT1xvdFbkMiRJLVufU2GNkE5hiz+hKOcRZl
	 Eo8hzObhX0nUUaF+ca3epy2sLkXxUTr+vJ+3maPU4U1up3TS1bpP/gXUgroYAfxbM4
	 Lcb4BXcos+q9LHyy5hObDjeOg3PFoLHM5YLS3a5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1426/1756] mptcp: options: mpc: avoid printing uninit data
Date: Wed, 18 Nov 2026 15:59:13 +0100
Message-ID: <20261118150105.924038787@linuxfoundation.org>
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

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

[ Upstream commit a234ee8eb9a20d1a272f0d2ceabdb35165071778 ]

When parsing the MP_CAPABLE suboption, this pr_debug() might read and
print uninitialised values.

That's mostly harmless, but that's also confusing. Fixing that also
avoids some tools to complain about accessing uninit data.

So read these fields only if they have been set.

Note: this was initially reported by Clashiko as an existing issue. The
code has been analysed by a human and confirmed. This is a non-urgent
fix.

Fixes: cc7972ea1932 ("mptcp: parse and emit MP_CAPABLE option according to v1 spec")
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20261013-net-next-mptcp-misc-feat-7-4-part2-v1-1-1181e5d2fda4@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/options.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index b920181a6a139..0fdb7900dac2f 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -126,8 +126,11 @@ static void mptcp_parse_option(const struct sk_buff *skb,
 			ptr += 2;
 		}
 		pr_debug("MP_CAPABLE version=%x, flags=%x, optlen=%d sndr=%llu, rcvr=%llu len=%d csum=%u\n",
-			 version, flags, opsize, mp_opt->sndr_key,
-			 mp_opt->rcvr_key, mp_opt->data_len, mp_opt->csum);
+			 version, flags, opsize,
+			 opsize >= TCPOLEN_MPTCP_MPC_SYNACK ? mp_opt->sndr_key : 0,
+			 opsize >= TCPOLEN_MPTCP_MPC_ACK ? mp_opt->rcvr_key : 0,
+			 opsize >= TCPOLEN_MPTCP_MPC_ACK_DATA ? mp_opt->data_len : 0,
+			 opsize == TCPOLEN_MPTCP_MPC_ACK_DATA_CSUM ? mp_opt->csum : 0);
 		break;
 
 	case MPTCPOPT_MP_JOIN:
-- 
2.53.0




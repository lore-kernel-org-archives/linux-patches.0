Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050235;
	b=R6MIRXeYNE8iSLCHrlcsEga9I4w/SsAC+3U83RZNonAOJ5yKpjuiuAlN6BObcm8QLgGc
	 0U9fsMoVN609WKnPIy1PJM6rioi9J9FWog1bPHYJWFmK3QKAhIPWJk7BsP9rBQ8SI25uV
	 NQfe/E1o6VY/gOCSfGMUx81uhLvqIxfF8BZuSCYrIaPRrGVylD+bl7B0bgR2/+fSAHGD3
	 qhiM7v810+0zZ+hY0PFyyurFDLYRdSwlN0Yx7qgEegNBa/NudgNub+w5W565Gc9ZqipTT
	 rN6T5JW6mgZRTJtWlo4eABxYaxoIe8DIQFQ442AVEsnqmJoonpqgw2xLkDijedHKpVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050235;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GCo2kzHzA6RFb+PrkwJ6sBx1c1G01gD/xlKqD1YFJOg=;
	b=G716eRWeWJ3E6xQsBSX86IbBz5/sfAVAQvqZigmvClSXfoXZvwI+fNXLDWPDqEH7tkiA
	 zlesbYZnWxgEaHW/muuw40ju3GHx2nESrt7UBtNF/pzw9vukZ1eqvV4gu9RShKUBpeqjB
	 Fa7HB92m7SCp/kDty8BCxQwEHBtSivbc4s5TQcFij6cywHZeHTusCQ3Wm/euwQvzHMkGb
	 mfAcZMHVwqgCWEX3sjZSyiHeiMoNZc2S4nZvZuEbENBmAYQ3sFqP9yIRhuv1H7CkmZ5GE
	 AI2Ss0Hp+U3yLzdWqmAfPDZ2HG9ZkjqqVatDNAk72RIv20liCYS5Ti/BPj1hQuWVtNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vvIC25Gv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5C89606A32F;
	Thu, 19 Nov 2026 01:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vvIC25Gv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21A411F000C5;
	Thu, 19 Nov 2026 01:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050235;
	bh=GCo2kzHzA6RFb+PrkwJ6sBx1c1G01gD/xlKqD1YFJOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vvIC25Gv7X48UI/cui1m4EpukCTD6ztzIfb4Z/10UDRA4I9gZCr69eGDlf1MrZUrR
	 7SlA29vG/lBBdjw4yNmgK9ohyYKV6aPlfWYo3nYFyI8HSUlsQ9pNbSsd0wHFbte4dB
	 JeJS0ifdN0Zqvw/yjQ+jLqNSXkv+tUvx/fYHacMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2637/2857] mptcp: options: mpc: avoid printing uninit data
Date: Wed, 18 Nov 2026 16:01:11 +0100
Message-ID: <20261118150336.541193212@linuxfoundation.org>
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
index 79c5f731a5e12..e466d73f3f80c 100644
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




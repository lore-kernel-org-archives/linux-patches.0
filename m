Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042130;
	b=tXMH588T3ZBmzhtNClyP4Vdol7grLlCOEHI0Wun4dMLqLVJKVirr82ZHdc1MwHpwCt+t
	 GD43j904scR+94BzzhkAyEpCRZ1uLLAUKn03cVwSgPLm5AgUr+JafmZgTAzT4UN6iwl2G
	 olw0G3VznM++LNhh82MpHaG5HfQRBRkkN9JgfEIEkqwVwAOY75bmNkwkQfOALV8rTrpYh
	 l6lg2pN7zEr8ku/chYvKYbLeDHDaPJqyj1TI8IoN80oO8W4xJ1KbjcEcD96FYz1Y8vnzM
	 RqDUviS8/hbhO+Sy/McObhnB3qhGYy4aJtNFDiyZq64pgWGx9vGHa5i598tH1SsohJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042130;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ef6A8GfRuI2RVVxyD05ys2FDir35ClrMNHeNwjFgXm8=;
	b=SV8jHr/rYBbl9Xg+JJ1Rj/m5vAssGpGN7AgeQ7+UKfiEmViXGLP5Hwor903JqfpKdJwp
	 SMRnQlrVAVDadpR1/MBQ/WyOq4cdWSVcOd4N0hX4P3UDIom+bJI+lleaZi9Xx1Kt2hCMw
	 igg3LuQWqLIFrElUc87myH1Nd4bGOqTgVxTk2vRO0wKQjRKhEiJIBxG7vdPwjxWlyxvBC
	 COv6b+8u7k6Zc4ZTDvkbbISJuigt4Uz+VG/wCnv6OtgG1GufE3qBtVlNgxjjQPy0FIBeW
	 t8Z3yGNDxekrVUfIJf9+0p7Fo8xHb6b10Wux6zbEw3Au6ATMKzJLFTj5lzselrD8egw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1VPmPUWi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E594606A320;
	Wed, 18 Nov 2026 22:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1VPmPUWi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 601791F000C4;
	Wed, 18 Nov 2026 22:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042129;
	bh=ef6A8GfRuI2RVVxyD05ys2FDir35ClrMNHeNwjFgXm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1VPmPUWi6xt1P/gCQUUCuBqPj36DZDzNB80rQkq1gahQzDVnY7NdhI9c2z7TEFh5z
	 ZNJCw6ZMffKWYBse/WyLpTCJI0NM4rQdwuzrwWWb6baSbb7i6983lhY4INxghvObX+
	 7sLiht61j5jCLNv7tQwfdrO6Bl8mefH0k12OAP1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3059/3318] mptcp: options: mpc: avoid printing uninit data
Date: Wed, 18 Nov 2026 16:01:21 +0100
Message-ID: <20261118150451.904910112@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7bc2a3a4cd3a4..a79a4922c6108 100644
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




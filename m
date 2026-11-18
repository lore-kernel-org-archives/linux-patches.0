Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027451;
	b=gLs0fn6rXZRq8/9BhrPuCPiZw6XNGd2L6Qn9rywD/wFcJ4grxwEO1Gih04eePQkJ1UyG
	 Ul+PXgi58GwhVt1Nz30NQcsml4Yvwq4w1qDHW07uocv6GT/v2QlZGUutR3bgi7tb0K5qI
	 XS52xYaL2CkKmwa0tDMYjjQOx+/jN8j+6eJR1UyxEGceOmGNi7S0zIxHlSIRgYGdl+jG0
	 cr0ta4C3xYTV95AVeHx5mid4RTuNAkh9tZGNe/3M4aYgfTh5ZHJqjD3WzRbNtH9FXqzrv
	 BCS9tJ+e60j4WuwqODgeSFluD+hltuM8z7rXl4HPemoKrK7kC0jGFif3mynWw2lBg9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027451;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ty5V2cMH3RFb5sj3/z9MnKm6E15xcZ+FKx0IsNvKCbg=;
	b=0a55mpUffPFCM4N0ntqQEPPGUIUhG6Mn660t+TgJxYBqBxRmFgUIwn/LSXnVCOdjPcqa
	 s2aHIS7tJfytCiqTulEKOSWqCJpHhiQoccjZaBIOKOYJ5baJ7pfad6wu39CB6MkcIlHn1
	 6DO3dNsp4saSX6CX+2DVXBmZQ2lMQ/uy1zR8QaZQhfiUs0scQFRqFuquxD6uQWSP9umCr
	 9NIo8XqyVn0dRLqGOBtfbwpx2dBFtqZ5YEgYRIWscssGb09G418mvTpQBIL/FL5CeAxGX
	 5bIJTHIk7sWQe45wNeooCpR20+JTJx7s1BQxpVAa37i8/wARrj943hyd6cUjQ9H1nRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="P/9naGgz";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00FB960A2612;
	Wed, 18 Nov 2026 18:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P/9naGgz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 526501F000C4;
	Wed, 18 Nov 2026 18:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027450;
	bh=ty5V2cMH3RFb5sj3/z9MnKm6E15xcZ+FKx0IsNvKCbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P/9naGgz06SqS2eUxeHEBOq+QrKbdLoAKJbI/VEJjD0RnTLgG+v+TeErHNeERt/A9
	 YbScNQPekta6hoaCUZq2XXDLaDx/wXoCHFwNVyQz+gTW7RuDoI6lupMyW1cCiyExtE
	 ffHselSMTnLmyysjcFsfnuvcwlN2MPi7CWM03L4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1795/2151] mptcp: options: mpc: avoid printing uninit data
Date: Wed, 18 Nov 2026 15:58:50 +0100
Message-ID: <20261118150227.199110180@linuxfoundation.org>
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
index a7f048afc8440..c53d212156303 100644
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




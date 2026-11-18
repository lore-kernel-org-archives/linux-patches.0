Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056639;
	b=bc89kXN25tuKmEA8sK2/2ussyKtriPu5WvCFjKYGhZ7R42Y9xLT4qdabBTafmQxdFLKO
	 +kK+BHj0/Df0E+P9yoSFwV0R5MLXJwTkTlGWjobXghFplGFD5ayfnF0v+D5gyeJkK2vud
	 cVxqQ5pONVTaK/0XEgD9+kuKoky0i6LZ6PyZ3ELF8i/2I4q2jFmXFb0xCg6DhuBQhCaDa
	 7cJe1KO3Vbno7h6mnKzH2xS7zPvtA2IuaCZoXhlSp/GNLxL6zuuz3kH6DdyIk89tO1eQ/
	 i5izskEpY+4a6O5EoLTqlRhrGZ+bstBY6QTcj54RQU5DvnWpUstwZyxzt04K88KD5/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056639;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AGuxnL/7CefFxnizlKEGutTCm+MJUY98dXYH48IFq6U=;
	b=G0b0aP9JOEysc3sp6xfIWuCX1BKTmv7g08x2Mid/gUQy5YT2+6R+H5VJXyp5BKzH/MUK
	 GAzKcZT8KMrVyP7CB6nZHbO/+WAnlgReTHwZyw1jbyBK50P0THQ6AaGCDa90UPBVaxUDt
	 xigI6EgoXeKr+WSIBsdhUBcE856gJ5ch4O+4b1AQi0mQ9E1nvV55alBjGAJJEc/xKEqBP
	 PkRaK7h3Z0/rOfQCUxdm48fh3S4ukLUfA+0KtzP+BxvrMnMlZmlU4N+ZuQG1JtTAGJE+o
	 4Rv8Bho3Pq4Hmu7gjx9ziz1LUDcydgECsbcPZwwJqxHzkTqcnuCyREG5a4uwz3Pl0uA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="SyQZ/EK8";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E2E606A32A;
	Thu, 19 Nov 2026 02:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SyQZ/EK8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44AE31F000C4;
	Thu, 19 Nov 2026 02:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056638;
	bh=AGuxnL/7CefFxnizlKEGutTCm+MJUY98dXYH48IFq6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SyQZ/EK8zkJ+Ky2h8pDJPfxjrRVri76MyoLcKuKTEOvwLVMQAk/gDEgBny1xUeUlP
	 Ra5zAOn5FlsjWBCWm8QC0WOEVFtYOqit5byM7N7iQEQtsx1SB657kRj6UK/L3Y0g/3
	 9vnCZAIhcvO81NeAqXnB7ILpz7azh3HOS87hHtxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2059/2214] mptcp: options: dss: avoid printing uninit csum
Date: Wed, 18 Nov 2026 16:02:15 +0100
Message-ID: <20261118150133.040061990@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

[ Upstream commit 00e2690c9dad0e09cd2a4435b98de6d8efd5fbc2 ]

When parsing the DSS suboption, this pr_debug() might read and print
uninitialised checksum value.

That's mostly harmless, but that's also confusing. Fixing that also
avoids some tools to complain about accessing uninit data.

So read this csum field only if it has been set.

Note: this was initially reported by Clashiko as an existing issue. The
code has been analysed by a human and confirmed. This is a non-urgent
fix.

Fixes: 390b95a5fb84 ("mptcp: receive checksum for DSS")
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20261013-net-next-mptcp-misc-feat-7-4-part2-v1-2-1181e5d2fda4@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/options.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 0dc5de6569fb4..28bdff9ee8e3f 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -254,7 +254,7 @@ static void mptcp_parse_option(const struct sk_buff *skb,
 			pr_debug("data_seq=%llu subflow_seq=%u data_len=%u csum=%d:%u\n",
 				 mp_opt->data_seq, mp_opt->subflow_seq,
 				 mp_opt->data_len, !!(mp_opt->suboptions & OPTION_MPTCP_CSUMREQD),
-				 mp_opt->csum);
+				 (mp_opt->suboptions & OPTION_MPTCP_CSUMREQD) ? mp_opt->csum : 0);
 		}
 
 		break;
-- 
2.53.0




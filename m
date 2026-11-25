Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618705;
	b=jzPt9Rm/05XtRWcNt9INMwxoeIyIhj7KWD9Z7DWC+CdCCaZk3KvgJnMhYtE0ER1xtumY
	 kGpyllg9L34cbPmXd1NPQAlskOclOZ3X6f6pPS2g8bFmee/W0r/mD8FOer/1wUYw8Yfm+
	 IYvYL1e0MURj8l6HHXZndHo++l3ZTEbjX5Q85iTILIF/uKdW1rOJZzmZgF1WJC7wPtH/X
	 oDuNNaycmZf5T8nlekRsWv6ndjjfndQ+Nrj9zmIwRppuHen+lFCOVtOfHXguWo7yAqoTN
	 oT6tQw2GglESN+buUFSGPCmCw18VqvYh8RLFUah4WZfI67Y9FfdUEZQN5heKvvZWQdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618705;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2S0TDq0bK6h0DxlSjti5HoLhRHXpY9UNjWAfWYfwN0Y=;
	b=sjG/gGu6Z9ErmvqtuuP+w0qLL501SFewZ+kgMr/SsHREF3fcosS9qaR9yUoC273WDE1I
	 VphukPM/Mfh9B8hCQP/JyLYgktPKhRaKnvVrOqHJhcXCvBc2SCUAsyZbU/6Vi0p7uLopC
	 sxt863pSTZ6+gXTbfn4svRT7FsDsg9JokZP/gJ9aHbGn6CPDFS9J2OnuwuledQVpILhQZ
	 Ef61JVmJSi08Tq0MC/fUiGsoeJTxx4C1al5I2Z87b/O3CZY2lSmBRXMaxtrT+yTU8Lm/u
	 5Fh1h4KQcCBW3F2XMrrGfrE8h0Drcs7oivTHDQ9sgf+ncAX6Mv9ovKJDVYpkP+Giyqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=itIdFl3r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0156D606A31E;
	Wed, 25 Nov 2026 14:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=itIdFl3r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB9831F000C4;
	Wed, 25 Nov 2026 14:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618704;
	bh=2S0TDq0bK6h0DxlSjti5HoLhRHXpY9UNjWAfWYfwN0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=itIdFl3rGmPE2GOnVvYxfdTswvNekQl33v+MkbbuCOuw9JukKPHMxhJMurdQaYSRo
	 YP4MmNmSyN9NzBIdGB6iZHgE4KNO9h3B1+mCZW7+5Acr0/uJ4lJ5JRJqqcvPeKypRY
	 HtyZQmkNI5K8Ysl3hJ9w2SzVxFix7NfRWrhb6Acw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joas Antonio dos Santos <joasantonio108@gmail.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0317/1005] netfilter: nf_conntrack_sip: fix OOB read in ct_sip_parse_transport()
Date: Wed, 25 Nov 2026 15:27:35 +0100
Message-ID: <20261125143829.163720458@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

[ Upstream commit 7af52bda65c0bbbf40894aa3df36ac1bb5697984 ]

ct_sip_parse_transport() compares the value of the "transport=" header
parameter against "TCP"/"UDP" with strncasecmp(..., 3), but it never
checks that the parsed value is at least 3 bytes long.

ct_sip_parse_param() returns matchlen = end - start, where end is the
next ';' or, when there is no ';', the end of the payload buffer
(limit = dptr + datalen).  If the "transport=" value is only 1 or 2
bytes long and runs exactly to the end of the payload (e.g. a REGISTER
request whose Contact header ends in ";transport=T" with no trailing
CRLF), matchlen is less than 3 while strncasecmp() still reads up to 3
bytes, reading 1-2 bytes past the end of the linearized skb data.

Add a matchlen check before the comparison, mirroring the
sdp_media_type() pattern a few lines below, so short values cannot reach
strncasecmp().

The bug was found by LLM-assisted manual review of the SIP helper's
parsers and confirmed with a userspace ASan harness built from the
verbatim parser functions, which reports a heap-buffer-overflow read of
size 2 in strncasecmp() called from ct_sip_parse_transport().

Fixes: ea45f12a2766d ("[NETFILTER]: nf_conntrack_sip: parse SIP headers properly")
Link: https://patch.msgid.link/20260815133104.50369-1-joasantonio108@gmail.com/
Signed-off-by: Joas Antonio dos Santos <joasantonio108@gmail.com>
Assisted-by: Claude:claude-opus-5-5
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_sip.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 64bc440b1181f..b05dc8858d094 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -701,9 +701,9 @@ static int ct_sip_parse_transport(struct nf_conn *ct, const char *dptr,
 
 	if (ct_sip_parse_param(ct, dptr, dataoff, datalen, "transport=",
 			       &matchoff, &matchlen)) {
-		if (!strncasecmp(dptr + matchoff, "TCP", strlen("TCP")))
+		if (matchlen >= 3 && !strncasecmp(dptr + matchoff, "TCP", 3))
 			*proto = IPPROTO_TCP;
-		else if (!strncasecmp(dptr + matchoff, "UDP", strlen("UDP")))
+		else if (matchlen >= 3 && !strncasecmp(dptr + matchoff, "UDP", 3))
 			*proto = IPPROTO_UDP;
 		else
 			return 0;
-- 
2.53.0




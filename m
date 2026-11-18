Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027400;
	b=eD7AjrAeXlLfqjd2St/mksH6WV/SRFtZakMnpT5Q5JjPdAxTDTiOtzFhA1B4/x8esVOD
	 PKSlZfe/r2qoAleKzEF048Lp6AXgGRg+2VeIEotGFektQNxiBg1pq2bcdN31TqlTefrLe
	 qPAA327IJVjbD0Hl74nPSOWoSALsaBYCao/FhQwDihpEUudcuCMnIaD2ZV/ZKiq+/vYPg
	 EGQvkPsQ4U00h38BuVLPaVtyitw6JZEvO/w6W8f7fO0QdUGp5bipi55y/vQ4g22nv/NVR
	 PxwJn8YlcPlb3j2yP1+8Jwm9/YUKchY+oAz7Qdon8EtO5R7LKzEp+1RbPfLOGNtkoxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027400;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=A6FrgIfod6+5KQ0I7DkoU3DM3Fo3gEdW32AmxGdAcmk=;
	b=FIoAgyVMXQ1Z1LyNm5KnYWXIGh09Vp55Ge2VoskQtSWAbpLYdbMzjlvi1ejwqiooHYON
	 8c5whVjHpQp/D1A86/binNCRa8fPGZtXFpB0xWjf58kgzpQMQKtvklySe4U+qfb7q04VF
	 4Z5WmQ8cRhglkEIHV7Ryh6DwZtN4gBIUrSH8HxE3V0EDJMLBI3OEFuFUO7SxVjhuRR8CC
	 zHvMtvNNrs7uCz5xjYt+D7/jNWA/Jf5ABspveJ9pLphVQlmejSe/dcTvYwDVoQVLH658g
	 K9tbNu8ZHzlRS24IpmXEeG7tLvh2O6vsbyhrvaIfEnyvNStXxjpa5zUivzqNzvTPyvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dgVVyCp1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E3860A261B;
	Wed, 18 Nov 2026 18:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dgVVyCp1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8E9D1F000C5;
	Wed, 18 Nov 2026 18:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027400;
	bh=A6FrgIfod6+5KQ0I7DkoU3DM3Fo3gEdW32AmxGdAcmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dgVVyCp1gMrLyRL862+WChw5Dxx+UeMHfwLwk7DjwM88mz2HpnJTk1x7iNuOa0h7y
	 BY3UggPA70Eq7xtdA33Vb1CjPmSd7d8L9nAY1wzJf311Zuf5W2PhuveGhW+JC3Bveu
	 q4qd96+MxYUDotqbTa+DnUoyqNsKPLqH34vsEI9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sung Byeongchan <tjdqudcks0424@naver.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1774/2151] netfilter: xt_dccp: handle reserved options as single-byte
Date: Wed, 18 Nov 2026 15:58:29 +0100
Message-ID: <20261118150226.453701916@linuxfoundation.org>
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

From: Sung Byeongchan <tjdqudcks0424@naver.com>

[ Upstream commit 2edda78aa4eb04cd8f112a81897510ee0cdd7099 ]

The DCCP UAPI defines option numbers 3 through 31 as reserved.  Like
Padding and Mandatory, these options occupy one byte.  dccp_find_option()
only treats values below 2 as single-byte and interprets the byte after a
reserved option as a TLV length.

This can skip a later option and invert an XT_DCCP_OPTION rule result.  A
local production-hook fixture installed the same DROP rule for IPv4 and
IPv6.  In three fresh boots per kernel, a target-only packet was dropped
20/20 times, while adding reserved option 3 before the same target let
20/20 packets reach the protected receiver.  The fixed kernel dropped all
trigger packets in three fresh boots and preserved the normal controls.

Treat every option up to DCCPO_MAX_RESERVED as single-byte, matching the
protocol definition.  Triggering requires
CONFIG_NETFILTER_XTABLES_LEGACY, CONFIG_NETFILTER_XT_MATCH_DCCP, an
option-based rule, and remote protocol-33 reachability.  The touched source
is unchanged at 0c2669a9f4a1d607e7591ae50ccf3c432a0aff08, where the patch
applies and builds cleanly.

Fixes: 1d3de414eb20 ("[NETFILTER]: New iptables DCCP protocol header match")
Assisted-by: LLM
Signed-off-by: Sung Byeongchan <tjdqudcks0424@naver.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/xt_dccp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/xt_dccp.c b/net/netfilter/xt_dccp.c
index 037ab93e25d0a..bab2fd6dba5fd 100644
--- a/net/netfilter/xt_dccp.c
+++ b/net/netfilter/xt_dccp.c
@@ -62,7 +62,7 @@ dccp_find_option(u_int8_t option,
 			return true;
 		}
 
-		if (op[i] < 2 || i == optlen - 1)
+		if (op[i] <= DCCPO_MAX_RESERVED || i == optlen - 1)
 			i++;
 		else
 			i += op[i + 1] ? : 1;
-- 
2.53.0




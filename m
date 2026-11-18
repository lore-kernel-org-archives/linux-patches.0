Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032437;
	b=Ij+slKDJiQS91/x+etSbnJSTAv6HsZj7/VfOyeAiHXj9fTshdXU5hL2eLIKga26SMxXd
	 lcF5JfKvIdBgksvVBizys66wW4EV2+d7kLM05J/6jhRns/ULXnRFRh5W/6ZkWUG23aFe6
	 uTrrZA5d1rnlwlJLRKx2XoljNmgJ3UFXR5Q+mpw8vRv6uaZ6uBri/ORrjvw4Hg7CLYcMS
	 gPruzHtZRMQ2BPvkM7UZOfb+FwuZp9aGpew4jWx/ydStKbCHxB/0dNzxdnRgGd1AKNq9F
	 mHkEWJcD2AH45umJ/DpKeKISkcF6fput+6H0J6pKKM//r1WGl78ARrs5qolNMRFBLnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032437;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3Obk7sRXZSL0y0KFbeQUqavulBgcnvB39Ictseefd/A=;
	b=ZQG6FQqT4SToAfr32k3QCPyqt8/mcLl+doOLu5emEvoKCWzqiannLWnTOGwrhAmAB9cq
	 hU1ZRwBOVoXxR+nXzygL/boHIzdW5tAKNt1B/jRalBazQA9FAxHyVlY92zTBsNAsJ+8tq
	 it6/i7z4/J13XLmzUUatjtjs4SpKi65YZTnoExSTsEqcTE2N2VPtGnqxf8TUaGJ6Jq1Xe
	 97nz8PGZa6FVv6LEsZRYK2iIEAtTgJWGK+gxD65wh95CiOUGHU/nfXCJqegWxkzjjC/WE
	 zHQOTEV+hy0f54NWYy4lSwVLRtG2tuWAFljiokLwaGx+XLthCCpryIIDbpZ7RNyqrYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZoxjZHhw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4F3606CB24;
	Wed, 18 Nov 2026 20:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZoxjZHhw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA3A11F000C5;
	Wed, 18 Nov 2026 20:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032437;
	bh=3Obk7sRXZSL0y0KFbeQUqavulBgcnvB39Ictseefd/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZoxjZHhwIQLae5xtieKr1r951l1apOsf+940HIm2vuiqZ+YNAFdxHloxe4kmtGII2
	 qq9jMCrEgNu2FQZsxL6Mi87jbDjqoQngFrcUd0nzdfnEJycRZGuixSWlNqMaDU2nf2
	 VG22fRqFsChAB/di/9sqNOmOBrXtruXuYbGy16iU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sung Byeongchan <tjdqudcks0424@naver.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1410/1756] netfilter: xt_dccp: handle reserved options as single-byte
Date: Wed, 18 Nov 2026 15:58:57 +0100
Message-ID: <20261118150105.340891080@linuxfoundation.org>
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




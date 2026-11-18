Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061922;
	b=14cpdDgqs+tiAs5KzgY+PuL9SXwmUEg+vp8zAb9dUwnuVzEtZJhpfmIpYIM7aHpj+62B
	 /fLf9ro3KSfWbjtRSERfEl6pN54ywrwz+XlnGBAOit+XblX0+GFHZ99V5PJyz5UvdzlWZ
	 74G+VtYkS0zImJ45ooi/zm/8TEf5hEz80oeBaTRZpSrjHaJmGR6o4lRZucauh+dEOH10P
	 th/zM6X+M33eFwP+/9JIJyHgL5OAcn3CBosN7wYYreTuV/MhG1K7kvI7VYf2n7BBNLjFL
	 4vIPjXvMOMxZHHOTovWF0giNgvCBVlQPzbuQKSr/x5WSDr3RS+cLApGFmr/LOYggalA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061922;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=et7Czb2rhwNqzIYGbLGmlpTuXfrcm/gfqP0u50tQIzU=;
	b=rl015oAIXfo895wJRLbh2qoGiGgaoMrs669Hq7aXXvuootWKG3KGqQY6bQqf/pByyqdI
	 NXD8SCNgJ3a8f6lcBID3ArBEyuEtpR02VfrH1nWpSE8KdLwI+XoDiKUFSGdKfLtC3b5g6
	 D2lr+Dper8V9kV5Wb5+Al4JSWFhfrEefk826yCsCR7/1LN2KTNiu5kylQu01Nzfjir3dM
	 SuZxT1HmUXou4L3KZjwL/qcSNrRRcWyppAMb9vQXCKSmAtGetUHOoxfDAQGfqbR0em+0f
	 6dGGMRLYMIdQq2tAznSij5Sp3bcKroKH/O9I3Xz0UBdMy2e0EtWz8spzfYMQguR6oLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VUzxXXb1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF3A606A325;
	Thu, 19 Nov 2026 04:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VUzxXXb1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 224CB1F000C4;
	Thu, 19 Nov 2026 04:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061922;
	bh=et7Czb2rhwNqzIYGbLGmlpTuXfrcm/gfqP0u50tQIzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VUzxXXb123R6yWJBxiViijJKrx/ZgYiROH4afbbSGub8peGmdessWhhonpbuzbMT3
	 DMH2s574xpz5b260OeXzYNStuBS1vWkIGLFitwu1tDoLoDycMWNmgPdIQ7yYL8j+g0
	 M41aN+E/uXxOZz/VQMDIkRpvx74O700++tj0AbuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sung Byeongchan <tjdqudcks0424@naver.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1724/1848] netfilter: xt_dccp: handle reserved options as single-byte
Date: Wed, 18 Nov 2026 16:02:42 +0100
Message-ID: <20261118150031.799126616@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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




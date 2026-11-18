Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021032;
	b=DowFsUet6rc2JPXWV/OsJUQvIIb4Ww1b6ePpFnfe3bWcAsxtX6tf1Ka642fX3zKXzWRO
	 sNRjavJQ0picdaEDEwKciSHegU6BERboH/VUQedc2CCDQz42oC6YNxFCw5kjyXaLplY4s
	 0LE1QZcEeFb622Et5ZswqXPTP1wjevL/yU9ScOSp4gYFGQvOL4Yru3lHznguW79ipdHC8
	 wnX32QFwlxMGo56Z2Eqfsvq8FN6rQ1Fcf5w7y6Tc3lmfDRPoFgzn+shhn8g7Z0ACAfuF+
	 JkcLMLmg8siYW4qrkBifANwyvPXfoK8z0O5WfD/bCVfniafz7Wnq2jWWEP/gOS3y76Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021032;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C2f1SVLLph/LG1I4IP4U9ShzIKDIY0BU71U6i93Kf8E=;
	b=uCQ2cXJxoViMK9jk7EIp7/cWQ3MGJ3Ia3grOupsKygsYjhcw7XTv0nYFrFdSGepWyIP/
	 pyz45YjJ5txA1NGFs5v2ttMvKeHSbBum8FkGPK1lwn5qnr4iN9TwYph1SYqKSYctJtkRp
	 kw63gY0ILz2HCz2q+Gs/AqHNUn5zMknhdbZQ+f6Uc/XRe/u9YWRfvplUBxGTfX5ac+5ox
	 nNBGif17gHt7KVh/EyGXbDOrXhwhlYo3Y/A6RJnT3j+fc2UicN0gsHal3XVNm5IOPdYLS
	 snwkLSSM8qWy/ceUNe/O+Wvgmfn0tgtBu6mt7nn4qwv39UTITkjJz5v21KXewzUnx3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B0JyUozY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E88C606A320;
	Wed, 18 Nov 2026 16:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B0JyUozY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC6AC1F000C5;
	Wed, 18 Nov 2026 16:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021032;
	bh=C2f1SVLLph/LG1I4IP4U9ShzIKDIY0BU71U6i93Kf8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B0JyUozYjfv5lMAb55/Y/I3/OkNvMy2ZI+MS5/qiRoFjohjUAWsIM1Sniwp++rHhk
	 OccNDNXwNh7ByP3lVwLQ19eax0zEch+26SMfx5kfPo3visKhmSHxUx+cPkamPlmV3e
	 v9rmw0phGt9PTkeW345XZdv2MOUwjO7Kr4C37vHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sung Byeongchan <tjdqudcks0424@naver.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2163/2651] netfilter: xt_dccp: handle reserved options as single-byte
Date: Wed, 18 Nov 2026 15:56:43 +0100
Message-ID: <20261118150403.691079603@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 3db81e041af9b..23a4e3e8df7de 100644
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




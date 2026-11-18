Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050311;
	b=LMJLhrvKrITD1jFcLbSjU7DngAarjxIXZx9WBgroYjD0EtsCHGaUnFesewwxnwEw6Oe6
	 8QOJ6dlIKhoP2IkKYIuwDBY7TFMkfiCr2RpQ6rzNV6r8b08Z+47Kl9Tp89Gw+6LO41/Dc
	 +c+q3J6M4KnWWfO3hcYZXVUpZDA7Rvtn8vMNmWxMEdCu3pYUTOA7cmHZWWJTX9GKcOR/9
	 2hlqkuVBv8YFvVhMMkBDsbUyiReSo+os7hRPNfXQr73505h4FebHfBdmPRWs50fHvMJQI
	 8xmSgB754cE6ds2DdwpTkCbZ1ozn5P3n+hcBIS2AL2+/4I/QrD6AxuYpPZ/BgpqPjhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050311;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZSE/ZEUv/XUox0BDrLTcDcDek/FAGn3zQ+OL27cZtw0=;
	b=dD1msrGSPujYBaYjFDHFge8iaIEf/GCC5s90sEjkxW3aFY4R8WWcwia8GElFx6QLdORW
	 +Mz8m9yP/7jFYiZbvIuLTUKDZ3Qk4Dr4QIAU2xweDmz2+k1byuk8+49IWD2O0RUbtpjYb
	 tZA3jFWN/yRaGqDwMOkVlfyLGn70qXKPWkOtNDb7Ws5iom61fn1s7L+OxQANgVybbZmVD
	 Qh6NFKskq6gnnTUtNyNi5sC9aCXMSfty1quiBYSEmKVMwzuSLXhCtD9xX6j9GIXVl9mSw
	 oMqVBu03YMSjGX7H9JFxFuBcxjQ5nsfMNmbhKJcy6SlVWJf6lW5hA35CF898br0BknQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="0vJ/CD60";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C273A606A338;
	Thu, 19 Nov 2026 01:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0vJ/CD60
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF0DD1F000C5;
	Thu, 19 Nov 2026 01:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050311;
	bh=ZSE/ZEUv/XUox0BDrLTcDcDek/FAGn3zQ+OL27cZtw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0vJ/CD60AiwF6vlgiEbO11T3rbU2Lp46AS3qhBgbv1Zp0nmdzOYJ09xI2scAQqbH0
	 hYnpIq0j8h7Ubzu77YUB7JIaJ3uu69Iy9tynBZa+s0F700wWWhGG2z8iZgmrEDuYUQ
	 W+7HWieRVakyji1fSCNMq5QPCaF7eF8lcpilsRYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sung Byeongchan <tjdqudcks0424@naver.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2626/2857] netfilter: xt_dccp: handle reserved options as single-byte
Date: Wed, 18 Nov 2026 16:01:00 +0100
Message-ID: <20261118150336.123544168@linuxfoundation.org>
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




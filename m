Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705366;
	b=N1Mw24VkEnv9FVuB8LsYyZaBFERAGgyQgHWXsS9+Jtgv/q3ETQxCpItnCoF9tu60wnms
	 qALD9JQiemQd3073hRJ2DvC2ADc4dlO2HgttI+V85D/uNGewpUCX8QzEfBl1X2aYLGBy4
	 gRYD1msiQo0VgUGd8PsC4EJ2GDF3VUQOMlSP5GU2F2rTCqW2qdHmBCxRzLefi/tHV9rV1
	 noa3bWi8qUzu/cAc1LavpDiL3URG7tAoVMMF/6tEhJ4J0H9Z8Ui36DmxnXN/JKiE0Th3R
	 9/8SbemISvzpalhjTGptK3GtDbNxcEnLkr9Gk8ykdlRoF3uH2c/kmWGWuovxVQOmcEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705366;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=I+ClMrjnAlB6XREIiWOY3SlvBLXonsaoT3DAd1lC9lI=;
	b=HZNAr5cjxRlCV7SSxiK1uts6JaVd8kJE6mos/yaF/mDcaoaT1gTZxI/Q4naUznG2uAg+
	 E72XiuwkfevR3wMQtlZQhjZu7NGazEbYeehNpTCX/pjZRLodMU5BpGWapgHPGzl4R3Qew
	 Kv1mKwMCMvomenQA5MgdH6wGYcJucSYCpOYPmmuxB1MaRgDZeyhkY0+Onb3iAMmd67JxA
	 aN9oMelcoIicKr6hBmvrhWxfAfhLkcY4t3lz39SqKWWgMnUZ5yUBwHzuci19uLdgK2nF9
	 QdcnhbrXX5w4Yx/1zLcaqv83qHtsvecC7fMarW/TJ7yUf5RuVcOLGs+MQ9n6EkvorGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q9Jj2t+Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0614D606A32A;
	Thu, 26 Nov 2026 15:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q9Jj2t+Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0B901F000C4;
	Thu, 26 Nov 2026 15:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705365;
	bh=I+ClMrjnAlB6XREIiWOY3SlvBLXonsaoT3DAd1lC9lI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q9Jj2t+ZZh8qdiClsn+GoNHZaV2qlCzBiY1CJjL8ZPlybtzWqB9k0rgg4OTzsKLbt
	 6Sb3qImEEGznRh4dhpSsvYneXkms+mH1SNi0+IqQcy3M+Wd7lbeXZidYPhmDx6blRB
	 ouHq5fkDXMBOpirU2MKKXwvMnmAVYRJ04TfpAgyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abaci Robot <abaci@linux.alibaba.com>,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	Simon Horman <simon.horman@corigine.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 128/319] ipv6: ICMPV6: Use swap() instead of open coding it
Date: Thu, 26 Nov 2026 15:38:16 +0100
Message-ID: <20261126144009.632220334@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

[ Upstream commit bc61761394ce0f0cc35c6fc60426f08d83d0d488 ]

Swap is a function interface that provides exchange function. To avoid
code duplication, we can use swap function.

./net/ipv6/icmp.c:344:25-26: WARNING opportunity for swap().

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=3896
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20230131063456.76302-1-jiapeng.chong@linux.alibaba.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 30c71476d842 ("ipv6: Check the Home Address option again before its address is used")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/icmp.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index fcfb0f79b07ab..9b04293a6d2b1 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -336,7 +336,6 @@ static void mip6_addr_swap(struct sk_buff *skb, const struct inet6_skb_parm *opt
 {
 	struct ipv6hdr *iph = ipv6_hdr(skb);
 	struct ipv6_destopt_hao *hao;
-	struct in6_addr tmp;
 	int off;
 
 	if (opt->dsthao) {
@@ -344,9 +343,7 @@ static void mip6_addr_swap(struct sk_buff *skb, const struct inet6_skb_parm *opt
 		if (likely(off >= 0)) {
 			hao = (struct ipv6_destopt_hao *)
 					(skb_network_header(skb) + off);
-			tmp = iph->saddr;
-			iph->saddr = hao->addr;
-			hao->addr = tmp;
+			swap(iph->saddr, hao->addr);
 		}
 	}
 }
-- 
2.53.0




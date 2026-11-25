Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624939;
	b=nLzkS2kjEvN5LOiHIrwrxXFQyItq9ZLG843TUPDsXXriDLUX1vPBPQuYX9Xa+iDV4xMh
	 07zH8wx8DaLJ0Oag778RpcfYQ9CJ9MJkRpNSGB//qtcD+Uc7ywazWyHXSkBqsuP8lJBYw
	 uSTxIWZEsQjcMLmeHxVb9zo3Ar+IbnevlwCUt2UmOLOM+L4VOV+CDeEMN30fvpEWk2MRQ
	 3vl1ncjpHWdU+KZ07UIR7dcwKQcP5yjEI9y865gWZIThOs2GNDINcFw3haq9fc6QWBttH
	 ueyhCgYAterO3vWqzIQ8K/I2mY57JdmPPPgkd070++3rKIg3px3fS9BYIaINVcFMXWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624939;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YmEDafXbOxTnwHlcHZLJY0LuzIqDhnbZmG5fn51XxhQ=;
	b=pyl73RF4xScARYVCkmOv3OEkX5ckM32Ix0ZHoIeqvpVWqVSo490xx9/RgcTdb6LFxxE2
	 1W+3AQA12UviNvOyFSlhvjf3pwKP9185pD9xVpD7s/blWwp/Gen3bcLkRvLC2LLMfIJJG
	 kGy5Ys8ZplNFFANqVx98aSVmKBRqHOHCO4IDEqzH7ZwzODPUVIpdQQ9W9MmR+qaEtU0nN
	 srsVQxT3fzu2ey5JPdZB8ZRExxcOfLcW2HWvx6eGsbg+Oc4oMQCRZH2c1jv2zoVg9EUgU
	 10zZ9N3McTCo+e4D3Fn0DglInICpYZIM0MhrvGoxM61/EtOO84Z54/EJKLZqeS1UNHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nm3LOjvg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85D9F606A31E;
	Wed, 25 Nov 2026 16:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nm3LOjvg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E3061F000E1;
	Wed, 25 Nov 2026 16:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624938;
	bh=YmEDafXbOxTnwHlcHZLJY0LuzIqDhnbZmG5fn51XxhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nm3LOjvgpdzHAFobUN+fooa+dezD0HFf6GVAg3TDRDr+1AZLUXjM7AqloA245xhQ+
	 tOC3RyDRXTNTn1d9OSKVfvzL5jeIpgQqJ2vswr8OyernSg8Im9JXO63OQcMz2kY4z3
	 +EG+AFpZ+FmMG45nIc3wOPjq9USdmhVwG9jJwUDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenbo Sun <sunwenbo@cmss.chinamobile.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 353/816] amt: use ipv6_hdr() in amt_mldv1_leave_handler()
Date: Wed, 25 Nov 2026 15:31:41 +0100
Message-ID: <20261125143857.369075451@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Wenbo Sun <sunwenbo@cmss.chinamobile.com>

[ Upstream commit 6730fe495c35f174a424ab58cf5fdf99ce4746e9 ]

In amt_mldv1_leave_handler(), which handles IPv6 MLDv1 Done
(ICMPV6_MGM_REDUCTION) messages, the source address is mistakenly
extracted via ip_hdr(skb)->saddr into host.ip4 instead of copying the
IPv6 source address from ipv6_hdr(skb)->saddr into host.ip6 as
amt_mldv1_report_handler() does.

Because amt_lookup_group() compares the full union amt_addr for v6
groups, looking up the group with a 32-bit IPv4 header slice fails to
match the group entry created by amt_mldv1_report_handler(). As a
result, amt_del_group() is not called when an MLDv1 listener leaves,
and the AMT relay continues forwarding multicast traffic until the
group timer expires.

Use ipv6_hdr(skb) and copy ip6h->saddr into host.ip6 so that MLDv1
Done messages properly match and delete the corresponding IPv6 group.

This issue was found via LLM-assisted code review, confirmed by
reproducing the stale group forwarding in a User-Mode Linux (ARCH=um)
environment, and verified in UML by testing that AMT relay multicast
forwarding stops immediately after receiving an MLDv1 Done message.

Fixes: b75f7095d4d4 ("amt: add mld report message handler")
Signed-off-by: Wenbo Sun <sunwenbo@cmss.chinamobile.com>
Link: https://patch.msgid.link/20261111031147.105834-1-sunwenbo@cmss.chinamobile.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/amt.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index 589d44b31c381..3d560d5dc981f 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -2129,13 +2129,12 @@ static void amt_mldv1_leave_handler(struct amt_dev *amt, struct sk_buff *skb,
 				    struct amt_tunnel_list *tunnel)
 {
 	struct mld_msg *mld = (struct mld_msg *)icmp6_hdr(skb);
-	struct iphdr *iph = ip_hdr(skb);
+	struct ipv6hdr *ip6h = ipv6_hdr(skb);
 	struct amt_group_node *gnode;
 	union amt_addr group, host;
 
 	memcpy(&group.ip6, &mld->mld_mca, sizeof(struct in6_addr));
-	memset(&host, 0, sizeof(union amt_addr));
-	host.ip4 = iph->saddr;
+	memcpy(&host.ip6, &ip6h->saddr, sizeof(struct in6_addr));
 
 	gnode = amt_lookup_group(tunnel, &group, &host, true);
 	if (gnode) {
-- 
2.53.0




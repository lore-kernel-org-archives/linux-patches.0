Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622234;
	b=oPq+XI6siovP+s7s5vWL86PV9QZq8h4D1pVzsiynstrXTuTJSDjYf7+TOUpVXv2i+r4U
	 OOhlPBlM0KjiyHE6Drsk1XT0QERX8YIgjg3tsEhrnpHSa7k4Gmr4T1U8FugBxR888I3CD
	 ZH4cgU+MXl1gQ8ar0ydjh9Yg/sGqKdk4fk8tF5l3aJbh62mklkbXI3rCLuwWqsVPhxK5J
	 LnN1xEDHE2+UqVC1TnF0vw1CKsj4FhHxEgrKc4R8BjoK8IpdLYweSmpGzvYAsglzjrzoj
	 /8n89nDc2JWFQbhHUtZ/gQ/1PZzmyQEQ9i//as+cHLsBZXoOGhnI34AYO/hzyzNFelg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622234;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qaUFevb4hhAe1FSBqyKKVwWpHQ3xLzKBtuax6kQ9So8=;
	b=hSqojpK+0XSGTuw4SmjBGQEA6ntZjeNWr4wZSwxT+o3bGhXuVXT0GGC7egwUuk6eHMIn
	 7hbnO1T9tQJ9ClEgCOAx44C2gsU796JKgq1zchOHcWsAoh8iiiej/IiPaK/V/2rf5XZkX
	 iIhw7/JWca8HPpGjviMVPNvhUPmVFgnwSIbK54earcuklaLF8CwKi6P1xEsyTCt3RUJWw
	 WQpk6Mu/JstGlsX3su9cdssKSpa9MoTm1TF11MuzcZQRhcIhu9XC2XlCKUe61+7ki0Lqz
	 LL8wdaVF8vqce1Uy5Q3osxfswPYrn/DGV7BQzwBIGrydMkSALUl4JraY7UFj8pnW13A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kPLZ4f8p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D7E4606A31E;
	Wed, 25 Nov 2026 15:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kPLZ4f8p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ED2F1F000C0;
	Wed, 25 Nov 2026 15:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622233;
	bh=qaUFevb4hhAe1FSBqyKKVwWpHQ3xLzKBtuax6kQ9So8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kPLZ4f8p3Z22GEkBePVvlKyNeeb1kKPsfgjUgjq9n0B2WPG/TresDsziz7GbLDnyb
	 bAGxLp8QUE43rbqxLOPA0xraTtUygH5yZMWvITwG3efmmOC9unW/UyZLmakoDT26fw
	 AiaidPn8PZw9WNM2PPq2lHr718e/IJ30EYKLNnBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenbo Sun <sunwenbo@cmss.chinamobile.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 472/990] amt: use ipv6_hdr() in amt_mldv1_leave_handler()
Date: Wed, 25 Nov 2026 15:30:39 +0100
Message-ID: <20261125143833.151115068@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
index 2a8a0c0e78993..e577b205f37b1 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -2134,13 +2134,12 @@ static void amt_mldv1_leave_handler(struct amt_dev *amt, struct sk_buff *skb,
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




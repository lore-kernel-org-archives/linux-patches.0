Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619279;
	b=RsTYXIuWwwVsgXgUbBcoJuPwdujLhmrZYzLbRUENqwECN/UBchXygxb1UoYivnT1Zv+8
	 5W5Qo3tuMmo31rG+LHASrQco4QhevH5souhDNN8lWVOmEiIziU3DcNbU6DrvleBOoQq28
	 55w1WodoPcfbiqYiy1hJrN5jzQ1JueyZwnlLW8fdgrfmCvl4NwQPjmObqacc1eRMJ6D63
	 7I4ZT1/uE20zmfmghd+jgW5pwyLDZkO64d4riP5nF3lUzT+ZuFKYJQd3r0l76t9sKnp+i
	 hHmg15mPgw82D0yzNuosudfPxBxN1APrFntcI0z/3dTSqhocmRO/e1dtichlrxAb9lg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619279;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mBpWW61Z98BVoREUCTkR9dBKNartXnsZ9Njv4DshKxM=;
	b=noqajuho9262dVo7ln/NqxWlP2wkQkm/3Vd+Npe6DGOyqmcM1mQvJyg5fwVXbp1hJxqZ
	 4BrCwCNXuRxiNMnqrJ7TCRz2Jlt7ikHTRSQJs7A5YPE+T+be4fNsagqUW2ULA9LnODPWe
	 yDnCpq9CWZC4hcVcCaDsbd87fLf1k8IaFE3haEBM7A0akBqXMVZdLauDNUDRvM+wXucwd
	 wAhKs8Fq9r4vnvngmihDzXlDkBdd7HAsuqG0NfGY5lXR68RDNxonDEbrrKc+t40K45XDm
	 cKTB9DD3KhrdAiDpStXyGU6vZ5neiD04wI4EZv3p+w0zbfHqst30nZBZdJMSoUR5xIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HP9KbaGa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2672E606A337;
	Wed, 25 Nov 2026 15:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HP9KbaGa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41A3B1F000D0;
	Wed, 25 Nov 2026 15:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619278;
	bh=mBpWW61Z98BVoREUCTkR9dBKNartXnsZ9Njv4DshKxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HP9KbaGa4JGIw6oX65O0KS+tXrsSd8GSHM0JyS48DVHdVMT4WPWwA+D0doJEJ6i/A
	 lbmM5pa8EWe7DKDPzR6IFdNz+ZVcHdVrVnDi4/sYQu3YOZSb5OoD5mr11ZKxKjTw7S
	 c3SC8+airrva4Oqe2Wz/ewn+NEu+jQ3Q8wYnvGHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenbo Sun <sunwenbo@cmss.chinamobile.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0544/1005] amt: use ipv6_hdr() in amt_mldv1_leave_handler()
Date: Wed, 25 Nov 2026 15:31:22 +0100
Message-ID: <20261125143834.487826211@linuxfoundation.org>
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
index 1b6759dc846d7..4e51269de3ca6 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -2137,13 +2137,12 @@ static void amt_mldv1_leave_handler(struct amt_dev *amt, struct sk_buff *skb,
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




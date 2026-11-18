Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059433;
	b=E25RyclylEz0RoJWN7QmaLViF0r/TVZQHInXuI5QCvvonjDNDHox5yaJsQLb/JOmjtR+
	 tW8XSBnJ8PZGCG/yqAhmvXwOJM2GV+VsVXUTtkW5aFdnls3tKMU0BI1jmxYaakYTo+N/H
	 WyDSsQZAPvyBxNigW0pnTXn5KpPhBGK4fDqCvP3r/FbfIyKgqdI8GLd6jSkvmX6hK42ZH
	 Wow6mhj/SknxNoWqr9itvU8CpTC97DKfW20IqsrQIcRhJvICnsfPf6HFmmo6ozmYM2tji
	 i8UrZX1hc7MJkuETOKz1/VtTLsjijofCqC/OxLPmt5uE2tghuuXN8e0lXwvykgMc+/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059433;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+7hFoy+lf/vqSkjPYcEZdpGra8/vuQbMFP/TqOScacI=;
	b=dyR5LLnYdjPhfxmAfuMFXjMcZy7i28J8c+x4zn7vHTRBRUaTdY2L5exQBjLanPTBRXo1
	 zXeryfpHS8wmjedVIzvGvEsUIQnF0LkDVRAKQkl5Geg20lcPt4x638WiF/tRKMva90qoy
	 J9athVwS5Oz5/0o7ymbThKjcTqUd+yq5fjDLf4zBiDbGO+S0czeT0BfWssZASRoGrydRf
	 yx1dzP4unMZKoSZjflWe9BntUxgJiUlkoyohrZG1X2yL3z9w9c9PyUocLYu8gf5o3IVSX
	 ugCAEaQVm9YolEV+dSsJ5D/j/YosbHP9FoT7bzUOE5N9445CyvL32J5mozTJqzUjNOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HRIfa++8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C39B9606A320;
	Thu, 19 Nov 2026 03:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HRIfa++8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 259C51F000C4;
	Thu, 19 Nov 2026 03:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059433;
	bh=+7hFoy+lf/vqSkjPYcEZdpGra8/vuQbMFP/TqOScacI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HRIfa++8x31KsEtZ1VCz0dVW3cb/LHFFCpWtToeemhhWs+LClvoQE05LD3+1Fequ8
	 aQYpa2xqWEFkQNQaLYxl18/bTOdzBw+3zjCf8YSm66CWMNtdy6F85NGU66Ga9R2Zzv
	 9xFiUWNG/ytgpbd2EGADyRfntAqr7KQi4ksfdWgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	David Lee <david.lee@trailofbits.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0838/1848] netfilter: nf_reject: initialize IPCB at inet ingress
Date: Wed, 18 Nov 2026 15:47:56 +0100
Message-ID: <20261118145951.736456113@linuxfoundation.org>
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

From: Kyle Zeng <kylebot@openai.com>

[ Upstream commit 73a73d442f9986353fe284bd1b504d0313d0f153 ]

The inet ingress hook runs before ip_rcv_core() and ip6_rcv_core(), so
neither IPCB nor IP6CB has been initialized when nft_reject_inet passes
a packet to nf_send_unreach() or nf_send_unreach6(). skb->cb can
therefore retain metadata from an earlier protocol layer.

For IPv4, icmp_send() treats IPCB(skb)->opt as parsed IPv4 options.
Stale option offsets can make __ip_options_echo() copy an
attacker-controlled length into its 40-byte reply option buffer and
overflow the stack. On an unpatched v7.2-rc5 kernel, the IPv4
reproducer produced:

  BUG: KASAN: stack-out-of-bounds in __ip_options_echo()
  Write of size 255

For IPv6, icmpv6_send() consumes IP6CB(skb) as parsed IPv6 metadata. It
always uses iif for source selection and, when MIP6 is enabled, uses
dsthao as an extension-header offset. These fields must not be stale.

For NF_INET_INGRESS, clear the address-family-specific control block and
restore its input interface before constructing the ICMP error.  This
matches similar initialization normally performed by ip_rcv_core() and
ip6_rcv_core().

Fixes: 117ca1f8920c ("netfilter: nft_reject_inet: allow to use reject from inet ingress")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6-sol Codex:gpt-5.5-cyber
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Co-developed-by: David Lee <david.lee@trailofbits.com>
Signed-off-by: David Lee <david.lee@trailofbits.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
[ sashal: Adjusted IPv4 patch context to preserve the existing one-argument nf_reject_verify_csum(proto) call. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/netfilter/nf_reject_ipv4.c | 5 +++++
 net/ipv6/netfilter/nf_reject_ipv6.c | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
index 48dcb2f0794fd..db2c4bbc641db 100644
--- a/net/ipv4/netfilter/nf_reject_ipv4.c
+++ b/net/ipv4/netfilter/nf_reject_ipv4.c
@@ -198,6 +198,11 @@ void nf_send_unreach(struct sk_buff *skb_in, int code, int hook)
 	if (!skb_valid_dst(skb_in) && nf_reject_fill_skb_dst(skb_in) < 0)
 		return;
 
+	if (hook == NF_INET_INGRESS) {
+		memset(IPCB(skb_in), 0, sizeof(*IPCB(skb_in)));
+		IPCB(skb_in)->iif = skb_in->skb_iif;
+	}
+
 	if (skb_csum_unnecessary(skb_in) || !nf_reject_verify_csum(proto)) {
 		icmp_send(skb_in, ICMP_DEST_UNREACH, code, 0);
 		return;
diff --git a/net/ipv6/netfilter/nf_reject_ipv6.c b/net/ipv6/netfilter/nf_reject_ipv6.c
index 4d8cfb7ae6e3e..a538f878ba332 100644
--- a/net/ipv6/netfilter/nf_reject_ipv6.c
+++ b/net/ipv6/netfilter/nf_reject_ipv6.c
@@ -263,6 +263,11 @@ void nf_send_unreach6(struct net *net, struct sk_buff *skb_in,
 	if (hooknum == NF_INET_LOCAL_OUT && skb_in->dev == NULL)
 		skb_in->dev = net->loopback_dev;
 
+	if (hooknum == NF_INET_INGRESS) {
+		memset(IP6CB(skb_in), 0, sizeof(*IP6CB(skb_in)));
+		IP6CB(skb_in)->iif = skb_in->skb_iif;
+	}
+
 	if (!skb_valid_dst(skb_in) && nf_reject6_fill_skb_dst(skb_in) < 0)
 		return;
 
-- 
2.53.0




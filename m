Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617921;
	b=rnD4HRFndnQRSTZR3C1K9MmRNl13wIktj6XbfjI1tKtQScUGTYScubtB5YNUTSE/tJot
	 +F51b8fWZzaIuEf0IIykK7M+IGKMON0iRuRIUqDNNMVEMmIlMF0zsfqttsRT9iSUOTjvU
	 4koIu26BAN6Eb1CmxKgkDEPxO5KAp634RV8JsqhEZnfgwZKfokfB8swNK0s5P1c3CFWPJ
	 X0WpMduh3zer0juNPptoiqGSRKvGc6WGCXMjPFKKwEVNHSqWmfyY2QB8pzkzKhOBZD19z
	 JnTgIOx3vBmyExRZN1HPocMeR5NxC9bcMbFJ2iUe3az/KQ286e+27slzu5DltLVOamQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617921;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q1yyHczV+TH4F72j7hOXz5HAY++T5/cZEDrV9SqWuuY=;
	b=CKTjS2nbFsT9ltu6V1kktwO81GFhqDQ4IZBOavqy8bvco8ZfFdT3Q+JzgcOx0CfWnv0z
	 z3skhHuypBtCVn5FuSYbuU0+iAHRYhHTQbYcTN0gTOddH0zpVdGv5E6pnOloM6PdcxIEj
	 g8CGfKl2obcn+z2A9QHfiZjpTN2w8Mfi1A0TKwbdSqdnkPd4gt0EEhdta5vQ3huA7onYO
	 zn32VA3NXT4mvymtvN7qW8LMLg4L6yW7L5lfHcOl/4fvlqZT2rkBaWe8/PzovbTXmJxcD
	 7ke6tmCTHAuAWdS3Bw8Z2CU7tko86EDNjLk7TTuIrGCbx+LuRGIGTEbwnPgaXmWO/nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xx8XyOOX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1643E606A31E;
	Wed, 25 Nov 2026 14:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xx8XyOOX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F7CE1F000D2;
	Wed, 25 Nov 2026 14:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617920;
	bh=Q1yyHczV+TH4F72j7hOXz5HAY++T5/cZEDrV9SqWuuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xx8XyOOXQKRcUmHQUxtkanES/qPfWI/twzioAVZNqwQ2T0FftIE9cdQyHVDBj1CN0
	 XyKaxv4VNvIYrdbxnpp7N6AXKhFb9yMMySWvbGCh9STomRi7yl4o4SWemuYSEYJamn
	 xoNsJE6onqQw5a7/gOvW43+ReHZLBKOaK2EtA4Mo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0115/1005] bpf: Dont let lwt_in progs call into IPv6 when it is disabled
Date: Wed, 25 Nov 2026 15:24:13 +0100
Message-ID: <20261125143824.439007910@linuxfoundation.org>
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

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit 95f1d5e4abb79fe85a54f7a46b41f297ce533c31 ]

With ipv6.disable=1, inet6_init() returns before it registers any pernet
subsystem. Thus net->ipv6.devconf_all and net->ipv6.seg6_data stay NULL.
IS_ENABLED(CONFIG_IPV6) only says that the code is built in.
bpf_lwt_input_reroute() and bpf_push_seg6_encap() call into IPv6, but do
not test ipv6_mod_enabled(). An lwt_in prog also runs with ipv6.disable=1,
and skb->protocol == htons(ETH_P_IPV6) does not prove that IPv6 is enabled.
Thus the kernel dereferences NULL and crashes.

Return -EAFNOSUPPORT before these calls if ipv6_mod_enabled() is false.
BPF_LWT_REROUTE then drops an IPv6 skb. With IPv6 enabled nothing changes.

The first Fixes tag is for bpf_push_seg6_encap(), which never had this
test. The second tag is for bpf_lwt_input_reroute(). Until that commit it
used ipv6_stub, which returned -EAFNOSUPPORT with ipv6.disable=1.

Fixes: fe94cc290f53 ("bpf: Add IPv6 Segment Routing helpers")
Fixes: ad84b1eefe28 ("bpf: remove ipv6_bpf_stub completely and use direct function calls")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261101190535.1454146-25-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c  | 4 ++++
 net/core/lwt_bpf.c | 2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index f5931e8964232..2d539860684f5 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6924,6 +6924,10 @@ static int bpf_push_seg6_encap(struct sk_buff *skb, u32 type, void *hdr, u32 len
 	int err;
 	struct ipv6_sr_hdr *srh = (struct ipv6_sr_hdr *)hdr;
 
+	/* With ipv6.disable=1 the netns has no seg6 data and no IPv6 tables. */
+	if (!ipv6_mod_enabled())
+		return -EAFNOSUPPORT;
+
 	if (!seg6_validate_srh(srh, len, false))
 		return -EINVAL;
 
diff --git a/net/core/lwt_bpf.c b/net/core/lwt_bpf.c
index 60f4eda7dae9a..774fad4e9fbf7 100644
--- a/net/core/lwt_bpf.c
+++ b/net/core/lwt_bpf.c
@@ -128,7 +128,7 @@ static int bpf_lwt_input_reroute(struct sk_buff *skb)
 		dev_put(dev);
 	} else if (skb->protocol == htons(ETH_P_IPV6)) {
 		skb_dst_drop(skb);
-		if (IS_ENABLED(CONFIG_IPV6)) {
+		if (ipv6_mod_enabled()) {
 			ip6_route_input(skb);
 			err = skb_dst(skb)->error;
 		} else {
-- 
2.53.0




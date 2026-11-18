Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020959;
	b=dgFNK2H3aEwJLUcjn+qPTqGQ/cBfpFTS33uAtZpWx1KdodMw3XYpJaKomBDqDuWdyPyC
	 okCwrRDRvgpXwICgaGBks9NYx8CxZSsUJ+2Bqa0+Uj9qmaWDKlKNnrUjGN+iwrPyby5mo
	 U5s+f2kRc+zdy9BX62/g1ZjGDf9ep3EaW4UzjsEaaFvv4YJUgsBb4DEc8csTcnCeHhtu2
	 sGlqx9AipOMoRwhUXP4OZ+VcfJaIbCkt0rOYRdrOI0W9usEDebxc0CQVmxE/uo44RxT4L
	 5f6/ULX+3668pBKhhBmUxjjkBoKJM0/AXoycQx7Vvdx1mYu/m/46TCNclxSMBk7XERg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020959;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lguk+8K0DJ5WInp1RwbpBYIGWT3hBu/yKqLNs1rzg5k=;
	b=JAPh4EbXwyOPPBLJB1WCfLVEEiWPz+ySBi397/6WugYcfc1lZsHzLvdXtlP2cLeN7CWK
	 OlmIS0W4Vc0tGVj6RgmY7ZKUrrFBMDtuNS+eK8fLdsV//YZ5zeADVjGTDhioYhGvZKxlF
	 YAfmxNO190x4H4/RGgv6cu81ZpBNnhMwuPjxja8qm1GWltCm8fWuiGELBih1of5kRFk3j
	 9ESFlS2UgMLdQSlAzs/zugKlNX2qCDvZey3mt3CYytsZ3XdsG0RFpMTt+1MKjCjvZcuwP
	 jkZr02AnxigEfn5+KVfFEgsm1YUOVytq8r9Ed/oebOo4VvSH+t1UpRqUdfrTfHB/Aew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lX109jOR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D787E606A31C;
	Wed, 18 Nov 2026 16:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lX109jOR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31D951F000C4;
	Wed, 18 Nov 2026 16:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020959;
	bh=lguk+8K0DJ5WInp1RwbpBYIGWT3hBu/yKqLNs1rzg5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lX109jORXHUc6yD+UYWnzsipa+Fe3E5AFm5CjzVHK/sQazOAXLGK6Up9ZlulfEPQi
	 F9qqsnWb362kuSvVggQ/jIN6SKLqT7Piyq6fFP3oxwDeASDeOwWrWFRYawmciV4/Tj
	 jwPyefITavkOshgOD0/X9Z0tduUG9RfF3mgjPo94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2100/2651] bpf: Pull the inner header for End.DT6 in End.BPF
Date: Wed, 18 Nov 2026 15:55:40 +0100
Message-ID: <20261118150401.594034057@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 434324c611a98bc76dc850d45d67756dae5622cf ]

bpf_lwt_seg6_action(SEG6_LOCAL_ACTION_END_DT6) pulls the outer headers off
the packet and hands it to seg6_lookup_nexthop(), which reads the inner
IPv6 header at skb->data. Nothing says that this header is in the head of
the skb, or that there is one. If the head ends with the outer headers,
the route is looked up for whatever lies behind the head, and the packet
is dropped or leaves by the wrong route. If the program then pushes an SRH
with SEG6_LOCAL_ACTION_END_B6, seg6_do_srh_inline() pulls an IPv6 header
off a head which has none, and __skb_pull() hits its BUG(): the kernel
panics on a packet from the network.

GRO pulls the inner header of a plain IPv6 in IPv6 packet into the head. It
takes a packet which GRO does not look into that far, one with a fragment
header in front of the inner header for example, or a device without GRO,
and a driver which leaves the inner header in a fragment.

Make sure of the inner header together with the outer ones. The program
goes on behind an error of the helper, so do it before the packet is
changed. A pull which fails can still have moved the head, so look for the
SRH again.

Fixes: 486cdf21583e ("bpf: add End.DT6 action to bpf_lwt_seg6_action helper")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261017163745.3341787-13-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index ef09652b8b160..1a01b8e364504 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -7073,9 +7073,14 @@ BPF_CALL_4(bpf_lwt_seg6_action, struct sk_buff *, skb,
 
 		if (ipv6_find_hdr(skb, &hdroff, IPPROTO_IPV6, NULL, NULL) < 0)
 			return -EBADMSG;
-		if (!pskb_pull(skb, hdroff))
+		/* As long as nothing has been changed, the program goes on */
+		if (!pskb_may_pull(skb, hdroff + sizeof(struct ipv6hdr))) {
+			/* but the head may have moved */
+			bpf_update_srh_state(skb);
 			return -EBADMSG;
+		}
 
+		__skb_pull(skb, hdroff);
 		skb_postpull_rcsum(skb, skb_network_header(skb), hdroff);
 		skb_reset_network_header(skb);
 		skb_reset_transport_header(skb);
-- 
2.53.0




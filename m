Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793521C3C08;
	Mon, 23 Mar 2026 13:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774271070; cv=none; b=CmtEkPzHihy5h+F3GwUEoR0oGsl8OJvjCNsI2RZV+IGm/ZJac/giQQ9k9KNqTQiHYsW76mI78tR6uqtIDVEhhJRPr2yev/LAn4RozC+nMbPZIp1Jmsoq4za7ezAXfNiv9CHp2wrUIx19WvVuPIxqoG1oPrnhH48t9IIMdyjJcEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774271070; c=relaxed/simple;
	bh=5Nz8s7+sMR0QBDNdaSxt7uendNTU32h2kZSUWeWq8ys=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=R9HS8MT6NhC/77ugi0YvOu7ZosuYncZfXGPGO1ooiwLgfi+l6fPT19OKgiYiIOinhu5NEU8AIv9ENnWEx/C+CrueNPPH6lZHO1jk1HznnGiC9Z4stOsnrWMwj+kJrHWxqqUrG4yUEVeyaW6HEdJ/UNPcJYWsJow5GGBYvgOPUxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qwl0knta; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qwl0knta"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ABDCC4CEF7;
	Mon, 23 Mar 2026 13:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774271070;
	bh=5Nz8s7+sMR0QBDNdaSxt7uendNTU32h2kZSUWeWq8ys=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=Qwl0kntavmmHq/WQm03gl37bTBCs7DwEkPJ7BwXuSSsAaPMCghlDIhupMVYG7kgYh
	 PIfzVQthZE2baLhs9FUm+SYUBuGJ7aNQdL7+IfMo4gWJ1/w4aThFWAte8dKrnWUF+W
	 oQlMJuD2j262fbJWW0e0Pb2jOSU6zAYBXdXxyEy4=
Subject: Patch "net: fix segmentation of forwarding fraglist GRO" has been added to the 6.1-stable tree
To: 1468888505@139.com,andrii@kernel.org,ast@kernel.org,daniel@iogearbox.net,davem@davemloft.net,dsahern@kernel.org,edumazet@google.com,gregkh@linuxfoundation.org,haoluo@google.com,jibin.zhang@mediatek.com,john.fastabend@gmail.com,jolsa@kernel.org,kpsingh@kernel.org,kuba@kernel.org,linux-arm-kernel@lists.infradead.org,linux-mediatek@lists.infradead.org,martin.lau@linux.dev,matthias.bgg@gmail.com,pabeni@redhat.com,patches@lists.linux.dev,sdf@google.com,song@kernel.org,steffen.klassert@secunet.com,willemb@google.com,yhs@fb.com,yoshfuji@linux-ipv6.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Mon, 23 Mar 2026 14:03:45 +0100
In-Reply-To: <20260302065427.2695392-1-1468888505@139.com>
Message-ID: <2026032344-dwindling-unretired-3b30@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore


This is a note to let you know that I've just added the patch titled

    net: fix segmentation of forwarding fraglist GRO

to the 6.1-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     net-fix-segmentation-of-forwarding-fraglist-gro.patch
and it can be found in the queue-6.1 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From 1468888505@139.com Mon Mar  2 07:54:33 2026
From: Li hongliang <1468888505@139.com>
Date: Mon,  2 Mar 2026 14:54:27 +0800
Subject: net: fix segmentation of forwarding fraglist GRO
To: gregkh@linuxfoundation.org, stable@vger.kernel.org, jibin.zhang@mediatek.com
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev, song@kernel.org, yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com, haoluo@google.com, jolsa@kernel.org, davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, yoshfuji@linux-ipv6.org, dsahern@kernel.org, matthias.bgg@gmail.com, willemb@google.com, steffen.klassert@secunet.com, bpf@vger.kernel.org, netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org
Message-ID: <20260302065427.2695392-1-1468888505@139.com>

From: Jibin Zhang <jibin.zhang@mediatek.com>

[ Upstream commit 426ca15c7f6cb6562a081341ca88893a50c59fa2 ]

This patch enhances GSO segment handling by properly checking
the SKB_GSO_DODGY flag for frag_list GSO packets, addressing
low throughput issues observed when a station accesses IPv4
servers via hotspots with an IPv6-only upstream interface.

Specifically, it fixes a bug in GSO segmentation when forwarding
GRO packets containing a frag_list. The function skb_segment_list
cannot correctly process GRO skbs that have been converted by XLAT,
since XLAT only translates the header of the head skb. Consequently,
skbs in the frag_list may remain untranslated, resulting in protocol
inconsistencies and reduced throughput.

To address this, the patch explicitly sets the SKB_GSO_DODGY flag
for GSO packets in XLAT's IPv4/IPv6 protocol translation helpers
(bpf_skb_proto_4_to_6 and bpf_skb_proto_6_to_4). This marks GSO
packets as potentially modified after protocol translation. As a
result, GSO segmentation will avoid using skb_segment_list and
instead falls back to skb_segment for packets with the SKB_GSO_DODGY
flag. This ensures that only safe and fully translated frag_list
packets are processed by skb_segment_list, resolving protocol
inconsistencies and improving throughput when forwarding GRO packets
converted by XLAT.

Signed-off-by: Jibin Zhang <jibin.zhang@mediatek.com>
Fixes: 9fd1ff5d2ac7 ("udp: Support UDP fraglist GRO/GSO.")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260126152114.1211-1-jibin.zhang@mediatek.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Li hongliang <1468888505@139.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/filter.c        |    2 ++
 net/ipv4/tcp_offload.c   |    3 ++-
 net/ipv4/udp_offload.c   |    3 ++-
 net/ipv6/tcpv6_offload.c |    3 ++-
 4 files changed, 8 insertions(+), 3 deletions(-)

--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3333,6 +3333,7 @@ static int bpf_skb_proto_4_to_6(struct s
 			shinfo->gso_type &= ~SKB_GSO_TCPV4;
 			shinfo->gso_type |=  SKB_GSO_TCPV6;
 		}
+		shinfo->gso_type |=  SKB_GSO_DODGY;
 	}
 
 	bpf_skb_change_protocol(skb, ETH_P_IPV6);
@@ -3363,6 +3364,7 @@ static int bpf_skb_proto_6_to_4(struct s
 			shinfo->gso_type &= ~SKB_GSO_TCPV6;
 			shinfo->gso_type |=  SKB_GSO_TCPV4;
 		}
+		shinfo->gso_type |=  SKB_GSO_DODGY;
 	}
 
 	bpf_skb_change_protocol(skb, ETH_P_IP);
--- a/net/ipv4/tcp_offload.c
+++ b/net/ipv4/tcp_offload.c
@@ -106,7 +106,8 @@ static struct sk_buff *tcp4_gso_segment(
 	if (skb_shinfo(skb)->gso_type & SKB_GSO_FRAGLIST) {
 		struct tcphdr *th = tcp_hdr(skb);
 
-		if (skb_pagelen(skb) - th->doff * 4 == skb_shinfo(skb)->gso_size)
+		if ((skb_pagelen(skb) - th->doff * 4 == skb_shinfo(skb)->gso_size) &&
+		    !(skb_shinfo(skb)->gso_type & SKB_GSO_DODGY))
 			return __tcp4_gso_segment_list(skb, features);
 
 		skb->ip_summed = CHECKSUM_NONE;
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -351,7 +351,8 @@ struct sk_buff *__udp_gso_segment(struct
 
 	if (skb_shinfo(gso_skb)->gso_type & SKB_GSO_FRAGLIST) {
 		 /* Detect modified geometry and pass those to skb_segment. */
-		if (skb_pagelen(gso_skb) - sizeof(*uh) == skb_shinfo(gso_skb)->gso_size)
+		if ((skb_pagelen(gso_skb) - sizeof(*uh) == skb_shinfo(gso_skb)->gso_size) &&
+		    !(skb_shinfo(gso_skb)->gso_type & SKB_GSO_DODGY))
 			return __udp_gso_segment_list(gso_skb, features, is_ipv6);
 
 		ret = __skb_linearize(gso_skb);
--- a/net/ipv6/tcpv6_offload.c
+++ b/net/ipv6/tcpv6_offload.c
@@ -108,7 +108,8 @@ static struct sk_buff *tcp6_gso_segment(
 	if (skb_shinfo(skb)->gso_type & SKB_GSO_FRAGLIST) {
 		struct tcphdr *th = tcp_hdr(skb);
 
-		if (skb_pagelen(skb) - th->doff * 4 == skb_shinfo(skb)->gso_size)
+		if ((skb_pagelen(skb) - th->doff * 4 == skb_shinfo(skb)->gso_size) &&
+		    !(skb_shinfo(skb)->gso_type & SKB_GSO_DODGY))
 			return __tcp6_gso_segment_list(skb, features);
 
 		skb->ip_summed = CHECKSUM_NONE;


Patches currently in stable-queue which might be from 1468888505@139.com are

queue-6.1/net-fix-segmentation-of-forwarding-fraglist-gro.patch
queue-6.1/net-gso-fix-tcp-fraglist-segmentation-after-pull-from-frag_list.patch
queue-6.1/net-add-support-for-segmenting-tcp-fraglist-gso-packets.patch

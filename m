Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032314;
	b=d9q1BdWHD9VykUc20boq/uwNO074XXI4P2UDZntPs1V+G83TCKtSW+SjxtNLZq5IXyYU
	 E6F4BYjN1s4nNJwybjJs8O+hTUob6m8axEvMKKkgdVsWhamlUTql6jasXokz5uNf0MkSy
	 H80myRmhzObN7xIicV9SmMHC7fix++/BINBdlns/KOtj0C+GPVQeBij+uU2otpb2ZsFsO
	 3/aj1tY+qUXHOL6567giUwgcAPbbdC4BBHCHFzQXZtcHbmI2VZbudFiOqAaXyCFYThS2r
	 Xd3SrhQhCcu2CyCWbn0tll9F/DIZea8GTcSsKDKikRYaef1non6/aRgnVka/KeRyiuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032314;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/LyjhTeWSxoWPm+IhyZe2YUoC9nF/dNmuZD7JMlA3Nw=;
	b=alFeKRLt6pBSrqGstGG5RPhRtCCWlWsEaUHoY3X7CpGogJHfNEUIgVFkgCmpTS9heT9S
	 LrINVJ+ZaNN3Cy6AKc8e8iIJiue0/p0d3rWG9OuZfEH3Q3hD7NW6/98KV2r5YO0l54I33
	 wUldfQjApoJI/eB4zOLPWJMFWVMHH06g5y2YGUMlbQmLiwd5iVeqD3Jt0DhXyZsiZ0IMg
	 nsIh+lRnJleP/3TOqbKMcheRMow33UQj96xkLBJNZ/p6RjSd5bGeaosTSheHtOHYmKB8S
	 4b68PF/6Hmw872kWXH2sqKjPyEdK0SxQ7VbBiFmuBP41D2E7U6CPsYcFsQQ0bd6W1VQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eQIKy73O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09853606A31C;
	Wed, 18 Nov 2026 20:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eQIKy73O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 584721F000C6;
	Wed, 18 Nov 2026 20:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032313;
	bh=/LyjhTeWSxoWPm+IhyZe2YUoC9nF/dNmuZD7JMlA3Nw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eQIKy73O5Mh/iseyZLewBxm6QG253BDQo4VODubI20tGNnGaNADhIgc/iwaVFLjt+
	 Sn69Nd4ZBXRFl/dyuLI16cNTtyykLQmUFD65nV+2AXHNDisWdY0itRil/bsYcl3CFO
	 ElpRhvXAXDxdUeLvQx3GP9i1tpdwBr5TxddgmOmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1366/1756] bpf: Pull the inner header for End.DT6 in End.BPF
Date: Wed, 18 Nov 2026 15:58:13 +0100
Message-ID: <20261118150103.632128003@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index 1b098f782799e..64fb3b3b03146 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6688,9 +6688,14 @@ BPF_CALL_4(bpf_lwt_seg6_action, struct sk_buff *, skb,
 
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




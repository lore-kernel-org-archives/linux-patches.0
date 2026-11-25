Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617892;
	b=qhxrOKTjzHyv/VfR5zToIZgGqfjyMDM28WgS56mynAD8lXCmsI6xEA6fbjCGYnavYJG6
	 VWUoqMS3AYM28CVM2N3+g5+zDO0wwzfMNPidJ/j3kMOeAhuPsqpqRA9z09L9xNKN9bv8W
	 U0b1Y8STabbCsPrW4E3zm5470jJs8UDszAX0q5+2ee19s+VjBD3w4xayOxBFApLX4mDFn
	 rXM9uaPmeCbp+VBRQRXrkwzzoPnJLqIchMZ1GOOGwBui/9O40qBkUFBDyR8Tsvle7RelO
	 s0MQyLtxY2Md8hQX6BxuDatB5uaQfrz+RV7WU7Bd00Pvu+hmKUo3TR4F6ttANpmdXWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617892;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PwFcyuckocTbbkDgZ3ObaSloZ4J8SrNZZRxiiFHrQsg=;
	b=ygNycy7nwv9UezANkOiGpKHzKMp9FwYvKJeH3qbN+UvdujCd81gHbe2LzzbuZ1mBNcUr
	 5nw7Fc6R3Lp7TP6jMh0LN/xBTWp3TMEapptUtAUj+mu7vjyxzcNtit63BQHXnvUGdsRPv
	 WhV5G5qYVkRpyLrrNeZkZkl7iPa56cjW3JiX1FuZIZB5u0GjG0MdF7jupnNl8rXQCO1+p
	 ILyVhIQXOd+AKjc+OSTsfKvdpwnX/1lppE5D/2Ws5dpcRrc31uKHViU899kYTuStXM8/m
	 5LuRDffUc2f6Hxcl4Nt3LO0Oa3ZTQryEe97QgpNnUAxopKEoCYvHtJC35pMUI603ssA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PG9E9DiQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC36606A326;
	Wed, 25 Nov 2026 14:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PG9E9DiQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 155A41F000CF;
	Wed, 25 Nov 2026 14:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617891;
	bh=PwFcyuckocTbbkDgZ3ObaSloZ4J8SrNZZRxiiFHrQsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PG9E9DiQ9IGQ1lajhKdlqNM247p/O3VibdjLqDbaUTK3SRy16f5jyXZKgSYWUEyRs
	 C/CNDGBigW6lqZb+sy+heENwokQgGwfuP8FnVaUsey1cZfqgtvoPZubo3hNRYFkSBw
	 +QxKGagHfgGRnwrOfeaVVLCNicpm3q8zLSETmdJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0107/1005] bpf: Reject non-IPv6 packets in BPF_LWT_ENCAP_SEG6
Date: Wed, 25 Nov 2026 15:24:05 +0100
Message-ID: <20261125143824.253161695@linuxfoundation.org>
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

From: Chris Mason <mason@kernel.org>

[ Upstream commit 58e39f8d58b141b96c030008a20dde9d625ec997 ]

The mode BPF_LWT_ENCAP_SEG6 of bpf_lwt_push_encap() pushes an IPv6 header
and an SRH, and it replaces the dst. The SRH says that IPv6 follows, and
skb->protocol does not change. Thus the mode assumes an IPv6 packet, but an
lwt_in prog also runs for IPv4 packets. After the prog, bpf_input() calls
orig_input() of the old dst. This IPv4 handler reads the pushed headers as
IPv4. It can write after the packet data, and the kernel crashes.

                 after the push         orig_input() expects
                 ---------------------  --------------------
  skb->protocol  ETH_P_IP               ETH_P_IP
  dst            rt6_info               rtable
  packet         | IPv6 | SRH | IPv4 |  | IPv4 |

The mode BPF_LWT_ENCAP_SEG6_INLINE returns -EBADMSG for non-IPv6 packets.
Apply this check to both modes. End.BPF does not change, because
seg6_local_input() drops non-IPv6 packets.

Fixes: fe94cc290f53 ("bpf: Add IPv6 Segment Routing helpers")
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261101190535.1454146-17-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 3f268e3aac56b..c2d08dfad40e3 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6927,11 +6927,15 @@ static int bpf_push_seg6_encap(struct sk_buff *skb, u32 type, void *hdr, u32 len
 	if (!seg6_validate_srh(srh, len, false))
 		return -EINVAL;
 
+	/*
+	 * The encap mode names IPv6 as the inner protocol, and neither mode
+	 * updates skb->protocol.
+	 */
+	if (skb->protocol != htons(ETH_P_IPV6))
+		return -EBADMSG;
+
 	switch (type) {
 	case BPF_LWT_ENCAP_SEG6_INLINE:
-		if (skb->protocol != htons(ETH_P_IPV6))
-			return -EBADMSG;
-
 		err = seg6_do_srh_inline(skb, srh);
 		break;
 	case BPF_LWT_ENCAP_SEG6:
-- 
2.53.0




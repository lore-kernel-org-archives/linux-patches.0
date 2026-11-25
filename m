Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621238;
	b=ow61Wxm/cfkF9a1BMvYSG3IdT6pK7/Qt8eRZHzcBovm+xx6uIaMQZSh3q2rHxwiZOLb0
	 o06Qbgpht3hrHZX+jwdkZ4iLSP/uaoQGdhp8d7/K7CtvBZyGnJokjYDnKFmc1/Pd0EBq7
	 sx+v8eBrEKIYMB32rPqzIlh5vBPfUyOOPnwXnar+TEUUQ30NF/VcIWriM6eiGmDSe+bGQ
	 7OZjpdno7WKCk8/yVzzV82v1gUohzs6ReCEvjMqnpZ7pkqxVqMDC8Qgt7WWrkSPUTwFlL
	 O6AOy172s9oyS53LYvCNvba7vqK3kOumMDCMcefHtEsazi+7vRbmhy0IrwbUleWe0oQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621238;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DuwLdRggUY/c9YfWa6kcuRNWg4zmPRsfSIvnPNQCbfU=;
	b=egCboxLPEOYa+2zhlj7RMQvzbHZSVV3mE5NHvApqD5wY4byAcbgmmqZD38CIrlKfw0Tb
	 FFtSzcZb1aFifPEuGBgcM0ZY2YO5orPJbvEMeLGqLuSNM8wVUUEekZHSnjcXwei8qGJv7
	 5dKz4uG8jj/vmX2yicHyNLt2lg+F8qlT2+EDereaT0G1QF1qYuNbkyzaZkwlV7Y6+vxop
	 bYJXJzY5XRyi3ml0plgi9zomoRHmgxXBM67KXEIqGLIMm92C49LET9WVsu0Wc50PBecF5
	 bYjDQ4JJ1c4p2ItthJ5JGozHbnbibEsji65SlQQkex9UEq2tIxd/gD5HqOIzXmMq7UQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="L/o7JpQv";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A68606B3A4;
	Wed, 25 Nov 2026 15:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L/o7JpQv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8B241F000C4;
	Wed, 25 Nov 2026 15:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621237;
	bh=DuwLdRggUY/c9YfWa6kcuRNWg4zmPRsfSIvnPNQCbfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L/o7JpQvZJ14ASm36+ONBAiUW6Z7ig4dO+nHwFdK+UsA/2RTTNlCapB9wtU+LFcTV
	 a/6pa9rknz5BSXnQ8oq8AjmH0h3Wd+MYU8nhn+TYgzQEbHyaAm3KLG852QsrnsY5UL
	 VgvUqmGLFVaCYWayaGjJPRL4IJ5o9gvd6+7RyFZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 119/990] bpf: Reject non-IPv6 packets in BPF_LWT_ENCAP_SEG6
Date: Wed, 25 Nov 2026 15:24:46 +0100
Message-ID: <20261125143824.876032195@linuxfoundation.org>
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
index 9463c10d0c907..2df3e5cfc3fcd 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6611,11 +6611,15 @@ static int bpf_push_seg6_encap(struct sk_buff *skb, u32 type, void *hdr, u32 len
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




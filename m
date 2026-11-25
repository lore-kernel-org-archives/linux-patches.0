Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617918;
	b=gmRoIPjISMSQLkCLuxyid9BLaZWtob/W3yk7Wh5SJBE1ZE3sH9P9EYFIrSYOaG9sf7HB
	 h09iM4HVADcX7R1MPoM3FsigZjfCNzjeA+j6KdGfjH/847h0u/qhEYw2pOQMXda2iOoq6
	 F8NxKfMKSATj1qNgizliyOoIY6B1uAjnABfSiXmY92ffd+9K//hyFuebRTA0Gt5N53qVl
	 yxSskgH32ov88xHf0GmHIaNZEKi76ndx/bpvYmN/F72QeJU1jM3G8o7agPx9eeGgWDOsm
	 voXvwHJRkgN3IDMrgQnGQe7+OpSqj0aA5mLlGgsaDzZfIMcsSpNON/CjepJPcXA805A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617918;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9LMhThW8W6ACpWj7I+UteAoN8Fb3yY+LQyYit0npTps=;
	b=bUDqYF23chzAnL/RTqBmfhWn+2rhYy2vq0wqxMjTadoyhLjRHe/qVVXoO96ZkxPEfJq2
	 a1lOMaG0Wopjcl/5wCZUTDIWh6qcp083+yYSCjO6B9LevjVQyBLCktpDZeBN8eTjM5XxK
	 mB9oN5Wi6sXhUP6yZgxhhbNcI7T91oMLV/TXu91JZaqvBzfH1NbAhZzAKK+R3cRkQbc23
	 QLYmY/pX/KHs643tEnkAB3xKb4ar7m+N6uzVKo0kewUAIbjbXcTCCFfkCQQ0DNNNubgeQ
	 kzjgAhpuY1H9FFGr5WNrqOgGY7hw7cba2FODLnCCN/vQonywWFKr2mdkYEGsfYbi1uQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rYkyc46j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 100AE606A330;
	Wed, 25 Nov 2026 14:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rYkyc46j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB3221F000E6;
	Wed, 25 Nov 2026 14:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617917;
	bh=9LMhThW8W6ACpWj7I+UteAoN8Fb3yY+LQyYit0npTps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rYkyc46jH5zjeAWr3Uuj4v1KC07GRBN2zrxVYAxkNrzYkhHeAIwrtIilf1BdCNs6O
	 OakYs0czWwB/50Ui1OD+tTjUv9pgPkVN65tHKB9z37hg59L4Hsg/Yyq1i3mH1/TGlA
	 4oXZULKdk5FAk2JJwvbbv4rcKKzwcLUmOIAGpk6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0114/1005] bpf: Require BPF_LWT_REROUTE when an lwt_in prog changes the protocol
Date: Wed, 25 Nov 2026 15:24:12 +0100
Message-ID: <20261125143824.415668732@linuxfoundation.org>
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

[ Upstream commit d9618a6196953718f7470de5d2e84121bed063f7 ]

When an lwt_in prog returns BPF_OK, bpf_input() calls orig_input(), the
input handler of the route. This handler is for one IP version and needs a
dst of the same family. But BPF_LWT_ENCAP_IP lets the prog push a header of
the other IP version and thus change skb->protocol. Then the handler reads
and changes a header of the other IP version. The push of an SRH also
replaces the dst, because seg6_lookup_nexthop() puts an rt6_info into the
skb. Then ip_forward() uses the rt6_info as a struct rtable.

Drop the skb with -EINVAL when skb->protocol changes, as bpf_xmit() does.
Drop it also when the family of the dst changes, because skb->protocol does
not always show this change. Today no such skb leaves as the prog made it.
A prog works as before if it returns BPF_LWT_REROUTE, or if it pushes an
SRH on an IPv6 route.

The commit in the first Fixes tag lets a prog change skb->protocol. The
commit in the second tag adds the check to bpf_xmit() only.

Fixes: 52f278774e79 ("bpf: implement BPF_LWT_ENCAP_IP mode in bpf_lwt_push_encap")
Fixes: 3bd0b15281af ("bpf: add handling of BPF_LWT_REROUTE to lwt_bpf.c")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261101190535.1454146-24-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/lwt_bpf.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/core/lwt_bpf.c b/net/core/lwt_bpf.c
index 3a946e8709b16..60f4eda7dae9a 100644
--- a/net/core/lwt_bpf.c
+++ b/net/core/lwt_bpf.c
@@ -165,6 +165,16 @@ static int bpf_input(struct sk_buff *skb)
 			bpf_lwt_reset_cb(skb, proto);
 		if (ret == BPF_LWT_REROUTE)
 			return bpf_lwt_input_reroute(skb);
+		/*
+		 * orig_input() is for the old protocol only, see bpf_xmit().
+		 * It also needs a dst of the old family. BPF_LWT_ENCAP_SEG6
+		 * puts an IPv6 dst into the skb.
+		 */
+		if (skb->protocol != proto ||
+		    skb_dst(skb)->ops->family != dst->ops->family) {
+			kfree_skb(skb);
+			return -EINVAL;
+		}
 	}
 
 	if (unlikely(!dst->lwtstate->orig_input)) {
-- 
2.53.0




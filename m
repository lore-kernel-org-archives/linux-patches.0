Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618091;
	b=r1FLSB4xqLBl6Ss/zRaWS1ka708SJDtTDmtCv0EMTEL8+yA/JcSHK53CvLlvPRHD8y6F
	 hM7zQTtQBH/NLL0RCOJqJkVSRtA5KuRDY9ozFeJngudSPfJEcgg2EU6xJm+vzNKxXLyC6
	 THNKTxd+1jrrnANGGI5NOr6hXf0wYerrjwWK5PBOaudaBOwp4GmLiOhR+cjMPji3oXmGA
	 UDH0DXlcXEwPBZTwP6IgFS3XihRnRvF9aI1dIgcN3OE/Eo917GSblqW7f0nZhvg50qcLI
	 uRODSie59c0a/3rHNiyXSWwxaEmffYV/3zrURaKPiVB7gRmzXK9vEBauH5o+/w8udZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618091;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gmiV54zzV0RPFEG2ZwpkjBsIxmXxyfgR7uEwyFgE3lI=;
	b=2z0TDQSLjZmD3Zyvmqwo/YygfCIYBMGzN8piDU8jw32iniM62c1ZTw1TnAS4kHc8sJH2
	 83J24G2424mkgbbpHDMWRJNwcbDBE6SMSocMI53CyE3X51CgrUHbNYjRn5utJSnSz8EiW
	 I+IlM7WpqsfbS1UVS7HCkcXvih07uAQdtFyCLbweTayle+dMDHEufB96b5svzve/dPtRe
	 /Rab52lAZ1Z64qKzPh5visko2at1vavlKGmuMY+wGF9IqPJzMFODYAMWqg9JEa75qI9qk
	 0FQW1znR69uo3BkfSzchH/LAjzS/zsQpAiIco6zLe3KQWcp3XVgjneGMKWdZmb3/I6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lODVIV6u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07BBD606A31E;
	Wed, 25 Nov 2026 14:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lODVIV6u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8CA11F000C0;
	Wed, 25 Nov 2026 14:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618090;
	bh=gmiV54zzV0RPFEG2ZwpkjBsIxmXxyfgR7uEwyFgE3lI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lODVIV6uXLtAb1Z+F09S8AqGv4/Np5d8f4KgVlD56eigu1/baBoIdP8efMICoS2vF
	 Y3NKIGIz7w2MqpjaJQqw26mmXFvvS3XSs4db5wVEIR7kYfHnFZaKBPPXAmkXijTQFa
	 5kqXQtFw6Rjfv9YprLKcLA0iN9vZxy5PEW5y7ne0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuqiang Sun <izaiahsun@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0123/1005] bpf: lwt: Free the skb when bpf_xmit() fails to expand the headroom
Date: Wed, 25 Nov 2026 15:24:21 +0100
Message-ID: <20261125143824.622057169@linuxfoundation.org>
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

From: Yuqiang Sun <izaiahsun@gmail.com>

[ Upstream commit 5e96760b25fdedbbf9312827f1f237d6b18b03e8 ]

When an LWT xmit program returns BPF_OK, bpf_xmit() makes sure that
the skb still has room for the link layer header. If
pskb_expand_head() fails there, bpf_xmit() returns -ENOMEM without
freeing the skb. Its callers, lwtunnel_xmit() and then
ip_finish_output2() or ip6_finish_output2(), take any return value
other than LWTUNNEL_XMIT_CONTINUE to mean that the skb has been
consumed, so nothing frees it.

Each such failure leaks the skb, together with what it holds: its dst
and its charge to the sending socket, so the socket is never freed
either. The other error paths of bpf_xmit() (BPF_DROP, an illegal
return code, a changed protocol, a failed reroute) all free the skb.

Free it here too.

The leak was found with kbound, a static analysis prototype for
ownership mismatches at kernel interfaces, on v7.2.12; it is present in
mainline.

Build-tested with x86_64 and arm64 allmodconfig (W=1, sparse): no new
warnings. Run-tested on QEMU (x86_64, KVM) with KASAN: a route through a
dummy device with an LWT xmit program that pushes one byte with
bpf_skb_change_head(), so the headroom check has to expand the head, and
failslab limited to allocations under bpf_xmit(). Each of 10 pings then
fails with ENOMEM. Without this patch each leaves a raw socket behind
(RAW slab objects 6 -> 16); with it none does (6 -> 6), and nothing else
is reported. Without injection both kernels go from 6 to 6.

Fixes: 3a0af8fd61f9 ("bpf: BPF for lightweight tunnel infrastructure")
Signed-off-by: Yuqiang Sun <izaiahsun@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261101182343.17991-1-izaiahsun@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/lwt_bpf.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/core/lwt_bpf.c b/net/core/lwt_bpf.c
index 774fad4e9fbf7..72c86ff2a8472 100644
--- a/net/core/lwt_bpf.c
+++ b/net/core/lwt_bpf.c
@@ -345,8 +345,10 @@ static int bpf_xmit(struct sk_buff *skb)
 			 * made before LWT xmit.
 			 */
 			ret = xmit_check_headroom(skb, hroom);
-			if (unlikely(ret))
+			if (unlikely(ret)) {
+				kfree_skb(skb);
 				return ret;
+			}
 
 			return LWTUNNEL_XMIT_CONTINUE;
 		case BPF_REDIRECT:
-- 
2.53.0




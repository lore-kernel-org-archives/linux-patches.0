Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624153;
	b=lzKNKkTxDiiGPOBgboQw0FUtWqBpuEjyVv/oWoF6OCqodFzC5dwb62ajQXxiX8nEWaIM
	 hPoopN/ibYCknShYSIjtZkeg4V7/OW8FusTPr80cCR37KDK5v36a5jEX4DggQoeg44MwI
	 tYfYFXQnJJv8z/SfVvXqnD1hKOSk8ZYHdENSsqyajQniceuNaeSFwbtoZ9nkGXD3q2v5Q
	 D3wZJDd3+PlG+BV7CMxHfzW2bAjTktqdJ8mIyEu22HAo8Lyd0a/h+tQhfUWF3tutdhFCZ
	 k1NX7IGJJ2/XskNbF+WPv89nvPkS3GH6bFa0Lr+BS0Lc+P8OW98O+zBPzAnCpI9j2pQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624153;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yTfALlOzJ6vRlJnInBAw6cSH03//6F8R5zChXqHyVK4=;
	b=cl/5nyxI2cl9zZvuM+F71+F96H3wpP3//Fz/kvBXDrotuID4DnDOhKXe6Uf9dlKD2q/C
	 RkFb3SpiucJS6pzynwc+U4GUGvLuw8Fhf68auT6r1OsXz0lY/WAoXoLn6lVrkAUc2sMM4
	 AEY7WYM+UXZ2va/JamznGlfs/EU9VASRNk33MAjacAVZJkiydTObHZsvT1lJ5DqMj7smp
	 ctSpvO7Oi7HSaythqlQYfnJvzYnUgGDyxf2CNcc2iiebsmY/5zPlvInIXvDhVWzD8liPA
	 Dc7iwdA1UFs4ZTBt3S78YIeAW3zjvBHiRvPRjVJyKaLdzgdg6gpiW7wxeU2Uo5i6UiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N46u7QPf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 821FA606A323;
	Wed, 25 Nov 2026 16:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N46u7QPf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64A3E1F000D3;
	Wed, 25 Nov 2026 16:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624152;
	bh=yTfALlOzJ6vRlJnInBAw6cSH03//6F8R5zChXqHyVK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N46u7QPf4V+eelnnka3paPtQxh9e1MPuu/S0yYF7EodkyE1eg84RyzjabkNwj56zZ
	 Vv7mXgB8sEBqHO3x3ty4oC+gXq10172a0E/Pw5vL4LfedgxzSsqC+cBEpgy4//1QBc
	 N2371WCPYY1FjwbwSAJQL9o645ii8gYnqYAOmM9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 102/816] bpf: Reject non-IPv6 packets in BPF_LWT_ENCAP_SEG6
Date: Wed, 25 Nov 2026 15:27:30 +0100
Message-ID: <20261125143851.576806034@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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
index 0f621e152b09a..4dbc3f091513b 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6524,11 +6524,15 @@ static int bpf_push_seg6_encap(struct sk_buff *skb, u32 type, void *hdr, u32 len
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




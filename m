Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212507;
	b=YalSi/fD07rFQNT9UY6lrPy/9gFWjxztjpkevQNZAG316Q07FsvEssoa5hXDGPW92qw5
	 akdVYoay0y8dzDgltNCSr3WLGlC96lJkTvdgkQtBrO1lo2OzZYkHRGhgtRA1X0Zpw5vlC
	 IU9o3fcLQpAGV/gWNzkOfzaBNCYfUGdtyu45G1mBea0pB0K6q5Z/NSRC5y+c439UaaNOB
	 ft72vtqxBPkJ0KTjTirjOiU/GJQUvmvvcZxUyikGEfNsVocWWq3117Tix4jQZUgNKXTLw
	 Eo83zsk6f3NR3FxXCoFhXx9yi5IlDuWWR+e1E5EQaVsMai4n1qmKWp/7qgFpHB+iyKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212507;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=PDBEgrDCcci0QL1uSmlYOsMX01PI5qxrM6wgLLaCwAw=;
	b=Nu3GaTxydtS3PZEqEqWGFqE84SJbBuuRMPyoAvOl6ZZswZBmOMQjOZsSBEHNMJa13Ayj
	 Eazfb/d48AqVRB9g1eLDaQEfjEBOnYy7+r/U7DvOnFLOirPXbIsidcu4CtN7+dtWjOQ5k
	 41fZtcjHfyuBOFXBKzpPgY7Me/OoJSNNdSL12vGD0TvrP+LTLHSW9y2aWMp9g50CEixiu
	 5O0FeJvtmQ1DhoAsKgfCcTH+EQl7qmn+Fjzu1u99aNWTOGXT4enuSRIoI0XuXcC8s9GI+
	 98wmqB6X33oYX2WNMpYsM/tcut0lNYv5QimvNf0r7QFIJmfwmwMNzmCR4Uaiz3tXB2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FyWpGrFZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F880606A320;
	Wed, 28 Oct 2026 18:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FyWpGrFZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 714A31F01825;
	Wed, 28 Oct 2026 18:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212507;
	bh=PDBEgrDCcci0QL1uSmlYOsMX01PI5qxrM6wgLLaCwAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FyWpGrFZWueJllwtQamvTJBdc51bF6w/WeIiurTvN/67zlBzayUXTwM5YkE+M/vw3
	 kt7nCOdVOyLzVnmrgZc1p6Fjhq7EJiEye5YUbvcmaXtyMXDa9+6Vz/pqdo3h8Vnuj4
	 YWFRakT1rT4sd8m6KcNhk7anYZkGmNc5jLXXXfeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilkka=20Lappetel=C3=A4inen?= <ilkka.lappetelainen@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 0178/1887] net/packet: prevent TX_RING byte count overflow
Date: Wed, 28 Oct 2026 17:37:54 +0100
Message-ID: <20261028170503.285728102@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilkka Lappeteläinen <ilkka.lappetelainen@gmail.com>

commit 2cf81fc9505b148b1b70068303ea6ea4b1212403 upstream.

tpacket_snd() drains every SEND_REQUEST frame in a TX ring and adds
each valid packet length to the signed int len_sum. Userspace can
recycle completed frames concurrently, so a single blocking send call
is not bounded by the ring size.

After enough successful transmissions len_sum wraps into the negative
range. In particular, 65536 65535-byte frames followed by a 65007-byte
frame produce 0xfffffdef, or -EIOCBQUEUED. sock_sendmsg_nosec() treats
that as an impossible return and triggers a BUG. On systems configured
to panic on oops, a CAP_NET_RAW holder can panic the host kernel.

Stop before the next frame would make the byte count exceed INT_MAX.
The positive short count leaves that frame pending for a later send
call.

A two-thread TPACKET_V2 reproducer triggered the BUG on an arm64 build
of Linux 7.3-rc4. With this change, the same reproducer returned the
expected positive short count without an oops.

Fixes: 69e3c75f4d54 ("net: TX_RING and packet mmap")
Cc: stable@vger.kernel.org
Signed-off-by: Ilkka Lappeteläinen <ilkka.lappetelainen@gmail.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260925124829.6595-1-ilkka.lappetelainen@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/packet/af_packet.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2912,6 +2912,9 @@ static int tpacket_snd(struct packet_soc
 						    vnet_hdr.hdr_len);
 			has_vnet_hdr = true;
 		}
+		/* Prevent the byte count from wrapping into a negative errno */
+		if (unlikely(tp_len > INT_MAX - len_sum))
+			break;
 		copylen = max_t(int, copylen, hard_header_len);
 		skb = sock_alloc_send_skb(&po->sk,
 				hlen + tlen + sizeof(struct sockaddr_ll) +



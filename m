Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622163;
	b=z/XlTMMuYHPqCKfe+ktHjy2eaVJtCn7Az10lUUBL4jVwe7ATw+CU7VTnIYkRkZ88CpVc
	 rNbu2LcRcy983olL2Bv1bduGhWk2jnRlbItt8mvwuHKFiDwS1ZtiNc+xa7mh9D4Ewdo+R
	 /uQevUl8nz/uhyW2lBNUensp4bEq6iYPYgBLVphW2loQwXbl3Mb6chEX83dpdJcaH2lmd
	 J0VsniOFv1Ro61O3+5C9UXI19ZDQkDaBvv/xYeeaY/uXBp5Eg/gDxqtK50Gxj3A/zlU9U
	 7EERv3uI6X0OAMTl/FdOJPpnJLG4ud0ICktPYJ49B918UBuiMvYv1q9dhnAWHEh/hkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622163;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=run6MzpBwN8FZ0I2hJFn5HwYkVk9YEQNX0pya5GdhJw=;
	b=XhPFbGdpsqYp9NtwHDa4aVWZ90dhDwu0FReDLzdxy+iTGeJ/yvpA+sBo5G6bK1q+0r7m
	 XHoCX8iXiaVCqek30BTsSHvquss3WfFpeXbjO6u+cAiR7bpE5bUWu+W13QJ5n25FWLSg8
	 Q+bCZuerzsboJovE/GeYctyoilzKLeukFx3thvAvTEa3dM18M5gu3zNPkLhqvnzFjbzDY
	 tRYQYzZuCFUi6HkXA6v/hamMVvs10U+qGm2tXnavh76WC8feBiL9HuhSUwrcWbb7HaxaP
	 JJ69m3jA04Uc98n5O+7KzYjIY6Jvz+MTbrDFT5PGJHThLKdq/vThaQPP4YW2SN3WxeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fq17Ov7S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5A62606A33B;
	Wed, 25 Nov 2026 15:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fq17Ov7S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 022431F008B2;
	Wed, 25 Nov 2026 15:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622163;
	bh=run6MzpBwN8FZ0I2hJFn5HwYkVk9YEQNX0pya5GdhJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fq17Ov7S5vznlaTehItVECQhpJPZ4du5CSZUujaOGDsTV7hyG1oCLBrGFROzPaMRd
	 bzFEcv3s4cnM+5UgFsLW53Bb3tK4QEiZ0v6AKK1GT1kEUCyinUK4AeBG14DupFJmO+
	 qnamL/h5OV9Qr8sdg/o7d6n2S53aQbL9A/UJRxjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Willem de Bruijn <willemb@google.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 442/990] net: gro: compare skb->protocol in gro_list_prepare()
Date: Wed, 25 Nov 2026 15:30:09 +0100
Message-ID: <20261125143832.448257380@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@kernel.org>

[ Upstream commit 511582022bfd07475d0daa209e6e6aa5a940740d ]

gro_list_prepare() checks whether a held packet may belong to the same
flow as the incoming one by comparing the device, VLAN tag, metadata
and the link-layer header, using dev->hard_header_len as its length.

On devices without a link-layer header (hard_header_len == 0), such as
L3 GRE tunnels, no compared byte carries the outer protocol:
skb->protocol comes from the tunnel header. Packets of different
protocols can then stay eligible, and the GRO handler selected from the
incoming skb->protocol parses the held packet with the wrong layout.

For example, take an IPv4/UDP packet held by UDP GRO and a
VLAN/IPv4/TCP packet received on the same ipgre device.
vlan_gro_receive() reads the first four bytes of the held IPv4 header
as a VLAN header. With crafted values, the held packet survives up to
tcp_gro_receive(), which uses its UDP header as a TCP header. With a
short linear part, the FIN/PSH update of the held packet's TCP flags
can then write into skb_shared_info.

The VLAN, GRE, IPv4 and IPv6 GRO handlers compare the next-protocol
field of their own header, so once the outer protocol matches, the
inner layers are checked too. Only the outermost protocol was not
compared.

Compare skb->protocol too. On Ethernet devices this is redundant with
compare_ether_header(), but it is cheap.

GUE direct IP encapsulation has a similar issue, but there both packets
have the same outer protocol, so it is fixed separately in
gue_gro_receive().

Fixes: 60769a5dcd87 ("ipv4: gre: add GRO capability")
Reported-by: Kyle Zeng <kylebot@openai.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Link: https://patch.msgid.link/20261109164540.3104392-1-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/gro.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/gro.c b/net/core/gro.c
index a7b3fdc1f7bae..28006c0960871 100644
--- a/net/core/gro.c
+++ b/net/core/gro.c
@@ -379,6 +379,7 @@ static void gro_list_prepare(const struct list_head *head,
 		}
 
 		diffs = (unsigned long)p->dev ^ (unsigned long)skb->dev;
+		diffs |= p->protocol != skb->protocol;
 		diffs |= p->vlan_all ^ skb->vlan_all;
 		diffs |= skb_metadata_differs(p, skb);
 		if (maclen == ETH_HLEN)
-- 
2.53.0




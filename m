Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061500;
	b=ty+L3cUTePGVzNoftthLtIUOnO5X8HKjMKe/wX9Fe6jFkYUhlFyv88jYbAI6pn2OVSUN
	 pIgR4uEy7u7OVv1wrFD3za4KYJOAhLWFkO89harGK0oY8q/sB5IXucvF6MEctin3w8Tql
	 YDrl3yiv6pIytIXTJ12bE8zw6En79/T3TWLVhaRM4DfKmeofWBnsD1+sEMrDZCBhd+j2c
	 6xeuEOiwqjcMXMBgM6YKRrcUDkpn97A5e32VVm9iH7vPyEY3Agw5TPN2n5ZOaUXQSKrVK
	 /D9h+2PyJ93vKBnXTzvGvxqF0utSHrom9dnmDLx5EL6J4t+YQC3zD6bObb/PG77AZ5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061500;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=AMZ2LGr8u7XwsxN3I7QbYyjO++iyQV4sFKBd0+HG2eU=;
	b=Rhyfc0SZR3zMey4xk5IeJqidagSTpdowxpCtKgJq6nMyyS43JErf+WHh+fnDnWHT3PJ1
	 ZuZeEgW1RRqL4hHyGINuxUdH5HHjY5GFJf9ri/J1W3swXNEqe5+AL4MGlDvQ2VhkV+65r
	 kBpcO23pzOwp5UjIl881DLMs47L5EAjd1/YwDTMjZRV/qi+FZFnos6d60Nd2M4DlqIwCh
	 0rktKXl95StPhZhqjALRuDqBq3rpRt27QzZaU3nZW+qzpCCroIRzKhVzz7DN7shKhoD6Y
	 HS/zoTuZKJzPBj25U6WmoYBU5AGOs0DTH0HPU4fFLIjQdkYAMq6rT74gfn/uqwJEmig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T1Wder3W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 634E5606A331;
	Sat,  7 Nov 2026 14:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T1Wder3W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D75FC1F0089F;
	Sat,  7 Nov 2026 14:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061500;
	bh=AMZ2LGr8u7XwsxN3I7QbYyjO++iyQV4sFKBd0+HG2eU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T1Wder3WUrTUPzwCE8LDLLIb6YvaxeX+oVVFMZxkYIuON1omoWsiigH9mhGsySBJ4
	 3t6NFVPfLJ3X8YQWmBk9MLvfvH9V/HbtZIKUjGBz1ZKxsYRDZ/nBzGKIpi2bH4O/RP
	 8uBJRwQvlFygqP9g47HjNezgDEgEkZm5EORVWd+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jan=20=C4=8Cerm=C3=A1k?= <sairon@sairon.cz>,
	Stefan Agner <stefan@agner.ch>,
	hitchin999 <hitchin999@users.noreply.github.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0595/1536] vlan: restore HW VLAN tag insertion with reorder_hdr off
Date: Sat,  7 Nov 2026 08:43:31 -0500
Message-ID: <20261107135014.254739344@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@kernel.org>

[ Upstream commit c2124f80be4ceb6ec566ca3b5fc87f84ea9c36e0 ]

Commit 447cbe95ebb9 ("vlan: fix skb_under_panic and races when toggling
HW VLAN offload") replaced vlan_passthru_header_ops with vlan_header_ops
unconditionally to avoid lockless data races when modifying
hard_header_len dynamically under RTNL.

Prior to that commit, vlan devices on top of a real device capable of
HW VLAN TX offload used vlan_passthru_header_ops, which never inserted
the 802.1Q header in the frame.

Now, with reorder_hdr=off (as done by Home Assistant OS / NetworkManager
when flags are omitted over D-Bus), vlan_dev_hard_header() always pushes
an in-band 802.1Q header, and vlan_dev_hard_start_xmit() hands the frame
to the real device as is, even if the real device supports HW VLAN TX
offload.

This is a regression for r8169 users (Realtek RTL8168h), who report
transmit queue timeouts (NETDEV WATCHDOG): this NIC stalls when asked
to offload checksum and/or TSO for frames carrying an in-band tag.
Users of r8152 based USB adapters were affected as well.

Reverting the blamed commit, disabling TX checksum offload (which
also disables TSO), or setting reorder_hdr=on were all reported to
work around the issue.

Keep vlan_dev_hard_header() as is: the in-band header keeps the frame
layout seen at the vlan device egress (taps, tc, netfilter) unchanged,
and is relied upon by stacked vlans (Q-in-Q) and by AF_PACKET SOCK_DGRAM
users sending ETH_P_8021Q frames.

Instead, when vlan_dev_hard_start_xmit() gets a frame carrying an
in-band tag with our protocol and the real device can insert tags,
move that tag to skb->vlan_tci with __skb_vlan_pop(), so that the real
device inserts it. Frames sent on the wire are unchanged, except that
frames shorter than 64 bytes with their tag now get up to 4 bytes of
extra padding, as with reorder_hdr=on and before 447cbe95ebb9.

skb_reset_mac_header() is needed first, because not all ndo_start_xmit()
callers set the mac header (e.g. AF_XDP copy mode, which uses
__dev_direct_xmit()).

vlan_set_encap_proto() may read the two bytes after the vlan header,
so frames whose linear part is shorter than VLAN_ETH_HLEN + 2 are sent
unchanged, as before. This also makes sure h_vlan_proto, read earlier
in the function, was in the linear part. Shared skbs (e.g. from
pktgen) are also sent unchanged, since popping the tag modifies the
skb, as are skbs already carrying a hwaccel tag (e.g. from generic XDP
redirect), whose tag must not be overwritten, skbs carrying XDP
metadata, which the pop would have to move, and CHECKSUM_PARTIAL skbs
whose csum_start lies within the first VLAN_ETH_HLEN bytes (only
possible with bogus offsets, e.g. from AF_XDP tx metadata), which the
pop would leave before skb->data.
If popping the header fails (memory allocation failure), the frame is
dropped and counted in tx_dropped, rather than handing the real device
a frame with an in-band tag.

tx_bytes is now sampled before the pop, so the vlan device statistics
do not change.

This also applies to frames provided by the sender with our tag
(AF_PACKET SOCK_RAW, or frames redirected from another reorder_hdr=off
vlan): the real device now inserts their tag too.

Fixes: 447cbe95ebb9 ("vlan: fix skb_under_panic and races when toggling HW VLAN offload")
Reported-by: Jan Čermák <sairon@sairon.cz>
Closes: https://lore.kernel.org/netdev/CAPa5EdCj3v17tB-SF2JNecq5Q8s1Pranr-XzAFWNpNTBPgPG7w@mail.gmail.com/
Reported-by: Stefan Agner <stefan@agner.ch>
Reported-by: hitchin999 <hitchin999@users.noreply.github.com>
Closes: https://github.com/home-assistant/operating-system/issues/5019
Tested-by: Jan Čermák <sairon@sairon.cz>
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://patch.msgid.link/20261013115022.1043024-1-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/8021q/vlan_dev.c | 33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index 61fb68fadea33..7a874d1a18192 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -109,6 +109,8 @@ static netdev_tx_t vlan_dev_hard_start_xmit(struct sk_buff *skb,
 	unsigned int len;
 	int ret;
 
+	len = skb->len;
+
 	/* Handle non-VLAN frames if they are sent to us, for example by DHCP.
 	 *
 	 * NOTE: THIS ASSUMES DIX ETHERNET, SPECIFICALLY NOT SUPPORTING
@@ -120,10 +122,39 @@ static netdev_tx_t vlan_dev_hard_start_xmit(struct sk_buff *skb,
 		vlan_tci = vlan->vlan_id;
 		vlan_tci |= vlan_dev_get_egress_qos_mask(dev, skb->priority);
 		__vlan_hwaccel_put_tag(skb, vlan->vlan_proto, vlan_tci);
+	} else if (skb_headlen(skb) >= VLAN_ETH_HLEN + sizeof(__be16) &&
+		   !skb_shared(skb) && !skb_vlan_tag_present(skb) &&
+		   !skb_metadata_len(skb) &&
+		   (skb->ip_summed != CHECKSUM_PARTIAL ||
+		    skb_checksum_start_offset(skb) >= VLAN_ETH_HLEN) &&
+		   vlan_hw_offload_capable(READ_ONCE(vlan->real_dev->features),
+					   vlan->vlan_proto)) {
+		u16 vlan_tci;
+
+		/* The frame carries its outer tag in-band, either inserted
+		 * by vlan_dev_hard_header() or provided by the sender.
+		 * Let the real device insert it: some NICs can not offload
+		 * checksum or TSO for frames carrying an in-band tag.
+		 * Not all ndo_start_xmit() callers set the mac header.
+		 * vlan_set_encap_proto() may read two bytes after the vlan
+		 * header, so frames with a shorter linear part are sent
+		 * unchanged, as are shared skbs (e.g. from pktgen), skbs
+		 * already carrying a hwaccel tag (e.g. from generic XDP
+		 * redirect), skbs carrying XDP metadata, and CHECKSUM_PARTIAL
+		 * skbs whose checksum starts within the header to be popped.
+		 * On allocation failure, drop the frame rather than handing
+		 * it to the real device with an in-band tag.
+		 */
+		skb_reset_mac_header(skb);
+		if (unlikely(__skb_vlan_pop(skb, &vlan_tci))) {
+			dev_kfree_skb_any(skb);
+			this_cpu_inc(vlan->vlan_pcpu_stats->tx_dropped);
+			return NETDEV_TX_OK;
+		}
+		__vlan_hwaccel_put_tag(skb, vlan->vlan_proto, vlan_tci);
 	}
 
 	skb->dev = vlan->real_dev;
-	len = skb->len;
 	if (unlikely(netpoll_tx_running(dev)))
 		return vlan_netpoll_send_skb(vlan, skb);
 
-- 
2.53.0




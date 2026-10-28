Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217363;
	b=ZIKwuuBCQZ6Cd3LlSJYTD7hItzgcMFEJo51WBQKLpIL9M9gwCwsKbt5JQ7b6vLHG8Lkl
	 y9KEyGQF44pwuhXfakNgo3Ar0MaOPWP9mMeX5DsDETJd6ZsXk7vi9mh7gtE9oe8o64aDh
	 E7sZxDH3BwVo7K4BJTH1ufhh5pd+J9eKNvkqQ4mryYo5O7wvU8vZUtQVMJGM54Ib4Gd5s
	 2ZjCmKOB+a9Nu/eo0w+lBIN65PM6h1R2rmjhXrHNtCfCQo4F3vZbht3EoCW6tgXmz725e
	 HkQD3z2/vysGZ2jMeOrbuSOQwl1F6BdiZfwt83YqxVkz3mUssxw/TkldfdEa8io6CeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217363;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=XueSKFxs21LS32s0ZCSlOdJGeDSQp97KxZ9TDoSOFHY=;
	b=ntBR9pJXpzeU4W5BlPdM08r3iFgM2aVagiYLsFoOQqLXNlhgwKa2M6xa0EHsoWmWvLNn
	 UzdmUtRK4mSmzFfRXOSgtLrVslKQzPWs4NcrQNzhMZEfG2YE7+UE1pxhX/aRqQEf2/SQS
	 hRwC5d38ICgwbtqnIAQiNJSG6hM67ReC7HXXUFMrwFeEXxn6HniulvpHQTSsIwqHzdNaP
	 EB/6Gk6hZ7YQsNoZrPiZup3MpipoEti1WnhveG85dB5IosAwl0vcoYV8yXytnQQi2Lvxj
	 krzxxUGugjcV+dIMCxH2Mc7eL4ZKpgrwirEvy0xZsqcPuViDFQWSZntTLyffZIOE0Bw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vxhGXPOe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98970606A31C;
	Wed, 28 Oct 2026 19:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vxhGXPOe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5DAD1F01825;
	Wed, 28 Oct 2026 19:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217363;
	bh=XueSKFxs21LS32s0ZCSlOdJGeDSQp97KxZ9TDoSOFHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vxhGXPOerUef8sbETwSI2T9g4NvgxTrjl4g9n5B790Ea5ra/62bYsRQij8evRqvMK
	 1GUvicAW8MZWYNVhU2qT6/70d/BXoXEOUOPD8GT83B7+IADNO3t3sV33EiEU4esXy8
	 NZxSH2Npk7cJEshrfveJNlNJWqE2XsJzJQOQz2Kw=
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
Subject: [PATCH 6.1 1876/1887] vlan: restore HW VLAN tag insertion with reorder_hdr off
Date: Wed, 28 Oct 2026 18:06:12 +0100
Message-ID: <20261028170542.146084515@linuxfoundation.org>
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
index f43dfd8f19d96..37ccd570419c3 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -108,6 +108,8 @@ static netdev_tx_t vlan_dev_hard_start_xmit(struct sk_buff *skb,
 	unsigned int len;
 	int ret;
 
+	len = skb->len;
+
 	/* Handle non-VLAN frames if they are sent to us, for example by DHCP.
 	 *
 	 * NOTE: THIS ASSUMES DIX ETHERNET, SPECIFICALLY NOT SUPPORTING
@@ -119,10 +121,39 @@ static netdev_tx_t vlan_dev_hard_start_xmit(struct sk_buff *skb,
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




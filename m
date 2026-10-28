Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213412;
	b=b4nyksSNBbt3RpfUW4vNGjkVBt2mNkgKn9ns1HI56wOQ75oUgjT/t/W/PJsxUFZraaSM
	 Q11fyZIF2GbcIHwV0CSwR+7FUyHogCkKOIykxqMcdv912Q1GMJFa44qYtYor4yKkv1DO3
	 0pV64dHu01dL4HZSTuAU0JUAQTIF1065FMnWKJwNfozcw0jbaltskwigPVF5W4Cfm1EKa
	 SIDHxtLzBz2v8OR75HPhlmsUY/nkdvM77fHcyzT2FxpBh7QH0dTU3hiKEhjXmJHVrrx2n
	 34r1Zaa9JcREqFj6Ze3NTZPhkaEB904T+y3F1heA5yhaJN8p//uo7d+90Ry3nIsYRKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213412;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CXajO8x6i+5nbGDK5O+CIddxcXVxn3m7jSq6ye/1s9M=;
	b=eesO/+GkmRT/dC38pLTuzoTW3P98bklCOW+sxfIsi77IjgqmKGBlQg6H+mAdu4RoLWUJ
	 v62yB/NTY2kN9FcIp+E7TBFztZpGM8DXqFJqE3Dc89/WXuwFtjNYoqm9xd+atbC/5zfnD
	 1uqm/R+k9UK1WjnZ0gwS3o+rPnyWkmQJRMxLmT1D+llZwZsO3TbZbC8C7Mzv2D7G9Cb4Y
	 TPC3Bwn0O/UR92tVKWjyxop6ZShoz/zCaYT4Uw3tMQhAqQRD5WAm095mNQUcA8muLPiBR
	 S3bn5NtNFArDN9iiF+vx+E7RwpkNHpdVQN4CErPTTfqrNQ9pNHy5aKI+0OWTPQ3cgUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QsanfmFS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5108A606A31E;
	Wed, 28 Oct 2026 18:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QsanfmFS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D9961F01825;
	Wed, 28 Oct 2026 18:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213410;
	bh=CXajO8x6i+5nbGDK5O+CIddxcXVxn3m7jSq6ye/1s9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QsanfmFStwHh3K/vGgg9vrUEq2FqtA3ZaM4h0Knpb7URB6varKKO0N5neNDQj4wFO
	 v+SAWcKx0TzmRBfTEgMlkfNXi/t3PnH/XbyIYDpZBQgfFFoQ7C7KEQLILuEEsOkrws
	 q2I1dDI9c6k170rpJdwcD0Y3ZY5BkJ1Q10vw7RJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4cc63fcfb3845e149969@syzkaller.appspotmail.com,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Ilya Maximets <i.maximets@ovn.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0497/1887] net: openvswitch: validate transport header presence in set_ipv6_addr
Date: Wed, 28 Oct 2026 17:43:13 +0100
Message-ID: <20261028170510.597045421@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit 3c6a4b11330fe424557538a98fca9f0a4c5bf313 ]

When executing IPv6 address rewrite actions on IPv6 fragments,
set_ipv6_addr() calls update_ipv6_checksum(). If parse_ipv6hdr()
processes a non-first IPv6 fragment, it sets key->ip.proto to
NEXTHDR_FRAGMENT and returns early without calling
skb_set_transport_header().

update_ipv6_checksum() unconditionally evaluates skb_transport_offset()
on entry before checking l4_proto.  Because skb->transport_header is
uninitialized, this triggers a warning under CONFIG_DEBUG_NET=y although
it is completely harmless.

Fix this by returning early in update_ipv6_checksum() if l4_proto is
NEXTHDR_FRAGMENT. This avoids reading the uninitialized transport offset
for fragments while preserving the debug warning for any other protocol
where the transport header is unexpectedly missing.

See the syzbot trace:

!skb_transport_header_was_set(skb)
WARNING: ./include/linux/skbuff.h:3075 at skb_transport_header include/linux/skbuff.h:3075 [inline], CPU#1: syz-executor463/5635
WARNING: ./include/linux/skbuff.h:3075 at skb_transport_offset include/linux/skbuff.h:3250 [inline], CPU#1: syz-executor463/5635
WARNING: ./include/linux/skbuff.h:3075 at update_ipv6_checksum net/openvswitch/actions.c:361 [inline], CPU#1: syz-executor463/5635
WARNING: ./include/linux/skbuff.h:3075 at set_ipv6_addr+0x462/0x660 net/openvswitch/actions.c:399, CPU#1: syz-executor463/5635
[...]
RIP: 0010:skb_transport_header include/linux/skbuff.h:3075 [inline]
RIP: 0010:skb_transport_offset include/linux/skbuff.h:3250 [inline]
RIP: 0010:update_ipv6_checksum net/openvswitch/actions.c:361 [inline]
RIP: 0010:set_ipv6_addr+0x462/0x660 net/openvswitch/actions.c:399
[...]
Call Trace:
 <TASK>
 set_ipv6 net/openvswitch/actions.c:531 [inline]
 do_execute_actions+0x557e/0x8600 net/openvswitch/actions.c:1366
 ovs_execute_actions+0xde/0x520 net/openvswitch/actions.c:1592
 ovs_packet_cmd_execute+0xb4f/0xf10 net/openvswitch/datapath.c:705
 genl_family_rcv_msg_doit+0x233/0x340 net/netlink/genetlink.c:1114
 genl_rcv_msg+0x614/0x7a0 net/netlink/genetlink.c:1209
 netlink_rcv_skb+0x226/0x4a0 net/netlink/af_netlink.c:2572
 genl_rcv+0x28/0x40 net/netlink/genetlink.c:1218
 netlink_unicast+0x7bd/0x940 net/netlink/af_netlink.c:1361
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1916
 sock_sendmsg_nosec+0x14e/0x190 net/socket.c:800

Reported-by: syzbot+4cc63fcfb3845e149969@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=4cc63fcfb3845e149969
Fixes: 3fdbd1ce11e5 ("openvswitch: add ipv6 'set' action")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Reviewed-by: Ilya Maximets <i.maximets@ovn.org>
Link: https://patch.msgid.link/20261008104135.4722-1-fmancera@suse.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/actions.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index 679409953ac50..00a3e0af95658 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -380,7 +380,12 @@ static void set_ip_addr(struct sk_buff *skb, struct iphdr *nh,
 static void update_ipv6_checksum(struct sk_buff *skb, u8 l4_proto,
 				 __be32 addr[4], const __be32 new_addr[4])
 {
-	int transport_len = skb->len - skb_transport_offset(skb);
+	int transport_len;
+
+	if (l4_proto == NEXTHDR_FRAGMENT)
+		return;
+
+	transport_len = skb->len - skb_transport_offset(skb);
 
 	if (l4_proto == NEXTHDR_TCP) {
 		if (likely(transport_len >= sizeof(struct tcphdr)))
-- 
2.53.0




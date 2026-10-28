Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209131;
	b=Db9a1GP4hZI1DtCgROKzog+P3fMf9kC6OzR1vd7SU68VWCKrQ4alF9Eg1pVphyZ1FQaG
	 7NZj9rRz431hhNyWtusX4wf678hUDG0e5ypom1BHWHKwscP7/KWAdiJ2aRWCPFJqweItL
	 /RYhA7IgopNojaz7FLTZWyZySI8XPT6ua2bg93ekniYh1x52r03FvrL9tzZCfPBLKiF3u
	 //MBPiktmiBbY8892IajfmZHlqZtrJyOK915ZviqEIAlaWDqryqOb1V6U3FhFyJ12r0JK
	 NdDMRvKGqaCZed+L5yK1Qz4wnmP7TKaU8E/6ag2IVRUPWnAEUnien1fFKV1YFnNhtjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209131;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R/7MEcOpBoLtV3gzeseJM4zj6s+vR7ZLfcrAs87nD/E=;
	b=2i5X2DjuBysyTMimmFaisl1LiYKfv+XZdsff3i+PPhdKN51+14ueiPsDLhAqmjhomqVX
	 R6xRoZk+cVB2XdWGQP81j93Nc/W1khM9a4tW9wisC1aVhX+dLOR5IdTlxTpgRZABg/2Bp
	 t+guUhZTxunBv+WRGSe3njc43UgoCRkKnT3oidHEvDyQmfTyFsB8gVnR2DprJ8Hgtlcqi
	 uUBev+ICnaPcEL3cbYpab4icaO04wmFt48hKBqtenFPj40+FtlENs9TEqJ5k8FCWftPPx
	 SLt1ON7mpvZZmIBFlx7p+kS453inQf1v3E+jp+Um84Dw9y4yFZN1KOz1mhQWkj9Dy6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bw4kL++e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB197606A324;
	Wed, 28 Oct 2026 17:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bw4kL++e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4692F1F01825;
	Wed, 28 Oct 2026 17:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209130;
	bh=R/7MEcOpBoLtV3gzeseJM4zj6s+vR7ZLfcrAs87nD/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bw4kL++exJzLk4ZS0OYR92mgmvm8Ito1MMSPoS4If/H5wr7W5z2IcpAEhNTxJhTVt
	 W0Bl+Oj7OtSO9wS4vzg9F+xK/Vr15UYCZboBTzqDePZuJ0a+UrB8nHRer0ehhvS06M
	 3akysrbfwIyMsjyBkdGNTvOgPzauacBPwrBeOo5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4cc63fcfb3845e149969@syzkaller.appspotmail.com,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Ilya Maximets <i.maximets@ovn.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 362/516] net: openvswitch: validate transport header presence in set_ipv6_addr
Date: Wed, 28 Oct 2026 17:58:34 +0100
Message-ID: <20261028170012.061823207@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 99fff9d6596c8..b23fd48105751 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -379,7 +379,12 @@ static void set_ip_addr(struct sk_buff *skb, struct iphdr *nh,
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




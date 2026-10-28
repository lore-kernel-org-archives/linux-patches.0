Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214221;
	b=LyXgaNx+NnVS16sG67LvDWrnMcXgGFQt7t16ZWMVeeqlKBoKyPhUie+V2b0l3A/UicsL
	 wOIl00+3hUhGvtRh3y4FH8CMXO5bXR9U8IVexsFOL5C8HApBzofqfsr5/DSKi10MM/4rb
	 UXhReaCRJpl4XGlgLZBn9TAvQEB1UkVbA/u3TLQYKR+uans1uorQ6oklFsPlegRHfIyyz
	 Sf4NC+W5akuL98U0cOKVPPjO/i0rGr2r2dD4RZRMAbhCQGDLaaT0KhY9zfwK4OZ2Abytg
	 lBi589srHhPer6hbSJ/Mg6FQSwLQv9nYEvd/TEYcBpUNCP276irxn87KS1ZaFpbTrBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214221;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2vNMLPiAi5I7+u4HlTHG6Z7B4HYl7zLL19m+qlYBlRY=;
	b=Jd5C4jBKafA3KM957bb75pVTUFdyOGgqlBFge5n8SLWgAFayycn7I2pu7EapcY0RSkIP
	 O8nv82mPtF3rkt8s5qjkafBG4TQyU846ygjsYWy/RJtIjEWRGGuU9TDNbsgCsxrAp19Fq
	 g76o9cM3Svqh2W0uova9i4DIG/J8yd0Qks50GJAMLSle9eZw8wJXuD/ZI+7vYtdDJclgD
	 R5RFW27jHytwRZzl9QYaejfj/G5gcFDe0xGFPLr2bv3w5XNWYGb7R7VSV8ni3UEm4/ak3
	 gpgXPqWW2Wj+HJWYvikpyw6SN5nHPHC1mAam4591yhaExbSNSc/TlyKzREy1iTOm+sQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tplxPFTk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 380E060A2622;
	Wed, 28 Oct 2026 19:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tplxPFTk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89F811F013C8;
	Wed, 28 Oct 2026 19:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214221;
	bh=2vNMLPiAi5I7+u4HlTHG6Z7B4HYl7zLL19m+qlYBlRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tplxPFTkVtUR8EIBkNj5ean4YuL+/sW0zbLKye1y7YqZGjRA9CZvTr6TF11/qYjUD
	 L1IhNLKeTczQcH2kFxdooojcHixYRVpcbAoDUT4q8SNN7fgJjaDRfGhUzzKRtSoL7H
	 6Xb2vuLksDb9gzKJLO27t6NygSC6R0uhe3aDX1I4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e76d52dadc089b9d197f@syzkaller.appspotmail.com,
	syzbot+1065a199625a388fce60@syzkaller.appspotmail.com,
	Matt Johnston <matt@codeconstruct.com.au>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0782/1887] net: mctp: Dont access ifa_index when missing
Date: Wed, 28 Oct 2026 17:47:58 +0100
Message-ID: <20261028170517.234858016@linuxfoundation.org>
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

From: Matt Johnston <matt@codeconstruct.com.au>

[ Upstream commit f11cf946c0a92c560a890d68e4775723353599e1 ]

In mctp_dump_addrinfo, ifa_index can be used to filter interfaces, but
only when the struct ifaddrmsg is provided. Otherwise it will be
comparing to uninitialised memory - reproducible in the syzkaller case from
dhcpd, or busybox "ip addr show".

The kernel MCTP implementation has always filtered by ifa_index, so
existing userspace programs expecting to dump MCTP addresses must
already be passing a valid ifa_index value (either 0 or a real index).

BUG: KMSAN: uninit-value in mctp_dump_addrinfo+0x208/0xac0 net/mctp/device.c:128
 mctp_dump_addrinfo+0x208/0xac0 net/mctp/device.c:128
 rtnl_dump_all+0x3ec/0x5b0 net/core/rtnetlink.c:4380
 rtnl_dumpit+0xd5/0x2f0 net/core/rtnetlink.c:6824
 netlink_dump+0x97b/0x1690 net/netlink/af_netlink.c:2309

Fixes: 583be982d934 ("mctp: Add device handling and netlink interface")
Reported-by: syzbot+e76d52dadc089b9d197f@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/68135815.050a0220.3a872c.000e.GAE@google.com/
Reported-by: syzbot+1065a199625a388fce60@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/681357d6.050a0220.14dd7d.000d.GAE@google.com/
Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
Link: https://patch.msgid.link/20250508-mctp-addr-dump-v2-1-c8a53fd2dd66@codeconstruct.com.au
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mctp/device.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/net/mctp/device.c b/net/mctp/device.c
index 47407c07afc27..365726010340d 100644
--- a/net/mctp/device.c
+++ b/net/mctp/device.c
@@ -120,12 +120,19 @@ static int mctp_dump_addrinfo(struct sk_buff *skb, struct netlink_callback *cb)
 	struct net_device *dev;
 	struct ifaddrmsg *hdr;
 	struct mctp_dev *mdev;
-	int ifindex;
+	int ifindex = 0;
 	int idx = 0, rc;
 
-	hdr = nlmsg_data(cb->nlh);
-	// filter by ifindex if requested
-	ifindex = hdr->ifa_index;
+	/* Filter by ifindex if a header is provided */
+	if (cb->nlh->nlmsg_len >= nlmsg_msg_size(sizeof(*hdr))) {
+		hdr = nlmsg_data(cb->nlh);
+		ifindex = hdr->ifa_index;
+	} else {
+		if (cb->strict_check) {
+			NL_SET_ERR_MSG(cb->extack, "mctp: Invalid header for addr dump request");
+			return -EINVAL;
+		}
+	}
 
 	rcu_read_lock();
 	for (; mcb->h < NETDEV_HASHENTRIES; mcb->h++, mcb->idx = 0) {
-- 
2.53.0




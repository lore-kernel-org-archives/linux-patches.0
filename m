Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618064;
	b=F+lb+USmS1HRPmkTRGxlqWQSDUmZ2vf1+CfgkVKZS+fUS9Vw8mSz/mB6hJkiR2QOAFTT
	 3FwIPXA0vy6DmJ4W7iLZFWs35L1NmS1Se5GNC0YsVFl0n7F0j9V3keZv6fuxzvduSZ2Id
	 bgBRxAe56bfwUU0lTA4dgdvifNmesAcT46bWpH35GjaBke9I7JDNsuhucrZFf+0muTqwi
	 7HtX6G4b5wPv+DicjoSkN8zCa1+Jx7jkbNU/2dPeLtcF7jRlZzQQFqH8LfPdsnZ40VxeZ
	 oqVffI5qkYB/YgJ8sGdTXws/nWpqJ9vLBZ6pXcx2HGtPUxpELlvWlE3qKjbobI6V8oQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618064;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iZ5h3DvPCuM/aolXID5ce5xsIcQ4+xT8tKleuoO1UYg=;
	b=ou7Z7jm9C9Sn6XzDHDXYl+oUguqkAP1a4ryckkRhiU8Dpzx6ldZWA8DbzjXqBx5nQZp8
	 i9IYWM5TrBqGctjSDyst63gl+TRn4LWmDfWhQIQDbBF5NguC2OUvKVMyzEsnFxr3PUEzv
	 BsF6mjHXYMr2W5bWV7lgv08lPUXBLGEsVC1YUDFPrpFsgz2ilSAEMRCEIl7kAcT0Ka1T2
	 i/8+irckhTN947oceT/4+SI/vb+7IFUh0mmAuSAO6RfMGaLkInjTdJDpfAqpiVVB5lmH5
	 Ojxggc4oAUZ7pPJ9ZJiqmCN2ObvABp8jOjnf0cT41beVMNp9eq1wM688yipsGTwIZlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AdEJesp3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5BCB606A321;
	Wed, 25 Nov 2026 14:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AdEJesp3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 921031F000C4;
	Wed, 25 Nov 2026 14:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618064;
	bh=iZ5h3DvPCuM/aolXID5ce5xsIcQ4+xT8tKleuoO1UYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AdEJesp3ungjwOJmKS9hbumHUx2/22OxAAYeWL5mW2lfAkH6Gt05aKG5+EmeUPu99
	 SOz6dZswQCjnE+0Cps49lBR3zj69/hYqfnk/+vcWoEELizg6y/31ylbRolzmwuYMHQ
	 tnolpmLA7z8E+7wpg0D3X8BWoJoLDP7n7U2IRfek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+6dcbccedc9ec6452@bugs.sh,
	Xiang Mei <xmei5@asu.edu>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Paul Moses <p@1g4.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0159/1005] vdpa: fix double free of the reply skb in vdpa_nl_cmd_dev_config_get_doit()
Date: Wed, 25 Nov 2026 15:24:57 +0100
Message-ID: <20261125143825.463787814@linuxfoundation.org>
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

From: Xiang Mei <xmei5@asu.edu>

[ Upstream commit 1f8824fe7f6eaaf2355404db08d3cd05a28aa576 ]

genlmsg_reply() consumes the reply skb on every outcome: netlink_unicast()
frees it whether it queues it, drops it, or bails out early.
vdpa_nl_cmd_dev_config_get_doit() lets its return value fall through to the
shared error label, which calls nlmsg_free(msg) again and double-frees the
sk_buff on any reply failure. The failure is reachable unprivileged:
VDPA_CMD_DEV_CONFIG_GET carries no GENL_ADMIN_PERM, so batching several
requests into one sendto() on a socket with a shrunken SO_RCVBUF fills the
receive queue, and netlink_attachskb() then takes its MSG_DONTWAIT path,
freeing the skb and returning -EAGAIN.

Set msg to NULL once genlmsg_reply() has consumed it so the shared exit
path frees the skb only on the early error gotos that still own it;
nlmsg_free(NULL) is a no-op.

  BUG: KASAN: slab-use-after-free in sk_skb_reason_drop (net/core/skbuff.c:1220)
  Read of size 4 at addr ffff88800d99d49c by task exploit/147
  Call Trace:
   sk_skb_reason_drop (net/core/skbuff.c:1220)
   vdpa_nl_cmd_dev_config_get_doit (drivers/vdpa/vdpa.c:1324)
   genl_family_rcv_msg_doit (net/netlink/genetlink.c:1114)
   genl_rcv_msg (net/netlink/genetlink.c:1194)
   netlink_rcv_skb (net/netlink/af_netlink.c:2556)
   genl_rcv (net/netlink/genetlink.c:1218)
   netlink_unicast (net/netlink/af_netlink.c:1345)
   netlink_sendmsg (net/netlink/af_netlink.c:1900)
   __sys_sendto (net/socket.c:2281)
   __x64_sys_sendto (net/socket.c:2284)
   entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)

  The buggy address belongs to the object at ffff88800d99d3c0
   which belongs to the cache skbuff_head_cache of size 232
  The buggy address is located 220 bytes inside of
   freed 232-byte region [ffff88800d99d3c0, ffff88800d99d4a8)

Fixes: ad69dd0bf26b ("vdpa: Introduce query of device config layout")
Reported-by: co+6dcbccedc9ec6452@bugs.sh
Closes: https://lore.kernel.org/all/ILTHcT8oe1HP47sY25JVxssvKmkCTjYlX9Hs%40bugs.sh/
Assisted-by: Claude:claude-opus-5
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reported-by: Paul Moses <p@1g4.org>
Message-ID: <20260912215401.126194-1-xmei5@asu.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/vdpa.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
index 47c6c3d23f5c7..6455f837dd263 100644
--- a/drivers/vdpa/vdpa.c
+++ b/drivers/vdpa/vdpa.c
@@ -1313,15 +1313,16 @@ static int vdpa_nl_cmd_dev_config_get_doit(struct sk_buff *skb, struct genl_info
 	}
 	err = vdpa_dev_config_fill(vdev, msg, info->snd_portid, info->snd_seq,
 				   0, info->extack);
-	if (!err)
+	if (!err) {
 		err = genlmsg_reply(msg, info);
+		msg = NULL;
+	}
 
 mdev_err:
 	put_device(dev);
 dev_err:
 	up_read(&vdpa_dev_lock);
-	if (err)
-		nlmsg_free(msg);
+	nlmsg_free(msg);
 	return err;
 }
 
-- 
2.53.0




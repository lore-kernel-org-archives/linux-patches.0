Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622309;
	b=pXVQgyrsjZeWr5PzwTIOF82dvwoLOXbthDsVsJe2Ug23ontwTTCMAm4zTeTpZVEN8Tdp
	 ndaF/XKdXhxGeNCZnZUh7tzu58JAnQGnR67+e4JxWvfJwRKdhFMYn1VhpE6wJGyXItoYh
	 FA+RYeIBb+gOIQNN4dWq+n/0Kn03bAdpyM1E5PfPgFRWmtDgQsmMqcqJXuFMuDHDiylv1
	 ah1rgbWLkGxsExBiqZKJx8+Ss1jHzSOg8lBY0Zkr3wbjU8pfhLEdmk+jB98Jc4Jos7Ri+
	 aW3OejqZfXYXXVtE95z17u2XJjh4tKx2IZwoOmh91B6vbedDIK4SV3Ndayl76YD3AXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622309;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s2N2d8fIvavLznSvbmqkI+0jgXgXUqV3PlLmopE7hio=;
	b=UZJ8b3qn4SqtSVGUGdODfSiVlq7DiNZKRJbqbW8YdFhHJ5X1Lj53mva7SFBad5SCVIzR
	 WlSEx7RwW+x08hJ+SuJ6Eo+JuyC9aV2EHvoEqghPZ6tCkFCUe1TdKWbUKFxiZI0aXqeZn
	 mz1siXvAUmUG0FR2OEY1+4n+7K6xKNVKWHegIX2JDEqqQiiU8/FHDwvkX2DLVeZkrmj16
	 GnCkIoisZokzO/kyFlOvRvCCOQYKtnHSc3BzJTZidUYHPHeQAXDGQDhIFsU92lhjuK7JK
	 Az+ZGf5oQGAZdvSFAQPe37aKVHEMYDk4s+V4+U1CRG3FFV5SgAJAwUZT4hPLsA3sX7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0pnzjdbi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF2A5606A32D;
	Wed, 25 Nov 2026 15:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0pnzjdbi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24FA91F000CF;
	Wed, 25 Nov 2026 15:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622309;
	bh=s2N2d8fIvavLznSvbmqkI+0jgXgXUqV3PlLmopE7hio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0pnzjdbiMguMJE+IaODZ+EQ/4jOty9uLjHRc90U2cPJmNaFDDBT9QAQL1HGLaXzpO
	 HcnDNMElDZLhIGsSGHy+kckuRaYzyn9ac4/fGIV5Q5SqHfEOOHzQka4vQNI7Y+w+8f
	 7cD4CG0TbVvjJMYGoLT8eCzrRYCD3WXqtPxyV9j4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9ea34da5ca6100593c90@syzkaller.appspotmail.com,
	Kalpesh Solanki <skalpesh942@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 452/990] tun: disallow setting IEEE 802.15.4 and 6LoWPAN link types via TUNSETLINK
Date: Wed, 25 Nov 2026 15:30:19 +0100
Message-ID: <20261125143832.680940919@linuxfoundation.org>
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

From: Kalpesh Solanki <skalpesh942@gmail.com>

[ Upstream commit 968f2b94a5964b75d9c0da84523e42530c1891f0 ]

A userspace application can set the link type of a TUN/TAP interface
to ARPHRD_IEEE802154, ARPHRD_IEEE802154_MONITOR, or ARPHRD_6LOWPAN
via ioctl(fd, TUNSETLINK, arg) because tun_get_addr_len() explicitly
recognized these types.

However, TUN devices cannot function as genuine IEEE 802.15.4 or 6LoWPAN
interfaces:

1. They lack wpan_phy, channels, PAN IDs, and MLME operations, and tun
   never initializes dev->ieee802154_ptr or dev->ml_priv. When an
   unprivileged user creates a TUN interface in a user+net namespace,
   changes its link type to ARPHRD_IEEE802154, and issues a netlink dump
   request (such as IEEE802154_LLSEC_LIST_KEY),
   ieee802154_llsec_dump_table() unconditionally dereferences
   dev->ieee802154_ptr / ieee802154_mlme_ops(dev), triggering a supervisor
   null-pointer dereference / general protection fault. Similar
   dereferences occur across net/ieee802154/nl-phy.c (ieee802154_del_iface)
   and net/ieee802154/socket.c.

2. Similarly, the 6LoWPAN subsystem assumes via lowpan_dev(dev) that
   netdev_priv(dev) is struct lowpan_dev. On a TUN device, netdev_priv(dev)
   is struct tun_struct. On netdev events (such as NETDEV_DOWN in
   net/6lowpan/core.c:lowpan_device_event), it clears bits in
   lowpan_dev(dev)->ctx.table flags, which corrupts private memory inside
   tun_struct.

Rather than scattering checks across subsystems, fix the issue at the
source: disallow setting ARPHRD_IEEE802154, ARPHRD_IEEE802154_MONITOR, and
ARPHRD_6LOWPAN via TUNSETLINK by returning -EINVAL. Cast arg to unsigned
short in the comparison to prevent upper-bit truncation bypasses (e.g.
arg = ARPHRD_IEEE802154 | 0x10000).

Fixes: ff4cc3ac93e1 ("[TUNTAP]: Allow setting the linktype of the tap device from userspace")
Reported-by: syzbot+9ea34da5ca6100593c90@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9ea34da5ca6100593c90
Signed-off-by: Kalpesh Solanki <skalpesh942@gmail.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20261109083037.22337-1-skalpesh942@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/tun.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index d7780a0069218..b244ae7f4d5eb 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -3235,6 +3235,10 @@ static long __tun_chr_ioctl(struct file *file, unsigned int cmd,
 			netif_info(tun, drv, tun->dev,
 				   "Linktype set failed because interface is up\n");
 			ret = -EBUSY;
+		} else if ((unsigned short)arg == ARPHRD_IEEE802154 ||
+			   (unsigned short)arg == ARPHRD_IEEE802154_MONITOR ||
+			   (unsigned short)arg == ARPHRD_6LOWPAN) {
+			ret = -EINVAL;
 		} else {
 			ret = call_netdevice_notifiers(NETDEV_PRE_TYPE_CHANGE,
 						       tun->dev);
-- 
2.53.0




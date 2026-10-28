Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214813;
	b=0FEc23+TDK3vnurqxR54R7n0PM0fwGlAP8UrQ6VPDYp6SmVcwWRUZhDA/qMFwJ12584Z
	 WTTcwcPV/GIKJws5wP9iXvg5QoMTWqhJSVj4AT6uGijAG08aaC6oyMmSbKV08LegMj/fL
	 jzeqR8ZU5oJcFW59Jgk6WXyV/MisYRJaRcr8Si/pbJW66yg3N1pwhY8kqDuQb32JUwKaM
	 jmrM6hGVsrXuHnVSJx4F+gSsoZddUiPDChhBzNKD5QUv5LKefTlusGLhGtI8k6fZZ9D6k
	 jwQfM+lEDy/r0ZfzYwTs/JL/P9aYtBLCZydgHOM4HV1RyGSniZUO8h0Q+W4s1CK1daA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214813;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zi77ZeqeTXdGepzDqK9yZoruxnV5Ngw+hrVOZNBx0ZY=;
	b=yHAkjfjWKk9PRDDsV0buW1MDYKwSKEQpvgF9qus7K30mW2R2ogK/xrG0NF533K0SkDay
	 hzfZaWG3xNL8TdbqPZrgs3Imf8OcufhwT6+0lOo3EVOjhm2vU6HElBu2pkHL3CPq4c/LK
	 RYeWuHrzn0hUN3E1/H6IL2Cflh0Izs/6+RG8AAU1VuvrTJTJVW2cfzrHhjHjIgb/CzFya
	 wCelFCtyni1Fz58zGwXcnCLhoYqp5Yqmik2qQpbNZj+CKbaWSqBiMx2IZV8jbtAh4zKQy
	 LbLL/qFNjjHU2VeoCUcgOLxRDZrHj+u1haqUK8YlqTV3RjJZ7MUqa/65Mh/Y/klgGpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tm6Pdo2G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 609CA606A31C;
	Wed, 28 Oct 2026 19:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tm6Pdo2G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B026A1F01825;
	Wed, 28 Oct 2026 19:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214813;
	bh=zi77ZeqeTXdGepzDqK9yZoruxnV5Ngw+hrVOZNBx0ZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tm6Pdo2GhqzHTzwFgpOKeX01aV/KzTu9+tu00fjF/UKdnNHI2+HpGX468+hApFn9q
	 KMel0OpetVwJZg5VF4fZtKuuMPh3e367JIKHThQqAEavvlzuGPt4wvwwZNhetPfb5c
	 jRWwlVNtAEtj4szIndMkhoww7L/5B3lzeg3JntLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+881d65229ca4f9ae8c84@syzkaller.appspotmail.com,
	Sabrina Dubroca <sd@queasysnail.net>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0989/1887] xfrm: always flush state and policy upon NETDEV_UNREGISTER event
Date: Wed, 28 Oct 2026 17:51:25 +0100
Message-ID: <20261028170521.917124155@linuxfoundation.org>
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

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit 4efa91a28576054aae0e6dad9cba8fed8293aef8 ]

syzbot is reporting that "struct xfrm_state" refcount is leaking.

  unregister_netdevice: waiting for netdevsim0 to become free. Usage count = 2
  ref_tracker: netdev@ffff888052f24618 has 1/1 users at
       __netdev_tracker_alloc include/linux/netdevice.h:4400 [inline]
       netdev_tracker_alloc include/linux/netdevice.h:4412 [inline]
       xfrm_dev_state_add+0x3a5/0x1080 net/xfrm/xfrm_device.c:316
       xfrm_state_construct net/xfrm/xfrm_user.c:986 [inline]
       xfrm_add_sa+0x34ff/0x5fa0 net/xfrm/xfrm_user.c:1022
       xfrm_user_rcv_msg+0x58e/0xc00 net/xfrm/xfrm_user.c:3507
       netlink_rcv_skb+0x158/0x420 net/netlink/af_netlink.c:2550
       xfrm_netlink_rcv+0x71/0x90 net/xfrm/xfrm_user.c:3529
       netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
       netlink_unicast+0x5aa/0x870 net/netlink/af_netlink.c:1344
       netlink_sendmsg+0x8c8/0xdd0 net/netlink/af_netlink.c:1894
       sock_sendmsg_nosec net/socket.c:727 [inline]
       __sock_sendmsg net/socket.c:742 [inline]
       ____sys_sendmsg+0xa5d/0xc30 net/socket.c:2592
       ___sys_sendmsg+0x134/0x1d0 net/socket.c:2646
       __sys_sendmsg+0x16d/0x220 net/socket.c:2678
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xcd/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

This is because commit d77e38e612a0 ("xfrm: Add an IPsec hardware
offloading API") implemented xfrm_dev_unregister() as no-op despite
xfrm_dev_state_add() from xfrm_state_construct() acquires a reference
to "struct net_device".
I guess that that commit expected that NETDEV_DOWN event is fired before
NETDEV_UNREGISTER event fires, and also assumed that xfrm_dev_state_add()
is called only if (dev->features & NETIF_F_HW_ESP) != 0.

Sabrina Dubroca identified steps to reproduce the same symptoms as below.

  echo 0 > /sys/bus/netdevsim/new_device
  dev=$(ls -1 /sys/bus/netdevsim/devices/netdevsim0/net/)
  ip xfrm state add src 192.168.13.1 dst 192.168.13.2 proto esp \
     spi 0x1000 mode tunnel aead 'rfc4106(gcm(aes))' $key 128   \
     offload crypto dev $dev dir out
  ethtool -K $dev esp-hw-offload off
  echo 0 > /sys/bus/netdevsim/del_device

Like these steps indicate, the NETIF_F_HW_ESP bit can be cleared after
xfrm_dev_state_add() acquired a reference to "struct net_device".
Also, xfrm_dev_state_add() does not check for the NETIF_F_HW_ESP bit
when acquiring a reference to "struct net_device".

Commit 03891f820c21 ("xfrm: handle NETDEV_UNREGISTER for xfrm device")
re-introduced the NETDEV_UNREGISTER event to xfrm_dev_event(), but that
commit for unknown reason chose to share xfrm_dev_down() between the
NETDEV_DOWN event and the NETDEV_UNREGISTER event.
I guess that that commit missed the behavior in the previous paragraph.

Therefore, we need to re-introduce xfrm_dev_unregister() in order to
release the reference to "struct net_device" by unconditionally flushing
state and policy.

Reported-by: syzbot+881d65229ca4f9ae8c84@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=881d65229ca4f9ae8c84
Fixes: d77e38e612a0 ("xfrm: Add an IPsec hardware offloading API")
Cc: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_device.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index 313c0eb3381f3..c676ff2f21acc 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -424,6 +424,13 @@ static int xfrm_dev_down(struct net_device *dev)
 	return NOTIFY_DONE;
 }
 
+static int xfrm_dev_unregister(struct net_device *dev)
+{
+	xfrm_dev_state_flush(dev_net(dev), dev, true);
+
+	return NOTIFY_DONE;
+}
+
 static int xfrm_dev_event(struct notifier_block *this, unsigned long event, void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
@@ -436,8 +443,10 @@ static int xfrm_dev_event(struct notifier_block *this, unsigned long event, void
 		return xfrm_api_check(dev);
 
 	case NETDEV_DOWN:
-	case NETDEV_UNREGISTER:
 		return xfrm_dev_down(dev);
+
+	case NETDEV_UNREGISTER:
+		return xfrm_dev_unregister(dev);
 	}
 	return NOTIFY_DONE;
 }
-- 
2.53.0




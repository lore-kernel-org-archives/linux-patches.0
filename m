Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059325;
	b=n7YE82pWiWRzLLf+iKrAVoGBOwCvwHF0Fd7bwRT2Z7bsl2XbGJW0knZHUJt617nrC2B3
	 7yBWTWiCdd23P+hGthFWtyQVkcj3FMkeTFmJk4DZPEUYOnrfweera8Y9D+lPoUkNURdrR
	 fY9sjMFBAB/KgaV+YzWU2D8Wm06kTibgBUBFSoJHn0ZhQH05z8D/Ytsj7SkJZ24tdeDn+
	 SZsoApwgLduZSljMnBnFP6FE89/nYSKGByFjwUt2j69ZtGV8WYc8dJPnoecsyTys/HWRu
	 sWYqeisvt0IM512gpIIQrEbwVNzXE5OcXNE2+NVx3Ikw+bqeJEVLL0Z1f5oxS87KWig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059325;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aRT9hsFyPQl5kF7DVAG98piE2AMGmTc9gCWHgRWF9xk=;
	b=xfwKEhjOtT75HaVVrzpK+WUZy/lkwZ9vHnfWOLvyBgJfN1R2RoeDSMXbDWKwGJufMr38
	 jv/hoxfbCV3Es+8dyMOZgNOZFylsfiygjTMfjImEt6RCY7z8c/IaN/SUEpRBFTZE9Kkw+
	 bA3q+xcbXJt/t84W0t1jfsRmGNvN3B9mMB37xLiNFwDlpqy7H+1+p+7NqEM9oawXRWZkr
	 0+N6m53SWtZQbh9MzssUQx/G7vZuKAYfUa8XcmeRKavL2NzWxlWjNITP71zDQ18AWXPmm
	 V0dTEXEP8jXgv71IWovdnAZB8XfkSOfiuPM6Z2ALZtrhsC5w1fPEzYydBXcy2ws33PQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rs4R4IdG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D17C4606A325;
	Thu, 19 Nov 2026 03:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rs4R4IdG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30FAC1F000C4;
	Thu, 19 Nov 2026 03:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059325;
	bh=aRT9hsFyPQl5kF7DVAG98piE2AMGmTc9gCWHgRWF9xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rs4R4IdGOvvdhkRtB19xLiHqBez79GmXbz1ODmU8D3d8DWtaNbQKDpVsTJhDjPkpn
	 fSvVqFne/TRsoBqMzPADAks1lAAbmHYT9Pr/EWcV1sdfnC5yx5HKe+XAOvW7UyJu+v
	 1nlaNP8NCfKQQmNeY2Wu+HcsHYx9nrSlTZC+HTAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Ziyang Xuan <william.xuanziyang@huawei.com>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0759/1848] can: raw: add missing refcount for memory leak fix
Date: Wed, 18 Nov 2026 15:46:37 +0100
Message-ID: <20261118145948.242514184@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

From: Oliver Hartkopp <socketcan@hartkopp.net>

commit c275a176e4b69868576e543409927ae75e3a3288 upstream.

Commit ee8b94c8510c ("can: raw: fix receiver memory leak") introduced
a new reference to the CAN netdevice that has assigned CAN filters.
But this new ro->dev reference did not maintain its own refcount which
lead to another KASAN use-after-free splat found by Eric Dumazet.

This patch ensures a proper refcount for the CAN nedevice.

Fixes: ee8b94c8510c ("can: raw: fix receiver memory leak")
Reported-by: Eric Dumazet <edumazet@google.com>
Cc: Ziyang Xuan <william.xuanziyang@huawei.com>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://lore.kernel.org/r/20230821144547.6658-3-socketcan@hartkopp.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 962947b69589 ("can: replace ARPHRD_CAN type checks with can_get_ml_priv()")
[ backport to 5.10: Use dev_hold()/dev_put() as in the 5.15-stable
  backport, as this tree has no netdevice reference tracker. ]
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/raw.c | 34 +++++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)

diff --git a/net/can/raw.c b/net/can/raw.c
index c9513dca8fc96..3e2822707ed8d 100644
--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -283,8 +283,10 @@ static void raw_notify(struct raw_sock *ro, unsigned long msg,
 	case NETDEV_UNREGISTER:
 		lock_sock(sk);
 		/* remove current filters & unregister */
-		if (ro->bound)
+		if (ro->bound) {
 			raw_disable_allfilters(dev_net(dev), dev, sk);
+			dev_put(dev);
+		}
 
 		if (ro->count > 1)
 			kfree(ro->filter);
@@ -398,10 +400,12 @@ static int raw_release(struct socket *sock)
 
 	/* remove current filters & unregister */
 	if (ro->bound) {
-		if (ro->dev)
+		if (ro->dev) {
 			raw_disable_allfilters(dev_net(ro->dev), ro->dev, sk);
-		else
+			dev_put(ro->dev);
+		} else {
 			raw_disable_allfilters(sock_net(sk), NULL, sk);
+		}
 	}
 
 	if (ro->count > 1)
@@ -451,10 +455,10 @@ static int raw_bind(struct socket *sock, struct sockaddr *uaddr, int len)
 			goto out;
 		}
 		if (dev->type != ARPHRD_CAN) {
-			dev_put(dev);
 			err = -ENODEV;
-			goto out;
+			goto out_put_dev;
 		}
+
 		if (!(dev->flags & IFF_UP))
 			notify_enetdown = 1;
 
@@ -462,7 +466,9 @@ static int raw_bind(struct socket *sock, struct sockaddr *uaddr, int len)
 
 		/* filters set by default/setsockopt */
 		err = raw_enable_allfilters(sock_net(sk), dev, sk);
-		dev_put(dev);
+		if (err)
+			goto out_put_dev;
+
 	} else {
 		ifindex = 0;
 
@@ -473,18 +479,28 @@ static int raw_bind(struct socket *sock, struct sockaddr *uaddr, int len)
 	if (!err) {
 		if (ro->bound) {
 			/* unregister old filters */
-			if (ro->dev)
+			if (ro->dev) {
 				raw_disable_allfilters(dev_net(ro->dev),
 						       ro->dev, sk);
-			else
+				/* drop reference to old ro->dev */
+				dev_put(ro->dev);
+			} else {
 				raw_disable_allfilters(sock_net(sk), NULL, sk);
+			}
 		}
 		ro->ifindex = ifindex;
 		ro->bound = 1;
+		/* bind() ok -> hold a reference for new ro->dev */
 		ro->dev = dev;
+		if (ro->dev)
+			dev_hold(ro->dev);
 	}
 
- out:
+out_put_dev:
+	/* remove potential reference from dev_get_by_index() */
+	if (dev)
+		dev_put(dev);
+out:
 	release_sock(sk);
 	rtnl_unlock();
 
-- 
2.53.0




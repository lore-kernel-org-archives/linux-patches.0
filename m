Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059329;
	b=YWacJnqDoa3ZKxfoFuHe17FzUebfRILSWgmUzBzWCufp3wjCIYpL2/UCjOnN63RpPEPF
	 hJSqN0bPsuPgKajlEWtxHftuMjTYzTgZcfoNxbyCTposSGpWwp/uzIbL3KhYfkshq0BJb
	 owylsxLlkmq2OdXqf+Vqfoyc5sTOC+enBnU4B+WS3bk3XuD7g69538HZpENgo+UfwhE1U
	 rtKQN7CSJazauSKAJRIbAXBAtsdBdKTdobgnVGMG45xqjer8TaL9P2IRGTkkEQOxicvZF
	 sko8GHB/FDDQOBN4+oiDg7eq0E3Ma1s/57FhUPvoR8rxEWWTSPZMxG1QIQ1GdKAjiOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059329;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SUHcdPJmNEldhTCeMGPLnvb3DDHJC3yIl9U0UeYc8zw=;
	b=oQdvMUv82ii03+nAPu5ZHhyYicqrj/AO2lg16J04vYs8rhHb140vKpDk2qOz/nuc7DKu
	 Vu/tsgVpqnX5ITt3vRaAWh/ATi9U+D5/+yDbH0b3bZ40q1dvOYGw8m8dbMJnrQHczc1Zl
	 WZI8cKUIM4mKJOIHCZDIcrzSoGOjbmLlhDOvI3NEhZYoydOZThfBupQNw3vTmy7vUJArL
	 hQCxx/SEq7GbXVpNLvi5hcTlT9xv8oZFQdL5y6Bf5labGJQS1AdYTfc1obGTu8yYhbKrY
	 ozzObOPmNyGdQtedAIR9wprSEt2VdPeXmfdg/v5irW78AyrIyzrW5XQuuvUsQH1i1YA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="JU/vco+N";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED70C606A31C;
	Thu, 19 Nov 2026 03:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JU/vco+N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C25F1F000C4;
	Thu, 19 Nov 2026 03:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059328;
	bh=SUHcdPJmNEldhTCeMGPLnvb3DDHJC3yIl9U0UeYc8zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JU/vco+NtBHQ0sBdldQG6Z6YSfpYzSkvvWGU4Y53dfe2HJ+1lrtcLEScdzV25ZHTp
	 +LNbHnpuj5Vv/ti9cKTCXqKiRlYS9uNPwdgaP03fy6yVU5fzn3RXPa9ASZ4pl3YFHe
	 3WBAWWp83vLJIFhcTDBOQ1x1qgon19cx61lhZHdU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0760/1848] can: replace ARPHRD_CAN type checks with can_get_ml_priv()
Date: Wed, 18 Nov 2026 15:46:38 +0100
Message-ID: <20261118145948.277362112@linuxfoundation.org>
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

commit 962947b69589881167054bae5accc8abfd5aa4b6 upstream.

Commit 4e096a18867a ("net: introduce CAN specific pointer in the struct
net_device") introduced an explicit way to assign the midlayer private
pointer (dev->ml_priv) to named users like ML_PRIV_CAN. A valid pointer
returned by can_get_ml_priv() therefore identifies a real CAN device.

The referenced commit only converted the j1939 and proc code to this
check, while the other parts of the CAN subsystem still rely on
dev->type == ARPHRD_CAN.

The TUNSETLINK ioctl allows a down TUN/TAP device to set its hardware
type to ARPHRD_CAN while dev->ml_priv remains NULL. Such a repurposed
netdevice passes the ARPHRD_CAN checks.

Commit 8aa59e355949 ("can: af_can: fix NULL pointer dereference in
can_rx_register()") already made can_rx_register() reject such devices.
But can_rx_unregister() still only checks dev->type and dereferences
the NULL ml_priv when it walks the receive lists of the device.

CAN_ISOTP reaches this path: isotp_bind() ignores the return values of
can_rx_register() and binds the socket anyway. When the socket is
released or the device is unregistered, isotp_release() and
isotp_notify() remove the filters that have never been registered and
trigger the NULL pointer dereference in can_rx_unregister(). This only
requires owning a TUN/TAP device or CAP_NET_ADMIN in an unprivileged
user namespace.

Convert the remaining ARPHRD_CAN checks in af_can, bcm, gw, isotp and
raw to can_get_ml_priv().

Fixes: 4e096a18867a ("net: introduce CAN specific pointer in the struct net_device")
Cc: stable@vger.kernel.org
Cc: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://patch.msgid.link/20261027-can-rx-lock-v12-1-eb5afc2d8b9b@hartkopp.net
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
[ backport to 5.10: This tree has no can_skb_ext, so only the ARPHRD_CAN
  check is removed from the conditions in can_rcv() and canfd_rcv().
  There is no canxl_rcv() in this tree. Add the <linux/can/can-ml.h>
  include to raw.c, which upstream got with commit faba5860fcf9 ("can:
  raw: instantly reject disabled CAN frames"). ]
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/af_can.c | 10 +++++-----
 net/can/bcm.c    |  7 ++++---
 net/can/gw.c     |  7 ++++---
 net/can/isotp.c  |  5 +++--
 net/can/raw.c    |  5 +++--
 5 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/net/can/af_can.c b/net/can/af_can.c
index 05066662279d9..8131992809bb3 100644
--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -225,7 +225,7 @@ int can_send(struct sk_buff *skb, int loop)
 		goto inval_skb;
 	}
 
-	if (unlikely(skb->dev->type != ARPHRD_CAN)) {
+	if (unlikely(!can_get_ml_priv(skb->dev))) {
 		err = -EPERM;
 		goto inval_skb;
 	}
@@ -452,7 +452,7 @@ int can_rx_register(struct net *net, struct net_device *dev, canid_t can_id,
 
 	/* insert new receiver  (dev,canid,mask) -> (func,data) */
 
-	if (dev && (dev->type != ARPHRD_CAN || !can_get_ml_priv(dev)))
+	if (dev && !can_get_ml_priv(dev))
 		return -ENODEV;
 
 	if (dev && !net_eq(net, dev_net(dev)))
@@ -519,7 +519,7 @@ void can_rx_unregister(struct net *net, struct net_device *dev, canid_t can_id,
 	struct can_rcv_lists_stats *rcv_lists_stats = net->can.rcv_lists_stats;
 	struct can_dev_rcv_lists *dev_rcv_lists;
 
-	if (dev && dev->type != ARPHRD_CAN)
+	if (dev && !can_get_ml_priv(dev))
 		return;
 
 	if (dev && !net_eq(net, dev_net(dev)))
@@ -687,7 +687,7 @@ static int can_rcv(struct sk_buff *skb, struct net_device *dev,
 {
 	struct canfd_frame *cfd = (struct canfd_frame *)skb->data;
 
-	if (unlikely(dev->type != ARPHRD_CAN || !can_get_ml_priv(dev) || skb->len != CAN_MTU)) {
+	if (unlikely(!can_get_ml_priv(dev) || skb->len != CAN_MTU)) {
 		pr_warn_once("PF_CAN: dropped non conform CAN skbuff: dev type %d, len %d\n",
 			     dev->type, skb->len);
 		goto free_skb;
@@ -713,7 +713,7 @@ static int canfd_rcv(struct sk_buff *skb, struct net_device *dev,
 {
 	struct canfd_frame *cfd = (struct canfd_frame *)skb->data;
 
-	if (unlikely(dev->type != ARPHRD_CAN || !can_get_ml_priv(dev) || skb->len != CANFD_MTU)) {
+	if (unlikely(!can_get_ml_priv(dev) || skb->len != CANFD_MTU)) {
 		pr_warn_once("PF_CAN: dropped non conform CAN FD skbuff: dev type %d, len %d\n",
 			     dev->type, skb->len);
 		goto free_skb;
diff --git a/net/can/bcm.c b/net/can/bcm.c
index f655764aae83e..99abdd11f1077 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -54,6 +54,7 @@
 #include <linux/if_arp.h>
 #include <linux/skbuff.h>
 #include <linux/can.h>
+#include <linux/can/can-ml.h>
 #include <linux/can/core.h>
 #include <linux/can/skb.h>
 #include <linux/can/bcm.h>
@@ -1663,7 +1664,7 @@ static int bcm_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 				goto out_release;
 			}
 
-			if (dev->type != ARPHRD_CAN) {
+			if (!can_get_ml_priv(dev)) {
 				dev_put(dev);
 				ret = -ENODEV;
 				goto out_release;
@@ -1811,7 +1812,7 @@ static int bcm_notifier(struct notifier_block *nb, unsigned long msg,
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
 
-	if (dev->type != ARPHRD_CAN)
+	if (!can_get_ml_priv(dev))
 		return NOTIFY_DONE;
 	if (msg != NETDEV_UNREGISTER && msg != NETDEV_DOWN)
 		return NOTIFY_DONE;
@@ -1967,7 +1968,7 @@ static int bcm_connect(struct socket *sock, struct sockaddr *uaddr, int len,
 			ret = -ENODEV;
 			goto fail;
 		}
-		if (dev->type != ARPHRD_CAN) {
+		if (!can_get_ml_priv(dev)) {
 			dev_put(dev);
 			ret = -ENODEV;
 			goto fail;
diff --git a/net/can/gw.c b/net/can/gw.c
index c6efa4830ce99..55605135ca584 100644
--- a/net/can/gw.c
+++ b/net/can/gw.c
@@ -52,6 +52,7 @@
 #include <linux/if_arp.h>
 #include <linux/skbuff.h>
 #include <linux/can.h>
+#include <linux/can/can-ml.h>
 #include <linux/can/core.h>
 #include <linux/can/skb.h>
 #include <linux/can/gw.h>
@@ -541,7 +542,7 @@ static int cgw_notifier(struct notifier_block *nb,
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
 	struct net *net = dev_net(dev);
 
-	if (dev->type != ARPHRD_CAN)
+	if (!can_get_ml_priv(dev))
 		return NOTIFY_DONE;
 
 	if (msg == NETDEV_UNREGISTER) {
@@ -1092,7 +1093,7 @@ static int cgw_create_job(struct sk_buff *skb,  struct nlmsghdr *nlh,
 	if (!gwj->src.dev)
 		goto out;
 
-	if (gwj->src.dev->type != ARPHRD_CAN)
+	if (!can_get_ml_priv(gwj->src.dev))
 		goto out;
 
 	gwj->dst.dev = __dev_get_by_index(net, gwj->ccgw.dst_idx);
@@ -1100,7 +1101,7 @@ static int cgw_create_job(struct sk_buff *skb,  struct nlmsghdr *nlh,
 	if (!gwj->dst.dev)
 		goto out;
 
-	if (gwj->dst.dev->type != ARPHRD_CAN)
+	if (!can_get_ml_priv(gwj->dst.dev))
 		goto out;
 
 	ASSERT_RTNL();
diff --git a/net/can/isotp.c b/net/can/isotp.c
index d06a99ce84135..e4542fdf8431d 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -65,6 +65,7 @@
 #include <linux/if_arp.h>
 #include <linux/skbuff.h>
 #include <linux/can.h>
+#include <linux/can/can-ml.h>
 #include <linux/can/core.h>
 #include <linux/can/skb.h>
 #include <linux/can/isotp.h>
@@ -1550,7 +1551,7 @@ static int isotp_bind(struct socket *sock, struct sockaddr *uaddr, int len)
 		err = -ENODEV;
 		goto out;
 	}
-	if (dev->type != ARPHRD_CAN) {
+	if (!can_get_ml_priv(dev)) {
 		err = -ENODEV;
 		goto out_put_dev;
 	}
@@ -1850,7 +1851,7 @@ static int isotp_notifier(struct notifier_block *nb, unsigned long msg,
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
 
-	if (dev->type != ARPHRD_CAN)
+	if (!can_get_ml_priv(dev))
 		return NOTIFY_DONE;
 	if (msg != NETDEV_UNREGISTER && msg != NETDEV_DOWN)
 		return NOTIFY_DONE;
diff --git a/net/can/raw.c b/net/can/raw.c
index 3e2822707ed8d..293e79aadd32d 100644
--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -49,6 +49,7 @@
 #include <linux/if_arp.h>
 #include <linux/skbuff.h>
 #include <linux/can.h>
+#include <linux/can/can-ml.h>
 #include <linux/can/core.h>
 #include <linux/can/skb.h>
 #include <linux/can/raw.h>
@@ -315,7 +316,7 @@ static int raw_notifier(struct notifier_block *nb, unsigned long msg,
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
 
-	if (dev->type != ARPHRD_CAN)
+	if (!can_get_ml_priv(dev))
 		return NOTIFY_DONE;
 	if (msg != NETDEV_UNREGISTER && msg != NETDEV_DOWN)
 		return NOTIFY_DONE;
@@ -454,7 +455,7 @@ static int raw_bind(struct socket *sock, struct sockaddr *uaddr, int len)
 			err = -ENODEV;
 			goto out;
 		}
-		if (dev->type != ARPHRD_CAN) {
+		if (!can_get_ml_priv(dev)) {
 			err = -ENODEV;
 			goto out_put_dev;
 		}
-- 
2.53.0




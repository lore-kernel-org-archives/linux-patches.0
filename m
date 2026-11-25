Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620887;
	b=w13EjiX4uGBBokbxSL9xr4+7Zk0QWvJebAptyjTs0gPNhM+M58X+UmVviEKsayN6D3L4
	 XEYzkNWb3yOixTL4ALfs86h5DPm8eunpwcOj/2iE/7HZwnBdqLSEOR1Hgtmnck+iazzdd
	 AM9MvkvIzhrO6e5rA0wBwICLtZC145GxpWSTmQkOXCgBOFT9hZh8RvfRnw6QjkwE9ykfE
	 CNngH8hcQjIj3jVEPNm8rayQ59jNfOe0rV9qxUOk0Zy06LLH6VC27cSQzwBQ9t453JHcT
	 QJCEw7M4/fBSWES7d2MJ5vI4UsYuzkNuc/CJKHPf++2Q6xV+ayJyOuo3zkaQi+Ax0Og==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620887;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GoyqBn0CmfLDUVk4BOXx0FEOoE5tE59wiO9QkEUmk98=;
	b=eyWBa4e1o/4/OITg7LInmU9vUmIixyrPjyTC3fk5UJ5kekf/JCc6RDqKm8uqTZdFkvaV
	 L8TN/gJzoBhWi3zoL3uX4fuMjr7q19db9Njrb0kDBoSl80dwBUZsH/spMlKKKsnaYw1Ql
	 dslp7zVg4BXGNVTYz8ILwreaeeqkEGltUlps7XhcxuaCVWTX4oBXAvrpnHcaXOC5bybsg
	 m+j6tCQjI/9ztYpf3yKT9hiXTqGV/2JfVq+i/T/ahhnHa+jtXvZb3QX/ZA/LL/VNOqN5F
	 Qrtp1ENmdLrGqAyNa8a+sPgCdaXXpBbuf4RwWwXpZvJuwWewtNiLoPDERXGRxzR69FQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SGXvksmQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01960606A321;
	Wed, 25 Nov 2026 15:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SGXvksmQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEEE21F000C6;
	Wed, 25 Nov 2026 15:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620886;
	bh=GoyqBn0CmfLDUVk4BOXx0FEOoE5tE59wiO9QkEUmk98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SGXvksmQf2PK74zdwVfKuvkeNt8V0yjwlQf1YusrAjuamfteJAUMf64Fb5s1sU39Q
	 K7+hzvT+0y6PuxGs2yQNFUKY9jI4EZSdynZhoLvXyLBBrfwAAJNZdM2xOj7uJ82gVg
	 cFd3ekKFDNKBvW3NhNDV8VzhiBVta6IFkgYC0tvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 053/990] bpqether: set both addresses or none in SIOCSBPQETHADDR
Date: Wed, 25 Nov 2026 15:23:40 +0100
Message-ID: <20261125143823.330571183@linuxfoundation.org>
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

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

SIOCSBPQETHADDR copies the destination address straight into the
device, then the accepted source address. When the second copy faults,
the ioctl returns -EFAULT but the destination address has already been
changed, and copy_from_user() has zero-filled the part of the accepted
address it could not read.

With the accepted address left as 00:00:00:00:00:00, bpq_rcv() drops
every frame whose source is not that address: the device silently
stops receiving although the ioctl reported a failure.

Copy the whole struct bpq_ethaddr to the stack first and only update
the device once it has been read in full.

Tested in a QEMU guest (6.12.94, KASAN) by placing the struct so that
its accept field falls in an unmapped page. Before the change
/proc/net/bpqether showed the new destination and an accepted address
of 00:00:00:00:00:00 after the -EFAULT; after it, both addresses are
unchanged, and a valid call still sets them.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit 431bb7f4a7d347ccda32319aa346346664858289)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hamradio/bpqether.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/hamradio/bpqether.c b/drivers/net/hamradio/bpqether.c
index 1adb56a5d4b86..fb32be106e222 100644
--- a/drivers/net/hamradio/bpqether.c
+++ b/drivers/net/hamradio/bpqether.c
@@ -299,8 +299,8 @@ static int bpq_set_mac_address(struct net_device *dev, void *addr)
 static int bpq_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
 			      void __user *data, int cmd)
 {
-	struct bpq_ethaddr __user *ethaddr = data;
 	struct bpqdev *bpq = netdev_priv(dev);
+	struct bpq_ethaddr ethaddr;
 	struct bpq_req req;
 
 	if (!capable(CAP_NET_ADMIN))
@@ -320,10 +320,10 @@ static int bpq_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
 			break;
 
 		case SIOCSBPQETHADDR:
-			if (copy_from_user(bpq->dest_addr, ethaddr->destination, ETH_ALEN))
-				return -EFAULT;
-			if (copy_from_user(bpq->acpt_addr, ethaddr->accept, ETH_ALEN))
+			if (copy_from_user(&ethaddr, data, sizeof(ethaddr)))
 				return -EFAULT;
+			memcpy(bpq->dest_addr, ethaddr.destination, ETH_ALEN);
+			memcpy(bpq->acpt_addr, ethaddr.accept, ETH_ALEN);
 			break;
 
 		default:
-- 
2.53.0




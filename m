Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015668;
	b=AYR1QSifR6+BMHb2VFmfdiw0HPnbzcsOd3YJZaqa9LgNJKRWFIlNy+sChfKTx4b/EiVQ
	 Mb/i0ljDw4J1/CS/Ft/a/X3+D2QWlUcUczL0GIQygK5Zr2AYqO5pIdETtWAze3lljMWJM
	 ernqF2YFhnxwIH9VPDH6cKrhxeUFrcXQfi0j8zNNZqXY77WP/RXNVSPZSqNvUP9d8GPez
	 O3jvoGSt+Lekvmg4HKJzud86HCMMMwPJIaKh8K/uaa3+W4QS4PSSBn6LHA5l1jMHgg5yB
	 GrWhapEpALl+vUEkeZwambqOuzPE8/PCUwudIxMRuRGzamCc9rpY2NuZm1wKckjcztA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015668;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mfrca/XdGJMlMs8nRUO7hC2qIBv8jYfIvc70ZmDjLdU=;
	b=WIM9g3N11P11zaXpzSQmdC5GLnL8ojxMhgfoFsF9oJgESRa4s+LUA8PyOAYbrRkVEA9f
	 wtQEmj1AMyZr27C+ygvrggTqQ0ufzRRv6nTg2IX8PSJc8v0PTYyxoxTgbqxTVXov5g6SR
	 kYZTXUTVQ/akBjvpU65+/wOfzo3tQXH+UqgEDQSxy1PfXq2QD5se4W3zAaYu0CIs2Qhaw
	 0zBYO6XXBBviQf3xfh3OOH0sVczPHiA9Ft/bneBnN0oH8XLz+iptI2KvMeYeg9r5MM6TN
	 AilYErTP8GiXOdpyH4N0/fqmUWXT5HAdRLIridMg1t+zv2HQhZVXxHlOBfuKHn+CL6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nDVNUMAn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1BF860A2601;
	Wed, 18 Nov 2026 15:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nDVNUMAn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E30591F000C5;
	Wed, 18 Nov 2026 15:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015667;
	bh=mfrca/XdGJMlMs8nRUO7hC2qIBv8jYfIvc70ZmDjLdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nDVNUMAnII1LYI+5lqtH+i2r8PycaA/Hs+d+aA1Eo3XJFf4MrvaR0Liao8xh8/9uJ
	 F+pUHjebzC8hibYASXBvBIVVu6JgTrQAdXXWmtrTPQ7Luplve1LFScUmPdjvOvwjkQ
	 duOqmYFU7yXGm1q0oBK8tj6vC67d/+d5pB/beBcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0248/2651] RDMA/nldev: Put the device when dellink fails
Date: Wed, 18 Nov 2026 15:24:48 +0100
Message-ID: <20261118150256.787466136@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit 0ff7fcd6aac16dd149ad322687a10c8ea7d806b2 ]

nldev_dellink() takes a device reference through
ib_device_get_by_index() and normally hands it over to
ib_unregister_device_and_put(). The error path of the ->dellink
callback returns without releasing it, so the reference is leaked.

Once that happens, any later unregistration of the device blocks
forever, because disable_device() drops its own reference and then
waits for the refcount to drain. No in-tree driver returns an error
from ->dellink today, so the leak is currently latent.

Put the device before returning the error.

Fixes: a60e3f3d6fba ("RDMA/nldev: Add dellink function pointer")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Link: https://patch.msgid.link/20260903082550.2257-1-lirongqing@baidu.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/nldev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 4e8fbee347454..3f715a1faaeca 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -1895,8 +1895,10 @@ static int nldev_dellink(struct sk_buff *skb, struct nlmsghdr *nlh,
 		mutex_lock(&nldev_dellink_mutex);
 		err = device->link_ops->dellink(device);
 		mutex_unlock(&nldev_dellink_mutex);
-		if (err)
+		if (err) {
+			ib_device_put(device);
 			return err;
+		}
 	}
 
 	ib_unregister_device_and_put(device);
-- 
2.53.0




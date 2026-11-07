Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064717;
	b=BHGNWBMJNqJGp71+UIVaKC3cqlOv0gq/ToVVVf9Q7SVL5QGWtYyNgXuA0m0is38b5huT
	 EmsuXQy+nm7Gg0obwRD+ppTFanyDiUeklI+OZpg92ESful7V9Hk/+25iKgXVmYzrwtLrS
	 f3oWaxDTU5hgEaXpMmmojWEb2b9PFYAhE9UuCyG0yvkyYuCK2hzNkBzBU8AzbEed2q5O2
	 XSyZrbd2oQ3jkZ1fg+sJw0dlypxNALVfLJB0S1rW7i0LbEE8wT8EtNBuQkobANBr++qK+
	 bA2R37OmyUe1l33ceFiLhLNCxEtJeit4KZnm/19mnLu0DLCg5PDNCyPMotWAFPvj6tA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064717;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8rL0aRpRLYd+X/dItii9kXe+EgjBGakr+ixUZndJwk0=;
	b=Ykj8rNYny2Zq7Y5qXdFEn1HDNwUQdiwpSvl+UJ8+w1spNRJv72WwnSdP4atPToiadxud
	 lHg67MpCqsQDXhSmy6i4oVF76BKlZK1wLNq8AVzkPcRw4y7AZv7DzKnTQko/J7RBe8DWa
	 9mMkZdwZWdcbZlz4GUI6qgkxKlCZzmipRohBTsZ9wXxy5pfUuKF6+0iP/oT3B6tG4VYZN
	 AjfafNmrfHYXKyoRJTd9bDjDWxBbJ74Ys9BkVK5ysYrnZCOjePez4lrLKc6Sows0jvBAv
	 PNvgyoKmIZNKZ86pU7WYZ+11LKGL24kTHDiD3vxr720Qm7kNyzE+NYscEP1d2RSHK0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="i/qX+9XE";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 349EA606A333;
	Sat,  7 Nov 2026 15:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i/qX+9XE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D19A91F008A5;
	Sat,  7 Nov 2026 15:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064717;
	bh=8rL0aRpRLYd+X/dItii9kXe+EgjBGakr+ixUZndJwk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i/qX+9XEB8jSh2ztkPVqwE2GSTYWAw0i60ZTscnx2JyhfMHnnQy5InkCk/bjGOwP1
	 OykfMQtdsaFiYMtDzJQijXYaAW2aoNKbaRiK3JcjHOO1XwF1ZvR5OIpgWvW4ReWml6
	 Kmb35vjapJvJVjxX6VjqxWKQLUA8Or0b+LTU9pzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Joshua Mulloy <joshuamulloy@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0698/1257] misc: tifm: dont clear dev->driver in tifm_device_remove()
Date: Sat,  7 Nov 2026 08:49:54 -0500
Message-ID: <20261107134958.533464662@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Joshua Mulloy <joshuamulloy@gmail.com>

[ Upstream commit 2b23952d70d43321a90dd8a06bcaab04a1a73118 ]

tifm_device_remove() sets sock->dev.driver to NULL after calling the
driver's remove() callback. Since commit a995fe1a3aa7 ("rust: driver:
drop device private data post unbind"), device_unbind_cleanup()
dereferences dev->driver after the bus remove() callback has returned,
so removing a card from a TI FlashMedia reader oopses:

  BUG: kernel NULL pointer dereference, address: 0000000000000090
  Workqueue: tifm tifm_7xx1_switch_media [tifm_7xx1]
  RIP: 0010:device_unbind_cleanup+0x16/0xb0
  Call Trace:
   device_release_driver_internal+0x220/0x260
   device_release_driver+0x12/0x20
   bus_remove_device+0xf9/0x1c0
   device_del+0x161/0x3b0
   device_unregister+0x17/0x70
   tifm_7xx1_switch_media.cold+0x6b/0xbd [tifm_7xx1]
   process_one_work+0x1ac/0x3d0
   worker_thread+0x1b8/0x360
   kthread+0xf7/0x130
   ret_from_fork+0x195/0x2a0
   ret_from_fork_asm+0x1a/0x30

The driver core clears dev->driver itself in device_unbind_cleanup(), so
there is no need for the bus code to do it. Remove the assignment.

The problem was found and the fix written with the help of an AI coding
assistant. Tested on a Dell Precision M6500 (TI PCIxx12 FlashMedia,
104c:803b) running a 7.0 kernel: removing an SD card oopsed every time
without the fix; with it, insert, read and remove work.

Fixes: a995fe1a3aa7 ("rust: driver: drop device private data post unbind")
Cc: stable@kernel.org
Assisted-by: LLM
Signed-off-by: Joshua Mulloy <joshuamulloy@gmail.com>
Link: https://patch.msgid.link/20261004102525.34356-1-joshuamulloy@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/tifm_core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/misc/tifm_core.c b/drivers/misc/tifm_core.c
index aac8f0933e435..03d1324bc2534 100644
--- a/drivers/misc/tifm_core.c
+++ b/drivers/misc/tifm_core.c
@@ -97,7 +97,6 @@ static void tifm_device_remove(struct device *dev)
 		sock->card_event = tifm_dummy_event;
 		sock->data_event = tifm_dummy_event;
 		drv->remove(sock);
-		sock->dev.driver = NULL;
 	}
 
 	put_device(dev);
-- 
2.53.0




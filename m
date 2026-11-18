Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028261;
	b=JBAZ5qalW1xTtQXW/Kt6JZEKqhPbKDhTzBpKhVo+v2ZyZKPbCDCb8qB6aTF2Nk61tCXO
	 cmqszFPiPCEKicTJSJDo7rI/Qw/AJC+rIYGuXOKwD4KwqtB7RlGuJC5rwMjGXQnMEbVAL
	 0Zc0f3lF4IhGHsMKz8Yei/2gQOqhsQUgoVQ4ah6OuUIYeQ/YpTcCODsi0Z9DA4faOTZ+t
	 tI6zY1W85sLgTeukO3HweVAaAbxn5+7drMzEoWqpkh6mAMaEvVMuDzmhJja+EPZDVK5pt
	 ajRdAdkMV0pdr4SQt1ooxLY9RLBmawXOn6FOydt/0shHm21Vig+E/uFLrPTmNJlSnSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028261;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=6DoF5jL9K8EwXKgWD3GqMcbRPoPE7i6WCnR+A8PRdqM=;
	b=yyOP5PNNv5zfItVfUtrYBfFY3vEiDQsfRvu3bJQ/NEb4scbepF8QFMw2i9PwDKq4e7J9
	 49iSCj2NomgmF+x6cI8BK+Prh+V5jLEPRaMZEYI53qyT1I4y7fYnu5BC0JpysgXmfVZq+
	 N32BpOzPZMLmljTbYGjLkmLslX9BkzQXrxjDJUkpynCKwiV+LIUsOlkBUQu+im+sEMsDA
	 26vV839lvu4vmpVwWoWZND+wh337e9SzhXE6BxZwrQ/GOg0tpaOzoMj1SD2fyMJLbsWJi
	 8AsywlxlwHQapcKK3UVahc7QD9vhvfoZDtZE57VEadm3YLwt4d4U44FqHi6+mtqGB8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YB5NzUs+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39A04606A32C;
	Wed, 18 Nov 2026 18:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YB5NzUs+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9382E1F000C4;
	Wed, 18 Nov 2026 18:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028261;
	bh=6DoF5jL9K8EwXKgWD3GqMcbRPoPE7i6WCnR+A8PRdqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YB5NzUs+wcSTEMQ7DGhE6DHbrOmOe8yWk6oqhKUqRwMpLnfMPv/BO1NbaDeM0WQU4
	 ULK7UApL8gRGJFcsAVvCNQXBnb5UFcsFogAhCKuq3gzGvQiJ1dVV7jxxYn+YHKPThh
	 7KOXT8QrSqv8Ga1nYNnnJpUnHDOO3gnWcddBRKR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	=?UTF-8?q?Christoph=20B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2081/2151] drbd: stop the start_resync timer of a dying device
Date: Wed, 18 Nov 2026 16:03:36 +0100
Message-ID: <20261118150237.517698055@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit a439d3fe3ec2bfe0b4ccb77973ae97949bcf46ec ]

start_resync_timer gets armed for up to a second and nothing ever
deletes it, so drbd_destroy_device() can free the device with the timer
pending. Shut it down where request_timer is shut down.

Fixes: 370a43e7982d ("drbd: Work on the Ahead -> SyncSource transition")
Cc: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: "Christoph Böhmwalder" <christoph.boehmwalder@linbit.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261028164415.1262013-13-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/drbd/drbd_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 1f6ac9202b66a..00726f9c35106 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2159,6 +2159,7 @@ void drbd_destroy_device(struct kref *kref)
 	struct drbd_peer_device *peer_device, *tmp_peer_device;
 
 	timer_shutdown_sync(&device->request_timer);
+	timer_shutdown_sync(&device->start_resync_timer);
 
 	/* paranoia asserts */
 	D_ASSERT(device, device->open_cnt == 0);
-- 
2.53.0




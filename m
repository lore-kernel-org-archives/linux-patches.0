Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D073112B4;
	Mon, 13 Oct 2025 15:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369058; cv=none; b=dryrSIgOWtQV2H9eEZm8awwgWsdLFplNjERM/YtYtzbvp02BK7KGvkflU2V+IuwCJl00o3Uue4pe0K0UDd7kdl+wCgzTePE7aYTyNCSSomFjt5rfJG8+NVvFUO0ISW5JaiLZkDoiXiK0kVb5ZK4J6mCW4bxjmU6EzKnE1f7pzoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369058; c=relaxed/simple;
	bh=s/03muLX84TLkR0AqENV0+EaulM58z/rfNsu6M2LL1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X0sRk+w6eJQeODZogy4vYxeh9omnoOKCVMzS9iqyklrLQ5iAoCapFCsqaf3WgSonL715XjhbC9DNjdPsg4Un3XszMgBHuvwY71fNDi4Oi5lUl9TJtpG3eVnnRij8tRMMyF6cL99iwZbiaFIOvjIhsdhwURW23+LyO+lYRrC8EGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Os6/gFKU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Os6/gFKU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1821FC4CEFE;
	Mon, 13 Oct 2025 15:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369058;
	bh=s/03muLX84TLkR0AqENV0+EaulM58z/rfNsu6M2LL1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Os6/gFKUs93jZPTKOHpunX+6RoINl3P4beaa1O98PObuyaQ+BWotR7ZqINdGcxiB2
	 e5QaGaT0hiTKFoQ6AZbJfzYqbnk4+gJIvr4vLfLXQKxo2oUZ6n32MFH39vghmYOj/W
	 zCyvwuR6i2dgPDy3d//esWNCQHYXjTQzyyOzqZ20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e1cd6bd8493060bd701d@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Mike Christie <mchristi@redhat.com>,
	"Richard W.M. Jones" <rjones@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Yu Kuai <yukuai1@huaweicloud.com>,
	linux-block@vger.kernel.org,
	nbd@other.debian.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 113/563] nbd: restrict sockets to TCP and UDP
Date: Mon, 13 Oct 2025 16:39:34 +0200
Message-ID: <20251013144415.389676652@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 9f7c02e031570e8291a63162c6c046dc15ff85b0 ]

Recently, syzbot started to abuse NBD with all kinds of sockets.

Commit cf1b2326b734 ("nbd: verify socket is supported during setup")
made sure the socket supported a shutdown() method.

Explicitely accept TCP and UNIX stream sockets.

Fixes: cf1b2326b734 ("nbd: verify socket is supported during setup")
Reported-by: syzbot+e1cd6bd8493060bd701d@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/CANn89iJ+76eE3A_8S_zTpSyW5hvPRn6V57458hCZGY5hbH_bFA@mail.gmail.com/T/#m081036e8747cd7e2626c1da5d78c8b9d1e55b154
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Richard W.M. Jones <rjones@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Yu Kuai <yukuai1@huaweicloud.com>
Cc: linux-block@vger.kernel.org
Cc: nbd@other.debian.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/nbd.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 6463d0e8d0cef..87b0b78249da3 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -1217,6 +1217,14 @@ static struct socket *nbd_get_socket(struct nbd_device *nbd, unsigned long fd,
 	if (!sock)
 		return NULL;
 
+	if (!sk_is_tcp(sock->sk) &&
+	    !sk_is_stream_unix(sock->sk)) {
+		dev_err(disk_to_dev(nbd->disk), "Unsupported socket: should be TCP or UNIX.\n");
+		*err = -EINVAL;
+		sockfd_put(sock);
+		return NULL;
+	}
+
 	if (sock->ops->shutdown == sock_no_shutdown) {
 		dev_err(disk_to_dev(nbd->disk), "Unsupported socket: shutdown callout must be supported.\n");
 		*err = -EINVAL;
-- 
2.51.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B7D03093C9;
	Mon, 13 Oct 2025 15:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368127; cv=none; b=m3/xZ0hULEBw5FQneaM3480NOXfVuvaIIcjEd0a2de4RPIipvlOTsx8h4pYo8Qni8Sh85TZ+KDDHhV4OhMe0ZU3/ZaKf2k18jLQaXmf1VRYodctsAOAHX+74KCwqDcf7fl1Z7D9L4sdLMWwfTY/5UxdaQC/cYDsmHVNBEb6rWjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368127; c=relaxed/simple;
	bh=c52cp2Mq362xHgpMzwKWS5joqtAlHPq8sZ/xvOXwK24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RgCEBUfcok3cpQCSYxCitzteNqQzitle8NzzdXCcYGShhpS2kA+B/JSLxT702diY4M6iV5zy/U/SJ8j7wirI+PL1+wInwX5PSkhiKh4Ie1Rd3xVYIPlmEgZ+ThTmQ52Kmgx/YwLxTMrVI0oplaFoYK0Y2k9xRWd2wXd879T4p0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aJxKLbA0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aJxKLbA0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E984AC4CEE7;
	Mon, 13 Oct 2025 15:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368127;
	bh=c52cp2Mq362xHgpMzwKWS5joqtAlHPq8sZ/xvOXwK24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aJxKLbA0nWhBNpVz99PKT3emcCD1IRwFkbkumzSCbivaqleU6SVLi1yxySlleW2ck
	 k80O2909vWIlR3zTwU8VBB6iVWNv3fvnldKsLyuFtKt/pNrOhtEzPrMwcHRniXvlyJ
	 a/o40+blZ1pSwEREqTzpuJB7f5A6SnmFvo8zXmLk=
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
Subject: [PATCH 6.12 053/262] nbd: restrict sockets to TCP and UDP
Date: Mon, 13 Oct 2025 16:43:15 +0200
Message-ID: <20251013144328.039218970@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c705acc4d6f4b..de692eed98740 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -1156,6 +1156,14 @@ static struct socket *nbd_get_socket(struct nbd_device *nbd, unsigned long fd,
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




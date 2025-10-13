Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F8C3093AD;
	Mon, 13 Oct 2025 14:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367514; cv=none; b=kv7NDtL0zHNUxl68mpln3uq/2qsbw82R8V0Jly2w39QY0KcjXneglGcz234X2DpCvaIXgT8Xkcy1a06rm55boqeclxFN7pNeyaU5uRejWSGvijdAopghgRkFIHoct1YcVvkz92JCv2zGyuzwk1UunO2fqSjDXhz/zG4oiOIkNNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367514; c=relaxed/simple;
	bh=7/6GbFERhTH+yGL94A/7UvmXfOTUjwQfbxkmJgUrViQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bW0W7hjmKle0HaaXFaW+jCj2VhmImsPPyTbZBbDN2MQIFTp5zU2KMW3ly+sP26NE8wD7H4sQAp4SEXtkuaLprgfQTDvc5ua6ZHpYxc2BOVrnIXzF2//AXSBiRNtjSiUgTmyKv6TNkPJy0as/183Gh2n8cEvbzZ1b+XQePaF6nsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oZ4nm5x4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oZ4nm5x4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA9DAC4CEFE;
	Mon, 13 Oct 2025 14:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367514;
	bh=7/6GbFERhTH+yGL94A/7UvmXfOTUjwQfbxkmJgUrViQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oZ4nm5x4pm1SdHQSaVeOYkHkZk95hECpneUjdxzE4SM9QYSz6KTMzfxTEJ7PmsJUG
	 689Np+nQhgPvY9U94sJMaUSbMVmfXDLyJjtSOr1w7Oqvn/n0zL3XTXytUmLM/qXVeC
	 lyVtlo7Wv2M6aqG9UZscoxfdvgVPTZ8JX31B+O+I=
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
Subject: [PATCH 6.6 039/196] nbd: restrict sockets to TCP and UDP
Date: Mon, 13 Oct 2025 16:43:50 +0200
Message-ID: <20251013144316.615991401@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3742ddf46c55a..27a05b1521f69 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -1128,6 +1128,14 @@ static struct socket *nbd_get_socket(struct nbd_device *nbd, unsigned long fd,
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




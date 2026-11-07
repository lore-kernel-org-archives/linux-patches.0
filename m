Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062646;
	b=0KqrBovU2br5L1fXEQaapFi2dlb4ysAwKRddtlgWHDceyypaBNEzkmb/Fhk2De579qu1
	 fWdYJOiHI6aXjkkwy+WHO6xTAfvsYectE/PqKo1OuXDKkMVv47K07GJ6YZVKk5djA1xay
	 GoYqR8dZtlaY2In1MEj9YnGAEERlABKo2b/6QlHgHAMcj07bMk3ikWv9XE3q06KNhvzBw
	 3kCtw0n0TY69arlMKfZR6w7/GwIDnnMEpCCrrwACjeI97V5wB+sj9RI3IGgHn6s8iC6TI
	 FdNRjCaVzN0paSarXuO6SdniXP32SZYbmL5s1KNFkUeYrAFTuZsFqqQs6YllapW/fdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062646;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OlBWvtGADBlrm66oiuUC6YYoQZjuMknlz+VFGMq5dLI=;
	b=Xp5EokeWz/WxBG0XOgqN67YCftGOwcqGzxEZJPzmr/YcWWYdDFWBsUXVeVfNphOHEJC/
	 RLloFjzTQekSGoJs4b8DaMQyUkCpqj/Uh2S6JIw6KIbFYXSYB5TzemTPPH9Blkcmx/yXv
	 nZI12/vzf7xQU+v1zKbpnQVWiMFATeZWrn1wBLXmaYAWAMMaoLikDWR0lWGn74SvKEFS9
	 ZLsH8qB8dTAzfQlztHgHtKpUQZQgfhYCOasrMZKslFZb8V+fIu5D0WVbAwbF1rBjAxNgf
	 TOkcFTspD5XxyCB6q3liCIVbVFLjUJwMv76gFylAT/35lmKQNoMlYUrcA9y1ym5juMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rKI5UJqP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFF16606A339;
	Sat,  7 Nov 2026 14:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rKI5UJqP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E6D41F0089F;
	Sat,  7 Nov 2026 14:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062645;
	bh=OlBWvtGADBlrm66oiuUC6YYoQZjuMknlz+VFGMq5dLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rKI5UJqPJEhm0yRcRZM1GL3lt3VZiCfNoOmGks/m5tatINnVZIwG2lk0KH4EaHz1F
	 Rxg5ysSeZ2jpebk2h7OfzLR7Fj+NL7v2GP5xJ6GxQhhLy+AkjaokZQFE+fzz0q6spc
	 A7IZWk97pO/HDyGSgTkWRE5UvR/R3CLid+htWxSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Martin Belanger <martin.belanger@dell.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1512/1536] nvme-tcp: start error recovery when read_sock fails
Date: Sat,  7 Nov 2026 08:58:48 -0500
Message-ID: <20261107135040.330054503@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Belanger <martin.belanger@dell.com>

[ Upstream commit 288cfa187208cc9d0809eb8e1508658151a444dd ]

nvme_tcp_recv_skb() disables the queue and starts error recovery for
errors it detects itself. An error returned by the transport reaches
nvme_tcp_try_recv() without either action.

nvme_tcp_io_work() returns on a negative result and does not requeue
itself, so the queue stops receiving and remains stalled until a command
times out.

Report the error and start error recovery when the queue is still
enabled, which indicates that the error was not handled by the actor.
Do this under the socket lock, as nvme_tcp_recv_skb() does.

Fixes: be8e82caa685 ("nvme-tcp: enable TLS handshake upcall")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Martin Belanger <martin.belanger@dell.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 93e743d6e9846..67d02cfb47ec7 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1421,6 +1421,19 @@ static int nvme_tcp_try_recv(struct nvme_tcp_queue *queue)
 	lock_sock(sk);
 	queue->nr_cqe = 0;
 	consumed = sock->ops->read_sock(sk, &rd_desc, nvme_tcp_recv_skb);
+	/*
+	 * nvme_tcp_recv_skb() handles its own errors, so a queue that is
+	 * still enabled failed inside read_sock(). Handle it before
+	 * release_sock() processes the backlog.
+	 */
+	if (unlikely(consumed < 0 && consumed != -EAGAIN &&
+		     queue->rd_enabled)) {
+		dev_err(queue->ctrl->ctrl.device,
+			"queue %d: receive failed: %d\n",
+			nvme_tcp_queue_id(queue), consumed);
+		queue->rd_enabled = false;
+		nvme_tcp_error_recovery(&queue->ctrl->ctrl);
+	}
 	release_sock(sk);
 	return consumed == -EAGAIN ? 0 : consumed;
 }
-- 
2.53.0




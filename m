Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704285;
	b=OjSYImfOCDhiJoFUSGGSFdX+dVhkj2d+P6FeNPL/0r+13bX1iHzMWJ44Pm36cAY6KjxQ
	 iqjN7YYKYsa9fTXFo9fbSOlhr0q2cPrQQKguRBVS69wLXgw/NlYNG0QvCC8UCffpwTeYX
	 IqMNGSxxFp7/9aIdGDJTsym4tSqVlfMcLFQOj7zF49yA9P74tK1QVALtTZ6uV6MRyQVwr
	 yDmma1tvDMgDsKHPl5t30Ra8RAdUWcHcz7L3r+bOalnypsKSSHub8LM42krLOzYObD6Iv
	 VBZ1fH/9zhzVPrNs1qFdgwUljIuledCXXyVF5D0RZbkQtzrZuQ+o0AmGvKrgN+0Z9Zg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704285;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d9bgNMaVY7N4jH2OJt5pwpHzKjwZQbXNmYnOih/eMBs=;
	b=zXQMhHw/Lu7/5Op8mQjxR0i7Mb8Rp8c5Xjn8Ql6dq20pJ/H9Vuu8DZVSYv8AMKAJQRJd
	 yjIp6xQWuTo+qR98vJaY6PhcDxgdEnjr0yfgBG2F+clrnQFa9APdVyOeD99N7CH0hRSC6
	 5xsKc5ZnHPiURspxEzkGgQO/KdELTKC99IlR6WX1rWM9bfA7nZwRqbnGGRtU3qOJEsYKG
	 EQQL0PDkid1pxqR8QQwrcEIMsYaPA262Sr09PCNQt+YeOK/W3Xz22pJlCRZ/ZyrcaDcnF
	 La1nJHO2X4LjlzSkKHlTuxt58ODd6uAmI5mDuBl0KbeSjlzSHTg2YZqd2MlOCl/jtcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Se++7ATD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C51606A321;
	Thu, 26 Nov 2026 14:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Se++7ATD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53CFB1F000E0;
	Thu, 26 Nov 2026 14:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704284;
	bh=d9bgNMaVY7N4jH2OJt5pwpHzKjwZQbXNmYnOih/eMBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Se++7ATDtttRe1Nkucn8f//YP6CAmsGAAHPhngHEtYAk0xYu3cQlbTf3K534oi0nO
	 u2MlThE2Y/pAUjZhDhw8P4BfJNFjsR5D5G/J7QdWs57OwCRNW79k8lYb6TUOKnWFnk
	 gUTzHvhbZA0jxqx1nnu9lQKg0PqghduvmUCA68Fs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wagner <dwagner@suse.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 070/265] nvme-tcp: handle number of queue changes
Date: Thu, 26 Nov 2026 15:36:40 +0100
Message-ID: <20261126143609.991769944@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

From: Daniel Wagner <dwagner@suse.de>

[ Upstream commit 09035f86496d8dea7a05a07f6dcb8083c0a3d885 ]

On reconnect, the number of queues might have changed.

In the case where we have more queues available than previously we try
to access queues which are not initialized yet.

The other case where we have less queues than previously, the
connection attempt will fail because the target doesn't support the
old number of queues and we end up in a reconnect loop.

Thus, only start queues which are currently present in the tagset
limited by the number of available queues. Then we update the tagset
and we can start any new queue.

Signed-off-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Stable-dep-of: a4387799d422 ("nvmet-rdma: disconnect a queue on device removal")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index f87ae42ec9e4c..e6850d4907aab 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1778,11 +1778,12 @@ static void nvme_tcp_stop_io_queues(struct nvme_ctrl *ctrl)
 		nvme_tcp_wait_queue(ctrl, i);
 }
 
-static int nvme_tcp_start_io_queues(struct nvme_ctrl *ctrl)
+static int nvme_tcp_start_io_queues(struct nvme_ctrl *ctrl,
+				    int first, int last)
 {
 	int i, ret = 0;
 
-	for (i = 1; i < ctrl->queue_count; i++) {
+	for (i = first; i < last; i++) {
 		ret = nvme_tcp_start_queue(ctrl, i);
 		if (ret)
 			goto out_stop_queues;
@@ -1791,7 +1792,7 @@ static int nvme_tcp_start_io_queues(struct nvme_ctrl *ctrl)
 	return 0;
 
 out_stop_queues:
-	for (i--; i >= 1; i--)
+	for (i--; i >= first; i--)
 		nvme_tcp_stop_queue(ctrl, i);
 	return ret;
 }
@@ -1918,7 +1919,7 @@ static void nvme_tcp_destroy_io_queues(struct nvme_ctrl *ctrl, bool remove)
 
 static int nvme_tcp_configure_io_queues(struct nvme_ctrl *ctrl, bool new)
 {
-	int ret;
+	int ret, nr_queues;
 
 	ret = nvme_tcp_alloc_io_queues(ctrl);
 	if (ret)
@@ -1938,7 +1939,13 @@ static int nvme_tcp_configure_io_queues(struct nvme_ctrl *ctrl, bool new)
 		}
 	}
 
-	ret = nvme_tcp_start_io_queues(ctrl);
+	/*
+	 * Only start IO queues for which we have allocated the tagset
+	 * and limitted it to the available queues. On reconnects, the
+	 * queue number might have changed.
+	 */
+	nr_queues = min(ctrl->tagset->nr_hw_queues + 1, ctrl->queue_count);
+	ret = nvme_tcp_start_io_queues(ctrl, 1, nr_queues);
 	if (ret)
 		goto out_cleanup_connect_q;
 
@@ -1960,6 +1967,15 @@ static int nvme_tcp_configure_io_queues(struct nvme_ctrl *ctrl, bool new)
 		nvme_unfreeze(ctrl);
 	}
 
+	/*
+	 * If the number of queues has increased (reconnect case)
+	 * start all new queues now.
+	 */
+	ret = nvme_tcp_start_io_queues(ctrl, nr_queues,
+				       ctrl->tagset->nr_hw_queues + 1);
+	if (ret)
+		goto out_wait_freeze_timed_out;
+
 	return 0;
 
 out_wait_freeze_timed_out:
-- 
2.53.0




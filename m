Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831075;
	b=znxEMG7d7/A46RTXyKxlslC22NV9s7jbJs1366PBZ4AhzWA9vaf6hM4xI2gKXTJVpALd
	 o30Zj7pX+ftx+hqOEKbnMxhcqv6sJUXzKU/4X1jWfoIHpSEr4mvmCBHIvQUXDErySVxyi
	 f2mB2X7QLJZlryL7H2cZCYZqNLTu3w7d0JT9ggcbD0r2MqoWHfdFsuRQxGbXaWNSHC6SB
	 WX1qLUBl7C5EmRON5SBKXo9v60ueLm+V8pNEzdQwD0dKt2QOIogHHFBCI38UKaa16VOn9
	 lmFHHDutZDusmixsRzBL5I/BAGqhBZusvyynITjGmSj0cRV7TVSpNpN5SS+hkihvdxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831075;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=umJpUitjalp8+7PC0vwbMMiFkjoY5UL7fZoLy+8pPyQ=;
	b=fozcEbXswV4z0UecSbNYbw80n/9iLwg+L/SAhkfxnWPcL12leVFPLJxDlJXyzRclbBDc
	 8m4W9HeYpKQ5N0/O4hYiOQd2Klz8kQXgK9E6AHhtDfXA1gU7GxttH5FCUc1jlSMrd2GKP
	 tixFIDwHIKGvMMN3CSK7j8CVpbEVpEoRyctahnF9Q+TfXdC8unkdbYkXqYHIHmp2m7BeE
	 CKHsmtL6FWppvY5s8tfAB4Z0FrrfLHnxJVLsJB8dP+OhJfbc+efAlgz+lSj0NRHSxgvG6
	 ok/OJhIHIJQKDJNMmT2WX61+uRHv8stTBVhMo9KcGKNYwzziiD7FHNZl7ogRm1O2PIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VtPxFjGg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB80606A32C;
	Wed,  4 Nov 2026 22:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VtPxFjGg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AC121F000C1;
	Wed,  4 Nov 2026 22:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831074;
	bh=umJpUitjalp8+7PC0vwbMMiFkjoY5UL7fZoLy+8pPyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VtPxFjGgGHVx/OnHQbdMpbrJzXM/IcmXLDF1lz4XqUPhj5AUeI0CGDyoJ/ju8CUV0
	 IMOTtyxORkLv3FtHXs6bTzbLaR4uUYMBnzax4IuxD5SZ9bTqkrps2PQCiUSDblLpb1
	 0pnmPSv8+tXGv2QoatOCxyw992lHakuSUFlUEwtE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilay Shroff <nilay@linux.ibm.com>,
	Eric Dumazet <edumazet@google.com>,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0490/1005] nvme-tcp: delay nvme_tcp_reclassify_socket()
Date: Wed,  4 Nov 2026 16:03:43 -0500
Message-ID: <20261104211057.694855576@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 447a7a3026eda85ac2738cbe6ee5ab066a39dad0 ]

Commit 841aee4d75f1 ("nvme-tcp: lockdep: annotate in-kernel sockets")
introduced nvme_tcp_reclassify_socket() to resolve a lockdep WARN by
distinguishing userspace sockets from nvme-tcp sockets. After that, TLS
encryption support was introduced to nvme-tcp and it added another lock
dependency on userspace socket handling by tlshd, which resulted in a
new lockdep WARN. This WARN was hidden by the commit 19bdb70c77d3
("nvme-tcp: lockdep: use dynamic lockdep keys per socket instance").
However, it turned out the commit 19bdb70c77d3 has a bug of lockdep key
lifetime management, and it is to be reverted by another patch in this
series. After the revert, the WARN was unveiled and observed at the
blktests test case nvme/062:

  WARNING: possible circular locking dependency detected
  7.3.0-rc2+ #455 Tainted: G        W
  ------------------------------------------------------
  tlshd/75867 is trying to acquire lock:
  ffffffff91ada5e0 (fs_reclaim){+.+.}-{0:0}, at: __kmalloc_cache_noprof+0x64/0x6d0

  but task is already holding lock:
  ffff888197808258 (sk_lock-AF_INET-NVME){+.+.}-{0:0}, at: do_tcp_setsockopt+0x499/0x26a0

  which lock already depends on the new lock.

To fix the lockdep WARN caused by the TLS encryption support, delay the
reclassification of the nvme-tcp sockets. Currently the reclassification
happens before the TLS handshake starts, which pulls in the additional
lock dependencies related to tlshd. Reclassify the sockets after the TLS
handshake instead, to cut that dependency.

Link: https://lore.kernel.org/lkml/CANn89i+wnTLC==UnXCpjsS4YxvEfhe5oK0N7fttbqr1zKyqdug@mail.gmail.com/
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 1f26e35d7a99e..9f15feff66132 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1859,7 +1859,6 @@ static int nvme_tcp_alloc_queue(struct nvme_ctrl *nctrl, int qid,
 	}
 
 	sk_net_refcnt_upgrade(queue->sock->sk);
-	nvme_tcp_reclassify_socket(queue->sock);
 
 	/* Single syn retry */
 	tcp_sock_set_syncnt(queue->sock->sk, 1);
@@ -1948,6 +1947,8 @@ static int nvme_tcp_alloc_queue(struct nvme_ctrl *nctrl, int qid,
 			goto err_init_connect;
 	}
 
+	nvme_tcp_reclassify_socket(queue->sock);
+
 	ret = nvme_tcp_init_connection(queue);
 	if (ret)
 		goto err_init_connect;
-- 
2.53.0




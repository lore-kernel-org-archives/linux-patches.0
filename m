Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212220;
	b=tk840UtqceMset6VkPIX4/8AUqOxVxqr1+Z4aqJxopXr5R2Ui6JOuZj5mbQmUspBVEW8
	 i0huBbN3nxzyJ6/5mllTmqT0oKVAMXivaFszDZZnKHKBVsQrQ7fFlJjjq8QAbXSykW/P4
	 O0aw++ADO6WJLbn6SnvfAf43hMjPNFG5VqvXHZRny6CETnWbfvYU0ahNTtTJl+laljIQl
	 UG1JgJI6otaGIKkkQbR+wE7m8+5ilyxZOanETfZhpQNZyQY5JkAFp7Rg+8JFXbkoR9HYo
	 jhGf27V6Sl9OsnCTDQkdCRGwM6xgLIoL2URtTl9DcvQcaKTXNIZr3odPKxBz/Ez6zRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212220;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jZJx5vKKpLKuuTtFQBEPWLyiZCKaY6WJ5aOYmkDfjvw=;
	b=iQdwwvMQHPtHnxLXeGMuxDEtKXshh1onj18iwCCgGd5X1CyuFZw+jD2kznyDBWnBKwsX
	 qryuEWzbhhMmIFYsFWJcLQXu4IQQWZmgKSsXLgUciipbALMC5C6l/+m0uZxlgrZZDXCK1
	 SVQYWRXEVWnth/YOqhyMGTx1COtlAFjpmPig77f2iZWHuAg4II5gQldLHW86SrTKIp5Wq
	 ozuYMFS2B2e5DOh8bJ+NGcBztB6bY/KSiHaOMb6xa4bUQ9tr6yXhOe8Y7iIdGxR35ZEC2
	 jewBnQ7jYUhOoRcvE3tgZcRui6iNivGHsTBynWDPfNpG2eZSNFjhhE7kU2Dha/0IwCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jNfPce8E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9708D606A31C;
	Wed, 28 Oct 2026 18:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jNfPce8E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE11E1F01825;
	Wed, 28 Oct 2026 18:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212220;
	bh=jZJx5vKKpLKuuTtFQBEPWLyiZCKaY6WJ5aOYmkDfjvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jNfPce8Ess+ZbEGvLI5mLkZzJDyWA4i2E7fPqdNPVdCEzN9Lf9n+mKUS1NSkCXO/y
	 7c5KinjJAh+OT7PCq/iDlxIPF9L6Atxr97v2btRFvu7m6Qj0N+BGlCWmRLel24kmfW
	 ntWcta7DJnA3o+EcmXzaBecmCnVfjhjAB9vL9Qcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Chris Mason <clm@meta.com>,
	Brian Geffon <bgeffon@google.com>,
	David Stevens <stevensd@google.com>,
	Minchan Kim <minchan@google.com>,
	Richard Chang <richardycc@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0063/1887] zram: fixup read_block_state()
Date: Wed, 28 Oct 2026 17:35:59 +0100
Message-ID: <20261028170500.663314406@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Senozhatsky <senozhatsky@chromium.org>

[ Upstream commit 8b05d2d8af817c6a1e23032df51e7ad83030d543 ]

ac_time is now in seconds, do not use ktime_to_timespec64()

[akpm@linux-foundation.org: remove now-unused local `ts']
[akpm@linux-foundation.org: fix build]
Link: https://lkml.kernel.org/r/20260115033031.3818977-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reported-by: Chris Mason <clm@meta.com>
Closes: https://lkml.kernel.org/r/20260114124522.1326519-1-clm@meta.com
Cc: Brian Geffon <bgeffon@google.com>
Cc: David Stevens <stevensd@google.com>
Cc: Minchan Kim <minchan@google.com>
Cc: Richard Chang <richardycc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

[ Stable tree note: The ac_time conversion described above is not present
  here, so retain the ktime_t conversion and microsecond output.  Move the
  timespec64 temporary into the scan loop instead, allowing the follow-up
  bounds fix to move nr_pages initialization under init_lock cleanly. ]

Stable-dep-of: 391f057f44a5 ("zram: fix out-of-bounds access in read_block_state()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/zram/zram_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index bef5388e4e28e..de5533fadc675 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -904,7 +904,6 @@ static ssize_t read_block_state(struct file *file, char __user *buf,
 	ssize_t index, written = 0;
 	struct zram *zram = file->private_data;
 	unsigned long nr_pages = zram->disksize >> PAGE_SHIFT;
-	struct timespec64 ts;
 
 	kbuf = kvmalloc(count, GFP_KERNEL);
 	if (!kbuf)
@@ -919,6 +918,7 @@ static ssize_t read_block_state(struct file *file, char __user *buf,
 
 	for (index = *ppos; index < nr_pages; index++) {
 		int copied;
+		struct timespec64 ts;
 
 		zram_slot_lock(zram, index);
 		if (!zram_allocated(zram, index))
-- 
2.53.0




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212252;
	b=YvlE9HMJOoqka7FCe7nf/Jv44KE/9+3pfdMg+GD9yh0QcQhKxlcCYYkGfxIrrRMql4kg
	 bFPfIseRc3okKpjJzAzBLME4NoRDfv6trRJuO2EV5QtFogT1Iqod5d/gEMmlMaldWY0I1
	 McD5G0nkFkeaFsOW3M4X6jDInhNHMfjJPTUzniDefG7HZd8EEwTy+49stN5h1uPLXkyBW
	 uUs1DtGrTnG4X9xgqeuY9cNNEW6X6wpATvnrup9Lb19FcCCCkZbY5nPkYKJZr1TYbfGvp
	 Vh6QiYIKd8bBDk/eOe9MoCQ3YonYW+Imbj37lLhz5P+ry3yq4pzE6wLOn+pOcwqJVUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212252;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bCGSHupccDVL7zf/SivVwqwHHDXHegHghmkkyb3dWaA=;
	b=GP5/eZu2u728snyEp7/wnNnLiZgd6JZxJzcrlMfO2B/71pDz3Qhv2SMCkZuQNeyjMCQK
	 glGAZDZ7i89I29/R4p9Kt5mvU5KEqfsm8BjfCVDecJtRAd7DgaqQi8Jxrc9s52+HGRzoO
	 sfQiJcu0gfWkVlXBgxcZljBCIWLBE5V0IzCGtZqLdv53lmp7dgfhh5Kns3o1LWjU18qwZ
	 FGH0pxIpL03x0wKY7pA3Od0dV3YVc0Wlt5RiQ6SzGZd592Ky1QvsRjhHgG4f799mUS4WN
	 Nxcjt9mBFlIXicV+t+cTTv8/ucR8V4G8lG6BDU9X55M3OGJ6XAYEN/ot438q1HLgisA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jx+EvZBt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D15EB606A32D;
	Wed, 28 Oct 2026 18:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jx+EvZBt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30FC21F031E1;
	Wed, 28 Oct 2026 18:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212251;
	bh=bCGSHupccDVL7zf/SivVwqwHHDXHegHghmkkyb3dWaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jx+EvZBt5Z6O5UmJ8lbSfB4iObXrBvbaMT/6N3A+P9wdQq51BVtPp3KOoUUT73Eq3
	 +T0uq1PhViPufyOYd8JAVsm5bdb2nQty7URa85tLbDD2LzBNqtWTH39RVh906ra/Ed
	 bzuYW+tE027hQzTLHPiBwtyJPg+mIFbmZHJypD5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Longlong Xia <xialonglong@kylinos.cn>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Jens Axboe <axboe@kernel.dk>,
	Minchan Kim <minchan@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0064/1887] zram: fix out-of-bounds access in read_block_state()
Date: Wed, 28 Oct 2026 17:36:00 +0100
Message-ID: <20261028170500.687037761@linuxfoundation.org>
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

From: Longlong Xia <xialonglong@kylinos.cn>

[ Upstream commit 391f057f44a51cc9418da5cba78b014324174264 ]

read_block_state() calculates nr_pages before taking dev_lock.  If the
device is reset and reinitialized with a smaller disksize before lock
acquisition, nr_pages still describes the old table.  The subsequent loop
can then call slot_lock() past the end of the newly allocated table.

Read disksize after acquiring dev_lock and checking that the device is
initialized.  The read lock then keeps the table and its bound stable for
the duration of the scan.

Link: https://lore.kernel.org/20260804065919.3970386-3-xialonglong2025@163.com
Fixes: c0265342bff4 ("zram: introduce zram memory tracking")
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/zram/zram_drv.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index de5533fadc675..740ca88bb6733 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -903,7 +903,7 @@ static ssize_t read_block_state(struct file *file, char __user *buf,
 	char *kbuf;
 	ssize_t index, written = 0;
 	struct zram *zram = file->private_data;
-	unsigned long nr_pages = zram->disksize >> PAGE_SHIFT;
+	unsigned long nr_pages;
 
 	kbuf = kvmalloc(count, GFP_KERNEL);
 	if (!kbuf)
@@ -916,6 +916,8 @@ static ssize_t read_block_state(struct file *file, char __user *buf,
 		return -EINVAL;
 	}
 
+	nr_pages = zram->disksize >> PAGE_SHIFT;
+
 	for (index = *ppos; index < nr_pages; index++) {
 		int copied;
 		struct timespec64 ts;
-- 
2.53.0




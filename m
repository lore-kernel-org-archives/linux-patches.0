Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210498;
	b=s3JTIbUe3U8KwsCxFSvldUwKVy3LxUd5L6PPXucRmM6OAZ0Wys2srsFFAhiEpUJQQ9jI
	 XNXmJeYmIdFz1FrR8i3sqBssJ2C1Lo3ZHsDwIYzE/ov2DczDxXwIvfHd2x/Ulloi9BFh4
	 2iBKXrLixqYjvWzLo9BHjEfmzRuhnUqeJw6UtUwt7+NMbNFxdbgtv7QsGyMjAdJ2hMRb4
	 Nf+eQVEHl1AiQ3ubnZ7d+bpTabB2kV/rWiyzDbwyU+DB5bodX8uglREltPp3UvcHTDWnN
	 3YqNqNes2guHAAoBQAgBN0Bwisv/vffjUyfIQCtH6JzLHpV/md2c6JHW3tKObdi/Rtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210498;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iRYRqK8yWVSeyTdfv605RNVIOnwsrDc4CXS0pcIk7rg=;
	b=r0zvxlfj+jiws+LAHNL2EVFVyaEaMg2sL9S+aP9CqRsop2SRXrxk3lpzby6DhWl41Eeq
	 lPlL1A/UfPhxvZ0rrTR0Nq9vtTRIM1RVltzhUs9mHi2U+F8D4/C3C070npbKZccMWgxu/
	 8Y0GUHmlLEzKHnQCybxhQfp6qfWXgpeXOMo5ojYJgvXvcoYqBydYRLxolEaa8I5d8tkI9
	 prC1GzgEs0ptMhVulXtsD7nU2UJzfoXKmyNa53m7jgBveoS70gxl2lMNvbMrAvS4Mmhh7
	 WC8/QL0mvpe/w9wrSWQ0d4+nnJrTWsx0sEWcPT57RTv7hIu+ipMJ4EF2fG/GPTUWIWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0H+Wqkmb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A463606A31A;
	Wed, 28 Oct 2026 18:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0H+Wqkmb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FB821F01825;
	Wed, 28 Oct 2026 18:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210498;
	bh=iRYRqK8yWVSeyTdfv605RNVIOnwsrDc4CXS0pcIk7rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0H+Wqkmb2FgwvM9Gi/E6LAxGgtoP+rKjUP1jDClbfNFVOD8YO1j83FQZ4aig/b+jS
	 dSyPTFUm0yPf85OF47Iv5ljwKi/ZA96Y3rWz69+Wqq+eJCamj6+gLh2MksqVzAr/qk
	 1ghhB33OSndYNW0vt52GMZ0bQQofDA7H8/DqD470=
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
Subject: [PATCH 5.15 048/571] zram: fixup read_block_state()
Date: Wed, 28 Oct 2026 17:53:15 +0100
Message-ID: <20261028170009.168326476@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a9f71b27d235a..d1f4b61509a0c 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -886,7 +886,6 @@ static ssize_t read_block_state(struct file *file, char __user *buf,
 	ssize_t index, written = 0;
 	struct zram *zram = file->private_data;
 	unsigned long nr_pages = zram->disksize >> PAGE_SHIFT;
-	struct timespec64 ts;
 
 	kbuf = kvmalloc(count, GFP_KERNEL);
 	if (!kbuf)
@@ -901,6 +900,7 @@ static ssize_t read_block_state(struct file *file, char __user *buf,
 
 	for (index = *ppos; index < nr_pages; index++) {
 		int copied;
+		struct timespec64 ts;
 
 		zram_slot_lock(zram, index);
 		if (!zram_allocated(zram, index))
-- 
2.53.0




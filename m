Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208232;
	b=TpSQPWtrRwatdziSEAO1ki/xQsI3xapfzUS0JSnm1UP1PNz3Dnsei1DW0gwu8M/lRa+b
	 a9z9YHmuvql3lMFbE2be6sBPZm7T56e8h9W4a/RfgmaUax05fQiYTJnYG3chzTkqxcGDC
	 p02AbayJwKkl/ojImFjOYhjv+q0JajBfekbTBdE2W2zEemlK8PCf7V3RUhkLhxWfjLpsi
	 5hRta6CIXNCedRotYe1bR665jOEgCyfNPEiQOV9P426M6udGPPFNYSMqQ5NcQxRGEpz7l
	 nPtOGBGQEbKGZZduv5xJPTXMS6VUzXIxAzZ2LOfuIFPs7oeXG//DM3f2NAI7BDOWGzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208232;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KxWbh+F3KCt+M2AdCmJNNfS+vpTGUOO6AkgYSWEeUJQ=;
	b=0b9ltblQH+JWJdtmhaPhISv9Ifk6bC9GenHmRQsddVa10O4XSPa+f9ptDKWhnnwr5bLa
	 u3FrDW3eypgLVIBe6kPS6DrwcUU8DrvP3e6AbVCElCKmjg6JbSWpdbMdE+yUEvks7hRno
	 PR3+giN6up1/B8HQTetJNuaZo/waFHN0wERaDk4ak6emvTpiwRV0nI94p14k3J27/4jm3
	 u+FCMNq7Pfyp1pLIk8/ByVmdaC5lADd0j9vOPfch/KqK2qziTYxSybC2PMuBfmIp50ZfR
	 cCto7xnSRto5856VpsY2oqWZh16fzDK8UK8KNvjVlM5lfKESLSi8i+jqJ5DhSaBYkdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="R/O6p7lH";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0596C606A31A;
	Wed, 28 Oct 2026 17:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R/O6p7lH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F6501F01825;
	Wed, 28 Oct 2026 17:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208231;
	bh=KxWbh+F3KCt+M2AdCmJNNfS+vpTGUOO6AkgYSWEeUJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R/O6p7lHoHSyUzArWXhJTdzCu05ILJ0wec/XqjS62bObEqHSpiWqmLs1iQEnYNtlk
	 H79EkaTV95arw7fRR38Q7ECXhy8zXmRCIKXMuRX4GBSFUIhuGJoKVaTmFcNqYHHo2u
	 HBUtXrGnaJNSXssuEVlkLjrfmoetzsYzZW4YCMXo=
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
Subject: [PATCH 5.10 045/516] zram: fixup read_block_state()
Date: Wed, 28 Oct 2026 17:53:17 +0100
Message-ID: <20261028170004.599880772@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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
index 16db4fae51456..ac5965ee64b2c 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -883,7 +883,6 @@ static ssize_t read_block_state(struct file *file, char __user *buf,
 	ssize_t index, written = 0;
 	struct zram *zram = file->private_data;
 	unsigned long nr_pages = zram->disksize >> PAGE_SHIFT;
-	struct timespec64 ts;
 
 	kbuf = kvmalloc(count, GFP_KERNEL);
 	if (!kbuf)
@@ -898,6 +897,7 @@ static ssize_t read_block_state(struct file *file, char __user *buf,
 
 	for (index = *ppos; index < nr_pages; index++) {
 		int copied;
+		struct timespec64 ts;
 
 		zram_slot_lock(zram, index);
 		if (!zram_allocated(zram, index))
-- 
2.53.0




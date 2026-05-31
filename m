Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC8CB42AA9
	for <patches@lists.linux.dev>; Sun, 31 May 2026 01:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780189388; cv=none; b=Gui23+MVSmtNd2uA3wM0FTbQ6ShLbevq6HsKfkKY6znmWMOP9IL+YXJSYtvWsvtQcOW1lxZ05MCU4rWTf/oBMnum8RkCqjMM3GUpDeERWa/oVqxxnXrLRHnUNO1pDPJaH1UNb6wYj7kuhwQFushQ8J9Lgvf6Nf/lSEZsoORsYIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780189388; c=relaxed/simple;
	bh=APiFWZXTnRfbG+HwF1DJ9n4FtfK50FyeJSRq8kImSmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vw1rLOboOHFCMxiQbSu65WmXwC14YAdLLF3MyQbqq4jbG69ZvEXV9mvOQ07QJKLZPvWuFvZLDg1j19B8DQGofKDXZMZp0etNUpRjXAdhg0fPAmdLupHb+OZ9jk6/G7lEY+x+q8vPm9w/je4tkqGrqOuJJbbPAHStG/XyI0vwzZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GCKbzAjR; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GCKbzAjR"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4908b92904fso37629115e9.0
        for <patches@lists.linux.dev>; Sat, 30 May 2026 18:03:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780189385; x=1780794185; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+xcR4llDLZ21dX5aGAHoZFyM5vQ6lE/uFW6fHX8pUaI=;
        b=GCKbzAjRopBLj0cN1omBpY6XHW69mcMsGWo0LIAuinXzw7KqK0Lydp4QvnHAPsHoLW
         pn+U4/ygPaF7Ga48jb0zGhjCiYFT/B0NTiilas3Y/WSgGixlASX9qJ36Aiqx/xGUppxI
         Xn7o58/r1KfxusM2eg9UvtvqtU4h4xFnpCCv4AGUJyM4TKBXFa1yWO1eWXYPfXc4dmxf
         i721DixrNqW88oVGyDiKj4QGOaHPUO03PF/m4MkkFgCyEG/zit6CTq4V7ZP51EZpkvgr
         fHfZmicia6RgR0GndIQBXdVNPCiPRLIb0M+08l4s0Z5DWyMSpZZbHLM3YargAZYoWVIf
         qt3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780189385; x=1780794185;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+xcR4llDLZ21dX5aGAHoZFyM5vQ6lE/uFW6fHX8pUaI=;
        b=O4uqJQWANIRNdGAVJjZsAnMRI1Kk053KzkzJmVCYDgPWUf9SNu03bZtFqM1WCWl/T/
         GJ6rq8KK3jJrLCvivw+DiJu+WRHPfH0dZhBkpo9DPuhyI8kOsHwnvC6jSh/vTYZR36g5
         4fLZnRbX9ZDS/YCHsjLUH0ftteLRQlQKvmqYU6aBhsANu+Knk1D+sfrWIJ8cC6lnP78a
         nIVHSqvwezEyRxvSG6gN3xgYdp/T5IJrc0IfRaJkpPXdHF9HgL5V9GpQsifiLxloDRsr
         bzattjWKCxiRSNUN1ARNGvkRmGxQ2+6VCAjHpJUy2jfLJd+MatapvUMHoLNIAOHhfGQb
         zSGQ==
X-Forwarded-Encrypted: i=1; AFNElJ9m/KmSVlYJMGuiMMucXQtDFzSnapZj8+RT2C85q/hv5fGt/1DNjQoxxe8n0Dk7VO+2RTRyKSMf@lists.linux.dev
X-Gm-Message-State: AOJu0YxVEOZPurzc9lwYh3Z9W0h2HxKb11JKUg0xuluAsnBpQqFY9zNy
	2X/BgF6nOhAJd+//FS6RloY2Djjjp20Lv8CLQRQR7kTEroYQchaZt7lb
X-Gm-Gg: Acq92OExnprtNpOQbnIqtEAwmzlXQJwTTtPT/LezmeNLgpGEB9iGT7QletGIsV9uKII
	o+MIwil4PxpV1V2O+1pEw15MzNytv1cebvbzyJ0ELIMwORyTvpCtREi2kT27dO1B8fyYg3IkWff
	2v9Grq1hEzYQejazM1MNPl9k6AgLilCoExQy517weyunhYFyb19C51RE+NKRir+eM50n1gk58Rp
	wpjw7nT4yOlW8emGdwR1Wd+AwZg9SNb/EagGiNcNjutfC3+KoD/XHRNzDnoRKC4fd41PsL8dIFv
	CfjMFUNZcvoCIyzJfblSCEVVNCWnc35OhXqkHsx3+lc4FYbocBqX8mWy+GcX7SnQrmFA6TnBfnx
	tvApjSemPDD2E8wE9khi/JPCo/yoENxQurGV/AL4euaHIB6BtrNU1aH/KcQwBQGW+/nzXHhYOdg
	DTW0UAfjpcFLGZk7SdJFFCyymWePb/ZQ==
X-Received: by 2002:a05:600c:e489:20b0:490:467e:a3d7 with SMTP id 5b1f17b1804b1-490a2952798mr65855195e9.30.1780189385274;
        Sat, 30 May 2026 18:03:05 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4909ca6575csm218111405e9.4.2026.05.30.18.03.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 May 2026 18:03:04 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-api@vger.kernel.org,
	netdev@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@infradead.org>,
	David Howells <dhowells@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Miklos Szeredi <miklos@szeredi.hu>,
	patches@lists.linux.dev
Subject: [PATCH 3/3] splice: remove PIPE_BUF_FLAG_GIFT
Date: Sun, 31 May 2026 01:01:07 +0000
Message-ID: <20260531010107.1953702-4-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260531010107.1953702-1-safinaskar@gmail.com>
References: <20260531010107.1953702-1-safinaskar@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It is unused now.

Signed-off-by: Askar Safin <safinaskar@gmail.com>
---
 fs/fuse/dev.c             | 1 -
 fs/splice.c               | 6 ++----
 include/linux/pipe_fs_i.h | 1 -
 3 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 5dda7080f4a9..fb8fe0c96692 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -2352,7 +2352,6 @@ static ssize_t fuse_dev_splice_write(struct pipe_inode_info *pipe,
 				goto out_free;
 
 			*obuf = *ibuf;
-			obuf->flags &= ~PIPE_BUF_FLAG_GIFT;
 			obuf->len = rem;
 			ibuf->offset += obuf->len;
 			ibuf->len -= obuf->len;
diff --git a/fs/splice.c b/fs/splice.c
index b1a4e3713bd6..6ddf7dd72f7b 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1622,10 +1622,9 @@ static int splice_pipe_to_pipe(struct pipe_inode_info *ipipe,
 			*obuf = *ibuf;
 
 			/*
-			 * Don't inherit the gift and merge flags, we need to
+			 * Don't inherit the merge flag, we need to
 			 * prevent multiple steals of this page.
 			 */
-			obuf->flags &= ~PIPE_BUF_FLAG_GIFT;
 			obuf->flags &= ~PIPE_BUF_FLAG_CAN_MERGE;
 
 			obuf->len = len;
@@ -1711,10 +1710,9 @@ static ssize_t link_pipe(struct pipe_inode_info *ipipe,
 		*obuf = *ibuf;
 
 		/*
-		 * Don't inherit the gift and merge flag, we need to prevent
+		 * Don't inherit the merge flag, we need to prevent
 		 * multiple steals of this page.
 		 */
-		obuf->flags &= ~PIPE_BUF_FLAG_GIFT;
 		obuf->flags &= ~PIPE_BUF_FLAG_CAN_MERGE;
 
 		if (obuf->len > len)
diff --git a/include/linux/pipe_fs_i.h b/include/linux/pipe_fs_i.h
index 7f6a92ac9704..a1eeed800669 100644
--- a/include/linux/pipe_fs_i.h
+++ b/include/linux/pipe_fs_i.h
@@ -6,7 +6,6 @@
 
 #define PIPE_BUF_FLAG_LRU	0x01	/* page is on the LRU */
 #define PIPE_BUF_FLAG_ATOMIC	0x02	/* was atomically mapped */
-#define PIPE_BUF_FLAG_GIFT	0x04	/* page is a gift */
 #define PIPE_BUF_FLAG_PACKET	0x08	/* read() as a packet */
 #define PIPE_BUF_FLAG_CAN_MERGE	0x10	/* can merge buffers */
 #define PIPE_BUF_FLAG_WHOLE	0x20	/* read() must return entire buffer or error */
-- 
2.47.3


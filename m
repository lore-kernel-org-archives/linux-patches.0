Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDF4A3812C7
	for <patches@lists.linux.dev>; Thu, 25 Jun 2026 08:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782376587; cv=none; b=EvdB2nzApGz151axUybFHMmhxuF1RIgocNIQ/AOd1huv51ActpZeYYrNRW/8oj7/9r1N2ByumvIYFjQ9mSK3ZCZDZFpbTcH9OpZMVw7mZNncZ3Y/quOPq5KiS75T63Jf18I1hAegVLtRztRq7FbynjObIHK9WPiVTei6LoR6yq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782376587; c=relaxed/simple;
	bh=qZiu7fS8kCZwF8htRjH//VRi7MyCn+kxzvosWiYjiV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eN1qMyXAfoL1gqHCw/i8Eo/fPHN1gFGiO+V8tvt6I3UAbagbYqjf5MgZ0IUNozCGZOLVPS8jJPMaOpESpovxB9wqnBiSi5fDeuR+T2fSZysDCcVTOTgoialmO3Nlileg7GbhUTUzeI+1KhyuBlI3+wzI5q4KWp/3vujhBBEHZnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BMMNOyKC; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BMMNOyKC"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-490b613a17bso18544625e9.3
        for <patches@lists.linux.dev>; Thu, 25 Jun 2026 01:36:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782376584; x=1782981384; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VhjLk1CMHsJsOzOKQ1JbfvjErAaIXQv49sV6IFA3w98=;
        b=BMMNOyKCUgcl6hbfjur/7imhccnw34jJqPdvx7s1O52wBOnKo1Z2oOhE5ksflBOOgd
         deEMJIJAX2fKgljiIa5jmP+2IPDSL0EnxLwEvFAJ1JrkEtG2C6/we3xfnXt9GlZExFun
         P8GICpyffQJZx/vkSSo5nVRGnV9saa2YLfjylHUlCgyePdCqcRPyrFPjpZ1v9vNZQ/FH
         HMou2l1fGuJqjJitpzfg84oE55G4MXd3+ML/yaTbKuk7FEnD060FXPVQacO1ZeZBSG74
         fIYsMctUkC/K06aGC8/K3lFUlt8fI8i4dWVKgWKaIvKZpSdL/rLJm5OGSw6rd97u+uTA
         pgWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782376584; x=1782981384;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VhjLk1CMHsJsOzOKQ1JbfvjErAaIXQv49sV6IFA3w98=;
        b=aSB34pHhekCec23mUVkfp61JGCnUpOYMBl0TC/lNkCspAEI3rtty96Zu6urY4lpfJy
         cIobyQ10Nr7OV0xyw0JiYWZT/GdA/XbJVDZDBGc+uoJYvKKkysz8CPI+WuzRVpzi/aGh
         SyHxG6bVqKp1yo0Ow5+cq7p4z7GHugWRGnbt8egqhxl0BKsHiIy/GYYxJaRs9/CDf68+
         1YOBr7hQxm2KjBRD7XkhZpBKu53pHH/BSAE/mB/LG/tO1j5OPzMrPDderbTLz5TZyfYW
         J5XXmNZYNgb2LtWTvADtoNrMttI2n9A7wwSUD7fj0CD7/4UNWsyPWE4ejvQ88MsBw5AB
         fTpg==
X-Forwarded-Encrypted: i=1; AFNElJ+qB6chpTyLtQxF5JLtEbxSVA4Y8KAQ4KiB6WzP2TEMosH/+50ZFT7PZPmUQnzcvLh4UHNkkLGv@lists.linux.dev
X-Gm-Message-State: AOJu0YwRuj2akhtHl4F8uUtUqpdSX1u+T90918cUI7RKLLqLud+aEfd5
	K6GNIjGXW5qeLOgDPeIOSAZbLkajAMp0b4meZ551RlOUC9s6Z2+Pi27k
X-Gm-Gg: AfdE7ckDIOXoKQXJgIv9S7DIiElXlXC4UQRWc4vh5M+AAzRfESVt2L1awFqU0uVJe7q
	pgRSh6rVxKBmXMeJ2dM1Qh5HLte9j15gjgWVGeqjqbP1lgw+dm7ZSCCQXGG3yOF8UQ4/n1xJLcU
	jFt9J9yB4A2xD5XWLHWR+43U2hH9H+vtNTtYqVEcBHRtyP3IGnHNxLDPXqzJFfJlGH4DvyjHS6N
	nCOgqRSW9tmzbMjx2FUJg8SIc73L883pNGgPVCjXrVF1AbmFGGGD0wmpuhUj/f1jg4aUdfxcWZS
	l9TAlLm+KaPwyG18BUryI1ixE1wIWefu8KVkRZyZhOOK8fck9gwa5IUKorwoi7WQOI/7bs4cN08
	CSKSZkEt2GnbUc8matqPIKxDlsf/1j/Z0k3h6xwLDcRrNwf+fCEKcNZu4+5xkouqAoNQnxwIN3/
	vtzqSbySYp
X-Received: by 2002:a05:600c:c4aa:b0:490:b189:212d with SMTP id 5b1f17b1804b1-492668a83dbmr17827635e9.33.1782376584308;
        Thu, 25 Jun 2026 01:36:24 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-46c2279b85csm13362284f8f.28.2026.06.25.01.36.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2026 01:36:23 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-api@vger.kernel.org,
	netdev@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@infradead.org>,
	David Howells <dhowells@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andy Lutomirski <luto@amacapital.net>,
	Collin Funk <collin.funk1@gmail.com>,
	David Laight <david.laight.linux@gmail.com>,
	Stefan Metzmacher <metze@samba.org>,
	The 8472 <kernel@infinite-source.de>,
	Willy Tarreau <w@1wt.eu>,
	Joanne Koong <joannelkoong@gmail.com>,
	Val Packett <val@packett.cool>,
	Andrei Vagin <avagin@gmail.com>,
	patches@lists.linux.dev
Subject: [PATCH v2 4/7] pipe: move wait_for_space to fs/pipe.c and rename it
Date: Thu, 25 Jun 2026 08:34:06 +0000
Message-ID: <20260625083409.3769242-5-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260625083409.3769242-1-safinaskar@gmail.com>
References: <20260625083409.3769242-1-safinaskar@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is needed, because I plan to use it in fs/read_write.c.

Signed-off-by: Askar Safin <safinaskar@gmail.com>
---
 fs/pipe.c                 | 17 +++++++++++++++++
 fs/splice.c               | 19 +------------------
 include/linux/pipe_fs_i.h |  2 ++
 3 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/fs/pipe.c b/fs/pipe.c
index 9841648c9..c0ccf21b9 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -1451,6 +1451,23 @@ long pipe_fcntl(struct file *file, unsigned int cmd, unsigned int arg)
 	return ret;
 }
 
+int pipe_wait_for_space(struct pipe_inode_info *pipe, bool non_block)
+{
+	for (;;) {
+		if (unlikely(!pipe->readers)) {
+			send_sig(SIGPIPE, current, 0);
+			return -EPIPE;
+		}
+		if (!pipe_is_full(pipe))
+			return 0;
+		if (non_block)
+			return -EAGAIN;
+		if (signal_pending(current))
+			return -ERESTARTSYS;
+		pipe_wait_writable(pipe);
+	}
+}
+
 static const struct super_operations pipefs_ops = {
 	.destroy_inode = free_inode_nonrcu,
 	.statfs = simple_statfs,
diff --git a/fs/splice.c b/fs/splice.c
index 707db2c2c..d12243d19 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1239,23 +1239,6 @@ ssize_t splice_file_range(struct file *in, loff_t *ppos, struct file *out,
 }
 EXPORT_SYMBOL(splice_file_range);
 
-static int wait_for_space(struct pipe_inode_info *pipe, bool non_block)
-{
-	for (;;) {
-		if (unlikely(!pipe->readers)) {
-			send_sig(SIGPIPE, current, 0);
-			return -EPIPE;
-		}
-		if (!pipe_is_full(pipe))
-			return 0;
-		if (non_block)
-			return -EAGAIN;
-		if (signal_pending(current))
-			return -ERESTARTSYS;
-		pipe_wait_writable(pipe);
-	}
-}
-
 static int splice_pipe_to_pipe(struct pipe_inode_info *ipipe,
 			       struct pipe_inode_info *opipe,
 			       size_t len, unsigned int flags);
@@ -1268,7 +1251,7 @@ ssize_t splice_file_to_pipe(struct file *in,
 	ssize_t ret;
 
 	pipe_lock(opipe);
-	ret = wait_for_space(opipe, flags & SPLICE_F_NONBLOCK);
+	ret = pipe_wait_for_space(opipe, flags & SPLICE_F_NONBLOCK);
 	if (!ret)
 		ret = do_splice_read(in, offset, opipe, len, flags);
 	pipe_unlock(opipe);
diff --git a/include/linux/pipe_fs_i.h b/include/linux/pipe_fs_i.h
index a1eeed800..be653625d 100644
--- a/include/linux/pipe_fs_i.h
+++ b/include/linux/pipe_fs_i.h
@@ -335,4 +335,6 @@ struct pipe_inode_info *get_pipe_info(struct file *file, bool for_splice);
 int create_pipe_files(struct file **, int);
 unsigned int round_pipe_size(unsigned int size);
 
+int pipe_wait_for_space(struct pipe_inode_info *pipe, bool non_block);
+
 #endif
-- 
2.47.3


Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE74A2ECD3A
	for <patches@lists.linux.dev>; Sat,  6 Jun 2026 06:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780726288; cv=none; b=jLk66FCWg+00gz52XVxGOLJnV/HLGBra/0Kvw7NPfZEqwwGGt8qcJJLVdBXZyXNAfXk+qnBmu53u0x5q8jDtUgfQyaC70EGAz4dLmH3pWOZnE1TuTLKmgb/h3DmfarrlgZQzOsmrSV2zs0nKDjI8Tv6PlKtOzv85gBvPFHR1GCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780726288; c=relaxed/simple;
	bh=QtIkhOcb4XuSPNMSHsQTam2xRok/IOw4SC1HUoDCl24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZzL/nc6l2i6uKh89bkcnFSXoXsUPJ3Obw69MqV0VsLiLeA8Zw2vAxSYO+p0Vk6bytthUvD/3AOExI/KFfZdh3zmY3cvaCBWUj19LWqq/PfQvKrC2neUV5YYSN66DULm30XUZVUPWzo5Ew0H0fwzJU11kBeW4JN6BiK0HlgH8B34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YJ0wvE8K; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YJ0wvE8K"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-490b4e1ade7so28379675e9.0
        for <patches@lists.linux.dev>; Fri, 05 Jun 2026 23:11:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780726285; x=1781331085; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T2cQgCHbxQom2kVIv1Cvt6Y9CPEs8rn7euaXGTL0+j8=;
        b=YJ0wvE8KauJ9WtQ5RTe4z2B7Icx7YYgOHUHWE7J01NrqVYA9F1H4wIrHtVDWIPUzuf
         EGU0a3+x9TMjvTOmfNP5wYjPdtwWa+rK8gpskqsH9aAo0aUwukCSLrRCHdCYHruUxgUv
         gmVeiBla4KCygIBdkZa7CLOJtd8+CrhSCphgRv9hZjjpJmGQbHfa+yi8vzkpmE6/RTIQ
         gL0TyTxZpvj3xfCwYZXR6ZQTZ5xyGtS4ziOJCdE2Xb/zl8Hd1GD1AjQ7YJfklh+KGQiW
         xKDMHKgPt+C8xGJE2a3pRBOpRQPuHLXayBPo4yjhIxk5TFqZtRUlOdevBP0vJjU7ObL5
         1wmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780726285; x=1781331085;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=T2cQgCHbxQom2kVIv1Cvt6Y9CPEs8rn7euaXGTL0+j8=;
        b=EZV3Ti4Om5DUyLP5aC+ICDJGPhnh+Fpf7C3BczNCrFMr/g5gt1hG10e1UlywR/mTCy
         znZvvELj63PP0b+etJhmrkfAa0cgB0AY/QfGJEbNjDXt6mnAqnkiYIvG111kORNOazfJ
         VBH1xByzyT/+chxGuomN59lJLscsKr+KnOVdpmvEHR7kee+tUMXRZA5dwjS2+vZKhgii
         hWzVy+azdrV4dPUxV9ni4+3adhWE1fw6O7lwc8TbGMMqq8CO9QhjsNyGc5wSX78fypHT
         o2vkcpb3wxsm8hVyxt/go1TWS3/W135aNMXmvY8zeh2IM1Xu/sM+ZcaU1ctasGs0NS4s
         LaCw==
X-Forwarded-Encrypted: i=1; AFNElJ8x/J38WiWhVYS2wnAyRiHqgYnNSd1cCGL9mO8BpJzil53u0m2JiUeNLFcp46HXvpn/x9gMQ4Fd@lists.linux.dev
X-Gm-Message-State: AOJu0Yx8q4GNFfhFwCOq+zgytMex87EoPWvUBFj+Mh0M2aUsO/Z2HWky
	lXYBxy9MHACANNS3Vn2D0V9rw7cxybfpSK5QOu5tk6bToQiyFAMSWmOY
X-Gm-Gg: Acq92OH6tRXS3PUNLH9Zlen4tIkq0QsBoTFXEjy8zNRUW/ojawnAFnYztTnfWTgOmsM
	QaKciCkQ8jwssAi41RFUfotcMOECgyUssQy3jGDcZJAatjJYXwQYoiz7P1zWGHBT6BactG0KH++
	wVL/3f6RHKUdvV8jG7wnm12B4r+/5XTq02gBkL2rAS+plAx18pOrtIDweoNvQAkdCHCkWoaiCod
	L6jV0+dn6eT9Memq3+91a0CSw+DD4CH751fscfsLKAYjVzCPlK9URrifKnzcAUnveKUTHoEkxEL
	SfTbD9JqEAkRyPyIGA7J3pWT36KPunyWRSGpvUbwy1BTdjFvnzohGh4zUKeFcCO1QU0gw1r0EAw
	NI82bnNatwfS4r/0BztN+zsGTOEjMznaTbQYb5D4opTAKGqPer/Q7O2iUEhv9FbGuCAcHTa/ZC4
	4jyNGGTFhyjuTgwMSEgtn8Ese8vM94QqekGGoHA/Fl
X-Received: by 2002:a05:600c:a117:b0:490:c2a3:3302 with SMTP id 5b1f17b1804b1-490c2a3336dmr71973635e9.35.1780726285175;
        Fri, 05 Jun 2026 23:11:25 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-490bc39e024sm273433555e9.4.2026.06.05.23.11.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Jun 2026 23:11:24 -0700 (PDT)
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
	ltp@lists.linux.it,
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
	Steven Rostedt <rostedt@goodmis.org>,
	The 8472 <kernel@infinite-source.de>,
	Willy Tarreau <w@1wt.eu>,
	Joanne Koong <joannelkoong@gmail.com>,
	patches@lists.linux.dev
Subject: [PATCH 1/5] vmsplice: open-code do_writev and do_readv
Date: Sat,  6 Jun 2026 06:10:27 +0000
Message-ID: <20260606061031.3744880-2-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260606061031.3744880-1-safinaskar@gmail.com>
References: <20260606061031.3744880-1-safinaskar@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

My previous vmsplice patch did the following mistake: I did
"CLASS(fd, f)(fd)", then did some checks on resulting "struct file",
then passed numeric (!) file descriptor to a function.

This is somewhat okay in this particular case, but I still think
this is code smell, so I fix this by open-coding do_writev and do_readv.

Also I insert a comment to warn other developers to keep
do_writev and do_readv in sync with vmsplice(2).

Signed-off-by: Askar Safin <safinaskar@gmail.com>
---
 fs/read_write.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 1e5444f4d..e224e7cb8 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1070,6 +1070,7 @@ static ssize_t vfs_writev(struct file *file, const struct iovec __user *vec,
 static ssize_t do_readv(unsigned long fd, const struct iovec __user *vec,
 			unsigned long vlen, rwf_t flags)
 {
+	/* All future changes to this function should be kept in sync with vmsplice(2). */
 	CLASS(fd_pos, f)(fd);
 	ssize_t ret = -EBADF;
 
@@ -1093,6 +1094,7 @@ static ssize_t do_readv(unsigned long fd, const struct iovec __user *vec,
 static ssize_t do_writev(unsigned long fd, const struct iovec __user *vec,
 			 unsigned long vlen, rwf_t flags)
 {
+	/* All future changes to this function should be kept in sync with vmsplice(2). */
 	CLASS(fd_pos, f)(fd);
 	ssize_t ret = -EBADF;
 
@@ -1226,14 +1228,24 @@ SYSCALL_DEFINE4(vmsplice, unsigned long, fd, const struct iovec __user *, vec,
 	if (fd_empty(f))
 		return -EBADF;
 
-	/* We do do_writev/do_readv, so it is okay to pass "false" here */
+	/* We do vfs_writev/vfs_readv, so it is okay to pass "false" here */
 	if (!get_pipe_info(fd_file(f), /* for_splice = */ false))
 		return -EBADF;
 
-	if (fd_file(f)->f_mode & FMODE_WRITE)
-		return do_writev(fd, vec, vlen, (flags & SPLICE_F_NONBLOCK) ? RWF_NOWAIT : 0);
-	else
-		return do_readv(fd, vec, vlen, (flags & SPLICE_F_NONBLOCK) ? RWF_NOWAIT : 0);
+	if (fd_file(f)->f_mode & FMODE_WRITE) {
+		ssize_t ret = vfs_writev(fd_file(f), vec, vlen, NULL, (flags & SPLICE_F_NONBLOCK) ? RWF_NOWAIT : 0);
+		if (ret > 0)
+			add_wchar(current, ret);
+		inc_syscw(current);
+		return ret;
+	} else {
+		ssize_t ret = vfs_readv(fd_file(f), vec, vlen, NULL, (flags & SPLICE_F_NONBLOCK) ? RWF_NOWAIT : 0);
+
+		if (ret > 0)
+			add_rchar(current, ret);
+		inc_syscr(current);
+		return ret;
+	}
 }
 
 /*
-- 
2.47.3


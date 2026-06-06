Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB9E2ECD3A
	for <patches@lists.linux.dev>; Sat,  6 Jun 2026 06:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780726336; cv=none; b=b0opIQuCxjsZkVgouIoaAFAlxIFVHN/ontDs3zHhwUClzdquVzCUQpTNzbdEc4ZX9qyEvXn+BHxoFPxabUxYX/yKk5cgR0dS+Upcu+P38w4j9cGeWQTrAOy5LsQ5M8nsjt1pJ7qg8VOHTwNapS18bRi8X1nmFl1/xotPw3gyq0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780726336; c=relaxed/simple;
	bh=cFehA3I9prjpPS9MpvxHw5vuJaTELUrjhx5IPWyT2q8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TZEMCwpF2Wt6FGJboMUCuHcR4vFsbykgupIbk9gD6Dq3+/wnyhs/E3bIixE/zFOYZJ9ij9uA6S1D0giEflu6x3cA5HBlyPFQkYUWq7plEI/L/Wu/nr6GV17qs23PvDBgtTPQOK/Nx8t5Jd+PlX/fpqQv+PwiRCxtzc8ohNbZfvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C9LYy9+8; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C9LYy9+8"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-490be29c1c5so31789795e9.2
        for <patches@lists.linux.dev>; Fri, 05 Jun 2026 23:12:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780726333; x=1781331133; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ybLyqkJC8PpxOPGtytqXN1jytQgb2AKCO5QalzHljcA=;
        b=C9LYy9+8nBZA5B6AR+QIhsUGtjnbHs2JHr7PsTzRdsZXpFqOavVVZ4+gnrjyZGZoNG
         vbGzZY/rhH9gjvzWYRt+JaWsJyEgLsz7lbc9kKqLh3b6Y8HOSL/23fzvs63EIMzKtqKg
         UIdRGz5OaIOjAr1JbZ8GbT+S2CJ487CabWSMvKkLVCD1Lq7z41Uc1vFnW/vKft7WnB+V
         0NbhX552O14B20i2bU/AROZkZa5RGBimLr1LBFt+f8mso+DUu7QnnNGBW1ywG3gO7wzV
         ByA3fiHs7qjVMqojoIwUL3+/QdnbJP21bpQMMb8BwhwHCOFT0vU6XgJsV/7vJO7huUpJ
         y4dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780726333; x=1781331133;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ybLyqkJC8PpxOPGtytqXN1jytQgb2AKCO5QalzHljcA=;
        b=OXIqJBUnobSeTT3Urcyta+VDYOrfVUaly8ZHNUnDsX3wCB4FZI/MEFGMMLApLuG170
         RJeKbn+M9PsxTeH8ZlU2jo1t6nA/1xki1vIqfz61NY5126lbEKTWWXx/2wFx4Uzh0RAc
         E7s17CDB8L8d/5ssSfjO+IyDA8Cqw/HNjHB1XjHgEm5E9jvtcoMr/jBvZ4uq0GmojBpt
         kA9fxwud7GYtF0idsZrUCotn0Er4ohhCw8F/BlDTomkCs/a6OB9ezN6nSm3b0TfKm/+r
         n51NNVq77UHhOMDgGHDDulbUChsIQQwTUT5h3LaYqCX/50V1l60/vNjg2/MLO3oFIi4d
         n4zw==
X-Forwarded-Encrypted: i=1; AFNElJ+dQlQgFOtOy7BhBtIGa/y81wqmYcqJm1YrDrEqBwQyfaKRlF6nOH+CSzZMlTnBzSetkKFjSjzd@lists.linux.dev
X-Gm-Message-State: AOJu0Yz8eBxKJcbaB+ymlOeSx90ZFf7MpmCDmu1Cuu6wHeeNz+gSeWUs
	3fZ8bQCse69smhfsTN5JwNxWDyTIvc1Yktx/zRqjXgJDKqYR169+x4q+
X-Gm-Gg: Acq92OFT1tX8eO29lXdkiMWfr88W9Sxd39d6GpSqOh2GeOBkkd8aq3vF3K/opw5rUbL
	ulbVG3oIEJq+WguMl2cj3Sy40v+nFTfGlD2rVZVCTbZeSpPaHQNO/+THWz4jCui12mattckcl0i
	LdAWjQuxAIKZDvyveJqJ4tiR6d1BfZ9RIUgSzkUWn/XXnLRiXauzLn+uSMrfOuV7vYWEYhyJmpj
	vF3koJzojy4eLj1eTnezurR2P2WXE3noRt2e04jJkGHKKHaSTKxJNhGwlEv81e6wHlSFEH2jR5j
	zmT5+FvMQO804Y5DnUhCKGZsn/5389KYckB00KOIhEA41EgyZWotcUzopapLjvd8dD6ouq9TFB4
	8g5gVTEs3laTWp8VqCGhLiwb7Jtt0rFd4/YWxdg5mujYa5fdJV0LD3XT5I/OurPsRiYTpgzukQ0
	uNddYQkDIPnz72fiEgdz6J7MHejWkJOPPgWb32x5sI
X-Received: by 2002:a05:600c:8b0c:b0:490:ba61:7981 with SMTP id 5b1f17b1804b1-490c25c1e4amr103918225e9.23.1780726332629;
        Fri, 05 Jun 2026 23:12:12 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-490c2c9ea37sm178712255e9.0.2026.06.05.23.12.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Jun 2026 23:12:12 -0700 (PDT)
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
Subject: [PATCH 3/5] splice: turn wait_for_space flags argument into bool
Date: Sat,  6 Jun 2026 06:10:29 +0000
Message-ID: <20260606061031.3744880-4-safinaskar@gmail.com>
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

I want to do this, because I will move this function to fs/pipe.c.

Signed-off-by: Askar Safin <safinaskar@gmail.com>
---
 fs/splice.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index 6ddf7dd72..707db2c2c 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1239,7 +1239,7 @@ ssize_t splice_file_range(struct file *in, loff_t *ppos, struct file *out,
 }
 EXPORT_SYMBOL(splice_file_range);
 
-static int wait_for_space(struct pipe_inode_info *pipe, unsigned flags)
+static int wait_for_space(struct pipe_inode_info *pipe, bool non_block)
 {
 	for (;;) {
 		if (unlikely(!pipe->readers)) {
@@ -1248,7 +1248,7 @@ static int wait_for_space(struct pipe_inode_info *pipe, unsigned flags)
 		}
 		if (!pipe_is_full(pipe))
 			return 0;
-		if (flags & SPLICE_F_NONBLOCK)
+		if (non_block)
 			return -EAGAIN;
 		if (signal_pending(current))
 			return -ERESTARTSYS;
@@ -1268,7 +1268,7 @@ ssize_t splice_file_to_pipe(struct file *in,
 	ssize_t ret;
 
 	pipe_lock(opipe);
-	ret = wait_for_space(opipe, flags);
+	ret = wait_for_space(opipe, flags & SPLICE_F_NONBLOCK);
 	if (!ret)
 		ret = do_splice_read(in, offset, opipe, len, flags);
 	pipe_unlock(opipe);
-- 
2.47.3


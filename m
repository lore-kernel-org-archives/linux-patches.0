Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB0237DAB3
	for <patches@lists.linux.dev>; Thu, 25 Jun 2026 08:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782376563; cv=none; b=JVXK1ZV1tHhQtnrligE6687gJCRb6SGbn2G9+GxjBps7DfPE+D/1z3YIWKvPs2faCwjUfntFuvBDh9X7kJHAJCTLEf9zUDsUyGfySUTAZUhQk0xjTfZVyNht+3mUcqgqVl+3GVqlS6O6xiv3uSqcKtvTDysyXja+biiHsmCP9To=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782376563; c=relaxed/simple;
	bh=cFehA3I9prjpPS9MpvxHw5vuJaTELUrjhx5IPWyT2q8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TgzPnKCRdWtpKBE7zoz85x8+TB/hIKRHFESO3BTD7agHjRT22nbDZsdwelAmVb8KdfPBAxbg4wgMobk/fp5ZudXU2clDERIKX9chelBPC2YMjQBvemae9CPXLJfOQx8U2OmDKf8A28qGXdOj/zlA8VEkLaCsVt/ntudxtgl1bKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oh1UcePl; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oh1UcePl"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-46daae24c79so360124f8f.0
        for <patches@lists.linux.dev>; Thu, 25 Jun 2026 01:36:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782376561; x=1782981361; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ybLyqkJC8PpxOPGtytqXN1jytQgb2AKCO5QalzHljcA=;
        b=oh1UcePlr+jYIlHKO/ZQKdymNnQgfw56lHEX5NU3nwCmA9ZGWLEwgEPhZim+RNv8sk
         GvoL5c9xJUvRiHRph3gLtZy+N1LaFXbtwI/nXtVZJZkQbK9QifWTjkgAL4+gyxFyrvoW
         yD+R6ssxQr3DmK0CFHagf8eHSXhKL7/i2ODBX6jwY18YgqA2tQgtZ+gijm4+eqBB3s+F
         khLTvA9G2SQBcwoobq80h22A4jgaMJONzopH43QBVbJ8ql+4vgI7t7tWu+0rEuSlOvT6
         ZcrzPPQ26pi3ULAeslh0HBM1fPA7thKq2F8yCQPdfbiyVkJaly0frrMkVKO59yh3zEGT
         F3Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782376561; x=1782981361;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ybLyqkJC8PpxOPGtytqXN1jytQgb2AKCO5QalzHljcA=;
        b=qA4XycBMBGPOaYD2+OKgqRWSEdQRjt7ypHSqDh6QJNDPF/I/Vfws69qCiEsaHnjji4
         uPNiphoVeZOkkfmIRxVSqq248ugA23B56HJKs/ouQDdVdGjb+W+kSz6Luwqw6p8dj0J/
         NSudOUo3IZ7WFK5eWAJ6Gg7iCrKnR9UkEXxiLnZmmhDsRJqP4A6voejwSpJ0y2yR+qp3
         DQws7qslAzUp1njAZ5QTkOcbxEJ0BFDxC9Ajd3JwlZfzRw1i50k4uo6VyIw73YdWZt6r
         qskS2XwISWif4pjS+14YEqQaFlyFppH5tnEa3r6PI0H8r2FoJ4WxVwGPQzTNyib+frBO
         9YOw==
X-Forwarded-Encrypted: i=1; AFNElJ8RggJUUwGcpWhRshOtTs6gLkCX+YbKQfET8IJi7+Y6Jj2qFWGdy2rzimUgH6c6B1fApN9KTp/Q@lists.linux.dev
X-Gm-Message-State: AOJu0YxGCuX7hweY1iUuoSOLBFBW3vWDaltwsQlOYf9ln2S+zX+fcrJ4
	ouSzhKbJX8vSeoFpph+oYRMD4JaLMfitp+Pxp/4u4MyPnCRFsI+tG8Pv
X-Gm-Gg: AfdE7cmMQOtPsTVSmKJxFCFXfEwqZKkAbt8pfkPR4/9BH0/Pxyz372YYnq+Yt4eAM6w
	60Zz13vth6mD6brB+5ZHU9i7KvBVJrv+9JIcarVyygb6rVONk64E3Ds1mknTCULhlfgTFCkW0vx
	wEiJqq7DIHuNEeqOAMi8/r8czH57jeKnINnvzhcJjiuwAl8jc7/kiB1hDUmzHbYj4TWa4Sz2MxY
	QW/XiDMIY7kjrhJ7XbtgnzLnKTxnR0FxOGnHReY8LWcQO9q4QojyoSI7/OdcAKFrNRzBFa1port
	hZ2kQS2gx1MoKyMLqfQgcb9YMg7CrvlRhYInCZFzOFCWHIRjCD18WsvJFaTK0K1n37tK5INvWdf
	4rplwSgvcYQlbUFYNX8Ujfj2CASRnFxWiWX+2YfGOPPIqbql8YVgtUbqojETemFeOxjTRFkWFAS
	hPgyJSNEiG
X-Received: by 2002:a05:600c:c0d2:20b0:492:41c9:886b with SMTP id 5b1f17b1804b1-4926684c948mr14881805e9.14.1782376560755;
        Thu, 25 Jun 2026 01:36:00 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4926401a2e7sm80070205e9.3.2026.06.25.01.35.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2026 01:36:00 -0700 (PDT)
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
Subject: [PATCH v2 3/7] splice: turn wait_for_space flags argument into bool
Date: Thu, 25 Jun 2026 08:34:05 +0000
Message-ID: <20260625083409.3769242-4-safinaskar@gmail.com>
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


Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B8C17745
	for <patches@lists.linux.dev>; Sun, 31 May 2026 01:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780189312; cv=none; b=dLpI62Ta0CdW3Xj3Pm3hU2o9YGlwejq8gdOnpB5MJloZ4xcQCBntZfK0HzfQO07oDDEzcfbVqHJPe6IUTOXufhrASarKoN1Oajhgakx078Iz1/lHiSFm6nm+bxTq8jXeWAmnjFeg3mUdQ+jhCW0IkaPHqzHXUVOmb5VBZHVtmqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780189312; c=relaxed/simple;
	bh=zDp1XhZh+e1pWOK/DsDnXaGWcjK6DLDDhCVbs2gw3ZU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fRHaUVAwerdx7Zkt5vKyHukZ6klSzOCnvx5540xDzggpF8uvWp4+7gncQjSJW54KuIRrM5Kpf5Dbd4biHExTo2gut01mvt+E63pdRJ0zDeAkpF3TRy6dqDU2N5SPZFRHutwI85dyqdAy0/kza9ow/Njmy5iSm+fql20mUt7jnTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GO+X7Trm; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GO+X7Trm"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-490686877a1so49172255e9.0
        for <patches@lists.linux.dev>; Sat, 30 May 2026 18:01:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780189309; x=1780794109; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zPl6w3uFFVNTR71LIvI6Hm9g27LWiqb2gsEEN2QBH30=;
        b=GO+X7TrmUCj0j6QJfUeVdaiePSTIPxXdv4a1OKcTpVWxGgGiXRjZqVqrVIYYFxRpVC
         oNswf5K6rIMMIaWt6lo9DwjWJMzCDP8GSUE0jjhG7h3t6FkrXO4B39O5i58FSrIgnX1u
         em4MvyjFQjF91fx9sB8bD5e7IOOA53TndgfeZZ4AcuPHg6Vq0I1Gb53X0+EVPmL5IoL/
         Gf9olTuHPN5SXzKXlp2OUd4sGWeW+woyTH8xvUkK4JkwRNEytl+9/Epx0l8Rmaw7DUNV
         z4HGT4DOuk8QeywLcPvP7dsVij2n2HRuC7KE5MOROcCJELW4YobSsKtmrHdQ87cQKsVq
         cm8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780189309; x=1780794109;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zPl6w3uFFVNTR71LIvI6Hm9g27LWiqb2gsEEN2QBH30=;
        b=fEDhxB6EOjdrtwv4oAmSqaV4xNo4ZF3W9bFBxx5Vndz3RInQRefIrqW2QSRBMaJ0DH
         ZYcNo7BLZrJWJtpttY146PARtRSEAspmw4+NrurhE0zCnaYzpnLJgJSVtIYXunKjqST8
         Hg18fib5q0geOpgLa7IbiigqIDuH/0m7o12IxRRvhi+vpx+Fi8xNdl9lgywVmd7XE/wL
         ghwnENCZUaDNuFjZuE7J9EilK/xfqkTshHKGJMnSu6XZEODY/29O8uymsz3HVXUGZKLi
         ZyJt3EFlorRjs9mlAD/mzuYxsZ0m1tGhiBUyTSvRVfps/CP2gx7s2GnyVOW+zH6L+VRe
         ioww==
X-Forwarded-Encrypted: i=1; AFNElJ/wfqER/zhDhYRng7v3nNpIUtPcSVlkBaL711HDWZUNjP8pu6uU3u1IoQwYcHuCGeZ7tIfgIIKT@lists.linux.dev
X-Gm-Message-State: AOJu0Yy9GCKnNA1AvxT6qWN2304RboDgdKGdJ9fVsFw6z+hrciOw6irL
	hjCyS8Z7coNstYp9wYfC+krMCu/dniIRcv0fdRn4C73pJYgdCHWLh8As
X-Gm-Gg: Acq92OHstb91wECyHYveuFS0bri48ytFYlxAtBr73A0U6Fyt9YNOaZsrScV3JGfNFpL
	i8jKRI1SnjoNorIicw8JAu/WPnnK4y3f1lfuv5BlTXiy7D4LRXpm6kxEw5+IFcqzF5F5r+3mjK1
	VIWhWtvWTle+YVObgj+tpZ5A0GlAxB+yPd7/UmF+4DNpKuNQUQ1JZtiA1FQkiYTxeLe6N6NJx5b
	z04/QEA/AXIU7YrZr/oB+JVuis42eUgzEInSa3gZJsiFZGhEuPq/iHXpgzbwcSsxQ3QECLcRJFc
	8C2dvW9aVOM7/8Qx41fMUOyPUsmiSiCy9GufatjtQ07pJfguTRzOJ3hJoyugrGhcOIzJ4ml1yWx
	YjBpLQHhqNsQY3dWpvGOIo3FgY4i3gGbaKYxxreSooHj4AWoXuls1xg8XJ3l+fl2KBSYUlEK3n/
	mm1XoJZVgNdCccXz/5jgH95wbh/PgSQoEi2ZigXqcs
X-Received: by 2002:a05:600c:c168:b0:490:5000:917 with SMTP id 5b1f17b1804b1-490a2a02ad9mr75824695e9.1.1780189308943;
        Sat, 30 May 2026 18:01:48 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4909cab0e79sm261799535e9.13.2026.05.30.18.01.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 May 2026 18:01:48 -0700 (PDT)
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
Subject: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
Date: Sun, 31 May 2026 01:01:04 +0000
Message-ID: <20260531010107.1953702-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patchset is for VFS.

Recently we got a lot of vulnerabilities in splice/vmsplice.

Also vmsplice already was source of vulnerabilities in the past:
CVE-2020-29374 (see https://lwn.net/Articles/849638/ ).

Also vmsplice is problematic for other reasons. Here is what other
developers say:

Linus Torvalds in 2023:
> So I'd personally be perfectly ok with just making vmsplice() be
> exactly the same as write, and turn all of vmsplice() into just "it's
> a read() if the pipe is open for read, and a write if it's open for
> writing".
https://lore.kernel.org/all/CAHk-=wgG_2cmHgZwKjydi7=iimyHyN8aessnbM9XQ9ufbaUz9g@mail.gmail.com/

Christoph Hellwig in May 2026:
> vmsplice is the worst, as it is one of the few remaining places that
> can incorrectly dirty file backed pages without telling the file system
> and cause the other problems fixed by a FOLL_PIN conversion, but it is
> the only one where we do not have any idea yet how we could convert it
> to FOLL_PIN due to the unbounded pin time.
https://lore.kernel.org/all/agwFlBKvKytjURDO@infradead.org/

See recent discussion here:
https://lore.kernel.org/all/20260516182126.530498-1-pfalcato@suse.de/T/#u

For all these reasons I propose to make vmsplice a simple wrapper for
preadv2/pwritev2.

vmsplice(fd, vec, vlen, vmsplice_flags) will
be equivalent to preadv2(fd, vec, vlen, -1, rw_flags) if you have
readable pipe and to pwritev2(fd, vec, vlen, -1, rw_flags) if you have
writable pipe.

SPLICE_F_NONBLOCK is translated to RWF_NOWAIT, all other SPLICE_F_*
flags are ignored.

There is a small change to handling of NONBLOCK-related flags,
see commit messages for details.

I tested this patch in Qemu.

This patchset was written by me, not by LLMs.

Askar Safin (3):
  tee: fs/splice.c: remove unused parameter "flags" from "link_pipe"
  vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
  splice: remove PIPE_BUF_FLAG_GIFT

 fs/fuse/dev.c             |   1 -
 fs/read_write.c           |  23 +++++
 fs/splice.c               | 202 +-------------------------------------
 include/linux/pipe_fs_i.h |   1 -
 include/linux/skbuff.h    |   4 +-
 include/linux/splice.h    |   2 +-
 include/linux/syscalls.h  |   4 +-
 7 files changed, 33 insertions(+), 204 deletions(-)


base-commit: e7ae89a0c97ce2b68b0983cd01eda67cf373517d (7.1-rc5)
-- 
2.47.3


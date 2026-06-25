Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A53D37B03E
	for <patches@lists.linux.dev>; Thu, 25 Jun 2026 08:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782376490; cv=none; b=LlzsJz9xjpbUV6oau5kxz4tOnf5AHWP9cvOzl0o2zAhHUyX7pkccaDHno5nXWPnafgenV+Q86XPPgs5wU+RXgAX5aCpfDvuU05+QL39sIuaKmp0LSPzoRIdiyx5JlZE+0APau6f4SjV2B7/tE8yVL6sJBN3Y3Gi4+PBXro2Equ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782376490; c=relaxed/simple;
	bh=7BEwt6eYwfYFJfykt1yWvyBcAyXt9b2E6Fr7Bm2s5hY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BO8+0Lg3MK/uU8nEDA5pVqaopmEncOapM9S9btLHnE9hUnlZry+In7FGkT0yUrqr/rDHgj7PRa34okvHz2SP3t3k/9GNhuJbxBBAG2VWQkleQJJGyHtyI+Wy/UNP2LFm3VEYcW3EtCDNWWqIXKCK+n2Q2tXWyfcoS/i8E9Kcjx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XahlinpF; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XahlinpF"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-46def4bd5e8so246603f8f.1
        for <patches@lists.linux.dev>; Thu, 25 Jun 2026 01:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782376487; x=1782981287; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cwuPvDSXXbiyOTdpO1yF6fW9CB9apWEc+I7V+XWMZf0=;
        b=XahlinpFz9KTIDhYEd0o1fF7ccUelvOv3pKU7ixvmbOk/wWfa1fikU9kGqL8KMwevx
         2bAvh9cvIeVOtvDaWj+OOkahjzSjeUNnyFos6psm/d09U0LE/g42F74wlAud3uuIbCCZ
         3ZZcTElYHP/53CFRx5Mch4sBccwj9xMHJQJCo5uIVdjt3OrpBNa/H4opiZSP677DbzDM
         kAqkRHv1QFP6kUqnYENpy6Wi0qwUs9Hn9X1Sw+EVFufNMf/W2Jem/QHOKABVqCrV6DWh
         RQLeSj1pzCKPn5QdSICFiSFJahwNKGRKgv5Ox0tQxtogesFn8xqeaQrsm6rhYcAZFiCo
         cGGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782376487; x=1782981287;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cwuPvDSXXbiyOTdpO1yF6fW9CB9apWEc+I7V+XWMZf0=;
        b=BgoW+KBs9hpkfZGPhqxibb0dowNOQE9Kx0Pykq26L0+dfNzLE0ZrOh+WeUcI5ySTCc
         tKMCN7Db1Hi2jWXvUeole/LTPHfZp+2AXklMynDNKX+aoxVrnf9KB80RuekMRBxcqxuw
         qYH/iEPhpeBFA6BwvHsAVC195AUIEQq4sDv4PS5zbIVBDZa2bwxBgvjcdXiwvRbft83e
         rr2+8ibP95FmN0uN981mMbc7E2A9OrgbPxRLrmpSn8ze+Fvua92Z+C58g3lDAXIQuNS4
         hhlam0s1FZb9cKErZhTc6bAI6t9xtAaZN+yBFLLujWd+szom9oCAbZNpTINyLEyfoUEj
         4vrw==
X-Forwarded-Encrypted: i=1; AHgh+RoUB2jDP2xYUwq0k5JDW5i8GpFKDLeHDjjRUTRhU+ZMROA8LsdJmcfECnuG7lS8qZ3sotbAzCM0@lists.linux.dev
X-Gm-Message-State: AOJu0YzqV0KGRhWAgntEqJCaCy79kHJdFxtmCzGjkQ9k5STdjAn5XbfZ
	KzDUQ7476fybic7vWWnnsFE++TDCOCeEOGzlg1ULYCRgi8DUMvCYpJm3
X-Gm-Gg: AfdE7cmqR0URetpQjzS6Bg4xwn2JhZR5GIEzX8MUG/6Mi3bQTLAjEmTnP3nIfpd4erb
	FPYIQcXYXovdSkRm1MCSEt9SfdhqwOOBkUy4SuJKJ49IgkkUmgWQGGctO82YGZFeJlW9ofQhIUk
	GYjsTCz9fCNRrcvF4WuP/p0BmEZca0s0gEfbixWmUt0hq+XdrIVWJAuYUwAPy4xo3O6TOJDAmxb
	QmMOUBlBUGzdjiluklpdQM8xrKmAWumNTWuvcnkR1kg8XwAXn/Y5SNtgsfmXUiLsdHaEikG+3OD
	k+77Yl5F0bS0o04AH3zLWq0dumpIYX5nWzTTxnm1H/xJgNJ0SErjfmPXZslBVZPZcPoF9GrLFvP
	yJtiPS3Wi17GEssieVT/aagIPireGGFfOXK/4vhKbqnV8iOQnutagaehCCX/cEQlfhapEiQz/s3
	Gc9vAFxPpT
X-Received: by 2002:a05:6000:2f8a:b0:46d:d6c1:8383 with SMTP id ffacd0b85a97d-46dd6c18494mr1746107f8f.44.1782376486646;
        Thu, 25 Jun 2026 01:34:46 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-46c221d998esm13183555f8f.24.2026.06.25.01.34.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2026 01:34:46 -0700 (PDT)
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
Subject: [PATCH v2 0/7] vmsplice: fix some problems in my previous vmsplice patchset
Date: Thu, 25 Jun 2026 08:34:02 +0000
Message-ID: <20260625083409.3769242-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patchset is for VFS. Of course, it depends on my previous vmsplice
patchset ( https://lore.kernel.org/all/20260531010107.1953702-1-safinaskar@gmail.com/ ).

I fix some problems in my previous patchset.

1. Fix problem with CLASS(fd, f)(fd). See first patch in this patchset
for details. This is probably not so important, but I fix it anyway.

2. Change "unsigned long" back to "int". See second patch for details.
Again, this is probably not important, but I want to fix this anyway.

3. Fix that LTP vmsplice01 bug.

4. libfuse relies on sharing vmsplice behavior. So we detect particular
combination of flags to pipe2(2) and vmsplice(2) and return -EINVAL.
This forces libfuse to fail back to non-vmsplice code path.
I. e. we fix libfuse-related regression [1].
I did debian code search for regex "vmsplice.*SPLICE_F_NONBLOCK" and
I found no other packages with this particular combination of flags
except for fuse itself. (Okay, other packages are fio and stress-ng,
but these are merely testers.) So, I think this is okay to return
EINVAL here, breakage will be minimal.

5. Set FMODE_NOWAIT for named FIFOs. CRIU relies on ability to do
vmsplice(SPLICE_F_NONBLOCK) on named FIFOs. So, I fix this CRIU-related
regression [2]. But there is another CRIU-related regression, which I do not
fix [3]: CRIU behavior in splice mode becomes so slow that splice mode
becomes useless. I personally still believe that removing vmsplice is
right thing to do. Other option is doing nothing. Yet another option
is to implement some deprecation period [3]. Let other developers
decide.

See patches for details.

Please, run that LTP vmsplice01 test again.

Notes:

- I want to repeat: I change behavior around SPLICE_F_NONBLOCK.
Previously, vmsplice ignored whether pipe itself was opened as
non-blocking file. Now it is not ignored. And in my opinion
new behavior is better.
- vmsplice(2) now is in fs/read_write.c . It is very similar to
preadv2 and pwritev2 now, so I think it belongs to fs/read_write.c now.

Please, review this patchset carefully. I'm still new contributor.
In particular, please, review that do-while loop, I'm not sure I did
everything right.

Tested in Qemu.

[1] https://lore.kernel.org/all/CAJnrk1Y9egYizkx1H9K0cqxSYuB+7vLvQbV7Tf4C5eHFqnnC-A@mail.gmail.com/
[2] https://lore.kernel.org/all/CANaxB-zK5q=Xw6UZTmeFtXsDZjUsPkFk=p485m-wtNTBnf4hgg@mail.gmail.com/
[3] https://lore.kernel.org/all/CANaxB-xUrLQYGiRJZc4Boi+KX=0TJSWymErNovANVko20fMDVA@mail.gmail.com/

v1: https://lore.kernel.org/lkml/20260606061031.3744880-1-safinaskar@gmail.com/

Changes since v1: fix fuse-related and CRIU-related regressions (see above).

Askar Safin (7):
  vmsplice: open-code do_writev and do_readv
  vmsplice: change argument type back to "int"
  splice: turn wait_for_space flags argument into bool
  pipe: move wait_for_space to fs/pipe.c and rename it
  vmsplice: make sure we don't wait after writing some data
  vmsplice: return -EINVAL for particular combination of flags
  pipe: set FMODE_NOWAIT for named FIFOs

 fs/pipe.c                 | 23 +++++++++++++
 fs/read_write.c           | 71 +++++++++++++++++++++++++++++++++++----
 fs/splice.c               | 19 +----------
 include/linux/pipe_fs_i.h |  2 ++
 include/linux/syscalls.h  |  2 +-
 5 files changed, 91 insertions(+), 26 deletions(-)


base-commit: 8d86fcfc2857d64af85f5c87c193c25655c970af
-- 
2.47.3


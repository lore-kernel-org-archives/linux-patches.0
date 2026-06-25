Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C02B537B41E
	for <patches@lists.linux.dev>; Thu, 25 Jun 2026 08:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782376540; cv=none; b=jCf8S3J52CjqLhVlK+SRBU4PP7egOp1cWRtE+Tv0t8iUPckZtf2dTZrdBtBlBiC2VkR+r/lJ6Cxzu7jcgJtG8qgS4HJSnkVHV8jokpqPmDOGFNKNCUJehr7hQr9orFwT/hZbvUt2kD3wiGkKPNw9MZ7yIW08iOp6oqzfwHb/Ps4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782376540; c=relaxed/simple;
	bh=x+w9SGxZBWO4hPXg8E+A/q/4ScS0BqeDSCrwJNo6iBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JxEuAvoWRQ/ah924hOfCLEWy9XJEUe6IuYs5K63LKQ8E43i7bmEek95sDXJh4WPl/h8HTbog115nsCYSAbNYZtjiH2ULtsrMXhWcw4ASQZS7ywle1AK91c69dNHlr350luiIhl4ZDjlho62wusm4ZSSZDyUv1UvwHvF0IlrFyQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lQxcVK75; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lQxcVK75"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-46e335379cbso28516f8f.0
        for <patches@lists.linux.dev>; Thu, 25 Jun 2026 01:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782376537; x=1782981337; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0+ggg4zFesK0IrYb2saIE8cPaSi4XEf6KWehvtWp5AY=;
        b=lQxcVK75WCtuxwym6/zcbg7RT7bOAefVPcNhR+JiYJtV3q/1N6hzC9m5k9Gs0k5ASO
         U7rjH0K8Y/sYniN9UMg7zBZ6+xhHavOlpRL9aADoQAq60qFAJGZa72G6kNiRrYRFYkex
         T2QtMnRQBGb2MgVU15Astu2YISwGUiPFM3M7fhpiSG2E2QqS/E87cK/DYNJyyRY5MMoI
         4HHa44I1X+MMEQeO4l2DLAYnSCC3AUKGj3oSMY9c2HUp114oEFoxmYrReI15eoGkHlVV
         wgepziB+VQL6WvSe4RxzrGMuyMd5/+zY9Ya/TNg5O3OGtIvxg/B4utMin7WJBJ7UL87K
         qf+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782376537; x=1782981337;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0+ggg4zFesK0IrYb2saIE8cPaSi4XEf6KWehvtWp5AY=;
        b=F4BbjFwbWHbOmuMNz+dGA42nOYlNOAh8woaq8Z3/2WdXYGH5EU3nyRKYcu4nbUCYS2
         k+YhvE28xBrzOJOca73AJszIOT+sXnl36anjcjtGXPlKCpNRUuKCYeubYgz81jIc7eyl
         hKJex/taiwm+vzfU6FbbC5cSWipC2zBg1m5jIMLvcIEQkO+z2fD59cDDtXlJNFQ/C3Wb
         Hrs0cuwqEcJnYqL2OsQgf19A9unegYXutmfIkH5poZkJPKRRD2sXnqVlC2+Omoh02hKi
         MtK/6LKkLhtLDIP/seQ0mMpb+rAOpPYXIFWNAR/aP5JF+Vgs+QU1oB79bQKqUCEJ15tk
         U7dg==
X-Forwarded-Encrypted: i=1; AHgh+RopkEqwfyb2gwwpCLEPLw4loX2j2RmEzNdNSpCGFEZN9k5Lvd5f4FyTuZubyNFV/Alqa0NeVjjF@lists.linux.dev
X-Gm-Message-State: AOJu0YzQ9EV6KDls/8jpgPGUvxn6cViRYwHHT8oTyfAILc2So8fVE5Sj
	xsHf+kTIh0JsDEIzazLpToYVMiBcOc6n746XrjXxU09Llsrb8dBiqkpT
X-Gm-Gg: AfdE7clXPbz0nL3vcbNjXRcvMcC4NAUZ8Zbp9PreDkRqU8eFRqbseJ0fL43g8Kh0Lhp
	r+LcswrpxS3mT5Ntmofysvs7iysMSRI0Pf6/VMwrMWoX5UGY8qiV0IRmzscJplXN8ieoL6Cum4+
	r2B+DLc7qmFrvhfa/rFGESHioCnDFl94h2gKi8SmAAJecZvABid5Hh4S+tQBTyWD1qInYa8DyH8
	dkcE+FIXNqEiHsAXNYcZ2sJXUArGMQ8XjjQ3hgmlX1DcxbkFK5QX27ITZOB6iutmy1FpyF4dyUN
	akX52/Tg0+L61YLd+B1gjTVumDFOu56BVDxDI2XIFQS9eG3vuJeNFXrG03O84788/JZX98wBVYq
	XVBpW2vus0SRS2o9yQLf++iHNfoFYRogRVYOlUe7i8wWLR6ivuzgMnNKBWvfee/wKkoaaP/9gUA
	ZjQLX9vjhz
X-Received: by 2002:a05:6000:1841:b0:451:3b12:9bca with SMTP id ffacd0b85a97d-46dc20763ecmr2315779f8f.25.1782376537012;
        Thu, 25 Jun 2026 01:35:37 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-46c2279b85csm13357402f8f.28.2026.06.25.01.35.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2026 01:35:36 -0700 (PDT)
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
Subject: [PATCH v2 2/7] vmsplice: change argument type back to "int"
Date: Thu, 25 Jun 2026 08:34:04 +0000
Message-ID: <20260625083409.3769242-3-safinaskar@gmail.com>
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

My previous vmsplice patchset changed vmsplice argument from
"int" to "unsigned long". This may cause problems, so let's
change it back.

Signed-off-by: Askar Safin <safinaskar@gmail.com>
---
 fs/read_write.c          | 2 +-
 include/linux/syscalls.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index e224e7cb8..77487b307 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1218,7 +1218,7 @@ SYSCALL_DEFINE6(pwritev2, unsigned long, fd, const struct iovec __user *, vec,
 /*
  * Legacy preadv2/pwritev2 wrapper.
  */
-SYSCALL_DEFINE4(vmsplice, unsigned long, fd, const struct iovec __user *, vec,
+SYSCALL_DEFINE4(vmsplice, int, fd, const struct iovec __user *, vec,
 		unsigned long, vlen, unsigned int, flags)
 {
 	if (unlikely(flags & ~SPLICE_F_ALL))
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index a86a88207..46a3ec954 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -514,7 +514,7 @@ asmlinkage long sys_ppoll_time32(struct pollfd __user *, unsigned int,
 			  struct old_timespec32 __user *, const sigset_t __user *,
 			  size_t);
 asmlinkage long sys_signalfd4(int ufd, sigset_t __user *user_mask, size_t sizemask, int flags);
-asmlinkage long sys_vmsplice(unsigned long fd, const struct iovec __user *vec,
+asmlinkage long sys_vmsplice(int fd, const struct iovec __user *vec,
 			     unsigned long vlen, unsigned int flags);
 asmlinkage long sys_splice(int fd_in, loff_t __user *off_in,
 			   int fd_out, loff_t __user *off_out,
-- 
2.47.3


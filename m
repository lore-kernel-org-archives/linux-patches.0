Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 043E32ECD3A
	for <patches@lists.linux.dev>; Sat,  6 Jun 2026 06:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780726264; cv=none; b=SLteNXdxqBkAdZqHiaUfeqgQpTFuHBGbe6/SnLlvWeYFZQU8wiC4Vc/bYmpP7km0SQcbuWbY4nsUEq6oz5Sb3UZC34SdjqToNRbgHc/ut5kKj0m3OmNmVpyaAhVgtmbqx1pCRZOvWXYEd0hKTrpyy5Gts6GKcKwcKIEn+eS5A5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780726264; c=relaxed/simple;
	bh=ve8FNUDJ+bfAlTYt1tyGpBHY0ZFpeP48sjRpO5hIorA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KXD9Gd7tPpJEDZ9kn8ljAx6ALAEZVlSiKTM+Qp6nl1B911Z4Fre4oZQOAsJCu0eY6b7/cVJHMN6nd3iocsQ72ntMbbPevXQ/2WaAIwBSqVshnyo2IgNT2K3w5qjgWVRopfxCp5QgMZmeHWKDxD96xeD0ZZvKmrS9RAEi+Sv761Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EWd0tEj2; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EWd0tEj2"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-45ef1198766so1433961f8f.0
        for <patches@lists.linux.dev>; Fri, 05 Jun 2026 23:11:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780726261; x=1781331061; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8r8X8oylGshLaIHIAK1kgCpu4mjI5I9eQ7pptBpGukw=;
        b=EWd0tEj2Zlx/PSOJerN28qfnqncXKdIvo60deiezT/0qoC1MGq1j+oViB4XEgOSnUd
         FGRXOj7YIeB/K9xld62jNOc73PMAfmvwroE5qaOkX3F9RA+kaZpylqhMFQrNAqJbYaoT
         jUwiORGDZRITmKjQapVUWvjNUidhSLBXhq4Na4hmfa769o00aCxETfjjsrpldvvnlQoo
         hZngxeXiaIY4fQQZBCFBdg+FsfVXa9UrFi0NdpcMFhgVdMg7A3lBQfqz1HovCcdqhtnZ
         jp0ilDv0R2d3GB93wYye6B26JHaAKwtv8xzg2EAfnHeY+wWCTDp/wLvwkjReo6Qo1zPw
         77iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780726261; x=1781331061;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8r8X8oylGshLaIHIAK1kgCpu4mjI5I9eQ7pptBpGukw=;
        b=CXFtI0f03OeFbJxR7DYMD1rRaAqJqDL8U7n/K6J/VInr0lGS6lkp8uYbxmKVZuMnCX
         MQsW79dFuh93cZ3sJybRSNvXxalp38UyFUw5loTQroXvaee+ncMdJTaGpmMBiG0uGSVW
         n+psUkrRBbnu8YfQBhv50344iL6EBKwrjWCTTfd3hhtPexoDPJ0ZJBVjuitVaYwRVKR6
         njvEcZqAw6IVLGT4EwNacGaO/JP2NnmxdKlY6//u72yaQsCsyudWSL0h5KZKKV7apAvB
         2sZmpobSVfvsjRZyckWKbRKpY7FPtP5Hx6kvyWvZfQC2Vw+R65wbftdOw44dB9PnUojs
         fuog==
X-Forwarded-Encrypted: i=1; AFNElJ8pR0vhdrcu9qt8FdeRKgn3AhXl1K+ECREP2v3nu+bbHt2ef2K0EYgIrYeV7gYOFqhCkHVUs4Bs@lists.linux.dev
X-Gm-Message-State: AOJu0Yxj640wpZdz9Qy7UQ8V7E9umFMTTz6LrjRZtav+nTKoVUoe/0g1
	ATNzUQfdpz4LLcNw1shCyxz+JvcxF14ku/KZ13fJmeqIt4YaAlFPlhMc
X-Gm-Gg: Acq92OEXNVQHh0O17CZPMXnHc3Wfn2S9oZ/+Y7OnjqHIqKwCWH+wtu8pjni3ChQmHDb
	fOUVWcS9BKnU6g7kVMqMDY728mRjzYyAUuMTcZNI04PVeShLv0t84yRSjdbXLBeVU9qPr/LXGYx
	qR5+646oaNFzjzD8ua8n6kpECQ+FRWYGL+JvXUPPxkwRfA5aVKSgzayttYSsmhrDI0Y/HMpd37t
	mRn6O1VZX+CpXBC4fm4qwyJP25Sa/ma1hPtzQaLUvCgZgKwI+MXDXBRd3jI5kEYr48ciz1yUPFF
	V9XDYWisOP4xZ2cLgYsXsveb8CGTaOy9ryhdkUXg/EiY31lvTR90lq+m7BiQVEcChQq1TacY/Av
	K86+1LrTiBlHMXkPyd5mq8WpDSVWvmhQfd0sF7lwY+1X4B2xEPDXQCkiaf+WOBzK4AnHcubL+Xf
	rh0c7d/DEr1hTPHUFtzIV23zSYzeB3Xw==
X-Received: by 2002:a05:6000:41c4:b0:45e:f5b5:885 with SMTP id ffacd0b85a97d-46032b610d1mr8361361f8f.2.1780726261254;
        Fri, 05 Jun 2026 23:11:01 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-4601f360bd6sm34254711f8f.36.2026.06.05.23.10.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Jun 2026 23:11:00 -0700 (PDT)
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
Subject: [PATCH 0/5] vmsplice: fix some problems in my previous vmsplice patchset
Date: Sat,  6 Jun 2026 06:10:26 +0000
Message-ID: <20260606061031.3744880-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patchset is for VFS. Of course, it depends on my previous vmsplice
patchset.

I fix some problems in my previous patchset.

1. Fix problem with CLASS(fd, f)(fd). See first patch for details.
This is probably not so important, but I fix it anyway.

2. Change "unsigned long" back to "int". See second patch for details.
Again, this is probably not important, but I want to fix this anyway.

3. Fix that LTP vmsplice01 bug.

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

Askar Safin (5):
  vmsplice: open-code do_writev and do_readv
  vmsplice: change argument type back to "int"
  splice: turn wait_for_space flags argument into bool
  pipe: move wait_for_space to fs/pipe.c and rename it
  vmsplice: make sure we don't wait after writing some data

 fs/pipe.c                 | 17 +++++++++++
 fs/read_write.c           | 61 ++++++++++++++++++++++++++++++++++-----
 fs/splice.c               | 19 +-----------
 include/linux/pipe_fs_i.h |  2 ++
 include/linux/syscalls.h  |  2 +-
 5 files changed, 75 insertions(+), 26 deletions(-)


base-commit: 8d86fcfc2857d64af85f5c87c193c25655c970af (vfs-7.2.vmsplice)
-- 
2.47.3


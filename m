Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B795937D132
	for <patches@lists.linux.dev>; Thu, 25 Jun 2026 08:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782376517; cv=none; b=S/NOFQPQGL9J/RYmRmnRSD7rPnJ4lkfEtygJSlAHHaXlbW9yyUFZK+auBEqkRj/vHXzEAHNNmWu5fq46Svmx0y2CChDj2r14Rpg7y2FLpc6MB3bUbOwwgIHkH0s5vELuucSx6hvKX1AR1cmhHC5poqrf8DTAHrX3xtE0KRYdhJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782376517; c=relaxed/simple;
	bh=QtIkhOcb4XuSPNMSHsQTam2xRok/IOw4SC1HUoDCl24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HiTpGgLIR6O+ysw7rejC3YSBcDrWfraKQ6fplg2qUSEWMy0Hdqkv2/PEDnfi8VLU90MNf5SWSbsJGpmX65CLRwrjQRCzT6k+p2AUgj5tIWiOqd4nsaFXNqNQrAI+8pdVTB/fRWPwUzJ9NdV1oKF4XNVzujiInFnqU/aiFiswGdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RhzO8hRo; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RhzO8hRo"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-4629051c946so453367f8f.1
        for <patches@lists.linux.dev>; Thu, 25 Jun 2026 01:35:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782376513; x=1782981313; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T2cQgCHbxQom2kVIv1Cvt6Y9CPEs8rn7euaXGTL0+j8=;
        b=RhzO8hRosLeLBjPemWX006m9s5ZNUa0ZSqZE1n9L5l2TQb/tNblKBW4C5mfYUBHJ4Z
         3Y6do0DjqKerUddsr/sOlL/VkFSqi66ZXr37W0vujrTOw5DNoVwzL6q5anhqTUrIgXl6
         kMCTSHXZIcI5WrCxM9W90O2ulH+F2b4bwKq4/lv7GFJOdTLk3tCzX5G8qHZggC2Is5w0
         HnwIPWOtbiJdixyx40PPMwsaeOoZVPMI9eiIRropEFqbRBqgOw14OQ4stziHXQJN5uA8
         thbJ4PBHvqii+Q1Ko32UpLhx8KGGWgytAHcPGD5wvqpq0s1hy9HFLfFWQMtZhNRUk/Xw
         UZOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782376513; x=1782981313;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=T2cQgCHbxQom2kVIv1Cvt6Y9CPEs8rn7euaXGTL0+j8=;
        b=lEluwoH+sDF1yJOOIIQWvtqv70Q0QTNh5t/4oIANX549NTk/WT6+3pJiaVMqyA3/Yz
         WlLAmhB0FJ7UMWuFhMu4sR0QR5zlIAGbC+x2uL0zHif3e+SG9BUfg2+wb+IPgXsCuN+i
         +ZOW2RembJtjLnblqiSOBJRzJPj8ze7obN94SW1lBlNBxIV9n/tq30ZE2/cKQD/gHHHV
         t92EPsfvy7HGGRUdEdQAh50MPGTw3RiXy+Ac/8HFWKPUEsXRJ1mia/QGlqmfC6VTGcZs
         0EMbjFs1AzGG2zNcvX+bgv1ULtOrSRebJ2OtyupPHm0AZ+fp57ijPR4V2lQzLWnKV9fZ
         wiHw==
X-Forwarded-Encrypted: i=1; AHgh+RoTV9mBrSeUdqWiU9j+DFki17+BSSWT/6dDOmhPkhsdOuUhgRm9CECDyn9JdAbtAJGyIN9fBb6G@lists.linux.dev
X-Gm-Message-State: AOJu0YyHRvsvoE6bQ5UUkWFjicw6sIYEnLDFlHVlht/AbZbz/TAx6+ot
	aIwELAls6Ekc32PK7AwEJOqMg3S8kylhQdsaFB5f19Qv27Xbsx+KXkZY
X-Gm-Gg: AfdE7cnOMY3EYc0YTKryOL1SgzYw4hdYThxPcf57iVBb/Rv2xqoNhXZw4E2NTiJ1iYs
	68XAGf5ITmM0tTT94DZDDGNF0u+4lQO68A6tvjRcDSMwrIgE59c3SHeJoRWyWTdh7qf6z7xRCyi
	3G419fVOKnaKPpMOj6eeu0yDnWhbOlk15cqJTiiWioUootDidF7aLquCR6gF8l+9pvBljESqfPb
	ZrQJFK2aTAgNFPNCtBeYb8RaS4nC4Kk6hR9VGt+RZzh/z9zhHEMrL0jqR+LIzAynr6Hs6zELolc
	b/9P4Mk3QoV2xWtWr5PsS06BW1SiovvboCWUfxauOJqaefyMU+mELkfVhnpzW1/A/+LhhrBei/0
	VSM+z5TysxW3S13v8u4XBneqiZhzmmKxYna3tAgrABKILN2gHA6mI8udlH9i1Aqde/RKhcpphGr
	WprDdQBlri
X-Received: by 2002:a05:6000:4603:b0:460:602f:85a6 with SMTP id ffacd0b85a97d-46da34965dbmr2376831f8f.0.1782376512951;
        Thu, 25 Jun 2026 01:35:12 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-46c9ed7491esm9926887f8f.37.2026.06.25.01.35.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2026 01:35:11 -0700 (PDT)
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
Subject: [PATCH v2 1/7] vmsplice: open-code do_writev and do_readv
Date: Thu, 25 Jun 2026 08:34:03 +0000
Message-ID: <20260625083409.3769242-2-safinaskar@gmail.com>
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


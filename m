Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF1F52FD1B6
	for <patches@lists.linux.dev>; Sat,  6 Jun 2026 06:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780726383; cv=none; b=SOw72POdau5QOfjfThs/qe6g0NHXtyX4PHStYmf8IufywvVPnPd6Q43kpUaRR+K4AjYfZuMJbbPzJ6LVe+h43T4uRugzHsymOiR2J/+aiiRPaTxARgPGc13ce0E6n1lqXHUeT5OBr8GrYtsBkZ0Pb1GlV+VXPDzWm+DxVe0R27M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780726383; c=relaxed/simple;
	bh=YVkMCLt5FJ+bDbSrJETzwIU6LK60EPUbwXQNXghAHuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JrdxfFWfoXwbOQ7UotFmmkPGclxQqqH0OLt+EZslPD4M50ekj/rAnHvjS2RKip0YJ5/cYqeYwITh/KqKIugcEdFeaWsVjhrgUGiOfuIOAyEBbiy3UvmPRJPHbKoY4aIUIYl/EoGmiyvW5QMlIKJ5PqLO2wWAQ8GcfVAS6XTcQCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dnl+EcXI; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dnl+EcXI"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-45ef1629ff4so1713655f8f.0
        for <patches@lists.linux.dev>; Fri, 05 Jun 2026 23:13:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780726380; x=1781331180; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y22J8nzR3UW0cMYCUVJWDcFSFo/6kHGVqnn/SzRaSz8=;
        b=dnl+EcXIzSy4EtPF71WNcyUsDMqVa9q6+43pLi+M7D37/oF9r4AoUCLRGo3YcqHvYr
         7VcCzIFKB2C230+KYX6rUAxGlaYanqkLn9iUqsO8wFwznyyEOoWkI0Wbbx8L4QLm74gr
         15XK0ua1uk8Ob8TklgZUvDBCWQ6v0CnNGXp07Mro8DmQFZ3MEroziM1fmD453tS9cqHo
         b3/gYRbaMALHswuIW3KCXZzOyR/Vn1Wn3ht0j8DFWEj5ITMqlJY40OLtDCAjvyqScrV8
         IkaG5eESmvuCKjia352k91MQ73uRQHAhPtSXLa9GSILjFw7PVEkpQF0AokRbAEntGv5A
         n5Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780726380; x=1781331180;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Y22J8nzR3UW0cMYCUVJWDcFSFo/6kHGVqnn/SzRaSz8=;
        b=KLbCioLVjiNJXpEAelwAx3+z7rfOUcmfAC6y7t5Bj0IFGTOerb5x/J5jXuy5wW9Y9B
         o1/Ggp7tOQXtXcOSnALDYyrERY5r+xSgkSHOtOLPEMtxYB9jYjV64I/DEjPHCXfWJQFB
         KK1MuRiv17HcimeEk96EdGRDlVtkdM+y33dXmsNMbetv15CZ77HEY6doKDtzuY0pqL89
         N4cINa6oR3fLnwna+TFkTrwejbQGec4PXPwFuX2vpKQ/RgpCjulzGhhZirJfEZV++fMu
         ZjNeQ0Z8HqIeJX7nVjdPs1j9hv3UxgvAvNVZ+gS+Tcww6BtOYB3qK/joskgc2wyETm70
         iCuw==
X-Forwarded-Encrypted: i=1; AFNElJ8UZotUwzBNQ/AxDpf0u46vitsMhdae8YxmFbrCZpYCKx2fn5PgFbd/ptA4dkFYjC54nGph5/n5@lists.linux.dev
X-Gm-Message-State: AOJu0Yy+PmLLfHbFnaENAzY18igGZDgCjFp+gT32FHyRsuubK/TgQ0M4
	ZdzCNdpQnQSEIvLUQK8Wp+MQc82tX4GXhnL2xYw9TwzM7ybUmIQLu0n/
X-Gm-Gg: Acq92OHv+uMdBgCmhvlmWyro6mKPcVt0HVC6wR91Ht7LwB1RWuRVGOz7vlnNxyP/l1+
	ayvOPGBZAnDrU9zoREdUfo2EeH2fcgNk0hkhPIsEoyvf1J7gi78GCjpRzavG3LMSA30irgO9JJ2
	koj91qtl+WtmbOpDPS0MXMfcv9KEf/L67aM9R3pwKf4Lt0TJhEdwXfRg9MGNMTMlVXsrFPttKGi
	08l1SWnR2oK3188aeeIA3FgeAUoqHOX254/cJwmBO0QvK9gD5pkDTOMFTFIHbsQrEAjWCNbtTTi
	CM/hFB8Q6+r9BApLuFGC/CQWHoJ9vGPkpAVeMw/v222YN4X3jxP7Gzu2S4gLkxn/NI8NA3fRbu1
	KPFNqU9kaUU1yniYEvp+GHh9AwxNk3+WoW/H2K4hETmJwOdu+p1u+oEK1jYxY+zMMEohs+Ebe2I
	ArLRjyCgNhBFF9f6O56oS+kU2fUkeh5w==
X-Received: by 2002:a05:600c:c0d3:b0:490:b0e0:3de2 with SMTP id 5b1f17b1804b1-490c265c148mr78044605e9.33.1780726380490;
        Fri, 05 Jun 2026 23:13:00 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-4601f2eadefsm32281391f8f.11.2026.06.05.23.12.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Jun 2026 23:13:00 -0700 (PDT)
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
Subject: [PATCH 5/5] vmsplice: make sure we don't wait after writing some data
Date: Sat,  6 Jun 2026 06:10:31 +0000
Message-ID: <20260606061031.3744880-6-safinaskar@gmail.com>
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

Make sure we don't wait for space in pipe after writing some data.
This is needed for compatibility with previous version of vmsplice.
Found by LTP vmsplice01.
See comments in the code and links below for details.

Link: https://lore.kernel.org/all/20260603-raumfahrt-unmerklich-ertrugen-c4ecae70d5f9@brauner/
Link: https://lore.kernel.org/all/CAHk-=wgV-j-G3d+899Zm1pQ=NaJrddPz=GKcL5Yw5DTUM=GaUw@mail.gmail.com/
Signed-off-by: Askar Safin <safinaskar@gmail.com>
---
 fs/read_write.c | 39 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 37 insertions(+), 2 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 77487b307..dbd0debc2 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1221,6 +1221,8 @@ SYSCALL_DEFINE6(pwritev2, unsigned long, fd, const struct iovec __user *, vec,
 SYSCALL_DEFINE4(vmsplice, int, fd, const struct iovec __user *, vec,
 		unsigned long, vlen, unsigned int, flags)
 {
+	struct pipe_inode_info *pipe;
+
 	if (unlikely(flags & ~SPLICE_F_ALL))
 		return -EINVAL;
 
@@ -1229,11 +1231,44 @@ SYSCALL_DEFINE4(vmsplice, int, fd, const struct iovec __user *, vec,
 		return -EBADF;
 
 	/* We do vfs_writev/vfs_readv, so it is okay to pass "false" here */
-	if (!get_pipe_info(fd_file(f), /* for_splice = */ false))
+	pipe = get_pipe_info(fd_file(f), /* for_splice = */ false);
+
+	if (!pipe)
 		return -EBADF;
 
 	if (fd_file(f)->f_mode & FMODE_WRITE) {
-		ssize_t ret = vfs_writev(fd_file(f), vec, vlen, NULL, (flags & SPLICE_F_NONBLOCK) ? RWF_NOWAIT : 0);
+		/*
+		 * When writing to the pipe, previous implementation of vmsplice
+		 * first waited for space in the pipe to appear
+		 * (depending on whether SPLICE_F_NONBLOCK was passed),
+		 * then did unconditional non-blocking write to the pipe.
+		 *
+		 * This differs from what pwritev2 does.
+		 *
+		 * For compatibility we do the same thing previous
+		 * implementation did.
+		 *
+		 * We lock the pipe, do pipe_wait_for_space, then unlock
+		 * the pipe, and then do vfs_writev. vfs_writev internally
+		 * locks the pipe again. This may cause TOCTOU: when we
+		 * do vfs_writev, the pipe may become full again. So we
+		 * do a loop.
+		 */
+
+		bool non_block = (flags & SPLICE_F_NONBLOCK) || (fd_file(f)->f_flags & O_NONBLOCK);
+		ssize_t ret;
+
+		do {
+			pipe_lock(pipe);
+			ret = pipe_wait_for_space(pipe, non_block);
+			pipe_unlock(pipe);
+
+			if (ret < 0)
+				break;
+
+			ret = vfs_writev(fd_file(f), vec, vlen, NULL, RWF_NOWAIT);
+		} while (!non_block && ret == -EAGAIN);
+
 		if (ret > 0)
 			add_wchar(current, ret);
 		inc_syscw(current);
-- 
2.47.3


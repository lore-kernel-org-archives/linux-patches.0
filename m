Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831135;
	b=rSHPwRUUNhCyDAGkIOXWYFeKpWxZ3E4OYeOyw54aN65UpsHBwVEWsHLxhHSGaVy0Rrk9
	 /nw3KKgq8bsYO7SFjJ6vC3h75lEbCGV6X+F4x355Qx9LP9md8Sl14k2x1LVWBAELXoFFr
	 rLlJKEFyV+jrUNETJSXxcFaxySzQIeCFxv8kjfumrG29lHZ0cDDFedoLwfWGZxC4rvxky
	 DM+k4ugd7eTUfBa4vT2fL77LQQH70zDfnaM0GsItmD/XXI8ddxnaMy27IRQhuzq6NBelB
	 oyX/hlrmcJA+2Ra4NFunN1ZyQM2H2Ya9Gshmym8VsYkPlm/9PZm4MmrC/iH7Lv5eNAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831135;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JUStYlxBub2NqfkdItWZoYJO0asrgBzKZkyGiXNElfo=;
	b=j8vTIl/bpjrgofiMG6O/nwh1pj71WPEG1ejJNXwCuWusGS2nOxkqcQd6OmJ37MwVLnum
	 j8Fkae5yUegs/PU1mlEhJB21L06A102vkb3shZpeFqDwAMY8DZ4OQSvCtEt4mrc/NCU9G
	 7VwT4P5JNKCtbJVPoHkw4Zn6JFMrNTXoNpGgT6zT7zez0vJo9tNcyAs9G0KtRRpMKQa5S
	 CkMe52PSRK2IQJEd7ZxNbUbuVya9X9FO5/MYBJVzkdEW+u2lhyZzx/YisI76zXGWTd7Qs
	 iTHVYOCoVkVnArqwhrMGSHIvweuGrUoFhZgpC7ew4H00Oks5qERpEMOt3utJ/vmeV4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=enmgWt5e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C31F606B3B8;
	Wed,  4 Nov 2026 22:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=enmgWt5e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C3241F000C1;
	Wed,  4 Nov 2026 22:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831134;
	bh=JUStYlxBub2NqfkdItWZoYJO0asrgBzKZkyGiXNElfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=enmgWt5eNoBDdf/KDcxYFvmStoIFw/b5uu8J/6tX5zhnf98saamH7Uz8llm6/qseE
	 zaXlo5xj1mARYXeWMvRM+Wl1mVvfnqlH5DCTUplbhnMtCv9pXKgJwjO37H8S6WoNiN
	 thyop3hg+ech/X+jwGMItteBGCMMLbOND0hgbEsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.18 0519/1005] fuse: dont BUG when the copy buffer is exhausted
Date: Wed,  4 Nov 2026 16:04:12 -0500
Message-ID: <20261104211058.464321241@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiang Mei <xmei5@asu.edu>

commit c1338aae7b4054e26f322155423f6aba90aeea23 upstream.

fuse_copy_fill() hits BUG_ON(!err) once the iterator backing the copy
runs out of pages.  Over io-uring the amount copied is not bounded by the
payload buffer the server registered, so an unprivileged user can drain
the iterator and panic the host - mount a FUSE filesystem with small
payload buffers, then setxattr() a larger value:

  kernel BUG at fs/fuse/dev.c:1064!
  Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
  CPU: 1 UID: 0 PID: 148 Comm: exploit Not tainted 7.3.0-rc1 #2
  RIP: 0010:fuse_copy_fill (fs/fuse/dev.c:1033)
  Call Trace:
   <TASK>
   fuse_copy_args (fs/fuse/dev.c:1354 fs/fuse/dev.c:1380)
   fuse_uring_args_to_ring (fs/fuse/dev_uring.c:891)
   fuse_uring_prepare_send (fs/fuse/dev_uring.c:940 fs/fuse/dev_uring.c:1057)
   fuse_uring_send_in_task (fs/fuse/dev_uring.c:1745)
   tctx_task_work_run (io_uring/tw.c:96)
   tctx_task_work (io_uring/tw.c:133)
   task_work_run (kernel/task_work.c:233)
   io_run_task_work (io_uring/tw.h:84)
   io_cqring_wait (io_uring/wait.c:278)
   __do_sys_io_uring_enter (io_uring/io_uring.c:2676)
   do_syscall_64 (arch/x86/entry/syscall_64.c:61)
   entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)

The reply path can drain it the same way, via the server-supplied
payload_sz in fuse_uring_copy_from_ring().

Return -EIO instead.  All three fuse_copy_fill() callers already
propagate the error.

Fixes: c090c8abae4b ("fuse: Add io-uring sqe commit and fetch support")
Cc: stable@vger.kernel.org
Reported-by: Weiming Shi <bestswngs@gmail.com>
Suggested-by: Joanne Koong <joannelkoong@gmail.com>
Assisted-by: Claude:claude-opus-4-8
Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dev.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -937,7 +937,8 @@ static int fuse_copy_fill(struct fuse_co
 		err = iov_iter_get_pages2(cs->iter, &page, PAGE_SIZE, 1, &off);
 		if (err < 0)
 			return err;
-		BUG_ON(!err);
+		if (!err)
+			return -EIO;
 		cs->len = err;
 		cs->offset = off;
 		cs->pg = page;



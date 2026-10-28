Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213039;
	b=nGr+9Qj8TTF9HQtQbuFmSQATCYRAn8uNc0kcHyp0IdKQve4WkUbDuVJMsQF9Rf0UkM5k
	 1qF4VK4DD9/bSemf5XEGwKnnBQ4SJZZj2ep0B9vSZGwukTR3MX52ug1JHBLk7USR/cUqF
	 UX8GPPsRMlXwfkfTo9yKezy6GyTIE6Qc/nK2gMlq6Sr5R5qTm2BYBFawnlSOTnsNvXLCD
	 Rzjf5d823C3KowmPfCo6dCXNNRaJ/fwSqOoYv6u+KoRw24UEAopmlK7H7IgFnIWghYIDo
	 d17ORGpEpy+UdhE6wu9iYDBuw9gImkrB0uVZyMLwxB+iDtDb0XeayCAm8TnkaL/1CWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213039;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=55QYiGyKQkp9MCblnVXuh7GKcxzk3fSt0cVafDZACvQ=;
	b=ZP22I/xfRdUebFPKGch3L/6V0l6XfFjqD5HHJuq7nIiN5JEJlrcYrjGPqoErY/XaVO/t
	 JECovTRFNunLEyZ8XRa378hFYw6+XfSfP714zH9unNNzS2MbmlO9b0hRS8mLNd3mKAsGM
	 Wzx5CfUYckHqxioYF64RZWLsH4KM4eS5e1KK11hQcNYCyLoFSe8RpB27t1s25W57AKeuQ
	 B1BMLl7qpg1WFzKx7cBerQLEk9+j97sqntFgkx3dXMVQKrHgUC244Ehccus2qjlRaV0S0
	 +TY+WOzg4I/A8YgfC1UPU3+qls2NP4jS1pk67SJv7Rg5UyoCm1ggquQUyYwk983K8bw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="039VS/Or";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF47606A31E;
	Wed, 28 Oct 2026 18:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=039VS/Or
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DFBD1F01825;
	Wed, 28 Oct 2026 18:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213038;
	bh=55QYiGyKQkp9MCblnVXuh7GKcxzk3fSt0cVafDZACvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=039VS/OrjBuBHekwKoIlNKcq9l+rOyHGzIDBqvymv2E9ZNMeP1gj4zk3UdSX3ACKh
	 i1dFlHhwMlVT/G7ty9iLByeDNEnhdHIs5BLnySTLC0paL5GJIrQPciUgRrqIELZWqc
	 pxOtMKrBv44c0WVxGcO4ArjPkWRCnPeHZGRj2UuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Prostitis <prostitisgabriel@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0365/1887] USB: gadget: ffs: fix mm lifetime handling
Date: Wed, 28 Oct 2026 17:41:01 +0100
Message-ID: <20261028170507.539853704@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriel Prostitis <prostitisgabriel@gmail.com>

[ Upstream commit 5eb5c72c72fef76cb765ef1669b62b6a3ba1bfc8 ]

io_data stores a pointer to the submitting task's mm_struct,
but does not currently hold a reference to it while async
requests are pending.

This can result in a use-after-free if the task exits before
completion handling finishes.

Take a reference with mmgrab() when queuing the read request
and release it with mmdrop() on request completion.

Reported-by: Gabriel Prostitis <prostitisgabriel@gmail.com>
Signed-off-by: Gabriel Prostitis <prostitisgabriel@gmail.com>
Link: https://patch.msgid.link/20260601-mm-uaf-fix-v2-1-3c942a707bce@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: e78dcb1f7ec2 ("usb: gadget: f_fs: Fix Use-After-Free in AIO error path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_fs.c |   27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -842,9 +842,15 @@ static void ffs_user_copy_worker(struct
 	unsigned long flags;
 
 	if (io_data->read && ret > 0) {
-		kthread_use_mm(io_data->mm);
-		ret = ffs_copy_to_iter(io_data->buf, ret, &io_data->data);
-		kthread_unuse_mm(io_data->mm);
+		if (mmget_not_zero(io_data->mm)) {
+			kthread_use_mm(io_data->mm);
+			ret = ffs_copy_to_iter(io_data->buf, ret, &io_data->data);
+			kthread_unuse_mm(io_data->mm);
+			mmput(io_data->mm);
+		} else {
+			ret = -EFAULT;
+		}
+		mmdrop(io_data->mm);
 	}
 
 	io_data->kiocb->ki_complete(io_data->kiocb, ret);
@@ -1229,16 +1235,20 @@ static ssize_t ffs_epfile_write_iter(str
 
 	kiocb->private = p;
 
-	if (p->aio)
+	if (p->aio) {
+		mmgrab(p->mm);
 		kiocb_set_cancel_fn(kiocb, ffs_aio_cancel);
+	}
 
 	res = ffs_epfile_io(kiocb->ki_filp, p);
 	if (res == -EIOCBQUEUED)
 		return res;
-	if (p->aio)
+	if (p->aio) {
+		mmdrop(p->mm);
 		kfree(p);
-	else
+	} else {
 		*from = p->data;
+	}
 	return res;
 }
 
@@ -1275,14 +1285,17 @@ static ssize_t ffs_epfile_read_iter(stru
 
 	kiocb->private = p;
 
-	if (p->aio)
+	if (p->aio) {
+		mmgrab(p->mm);
 		kiocb_set_cancel_fn(kiocb, ffs_aio_cancel);
+	}
 
 	res = ffs_epfile_io(kiocb->ki_filp, p);
 	if (res == -EIOCBQUEUED)
 		return res;
 
 	if (p->aio) {
+		mmdrop(p->mm);
 		kfree(p->to_free);
 		kfree(p);
 	} else {



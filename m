Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065218;
	b=iIkHd6mbqTeYNBugNNQXfTSsOAWPTDdvyRgt0XvJddtsI1YB0SK80up36Od1PbBAJAke
	 ubxmmbEFA8vYvXb6llkEvZoLcmg0+nEbrT9eHr3KLuiY9NSspA5YlR+5qQPz5IXL6YOao
	 QvGwuNuNo/6RENNLiUyc34wNfVNSbJLOK1/hXfeZ5WJ/KOZJJPjcNri56Ax2Jv+dxQM3p
	 89sjlL5yletH7Poc6u+91ojHPja45jg2og36efiALVnIDZG19HwJGfglWvoQjbiCu63s1
	 1Gm0gcupD5/bLNrpyOpzuymjzEg4IZ28xBOnGmdjAsecPEoAlWSOLXYqr7hjbcR1qXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065218;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QGazwSKHCs71ooC4udure0TdZgHO2BSgOWYI7wKNX5Q=;
	b=LvFeafhOStallEgUmxq8GUhLNNbOt3pYYaRI8bAXXydITqusGrcY9KD/b2SvZ2kbiL4R
	 Lq92A3sVGgKFoTVQPLZvbHJ/3phk7NGKyfwFfEkXrX4tpRr3i0WOdnO4Dx/yRBWpFZawM
	 CdMHUCCzMc51zZfh2qijjb0yEQrrxuYKkSP2RRc4wbfwap+HO/62OQqxsrb8nLRWDTBWK
	 ywSTCZ/AbV997nROCDcBCeU0wbTr+wBZdU5mRy957o9wMm9NfG99YCFd18hxNov1ZitkQ
	 A9XAZx4l5YlbAkUz/NZGo/GIyw4HKzOkvBP7CVobiDebSOj16To0NlSp8dTNF8ApYmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KQ9BdLnd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC054606A33F;
	Sat,  7 Nov 2026 15:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KQ9BdLnd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5901C1F0089F;
	Sat,  7 Nov 2026 15:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065217;
	bh=QGazwSKHCs71ooC4udure0TdZgHO2BSgOWYI7wKNX5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KQ9BdLnd6ZkIyiM1TWugbk+W0+cOJglexaubUeOQFjRvx8S9mqqpAunzsIuCaCjjF
	 cqLx3ibiCmeWXVMMcAtbH1IQCLRl3yY6cCBRK7fSUPo/wpXt/nmRQjb1PcVnF5tZvs
	 geyRDRzI5OHcmKh8ibj/GsBULPnugjXOtceRlVCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	Naman Jain <namjain@linux.microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1011/1257] mshv_vtl: reject poll files with multiple waitqueues
Date: Sat,  7 Nov 2026 08:55:07 -0500
Message-ID: <20261107135007.260213851@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daehyeon Ko <4ncienth@gmail.com>

[ Upstream commit 70cd4623f3e5068a72c72791b96f2dcb4c991131 ]

MSHV_SET_POLL_FILE invokes a file descriptor poll callback with a poll
table backed by a single embedded wait entry. A poll callback may,
however, register the table with more than one waitqueue. pipe_poll()
does this naturally for an O_RDWR FIFO.

The second registration currently warns but then inserts the same list
node into another list. The new insertion overwrites the entry links while
the first waitqueue still points at it, corrupting the first waitqueue and
causing an invalid callback traversal when that queue wakes.

Reject a second distinct waitqueue, remove the first registration through
the common removal helper, and return -EINVAL from the ioctl. Repeated
registration of the same waitqueue is treated as a no-op. A rejected
replacement leaves the CPU slot unregistered, consistent with the existing
remove-before-register ordering. Single-waitqueue users such as the OpenHCL
io_uring poll file keep their existing behavior.

An LLM assisted the source audit, fix development, and validation of this
issue.

Fixes: 7bfe3b8ea6e3 ("Drivers: hv: Introduce mshv_vtl driver")
Cc: stable@vger.kernel.org
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Reviewed-by: Naman Jain <namjain@linux.microsoft.com>
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/mshv_vtl_main.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/hv/mshv_vtl_main.c b/drivers/hv/mshv_vtl_main.c
index c6f1e2157d258..9133646b5b66c 100644
--- a/drivers/hv/mshv_vtl_main.c
+++ b/drivers/hv/mshv_vtl_main.c
@@ -73,6 +73,7 @@ struct mshv_vtl_poll_file {
 	wait_queue_entry_t wait;
 	wait_queue_head_t *wqh;
 	poll_table pt;
+	int error;
 	int cpu;
 };
 
@@ -482,7 +483,18 @@ static void mshv_vtl_ptable_queue_proc(struct file *file, wait_queue_head_t *wqh
 {
 	struct mshv_vtl_poll_file *poll_file = container_of(pt, struct mshv_vtl_poll_file, pt);
 
-	WARN_ON(poll_file->wqh);
+	if (poll_file->error)
+		return;
+
+	if (poll_file->wqh) {
+		if (poll_file->wqh == wqh)
+			return;
+
+		mshv_vtl_poll_file_remove_wait_queue(poll_file);
+		poll_file->error = -EINVAL;
+		return;
+	}
+
 	poll_file->wqh = wqh;
 	add_wait_queue(wqh, &poll_file->wait);
 }
@@ -492,6 +504,7 @@ static int mshv_vtl_ioctl_set_poll_file(struct mshv_vtl_set_poll_file __user *us
 	struct file *file, *old_file;
 	struct mshv_vtl_poll_file *poll_file;
 	struct mshv_vtl_set_poll_file input;
+	int ret;
 
 	if (copy_from_user(&input, user_input, sizeof(input)))
 		return -EFAULT;
@@ -518,6 +531,7 @@ static int mshv_vtl_ioctl_set_poll_file(struct mshv_vtl_set_poll_file __user *us
 
 	old_file = poll_file->file;
 	poll_file->file = file;
+	poll_file->error = 0;
 	poll_file->cpu = input.cpu;
 
 	if (file) {
@@ -525,13 +539,18 @@ static int mshv_vtl_ioctl_set_poll_file(struct mshv_vtl_set_poll_file __user *us
 		init_poll_funcptr(&poll_file->pt, mshv_vtl_ptable_queue_proc);
 		vfs_poll(file, &poll_file->pt);
 	}
+	ret = poll_file->error;
+	if (ret)
+		poll_file->file = NULL;
 
 	mutex_unlock(&mshv_vtl_poll_file_lock);
 
 	if (old_file)
 		fput(old_file);
+	if (ret)
+		fput(file);
 
-	return 0;
+	return ret;
 }
 
 /* Static table mapping register names to their corresponding actions */
-- 
2.53.0




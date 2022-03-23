Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88CA86AB9
	for <patches@lists.linux.dev>; Wed, 23 Mar 2022 23:06:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55407C340E9;
	Wed, 23 Mar 2022 23:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1648076781;
	bh=OOOg5sV6acqca9K6Ma4LhVQnaCX2eDgI6f8HEHiTKpc=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=F4WG/SKd+1s4ZnFY6Tzeowd27azsHGWwaW7TE9T3COsUk7CkoeXcHSqjD1Vxpuv21
	 QTiLLaR5WSOVP799aLkM/mV0Qsxk9pMCat3dsIX5B+AXi3fYVDOAv7xJEeNM1/obIl
	 NCILoWD9z2CKOWMdLLLZ4FFIUhhX6BMZm1lY2bWo=
Date: Wed, 23 Mar 2022 16:06:20 -0700
To: christian.brauner@ubuntu.com,0x7f454c46@gmail.com,avagin@gmail.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220323160453.65922ced539cbf445b191555@linux-foundation.org>
Subject: [patch 21/41] fs/pipe.c: local vars have to match types of proper pipe_inode_info fields
Message-Id: <20220323230621.55407C340E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Andrei Vagin <avagin@gmail.com>
Subject: fs/pipe.c: local vars have to match types of proper pipe_inode_info fields

head, tail, ring_size are declared as unsigned int, so all local variables
that operate with these fields have to be unsigned to avoid signed integer
overflow.

Right now, it isn't an issue because the maximum pipe size is limited by
1U<<31.

Link: https://lkml.kernel.org/r/20220106171946.36128-1-avagin@gmail.com
Signed-off-by: Andrei Vagin <avagin@gmail.com>
Suggested-by: Dmitry Safonov <0x7f454c46@gmail.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/pipe.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/pipe.c~fs-pipe-local-vars-has-to-match-types-of-proper-pipe_inode_info-fields
+++ a/fs/pipe.c
@@ -607,7 +607,7 @@ out:
 static long pipe_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	struct pipe_inode_info *pipe = filp->private_data;
-	int count, head, tail, mask;
+	unsigned int count, head, tail, mask;
 
 	switch (cmd) {
 	case FIONREAD:
@@ -829,7 +829,7 @@ out_free_uid:
 
 void free_pipe_info(struct pipe_inode_info *pipe)
 {
-	int i;
+	unsigned int i;
 
 #ifdef CONFIG_WATCH_QUEUE
 	if (pipe->watch_queue)
_

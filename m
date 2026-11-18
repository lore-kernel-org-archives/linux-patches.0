Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035054;
	b=sZ9CI323wVbzXj1CctQv7fo8oJ69+G9M2GZHrwInf2pKoaS6HYqH8PuVd8TamSGVJDum
	 KsHYe9Tt/6B8tNQAknYBuJBr3ABJg70s1O5ZypptJNSaf9D9P+EH3wfp97LAZtP9I5AOS
	 qzNyRxPQ0/h42f2I8ETNNrRPQQcIFvJQTNtfq8R+1wmnmcY6Enii/xY4Cq/h1FR6rlkA/
	 5SXVFc47qy8TgaDEwkrpojNham5hXk2Uw8QPND4IFJde+tLx2SACck75bLj1n1NFaj35Z
	 aQF57YjBcSrfbNxivjRYiraXQdWId3cVr2YqyAPiZnthJDzC5fNLN6gppLjCQcXdqUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035054;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OmiExuQ+yHP1pvhJ3rP6G3YyHsDVJCzNsszh6mZ2TaM=;
	b=CxhK08LR/P8XHFZWZlVA6VRCfPnY9Eyebo4KoDonHz2IJ2/YxqRrtjWs7j+fLqEx1+yL
	 5WQHf+IPmLz2nRIW+7fZxuLsLQt2y5XPjQjdSPmxKAlUj3j/JdoCWSy0RsSA9aLEXk+sM
	 yKh585GjCy5Q5XMo4YyEDtB11pgolIUEQIMe4cACVufr6qreyYPLBJ6c9ASJ49yO0xpHA
	 bQKyPwxFfzFAw0Z8wvffwpH3mWINFe0GH49D0kfnHdaktXh1QM45cPW8xkwMLFlzC2hzy
	 0e3TLrfRZhSqweDhoAuhPjQw6kV4F96qIifPDt7uJr7roKvT/XccGfhiLCZH7Fma7uQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0ZAV49sS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0CDE606A31C;
	Wed, 18 Nov 2026 20:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0ZAV49sS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14E511F000C4;
	Wed, 18 Nov 2026 20:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035054;
	bh=OmiExuQ+yHP1pvhJ3rP6G3YyHsDVJCzNsszh6mZ2TaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0ZAV49sSRjVpDOU4gG5XGoG/kYgzI3TaATv88cq1QqzW5b8Z/3goXqCOAAORcwA2f
	 yjoSejULXoxi7ULwwyxIgJSrSk8RCAqQycYB8NnGyBNptxbYKbtE7fsxHwt9VqmSp/
	 kHNZtSfqurK+05BCC5olJdPXl/1vhpF7OnVpFAP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Kim <james010kim@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexandre Bounine <alex.bou9@gmail.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Matt Porter <mporter@kernel.crashing.org>
Subject: [PATCH 6.6 0586/3318] rapidio: mport_cdev: fix use-after-free in mport_mm_close()
Date: Wed, 18 Nov 2026 15:20:08 +0100
Message-ID: <20261118150335.137501529@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Kim <james010kim@gmail.com>

commit 0f2cd84858e67cf8e02438bf28243bcdc67aa49a upstream.

A use-after-free vulnerability was identified in mport_mm_close() in
drivers/rapidio/devices/rio_mport_cdev.c, identical to the pattern
previously addressed in dma_req_free().

This is observable from userspace when an application creates an mmap
mapping via the RapidIO character device and subsequently unmaps it (or
terminates, triggering exit_mmap()).  During munmap, mport_mm_close() is
invoked and drops the mapping reference via kref_put().

If kref_put() drops the last reference, mport_release_mapping() is called,
which frees the underlying rio_mport_mapping structure.  The subsequent
mutex_unlock() then dereferences map->md to unlock buf_mutex, leading to a
use-after-free:

   mport_mm_close()
     -> mutex_lock(&map->md->buf_mutex);
     ...
     -> kref_put(&map->ref, mport_release_mapping); /* map is freed */
     -> mutex_unlock(&map->md->buf_mutex);          /* UAF: map used */

Fix this by caching map->md before kref_put() and using the cached pointer
for mutex unlocking, ensuring that freed memory is not accessed.

Link: https://lore.kernel.org/20260914042327.49798-1-james010kim@gmail.com
Fixes: e8de370188d0 ("rapidio: add mport char device driver")
Signed-off-by: James Kim <james010kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rapidio/devices/rio_mport_cdev.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/rapidio/devices/rio_mport_cdev.c
+++ b/drivers/rapidio/devices/rio_mport_cdev.c
@@ -2186,11 +2186,12 @@ static void mport_mm_open(struct vm_area
 static void mport_mm_close(struct vm_area_struct *vma)
 {
 	struct rio_mport_mapping *map = vma->vm_private_data;
+	struct mport_dev *md = map->md;
 
 	rmcd_debug(MMAP, "%pad", &map->phys_addr);
-	mutex_lock(&map->md->buf_mutex);
+	mutex_lock(&md->buf_mutex);
 	kref_put(&map->ref, mport_release_mapping);
-	mutex_unlock(&map->md->buf_mutex);
+	mutex_unlock(&md->buf_mutex);
 }
 
 static const struct vm_operations_struct vm_ops = {



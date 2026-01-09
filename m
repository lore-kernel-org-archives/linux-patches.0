Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CBC635A92D;
	Fri,  9 Jan 2026 12:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960599; cv=none; b=edf4ih1B/3CT9JDMF9iMOfCBrSJbKBtNV6Hgc/etmY2CSouarI8djOI1iXiMnmdllM0qzn5NnIzq8C0hPLT05ppFwMjBVhZD/kBcBkn9uY+OSL4qQLCcXkc8grQWYxBHBnAhMMS43V2/25kD9yLIYsD6wgub/T8sXYJJId3rrgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960599; c=relaxed/simple;
	bh=cAs7nxBo0hPgInYYM7t9LZhw7SlRrtJnIXownP4hi/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JAl3Q9n/6Fp7ec3hGIylOoGVMav+U1P36P1gUPJpWWu6O9BJhiwlu3+nnSq5d/HNrMFyAqfdVKbyN5MtzXQC3YxnAJ9tJ5dwbadr6Wc32dcv/GSyA8jhIsa1FYLRUzb8BvwVdPcyYhsxtDuBMm54p+QK5vk57iPDJS9zdh8wy6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j9jqCall; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j9jqCall"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43608C4CEF1;
	Fri,  9 Jan 2026 12:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960598;
	bh=cAs7nxBo0hPgInYYM7t9LZhw7SlRrtJnIXownP4hi/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j9jqCallm+dgvNJHvtMLhfXG1e8Ru1PvkCiAxuXdVJuZBCq3cfuGtPAmaxMzrNnrr
	 aDoNn7QXfqh2g4U3pqEwq/gG/3DD0VtX6n2iWmqu4uCCOrOXcafuJHqj19MJSdHKjU
	 orMr+2uTqhHrRSz8Gds29Xel6kx0IqOQ8Bsdvp1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 428/737] media: v4l2-mem2mem: Fix outdated documentation
Date: Fri,  9 Jan 2026 12:39:27 +0100
Message-ID: <20260109112150.096543420@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

commit 082b86919b7a94de01d849021b4da820a6cb89dc upstream.

Commit cbd9463da1b1 ("media: v4l2-mem2mem: Avoid calling .device_run in
v4l2_m2m_job_finish") deferred calls to .device_run() to a work queue to
avoid recursive calls when a job is finished right away from
.device_run(). It failed to update the v4l2_m2m_job_finish()
documentation that still states the function must not be called from
.device_run(). Fix it.

Fixes: cbd9463da1b1 ("media: v4l2-mem2mem: Avoid calling .device_run in v4l2_m2m_job_finish")
Cc: stable@vger.kernel.org
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/media/v4l2-mem2mem.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/include/media/v4l2-mem2mem.h
+++ b/include/media/v4l2-mem2mem.h
@@ -185,8 +185,7 @@ void v4l2_m2m_try_schedule(struct v4l2_m
  * other instances to take control of the device.
  *
  * This function has to be called only after &v4l2_m2m_ops->device_run
- * callback has been called on the driver. To prevent recursion, it should
- * not be called directly from the &v4l2_m2m_ops->device_run callback though.
+ * callback has been called on the driver.
  */
 void v4l2_m2m_job_finish(struct v4l2_m2m_dev *m2m_dev,
 			 struct v4l2_m2m_ctx *m2m_ctx);



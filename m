Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A756133C53A;
	Fri,  9 Jan 2026 12:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962344; cv=none; b=QACP6SqC0icXPapkr4XwAbaDu7KZDKE8tmDCUjtMGeKGoYUTdtVCsy7BKHViNbgybNQlBLG2mRMCxI7n4EU1IfQcy71il0BY9RwILPvumRHltZfexZ1K6YHC9hqR/rA77q0C6WwsLmgbLSG2aZWgjHm6bcQPuVCW8kQUu9K2Wyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962344; c=relaxed/simple;
	bh=mx9yDoWBi5L1i/CvSw8jiXzn5yAhGWolkP70/9zdEDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=opGGUAl0C3mLM4Rw/zjJ9BQlkviT9yAPfUZmpKBrdDsmqN2Ri0VNsob34dq/4qfFO2l1US//CDj3GcvIAFPS1uoJ0AKKCNxgTTHHpMvA+CG4bflQSiFZsggzz6l6BJXxmjjuPAfpTW9OIhbDphmVy6Eoo1BET9/bEL2o6PHjcUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EmemeV7j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EmemeV7j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 329E9C4CEF1;
	Fri,  9 Jan 2026 12:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962344;
	bh=mx9yDoWBi5L1i/CvSw8jiXzn5yAhGWolkP70/9zdEDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EmemeV7jgqM7zIXqx0n5bj4JT7HAI8w/qW12wNVdGmllbaqVIYMHH9UentSnvlf9Z
	 XOyslwPXjRAINqiWSv3DHOwNm2b/RILdRdyL+BEShQF7tOoPrnJQZsjTXRQ3agnHH9
	 11eyVRCPKAhNWHtrRD5pc0Os/TYP8fYkdJqEvCwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.1 332/634] media: v4l2-mem2mem: Fix outdated documentation
Date: Fri,  9 Jan 2026 12:40:10 +0100
Message-ID: <20260109112130.018679476@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



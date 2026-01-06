Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFEF93557ED;
	Tue,  6 Jan 2026 17:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720322; cv=none; b=XgM66e7DsDWDRSpXrxo9upPm7DE3ykYH+cUgyOd/vQrayXBTMYDO7x41WCHNNvRs5YOSWKRRp95PB0oUv+fodLKuzkc9eTTYFULxnihtZMAPEP9Mv+xJ0NcoyEsZwWTCHY3lkvJTlHBwhb3Y5mioRKc4O3XlHDUIkLH1ItWVetg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720322; c=relaxed/simple;
	bh=harV5kGS4w9Keo1Pf/q01Kw1k7V0WSkXgFmz4vOdgDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f6ODodbECvkPtPwR0m60fShb48ci0N/MRDE+r2wuSKfc2WxPaPIgMFw7pTW/1nE0tgiI/s0xyhQyOUC/5TJZBhsZ9KvLOuS9PUJpbN/cVAl9U/dw3vs+EIJIskib9kPUTO1AqZlNYrpbVSTTitGUPw4q0ur71krmSexTGHc9C+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tJiI9LaG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tJiI9LaG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75439C116C6;
	Tue,  6 Jan 2026 17:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720321;
	bh=harV5kGS4w9Keo1Pf/q01Kw1k7V0WSkXgFmz4vOdgDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tJiI9LaGJa2IBKSDEaaGQTpQlc1yhL8UUdhyvw74I6JFuKZE6zvhVtFM1VMIR/Iyx
	 dr6Jc9eGzgTS5Vs72qbwzr5cbzKthdAZb8CR02+EtUS4yX1Z18wC5Jynk3D3tpu2Dd
	 FJsruiThAyvEEFnkBfq5qfb7HrLRkdOCZalR6+mA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 174/567] media: v4l2-mem2mem: Fix outdated documentation
Date: Tue,  6 Jan 2026 17:59:16 +0100
Message-ID: <20260106170457.763210856@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -192,8 +192,7 @@ void v4l2_m2m_try_schedule(struct v4l2_m
  * other instances to take control of the device.
  *
  * This function has to be called only after &v4l2_m2m_ops->device_run
- * callback has been called on the driver. To prevent recursion, it should
- * not be called directly from the &v4l2_m2m_ops->device_run callback though.
+ * callback has been called on the driver.
  */
 void v4l2_m2m_job_finish(struct v4l2_m2m_dev *m2m_dev,
 			 struct v4l2_m2m_ctx *m2m_ctx);



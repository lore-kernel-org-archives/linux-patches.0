Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CAB13C1977;
	Thu, 15 Jan 2026 17:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499445; cv=none; b=FqcHC6havaIX8ZDzT3mLiXYzDDyHXMvXvSAqOixO2bcOAHOwzLL29olZSp6ZFQreTeJqi7PFwQnWfzoTi8cIpRDvMdUyT7UBpLMSdfonZ4rMzqMRQjXL8OE3ELJd5TdajZ3T/cyzC0WW6x6Dj/SOMumhTkQIe9nONxKmjvyR0VU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499445; c=relaxed/simple;
	bh=uvePmVDHoFEXJ0VTqmNTQ3T8o3WStO3aspgY8U/HaS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GRucXJBqvVZ99K7YbAHGBPQXvYxFWgecv+78ERAwRcifjys1u/0h96jx4y3ofO7uozJidNJ2PoyiY66MqvB6DVDCLFeeebdRQwiX6XNVWs+9DE2Dv3tgPVJYIaECErVaKxPlZgxaNpjsvCY6kzAqpG42c8YwvhUjBnT8BXV8u4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LZrK5wMN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LZrK5wMN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B96C2C19422;
	Thu, 15 Jan 2026 17:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499445;
	bh=uvePmVDHoFEXJ0VTqmNTQ3T8o3WStO3aspgY8U/HaS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LZrK5wMNkhRVT3FyxYaNwAHR6fNic88P6ep2XhrRS2L2Zb8gYhGRFePqEkeTGgqRQ
	 BbhZVmmw46DVuvVH72xwUJMWaUUW3oMxmehoeNZ6KS5769KSOgi3OzsqqQt1Ck6QlH
	 o4+2E4nK9JOgzSqWoDJd0LHQSSfByMuPgqDNqchY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.10 228/451] media: v4l2-mem2mem: Fix outdated documentation
Date: Thu, 15 Jan 2026 17:47:09 +0100
Message-ID: <20260115164239.143709104@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



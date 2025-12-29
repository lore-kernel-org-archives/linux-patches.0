Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED7C83A1E66;
	Mon, 29 Dec 2025 16:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025600; cv=none; b=R5RN2P3J14/9+9/hQw+hzIkWbVmQChPVJsPuWi1N6/V9lyb07vJJdrU3dRtSJHggBO5oxA4YrmRbMJmYG/j/YjzFYfudNoZGgY3Hl/uRAz0pA1SpYgpqd0CBNcH8RN5moSNnhMSS0Z8uBWfi4j90VhaP5hIsjwOSa+PnhslTH6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025600; c=relaxed/simple;
	bh=YED8VIe6xSJEX1Kcq3hjDjVTexP3y0OissK+++5TJtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RNORZAOqYtvTFjvaVTvEjRTCCPxStaJ5LlI1B6d2tT9+Z0YATTIaM6+zB0P+rs8xnGeVFotmt2R5gcJ5LqhWrjcGWWmBsVijLHnhc4pj6qJESz671enwW7vVaKKO4wXt8WZrEZ/RsHPxfRJc3mkv7xlZzbCbTmXIWauY5DgWY6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=acAUVrYV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="acAUVrYV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E917C4CEF7;
	Mon, 29 Dec 2025 16:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025599;
	bh=YED8VIe6xSJEX1Kcq3hjDjVTexP3y0OissK+++5TJtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=acAUVrYV3dCkHcaMfUN9BG7Jo0TDotkibjBmAP6Kn/fCsxZQCZup9Pff3W12sQ2K9
	 tJC+z+8+7MNFzdz7Y3ilyYfzuqBsmeIcrvVIGvP4xqbc7JNW5HLR1ezmqJj50ssHh2
	 mvaxA5Ezu/4GPrhckDd9Im0dkvqm5gBFyDVl2yMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 269/430] media: v4l2-mem2mem: Fix outdated documentation
Date: Mon, 29 Dec 2025 17:11:11 +0100
Message-ID: <20251229160734.250179207@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



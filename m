Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 233683C008E;
	Thu, 15 Jan 2026 17:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498027; cv=none; b=QiglLoAEGbQHTPb4BK8i2VWSnPgnBnzJyHJhfZ8iXsWsfesxrLNBAYLDuHCus1G/1zXl7B0NU4B+nhNyiBvczIH+EY7o2B6GWOiultMkEv5TdLmk3edNsU6wKOsYx/fNUIrd0S8HB+dZMbwyoP9Ezfy4gA4j5XiR8R0nS6gmjmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498027; c=relaxed/simple;
	bh=h3ZVyySazTKFlfUqisdUKxhZes3hzsckwqIpomhVfIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IqGJhPnxY3XV5yvJltvjM0FLqyEXA4hlWaHUQQW8tCRy6mvR7NA7qAVH2411verkpeXuGzZLwrvH5FlmD8ha1CBmxGtbutIgrNEB85ty1/9kLS4mvIsOjV1wFEDDNaDC8yiHJ2H2q0Kiv1N2lZJn/Uz3zgyOmGlRjBY0/eOb5JU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aCUC8VSl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aCUC8VSl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A16B9C19423;
	Thu, 15 Jan 2026 17:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498027;
	bh=h3ZVyySazTKFlfUqisdUKxhZes3hzsckwqIpomhVfIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aCUC8VSlRM28b8oSLpZMdrRYgiflVUdgTUz5HHZaMbn1NqHidRsmRrwXpqG7e+ln7
	 m2jlheAmuHzWoxNJPKE7hdmxseteovwMT2uNbeaihq8P+L3pla1t9aij4vQYEQsI7F
	 +hARPWZQ3Qa/oqKPsfk9foU3KXla2OD1tyqQQF3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.15 288/554] media: v4l2-mem2mem: Fix outdated documentation
Date: Thu, 15 Jan 2026 17:45:54 +0100
Message-ID: <20260115164256.653126370@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8258B1581F6;
	Tue, 18 Jun 2024 13:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716032; cv=none; b=uQdbbxTdylBjf5CSmpc61PLSA6PlrSTq2VrMmsQ8XCEyVHcU1V0S8LB381PY9pclcT/QDtIOkOFjKaeQ1KB/IcJAJTc2MpINce7U15/6JcbYEyxSuu6oKWTk20hfY1PPAnVFaqxFthkZQmVrhdvRKGNRV/5bd9EbhmPVEK4phRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716032; c=relaxed/simple;
	bh=LURaLRecJvAknXdCMY0sPWHeLYCF3coFm+oJg4aIfOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tm//jxqmeg2iK+7mZz7tQNSCuMI41pL8VKP0uFnwM4ax4r5I7wBgahj/FXUGja4vU5duWNS5oD2VZWl2fJzMOFpZb1r4tIuVbGxuK+sJow3ldpLCa/BsY7PE9cgr5cEpHRL9oACcN1/CfYRgshpaP64bj2E9qlv8FbHOcw0Pe2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NBW2Vhns; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NBW2Vhns"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07D40C3277B;
	Tue, 18 Jun 2024 13:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716032;
	bh=LURaLRecJvAknXdCMY0sPWHeLYCF3coFm+oJg4aIfOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NBW2Vhns21+/7ZwuaBTDvUJBL/rtDDzi7E773Tf1sYiBa93cvyLNrTw5nqDMHJgiO
	 BJsMFfUSiVtlD1bVFQlYldOMu7Q76s+s6SWltBT+PAdZSP/V7a58onnnIeGaxWSxZo
	 hzYMgdzCkoIbSAHcBUwXyOqOqx1GBqJmkj62fIDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasily Averin <vvs@openvz.org>,
	"Christian Brauner (Microsoft)" <brauner@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Jan Kara <jack@suse.cz>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 508/770] fanotify: fix incorrect fmode_t casts
Date: Tue, 18 Jun 2024 14:36:01 +0200
Message-ID: <20240618123426.921495908@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Vasily Averin <vvs@openvz.org>

[ Upstream commit dccd855771b37820b6d976a99729c88259549f85 ]

Fixes sparce warnings:
fs/notify/fanotify/fanotify_user.c:267:63: sparse:
 warning: restricted fmode_t degrades to integer
fs/notify/fanotify/fanotify_user.c:1351:28: sparse:
 warning: restricted fmode_t degrades to integer

FMODE_NONTIFY have bitwise fmode_t type and requires __force attribute
for any casts.

Signed-off-by: Vasily Averin <vvs@openvz.org>
Reviewed-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/9adfd6ac-1b89-791e-796b-49ada3293985@openvz.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/fanotify/fanotify_user.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 3a1325c90ff86..f4a5e9074dd42 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -252,7 +252,7 @@ static int create_fd(struct fsnotify_group *group, struct path *path,
 	 * originally opened O_WRONLY.
 	 */
 	new_file = dentry_open(path,
-			       group->fanotify_data.f_flags | FMODE_NONOTIFY,
+			       group->fanotify_data.f_flags | __FMODE_NONOTIFY,
 			       current_cred());
 	if (IS_ERR(new_file)) {
 		/*
@@ -1365,7 +1365,7 @@ SYSCALL_DEFINE2(fanotify_init, unsigned int, flags, unsigned int, event_f_flags)
 	    (!(fid_mode & FAN_REPORT_NAME) || !(fid_mode & FAN_REPORT_FID)))
 		return -EINVAL;
 
-	f_flags = O_RDWR | FMODE_NONOTIFY;
+	f_flags = O_RDWR | __FMODE_NONOTIFY;
 	if (flags & FAN_CLOEXEC)
 		f_flags |= O_CLOEXEC;
 	if (flags & FAN_NONBLOCK)
-- 
2.43.0




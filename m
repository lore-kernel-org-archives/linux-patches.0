Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4268D12CDB5;
	Tue, 18 Jun 2024 13:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715695; cv=none; b=o+BmfwaM/8k/bY/ulHisRnJ++UbLHelkJF+yFWOa0baZOI7OZrlirb+8VXxfA4kZ72W25OU+tIQkvrCVwRv0crpZxThPthVUjz86GELItmBAIUnX3YK1wJ3fboQ+0+p4E0I7n0TycK3Xq+uxg3sXQL7XiD6GIgpWIKtFW5yQj+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715695; c=relaxed/simple;
	bh=5KE/g3eEDsVtWKG5gVsAyLKogss9AR0qyJcMxae+brY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f5KFIslhVZKr9kxJn1TLyXxfTKBDfrQSMh/pzkLKATrn6t3xN9rdScDQm8KRw3rXbKeKeM1zEOdecP/OndLU3/u7sCIzrTHq9UeZQbWBM6gydxjJpFE4ViKufygpM4jjBVPblYvWxA37ion593cI2ploh4Ynrlij6KSiSBcfEzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=186rxamG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="186rxamG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBBF0C3277B;
	Tue, 18 Jun 2024 13:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715695;
	bh=5KE/g3eEDsVtWKG5gVsAyLKogss9AR0qyJcMxae+brY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=186rxamGHC7ghL7g9ag8VE4AxvQSkmmTVFSCYepVj+ltf8zl7n/XipnmRo6B8OfAt
	 5AR/fFdkVri0Yy8yPSWEsgLyUjoJOsjH1qpMy0A10iMh2qdvJwsUn0MEPmz0tVgAcT
	 iytnS2vYe7+lXGlvlqi7WMQDEkifHsQzulK7KOaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Amir Goldstein <amir73il@gmail.com>,
	Gabriel Krisman Bertazi <krisman@collabora.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 378/770] fanotify: Reserve UAPI bits for FAN_FS_ERROR
Date: Tue, 18 Jun 2024 14:33:51 +0200
Message-ID: <20240618123421.865175985@linuxfoundation.org>
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

From: Gabriel Krisman Bertazi <krisman@collabora.com>

[ Upstream commit 8d11a4f43ef4679be0908026907a7613b33d7127 ]

FAN_FS_ERROR allows reporting of event type FS_ERROR to userspace, which
is a mechanism to report file system wide problems via fanotify.  This
commit preallocate userspace visible bits to match the FS_ERROR event.

Link: https://lore.kernel.org/r/20211025192746.66445-19-krisman@collabora.com
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/fanotify/fanotify.c | 1 +
 include/uapi/linux/fanotify.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index c64d61b673caf..8f152445d75c4 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -752,6 +752,7 @@ static int fanotify_handle_event(struct fsnotify_group *group, u32 mask,
 	BUILD_BUG_ON(FAN_ONDIR != FS_ISDIR);
 	BUILD_BUG_ON(FAN_OPEN_EXEC != FS_OPEN_EXEC);
 	BUILD_BUG_ON(FAN_OPEN_EXEC_PERM != FS_OPEN_EXEC_PERM);
+	BUILD_BUG_ON(FAN_FS_ERROR != FS_ERROR);
 
 	BUILD_BUG_ON(HWEIGHT32(ALL_FANOTIFY_EVENT_BITS) != 19);
 
diff --git a/include/uapi/linux/fanotify.h b/include/uapi/linux/fanotify.h
index 64553df9d7350..2990731ddc8bc 100644
--- a/include/uapi/linux/fanotify.h
+++ b/include/uapi/linux/fanotify.h
@@ -20,6 +20,7 @@
 #define FAN_OPEN_EXEC		0x00001000	/* File was opened for exec */
 
 #define FAN_Q_OVERFLOW		0x00004000	/* Event queued overflowed */
+#define FAN_FS_ERROR		0x00008000	/* Filesystem error */
 
 #define FAN_OPEN_PERM		0x00010000	/* File open in perm check */
 #define FAN_ACCESS_PERM		0x00020000	/* File accessed in perm check */
-- 
2.43.0




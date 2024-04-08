Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66A87EF1F;
	Mon,  8 Apr 2024 13:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582877; cv=none; b=dYBGrCCnR9ZPcq/mkENHUdZ0b09g1woKsXWFmGG1YOBu88Nok8uQwoOens5C5yNxJ5i2gyPk1tsUJPRv5hcb74jRIbbWy1cM3pdkXFawVRrxQH0T8gU1ideGdSuf0iTwSz4naHZyHjJLTRiFmiJe1KbO1FDZH1IxwXY+6Ov1v3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582877; c=relaxed/simple;
	bh=yTW9TYN1myipqZLPVNlPz1PyqDJ7UVUlzc58sNMgU9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=akJfjZPWF+N7L780w3AuSVuiTdv0hBhTb2Rf1Vzvi+BWeT9CNkN4smCPmNIihJKTxgV74Lpb9w78iO5boBHXfunvbEckpb8pjBhLIypXBui40J6hb7o0FOXSuV8A4mDqac+tbM64eZ0cJmYF0AqcLJrJA71OKcayh4gryGU6c9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rcl8dQ1k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rcl8dQ1k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D14CC433C7;
	Mon,  8 Apr 2024 13:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582877;
	bh=yTW9TYN1myipqZLPVNlPz1PyqDJ7UVUlzc58sNMgU9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rcl8dQ1kBkfPFEN1ZBtxLf2iBeQv+huIiRqSEo7E0Bf4+BaInABZmoFU2AjSqlQth
	 nk4ZMg5zSUDNLrI7oP2UcZo+bWF5xsuQ+bgxXUsx11NoHMxCxpgGgHCGQ0Cel5Mbkl
	 LH0E14D1atbP7YHcdvCt0c3x5Eng2+UVD3u/uCf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Amir Goldstein <amir73il@gmail.com>,
	Gabriel Krisman Bertazi <krisman@collabora.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 183/690] fanotify: Reserve UAPI bits for FAN_FS_ERROR
Date: Mon,  8 Apr 2024 14:50:49 +0200
Message-ID: <20240408125406.183930783@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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




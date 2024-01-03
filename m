Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB9A81C695;
	Wed,  3 Jan 2024 16:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2ZMeUuCy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B22C4C433C9;
	Wed,  3 Jan 2024 16:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301065;
	bh=RcGEdjHRSakFuysbIqnZbD4z3zSHdXSH148+MbE5R7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2ZMeUuCy7zYdDjFlfSmoQZk2O80GuKnCCYijhHu3TA0dU8lG6+MpkWSHa3HW6J3S0
	 4KUcJVDrasdIQ9bk/oy3P403vJdr+bDg2gOlNJesx4XjlEKUB4zDNhclYwTuSW0PeT
	 +O1EAQitRhQteagcP4DUKAn45DLDXTgeMoyQUOEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abaci Robot <abaci@linux.alibaba.com>,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 011/100] ksmbd: Fix parameter name and comment mismatch
Date: Wed,  3 Jan 2024 17:54:00 +0100
Message-ID: <20240103164857.846604696@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164856.169912722@linuxfoundation.org>
References: <20240103164856.169912722@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

[ Upstream commit 63f09a9986eb58578ed6ad0e27a6e2c54e49f797 ]

fs/ksmbd/vfs.c:965: warning: Function parameter or member 'attr_value' not described in 'ksmbd_vfs_setxattr'.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=3946
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/vfs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 36914db8b6616..187d31d984946 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -951,9 +951,9 @@ ssize_t ksmbd_vfs_getxattr(struct user_namespace *user_ns,
  * ksmbd_vfs_setxattr() - vfs helper for smb set extended attributes value
  * @user_ns:	user namespace
  * @dentry:	dentry to set XATTR at
- * @name:	xattr name for setxattr
- * @value:	xattr value to set
- * @size:	size of xattr value
+ * @attr_name:	xattr name for setxattr
+ * @attr_value:	xattr value to set
+ * @attr_size:	size of xattr value
  * @flags:	destination buffer length
  *
  * Return:	0 on success, otherwise error
-- 
2.43.0




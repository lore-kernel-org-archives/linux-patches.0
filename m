Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B1B648793;
	Wed, 20 Dec 2023 16:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WdbCEajm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D48FCC433C7;
	Wed, 20 Dec 2023 16:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088834;
	bh=YO9HrUhf86LGoIrt1X/Xb6A/UaRpddLlqF4Zn+IzGTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WdbCEajmxQW0f+8jwvxv+H85S22U5KxBzGCkRThXWNBo+tbseM8HpLCLupfoXbyKt
	 F9AbIa/nVQ4I+rNutu4pJ8zcH9BzdVFK72Tln+oJDffiE347nBa5FqA0heaWjg7djU
	 o3rqcEOG2D6CqaoChg/anY91OrzEVt1rTEy/tfdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abaci Robot <abaci@linux.alibaba.com>,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 076/159] ksmbd: Fix parameter name and comment mismatch
Date: Wed, 20 Dec 2023 17:09:01 +0100
Message-ID: <20231220160934.914919998@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231220160931.251686445@linuxfoundation.org>
References: <20231220160931.251686445@linuxfoundation.org>
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

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

[ Upstream commit 63f09a9986eb58578ed6ad0e27a6e2c54e49f797 ]

fs/ksmbd/vfs.c:965: warning: Function parameter or member 'attr_value' not described in 'ksmbd_vfs_setxattr'.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=3946
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/vfs.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/ksmbd/vfs.c
+++ b/fs/ksmbd/vfs.c
@@ -950,9 +950,9 @@ ssize_t ksmbd_vfs_getxattr(struct user_n
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



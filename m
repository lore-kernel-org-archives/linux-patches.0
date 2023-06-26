Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7FB8134CE
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:24:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56606C433C9;
	Mon, 26 Jun 2023 18:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687803844;
	bh=neA9qgU3dCAsv5QE8daUZ122pqBqvw9cm8lilPq1gEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UuUA6Xe7sdgQmsoTLkDexaGBvFwgv1qhyOCt1Yev3OhkFrMuPO741STlX25u6xNgf
	 Oz2s8KSlIvGoc7fqTasPbGX8v4TD26J9OkZSN8UoVxcwJN9KxMNrcgG0QZX3WZmJUy
	 5nG76RaWdD8fSNx/hMstKrGvP8RaQ98wQP5Qo4I0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Coverity Scan <scan-admin@coverity.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.3 197/199] ksmbd: fix uninitialized pointer read in ksmbd_vfs_rename()
Date: Mon, 26 Jun 2023 20:11:43 +0200
Message-ID: <20230626180814.377177329@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180805.643662628@linuxfoundation.org>
References: <20230626180805.643662628@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Namjae Jeon <linkinjeon@kernel.org>

commit 48b47f0caaa8a9f05ed803cb4f335fa3a7bfc622 upstream.

Uninitialized rd.delegated_inode can be used in vfs_rename().
Fix this by setting rd.delegated_inode to NULL to avoid the uninitialized
read.

Fixes: 74d7970febf7 ("ksmbd: fix racy issue from using ->d_parent and ->d_name")
Reported-by: Coverity Scan <scan-admin@coverity.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/vfs.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ksmbd/vfs.c
+++ b/fs/ksmbd/vfs.c
@@ -769,6 +769,7 @@ retry:
 	rd.new_dir		= new_path.dentry->d_inode,
 	rd.new_dentry		= new_dentry,
 	rd.flags		= flags,
+	rd.delegated_inode	= NULL,
 	err = vfs_rename(&rd);
 	if (err)
 		ksmbd_debug(VFS, "vfs_rename failed err %d\n", err);



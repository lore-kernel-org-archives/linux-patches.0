Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53724CB33;
	Wed, 20 Dec 2023 16:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qrpNdoz8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26601C433C7;
	Wed, 20 Dec 2023 16:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088760;
	bh=upoeHXJte9eihdoAhxjXLJCvuffzoOxLXfXGCZPAkAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qrpNdoz8Ee/rbvKDSP1kayXStls1QF8rcf+3eEMTzajx5CXvAy2zDNdPWIAx4qAYI
	 Ju6JofRSkiKvDlT37P3U5LcxJkSfv31adgl7uWyvhZ/qwPyYSqxKAcpr6+MOePSiNM
	 rdKWwj4HMfIMlQDFAyJo7bUOnKw8pA9yMVfCCS3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 048/159] ksmbd: dont open-code file_path()
Date: Wed, 20 Dec 2023 17:08:33 +0100
Message-ID: <20231220160933.556877405@linuxfoundation.org>
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

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 2f5930c1d7936b74eb820c5b157011994c707a74 ]

Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -5449,7 +5449,7 @@ static int smb2_rename(struct ksmbd_work
 	if (!pathname)
 		return -ENOMEM;
 
-	abs_oldname = d_path(&fp->filp->f_path, pathname, PATH_MAX);
+	abs_oldname = file_path(fp->filp, pathname, PATH_MAX);
 	if (IS_ERR(abs_oldname)) {
 		rc = -EINVAL;
 		goto out;
@@ -5584,7 +5584,7 @@ static int smb2_create_link(struct ksmbd
 	}
 
 	ksmbd_debug(SMB, "link name is %s\n", link_name);
-	target_name = d_path(&filp->f_path, pathname, PATH_MAX);
+	target_name = file_path(filp, pathname, PATH_MAX);
 	if (IS_ERR(target_name)) {
 		rc = -EINVAL;
 		goto out;



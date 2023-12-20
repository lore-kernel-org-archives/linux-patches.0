Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64CF449F7F;
	Wed, 20 Dec 2023 16:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QyZ9H1TC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA7E6C433C7;
	Wed, 20 Dec 2023 16:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088719;
	bh=Fjc1u5SCEWLnhAoKOfiYFOmPGvaLRfhAV4e04GE8FMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QyZ9H1TC6GZxgR9gtxl+WbtQOio0jPyM+f6XaU+tRO6WB9CoSBRr1YBTnHmFKwluy
	 5QikuOn5dhItRmaILF378kzMZi2BCS44S0I+/Bt5qRZvwuwEBunDj1j1iGlKigYBAb
	 6laY5XiFCuMLRQHAFK1wtn5fTWJtLD0Tbo8wiZ4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Marios Makassikis <mmakassikis@freebox.fr>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 009/159] ksmbd: Remove unused parameter from smb2_get_name()
Date: Wed, 20 Dec 2023 17:07:54 +0100
Message-ID: <20231220160931.724336802@linuxfoundation.org>
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

From: Marios Makassikis <mmakassikis@freebox.fr>

[ Upstream commit 80917f17e3f99027661a45262c310139e53a9faa ]

The 'share' parameter is no longer used by smb2_get_name() since
commit 265fd1991c1d ("ksmbd: use LOOKUP_BENEATH to prevent the out of
share access").

Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -651,7 +651,6 @@ static void destroy_previous_session(str
 
 /**
  * smb2_get_name() - get filename string from on the wire smb format
- * @share:	ksmbd_share_config pointer
  * @src:	source buffer
  * @maxlen:	maxlen of source string
  * @nls_table:	nls_table pointer
@@ -659,8 +658,7 @@ static void destroy_previous_session(str
  * Return:      matching converted filename on success, otherwise error ptr
  */
 static char *
-smb2_get_name(struct ksmbd_share_config *share, const char *src,
-	      const int maxlen, struct nls_table *local_nls)
+smb2_get_name(const char *src, const int maxlen, struct nls_table *local_nls)
 {
 	char *name;
 
@@ -2604,8 +2602,7 @@ int smb2_open(struct ksmbd_work *work)
 			goto err_out1;
 		}
 
-		name = smb2_get_name(share,
-				     req->Buffer,
+		name = smb2_get_name(req->Buffer,
 				     le16_to_cpu(req->NameLength),
 				     work->conn->local_nls);
 		if (IS_ERR(name)) {
@@ -5481,8 +5478,7 @@ static int smb2_rename(struct ksmbd_work
 		goto out;
 	}
 
-	new_name = smb2_get_name(share,
-				 file_info->FileName,
+	new_name = smb2_get_name(file_info->FileName,
 				 le32_to_cpu(file_info->FileNameLength),
 				 local_nls);
 	if (IS_ERR(new_name)) {
@@ -5593,8 +5589,7 @@ static int smb2_create_link(struct ksmbd
 	if (!pathname)
 		return -ENOMEM;
 
-	link_name = smb2_get_name(share,
-				  file_info->FileName,
+	link_name = smb2_get_name(file_info->FileName,
 				  le32_to_cpu(file_info->FileNameLength),
 				  local_nls);
 	if (IS_ERR(link_name) || S_ISDIR(file_inode(filp)->i_mode)) {



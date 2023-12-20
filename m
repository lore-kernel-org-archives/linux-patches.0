Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DFCD4779E;
	Wed, 20 Dec 2023 16:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gqDVyPL4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EA9DC433C8;
	Wed, 20 Dec 2023 16:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088680;
	bh=+DkKvCNQJHO7rnPAw/fX1Y19Ls+76yajsYDyIrzaBWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gqDVyPL4XVjqT/NcrL7MSR2qADAg4fBMerrlhlKWieiys3y+7UA9NupyyHGcax+IF
	 FUpzFIXljDZw0ksLP3NRPbvKPxMtTryM41XutWD1vFaF0FMd+ehJKFx/4Q8DvQlsxO
	 dZeWc+sSA3BOoTxNPqNE6r7gi0g0l2+wc8zs+tDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Talpey <tom@talpey.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Steve French <smfrench@gmail.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ralph Boehme <slow@samba.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 002/159] ksmdb: use cmd helper variable in smb2_get_ksmbd_tcon()
Date: Wed, 20 Dec 2023 17:07:47 +0100
Message-ID: <20231220160931.371814185@linuxfoundation.org>
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

From: Ralph Boehme <slow@samba.org>

[ Upstream commit 341b16014bf871115f0883e831372c4b76389d03 ]

Use cmd helper variable in smb2_get_ksmbd_tcon().

Cc: Tom Talpey <tom@talpey.com>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Steve French <smfrench@gmail.com>
Cc: Hyunchul Lee <hyc.lee@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Ralph Boehme <slow@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -95,11 +95,12 @@ struct channel *lookup_chann_list(struct
 int smb2_get_ksmbd_tcon(struct ksmbd_work *work)
 {
 	struct smb2_hdr *req_hdr = work->request_buf;
+	unsigned int cmd = le16_to_cpu(req_hdr->Command);
 	int tree_id;
 
-	if (work->conn->ops->get_cmd_val(work) == SMB2_TREE_CONNECT_HE ||
-	    work->conn->ops->get_cmd_val(work) ==  SMB2_CANCEL_HE ||
-	    work->conn->ops->get_cmd_val(work) ==  SMB2_LOGOFF_HE) {
+	if (cmd == SMB2_TREE_CONNECT_HE ||
+	    cmd ==  SMB2_CANCEL_HE ||
+	    cmd ==  SMB2_LOGOFF_HE) {
 		ksmbd_debug(SMB, "skip to check tree connect request\n");
 		return 0;
 	}



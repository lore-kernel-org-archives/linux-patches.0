Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 508BD47A5F;
	Wed, 20 Dec 2023 16:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YRWdvrW7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5395DC433C8;
	Wed, 20 Dec 2023 16:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088650;
	bh=OzpPYPzK8iwTxzzGb9DKaoXmGXt8+8TeO+uspEErZEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YRWdvrW7toxshzZxOq998aDd3YWKgb6jP5a2lQWjLjslsBrjfyqZ5Ltoc6HXT3zWO
	 fe883WzMuOUJ7WGANJfBFkGbMfATtEItT6DjhA/Jtl9ze6xLqAdnuSkotnosH1eK6v
	 19HdaSw9W2WJ/J+rmCtnU6yg4aR6RXv+z8DdSKkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ralph Boehme <slow@samba.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 001/159] ksmbd: use ksmbd_req_buf_next() in ksmbd_verify_smb_message()
Date: Wed, 20 Dec 2023 17:07:46 +0100
Message-ID: <20231220160931.324891314@linuxfoundation.org>
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

[ Upstream commit a088ac859f8124d491f02a19d080fc5ee4dbd202 ]

Use ksmbd_req_buf_next() in ksmbd_verify_smb_message().

Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Ralph Boehme <slow@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb_common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ksmbd/smb_common.c
+++ b/fs/ksmbd/smb_common.c
@@ -134,7 +134,7 @@ int ksmbd_lookup_protocol_idx(char *str)
  */
 int ksmbd_verify_smb_message(struct ksmbd_work *work)
 {
-	struct smb2_hdr *smb2_hdr = work->request_buf + work->next_smb2_rcv_hdr_off;
+	struct smb2_hdr *smb2_hdr = ksmbd_req_buf_next(work);
 	struct smb_hdr *hdr;
 
 	if (smb2_hdr->ProtocolId == SMB2_PROTO_NUMBER)



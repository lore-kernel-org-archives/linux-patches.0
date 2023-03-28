Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B80C8BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 15:11:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFA42C433EF;
	Tue, 28 Mar 2023 15:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680016268;
	bh=kP0JPS1zXctdmj4tVw8dOyRRnk64nFa4YDV6BCCsZPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Om4BTATI5pfxww1aVLIeWu0zurD+Jiqc4EKm9nlLAAEf4w4ShJTP+L96X4fMIjf7j
	 6dmC0B4digf3NsnwPWpDsZ52wZGjc+EEJRqPFz2OWF1HFSBafZ4GIoO4YmSDQB5cam
	 5lprrLpRyUwj3qy5/gT3FdsE7n2ksjOTkuoPV7Q0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve French <stfrench@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 5.15 125/146] ksmbd: return STATUS_NOT_SUPPORTED on unsupported smb2.0 dialect
Date: Tue, 28 Mar 2023 16:43:34 +0200
Message-Id: <20230328142607.864109288@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142602.660084725@linuxfoundation.org>
References: <20230328142602.660084725@linuxfoundation.org>
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

commit b53e8cfec30b93c120623232ba27c041b1ef8f1a upstream.

ksmbd returned "Input/output error" when mounting with vers=2.0 to
ksmbd. It should return STATUS_NOT_SUPPORTED on unsupported smb2.0
dialect.

Cc: stable@vger.kernel.org
Reported-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb_common.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ksmbd/smb_common.c
+++ b/fs/ksmbd/smb_common.c
@@ -434,7 +434,7 @@ int ksmbd_extract_shortname(struct ksmbd
 
 static int __smb2_negotiate(struct ksmbd_conn *conn)
 {
-	return (conn->dialect >= SMB21_PROT_ID &&
+	return (conn->dialect >= SMB20_PROT_ID &&
 		conn->dialect <= SMB311_PROT_ID);
 }
 
@@ -464,7 +464,7 @@ int ksmbd_smb_negotiate_common(struct ks
 		}
 	}
 
-	if (command == SMB2_NEGOTIATE_HE && __smb2_negotiate(conn)) {
+	if (command == SMB2_NEGOTIATE_HE) {
 		ret = smb2_handle_negotiate(work);
 		init_smb2_neg_rsp(work);
 		return ret;



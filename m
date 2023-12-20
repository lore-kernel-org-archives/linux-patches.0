Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D29F84645F;
	Wed, 20 Dec 2023 16:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nxcCJGAU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 574C1C433C8;
	Wed, 20 Dec 2023 16:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088914;
	bh=L99EwiaAR+1LNiqvpktL4OvaCVoPzMvZ259EK2MUuro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nxcCJGAUCkt1arRkkOs+y5YNvSCK2Apth0t4vfgSh1hECWUi94s1ivg3sslMAl20M
	 DJdtNYaxhIqIYfKeVeTIXwzSFj76I9qzftjmMvlWEtR5/NibWy7l3l6QjmVrxFxWE6
	 GwfKSCxfF5olR0sPgOIK4L0BEtC6wumcx25hV7wQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 105/159] ksmbd: use kzalloc() instead of __GFP_ZERO
Date: Wed, 20 Dec 2023 17:09:30 +0100
Message-ID: <20231220160936.257219414@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit f87d4f85f43f0d4b12ef64b015478d8053e1a33e ]

Use kzalloc() instead of __GFP_ZERO.

Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb_common.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ksmbd/smb_common.c
+++ b/fs/ksmbd/smb_common.c
@@ -359,8 +359,8 @@ static int smb1_check_user_session(struc
  */
 static int smb1_allocate_rsp_buf(struct ksmbd_work *work)
 {
-	work->response_buf = kmalloc(MAX_CIFS_SMALL_BUFFER_SIZE,
-			GFP_KERNEL | __GFP_ZERO);
+	work->response_buf = kzalloc(MAX_CIFS_SMALL_BUFFER_SIZE,
+			GFP_KERNEL);
 	work->response_sz = MAX_CIFS_SMALL_BUFFER_SIZE;
 
 	if (!work->response_buf) {



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF55495C8;
	Wed, 20 Dec 2023 16:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NdQI2hR5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FB3BC433C8;
	Wed, 20 Dec 2023 16:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088702;
	bh=ncypJDfdjBut2QWnUQQzx/wL/aNzlRqWUkuXi0n3xT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NdQI2hR5y7XtPxdllxXSLT6+VDKmrY3HuRf2gVluro3RbM+zvmxqYmZ0NvVoYLdFd
	 Bzvr07wcrtTC/iBYV2M+G2D3+XTqDwgBSEI7xHsWsLCmcAmZjvhU69vOYfx4zMMTS3
	 yjtNC5rPgljDRZgEEMyPuKREvJ/Z3I55pnv16qhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 003/159] ksmbd: Remove redundant flush_workqueue() calls
Date: Wed, 20 Dec 2023 17:07:48 +0100
Message-ID: <20231220160931.421686731@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit e8d585b2f68c0b10c966ee55146de043429085a3 ]

'destroy_workqueue()' already drains the queue before destroying it, so
there is no need to flush it explicitly.

Remove the redundant 'flush_workqueue()' calls.

This was generated with coccinelle:

@@
expression E;
@@
- 	flush_workqueue(E);
	destroy_workqueue(E);

Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/ksmbd_work.c     |    1 -
 fs/ksmbd/transport_rdma.c |    1 -
 2 files changed, 2 deletions(-)

--- a/fs/ksmbd/ksmbd_work.c
+++ b/fs/ksmbd/ksmbd_work.c
@@ -69,7 +69,6 @@ int ksmbd_workqueue_init(void)
 
 void ksmbd_workqueue_destroy(void)
 {
-	flush_workqueue(ksmbd_wq);
 	destroy_workqueue(ksmbd_wq);
 	ksmbd_wq = NULL;
 }
--- a/fs/ksmbd/transport_rdma.c
+++ b/fs/ksmbd/transport_rdma.c
@@ -2049,7 +2049,6 @@ int ksmbd_rdma_destroy(void)
 	smb_direct_listener.cm_id = NULL;
 
 	if (smb_direct_wq) {
-		flush_workqueue(smb_direct_wq);
 		destroy_workqueue(smb_direct_wq);
 		smb_direct_wq = NULL;
 	}



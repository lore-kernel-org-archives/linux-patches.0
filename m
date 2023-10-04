Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5E971BDEC
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eoH276f6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39182C433C9;
	Wed,  4 Oct 2023 18:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444585;
	bh=+dU/iIz0gpBfsHAFUIqCx5Vj89RlPApdYpGgTT8OPjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eoH276f6IdHXH1vtRKOHFCM7eJSM/60DDlNR4qxfS0iyNDvtqyFZDEResSJpzTWn8
	 53vu64+o/pRsCYJyRttHFrMkuVRLcChVXMFkJEqLH5iQ8kFFgAfONAmkk+CJahCxVd
	 V1nrhA13MqvYDH72GWvPAWOQnJAggOtvNf5h/ZwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willy Tarreau <w@1wt.eu>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Quang Le <quanglex97@gmail.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.5 301/321] fs/smb/client: Reset password pointer to NULL
Date: Wed,  4 Oct 2023 19:57:26 +0200
Message-ID: <20231004175243.240243395@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quang Le <quanglex97@gmail.com>

commit e6e43b8aa7cd3c3af686caf0c2e11819a886d705 upstream.

Forget to reset ctx->password to NULL will lead to bug like double free

Cc: stable@vger.kernel.org
Cc: Willy Tarreau <w@1wt.eu>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Quang Le <quanglex97@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/fs_context.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1532,6 +1532,7 @@ static int smb3_fs_context_parse_param(s
 
  cifs_parse_mount_err:
 	kfree_sensitive(ctx->password);
+	ctx->password = NULL;
 	return -EINVAL;
 }
 



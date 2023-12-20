Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A355541841;
	Wed, 20 Dec 2023 16:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SgaKElEH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 258EBC433C7;
	Wed, 20 Dec 2023 16:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088936;
	bh=3OJ/DN0/b5ODDvCZlxOkyIvsQIKNWsMnC/cXgZzP+LA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SgaKElEHhv+A7Hzjl+rtxKxpsdaF+bo+012op0DUx8HzuNbcAPYYoR/T2N1sUVmFn
	 eby+GbOC1QhxOD9QCVWHeT/IaR0Ph2boZpneacRkRPYjEopV5nQjUOykLiebEbkPSj
	 LcA+j8SaWPAuQAvmU5fgDWYTBJk3s7rDWaFjKGRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 112/159] ksmbd: Use struct_size() helper in ksmbd_negotiate_smb_dialect()
Date: Wed, 20 Dec 2023 17:09:37 +0100
Message-ID: <20231220160936.566854383@linuxfoundation.org>
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

From: "Gustavo A. R. Silva" <gustavoars@kernel.org>

[ Upstream commit 5211cc8727ed9701b04976ab47602955e5641bda ]

Prefer struct_size() over open-coded versions.

Link: https://github.com/KSPP/linux/issues/160
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb_common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ksmbd/smb_common.c
+++ b/fs/ksmbd/smb_common.c
@@ -266,7 +266,7 @@ static int ksmbd_negotiate_smb_dialect(v
 		if (smb2_neg_size > smb_buf_length)
 			goto err_out;
 
-		if (smb2_neg_size + le16_to_cpu(req->DialectCount) * sizeof(__le16) >
+		if (struct_size(req, Dialects, le16_to_cpu(req->DialectCount)) >
 		    smb_buf_length)
 			goto err_out;
 



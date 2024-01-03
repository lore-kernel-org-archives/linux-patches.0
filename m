Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 896471C28A;
	Wed,  3 Jan 2024 16:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DIbGy1I/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C609EC433C7;
	Wed,  3 Jan 2024 16:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301074;
	bh=zVXFPsWTwi9zR2yEA7tw7FM+aEMfHQeoPFxmrmvI/AU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DIbGy1I/5w5lTY2wBZEcRITnT08BXU7VFXlfXBB7RODW+idAMNmsTsUXwoqqYBJna
	 m6DJPC+VWSc45ZHLZhLHx096EBUYWeFKNouBnCRuGm+v5AnLAH6Hp+sNKs3jFKbdBo
	 5HYPT6Y9ZuZn7cwo6MRxucaBjh/Wcl4hcB9zzbII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 030/100] ksmbd: Use struct_size() helper in ksmbd_negotiate_smb_dialect()
Date: Wed,  3 Jan 2024 17:54:19 +0100
Message-ID: <20240103164900.590066228@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164856.169912722@linuxfoundation.org>
References: <20240103164856.169912722@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gustavo A. R. Silva <gustavoars@kernel.org>

[ Upstream commit 5211cc8727ed9701b04976ab47602955e5641bda ]

Prefer struct_size() over open-coded versions.

Link: https://github.com/KSPP/linux/issues/160
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/smb_common.c b/fs/smb/server/smb_common.c
index 62c33d3357fe1..b6f414a2404b1 100644
--- a/fs/smb/server/smb_common.c
+++ b/fs/smb/server/smb_common.c
@@ -266,7 +266,7 @@ static int ksmbd_negotiate_smb_dialect(void *buf)
 		if (smb2_neg_size > smb_buf_length)
 			goto err_out;
 
-		if (smb2_neg_size + le16_to_cpu(req->DialectCount) * sizeof(__le16) >
+		if (struct_size(req, Dialects, le16_to_cpu(req->DialectCount)) >
 		    smb_buf_length)
 			goto err_out;
 
-- 
2.43.0




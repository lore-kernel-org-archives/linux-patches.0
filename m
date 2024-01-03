Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 829A61BDEC;
	Wed,  3 Jan 2024 16:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VUbqRxgf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB758C433C7;
	Wed,  3 Jan 2024 16:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301055;
	bh=Rc2WqnYHWa2VSQgdVenQ1saB3dnwuDam8+iZ7wMdCSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VUbqRxgfqwmX5rKpObakegyXg365FaNvRkHD2ySYxmOaHYNQQkziEBsxSr/+4ld4R
	 I1ECXFWqVG3AYhFlCGbCozT3EsV+FIueqGUA3UTUGb70fH0xu/JcDIWU8tsBRmIFPP
	 WtAXmxXEbmHoo18+yV03nKArWnjmUCbkv/kxnh/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 026/100] ksmbd: return a literal instead of err in ksmbd_vfs_kern_path_locked()
Date: Wed,  3 Jan 2024 17:54:15 +0100
Message-ID: <20240103164859.990058043@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit cf5e7f734f445588a30350591360bca2f6bf016f ]

Return a literal instead of 'err' in ksmbd_vfs_kern_path_locked().

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/vfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index e6218c687fa0b..d0a85774a496a 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1208,7 +1208,7 @@ int ksmbd_vfs_kern_path_locked(struct ksmbd_work *work, char *name,
 
 	err = ksmbd_vfs_path_lookup_locked(share_conf, name, flags, path);
 	if (!err)
-		return err;
+		return 0;
 
 	if (caseless) {
 		char *filepath;
-- 
2.43.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D0241C283;
	Wed,  3 Jan 2024 16:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oNP+2/DP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77111C433C8;
	Wed,  3 Jan 2024 16:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301119;
	bh=a5hIWtEZJKzXb1nMhkzgIAHFV7JOFQMw+kd2kX0Xeoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oNP+2/DPYkwzx/fGbid7dluO1YNmACC044ny+o2caVhpgjbA0G7q1CS5eR85rkBJr
	 zcRYjStB8RzlSH+sd8UpkeluaKXTlnocfG7RJFc5Abm4SQ9NlvlZlosA7ht5smfPqS
	 t4uX+lZO/BgDG6uXWGzIdbdK3xzUqZehmEpzJyg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 040/100] ksmbd: remove experimental warning
Date: Wed,  3 Jan 2024 17:54:29 +0100
Message-ID: <20240103164902.076714426@linuxfoundation.org>
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

From: Steve French <stfrench@microsoft.com>

[ Upstream commit f5069159f32c8c943e047f22731317463c8e9b84 ]

ksmbd has made significant improvements over the past two
years and is regularly tested and used.  Remove the experimental
warning.

Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/Kconfig  | 2 +-
 fs/smb/server/server.c | 2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/smb/server/Kconfig b/fs/smb/server/Kconfig
index 7055cb5d28800..d036ab80fec35 100644
--- a/fs/smb/server/Kconfig
+++ b/fs/smb/server/Kconfig
@@ -1,5 +1,5 @@
 config SMB_SERVER
-	tristate "SMB3 server support (EXPERIMENTAL)"
+	tristate "SMB3 server support"
 	depends on INET
 	depends on MULTIUSER
 	depends on FILE_LOCKING
diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index ff1514c79f162..f5d8e405cf6fd 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -591,8 +591,6 @@ static int __init ksmbd_server_init(void)
 	if (ret)
 		goto err_crypto_destroy;
 
-	pr_warn_once("The ksmbd server is experimental\n");
-
 	return 0;
 
 err_crypto_destroy:
-- 
2.43.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 951521C2A1;
	Wed,  3 Jan 2024 16:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Iw5xZoK4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A513CC433C8;
	Wed,  3 Jan 2024 16:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301178;
	bh=7tsYaeKZl7Lbr3dC08EeEfcevsPa31uRbHuR0MruoEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Iw5xZoK4JayeYZDfV3PauNEKfFBiPBA+hNbxa7D09COoUHWXhzt4mVDD7p1ep69bZ
	 QHlblQRWPi/PLx0+Cp3RjKtDW8RlNtNp6ffZolWs3j0Yy63+FJHpetxGqSMw/NKinn
	 QjnRVjMc8vpkdyNJYonl69eZXIF3stOmb3oA6aOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 059/100] ksmbd: fix kernel-doc comment of ksmbd_vfs_kern_path_locked()
Date: Wed,  3 Jan 2024 17:54:48 +0100
Message-ID: <20240103164904.960196885@linuxfoundation.org>
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

[ Upstream commit f6049712e520287ad695e9d4f1572ab76807fa0c ]

Fix argument list that the kdoc format and script verified in
ksmbd_vfs_kern_path_locked().

fs/smb/server/vfs.c:1207: warning: Function parameter or member 'parent_path'
not described in 'ksmbd_vfs_kern_path_locked'

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/vfs.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index e2e454eba4095..d4298a751d4a2 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1178,9 +1178,10 @@ static int ksmbd_vfs_lookup_in_dir(const struct path *dir, char *name,
 
 /**
  * ksmbd_vfs_kern_path_locked() - lookup a file and get path info
- * @name:	file path that is relative to share
- * @flags:	lookup flags
- * @path:	if lookup succeed, return path info
+ * @name:		file path that is relative to share
+ * @flags:		lookup flags
+ * @parent_path:	if lookup succeed, return parent_path info
+ * @path:		if lookup succeed, return path info
  * @caseless:	caseless filename lookup
  *
  * Return:	0 on success, otherwise error
-- 
2.43.0




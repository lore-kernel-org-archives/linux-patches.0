Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2BAF4BAAF;
	Wed, 20 Dec 2023 16:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rIgdBPIK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 659B9C433C8;
	Wed, 20 Dec 2023 16:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703089036;
	bh=YMTalHL7NOCKT5Sfnzel98/ja94aurwAGWil0aIc69Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rIgdBPIKTYP/pNBcOaD8CRG9NW/8sgw3Ztjh8fT/516g2Kcoqae9iqfpWXdBDy+fY
	 mOFA+GPLv6xJUsOlFoR7laXVFpqw/VHaX7A+hSpFdAPSNfgyr60NDr8OfeprsDqQcu
	 AAlJz/sViZ2aIP6GgZUsHCU72rfoICPC1Z5DbWSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 146/159] ksmbd: fix kernel-doc comment of ksmbd_vfs_kern_path_locked()
Date: Wed, 20 Dec 2023 17:10:11 +0100
Message-ID: <20231220160938.134256986@linuxfoundation.org>
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

[ Upstream commit f6049712e520287ad695e9d4f1572ab76807fa0c ]

Fix argument list that the kdoc format and script verified in
ksmbd_vfs_kern_path_locked().

fs/smb/server/vfs.c:1207: warning: Function parameter or member 'parent_path'
not described in 'ksmbd_vfs_kern_path_locked'

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/vfs.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/ksmbd/vfs.c
+++ b/fs/ksmbd/vfs.c
@@ -1179,9 +1179,10 @@ static int ksmbd_vfs_lookup_in_dir(const
 
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



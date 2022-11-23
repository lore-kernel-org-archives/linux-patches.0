Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB2131C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:23:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2841BC433C1;
	Wed, 23 Nov 2022 09:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669195421;
	bh=BPu3BVWP+VyGSB9iSqvVgk/d67IQof73lthAzGoLkoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V/kr7TPaAuD2TVtOgRSc1S9ZnApSLxHd0HhHq5yNR4Fx8rIbgZMepg7EHZLkmqrQP
	 JjjkQA3S6gyWsb9iW1+F/RBPKgcrHa6UnXZstHZj3UOv0Ot1X4PpYvRNLH8CduGNaV
	 DTNkk0NydO3TWtRyjjivsaErAg2oxcp1XRJcXl6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 079/149] cifs: Fix wrong return value checking when GETFLAGS
Date: Wed, 23 Nov 2022 09:51:02 +0100
Message-Id: <20221123084600.806465735@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.945845710@linuxfoundation.org>
References: <20221123084557.945845710@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>

[ Upstream commit 92bbd67a55fee50743b42825d1c016e7fd5c79f9 ]

The return value of CIFSGetExtAttr is negative, should be checked
with -EOPNOTSUPP rather than EOPNOTSUPP.

Fixes: 64a5cfa6db94 ("Allow setting per-file compression via SMB2/3")
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/ioctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
index dcde44ff6cf9..e45598b62242 100644
--- a/fs/cifs/ioctl.c
+++ b/fs/cifs/ioctl.c
@@ -193,7 +193,7 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 					rc = put_user(ExtAttrBits &
 						FS_FL_USER_VISIBLE,
 						(int __user *)arg);
-				if (rc != EOPNOTSUPP)
+				if (rc != -EOPNOTSUPP)
 					break;
 			}
 #endif /* CONFIG_CIFS_POSIX */
@@ -222,7 +222,7 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 			 *		       pSMBFile->fid.netfid,
 			 *		       extAttrBits,
 			 *		       &ExtAttrMask);
-			 * if (rc != EOPNOTSUPP)
+			 * if (rc != -EOPNOTSUPP)
 			 *	break;
 			 */
 
-- 
2.35.1




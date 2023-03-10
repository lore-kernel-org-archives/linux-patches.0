Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A41847F
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 13:56:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CF00C433D2;
	Fri, 10 Mar 2023 13:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678456607;
	bh=lL7iVy6tWYc7PyXd1xCbffPLP1SEh4mWveKhjOBcmr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r7u91NTIO67okt1wAfUxb4c9s8kF8WKmlzStqg0qZiEVZlsK2F8J661x4wwODa4b+
	 F+tcEDztmtgZwivtP9ptMvW5DSbz7t/CkmDOAVfH8FuXF2qjTna92fqP06GBgJNiA5
	 Gdg+VqDZgQ59OQp+kXSSyM73Syc+oys6MaVq5tLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 044/211] f2fs: fix to handle F2FS_IOC_START_ATOMIC_REPLACE in f2fs_compat_ioctl()
Date: Fri, 10 Mar 2023 14:37:04 +0100
Message-Id: <20230310133720.078101181@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chao Yu <chao@kernel.org>

[ Upstream commit 933141e4eb49d8b48721e2377835063a1e8fb823 ]

Otherwise, 32-bits binary call ioctl(F2FS_IOC_START_ATOMIC_REPLACE) will
fail in 64-bits kernel.

Fixes: 41e8f85a75fc ("f2fs: introduce F2FS_IOC_START_ATOMIC_REPLACE")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 1aa21160a0614..63d468b1a9b82 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -4827,6 +4827,7 @@ long f2fs_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case F2FS_IOC32_MOVE_RANGE:
 		return f2fs_compat_ioc_move_range(file, arg);
 	case F2FS_IOC_START_ATOMIC_WRITE:
+	case F2FS_IOC_START_ATOMIC_REPLACE:
 	case F2FS_IOC_COMMIT_ATOMIC_WRITE:
 	case F2FS_IOC_START_VOLATILE_WRITE:
 	case F2FS_IOC_RELEASE_VOLATILE_WRITE:
-- 
2.39.2




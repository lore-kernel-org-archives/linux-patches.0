Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5919B28DDE
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h/sAln0v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03671C433C8;
	Wed, 15 Nov 2023 20:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078402;
	bh=ZqncAW2Q+CPJLfGzcQ3+WCfS+85noYUC/1G4YFDafh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h/sAln0vCasEsTqM3NEJXTm0PZy/tOyH5SjChQEYDkgEsWKEANrWVJbVysSKZLmVZ
	 +HQzDqcOY2bqT2QaGWMbwaKnb+uH5NCQHzxYMUEhLFXsn5wfso1GrNQKryQI4k92LB
	 IHVwLJuT3/69cM/psIPjx8JFCqbtprLs2QtKlIGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 276/379] f2fs: fix to initialize map.m_pblk in f2fs_precache_extents()
Date: Wed, 15 Nov 2023 14:25:51 -0500
Message-ID: <20231115192701.439169632@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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

From: Chao Yu <chao@kernel.org>

[ Upstream commit 8b07c1fb0f1ad139373c8253f2fad8bc43fab07d ]

Otherwise, it may print random physical block address in tracepoint
of f2fs_map_blocks() as below:

f2fs_map_blocks: dev = (253,16), ino = 2297, file offset = 0, start blkaddr = 0xa356c421, len = 0x0, flags = 0

Fixes: c4020b2da4c9 ("f2fs: support F2FS_IOC_PRECACHE_EXTENTS")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 746c71716bead..d0c17366ebf48 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -3249,6 +3249,7 @@ int f2fs_precache_extents(struct inode *inode)
 		return -EOPNOTSUPP;
 
 	map.m_lblk = 0;
+	map.m_pblk = 0;
 	map.m_next_pgofs = NULL;
 	map.m_next_extent = &m_next_extent;
 	map.m_seg_type = NO_CHECK_TYPE;
-- 
2.42.0




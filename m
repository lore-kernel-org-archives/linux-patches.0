Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A62611EA8F
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:50:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26A7BC433CA;
	Tue,  1 Aug 2023 09:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690883449;
	bh=7en2ZsGzG4GBq5c5OHJtj5w8xAVrjarutFS4cVjJ3TM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mnE3xLaYlI5Fkz4kHcR/sCLtXjpoB/Yn1PCARtd5gRlqt7ofRhu2KTTykV3bMOdbF
	 Rbyb+KjykCWvB3hV1ra/pQZlWv0uVwpLf6gVmKRmf61N8nqTVlvgf1wA1sYTylhFIK
	 tS/7TL512MHDxI6mlL0lh8KfUs3k86NQ6/+rdKQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	Eric Van Hensbergen <ericvh@kernel.org>
Subject: [PATCH 6.4 220/239] fs/9p: remove unnecessary invalidate_inode_pages2
Date: Tue,  1 Aug 2023 11:21:24 +0200
Message-ID: <20230801091933.859126844@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Van Hensbergen <ericvh@kernel.org>

commit 350cd9b959757e7c571f45fab29d116d5f67cbff upstream.

There was an invalidate_inode_pages2 added to readonly mmap path
that is unnecessary since that path is only entered when writeback
cache is disabled on mount.

Cc: stable@vger.kernel.org
Fixes: 1543b4c5071c ("fs/9p: remove writeback fid and fix per-file modes")
Reviewed-by: Christian Schoenebeck <linux_oss@crudebyte.com>
Signed-off-by: Eric Van Hensbergen <ericvh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/9p/vfs_file.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/9p/vfs_file.c
+++ b/fs/9p/vfs_file.c
@@ -484,7 +484,6 @@ v9fs_file_mmap(struct file *filp, struct
 
 	if (!(v9ses->cache & CACHE_WRITEBACK)) {
 		p9_debug(P9_DEBUG_CACHE, "(read-only mmap mode)");
-		invalidate_inode_pages2(filp->f_mapping);
 		return generic_file_readonly_mmap(filp, vma);
 	}
 



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58DEA208D1;
	Mon,  1 Apr 2024 15:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986798; cv=none; b=otrTmSqbnqQezppkJQ9Zd6xe5SQ+U0yFoEZ2qOje8oUidejTMfBSYE7h13rGLTyfzDCTqOWfhu488B3yMOSZTSFi6Wul1aXhXKPpQhggMBxIPtT4QPjf/2ddGQvOKpgA8kRjcqCdEtFCbyXyCU9EYVWVk/LUaD1AB30t/ORMpb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986798; c=relaxed/simple;
	bh=DGIYcLR1jxQCChYOyH9TgAqzRT8ZrTV4HmMRzlAmYFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TiA7wwfyGdf1Q2ZqNYAP2UQud9pwUIGygveldai+KVBq3WrdkXu4Vb2uovvymFoqiOwy0L7I27Q8E/VmHKH7VmLQIuFLW6WsKCTs3QrZOFY0cRbCf1axCbnddhDc6T4wW+Z4yNffxbV9eRcRqJ5zJGN+KEHDsfcc5QTt8qQ5qOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YkIcEKZh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YkIcEKZh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3352C433C7;
	Mon,  1 Apr 2024 15:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986798;
	bh=DGIYcLR1jxQCChYOyH9TgAqzRT8ZrTV4HmMRzlAmYFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YkIcEKZhIoDV5YgQo7rGsO99Z8o88zfMx4jZS8lJrHYX74AkCbWARqKdTwKfdY+fW
	 4XVYxGrjlplaLC9VKbvoErX/udShZIqdn8ZNhDlkZLDxqMEq1CQdmd7JUVJ1+GkPS4
	 9tSYtr+7JFESQyNhGZCoYzGAVObouXIOIKDxxeuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 088/399] fuse: replace remaining make_bad_inode() with fuse_make_bad()
Date: Mon,  1 Apr 2024 17:40:54 +0200
Message-ID: <20240401152551.806560027@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@redhat.com>

[ Upstream commit 82e081aebe4d9c26e196c8260005cc4762b57a5d ]

fuse_do_statx() was added with the wrong helper.

Fixes: d3045530bdd2 ("fuse: implement statx")
Cc: <stable@vger.kernel.org> # v6.6
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index d19cbf34c6341..d3bc463d9da76 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1210,7 +1210,7 @@ static int fuse_do_statx(struct inode *inode, struct file *file,
 	if (((sx->mask & STATX_SIZE) && !fuse_valid_size(sx->size)) ||
 	    ((sx->mask & STATX_TYPE) && (!fuse_valid_type(sx->mode) ||
 					 inode_wrong_type(inode, sx->mode)))) {
-		make_bad_inode(inode);
+		fuse_make_bad(inode);
 		return -EIO;
 	}
 
-- 
2.43.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C4BB1E86C;
	Mon,  1 Apr 2024 16:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989551; cv=none; b=hw+hap1+ValwoPEpmSiygbyXxN5CdyLMpotTaBcdkqzpb/RRLbc39rBr0D9dkrlas7ZOgbMXMZYv/u+hZuDbV4YyUvXAiz51WA4dtztBVuiheNiB5yIF3Y26ieddMTTyq6rr47WN0YPn2PVNXNdr4TX3us/e9juPNvOB+jYzzNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989551; c=relaxed/simple;
	bh=61384N92rfJJqnIoZ+4ugSSjn6jc8vdBYd6srblP3Oc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i0N8Npw5TQ3UTtr/xHMTP+0j7ppFEFO/MyTD5906NrqYpVu8/dRcD5BEP37ghw/OblmRH++IS6U45cHCFVavEU1vojLyS7woeU2kfwCl9di+ppBsWc47ra7kaajxhqjyDpx2szPeb6T0+hrvefdwV+0FuMsgTMYYoYpYxnwL5jQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mwBB9JHL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mwBB9JHL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C138EC433F1;
	Mon,  1 Apr 2024 16:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989551;
	bh=61384N92rfJJqnIoZ+4ugSSjn6jc8vdBYd6srblP3Oc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mwBB9JHL9umTKMJ6/hov5YDVCvFZDO9mk0KyIwTmtbbTLHFyZFV9StKk3khmp7OVt
	 fP8qTJmgAFU5Oft3vGfFdENkIMaOIOoEEF4LLhYC8WR2Wk398HreyZhBCH4nzKjSlC
	 y2l69dTg59moAyTnLT7P4fD0GhInxWg2GYxJhmS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 082/396] fuse: replace remaining make_bad_inode() with fuse_make_bad()
Date: Mon,  1 Apr 2024 17:42:11 +0200
Message-ID: <20240401152550.362803768@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d707e6987da91..a4ad01a78e826 100644
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




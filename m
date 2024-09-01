Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4125817E01C;
	Sun,  1 Sep 2024 16:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207665; cv=none; b=rtSiXr+qFxqlVwBBQP6oYSsHRlKwUwaP8ZK7XItO0jpQBHzp5FbYhlS/ddHWYuKKNxj6Af0VZZ+by5QzlywK5uxs+nBon1pvO1PuXn4YOfHkN6ydR4XsmtOz37mEyX/Mch1sbMOZMGGQKQmt2fZtRVxiaDTKH3jXhg8+m19A7Ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207665; c=relaxed/simple;
	bh=kWvt8Z9FZEQeTPJkDUiibRDo3RTyr4bg8HdG8DCZZyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qKJP4hUfjQTpQvbm3COjBdwNWLIiaYxZYcqBE54U3sx1iQuLhfT1m5z6SWXCFt3Bil80glOjW4+rhpDXa77jIQ9+BX8gDiNRRkbqWhZOwrM+HfWDNzBNCjJkp5hMFUPh86wKhJM2onJBB8vhNYACc1z+X47lSpkd3u/7hgvVIQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ohKpTprf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ohKpTprf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CC66C4CEC3;
	Sun,  1 Sep 2024 16:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207664;
	bh=kWvt8Z9FZEQeTPJkDUiibRDo3RTyr4bg8HdG8DCZZyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ohKpTprfd+3jtsxSHtHs5pPyVM7S0c82OLl9smPWTDpmNc3lJCHcqiMBIDVZx6UB4
	 AoN722b0hJAY0552f5+u/ViFRqwkNwJWfZjUWnh/rUgMdPyHtWzEIoI6c+XpdFKA4X
	 xuzJFAgNCE4jg1ZIZffqo18wogix5fH54kYA3vJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 23/98] gfs2: setattr_chown: Add missing initialization
Date: Sun,  1 Sep 2024 18:15:53 +0200
Message-ID: <20240901160804.567018829@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160803.673617007@linuxfoundation.org>
References: <20240901160803.673617007@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 2d8d7990619878a848b1d916c2f936d3012ee17d ]

Add a missing initialization of variable ap in setattr_chown().
Without, chown() may be able to bypass quotas.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index a52b8b0dceeb9..16febedaa4a5d 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -1847,7 +1847,7 @@ static int setattr_chown(struct inode *inode, struct iattr *attr)
 	kuid_t ouid, nuid;
 	kgid_t ogid, ngid;
 	int error;
-	struct gfs2_alloc_parms ap;
+	struct gfs2_alloc_parms ap = {};
 
 	ouid = inode->i_uid;
 	ogid = inode->i_gid;
-- 
2.43.0




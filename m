Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC3726AC1;
	Sun,  1 Sep 2024 17:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210007; cv=none; b=WxmFAeqeGf5VPlea0CDsFpmKpTr2t0/u4whSBqCWIiRzfaI4uOSeta510CFmZqGugRxrO1siaykRdalwB9/7k1heUbszidPxz5txfjRmN5sidJyuAMDM1QR4Y82Tw3IMtd+UMDeOXKohB3ZudfqF9Gw5E/5cO9PdcLkRmjUYpnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210007; c=relaxed/simple;
	bh=EubeKURDzYldantp7zGZR2Zcx24kBYjaNBR48x5+vw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qs8/lmh3Ikw9Xwrn2TRnG8L3vc2OtuH/FADtDonyUB2r0V5OvHD7LSuMxb52l4ErkGYFsXYCe6p2pANHxQJgrjKNHw9I3I/w0c/REy0EQA8vK9WTJ0hwNeHN+WuoifwVZq9BMqG6nO/QmMUjKEg3i89dx0368hhT4o01MTSFiVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1dgZM1V8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1dgZM1V8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB862C4CEC3;
	Sun,  1 Sep 2024 17:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210007;
	bh=EubeKURDzYldantp7zGZR2Zcx24kBYjaNBR48x5+vw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1dgZM1V8vePIcEMMGP5p4t/zIR5A0XHKW4WPEBIo1B3ws1xE1uWzWpR9t6UBnJB4U
	 BWBWfZBdqDe2MMPaNFvYh8xjDr0hiIfVolQpqcqNvIUgE1oq+rVVHyl+NW8XmPxMIv
	 T4o4h1IgmMWnz6O7gnpxJ+a7pUE6Vw67dDr2lmCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 059/215] gfs2: setattr_chown: Add missing initialization
Date: Sun,  1 Sep 2024 18:16:11 +0200
Message-ID: <20240901160825.587133227@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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
index 462e957eda8be..763d8dccdfc13 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -1910,7 +1910,7 @@ static int setattr_chown(struct inode *inode, struct iattr *attr)
 	kuid_t ouid, nuid;
 	kgid_t ogid, ngid;
 	int error;
-	struct gfs2_alloc_parms ap;
+	struct gfs2_alloc_parms ap = {};
 
 	ouid = inode->i_uid;
 	ogid = inode->i_gid;
-- 
2.43.0




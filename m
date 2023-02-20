Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 212B463BB
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:51:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D4AFC4339B;
	Mon, 20 Feb 2023 13:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676901114;
	bh=HKgf7tEf7fjCKIm9ip1+X34N5pNlozGt6DaMaMV1eh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OP7DBJDwV4RzSwlVs0lvmWFdHerY+J0PGB6iz3c/kNJ0fUx4jWYqjaaImyXgC7ddN
	 oS6wwjVyuuNBUsM3+Vsn+TRHLRVC+6P0F1cjnXAvy3pfjeR98ywAeYeaccQ/Ga8wlY
	 LjCD2YXXKFwPRkjq6txCqQpf9KqRzm/1n1MHPfkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Chinner <dchinner@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 27/83] xfs: set XFS_FEAT_NLINK correctly
Date: Mon, 20 Feb 2023 14:36:00 +0100
Message-Id: <20230220133554.631876871@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.669025851@linuxfoundation.org>
References: <20230220133553.669025851@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit dd0d2f9755191690541b09e6385d0f8cd8bc9d8f ]

While xfs_has_nlink() is not used in kernel, it is used in userspace
(e.g. by xfs_db) so we need to set the XFS_FEAT_NLINK flag correctly
in xfs_sb_version_to_features().

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_sb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index e58349be78bd5..72c05485c8706 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -70,6 +70,8 @@ xfs_sb_version_to_features(
 	/* optional V4 features */
 	if (sbp->sb_rblocks > 0)
 		features |= XFS_FEAT_REALTIME;
+	if (sbp->sb_versionnum & XFS_SB_VERSION_NLINKBIT)
+		features |= XFS_FEAT_NLINK;
 	if (sbp->sb_versionnum & XFS_SB_VERSION_ATTRBIT)
 		features |= XFS_FEAT_ATTR;
 	if (sbp->sb_versionnum & XFS_SB_VERSION_QUOTABIT)
-- 
2.39.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C04642566
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:31:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46D8FC433EF;
	Tue, 18 Apr 2023 12:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821082;
	bh=FSdzolV37+Y0e9VsLAP/fpZtjwozTZYnOfENyNnrS0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KSrK9+Z2ZO3wc8uBFxPI/V+Dq1f1WnxS2uqg83x8YsAr86teV+jrZPKzwA9itiFhz
	 jVS7uku/x1piKTr5PdF7iqtWjRDKXIhbMKz8+gi5NTHZyRAgLyGuHKtlqVbf7qZ1De
	 izD0sGs59h55WfqG1ArMlefbyW92mfv06MniOtVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Brian Foster <bfoster@redhat.com>,
	Chandan Rajendra <chandanrlinux@gmail.com>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 5.4 84/92] xfs: simplify a check in xfs_ioctl_setattr_check_cowextsize
Date: Tue, 18 Apr 2023 14:21:59 +0200
Message-Id: <20230418120307.723060751@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120304.658273364@linuxfoundation.org>
References: <20230418120304.658273364@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

commit 5e28aafe708ba3e388f92a7148093319d3521c2f upstream.

Only v5 file systems can have the reflink feature, and those will
always use the large dinode format.  Remove the extra check for the
inode version.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_ioctl.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1510,8 +1510,7 @@ xfs_ioctl_setattr_check_cowextsize(
 	if (!(fa->fsx_xflags & FS_XFLAG_COWEXTSIZE))
 		return 0;
 
-	if (!xfs_sb_version_hasreflink(&ip->i_mount->m_sb) ||
-	    ip->i_d.di_version != 3)
+	if (!xfs_sb_version_hasreflink(&ip->i_mount->m_sb))
 		return -EINVAL;
 
 	if (fa->fsx_cowextsize == 0)



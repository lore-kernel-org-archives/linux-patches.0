Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C37165F54E;
	Tue, 13 Feb 2024 17:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845322; cv=none; b=jXnwzN2s1wjSOC34NYXkWQ91r0D8aPnDfKP/pKgAw141crSDjuwZhUBRPpIvGXONO0F9g+gMT2TfPFk5/9cR57sOhdJZwQaOM8Tl6qaWsH9sR218Yugjn5IE3mZ2gvyNF+Ymhq56eii+brrL3/9ONSP/sHCIIBr0R6lg4RjFMOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845322; c=relaxed/simple;
	bh=Pz/dtNfXTn6niUnUxXTxyH5OKF35bNaSsafrOBWElFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=turY1/9duK3lXYlj12sppEeaAPgko8XBeemZGqQBPoPd4EPtNeye6Z+Esdtqsx2xnS5MR4fohULnD8U9f2uVomZYoOpMi37bsVC3sAHkiaXWPHS1DiLaSjWwhVDec6FlNpquzFauV+pbwWPsD3paba1+g8gkQbKkHmQ5apXNbPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g4PBTAv8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g4PBTAv8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD59C433C7;
	Tue, 13 Feb 2024 17:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845322;
	bh=Pz/dtNfXTn6niUnUxXTxyH5OKF35bNaSsafrOBWElFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g4PBTAv8XzHCgcNKVt6q357PpdMCt1vpd/XsQhj4ZHxLYbLoWNV5cjeuF7fDWj3Am
	 taxHAHg3I7TxZHjokdDdDIre8QMARK+t8m0qabEQ4eWaEt3TY3uhXOWmCizn9MoGrl
	 x67aVAqT3ITNG21hRxXOGPoOdg9cv6G/BbzMF62I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Catherine Hoang <catherine.hoang@oracle.com>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 018/121] xfs: bump max fsgeom struct version
Date: Tue, 13 Feb 2024 18:20:27 +0100
Message-ID: <20240213171853.503034834@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
References: <20240213171852.948844634@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit 9488062805943c2d63350d3ef9e4dc093799789a upstream.

The latest version of the fs geometry structure is v5.  Bump this
constant so that xfs_db and mkfs calls to libxfs_fs_geometry will fill
out all the fields.

IOWs, this commit is a no-op for the kernel, but will be useful for
userspace reporting in later changes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_sb.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
index a5e14740ec9a..19134b23c10b 100644
--- a/fs/xfs/libxfs/xfs_sb.h
+++ b/fs/xfs/libxfs/xfs_sb.h
@@ -25,7 +25,7 @@ extern uint64_t	xfs_sb_version_to_features(struct xfs_sb *sbp);
 
 extern int	xfs_update_secondary_sbs(struct xfs_mount *mp);
 
-#define XFS_FS_GEOM_MAX_STRUCT_VER	(4)
+#define XFS_FS_GEOM_MAX_STRUCT_VER	(5)
 extern void	xfs_fs_geometry(struct xfs_mount *mp, struct xfs_fsop_geom *geo,
 				int struct_version);
 extern int	xfs_sb_read_secondary(struct xfs_mount *mp,
-- 
2.43.0




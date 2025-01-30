Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B52B41E7C25;
	Thu, 30 Jan 2025 14:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247358; cv=none; b=FjDfyC8TVI2nIRIbJ7+ACcvXhMnlpUkzAlVA9TJDNMTFKN040Wu78VlU0ERC9y9C/0n0mRaLG3ar+//cjpaR83NpY529CzeQOUlPLF0k1s2lZfK2MefuHHCPJ/tFN+49f4LuZMuj5C3C6PdMrgZ7B3OlERHMpP3UBTwqzfj5x0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247358; c=relaxed/simple;
	bh=La/s5fw+My5mMi+VbKmjtC35Lpt/fKQqTIjjYzsmDS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GfYNNf8dFn3nF9x+5N+1VNiOnf/tIT4Fvg9kMFVoS31SUilJCYbq7OxWu4ku4RWu005p3FUSsIrilY4BmTsP5JpJftRFs9iPnXreCODUnKjfQrU1hcEneM/iUIwIRLyHAjVT5ahgq5R21FOr9qF9XdcYaVSAEXv61F9zwPM4RMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P3V7b3Ip; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P3V7b3Ip"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37E68C4CED2;
	Thu, 30 Jan 2025 14:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247358;
	bh=La/s5fw+My5mMi+VbKmjtC35Lpt/fKQqTIjjYzsmDS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P3V7b3Ipk0gik9wMo3RIkV9kka8fwtHivQjaRqBqXNvlrm+BZ5mTvvZhlycxRr79d
	 9M1iN8uXzj7dTyor7lLzyv43Q9sIVZLMvOQRHMfSm2cOkSCy3/zpyafK9Iwj1J9D+5
	 is07gcn5768GdvdjBk+c4JZLbXJAdxPeLIAJJtcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 12/49] xfs: bump max fsgeom struct version
Date: Thu, 30 Jan 2025 15:01:48 +0100
Message-ID: <20250130140134.325001378@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.825446496@linuxfoundation.org>
References: <20250130140133.825446496@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 9488062805943c2d63350d3ef9e4dc093799789a ]

The latest version of the fs geometry structure is v5.  Bump this
constant so that xfs_db and mkfs calls to libxfs_fs_geometry will fill
out all the fields.

IOWs, this commit is a no-op for the kernel, but will be useful for
userspace reporting in later changes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_sb.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/libxfs/xfs_sb.h
+++ b/fs/xfs/libxfs/xfs_sb.h
@@ -25,7 +25,7 @@ extern uint64_t	xfs_sb_version_to_featur
 
 extern int	xfs_update_secondary_sbs(struct xfs_mount *mp);
 
-#define XFS_FS_GEOM_MAX_STRUCT_VER	(4)
+#define XFS_FS_GEOM_MAX_STRUCT_VER	(5)
 extern void	xfs_fs_geometry(struct xfs_mount *mp, struct xfs_fsop_geom *geo,
 				int struct_version);
 extern int	xfs_sb_read_secondary(struct xfs_mount *mp,



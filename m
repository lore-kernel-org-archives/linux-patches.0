Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB7B528851E;
	Thu, 27 Nov 2025 14:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255438; cv=none; b=fQzjxos0DbDlhCzu9eRijz/guH/0uuCORyGlQXVdaaG6udTbG7fdA8BhW3GGLhHeYc/shCRsnEwDqu5Xv/b8QHM0XVXR1Ipgr/o3RvTtbOeN/rrY5c9Z6mNtiZK/61kdHE7fwmP7VK/RT1sUIqUlre+MmgIBq2jSzEFMhYIhRGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255438; c=relaxed/simple;
	bh=0BqLRSiJqOi2fIhmcqmbNYrPv4QBxIRalEHNTjfzcWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iANbA61scJadPxJcOLy6WEG0RemZAn9lK07a3ogUX0kqKNQ9pz0QLtLobXqsFM0pLGM0WKISdRpCybZYqHpkwM/Ez8wzfOfDk4BDw6wgFHwYsz05m1GxtTHuggX6+vJ6SYhPoq2fsAr4JKydMzipKdNNra4EnoJkhiwKw+qRqc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sMhm3Ikz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sMhm3Ikz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59F69C4CEF8;
	Thu, 27 Nov 2025 14:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255438;
	bh=0BqLRSiJqOi2fIhmcqmbNYrPv4QBxIRalEHNTjfzcWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sMhm3IkziayknUITbjpXLXr9UfVkIXUqrsaPSFOGwdOB0bMjWjduVXDl1OVMmg7BZ
	 0okNax+v0t38LGsitq3gIKyqezOi11PGZu6T+LNVNsnZ22qYoYfk4qcJVs3F66hMm4
	 YN8PUdQw2CuX8gqKnBCbzi2hf9lWl4gw4sabPZmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Chinner <david@fromorbit.com>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Marcelo Moreira <marcelomoreira1905@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 107/112] xfs: Replace strncpy with memcpy
Date: Thu, 27 Nov 2025 15:46:49 +0100
Message-ID: <20251127144036.763492386@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144032.705323598@linuxfoundation.org>
References: <20251127144032.705323598@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcelo Moreira <marcelomoreira1905@gmail.com>

[ Upstream commit 33ddc796ecbd50cd6211aa9e9eddbf4567038b49 ]

The changes modernizes the code by aligning it with current kernel best
practices. It improves code clarity and consistency, as strncpy is deprecated
as explained in Documentation/process/deprecated.rst. This change does
not alter the functionality or introduce any behavioral changes.

Suggested-by: Dave Chinner <david@fromorbit.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Marcelo Moreira <marcelomoreira1905@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Stable-dep-of: 678e1cc2f482 ("xfs: fix out of bounds memory read error in symlink repair")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/symlink_repair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/scrub/symlink_repair.c
+++ b/fs/xfs/scrub/symlink_repair.c
@@ -185,7 +185,7 @@ xrep_symlink_salvage_inline(
 		return 0;
 
 	nr = min(XFS_SYMLINK_MAXLEN, xfs_inode_data_fork_size(ip));
-	strncpy(target_buf, ifp->if_data, nr);
+	memcpy(target_buf, ifp->if_data, nr);
 	return nr;
 }
 



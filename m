Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB2B732AAC4;
	Thu, 27 Nov 2025 15:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255940; cv=none; b=MSnqTRM3C2M4SQeCSAPc2LiboWfE/zcckvdUYX+X6jv1eyeV2BjLaau0On+dvjW8xjpn5iU94t/LWQfETdZo5lwfm5HrcnBFdO30XtwOGl1+IZb1bTa462q/YqY1e9RU3QKe/P7mhmjUX6TImc4WEo9C4gjrgRgL/rEr49k32os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255940; c=relaxed/simple;
	bh=htnwP0v3X+96GpVAc9U2SyqR/ho21Ntnp9sI/I2Zykk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SWrP2yNEh5ytALKbu6q1owRuMl1hI47kXyM7ZnnYPQ8U+Me+RV5o98PhZs/PMaFT6japTcHriVoKZ7ePvFKQWIK2SrmtjulopZpvSQbssT9T4d6TNqwEBvIUZ/mgfqfrNKxs0TdsVYORImFKXxqbjji+uXoSh1DudMO+0Isy+uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F6Ake5Oy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F6Ake5Oy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12239C4CEF8;
	Thu, 27 Nov 2025 15:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255940;
	bh=htnwP0v3X+96GpVAc9U2SyqR/ho21Ntnp9sI/I2Zykk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F6Ake5Oy1MYQLjbL6BrqSy7f4Ov9Duk3oaDIpeWBitRO44C4rq/p3S02M2qnmAkFh
	 F4qqCt3M6xP+6pgp4YE7r6LZX+S3B5YIKbPr5MelqZwcHCUOiJr5aCyNpkg+cPzRad
	 H4UZlvKVZJfBCVsKz4aZVx9CPkjcL0P+ArNYFmLo=
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
Subject: [PATCH 6.17 166/175] xfs: Replace strncpy with memcpy
Date: Thu, 27 Nov 2025 15:46:59 +0100
Message-ID: <20251127144049.015979193@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
 



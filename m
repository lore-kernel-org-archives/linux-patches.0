Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD6A257421;
	Tue, 25 Mar 2025 12:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905660; cv=none; b=jYu5eFzQ1frjeT/H4yzPhsyQN4gGh96Mg0EK5CqdXu39n6sJCG43CfMTga/brBPVGHFQoa50BIuDFk3Jqp6ERNGQVilq1gpD7pn1IO8uW++VbIGEYL5H2VaHrC5EzGctGcdznwf2rDKZmThihrN4EVkGss4VKjna8F+LRUlnzfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905660; c=relaxed/simple;
	bh=6ExazcCfnzS0BFGs5e0gyddUhVFXJvpgFgnkRinwTzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fye77Z5obFE2dh7iJd8NOfkh+1LG7HYvU2kgyuXh+Bo2qRoOBg6zSFp8vWBEPHbtFe49O3C8Pyk8HdgJIDJcFR81YX66L0pSMBmxlrQvxWUr0XdZNBcvW/vDT1BG5SFFxStjkpTgmUQ+zFFvf5RQ4Nx5N08WmvCYEeAPy1CqrdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x7qMvLZ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x7qMvLZ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30874C4CEE4;
	Tue, 25 Mar 2025 12:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905660;
	bh=6ExazcCfnzS0BFGs5e0gyddUhVFXJvpgFgnkRinwTzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x7qMvLZ0DOm1sxIpiSIlkC8M6vgVj1hsEG/XvXSGZ7kCDT+iKlTV2uijCSWVX3LYz
	 TERgQsgJhJF8piziPWDH8tTlOuoB++1Ckv/QyXRGmvPHHZ6g+/dbUq4ExOy1qj8q4t
	 rrwwLMRLl3YtxHB/W1FdRXg7cl4ZAmiZDwsue86w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 094/198] xfs: remove unused fields from struct xbtree_ifakeroot
Date: Tue, 25 Mar 2025 08:20:56 -0400
Message-ID: <20250325122159.116389154@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

[ Upstream commit 4c8ecd1cfdd01fb727121035014d9f654a30bdf2 ]

Remove these unused fields since nobody uses them.  They should have
been removed years ago in a different cleanup series from Christoph
Hellwig.

Fixes: daf83964a3681 ("xfs: move the per-fork nextents fields into struct xfs_ifork")
Fixes: f7e67b20ecbbc ("xfs: move the fork format fields into struct xfs_ifork")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_btree_staging.h |    6 ------
 1 file changed, 6 deletions(-)

--- a/fs/xfs/libxfs/xfs_btree_staging.h
+++ b/fs/xfs/libxfs/xfs_btree_staging.h
@@ -37,12 +37,6 @@ struct xbtree_ifakeroot {
 
 	/* Number of bytes available for this fork in the inode. */
 	unsigned int		if_fork_size;
-
-	/* Fork format. */
-	unsigned int		if_format;
-
-	/* Number of records. */
-	unsigned int		if_extents;
 };
 
 /* Cursor interactions with fake roots for inode-rooted btrees. */



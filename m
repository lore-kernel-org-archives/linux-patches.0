Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 022BB2F851;
	Mon, 23 Mar 2026 14:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277634; cv=none; b=TajhlFPris+lYY4ducE1zwcBMAPhruVcUdCUiMRKZelc4Lns1vVQtF0Gh6b1jPmhu0xg0k8sgTMDqDmDCPfvGTwq30EDfq3LJbhaIpu+DRqqANQ1uxnJnP/DqYMVekmhGy63Wnnce8zLLWLkU1dFzOF6PZnjEcZ8Jf4qj2egGqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277634; c=relaxed/simple;
	bh=g+1I7BVqbJUzPEAzub2VV56vsxgUfLVUxxR0AFUmz/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d01M3LkN4UWfam/xNUmuluaLSIWn5kYnqVQXyCMJGDed75snTyin7AAB6/ckeg12nR0VF61W5zKB96uOA5ZzBwDWRMhzFxmFQoUwEGeTeypZJXEqPhOal0fFHtC9kaRnXQZtEgkRwG1HS9KN+mTXbXOffCBZwkkr1n3CV2nP4gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=peT9M2vl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="peT9M2vl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 287A3C2BCB1;
	Mon, 23 Mar 2026 14:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277633;
	bh=g+1I7BVqbJUzPEAzub2VV56vsxgUfLVUxxR0AFUmz/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=peT9M2vl4x2QZQXN91FTKwWbiro+e738I58YUkOX3sPFApNtfW6ZEGQOOhq9qbiP0
	 0Xdv+slC5UvpYziXMErJ1YMMJPfFnI1faUGDUJ25ckaPQze97r/vtHQXMDuiaRLWop
	 N8Im9xjZdugfFvw3xE2GM/daozIku++n6GoEG8N4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Mark Harmstone <mark@harmstone.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 022/567] btrfs: fix objectid value in error message in check_extent_data_ref()
Date: Mon, 23 Mar 2026 14:39:02 +0100
Message-ID: <20260323134534.318013703@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Harmstone <mark@harmstone.com>

[ Upstream commit a10172780526c2002e062102ad4f2aabac495889 ]

Fix a copy-paste error in check_extent_data_ref(): we're printing root
as in the message above, we should be printing objectid.

Fixes: f333a3c7e832 ("btrfs: tree-checker: validate dref root and objectid")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Mark Harmstone <mark@harmstone.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-checker.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index bca5ec4c26630..e38994ac14848 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1673,7 +1673,7 @@ static int check_extent_data_ref(struct extent_buffer *leaf,
 			     objectid > BTRFS_LAST_FREE_OBJECTID)) {
 			extent_err(leaf, slot,
 				   "invalid extent data backref objectid value %llu",
-				   root);
+				   objectid);
 			return -EUCLEAN;
 		}
 		if (unlikely(!IS_ALIGNED(offset, leaf->fs_info->sectorsize))) {
-- 
2.51.0




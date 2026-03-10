Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD7242BF3E2;
	Tue, 10 Mar 2026 11:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141075; cv=none; b=AwGkE+0iK6PEML/l2Opa9Oomzemhh85RqM3WJeklqtmIRhOQK2JzdcMPO7EYvjN5XHF/P4KfvUd8594/kGgO9nF+zPAAf9CfPavqkfxUrmDiuKeiaX1BIIGt4V+bI28/qkwO9Fa4uo7hSd6GljaUGJf2/YRuaM6jy/LsXQwK+XA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141075; c=relaxed/simple;
	bh=Adid65bzDuRoC0QPHg6cwevuks2OR9kFIQPcOsvF0hY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bqCejK81G+BTDmxMWuYPee1oZ+tuRTJekrGpNuzruyMmFbDN2h9NjHMrKqVLYvZmk9dP0/7ZIRMmIbkzHwEW9f4VssvP2BCEBjPmnnVcRETUnqf8hCwkrI159m4tcsrP3O3RwARul5UH5HPodCXnWSGi0TtAwDqDYonXIb8a8kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TAO/1SIB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TAO/1SIB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E36B6C19423;
	Tue, 10 Mar 2026 11:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141075;
	bh=Adid65bzDuRoC0QPHg6cwevuks2OR9kFIQPcOsvF0hY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TAO/1SIBO7vU1sMEkDwO38t+aNFWlS7N/G8yEABPZugPEPW9e36hCdwPGablQ80UY
	 Uq8/GUJt5+s8N4THTqnjLz7b7XNApqAbg2w7Wjsj8aOpEPKAkT205xPgl0h+neWK1q
	 Etg0Yaj4TgsO2OpOTbotPEPSPXtK2CA3JqnG2rYt5ufG6Ed2IjmKlyyd+s5uu8ykHc
	 dWytTap0tn+2uj6COJLb3q6v43sK69mJdd0P3nLPxb0Lu9aW+9323j2FDvfSCRjfKk
	 V2zX22DiVSCW8J7s4c+y3MRXWHd0/WE+jVoXFaYI+GWz4oFZl6DMu0rf4hXC3j8MxK
	 kgR8eYMXz8G+Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mark Harmstone <mark@harmstone.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 075/311] btrfs: fix objectid value in error message in check_extent_data_ref()
Date: Tue, 10 Mar 2026 07:02:02 -0400
Message-ID: <cb669c7de26be713b92db2e4bf20ab5d9c303e8c.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
index 6d4dceb144373..12d6ae49bc078 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1712,7 +1712,7 @@ static int check_extent_data_ref(struct extent_buffer *leaf,
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


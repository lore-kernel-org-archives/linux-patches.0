Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D820A3B3BE5;
	Mon, 23 Mar 2026 16:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774283093; cv=none; b=BXF8csHMRs9R8AZLCcrL4XFJcfnjojtOHExwLOvPzWYQQoHjQcd/VOo2E2uAW58N8CCBf+8tYY1yBAf62Nq7U0rK1W3+dbQK2Dsh6gqQPFF34hPfOcT7aMJ5ATcLMfotkPB0UIs6mK2Jsy06BP8Fpehkw7iiSUR694Z29IVwV0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774283093; c=relaxed/simple;
	bh=X3LFKihjrP+Kkfne6YREokPqSeVKEMAE37wnLGH4QpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EvEWFUC9HZttHR0Ml2xYG0nKBsOgAe2ORaXFLckNYTvPrLeDbcHE++0u7h6++tFtqTsvhvUIeTe2EH9ZhY1qoj0y/06mj8+hRsBO6LtRDsNSFXZjiP+FArO+UM5R8ipNVwE4iG+jtWR0H/HfLIe5NjGNU8f/yhp4rd2I9zUJDWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MNvsLKIv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MNvsLKIv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6990BC4CEF7;
	Mon, 23 Mar 2026 16:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774283093;
	bh=X3LFKihjrP+Kkfne6YREokPqSeVKEMAE37wnLGH4QpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MNvsLKIvavqKKO1SV8y9+hHmjzVuBj7GXwFFwb9aSktlzgzu1EE4qM9ONaQLTtjkw
	 ZAcDyVmZt2MAQyrlI5KfvQKb3PmmZa00kKTefQhVDhnESY4hTGtm+HcL4Voyyswbo7
	 9Mzm/nh0wY8V443alSeFLpCBFmoTkJpXVIIeSldU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	ZhengYuan Huang <gality369@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 399/481] btrfs: tree-checker: fix misleading root drop_level error message
Date: Mon, 23 Mar 2026 14:46:21 +0100
Message-ID: <20260323134534.890358499@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ZhengYuan Huang <gality369@gmail.com>

[ Upstream commit fc1cd1f18c34f91e78362f9629ab9fd43b9dcab9 ]

Fix tree-checker error message to report "invalid root drop_level"
instead of the misleading "invalid root level".

Fixes: 259ee7754b67 ("btrfs: tree-checker: Add ROOT_ITEM check")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-checker.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index d1b6bb8f08dd1..cafd7055ab090 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1200,7 +1200,7 @@ static int check_root_item(struct extent_buffer *leaf, struct btrfs_key *key,
 	}
 	if (unlikely(btrfs_root_drop_level(&ri) >= BTRFS_MAX_LEVEL)) {
 		generic_err(leaf, slot,
-			    "invalid root level, have %u expect [0, %u]",
+			    "invalid root drop_level, have %u expect [0, %u]",
 			    btrfs_root_drop_level(&ri), BTRFS_MAX_LEVEL - 1);
 		return -EUCLEAN;
 	}
-- 
2.51.0




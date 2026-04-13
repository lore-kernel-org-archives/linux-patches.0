Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBAC949620;
	Mon, 13 Apr 2026 16:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097707; cv=none; b=cygxZhOADjqzyrHdrS5itaoD7D+2bYXdsTtsVWCwlmIbLQFY9w/81sxUJHmvNsSsb+j6JakPcWly1OefjkU0IcrHuxor7rXJOMUPBvtc5OubCc4lpi7gi4PylW9GlUmj7yLQvXJL/QAKA1E7vRoXE2L1ZrzwY4W9oWZwO6JsMKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097707; c=relaxed/simple;
	bh=aQayMgE1tWOXEQMtFUeXapPaD9htN3yh7uskRF8+i/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nYh9VVF/b1Yp5oA0GStKpFD/s6ztfFYalBbFqHqSxEjFOiz+z1mz1Huw9CuBrhwiacMB6RZxONeiGyXNgVxA833zEzGHKjW3CxP2hn1PCRRIxhteY2tWtkRMHg8pLfn8bNlKvDGTfJ9UK4fO4n4xzAYUUgXqzMyxnbhvvBwAqh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LKJZO64P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LKJZO64P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A919C2BCAF;
	Mon, 13 Apr 2026 16:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097707;
	bh=aQayMgE1tWOXEQMtFUeXapPaD9htN3yh7uskRF8+i/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LKJZO64POH46rvy3opd2468+qfyv+shDEcohE9XnibqVbfSPgwgi7OYbE3LRw6ZS9
	 bGIK5OQ2kdbmMP415H72oJ4B7rpp1abziEhaikvILY4nuJ+5PZJaMFALmU74zwRg4g
	 aZvkmV2XTN7nYSGiT8X4S7QiW2CVTgeYx/PlhwAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	ZhengYuan Huang <gality369@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 242/570] btrfs: tree-checker: fix misleading root drop_level error message
Date: Mon, 13 Apr 2026 17:56:13 +0200
Message-ID: <20260413155839.535526403@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 86042c1f89f0b..b0afa47032104 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1183,7 +1183,7 @@ static int check_root_item(struct extent_buffer *leaf, struct btrfs_key *key,
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




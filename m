Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 401383B27C5;
	Mon, 23 Mar 2026 15:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774279168; cv=none; b=bPu1XBGZDiZMUx5CXXFg4cLE8imu8ClMLZI7eTOSVa6qKrbb7auAMFHhGB76R58wGq9osO4j9eI+7BLDCBj+VnK3TRytEX/ObLNJNs2RT9SX/6hpZUf/LW7p5jrBOuskzxBI2W/U2yDYGRcKWsCqa9Ml/qj3RCHg9yHYtNaSNoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774279168; c=relaxed/simple;
	bh=n5bLzcIlizE0YFFDik3/ko/gDAI0A3yINlFfxmFMTsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bt9UZkiNBj3NavKCZp39iF4P824NLFmOi/FSMidyvPq8Q4TDYKxu74PJhmcxuzPbYxQ8I9wqxKU5HK/JCwD37vzLzEFSQFzyAbMiIAQANyDQOzS/1pjpOMMTdojvnLy1rcA9cUANVpqhWIW6jk5Ri8PCQfiPazOBKw82eWq1gRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LPm2gz8X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LPm2gz8X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA3E3C4CEF7;
	Mon, 23 Mar 2026 15:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774279168;
	bh=n5bLzcIlizE0YFFDik3/ko/gDAI0A3yINlFfxmFMTsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LPm2gz8XP2lklmnqAo44hZHr7dnWo9enkERS9/i6XcY+UyyYTtaJz17n7shY1XTd2
	 nt3WR1qTvLVySwTl284VClpLn1SMdHu3g4Au+bxmnTgT5ijHhnmJXIWE6CM0ez3ASA
	 rrqzRlah7KhcTytJ/8sw5OCpW65kF2L2yoQoYpuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	ZhengYuan Huang <gality369@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 497/567] btrfs: tree-checker: fix misleading root drop_level error message
Date: Mon, 23 Mar 2026 14:46:57 +0100
Message-ID: <20260323134546.325821900@linuxfoundation.org>
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
index e38994ac14848..d2c36b765c83a 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1220,7 +1220,7 @@ static int check_root_item(struct extent_buffer *leaf, struct btrfs_key *key,
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




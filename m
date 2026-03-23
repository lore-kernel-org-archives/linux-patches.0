Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B2291A5B84;
	Mon, 23 Mar 2026 14:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277243; cv=none; b=qLnbSoVGBzN5SWTmFv21O5gK8hpWzCPZtetVA0caVCSlZWHH1kyGX2vdmvUca8jujQ8WlGRiENPh9NP5jdx9TK+hY1agGsGjtg10oaBHhtHch1R28zBkrRXh2RfVP/N6ulzt/2Jfv55UYjbPN8dJCxW9gjBTdzcHdTYr1zMpGVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277243; c=relaxed/simple;
	bh=NHG1LB8GWfpS/o7zY1IXhiyir4ojBWFfYv6VPChF0Tc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IlSYqXuLznL4vCpjQuZFVLzKDYffMgnq0RFrR7VDgbdt3y9PKtMUuz+k/Ad3W21sAWa4yG1QJKtv7No/ScrZ5QwXWRW83GjwLXxIg1tn6852lT1NsxSc633kjNKc+ByhQqIPK2ddG1dLWVBgBN97hWuJzk1qMeFcl6Yu5oHBlPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q8Sryeru; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q8Sryeru"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DFCAC4CEF7;
	Mon, 23 Mar 2026 14:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277242;
	bh=NHG1LB8GWfpS/o7zY1IXhiyir4ojBWFfYv6VPChF0Tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q8SryeruEZksMRWXzZrBxAXC9vceliOnHZs4/33YsLzYNomPXBBM/d8BGImN+sJa5
	 +dIen8MF0y14WcwsGTH5acAC5GHOD9hkiJGiWwUE9z6uMgPZbKpzSYwP4G0AX6jFR6
	 XZvssbBxENS/Ctev93IXQO7lN26hHtQsvTgp6kdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	ZhengYuan Huang <gality369@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 367/460] btrfs: tree-checker: fix misleading root drop_level error message
Date: Mon, 23 Mar 2026 14:46:03 +0100
Message-ID: <20260323134535.584021799@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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
index 60bba7fbeb351..7e9475e2a047b 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1244,7 +1244,7 @@ static int check_root_item(struct extent_buffer *leaf, struct btrfs_key *key,
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




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D43452D24B7;
	Tue, 10 Mar 2026 11:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141076; cv=none; b=ZdGmDeBZ3TIgYJ89gxLdSd71Q1sv5IFhWd3LQQlw4ziy6+e1IHjg6UxxfyyW9NM8R37MQzEoKGuafdCZwk1dCzwYkXqlmzW2gCf+c7SSoSN5Z2zoOTH2IBJz8LiVrPTRgIzegBkUlV9FxOyy39BqZYpSQfgabwyJdrplGH5o8RA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141076; c=relaxed/simple;
	bh=GiB2MaaIzlE6Z/0PKJCY/yI3xS7zoYboqrCEFV19s+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CSN+YhTpD857CmmScbkTKz7s440owgKRXmy30lxq25UWJJDE0ZkMExoozIjp5Ja/PH6h2gFGnBeVoSpgGieJoePdY5Y9g9HUNtn919/xC3yPc4O3GiXuqLGRG8laY0kyR2OqY6Ne+FvfXV6+RNRkj2wwMY1ZCKVji3Mo7YFnTyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pvICn5wY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pvICn5wY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D434DC19423;
	Tue, 10 Mar 2026 11:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141076;
	bh=GiB2MaaIzlE6Z/0PKJCY/yI3xS7zoYboqrCEFV19s+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pvICn5wYPkAAXoK2R0n1YOi7eVfSQ0zIPIYcYlY6FIZkYHHbTnykEbJZP6/u3zW1r
	 3mMjI/YK3le0kh6uVFaN72o8UZ/lmHdic1XkXIn24Q9jKA5AfR35Mm6+lfc/CcsjI2
	 /jlAITlQdu+p+eGZK0OvjJK9+NtUePdi8PTZGJQNx+W1IPcZElQUoslqV3d+6TrfXo
	 86T/tBCJyXcnjW5D8BW4YSMefOYi66K5TfTr+Ex9OPNF+VkAm2mqi+CAlm8s6MQ0m0
	 NWMxxRuog0fC4FmSL3b/eLgeOdNEW1iXlPAKbTpjFD11/BGrVUAPdib3BTHYMBdpUh
	 kXPTfONQp6SUA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mark Harmstone <mark@harmstone.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 076/311] btrfs: fix warning in scrub_verify_one_metadata()
Date: Tue, 10 Mar 2026 07:02:03 -0400
Message-ID: <2837485118a789d3dd19f0690f8b726e6e0154d3.1773140655.git.sashal@kernel.org>
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

[ Upstream commit 44e2fda66427a0442d8d2c0e6443256fb458ab6b ]

Commit b471965fdb2d ("btrfs: fix replace/scrub failure with
metadata_uuid") fixed the comparison in scrub_verify_one_metadata() to
use metadata_uuid rather than fsid, but left the warning as it was. Fix
it so it matches what we're doing.

Fixes: b471965fdb2d ("btrfs: fix replace/scrub failure with metadata_uuid")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Mark Harmstone <mark@harmstone.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/scrub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index a40ee41f42c68..4fc69b2d213a6 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -745,7 +745,7 @@ static void scrub_verify_one_metadata(struct scrub_stripe *stripe, int sector_nr
 		btrfs_warn_rl(fs_info,
 	      "scrub: tree block %llu mirror %u has bad fsid, has %pU want %pU",
 			      logical, stripe->mirror_num,
-			      header->fsid, fs_info->fs_devices->fsid);
+			      header->fsid, fs_info->fs_devices->metadata_uuid);
 		return;
 	}
 	if (memcmp(header->chunk_tree_uuid, fs_info->chunk_tree_uuid,
-- 
2.51.0


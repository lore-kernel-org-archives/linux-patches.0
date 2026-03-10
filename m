Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6C03876AA;
	Tue, 10 Mar 2026 11:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141934; cv=none; b=kXbT5j6PzOV6khPAoORgDprDQkr4g0qZqdpWKwUpoT4ijAHuGRYfQIO4Zp0xuphkps9seMBGHtOjN43hF72m4rWyp0N6na71eJXJysTGkA0BdInyhVDJ2+S4jzPsG9nm+ao5AWN/UvxdNzJS/Yl7k4n+Ts1bk9zRJckrWspbrsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141934; c=relaxed/simple;
	bh=WigrheM6jUcNp1Mk76i5XBilyWk/LLohj3qjcarlZXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CP/XWzyfRp171ZGUPx6yVuaAuDfrpSSXi7lv2q8Oduf9FQ2fPk48dwmG2pgcmkHRHSJg5pAUyl8xrxfQYAaEAc6jWtgmlsggLCN0tu9UgG0v7qYRN/hRzylDhgjslvCtyYNtEE3dIrZgK/6GDUHsL8wpHNxPTqfIJDgfgs7rj+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DnhSgQcZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DnhSgQcZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F13B8C2BCAF;
	Tue, 10 Mar 2026 11:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141933;
	bh=WigrheM6jUcNp1Mk76i5XBilyWk/LLohj3qjcarlZXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DnhSgQcZqkmAlrU945noOVT+XUKCMJy0H5QddGCv5R/tFfWYMlX96tacuYKCk+JPF
	 w6jznpRj5GohMzhq1s+O7avNUVuBGBxgwsmz4Uhvb1SB3loSYmuBbyFn7+wt4vRaJZ
	 3NlvREDJ50Uh1rmfDkCFVuVMbuhWgs8uLZHCWTBGXC1/CaHYfoq6mJ6XNm+VOaWui7
	 dMtfi2B7DguNC7a8yLmbiZcLWxleaN23LvQ4uUmiB86oLvC3XDfOJrcsl+ngF8If0+
	 sffV58ZkOhBqHECy3PmydWpYtDojF3beqcTISUel8u9R55WJPu5QbL1ZD3ON4TevMy
	 +AoQ9DdHo0iNA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mark Harmstone <mark@harmstone.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 057/314] btrfs: fix warning in scrub_verify_one_metadata()
Date: Tue, 10 Mar 2026 07:15:16 -0400
Message-ID: <e4adc141b01d5cc66c3dabb86b1b1abd5e9a368b.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
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
index 747e2c748376a..16936d17166ee 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -747,7 +747,7 @@ static void scrub_verify_one_metadata(struct scrub_stripe *stripe, int sector_nr
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


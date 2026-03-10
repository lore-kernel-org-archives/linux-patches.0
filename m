Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C24B3387361;
	Tue, 10 Mar 2026 11:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141935; cv=none; b=MS5CO2dRsbz8cRJoXoIN3ngtFOG9a8H0RBKXo1FYu4KKFYEpik80aU2ayCGmhpHehiyUXV+kvz4JGRyOmC2ncH5WTJq0eZGi3hW/CgmZXvRTXlNffVrZap0668aXXOl7+fFxF8W6RDETCbglUEZL1P/v+gCAIDidbsXHa86mT5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141935; c=relaxed/simple;
	bh=+lPo3gXD9wtOuArQzIoqKv3EMunh4kBhmD3duLxeMQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n7zGbo6tkwXEhxmp+hFX1wHMOMC0+3xcba2qxzKI5wYe78BYSVvEpI9aE0X7+8HEhmmXq/ThH2sNys6sAp/saKFn+V45d2J3/z4lKJpccV5lZ1giku0IuCiB/8FL4ZzwHxcmR/X5ifFekpCKtM+W2f/6L4BzGHIwfW/DIup2SnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hW6uaKBO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hW6uaKBO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0928C2BC86;
	Tue, 10 Mar 2026 11:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141935;
	bh=+lPo3gXD9wtOuArQzIoqKv3EMunh4kBhmD3duLxeMQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hW6uaKBOENexTrYJoHKU4DxLQrOwwk3QzxnvCukXaI3TDJ3cWUgcGX9cAoIp3t4Oe
	 8FGDUSbYPQ+n4s3oPLgDi9HHf/yOjuc/UZO8JxYQ/bPZyo7cvuS8L5/HcFWmyP78Vt
	 0bxj1WYBaynAzbAl3BsTJVFR/roO9bDkDWTm5pXfsECSUJc0L7+cY61xcSwNapFqfP
	 14D3iUOMUlDFBfAGi8MihIMsR4I2ts60pePdH3AZF6vF3sSzsP3CsKqczgcv+c9TXY
	 SwnF4uUTvyLTj3V7f7jnJ3uaD7RsgUaHliZjEcCmljw4BL0R4uD8jP40cIwXAS5qdf
	 Rxsue/d1D7XOw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mark Harmstone <mark@harmstone.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 059/314] btrfs: fix compat mask in error messages in btrfs_check_features()
Date: Tue, 10 Mar 2026 07:15:18 -0400
Message-ID: <7152bba0d77b18fdbf678f70b21eb54a27033542.1773141555.git.sashal@kernel.org>
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

[ Upstream commit 587bb33b10bda645a1028c1737ad3992b3d7cf61 ]

Commit d7f67ac9a928 ("btrfs: relax block-group-tree feature dependency
checks") introduced a regression when it comes to handling unsupported
incompat or compat_ro flags. Beforehand we only printed the flags that
we didn't recognize, afterwards we printed them all, which is less
useful. Fix the error handling so it behaves like it used to.

Fixes: d7f67ac9a928 ("btrfs: relax block-group-tree feature dependency checks")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Mark Harmstone <mark@harmstone.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/disk-io.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 3fd5d6a27d4c0..9c3a944cbc24a 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3160,7 +3160,7 @@ int btrfs_check_features(struct btrfs_fs_info *fs_info, bool is_rw_mount)
 	if (incompat & ~BTRFS_FEATURE_INCOMPAT_SUPP) {
 		btrfs_err(fs_info,
 		"cannot mount because of unknown incompat features (0x%llx)",
-		    incompat);
+		    incompat & ~BTRFS_FEATURE_INCOMPAT_SUPP);
 		return -EINVAL;
 	}
 
@@ -3192,7 +3192,7 @@ int btrfs_check_features(struct btrfs_fs_info *fs_info, bool is_rw_mount)
 	if (compat_ro_unsupp && is_rw_mount) {
 		btrfs_err(fs_info,
 	"cannot mount read-write because of unknown compat_ro features (0x%llx)",
-		       compat_ro);
+		       compat_ro_unsupp);
 		return -EINVAL;
 	}
 
@@ -3205,7 +3205,7 @@ int btrfs_check_features(struct btrfs_fs_info *fs_info, bool is_rw_mount)
 	    !btrfs_test_opt(fs_info, NOLOGREPLAY)) {
 		btrfs_err(fs_info,
 "cannot replay dirty log with unsupported compat_ro features (0x%llx), try rescue=nologreplay",
-			  compat_ro);
+			  compat_ro_unsupp);
 		return -EINVAL;
 	}
 
-- 
2.51.0


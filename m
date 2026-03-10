Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 944CA2BF3E2;
	Tue, 10 Mar 2026 11:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141078; cv=none; b=rADqFzcvcXOdupsFNIvMFFHXXy+E/ZH8gqjxxFzapEaPyrT17J80oTJrbtOM41m7DPfYd2cJ+KWSmj0Nsv7NOxwSQdINpPLERJxQfUCb3te4X6MbjZ06Wbmn/kYzgzmjinZL3V2y0I7WQoMaIHr99BKtw8TBsOQT9JpPgQN2rOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141078; c=relaxed/simple;
	bh=xIW4VuAjI3iz6/AfmNrjuuluYoXNKTkzjlvAsvgOZ/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jDmjf2QRxjJJLaMoZNuX0oUiXuLBhAEzXqvX7XiBwYn0mXsZgNomFXbyLNlNOZj0+gNR3qkyD5pfinATC7QsJIdOJ0TYln3rlRAwEtTApju5xCQk1+6SJFddWT9RDc7hC7h9IxEXy+AZ7clN7O1YC95tqeRywohxKrU7/iHiYFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LKJWoiPm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LKJWoiPm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBE4EC19423;
	Tue, 10 Mar 2026 11:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141078;
	bh=xIW4VuAjI3iz6/AfmNrjuuluYoXNKTkzjlvAsvgOZ/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LKJWoiPmi+SW1HmIIK30b+wbo+DCidn7MkzdC9QvBduiVwZoUODMMqWGx0B1M+8Y0
	 G0nUAHdJB+xSngPfl4IwTMW6pXk3zGj/LWhxR726R3E70PWtQoO+O3v3Q3bKb7MiQ3
	 I073EwkeEmlXA5xTAxmtXKk/suaRqk/B4/aNp0lXzcPcT2GM0ogQWTTOiz12GRhWfP
	 nj7V0duTFlu9Yzgv/NDzFOefyE8LAOjdcVKERAjW/yp7NOL/ilDX0Lv3pZtoOF2Ns0
	 SMfc45bHQ8QpWNIap4G1AFdPJ34vIr0a640L4EreMKWvvsv071y8eqZ4eO9Dfd/9CI
	 yVu/AoKjbJt2w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mark Harmstone <mark@harmstone.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 078/311] btrfs: fix compat mask in error messages in btrfs_check_features()
Date: Tue, 10 Mar 2026 07:02:05 -0400
Message-ID: <3bf0df9d66059cb3b6695f9c271b5c2ca66420fc.1773140655.git.sashal@kernel.org>
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
index 2833b44f4b4f2..6d2dcd023cc6f 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3150,7 +3150,7 @@ int btrfs_check_features(struct btrfs_fs_info *fs_info, bool is_rw_mount)
 	if (incompat & ~BTRFS_FEATURE_INCOMPAT_SUPP) {
 		btrfs_err(fs_info,
 		"cannot mount because of unknown incompat features (0x%llx)",
-		    incompat);
+		    incompat & ~BTRFS_FEATURE_INCOMPAT_SUPP);
 		return -EINVAL;
 	}
 
@@ -3182,7 +3182,7 @@ int btrfs_check_features(struct btrfs_fs_info *fs_info, bool is_rw_mount)
 	if (compat_ro_unsupp && is_rw_mount) {
 		btrfs_err(fs_info,
 	"cannot mount read-write because of unknown compat_ro features (0x%llx)",
-		       compat_ro);
+		       compat_ro_unsupp);
 		return -EINVAL;
 	}
 
@@ -3195,7 +3195,7 @@ int btrfs_check_features(struct btrfs_fs_info *fs_info, bool is_rw_mount)
 	    !btrfs_test_opt(fs_info, NOLOGREPLAY)) {
 		btrfs_err(fs_info,
 "cannot replay dirty log with unsupported compat_ro features (0x%llx), try rescue=nologreplay",
-			  compat_ro);
+			  compat_ro_unsupp);
 		return -EINVAL;
 	}
 
-- 
2.51.0


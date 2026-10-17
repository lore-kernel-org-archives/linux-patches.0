Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 995D63A257A;
	Sat, 17 Oct 2026 17:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259734; cv=none; b=EXTV4bxKYuxYo8kP1u/V17RehMc3vKlhI5ZZ6fSWD21MJrRpKUykDJt6Z7g0lVXHFaNGuAn0NCDBbZpyw8izEPfReWa/AodwE4UiEmofMxMqtbsDzIvt9qRBPnI3X7BNpxZHMX+vYr7n3mxLb8gCswCPmJOf51+/4xKqNVOGl80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259734; c=relaxed/simple;
	bh=a+imd2L9oMFjfKYn78KSNwL00foARi3A17hhBxZ3xMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CP/Kt49jww0vcsWZl1Mmd8BssLv9q3wVyMr/+ncoafaGzpxpvWlaRx+Za/ZZTkXW9rCIkUSOZIb24hmYyj8U15A5Uof3aZ3ZX9j/A9cEdq/jNpkgLvB1dKJp/Rl90/sRL1ESk/jUbi6ZsuFjiO+8+oNgpY9tUfe+EARLYf6yNIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q5AND5ww; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q5AND5ww"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFA171F000C4;
	Sat, 17 Oct 2026 17:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259733;
	bh=3DnUiTWLWD7E+qxmkbghj91g0JaEMFVRxY1Hu4bOX3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q5AND5wwIwXTZBFF+MIo3MRCPwDEA84+FBXGcZI38cbe5tTMWy2xzu1iQPao0SGbG
	 XUFzIhLwJnJ82DVFcOL9oB7zLtkaWzozN/MLx7mSy33y/0+/UK0hUOmHIBnyBxqofS
	 /tDdB0S7MIoxKkqFxNPhIDiVF5rR+moflQrhhCPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anand Jain <anand.jain@oracle.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1311/1674] btrfs: rename ret to ret2 in btrfs_recover_relocation()
Date: Sat, 17 Oct 2026 17:59:43 +0200
Message-ID: <20261017160504.795271462@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Anand Jain <anand.jain@oracle.com>

[ Upstream commit bd0d9a619a870f8c6745d2b4f57508bc5106e282 ]

A preparatory patch to rename 'err' to 'ret', but ret is already used as an
intermediary return value, so first rename 'ret' to 'ret2'.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 6d8ba4572922 ("btrfs: drop recovered reloc root refs on recovery failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/relocation.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index cba0cb87dae98..0e29da8704752 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4204,7 +4204,7 @@ int btrfs_recover_relocation(struct btrfs_fs_info *fs_info)
 	struct extent_buffer *leaf;
 	struct reloc_control *rc = NULL;
 	struct btrfs_trans_handle *trans;
-	int ret;
+	int ret2;
 	int err = 0;
 
 	path = btrfs_alloc_path();
@@ -4339,9 +4339,9 @@ int btrfs_recover_relocation(struct btrfs_fs_info *fs_info)
 	}
 	err = btrfs_commit_transaction(trans);
 out_clean:
-	ret = clean_dirty_subvols(rc);
-	if (ret < 0 && !err)
-		err = ret;
+	ret2 = clean_dirty_subvols(rc);
+	if (ret2 < 0 && !err)
+		err = ret2;
 out_unset:
 	unset_reloc_control(rc);
 	reloc_chunk_end(fs_info);
-- 
2.53.0




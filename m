Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DC0A2C08D0;
	Thu, 12 Mar 2026 20:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346687; cv=none; b=r7OVpiSVJOGODUpti54C5E6b9j2n4mHq5n0yfKPMd6JMHS0jwGINYP/8K/dRYRM6f37SxT/J4DUaLOy43UyKbiYCc8RG9zEVkhBGBXlCVKNhhER54yR898/TEMlBRTNGzK6bZ9qml4WCXQV6NySh08nXlW964ph4HTLOtd63Xbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346687; c=relaxed/simple;
	bh=iDouvmFeBY5Y2VetQ7syTvB24OI2R6ljQjRNfIVm0+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lU9yIuhUZD1MhQZ4TpAIp5H1NLqvhJyATzB4J+1M92uidMoQna1Osg0x8lHSKg9kfVcL0Br/qvoRniHI9ImSFbVKgk1Putylo24R/bKQI3aD2SqpKioHD7aTAez6i6ee1hwEAPjLasSFEsJc9MNH9LONQvnckDR0sYbzFk2xnyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YsofNMj7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YsofNMj7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55E80C4CEF7;
	Thu, 12 Mar 2026 20:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346686;
	bh=iDouvmFeBY5Y2VetQ7syTvB24OI2R6ljQjRNfIVm0+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YsofNMj7xe6exhZMPQ/n+Hy1bYWanrsanE1HTtmDl9iuXr8m3WPaxMTnkxKxG4ldV
	 cWhBaqK+vMpgTDBQD/fybGnhG6HGhXgq8YnHU1GS+zdAzT61wVsATzLs7iD5TlYXHf
	 /yUZJ3iDyN5m7El4BIDXEXyTVW307bTbGhvIrmAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anand Jain <anand.jain@oracle.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 100/265] btrfs: drop unused parameter fs_info from do_reclaim_sweep()
Date: Thu, 12 Mar 2026 21:08:07 +0100
Message-ID: <20260312201021.842041787@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

From: David Sterba <dsterba@suse.com>

[ Upstream commit 343a63594bb6a49d094860705817aad6663b1f8f ]

The parameter is unused and we can get it from space info if needed.

Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 19eff93dc738 ("btrfs: fix periodic reclaim condition")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/space-info.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index cae4ec21bab47..0470e041aba16 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -2031,8 +2031,7 @@ static bool is_reclaim_urgent(struct btrfs_space_info *space_info)
 	return unalloc < data_chunk_size;
 }
 
-static void do_reclaim_sweep(const struct btrfs_fs_info *fs_info,
-			     struct btrfs_space_info *space_info, int raid)
+static void do_reclaim_sweep(struct btrfs_space_info *space_info, int raid)
 {
 	struct btrfs_block_group *bg;
 	int thresh_pct;
@@ -2128,6 +2127,6 @@ void btrfs_reclaim_sweep(const struct btrfs_fs_info *fs_info)
 		if (!btrfs_should_periodic_reclaim(space_info))
 			continue;
 		for (raid = 0; raid < BTRFS_NR_RAID_TYPES; raid++)
-			do_reclaim_sweep(fs_info, space_info, raid);
+			do_reclaim_sweep(space_info, raid);
 	}
 }
-- 
2.51.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C4201C0DC0;
	Thu,  6 Jun 2024 14:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683558; cv=none; b=Dzu0sApqkQSaRYDg3PmK31MGa0130YukZBrtIllvrOTa4oHGEAuDbuM1/j9URe7s6d6hFBVYmHcMV6MDKPugLQcyt8NyXC+8gjip0lj9WJvG9WQVKEtBEDv6vrTaNc9KL5Xp7DXNsOaveWpy2VaudJM1QOKYFFMjdVtcO2XMjm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683558; c=relaxed/simple;
	bh=31x/cBW2r5Tm/ZAiJIDy599WR2A/NvK72YA5JLfQ4fI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pnERL5P+HfIkdo6IbXWwGjzbrHJQ+zmxTfjv4qnObFkyiFlnK+6YT4Il5B7j7UG8smClZ/t1muRw6/i2tBxCjsT8dC9ARTQD2KdDyzY7zIHzOh5fMsKgHAPQEWB/3D/S0Vz6ks7/X5F6THhssySwxERJj1V682LPyK8a9gcbI88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NGOeiheA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NGOeiheA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C941C2BD10;
	Thu,  6 Jun 2024 14:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683558;
	bh=31x/cBW2r5Tm/ZAiJIDy599WR2A/NvK72YA5JLfQ4fI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NGOeiheAy0ug0NW77WDBbajlUlSCJn94DHhoEdhHtl/AqBwDn8Cw8cALkIXbT5qdU
	 oO5CeFy6yCUIg7v0BspjXmYTGODZv4MwD17QuiBnd1LkLVz6RqqIFhUgpdtSC4XFdt
	 p84AvVnIQ7i4YRVQaQhIeetz0Jo3yg+ZjlOkWpnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	KaiLong Wang <wangkailong@jari.cn>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 500/744] f2fs: Clean up errors in segment.h
Date: Thu,  6 Jun 2024 16:02:52 +0200
Message-ID: <20240606131748.476829432@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: KaiLong Wang <wangkailong@jari.cn>

[ Upstream commit 37768434b7a7d00ac5a08b2c1d31aa7aaa0846a0 ]

Fix the following errors reported by checkpatch:

ERROR: spaces required around that ':' (ctx:VxW)

Signed-off-by: KaiLong Wang <wangkailong@jari.cn>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: aa4074e8fec4 ("f2fs: fix block migration when section is not aligned to pow2")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index 20580ebd24138..c77a562831493 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -108,11 +108,11 @@ static inline void sanity_check_seg_type(struct f2fs_sb_info *sbi,
 	((sbi)->segs_per_sec - ((sbi)->unusable_blocks_per_sec >>\
 	(sbi)->log_blocks_per_seg))
 #define GET_SEC_FROM_SEG(sbi, segno)				\
-	(((segno) == -1) ? -1: (segno) / (sbi)->segs_per_sec)
+	(((segno) == -1) ? -1 : (segno) / (sbi)->segs_per_sec)
 #define GET_SEG_FROM_SEC(sbi, secno)				\
 	((secno) * (sbi)->segs_per_sec)
 #define GET_ZONE_FROM_SEC(sbi, secno)				\
-	(((secno) == -1) ? -1: (secno) / (sbi)->secs_per_zone)
+	(((secno) == -1) ? -1 : (secno) / (sbi)->secs_per_zone)
 #define GET_ZONE_FROM_SEG(sbi, segno)				\
 	GET_ZONE_FROM_SEC(sbi, GET_SEC_FROM_SEG(sbi, segno))
 
-- 
2.43.0




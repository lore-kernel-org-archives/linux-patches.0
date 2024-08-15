Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FFD919AA53;
	Thu, 15 Aug 2024 13:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729601; cv=none; b=sHhDRyY7MgF0fWI1IjnSdNAD6U4wv2/183p8sEhPOywkiooVaGiaev4+p4NuVVn/WWhsiB0bvS3/NtP6jAUZGKk9usctEbUNxVZRNdFOL8BeXncXS4UftD8zcmEquyeKlN8QO1PxJw217FlSEgh2LT6Hq5jlFIOzyTnZaKbxkOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729601; c=relaxed/simple;
	bh=PRaG0iA5flKv/MsJFPPb6AY5pfQDvNTslTswnSwwUJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gIEX873MKSOh/idzUmcv2WENiDSgw2JajySMRVaENrCOHgt53gEv59fXdgrpUtOARE8uPumoAmWOFAQuY4vkzsJCD3eOuj440+vtYv9Ded+OKC6bv0uqR9lL6sksNiJK5qT/8wo5VVxc6eyCEBI1gzSTv3fV8yRzLrqkpplXunI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SHr7jZpW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SHr7jZpW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A95BCC32786;
	Thu, 15 Aug 2024 13:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729601;
	bh=PRaG0iA5flKv/MsJFPPb6AY5pfQDvNTslTswnSwwUJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SHr7jZpWA2vBq4p3uyOW8ESq3c68HU3peLBX14egvVh4hy7N0odOxeKTpWwVI/v/R
	 OM8dqvdY9+LdWKxyqH9bmjsJYxw1rjlVtfVC+KK6ZcL6UN6gAfqShzO0FPPoC2evg9
	 yA5szm2Y4bL/FlhkwmgAEWsysn7aVDukJeyRWeDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 149/484] fs/ntfs3: Use ALIGN kernel macro
Date: Thu, 15 Aug 2024 15:20:07 +0200
Message-ID: <20240815131947.172075007@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 97a6815e50619377704e6566fb2b77c1aa4e2647 ]

This way code will be more readable.

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Stable-dep-of: 25610ff98d4a ("fs/ntfs3: Fix transform resident to nonresident for compressed files")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/fsntfs.c  | 2 +-
 fs/ntfs3/ntfs.h    | 1 -
 fs/ntfs3/ntfs_fs.h | 2 ++
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs3/fsntfs.c b/fs/ntfs3/fsntfs.c
index 1b082b7a67ee2..4bd3e6718ee65 100644
--- a/fs/ntfs3/fsntfs.c
+++ b/fs/ntfs3/fsntfs.c
@@ -475,7 +475,7 @@ static int ntfs_extend_mft(struct ntfs_sb_info *sbi)
 	struct ATTRIB *attr;
 	struct wnd_bitmap *wnd = &sbi->mft.bitmap;
 
-	new_mft_total = (wnd->nbits + MFT_INCREASE_CHUNK + 127) & (CLST)~127;
+	new_mft_total = ALIGN(wnd->nbits + NTFS_MFT_INCREASE_STEP, 128);
 	new_mft_bytes = (u64)new_mft_total << sbi->record_bits;
 
 	/* Step 1: Resize $MFT::DATA. */
diff --git a/fs/ntfs3/ntfs.h b/fs/ntfs3/ntfs.h
index 324c0b036fdc1..1197d1a232962 100644
--- a/fs/ntfs3/ntfs.h
+++ b/fs/ntfs3/ntfs.h
@@ -84,7 +84,6 @@ typedef u32 CLST;
 
 #define COMPRESSION_UNIT     4
 #define COMPRESS_MAX_CLUSTER 0x1000
-#define MFT_INCREASE_CHUNK   1024
 
 enum RECORD_NUM {
 	MFT_REC_MFT		= 0,
diff --git a/fs/ntfs3/ntfs_fs.h b/fs/ntfs3/ntfs_fs.h
index 12a3b41d351c9..e67bef4018079 100644
--- a/fs/ntfs3/ntfs_fs.h
+++ b/fs/ntfs3/ntfs_fs.h
@@ -198,6 +198,8 @@ struct ntfs_index {
 
 /* Minimum MFT zone. */
 #define NTFS_MIN_MFT_ZONE 100
+/* Step to increase the MFT. */
+#define NTFS_MFT_INCREASE_STEP 1024
 
 /* Ntfs file system in-core superblock data. */
 struct ntfs_sb_info {
-- 
2.43.0




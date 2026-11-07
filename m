Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060831;
	b=ghijXzGy9RaYvSEZiTpNS/L6YcCAbKa3WM7g1IkES6n3Qvmri0W8gtP+BdH4IJO/T0NW
	 YPltvyh6grrn3/yGnrHodyuwHrd8m+fKZ3Nxp0u7wy9QCaAkvcy2/RGZ7XdkHBss4425/
	 z8XGtvhbVJmz6kwfg90L2u0xGRvM+JZwvgZt4a20TQObIY1oD2ZgH7GRAf4P9gRNZfuUP
	 PgCsnCqvYRdWEZDs38jRHOk3TnznDBZXXoR7ecQ3b+HaV01V+8aynOlxfjrTb59Eg6YF2
	 +v4UHvs6uHjfRzSNa/wr/oMybJSpIL9t+ReSo25vXP7p5gqGoWX5JVgkfQJaFWfy+/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060831;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UCqoZzOd1yucDaGpuVfnuX5dsisSjkCMZpSMHJFWBe0=;
	b=NS+x+ruhy5R+Z5Sp663V+n9UeF+kqKMXmShtgCyNUGhkwNPfivr6yOxjlBwicUMHN5yQ
	 QnnXVl4E3BhdwEA7VaViYycIrzNAXmKoFBgwvwP7vvvDQhjUbMuVf4XH/KBauvBmf/CZD
	 hn49rRZPe39hk1o8zFPXyoQXCJmxrKqs5rfh2ZUiCMycln0WpZb/8JnVlS2CJ8VqFufsS
	 2q4uQgsvG1yCox0JbmqSLsTpx4nAZccMm7wy921Tj+ijvyw4oaUieIxsvnxvSH2Rr6/Ko
	 1HAN+Zxzq7/tgmLiD1u2kBHLZzH/4QOM391vEYMk/My5VXWa9zQ8NdsWds/zvS3LUtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xLGTECpG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B360606D801;
	Sat,  7 Nov 2026 14:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xLGTECpG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB1D61F008A3;
	Sat,  7 Nov 2026 14:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060830;
	bh=UCqoZzOd1yucDaGpuVfnuX5dsisSjkCMZpSMHJFWBe0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xLGTECpGkuBGzU+1eMy+EkWgwt54Nvex8vWtYEq9yrUxFKxp3EqWohBCJd4oJTnez
	 Hqfuk5RPiffd/CqjtSiWknNRTdq1o/vgEzmdsKZxCOtFCCHOX84hsEnfk4hpm2NKrQ
	 89/8oLhtHfQAfMV7+f1hZNdAC78dbPKMhv2e56vc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Senjin <senjin@hatchling.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0207/1536] fs/ntfs3: load ATTR_BITMAP run extents from $MFT extension records
Date: Sat,  7 Nov 2026 08:37:03 -0500
Message-ID: <20261107135003.470148014@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit e31886cb6e0e14cf65e27da0bf1a422ff419d893 ]

When $MFT's ATTR_BITMAP attribute is heavily fragmented, its run list
can span multiple MFT extension records (attribute list entries with
vcn > 0). The non-primary segment handler in ntfs_read_mft() only
processed ATTR_DATA extension segments for MFT_REC_MFT, silently
skipping any ATTR_BITMAP segments. This left sbi->mft.bitmap.run
incomplete, causing wnd_init() to fail with -ENOENT when wnd_rescan()
tried to look up a VCN not covered by the truncated run list.

Observed on a 16 TB NTFS volume (0xFFFFFEFF total clusters) whose MFT
bitmap run list was split across 97 extents in extension records.
wnd_rescan() successfully looked up VCNs 0-122 from the runs loaded
from the base record, then failed at VCN 123 (the last cluster of the
bitmap) whose run was only present in an extension record.

Fix by extending the MFT_REC_MFT special case to also handle
ATTR_BITMAP extension segments, storing their runs into
sbi->mft.bitmap.run the same way the primary segment does.

Signed-off-by: Senjin <senjin@hatchling.org>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/inode.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index e7339f2bc5fd1..b371f897bcf4c 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -126,10 +126,16 @@ static struct inode *ntfs_read_mft(struct inode *inode,
 
 	if (le && le->vcn) {
 		/* This is non primary attribute segment. Ignore if not MFT. */
-		if (ino != MFT_REC_MFT || attr->type != ATTR_DATA)
+		if (ino != MFT_REC_MFT)
+			goto next_attr;
+
+		if (attr->type == ATTR_DATA)
+			run = &ni->file.run;
+		else if (attr->type == ATTR_BITMAP)
+			run = &sbi->mft.bitmap.run;
+		else
 			goto next_attr;
 
-		run = &ni->file.run;
 		asize = le32_to_cpu(attr->size);
 		goto attr_unpack_run;
 	}
-- 
2.53.0




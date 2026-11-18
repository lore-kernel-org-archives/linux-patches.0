Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051230;
	b=PBpLn4BByksH0+JEhHL3lrctJ5FVSKzhagO84KAjEZ72YStu+XBA9UOJT886uZEySHRQ
	 RiSrQgS7Ii3DLb2KNTouUPeNI+n2s4ou0yAQbIDWjR8hTMHeVi734UOqnMTypBCjR0cnH
	 lilkkmB6E+C55g7UZeyc4Clk/uHHFmtM0a/guF98rInf0CjAgAmnVKbbZiN4+1XNdF9LA
	 UrhzQx/dCCIdNMA+BuiLK9wuZ2bmUq7UaU/gjJBMoRH3fW+r8DI3NNJ7Xto3Cfb4Dlzmu
	 jKznwIPSYh9BpcTEr/n9mZMLmRnjqzQrTzen0eM+5JcPGuhs7zQqpvYwlz7c/GQs3IA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051230;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NtKPOrnPqi0zfWNqADlKHFoelHFtUK9fE6x261SkFBU=;
	b=k74w2Qf6xSCekj7gHv4st1AWKZuXMaFepLudJAgr8GkPo4O2rm17AokV4VSfufOg0Bj4
	 aKqDfJL3LWg4DZanp3KBEcyhD4bKZuDU7DecWcrhQ/Ep3Qqsa2/lewHLQ1Mi5NCpDr1CM
	 J+vyElXaQhV16o+C/lsNkE/8cV9NYbKF1NbO5UfCttVF5VSvSYg7DATJhZ7vGLIzSsbFJ
	 Z+8TEogMSIWzXXMpZSV2gjpqDEVGKNNO0KkA/gSVSwAPjBy4nB3tAZ74XiMwLP/lwt6rO
	 EKla3gt5VEDZu2Yp7Fe/+bKgFomMGmo4l6Tc3EqKyp3H3jMbLCoCKhXIEyZG64AdG7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BRz9VFH6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49841606A325;
	Thu, 19 Nov 2026 01:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BRz9VFH6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96C9B1F000C4;
	Thu, 19 Nov 2026 01:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051230;
	bh=NtKPOrnPqi0zfWNqADlKHFoelHFtUK9fE6x261SkFBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BRz9VFH6CMCZnj2WBmRxgENewUTO1uLeSuDD+qEGNuw0cBcxs0Dws+jAIgNe7Y3Xv
	 vwRgVZqV1oMoR8ohTq4ZK1dBPCXgDAtAn/rMgP8eQJc8APtwPYvdWW7Eaxboe6Rd63
	 EBj529gl0CkLn0gvyn2vwuSJmaF1C88RpsUve70Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Senjin <senjin@hatchling.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0136/2214] fs/ntfs3: load ATTR_BITMAP run extents from $MFT extension records
Date: Wed, 18 Nov 2026 15:30:12 +0100
Message-ID: <20261118150015.636834818@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index acd5be0d36c0c..bccfd60db7de7 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -125,10 +125,16 @@ static struct inode *ntfs_read_mft(struct inode *inode,
 
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




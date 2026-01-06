Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5CE435503E;
	Tue,  6 Jan 2026 17:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720315; cv=none; b=LvlcFFfqWlvEEdvNW9ah8Q7CjwdZ2mihrrxz7KkKAGnRJTOuxYZDEnrrmr2R2T6WsjGRg73SHw6+ODLAqe/3v40gCOevS+jBc509OsG43wBj10nEsHmINKuSicn8p0H0icGwlczARKjowBksAFowiEzuiHzlWojVt6NRZUrBYLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720315; c=relaxed/simple;
	bh=aFR0hgOS2iuSnYbCGweYZGhK9UYksbFKYtoSg9LijEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HaqZ/nkiXecEIaRBIvxxcI8hf9dtQ+yTgltyYDOB8Z/7CuHPaKDp3W8tm/CM29MsMWDotpmIUtqPwWQZBOaeqQoKxW2EZkm6+gmmh+KTyUHid0+bbLt3ejlQygXg7OqC95PSg8uIVH6so291I1HGpr1NYSyK7gwrnrJUOI0YBB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eTBq7m0u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eTBq7m0u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 270ACC116C6;
	Tue,  6 Jan 2026 17:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720315;
	bh=aFR0hgOS2iuSnYbCGweYZGhK9UYksbFKYtoSg9LijEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eTBq7m0updT2rIW+1ewuhUBQyTIOI043chnx2ks00n0176lg/pb8Rn9W4J3ORvV5B
	 skAcd4B4iC0yo9wJAlku5RE+c62496oOcwScUYvlibO0YUsY7NSPpqwnqdClsvSSqJ
	 Am1Y8i0QvK60dvU9McuEy4AhF/aG0rmWSgKJjqEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <dai.ngo@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.12 199/567] NFSD: use correct reservation type in nfsd4_scsi_fence_client
Date: Tue,  6 Jan 2026 17:59:41 +0100
Message-ID: <20260106170458.685615765@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Dai Ngo <dai.ngo@oracle.com>

commit 6f52063db9aabdaabea929b1e998af98c2e8d917 upstream.

The reservation type argument for the pr_preempt call should match the
one used in nfsd4_block_get_device_info_scsi.

Fixes: f99d4fbdae67 ("nfsd: add SCSI layout support")
Cc: stable@vger.kernel.org
Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/blocklayout.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/nfsd/blocklayout.c
+++ b/fs/nfsd/blocklayout.c
@@ -341,7 +341,8 @@ nfsd4_scsi_fence_client(struct nfs4_layo
 	struct block_device *bdev = file->nf_file->f_path.mnt->mnt_sb->s_bdev;
 
 	bdev->bd_disk->fops->pr_ops->pr_preempt(bdev, NFSD_MDS_PR_KEY,
-			nfsd4_scsi_pr_key(clp), 0, true);
+			nfsd4_scsi_pr_key(clp),
+			PR_EXCLUSIVE_ACCESS_REG_ONLY, true);
 }
 
 const struct nfsd4_layout_ops scsi_layout_ops = {



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E4673D348B;
	Thu, 15 Jan 2026 17:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499479; cv=none; b=kaY6c8NhCQKqJeckMmClXZXFCZzUovM9DshCJQStHnHxYscYYoy5rqzW7g2J0lmPlstSHH/xfZvDM0bIuvL/oMbh3ZuBkJuAAEsCkRXG/MwqHxeWoc3optHAvjs75BsBXxTrWdSLSaqAkMattoAQBc22INd5TMKa92GErIRs558=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499479; c=relaxed/simple;
	bh=8pcQWL6WMULg7KE45SZI9B3cTNkNAsDIsT+jlIvUANY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o5ntQAwATlRA28o0HN37fnRKK2VvISzYb2FsmqbOKEKV6VpHQciuBJYsaN6FL9RfzNWOS6o0XR6XGBXapBLL+PdpR07/PHmYjx9moxg7jLnEnqguzPdUkHo3izq7zlHIIkjLU6KPQokpD58N6n+GGLriQh9cRxG4A241RfjrtXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eMbdyV2/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eMbdyV2/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6B93C116D0;
	Thu, 15 Jan 2026 17:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499479;
	bh=8pcQWL6WMULg7KE45SZI9B3cTNkNAsDIsT+jlIvUANY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eMbdyV2/iz/fqQ3VdIW7HfeX54enukUwKE27s0aXih8FPwO5RmTVhDibrOhZQUrPP
	 oZptWUDlStYbF+mCW7QepfdJZbHPiBSgXKnetmXy20n4BZvRccdqX3FvfnDSviYFKM
	 WQNKHwoAFStejANO0gRTrIzu8FTWqKwqIUTeQojE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <dai.ngo@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.10 242/451] NFSD: use correct reservation type in nfsd4_scsi_fence_client
Date: Thu, 15 Jan 2026 17:47:23 +0100
Message-ID: <20260115164239.647668868@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -410,7 +410,8 @@ nfsd4_scsi_fence_client(struct nfs4_layo
 	struct block_device *bdev = ls->ls_file->nf_file->f_path.mnt->mnt_sb->s_bdev;
 
 	bdev->bd_disk->fops->pr_ops->pr_preempt(bdev, NFSD_MDS_PR_KEY,
-			nfsd4_scsi_pr_key(clp), 0, true);
+			nfsd4_scsi_pr_key(clp),
+			PR_EXCLUSIVE_ACCESS_REG_ONLY, true);
 }
 
 const struct nfsd4_layout_ops scsi_layout_ops = {



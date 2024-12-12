Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCAD1221D88;
	Thu, 12 Dec 2024 15:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018390; cv=none; b=r/X8VowuMIAyIv2WnEUStyHPUcT2ozsEGJI1FZhTjJArZ/HpYIKGvvQmPKIfJvd/o08uPnkmfT5F1ly/N5HCfAxUW1OO7yqITWYWOVftrB4F2BPE+bUkfBpdZOiJEZO7zkfGpyPXbKRndRaUjisireg1o5qry+++L7xe7nQrKDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018390; c=relaxed/simple;
	bh=AYzzhv64X5kJdXf1kHDVRH3tmcDBbFCxw8egReGTy6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=epEgd7tHw3JhzZ0Vs1D+MwQNY6BNZfOR4YTCV+hTdY13Ns/6cWYag9aX6+KNBBlmL4VgQaDu2xwsafv8wwZ20DU7Oo+tp5JjuIw6uWOWobUF5weNFI/16Z/gkVNbFVdWPc3iT8wUFxw81rOFW6aJLsd/vxHipsS+17K6JlZGLfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W+4lHQAR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W+4lHQAR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30B2BC4CECE;
	Thu, 12 Dec 2024 15:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018389;
	bh=AYzzhv64X5kJdXf1kHDVRH3tmcDBbFCxw8egReGTy6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W+4lHQARbiijCo50dONDlxN5GoG5ck3d0BfaO3mKnftA7F8FMEE38ySxR2SZz9qsz
	 BDRlOc+DKfEllIaN4a+gRdXr2d5Uj6zTU6I88D3vXgfKEyxciqGaDic+fpRd3aE7CB
	 h+izj9hNAOWlJbMgbd4V2stZDA6w7wVvehjnyyDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	John Meneghini <jmeneghi@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 279/356] scsi: st: Dont modify unknown block number in MTIOCGET
Date: Thu, 12 Dec 2024 15:59:58 +0100
Message-ID: <20241212144255.606039144@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kai Mäkisara <Kai.Makisara@kolumbus.fi>

[ Upstream commit 5bb2d6179d1a8039236237e1e94cfbda3be1ed9e ]

Struct mtget field mt_blkno -1 means it is unknown. Don't add anything to
it.

Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=219419#c14
Link: https://lore.kernel.org/r/20241106095723.63254-2-Kai.Makisara@kolumbus.fi
Reviewed-by: John Meneghini <jmeneghi@redhat.com>
Tested-by: John Meneghini <jmeneghi@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/st.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 212a402e75358..1537f4a9347f9 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3757,7 +3757,7 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 		    ((STp->density << MT_ST_DENSITY_SHIFT) & MT_ST_DENSITY_MASK);
 		mt_status.mt_blkno = STps->drv_block;
 		mt_status.mt_fileno = STps->drv_file;
-		if (STp->block_size != 0) {
+		if (STp->block_size != 0 && mt_status.mt_blkno >= 0) {
 			if (STps->rw == ST_WRITING)
 				mt_status.mt_blkno +=
 				    (STp->buffer)->buffer_bytes / STp->block_size;
-- 
2.43.0




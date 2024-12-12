Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBACC237FD9;
	Thu, 12 Dec 2024 16:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021323; cv=none; b=CEQqml1Ia35R6MFobuNrs5AMu4lQzqDSL0GhjWtB1JvrgvSwMGFjnlEuvTZaKi05Mbh+rwupRlj+XHRJLq8ogQzZikbvVC8BQzgfUL3YXiQWBISwobDZ8+qjB6J7ZNfGnOaKbLs9JKxFhV+i+zjR7SyRqyAPKUh61njZsWkN648=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021323; c=relaxed/simple;
	bh=zOG+oK5GDsOSmqZGLrNLmN2i+BaPtAxlgpJqxnD/Jjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PoOW5rEu7nohibRhY5IKTqTMaK1wB8u7lrHEdq/+2fpOWbNwrm/NWOi/Oqt8Af1IbQ4cL+rMD9vpCGfnZrv3324fzIiaDfaOSHwimDtio08WohsVDPS+upl4mSjg8bJc02gFVnkDlltmdDny4DV37mTTiyeKmvs3q37XOfvLkl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YapVX2hG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YapVX2hG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A65DC4CED3;
	Thu, 12 Dec 2024 16:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021322;
	bh=zOG+oK5GDsOSmqZGLrNLmN2i+BaPtAxlgpJqxnD/Jjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YapVX2hGEIsoN2urUee08SYbAG0f3J67MqKVK+/ZPFH8DojOoh40nWVHNfwlFJx+U
	 BAxm6X2fJI82eJjzRRsLqSGRwHSoe66jzbPnGY+3/f/45zVtmuo6RqWB2cajkjZC0Q
	 cCdd7ZvouxTJSL3WBkLJyH2wt19SE/vPOcCId+MY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	John Meneghini <jmeneghi@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 706/772] scsi: st: Dont modify unknown block number in MTIOCGET
Date: Thu, 12 Dec 2024 16:00:51 +0100
Message-ID: <20241212144419.071116160@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b90a440e135dc..b91da7b51814a 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3754,7 +3754,7 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
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




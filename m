Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E0DC6F2FE;
	Thu, 12 Dec 2024 17:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023477; cv=none; b=SXKqKVtGZn+EhPoe3e2gpelwHz7nkonE7wfyq7QSipf88zpQ6HJ7IvzXNgMGwCDf8MvV7r80tb2b8S6sPO7Prx1oKIeVJPYni8Yog6fnI700u5VqKQgVTmxyNf57V9ru1nlmMaFokzMN8fl34vj2YguHMdtMOkSawab1QLTVLe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023477; c=relaxed/simple;
	bh=7gmRY4YzHptlsWreRWFe4Sn0ifOfrhGOzBSDxu28XnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=haLBxvUUkw9QKJ5qEWqu+5xzXunWf85VjfwUBzG0nXnUtj3Ums9cUIxyDOlworxp4HUfSWQ+PgISqgKro/XT9oq72kNnoAcb+9N1fpnsxyaN5uBy2tLojTfC8HLevRdwBPswpUJZEpBaIdeHGPlRw+XfSVj4H19E053TtuF+EkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cHCDVQid; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cHCDVQid"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CA5AC4CED0;
	Thu, 12 Dec 2024 17:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023477;
	bh=7gmRY4YzHptlsWreRWFe4Sn0ifOfrhGOzBSDxu28XnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cHCDVQidNGtVPPULImpiw5aJssFL0JH5x5e0Q+8jnlVBFpjNTU0W19u+W3VVpKCM7
	 rg8REbVIgTd5jgc8hftZm2sGletNrjSvZU+MJ/C3kkGP9Yw9amo68VdnVzCMhUiGSn
	 XORulyWF6Xq0BETRT3ZxQklz4ckECGi1W+gtoqhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	John Meneghini <jmeneghi@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 516/565] scsi: st: Dont modify unknown block number in MTIOCGET
Date: Thu, 12 Dec 2024 16:01:51 +0100
Message-ID: <20241212144332.190007083@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 9933722acfd96..861038a1cbd48 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3751,7 +3751,7 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
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




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01536209693;
	Thu, 12 Dec 2024 15:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017083; cv=none; b=YArx7l14gCJxJUp3U8Sxv6Hi+29HEst/a5H5qkL3Lvid6XZv8q2mL6hnIAHhYyyD4U0Z3MYr+qRUep2Dy2O3xYn3qhGskN3liX17XXayxYdFcYZ/hP5Mnu+CGL4onSJlqP6s50zVxusjU+SoxAKVMKeP4RVWL0bogd+ra7coxis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017083; c=relaxed/simple;
	bh=fzr003U5GurNELQj/sfGKiAIZZ+4RabXs2DUz/sRE0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mP4d90KndHD2/oUC4JL0VRlswO2aipKgztK/RDF550WT14OoQViatYovmaei0NeGvVo+QFHuT5R9YkS6mBwLOkCKWlN1iIUTXd1pW2utMS8p+ZfWOTkJMb2fGQ1glM3zvXeGRg8lMv0ZLzYHxjymkP7ujt3kelGaGac8hyQHjOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g5Scxe9I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g5Scxe9I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B669C4CECE;
	Thu, 12 Dec 2024 15:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017082;
	bh=fzr003U5GurNELQj/sfGKiAIZZ+4RabXs2DUz/sRE0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g5Scxe9Iq3fMppYSkSsiQta6m8C/9SFTrs2RmSVE38Vv4pEgooCk7u/lAXKwvt+ra
	 WstPtUwrBbc2UL78yDWI5oBIUd/BH3qX9yHbjn5uVg9RdFD+TVmcMiVo/PQeWLIO51
	 kD5dkrzAfCe2s1cvBS0AO4Quqh3fT4cSWsMMPU78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	John Meneghini <jmeneghi@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 377/466] scsi: st: Dont modify unknown block number in MTIOCGET
Date: Thu, 12 Dec 2024 15:59:06 +0100
Message-ID: <20241212144321.668378596@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index beb88f25dbb99..8d27e6caf0277 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3756,7 +3756,7 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
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




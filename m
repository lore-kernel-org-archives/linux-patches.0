Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E98E38F631
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302202; cv=none; b=QWyx9UYoGrxDyQ1vbK3skpVunR3OpcActuao47pxwgXmPoRnH/vHqGDe5iIiz3zPPPiulRIjj7LwXOLrmZ0LNqiRaUeIJZhvcZkNZjjKV/w614eolyGGARTxUsfDaTQgKo3MglLKyEthOckhLbuf02boc/fEfyeUyqPbV+yHe8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302202; c=relaxed/simple;
	bh=QBseQC6NLecqCS/kqBdFVSv55rxQ7Kmy1PSv2p/dTgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OaSJMjtbiQtj/yXekrUtTy5IHc0+7s6eMmVi1Ttgc5JBcRD0kcdLK6MT5uceYDO/POFWfe+Y5kXHr0iq7Cz7fOt1UfUOiguo83i52fcTgyrVT00ToLikTKEHxMnJPASUI7RApXHtz/ugaNaco+kWZ/n2g6rUJEtlcNX3Nc3A2i4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vHjEdNJ4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vHjEdNJ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DCA0C116D0;
	Sat, 28 Feb 2026 18:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302201;
	bh=QBseQC6NLecqCS/kqBdFVSv55rxQ7Kmy1PSv2p/dTgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vHjEdNJ4zEsuhPvh7RSsRtrxCYv0t9KIsSB63C4L9z0bBxMVWj4AldF9EKIJtSLaU
	 81nM5v06sZiax6Ep4nxA+YeyRkq37a8/IhfZ+XHj12G/Z/RnzKZhuK5ZHyqsxrqm/5
	 CRB0QTSMO4k4MmZvX56E3jtC77ysOTjmxqwYKejd57/rwyeyChVqq9lwO2kA/PEcVP
	 sCgYoBP+62kup7M4yWWss1uIjXGRdXgVY7EtAQki4fC+ezXO8v8ZbVC1egcTgOmcfq
	 vrwPoap1K+RnsMw2vz0pZmIbnDHpEqIqhgpclr/vvFHihIXqmM0YgUNvhIi1QeGJHT
	 mDamG1xGP9NjQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Colin Ian King <colin.i.king@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 206/283] scsi: csiostor: Fix dereference of null pointer rn
Date: Sat, 28 Feb 2026 13:05:48 -0500
Message-ID: <20260228180709.1583486-206-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Colin Ian King <colin.i.king@gmail.com>

[ Upstream commit 1982257570b84dc33753d536dd969fd357a014e9 ]

The error exit path when rn is NULL ends up deferencing the null pointer rn
via the use of the macro CSIO_INC_STATS. Fix this by adding a new error
return path label after the use of the macro to avoid the deference.

Fixes: a3667aaed569 ("[SCSI] csiostor: Chelsio FCoE offload driver")
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Link: https://patch.msgid.link/20260129155332.196338-1-colin.i.king@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/csiostor/csio_scsi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
index 05e1a63e00c3a..ed40ae6b9800c 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -2074,7 +2074,7 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
 	struct csio_scsi_level_data sld;
 
 	if (!rn)
-		goto fail;
+		goto fail_ret;
 
 	csio_dbg(hw, "Request to reset LUN:%llu (ssni:0x%x tgtid:%d)\n",
 		      cmnd->device->lun, rn->flowid, rn->scsi_id);
@@ -2220,6 +2220,7 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
 	csio_put_scsi_ioreq_lock(hw, scsim, ioreq);
 fail:
 	CSIO_INC_STATS(rn, n_lun_rst_fail);
+fail_ret:
 	return FAILED;
 }
 
-- 
2.51.0


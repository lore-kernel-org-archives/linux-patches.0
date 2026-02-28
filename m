Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2ED935AC0F
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302744; cv=none; b=neENkW5UUeRqjZ/5VV49gO6lBdF2ZG8hlMiYB+Qx+mdiYHNjiQJ21/uKNYG6bNl9kamrI5+bUiaB82Pl/rL7BiOZp2+9XSUoxfmgetrJcnxpA4xTPBs3YV1Y5T6zeKvEmtX+Bd8yasc4jhVS2ixI2aGVtladYKN9V5nyY47b6cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302744; c=relaxed/simple;
	bh=qPejHU/kDQpnomFZCQVS1txPK6JsuVwFsG5U9jObWZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U9+Ve9ppRsVpTmxQ/wdgBYCWldTSddrJt2GzygKU9qOgIiPyYTjqV7VuA3j7dxXqR6mXfEAEz+HOisXDd/eLvDu6RSjQni6N4j5K75xz/EC2QAcUd+3ZGRN4fkCCEP4V/ZkqyuVJbXvqxbHQnHq5gA0aDf5WU5cwiNVEMqq8skU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gQ1qrHND; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gQ1qrHND"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 348B0C19423;
	Sat, 28 Feb 2026 18:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302744;
	bh=qPejHU/kDQpnomFZCQVS1txPK6JsuVwFsG5U9jObWZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gQ1qrHNDg//5VkNXscwpGOoLRhk8XZHwJaDSHckveUikON0ttCBwhDqxJ5tZLcBHs
	 fxSW4chI4jtCWwitHEIf7BrgUauYAdCkfLcrc71BaOdE11vAluxTywjJ15ph/iGQxu
	 0FgGHIz2oK6jQS0bSu1IG1b8APKrc3sFjPNifro3Y1CI2meGrY1limkspOAnOQdDGr
	 U6mpg/rSHW5xksnuGrVylvT6Aen9kjiM/7oCCwjKlIrMT2GLnsFKB/l6lW3IqzRn10
	 Rn7PiryCc2jWhsmRgcqZ3blhmeObaSG3vbHfQzO1qAe4p60aultghpVrJ2HgFdEC5x
	 ON8s0E4iGPK6Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Colin Ian King <colin.i.king@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 111/147] scsi: csiostor: Fix dereference of null pointer rn
Date: Sat, 28 Feb 2026 13:16:59 -0500
Message-ID: <20260228181736.1605592-111-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
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
index 55e74da2f3cbe..e320ca2911e0c 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -2070,7 +2070,7 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
 	struct csio_scsi_level_data sld;
 
 	if (!rn)
-		goto fail;
+		goto fail_ret;
 
 	csio_dbg(hw, "Request to reset LUN:%llu (ssni:0x%x tgtid:%d)\n",
 		      cmnd->device->lun, rn->flowid, rn->scsi_id);
@@ -2215,6 +2215,7 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
 	csio_put_scsi_ioreq_lock(hw, scsim, ioreq);
 fail:
 	CSIO_INC_STATS(rn, n_lun_rst_fail);
+fail_ret:
 	return FAILED;
 }
 
-- 
2.51.0


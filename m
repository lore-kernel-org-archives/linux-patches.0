Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E74359A65
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302427; cv=none; b=JF/duMela+2AbnJw9bNPViJMndqh7jdE8N38ecQ9ZkoDU/sCKK7UhGOi2v8Vx59zvvDajXXma+V9XdPDB08PfgmGwu1dfCkBcXj/4K5E3kecnMkU48Pp1bQDa6ArYJWdu8PH3Hqn1NfapKa60FNIPHRjfN4oCV+f0UUajHPOb8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302427; c=relaxed/simple;
	bh=QBseQC6NLecqCS/kqBdFVSv55rxQ7Kmy1PSv2p/dTgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KG2zfQOgh+9JmsodgDEwDoI49aY5EIKmqUmaz9sqUh0disc/8MxtJm4fSOeOdNr8DhX7ts+CHdyFcnHNE5MAZuJMEpJsc5L3qQXLn3yb2M6fAiH4t9sk3s8MyibMpcW7EtCpEa6DcvjhmcsXJkASiIEoQ7xKRQD29LCXoDb+Atw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pgoXyj7N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pgoXyj7N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3FD0C116D0;
	Sat, 28 Feb 2026 18:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302427;
	bh=QBseQC6NLecqCS/kqBdFVSv55rxQ7Kmy1PSv2p/dTgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pgoXyj7N/wSWrujPWimfF0bnW6jBFPG/IPMbcCfsuXnSX5FlHMj2LBkxrJ/BCp1r3
	 ww0n8vgnXaZi49aTx3x1i4lerTZtp59pFZ82TBcWOFJg0/cXFPNOZWPNBSoRKoTjI+
	 OsYMJPm31REMY6R1aSe4nNa4uMHRifJwIJgja7gjxzyK/SQy/toh4B/hz0Yf+QeETU
	 nwM73xBtwpjNxYkxCbZTteSGbPp3/7EMIGBPBF3oDk7O10k3n/mvQ0LkM1gfjJBmdG
	 OShXs4/yOyBpScnYiUGXc+q06CDhFF3fU3T5YXfI7EXfn0ZcqcKNbMdfwzZYXdksSk
	 kfqeQuQF6G5+w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Colin Ian King <colin.i.king@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 164/232] scsi: csiostor: Fix dereference of null pointer rn
Date: Sat, 28 Feb 2026 13:10:17 -0500
Message-ID: <20260228181127.1592657-164-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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


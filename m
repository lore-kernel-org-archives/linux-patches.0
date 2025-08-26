Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2850350851;
	Tue, 26 Aug 2025 14:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219151; cv=none; b=tFwb+nEfvhfYNWTv+5A0mM/jtjaDqet8IWGXmTEfqQSC5I4f3I2gc/mjGNjip0W6phxWgqQcp2DPJstlj10qhLjYNH677roVhIhDgfRNnOUmvKKVpYvGX3ffHjS7UleyrQ4PNIu+FJuAwMAdhV/bJ70VnYRNjw57IBE74nR5uGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219151; c=relaxed/simple;
	bh=BwuEV/LUHjhNKK3UJTNbGAF/6HQ6CsrJ5VHtQSMb2Tg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AgqfDZoAiEh+YC0N490bulKT0jdMq0joT7wHPStN8K5n2TLuWG/hK8L4x2JTv3BC+SUEUE/tQoBVv2PueMLRiL1Bb3g13VXnyjV243MgO63i8BqVSLezh8Z+Wbs8O6cClnAXFzx7N8PmJJ81nWtJnCuq6YllW244AFdefLHyvgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Kp2DujO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Kp2DujO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56478C4CEF1;
	Tue, 26 Aug 2025 14:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219151;
	bh=BwuEV/LUHjhNKK3UJTNbGAF/6HQ6CsrJ5VHtQSMb2Tg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Kp2DujOmVRY5+ndBVAeWW1PQ/YdYBU/t2qRXI5Yq525S7O4blBB7j8uS1DTahgnf
	 lMtHGJ35LMO5Sf1e7qJSpYRa1sdeZEnlptlL4vu+8DZ36pSqGHoRLe3Ca3hK8oHPrr
	 PF00/JgVmg8ltumx57wxVomdz7Kj9h9NywloNFXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 272/403] scsi: lpfc: Remove redundant assignment to avoid memory leak
Date: Tue, 26 Aug 2025 13:09:58 +0200
Message-ID: <20250826110914.317869789@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiasheng Jiang <jiashengjiangcool@gmail.com>

[ Upstream commit eea6cafb5890db488fce1c69d05464214616d800 ]

Remove the redundant assignment if kzalloc() succeeds to avoid memory
leak.

Fixes: bd2cdd5e400f ("scsi: lpfc: NVME Initiator: Add debugfs support")
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Link: https://lore.kernel.org/r/20250801185202.42631-1-jiashengjiangcool@gmail.com
Reviewed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_debugfs.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 291fccf02d45..f75431a948f3 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -5886,7 +5886,6 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
 			}
 			phba->nvmeio_trc_on = 1;
 			phba->nvmeio_trc_output_idx = 0;
-			phba->nvmeio_trc = NULL;
 		} else {
 nvmeio_off:
 			phba->nvmeio_trc_size = 0;
-- 
2.50.1




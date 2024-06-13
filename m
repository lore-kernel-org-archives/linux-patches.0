Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D697F1474A6;
	Thu, 13 Jun 2024 12:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280803; cv=none; b=K8uillLz8Wg9nUNDJFrrWvfGISTbvvjEBG+Kjk0Kbx8Wl2oC9bw0GmZShVLjBnpC1sX78vzmu8hcYPfEFKuxmjOQanG38BBAhezhnG+O/yqzhBf2081TAP2obr9rXdaSw10KY5Qvy0D0d8o9LF5kstDCVvBJhPoNr9lOMwCqLIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280803; c=relaxed/simple;
	bh=+meOkEcmERzAK7GPCmQDjFG2391zuaQKGbywlgZtKV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cL5FiCCScVu0p/Tx2nafRkx7XrEicOxIcs4fm0Iytp7oBTU7bMiMfKDSikEE4T51HVb+B/8xRozrGsDmF0Mox8uBWjVf2UdRSih29o5fPbzhPvXwhjTVdfOLdBy5Ep2qhnGq6pnij9JYfBRInrdXj5pD/C/MX+3b1Gbwz/QgqK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RPVJwf7R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RPVJwf7R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 269B1C32786;
	Thu, 13 Jun 2024 12:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280803;
	bh=+meOkEcmERzAK7GPCmQDjFG2391zuaQKGbywlgZtKV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RPVJwf7RKs8ejzFGUFv3CyjE6fYpWFQCtuKphq/3IACo92FcoNtZUOa2i2MfYESDu
	 N+dgm67prikLDOTFnV1TCrLiOILHghpo0Bm2cWWhFWx3BlXO0R941tefLsXZpgPtYv
	 uWbgDM3YDfZPU9zM/wkQ/9Keg1Yc9xbtVm4+yoEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Halaney <ahalaney@redhat.com>,
	Asutosh Das <quic_asutoshd@quicinc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 040/317] scsi: ufs: ufs-qcom: Fix the Qcom register name for offset 0xD0
Date: Thu, 13 Jun 2024 13:30:58 +0200
Message-ID: <20240613113249.098391105@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit 7959587f3284bf163e4f1baff3c6fa71fc6a55b1 ]

On newer UFS revisions, the register at offset 0xD0 is called,
REG_UFS_PARAM0. Since the existing register, RETRY_TIMER_REG is not used
anywhere, it is safe to use the new name.

Reviewed-by: Andrew Halaney <ahalaney@redhat.com>
Reviewed-by: Asutosh Das <quic_asutoshd@quicinc.com>
Tested-by: Andrew Halaney <ahalaney@redhat.com> # Qdrive3/sa8540p-ride
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 823150ecf04f ("scsi: ufs: qcom: Perform read back after writing unipro mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufs-qcom.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufs-qcom.h b/drivers/scsi/ufs/ufs-qcom.h
index 478134ba80864..70bee1d1f1139 100644
--- a/drivers/scsi/ufs/ufs-qcom.h
+++ b/drivers/scsi/ufs/ufs-qcom.h
@@ -46,7 +46,8 @@ enum {
 	REG_UFS_TX_SYMBOL_CLK_NS_US         = 0xC4,
 	REG_UFS_LOCAL_PORT_ID_REG           = 0xC8,
 	REG_UFS_PA_ERR_CODE                 = 0xCC,
-	REG_UFS_RETRY_TIMER_REG             = 0xD0,
+	/* On older UFS revisions, this register is called "RETRY_TIMER_REG" */
+	REG_UFS_PARAM0                      = 0xD0,
 	REG_UFS_PA_LINK_STARTUP_TIMER       = 0xD8,
 	REG_UFS_CFG1                        = 0xDC,
 	REG_UFS_CFG2                        = 0xE0,
-- 
2.43.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 754A91A38EF;
	Thu,  6 Jun 2024 14:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683229; cv=none; b=MSV2GAH2vbtIE7Ghy1UAEMgMfHLkYljMxKAIddlloIU4CQT+wgtkFgyVhFgLpJrxHc74DY3mWFLkz4qd/VKBAd6LsYh2HY6azEuMgRKYSjxlj5Ss3fogX3xBgUao9bV4/NsRlqGSl2cMo3dbfywyCDAG0fHEoSAr3mBYR0yDen8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683229; c=relaxed/simple;
	bh=p1EBD86fbNpBrEkFJ9hIdTH6DBAxtZ6o1Oyd6qlPXfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PXIV7X/6owVC/qttfAi6YtaEhGZmDf9Fue278ZV/Pa/vObbW3qDl8zptfFpDZtT6rTIIwS6/Qdh5JaStS4zns5Hd9S+LqjX1N2KqR0Ad73cKFpcQvY1N8siZIYO18JHQl4FMclnwS7CqZK+SlPxFlzKwLMD/GRP6gKTRsK3JfCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1pTEMAFE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1pTEMAFE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 514FCC2BD10;
	Thu,  6 Jun 2024 14:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683229;
	bh=p1EBD86fbNpBrEkFJ9hIdTH6DBAxtZ6o1Oyd6qlPXfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1pTEMAFEk05WXVe8PJm0vT58wcLLzzF+Ydi+zO7xq6TpAqsX8rBtsIm9hcpOmQCDd
	 ws11FsISSGgq2P/OXWqEEzuVKDWTL74jWZfagNJf8FwVp3k0O4TNNTdFJLMD6QNx6W
	 r4C2dW54N6HsKZb0s7AiUhN7Uq3ap1Z3Fo08E+NY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Halaney <ahalaney@redhat.com>,
	Asutosh Das <quic_asutoshd@quicinc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 105/473] scsi: ufs: ufs-qcom: Fix the Qcom register name for offset 0xD0
Date: Thu,  6 Jun 2024 16:00:34 +0200
Message-ID: <20240606131703.378382184@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/ufs/host/ufs-qcom.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-qcom.h b/drivers/ufs/host/ufs-qcom.h
index 8a3a65625db55..112e53efafe2b 100644
--- a/drivers/ufs/host/ufs-qcom.h
+++ b/drivers/ufs/host/ufs-qcom.h
@@ -36,7 +36,8 @@ enum {
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




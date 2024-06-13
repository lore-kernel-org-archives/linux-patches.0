Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D214256458;
	Thu, 13 Jun 2024 12:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281795; cv=none; b=DHDaxr+IAoATRJhKHyh5EDOkncKd8BCk5aL54EDIOy86S0CKsE2wM63pPcMGPXI6EOgsu1ldZyMNzgtVJdmphp16LtSNvVJt34kVhQOC3AkFBDmco9wnDIVs5sJywVBBtbJuUD1TRyD80ti8t2DoWK66HOWRI8adzgBZYgHQs/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281795; c=relaxed/simple;
	bh=mcX2AxHxiC/FQW5+P3OghDeiD6qmrfv/282CotewqGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q+iELTA65o/Jw8JoCd//mT5pj5CEVeyW8A/OgOEffC3B0bzpkQ3TDqxd6ngNJDi5NQkcbqEWNOFTTAe5i5FzsviwlkraKPazMtpcRbRq9D1TTLbOgDU+QOaZlt3M8p40pHFjygkoXKZzPfvblOarLaerQTC7HTuDBKbddsSqRyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gXjQxIhv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gXjQxIhv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 019E0C2BBFC;
	Thu, 13 Jun 2024 12:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281795;
	bh=mcX2AxHxiC/FQW5+P3OghDeiD6qmrfv/282CotewqGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gXjQxIhvLnJ1ZTYqddIHK/1aWsZmOLwihcE0GLotR08csPBNmNfiG4yqsiMqiypmw
	 6u0WYNTODf2vaWLdFGulAkSrwaYLSrIUZsoESf7nGavznX7J4Da2RP/xgXT3bGktDH
	 M0vkjGlBn2gSPPMCCgW8nP2QbmTsDg3QnCYE8Hoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Halaney <ahalaney@redhat.com>,
	Asutosh Das <quic_asutoshd@quicinc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 059/402] scsi: ufs: ufs-qcom: Fix the Qcom register name for offset 0xD0
Date: Thu, 13 Jun 2024 13:30:16 +0200
Message-ID: <20240613113304.439213652@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a2f32aa1ce1b8..b9f9b246c43b3 100644
--- a/drivers/scsi/ufs/ufs-qcom.h
+++ b/drivers/scsi/ufs/ufs-qcom.h
@@ -35,7 +35,8 @@ enum {
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




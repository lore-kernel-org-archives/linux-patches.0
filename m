Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F2BF1C6AB;
	Mon,  4 Mar 2024 21:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588474; cv=none; b=Dljl7pGzDxSd+vqiFFTjC+YYLm2Ldbrz/sGhjJ+lE5nH+PGDWiV4AyQWkX8QYovslurlTO639L7Ajr7Awkd+6SqiOTTs+2tt9C+aFbEbwLjJe5nOyT7ZRvS/2XHZ2/T2L+WHEi3RUqtfUrXq0J1SGAfiveuRgFV1sJ/xtKlNDac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588474; c=relaxed/simple;
	bh=0pMtj3tbXUMob+URuajrmDdKRNJOVE/iss3t+06QspM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r48PU5jzwHTu9mebR3H02JuX9uCpevpHLI1K2ZzuNmjaoS1OlZhsN12copupMBPCOWTXPHo1SV5QI3z86yAFc70ztO7Rc1agskZjPz19gkSQlTbyn09IAb7cNhS7WMT6kY6YVzmL2RaTOrjQMsOLV0ZfajxahHM7o2bWbMjQBW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vFXzFeBz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vFXzFeBz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94EF4C433C7;
	Mon,  4 Mar 2024 21:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588473;
	bh=0pMtj3tbXUMob+URuajrmDdKRNJOVE/iss3t+06QspM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vFXzFeBzk7xPzi17qycENSAEBflk9zGSaw6MN+N9BpSALN1jam2PpSCN6rc2THwt7
	 B9Oi6ESCSWjHCKE5tascFBYgVNBDGtcWnVGheSyzlHmYsGsEQ/93iGPLReaXX0a3dD
	 CIR/jrBAsn0af2aKq+hFGHW6vpxa0es/HGBoHIfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serge Semin <fancer.lancer@gmail.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Kory Maincent <kory.maincent@bootlin.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 120/143] dmaengine: dw-edma: HDMA_V0_REMOTEL_STOP_INT_EN typo fix
Date: Mon,  4 Mar 2024 21:24:00 +0000
Message-ID: <20240304211553.750990610@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
References: <20240304211549.876981797@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kory Maincent <kory.maincent@bootlin.com>

[ Upstream commit 930a8a015dcfde4b8906351ff081066dc277748c ]

Fix "HDMA_V0_REMOTEL_STOP_INT_EN" typo error

Fixes: e74c39573d35 ("dmaengine: dw-edma: Add support for native HDMA")
Reviewed-by: Serge Semin <fancer.lancer@gmail.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Kory Maincent <kory.maincent@bootlin.com>
Link: https://lore.kernel.org/r/20240129-b4-feature_hdma_mainline-v7-3-8e8c1acb7a46@bootlin.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dw-edma/dw-hdma-v0-regs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/dw-edma/dw-hdma-v0-regs.h b/drivers/dma/dw-edma/dw-hdma-v0-regs.h
index a974abdf8aaf5..eab5fd7177e54 100644
--- a/drivers/dma/dw-edma/dw-hdma-v0-regs.h
+++ b/drivers/dma/dw-edma/dw-hdma-v0-regs.h
@@ -15,7 +15,7 @@
 #define HDMA_V0_LOCAL_ABORT_INT_EN		BIT(6)
 #define HDMA_V0_REMOTE_ABORT_INT_EN		BIT(5)
 #define HDMA_V0_LOCAL_STOP_INT_EN		BIT(4)
-#define HDMA_V0_REMOTEL_STOP_INT_EN		BIT(3)
+#define HDMA_V0_REMOTE_STOP_INT_EN		BIT(3)
 #define HDMA_V0_ABORT_INT_MASK			BIT(2)
 #define HDMA_V0_STOP_INT_MASK			BIT(0)
 #define HDMA_V0_LINKLIST_EN			BIT(0)
-- 
2.43.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E37F198A3C;
	Thu,  6 Jun 2024 14:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683451; cv=none; b=S42JjbFfm29m1YxM3E2Xq9mIA/4jS1qcyHUCWj1buIoVSwtoqfB2d/M1vAEUoLX6QMMGzvjJBWDyZPEW9ZpBXJsZn8tbmtgNw/f7ZeD5qKmx75lYAyzWj+aEUcS6i4jYxgID4uj18MSS6/tRt6fa769sPds9g0O5AoJgyuCTQ+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683451; c=relaxed/simple;
	bh=JZ+ZVcD08N8jHjYewwG8V0L8F8UBo6ECR7tnhelurA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rlvL8WWsE8KBH10YyBWAabMQofPKSCjEvUNLN/eyw2I3duFUQVM1L73qEku64i3NyyaGj6phPjOGrF48paxTCqhFkawJq1D+w7lzhJS1qr64ajI/dPTnDN+744um+ulwIdSbW4eeewFKUXiCB7wblDboNojvGBUFlEYCCHM0Ez0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k3KoWrBW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k3KoWrBW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E03E1C2BD10;
	Thu,  6 Jun 2024 14:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683450;
	bh=JZ+ZVcD08N8jHjYewwG8V0L8F8UBo6ECR7tnhelurA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k3KoWrBWKMzcMkbA5ePGYIdrx7dyia4hp1xHYgWEN3SOMnlASjoNaskzpMxpIhnl7
	 j/86DKSe0spVbGO0w4c83SMQCbRcuX+mMALPJqvmfXaRvjnpl+h2WM7YXGvgLpAtUB
	 CUCeRkCNh1ZqSEbCCyAkT0N/r0QQYnVXQicaV0Dw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 394/744] phy: qcom: qmp-combo: fix duplicate return in qmp_v4_configure_dp_phy
Date: Thu,  6 Jun 2024 16:01:06 +0200
Message-ID: <20240606131745.096231032@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Neil Armstrong <neil.armstrong@linaro.org>

[ Upstream commit e298ae7caafcc429e0fc4b3779f1738c0acc5dac ]

Remove duplicate "return 0" in qmp_v4_configure_dp_phy()

Fixes: 186ad90aa49f ("phy: qcom: qmp-combo: reuse register layouts for even more registers")
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Link: https://lore.kernel.org/r/20240228-topic-sm8x50-upstream-phy-combo-fix-duplicate-return-v1-1-60027a37cab1@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp-combo.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-combo.c b/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
index dce002e232ee9..54fb5fca1c422 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
@@ -2334,8 +2334,6 @@ static int qmp_v4_configure_dp_phy(struct qmp_combo *qmp)
 	writel(0x20, qmp->dp_tx2 + cfg->regs[QPHY_TX_TX_EMP_POST1_LVL]);
 
 	return 0;
-
-	return 0;
 }
 
 /*
-- 
2.43.0




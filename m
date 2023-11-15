Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B2641212
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zzUzDllT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 068C1C433C8;
	Wed, 15 Nov 2023 19:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076751;
	bh=q2PVEIktzp2SKJL00lD592NHKdxP07z2BgpxVHAZ/Po=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zzUzDllTQjIe/h9DTaaISMO4b88KCxcEqnkrFFpYxlMIn+x81I+Xjg8V17ahe80B9
	 jojk99/7gmPdBM+Hcz7PkAemi1l349YdreIT2QBwRlTGDaSniLyT7WBq8Q892yjapo
	 SLVTCeDjI1fOgVCV0o+Drt0T0VINL5onbPP0xDk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 410/550] interconnect: qcom: sc8180x: Set ACV enable_mask
Date: Wed, 15 Nov 2023 14:16:34 -0500
Message-ID: <20231115191629.183377421@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 0fcaaed3ff4b99e5b688b799f48989f1e4bb8a8b ]

ACV expects an enable_mask corresponding to the APPS RSC, fill it in.

Fixes: 9c8c6bac1ae8 ("interconnect: qcom: Add SC8180x providers")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230811-topic-acv-v2-4-765ad70e539a@linaro.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/qcom/sc8180x.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/interconnect/qcom/sc8180x.c b/drivers/interconnect/qcom/sc8180x.c
index c76e3a6a98cdd..024930f24f1f7 100644
--- a/drivers/interconnect/qcom/sc8180x.c
+++ b/drivers/interconnect/qcom/sc8180x.c
@@ -1344,6 +1344,7 @@ static struct qcom_icc_node slv_qup_core_2 = {
 
 static struct qcom_icc_bcm bcm_acv = {
 	.name = "ACV",
+	.enable_mask = BIT(3),
 	.num_nodes = 1,
 	.nodes = { &slv_ebi }
 };
-- 
2.42.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F19841223
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wYvcFlqh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E514C433CA;
	Wed, 15 Nov 2023 19:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076768;
	bh=AUffdMteexZwrPNoehp4itEP1Y89a5iawdcjYcwhVNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wYvcFlqhgcsNrPA6lf61LvCBmYG+079PHrIUtEhxmnvs0vs7LsU8X1fQmH0Bsd8rg
	 DCq5VGAXEKtIQV/VHvSHGP28gztq8MKYKvbUFL+kJOkLRmVjhVbJmio1z6c2/prsmR
	 QS5V8KLypDa4juVP8RbFC7v2T3UxwGMm2xPpOHws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 415/550] interconnect: qcom: sdm845: Set ACV enable_mask
Date: Wed, 15 Nov 2023 14:16:39 -0500
Message-ID: <20231115191629.530097848@linuxfoundation.org>
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

[ Upstream commit f8fe97a9fd2098de0570387029065eef657d50ee ]

ACV expects an enable_mask corresponding to the APPS RSC, fill it in.

Fixes: b5d2f741077a ("interconnect: qcom: Add sdm845 interconnect provider driver")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230811-topic-acv-v2-7-765ad70e539a@linaro.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/qcom/sdm845.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/interconnect/qcom/sdm845.c b/drivers/interconnect/qcom/sdm845.c
index 39ee54ffdb7ba..02cf890684441 100644
--- a/drivers/interconnect/qcom/sdm845.c
+++ b/drivers/interconnect/qcom/sdm845.c
@@ -148,6 +148,7 @@ DEFINE_QNODE(xs_sys_tcu_cfg, SDM845_SLAVE_TCU, 1, 8);
 
 static struct qcom_icc_bcm bcm_acv = {
 	.name = "ACV",
+	.enable_mask = BIT(3),
 	.keepalive = false,
 	.num_nodes = 1,
 	.nodes = { &ebi },
-- 
2.42.0




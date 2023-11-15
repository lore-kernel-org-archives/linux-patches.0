Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F49A41A84
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U3ycQ9j3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0AFEC433CB;
	Wed, 15 Nov 2023 19:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076806;
	bh=DJk2KLPQM7PNfi4+4Kf/qR1vv2u9z2syQzoNbhHX+Xw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U3ycQ9j3a2bmvRC+QZ9EvWn4LiWSxzc2H+bbqQC5JxUQ6ZNBxDWtYVbJoVOIB1G7/
	 YyGotO/WZM6Y3rDYuM7IQkZgf+aVyUjMMg8uGbabqpXqB2sWLVkTIx6+JjPykyWxs+
	 reI8U/2DCx6zsCmcxrCI7TTpfPim8ldWpyxhCXrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 409/550] interconnect: qcom: sc7280: Set ACV enable_mask
Date: Wed, 15 Nov 2023 14:16:33 -0500
Message-ID: <20231115191629.117431049@linuxfoundation.org>
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

[ Upstream commit 437b8e7fcd5df792cb8b8095e9f6eccefec6c099 ]

ACV expects an enable_mask corresponding to the APPS RSC, fill it in.

Fixes: 46bdcac533cc ("interconnect: qcom: Add SC7280 interconnect provider driver")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230811-topic-acv-v2-3-765ad70e539a@linaro.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/qcom/sc7280.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/interconnect/qcom/sc7280.c b/drivers/interconnect/qcom/sc7280.c
index 971f538bc98ad..3c39edd21b6ca 100644
--- a/drivers/interconnect/qcom/sc7280.c
+++ b/drivers/interconnect/qcom/sc7280.c
@@ -1284,6 +1284,7 @@ static struct qcom_icc_node srvc_snoc = {
 
 static struct qcom_icc_bcm bcm_acv = {
 	.name = "ACV",
+	.enable_mask = BIT(3),
 	.num_nodes = 1,
 	.nodes = { &ebi },
 };
-- 
2.42.0




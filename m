Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E7C63C478
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1yCxWQpW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B32CAC433CB;
	Wed, 15 Nov 2023 19:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078380;
	bh=TMRUffSmRPk0cawMJonlUn/WSV7NhpCExqFhcxTZ6zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1yCxWQpWoGkrFlN24DUHCAZFoGvfsSb2SotDbvO9cv7Oqcz1/8v78mFgHHIlWVu95
	 7XMhJtcvN0t5iYN4cowXLoZGz+DcAq9YHo8q+qXjuTko+Wt81h8jePE/vM2a/tQFDL
	 jYYlMe7pDxmnSf/RmKKc6bIYdynowbQ3PqFn9VF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 289/379] interconnect: qcom: sm8150: Set ACV enable_mask
Date: Wed, 15 Nov 2023 14:26:04 -0500
Message-ID: <20231115192702.239137930@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 7ed42176406e5a2c9a5767d0d75690c7d1588027 ]

ACV expects an enable_mask corresponding to the APPS RSC, fill it in.

Fixes: a09b817c8bad ("interconnect: qcom: Add SM8150 interconnect provider driver")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230811-topic-acv-v2-9-765ad70e539a@linaro.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/qcom/sm8150.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/interconnect/qcom/sm8150.c b/drivers/interconnect/qcom/sm8150.c
index 640fd4c4a6886..685f35bbf5a7c 100644
--- a/drivers/interconnect/qcom/sm8150.c
+++ b/drivers/interconnect/qcom/sm8150.c
@@ -156,6 +156,7 @@ DEFINE_QNODE(xs_sys_tcu_cfg, SM8150_SLAVE_TCU, 1, 8);
 
 static struct qcom_icc_bcm bcm_acv = {
 	.name = "ACV",
+	.enable_mask = BIT(3),
 	.keepalive = false,
 	.num_nodes = 1,
 	.nodes = { &ebi },
-- 
2.42.0




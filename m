Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B422011706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:55:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0445DC433C8;
	Mon, 11 Sep 2023 14:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694444106;
	bh=PDqRJaRyvbq51dlpY3FbyZooE53VY1mcYL1o/Vtqckk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iMWqAUd15BTochzvsnicN8hPQsSUAghZRz9wn0oZhczQgokyz+5JsIFymsPzTnZ4s
	 TPDJgmmg1GFjOt3Frf3US9D/sc8N3oCHIVHPKnrt8flzSvILZqZQCwoimSCsSc/4Gh
	 Z0BqRQWvh6ktlPU8BBcltvWRoFUm+yL+r0PPtTYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 586/737] interconnect: qcom: sm8450: Enable sync_state
Date: Mon, 11 Sep 2023 15:47:25 +0200
Message-ID: <20230911134706.895084141@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 16862f1b2110eca6330e5be6d804e1a08e06a202 ]

Enable sync_state on sm8450 so that the interconnect votes actually mean
anything and aren't just pinned to INT_MAX.

Fixes: fafc114a468e ("interconnect: qcom: Add SM8450 interconnect provider driver")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Vinod Koul <vkoul@kernel.org>
Link: https://lore.kernel.org/r/20230811-topic-8450_syncstate-v1-1-69ae5552a18b@linaro.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/qcom/sm8450.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/interconnect/qcom/sm8450.c b/drivers/interconnect/qcom/sm8450.c
index e64c214b40209..d6e582a02e628 100644
--- a/drivers/interconnect/qcom/sm8450.c
+++ b/drivers/interconnect/qcom/sm8450.c
@@ -1886,6 +1886,7 @@ static struct platform_driver qnoc_driver = {
 	.driver = {
 		.name = "qnoc-sm8450",
 		.of_match_table = qnoc_of_match,
+		.sync_state = icc_sync_state,
 	},
 };
 
-- 
2.40.1




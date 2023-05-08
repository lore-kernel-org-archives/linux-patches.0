Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC10320A
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:18:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0B18C4339B;
	Mon,  8 May 2023 11:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544714;
	bh=J96scCUgcFwW/WgU8ia+/0lU8QJhNiFPQo295skVAcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JXwPzIwDZ2yvIBrd5JC+AhzKJk/4uGeqKtPkE4F2d/2cxqmeWjvR4vOehvEm8cEgR
	 QLvBnXEAjHTWUZKflMm7abCxlWszkeCwHcxdRPO3cGowcLgdIjBvTUxnDA1jC4vRKM
	 Dq5vJbuji4ez3BPqsXAO5r9uWdWzyCbhc9NLnudM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 500/694] interconnect: qcom: osm-l3: drop unuserd header inclusion
Date: Mon,  8 May 2023 11:45:35 +0200
Message-Id: <20230508094450.276075308@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit f730038fe6a6de170268fd779b2c029aa70a928b ]

The commit 4529992c9474 ("interconnect: qcom: osm-l3: Use
platform-independent node ids") made osm-l3 driver use
platform-independent IDs, removing the need to include platform headers.

Fixes: 4529992c9474 ("interconnect: qcom: osm-l3: Use platform-independent node ids")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Bjorn Andersson <andersson@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230103031159.1060075-1-dmitry.baryshkov@linaro.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/qcom/osm-l3.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/interconnect/qcom/osm-l3.c b/drivers/interconnect/qcom/osm-l3.c
index 1bafb54f14329..a1f4f918b9116 100644
--- a/drivers/interconnect/qcom/osm-l3.c
+++ b/drivers/interconnect/qcom/osm-l3.c
@@ -14,13 +14,6 @@
 
 #include <dt-bindings/interconnect/qcom,osm-l3.h>
 
-#include "sc7180.h"
-#include "sc7280.h"
-#include "sc8180x.h"
-#include "sdm845.h"
-#include "sm8150.h"
-#include "sm8250.h"
-
 #define LUT_MAX_ENTRIES			40U
 #define LUT_SRC				GENMASK(31, 30)
 #define LUT_L_VAL			GENMASK(7, 0)
-- 
2.39.2




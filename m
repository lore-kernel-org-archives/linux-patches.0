Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB2FB33CDF
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hbmN6VcS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99114C433CB;
	Wed, 15 Nov 2023 19:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077706;
	bh=uJ7kbwXb2LPBz5KWPNIKUHY1mkvG4CzrQ9W4C/yqfHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hbmN6VcSvufzXRO9KVy02qYz9fn/xkaqf0+/EcrRWR1iEQAiV///T4GafKxDu7ooj
	 9EhIlGErpRHHj1LcUh6typsjeY/1EDEE7LKKTdib+mBvTlVIaMMjenremwMIypMcoR
	 2qmQoROl51gl0speD3Gg0IS+/Xbsmg51KwXOHMO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 447/603] interconnect: qcom: qdu1000: Set ACV enable_mask
Date: Wed, 15 Nov 2023 14:16:32 -0500
Message-ID: <20231115191643.667859845@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 8517824f0e94d52ab82742106314f0b8875e03c4 ]

ACV expects an enable_mask corresponding to the APPS RSC, fill it in.

Fixes: 1f51339f7dd0 ("interconnect: qcom: Add QDU1000/QRU1000 interconnect driver")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230811-topic-acv-v2-1-765ad70e539a@linaro.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/qcom/qdu1000.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/interconnect/qcom/qdu1000.c b/drivers/interconnect/qcom/qdu1000.c
index bf800dd7d4ba1..a7392eb73d4a9 100644
--- a/drivers/interconnect/qcom/qdu1000.c
+++ b/drivers/interconnect/qcom/qdu1000.c
@@ -769,6 +769,7 @@ static struct qcom_icc_node xs_sys_tcu_cfg = {
 
 static struct qcom_icc_bcm bcm_acv = {
 	.name = "ACV",
+	.enable_mask = BIT(3),
 	.num_nodes = 1,
 	.nodes = { &ebi },
 };
-- 
2.42.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805513309F
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N9oOyXyk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32702C433C9;
	Wed, 15 Nov 2023 19:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077688;
	bh=bzI3fWeHuOghIhX3U8aGeu9GKkKVEBzKr7BP6F9M+zU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N9oOyXykygBrqUHcSSCrbkkR3b9eYLppFjg023y8mcZwZ5r+h2pAbCf0AVsjWFjjM
	 kdUwDrOTlUbW3QutDxY5td0yGLj3J6qyUsTUvyKQQ0DWmxZQdwinyc4RuxRBLFqHZI
	 /4VdNe+BJWPlU52D5hNxyvQ0VOV+2sArF2yNaWH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 457/603] interconnect: qcom: sm8350: Set ACV enable_mask
Date: Wed, 15 Nov 2023 14:16:42 -0500
Message-ID: <20231115191644.265530429@linuxfoundation.org>
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

[ Upstream commit df1b8356a80ab47a7623e08facf36fe434ea9722 ]

ACV expects an enable_mask corresponding to the APPS RSC, fill it in.

Fixes: d26a56674497 ("interconnect: qcom: Add SM8350 interconnect provider driver")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230811-topic-acv-v2-11-765ad70e539a@linaro.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/qcom/sm8350.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/interconnect/qcom/sm8350.c b/drivers/interconnect/qcom/sm8350.c
index bdf75839e6d17..562322d4fc3c4 100644
--- a/drivers/interconnect/qcom/sm8350.c
+++ b/drivers/interconnect/qcom/sm8350.c
@@ -1356,6 +1356,7 @@ static struct qcom_icc_node qns_mem_noc_sf_disp = {
 
 static struct qcom_icc_bcm bcm_acv = {
 	.name = "ACV",
+	.enable_mask = BIT(3),
 	.keepalive = false,
 	.num_nodes = 1,
 	.nodes = { &ebi },
-- 
2.42.0




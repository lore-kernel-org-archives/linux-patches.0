Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D23033EA7B
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ADGYRGmq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 861A8C433C7;
	Wed, 15 Nov 2023 19:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076774;
	bh=B52WIjoht8AGPHts7TuAt8YeLuY/fLSZ/iyYgMsz8VE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ADGYRGmqrC8KonZiq81x6X6uPl0EXPqs+KCXrfU5P3IlfQTsfbkqiEjpKKOq6TPE2
	 EIYkMuruLKqkHqRAmwNUo9ogd4oTsz3FvFiJDWbD/txGY6MsioEbgDSIpMSLzKkeLA
	 YAXexVqoxw4MYi8xXdGE3aTuHcOdlB7KcNExwSIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 417/550] interconnect: qcom: sm6350: Set ACV enable_mask
Date: Wed, 15 Nov 2023 14:16:41 -0500
Message-ID: <20231115191629.667785829@linuxfoundation.org>
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

[ Upstream commit fe7a3abf4111992af3de51d22383a8e8a0affe1e ]

ACV expects an enable_mask corresponding to the APPS RSC, fill it in.

Fixes: 6a6eff73a954 ("interconnect: qcom: Add SM6350 driver support")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230811-topic-acv-v2-8-765ad70e539a@linaro.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/qcom/sm6350.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/interconnect/qcom/sm6350.c b/drivers/interconnect/qcom/sm6350.c
index 8a33a39f13260..aae4b43b730c0 100644
--- a/drivers/interconnect/qcom/sm6350.c
+++ b/drivers/interconnect/qcom/sm6350.c
@@ -144,6 +144,7 @@ DEFINE_QNODE(xs_sys_tcu_cfg, SM6350_SLAVE_TCU, 1, 8);
 
 static struct qcom_icc_bcm bcm_acv = {
 	.name = "ACV",
+	.enable_mask = BIT(3),
 	.keepalive = false,
 	.num_nodes = 1,
 	.nodes = { &ebi },
-- 
2.42.0




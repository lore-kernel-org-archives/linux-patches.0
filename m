Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0388411706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:51:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 740E5C433C8;
	Mon, 11 Sep 2023 14:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443866;
	bh=sqrgwmpjfdVJMT3ABvcJJg0tQ8OfH1hrt1llJds3n0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hOOtJtT1CnUnJ72ukZif0GAtvFv0oEKXD4Tpx7Ah9wQJplK+ERdtk80bGAfsGxyV9
	 SNqF36q748JDnrHWdZH9c9Lcoq3jgWEDlnB/i+XHIRjlxQSpYsnjy9fNACcJeLFQgp
	 EthEshh2NCqXohFZtX84wCY3MGhb6RPaOaUb9hUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 529/737] interconnect: qcom: qcm2290: Enable sync state
Date: Mon, 11 Sep 2023 15:46:28 +0200
Message-ID: <20230911134705.354138358@linuxfoundation.org>
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

[ Upstream commit 4e048e9b7a160f7112069c0ec2947be15f3e8154 ]

Enable the generic .sync_state callback to ensure there are no
outstanding votes that would waste power.

Generally one would need a bunch of interface clocks to access the QoS
registers when trying to go over all possible nodes during sync_state,
but QCM2290 surprisingly does not seem to require any such handling.

Fixes: 1a14b1ac3935 ("interconnect: qcom: Add QCM2290 driver support")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230720-topic-qcm2290_icc-v2-2-a2ceb9d3e713@linaro.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/qcom/qcm2290.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/interconnect/qcom/qcm2290.c b/drivers/interconnect/qcom/qcm2290.c
index a29cdb4fac03f..82a2698ad66b1 100644
--- a/drivers/interconnect/qcom/qcm2290.c
+++ b/drivers/interconnect/qcom/qcm2290.c
@@ -1355,6 +1355,7 @@ static struct platform_driver qcm2290_noc_driver = {
 	.driver = {
 		.name = "qnoc-qcm2290",
 		.of_match_table = qcm2290_noc_of_match,
+		.sync_state = icc_sync_state,
 	},
 };
 module_platform_driver(qcm2290_noc_driver);
-- 
2.40.1




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9904C881F;
	Sat, 30 Dec 2023 12:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IC538dBH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21021C433C7;
	Sat, 30 Dec 2023 12:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703938238;
	bh=RIBN/2jniDEDJJIe4j+Fv3J1f2qigAi+LfGkB+T8WfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IC538dBHVMlGsyVda7+FnefeMI42y42B2uMF8LTQ256pN5+ft4+ut5MB4RK4CE0Pc
	 uJ6ivP7Cwu6rW5kypx6kREGZzHudqRD3ciqNMPbvyRJ+hHT32WgU3xMC6nqXlF6OOZ
	 pGxb76ogAuAwXlgptGIZ15Xo0Z5HqHRyCd8uaW0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 056/112] interconnect: qcom: sm8250: Enable sync_state
Date: Sat, 30 Dec 2023 11:59:29 +0000
Message-ID: <20231230115808.501573262@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115806.714618407@linuxfoundation.org>
References: <20231230115806.714618407@linuxfoundation.org>
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

[ Upstream commit bfc7db1cb94ad664546d70212699f8cc6c539e8c ]

Add the generic icc sync_state callback to ensure interconnect votes
are taken into account, instead of being pegged at maximum values.

Fixes: b95b668eaaa2 ("interconnect: qcom: icc-rpmh: Add BCMs to commit list in pre_aggregate")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20231130-topic-8250icc_syncstate-v1-1-7ce78ba6e04c@linaro.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/qcom/sm8250.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/interconnect/qcom/sm8250.c b/drivers/interconnect/qcom/sm8250.c
index 5cdb058fa0959..9c2dd40d9a559 100644
--- a/drivers/interconnect/qcom/sm8250.c
+++ b/drivers/interconnect/qcom/sm8250.c
@@ -551,6 +551,7 @@ static struct platform_driver qnoc_driver = {
 	.driver = {
 		.name = "qnoc-sm8250",
 		.of_match_table = qnoc_of_match,
+		.sync_state = icc_sync_state,
 	},
 };
 module_platform_driver(qnoc_driver);
-- 
2.43.0




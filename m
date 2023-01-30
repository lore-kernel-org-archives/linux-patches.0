Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4AA428EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:14:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1172BC433D2;
	Mon, 30 Jan 2023 14:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675088057;
	bh=jIBAPAVrCr6k7xXt91czoeA9kRhU+zg4zMDQpo9pcA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yfaHr/LtAKKGSGzqs4RoynqDWlBaeABRTg6aMybELVeJI9iuo2Mwb6FwS4N8lRube
	 Cwn2bOIvn2597p4NLP/BtaFJfFOqUub4/WkrE4IQMpxd5QNX4SYYLlooMHYPZBB2Wh
	 XANQEfRifIBUzRNjsYU1/y36rlcnv/v5BgX/WrRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 099/204] cpufreq: Add SM6375 to cpufreq-dt-platdev blocklist
Date: Mon, 30 Jan 2023 14:51:04 +0100
Message-Id: <20230130134320.701315911@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit faf28e240dd118d9521c68aeb9388b9b8f02d9d0 ]

The Qualcomm SM6375 platform uses the qcom-cpufreq-hw driver, so add
it to the cpufreq-dt-platdev driver's blocklist.

Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq-dt-platdev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/cpufreq/cpufreq-dt-platdev.c b/drivers/cpufreq/cpufreq-dt-platdev.c
index 27a3b8800a35..e1b5975c7daa 100644
--- a/drivers/cpufreq/cpufreq-dt-platdev.c
+++ b/drivers/cpufreq/cpufreq-dt-platdev.c
@@ -144,6 +144,7 @@ static const struct of_device_id blocklist[] __initconst = {
 	{ .compatible = "qcom,sc8180x", },
 	{ .compatible = "qcom,sdm845", },
 	{ .compatible = "qcom,sm6350", },
+	{ .compatible = "qcom,sm6375", },
 	{ .compatible = "qcom,sm8150", },
 	{ .compatible = "qcom,sm8250", },
 	{ .compatible = "qcom,sm8350", },
-- 
2.39.0




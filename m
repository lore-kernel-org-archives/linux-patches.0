Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89EC628EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:01:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E372C433EF;
	Mon, 30 Jan 2023 14:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087276;
	bh=IW3yOLaXoZXpuFLLsx1ZpBs3DzyXsUeJmVzD8tAAsmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J2PhrLVoukGMA+X9NCwvuGq4hA24UrUIbU3AX1WiOvTn5yG4N6CtmOSsFOH2Uy2qb
	 ZrgdN0/Apj30QR4/Z+8Ac+wdmob9+H1s7fLtaR9P5Lek7st0UzgHt+vZo/b2PStr+3
	 xXa+EjXm7vjomqTzahVgUCT/9jMJRUiNE1vQEsrw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 154/313] cpufreq: Add SM6375 to cpufreq-dt-platdev blocklist
Date: Mon, 30 Jan 2023 14:49:49 +0100
Message-Id: <20230130134343.831790274@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
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
index 54ae8118d528..69a8742c0a7a 100644
--- a/drivers/cpufreq/cpufreq-dt-platdev.c
+++ b/drivers/cpufreq/cpufreq-dt-platdev.c
@@ -149,6 +149,7 @@ static const struct of_device_id blocklist[] __initconst = {
 	{ .compatible = "qcom,sdm845", },
 	{ .compatible = "qcom,sm6115", },
 	{ .compatible = "qcom,sm6350", },
+	{ .compatible = "qcom,sm6375", },
 	{ .compatible = "qcom,sm8150", },
 	{ .compatible = "qcom,sm8250", },
 	{ .compatible = "qcom,sm8350", },
-- 
2.39.0




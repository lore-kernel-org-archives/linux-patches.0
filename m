Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9579C33FE12
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300942; cv=none; b=o6T4O+fgZjXxfGSROjnYl+/rBbTZprX2hE0xeFj6K+tyMdL/M5HBbi2c7GyUmgbbl/BYPlppMtvSB6GZvjM45U8W8iwF2lp6Bi1Dd4N6nE/v2uINh+jX/rzj64GzfWZbar6W8L0PIRCb1KqwceU/bzgz+sQGG6Z/p89xPctxKlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300942; c=relaxed/simple;
	bh=SzAOPBObLOGNLSSdBzhd6dsX7YYbnEwO2MQW97Vd6K8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YjDGX04X7zmqwkwWx/AOlt99vhers/Q9M0sGHhiuBKAI2QdN13clIbQCCvbznphMxiobXNiwWgg0heH8d5IXGfMDZ1r0qJvEjVusTddxXvUg7INSKUvBsExglj0n3zsSr7XIgRTPnUU5/5dkY1J7v2lzkTwYfOM51SgIPw9IdvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OlyfX+kh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OlyfX+kh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0082AC116D0;
	Sat, 28 Feb 2026 17:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300942;
	bh=SzAOPBObLOGNLSSdBzhd6dsX7YYbnEwO2MQW97Vd6K8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OlyfX+khOBlJY7goz/KX5bAOuzTiUwnXU8ZSeczyRaSeYKbrPXIW7jHqKx1urWDuR
	 kcfg55I27mgZYGaoB61hIov94RF7xNRdHjkPtWQn3+6SVKWNSOZN/Xr7Jxh+0vj/2A
	 3SAZUCfZFpbryzui8mI2AEwrDISHucnUEcZo1KT1EMcawU29aaxNBzX13Q7OQJHltY
	 T9xcXoz2CQEdURYnAsOS7oCWfyHMWAxc7eIl0GNJOm+anU18n8EPR2dFgIhFkPj7m+
	 /c4mXOstotCXA4df6FM06dTa352yds4KYMkmmcPKOoU8sheUfROH04/5PnLVw8LRVP
	 9QdlKoxethwrQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 064/752] cpufreq: dt-platdev: Block the driver from probing on more QC platforms
Date: Sat, 28 Feb 2026 12:36:15 -0500
Message-ID: <20260228174750.1542406-64-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit 7b781899072c5701ef9538c365757ee9ab9c00bd ]

Add a number of QC platforms to the blocklist, they all use either the
qcom-cpufreq-hw driver.

Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq-dt-platdev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/cpufreq/cpufreq-dt-platdev.c b/drivers/cpufreq/cpufreq-dt-platdev.c
index dc11b62399ad5..47dd76acd31e5 100644
--- a/drivers/cpufreq/cpufreq-dt-platdev.c
+++ b/drivers/cpufreq/cpufreq-dt-platdev.c
@@ -169,8 +169,11 @@ static const struct of_device_id blocklist[] __initconst = {
 	{ .compatible = "qcom,sdm845", },
 	{ .compatible = "qcom,sdx75", },
 	{ .compatible = "qcom,sm6115", },
+	{ .compatible = "qcom,sm6125", },
+	{ .compatible = "qcom,sm6150", },
 	{ .compatible = "qcom,sm6350", },
 	{ .compatible = "qcom,sm6375", },
+	{ .compatible = "qcom,sm7125", },
 	{ .compatible = "qcom,sm7225", },
 	{ .compatible = "qcom,sm7325", },
 	{ .compatible = "qcom,sm8150", },
-- 
2.51.0


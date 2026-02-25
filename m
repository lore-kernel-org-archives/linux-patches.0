Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0A66254B03;
	Wed, 25 Feb 2026 01:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983465; cv=none; b=OKlB7FMUrz6BC5xsVZDHRvf6pGsGI3vXyDhRLEIlbE8lXTPSqnXd1QqZktc8kZIMGYqCX0RPvJv4irq0bg1TClcFUDml/IO+YY3zFQlycWavxHPVA/lkhp9xM5Rjh6XLXVSV9uel9AJbyaoRryj8QUZZsm8G5VEweu3mG6aB92A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983465; c=relaxed/simple;
	bh=vexnOwa4r5tOalQj4urIL7/vnHF7XGitqV403dALA30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xl2k7Hbv/RV85MFz92thquRu+a51MZT2j3gLyWAXMtMiZ4kMTdZv3XTtv4hDsr/EeyyYg5KA0iBPLkN6cxq0L/evXgIT16uWBlCiQDAJ9dRY45RktLV9+hSgEplX4BtaC4jIZfZ3G9/6Dtiwy9xIiY+hm6ow3SMpjVsbK59HrDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E0bMpgj1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E0bMpgj1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 616BCC116D0;
	Wed, 25 Feb 2026 01:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983465;
	bh=vexnOwa4r5tOalQj4urIL7/vnHF7XGitqV403dALA30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E0bMpgj1IX29mw0LPTZ6S100pCUsQrrQ1fhdDLjfxteFtlZ1S0gRmjG/i8j07PMQD
	 LLzghi4ujnArJv3FckvriPNMsnTcKzwxuVUz7pQe+QtyhS8XXW1oYMWYzb/Mmmf5sv
	 j+v8EEjI9MXf1HQeLXcpsxPyr2EPOCCuQ1pPpgss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Barnab=C3=A1s=20Cz=C3=A9m=C3=A1n?= <barnabas.czeman@mainlining.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 527/781] clk: qcom: gcc-msm8917: Remove ALWAYS_ON flag from cpp_gdsc
Date: Tue, 24 Feb 2026 17:20:36 -0800
Message-ID: <20260225012412.723589662@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Barnabás Czémán <barnabas.czeman@mainlining.org>

[ Upstream commit e4eb42f290aecac0ba355b1f8d7243be6de11f32 ]

cpp_gdsc should not be always on, ALWAYS_ON flag was set accidentally.

Fixes: 33cc27a47d3a ("clk: qcom: Add global clock controller driver for MSM8917")
Signed-off-by: Barnabás Czémán <barnabas.czeman@mainlining.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251117-fix-gdsc-cpp-msm8917-msm8953-v1-2-db33adcff28a@mainlining.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-msm8917.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/clk/qcom/gcc-msm8917.c b/drivers/clk/qcom/gcc-msm8917.c
index 0a1aa623cd49a..9d1c5a9953e2c 100644
--- a/drivers/clk/qcom/gcc-msm8917.c
+++ b/drivers/clk/qcom/gcc-msm8917.c
@@ -3409,7 +3409,6 @@ static struct gdsc cpp_gdsc = {
 	.pd = {
 		.name = "cpp_gdsc",
 	},
-	.flags = ALWAYS_ON,
 	.pwrsts = PWRSTS_OFF_ON,
 };
 
-- 
2.51.0




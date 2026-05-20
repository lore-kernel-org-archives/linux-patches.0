Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40264318ED6;
	Wed, 20 May 2026 18:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302239; cv=none; b=PIQTLIEdRUtKVXfObJO4e5Dgm2DCVvc+qXvH9SvxkDNmwQ8+CG1ytIZNxMebSHBi+VW4+6Hlgb+ShGg/HY0yVALQ2LCjmuSeGGtJ7f1OpiYybaNncvpmafCDdGM31vvNCyr1knm/0ZuzNzeP0Pv5f8wM1S9iq8xZMKkoRE+THHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302239; c=relaxed/simple;
	bh=se84nEmj9GmMjhcCBN8Md7wbwMnah6goi51Ek0nA8xo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jSKjeK4QsI4iGsicd2/Ed/KoL9oltb+oe0IeAgVjJAA9q83BUqLSE3gCVYlvfjXcOyjpLpYriRw1SQoSWjLOw3WjRezHkvj5fXVeFp06RTBS4D4hg5I6MWoMSsJUjob7InG4trOyZD7nzourHGV0eta7731SUZOvygejSs+DOFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TXYgjKHv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TXYgjKHv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5E241F000E9;
	Wed, 20 May 2026 18:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302238;
	bh=2nCCUCOsIowl/EcHumg75Q0XOYMjykuuzDiTfyva7Fo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TXYgjKHv8nvzNo26dnLDESJ40aSXqmhONK2Ms4mXQx4NOKin0QfmopNqacguWBWSV
	 EjEZFjrDdrJufRPZLJnPI2klnYrDAnHtUK9gDnBzvQbqRC9HbA+r72N05IXwmXAXuM
	 Co0DBsbtFELwbttZVt1yAdqzLjsUDqKPpruCWjW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 191/508] soc: qcom: ocmem: make the core clock optional
Date: Wed, 20 May 2026 18:20:14 +0200
Message-ID: <20260520162102.773271640@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit e8a61c51417c679d1a599fb36695e9d3b8d95514 ]

OCMEM's core clock (aka RPM bus 2 clock) is being handled internally by
the interconnect driver. Corresponding clock has been dropped from the
SMD RPM clock driver. The users of the ocmem will vote on the ocmemnoc
interconnect paths, making sure that ocmem is on. Make the clock
optional, keeping it for compatibility with older DT.

Fixes: d6edc31f3a68 ("clk: qcom: smd-rpm: Separate out interconnect bus clocks")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260323-ocmem-v1-1-ad9bcae44763@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/ocmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/ocmem.c b/drivers/soc/qcom/ocmem.c
index 1511d19643d41..c5fc6db9870a2 100644
--- a/drivers/soc/qcom/ocmem.c
+++ b/drivers/soc/qcom/ocmem.c
@@ -313,7 +313,7 @@ static int ocmem_dev_probe(struct platform_device *pdev)
 	ocmem->dev = dev;
 	ocmem->config = device_get_match_data(dev);
 
-	ocmem->core_clk = devm_clk_get(dev, "core");
+	ocmem->core_clk = devm_clk_get_optional(dev, "core");
 	if (IS_ERR(ocmem->core_clk))
 		return dev_err_probe(dev, PTR_ERR(ocmem->core_clk),
 				     "Unable to get core clock\n");
-- 
2.53.0




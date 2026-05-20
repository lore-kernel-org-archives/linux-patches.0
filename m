Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB33F28DC4;
	Wed, 20 May 2026 17:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298388; cv=none; b=D4A4YyLQ0wCGyPV7m3uCFAJ//6bQmpNVzW8umq3viei15VEkjO/k1lY1gR3msHGD30EHo6UFXzBFq3uH45+vjRlcAwT+DgWbptlB1EhbcPgq44I5TLyK1dIc7noqskZW/kA049Wfi3uNpP7WK3QkRVBr+AUHrCTZk16LC/d76zI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298388; c=relaxed/simple;
	bh=BJBsUppjI8w7cTltwBO5Jxk0kRmuUfBkfBMttz+5V8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f5eE10+PbxpJBEEGOdpSRhTdhFfPfZqBxq0L32SWovVhC88T6g2w3NytsGaDx+dbrNaPuyioLti9C7/4e9ZQTPPSV+8K5dZLO4sS0MPnDJma5sBoJyeb+UYpMo8VNw79rVvV4tfP+mEea+QvpW3AWqnYjRAO4yYxX+eb2pEZcpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SScSDF8u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SScSDF8u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19AF71F000E9;
	Wed, 20 May 2026 17:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298386;
	bh=pQqifk2ywwGueuiTOqWzqLv4ge6ayNEiu3Bdu+rxopI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SScSDF8uX8LOau1KfbV8WkGRTyZvTKaAhOzrzB/VNp+moINJcNIWoIEpyPeSBu3TT
	 ca6G+0dckOni8n+HgVvYkQTHCrfKIQtg+plbPL/I/bGeGEx8xl/UJgfV6hTCx723zB
	 +h2+uc7W6sLUI0JQ5UGTNvEPjUWxpyCHvlfKh7oo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 389/957] soc: qcom: ocmem: make the core clock optional
Date: Wed, 20 May 2026 18:14:32 +0200
Message-ID: <20260520162142.963592097@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 71130a2f62e9e..7bcd0c71d7f64 100644
--- a/drivers/soc/qcom/ocmem.c
+++ b/drivers/soc/qcom/ocmem.c
@@ -308,7 +308,7 @@ static int ocmem_dev_probe(struct platform_device *pdev)
 	ocmem->dev = dev;
 	ocmem->config = device_get_match_data(dev);
 
-	ocmem->core_clk = devm_clk_get(dev, "core");
+	ocmem->core_clk = devm_clk_get_optional(dev, "core");
 	if (IS_ERR(ocmem->core_clk))
 		return dev_err_probe(dev, PTR_ERR(ocmem->core_clk),
 				     "Unable to get core clock\n");
-- 
2.53.0




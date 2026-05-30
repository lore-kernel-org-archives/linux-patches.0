Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE9B3AC0FC;
	Sat, 30 May 2026 18:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164357; cv=none; b=AHTjB13PwzZBb+8d5XL1MpzQM3PMXHJAMZgjc1SJM7YgaAdPSTqGWrulW+sBWE5qoKy0A0fRW2k4E6WqtAVvtoXVW9v6/kdtHadOKxmfBMCduwHrlsC/jK5Jo/nOIlOSlCJpESVSTJgZKMIjGXKSXDsmpkyy6H/VSc/oquwyD9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164357; c=relaxed/simple;
	bh=LLwWSG1fCRYLfOxde+LPLUQRU7xzkGWx4/48vBzmuVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lv1mneDR7B7VE54iYVSzw3Eso/h4yClt3Z3Yh7O7A9akdopqXIcTwvP1XrRjOmg4pZEP4JqAV2D7TULbPTVA+VLJg6HZdXZUv8CvI3jI0nJGm6XdnT3BY/SIqqkd4HtJ1qcxMKyIRDK3NWfaQAVKDPVsJ7zQlOg6qz7R5QlmRh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YwcnnDDn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YwcnnDDn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C2AD1F00893;
	Sat, 30 May 2026 18:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164356;
	bh=KpLzqvb1AjhzsYEks4TMfHyl1X7u9JGA2JLc4u2CBsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YwcnnDDnk4ICbjQl/gtbIXgxUjZC+VtKS3oWxYWC8nuW6JvCTUMNmEfXJQ2X/FhMB
	 CXpCN5XkGmw2/o0ZA4OaZMx1KU67ECVaks8OlAm2GzRhawvK2lfBCV+OOlRsMHOjbd
	 MxnyUCCq4wDSz6nGbNi/QAg0JXtZFl85Mugn/ucA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 491/776] soc: qcom: ocmem: return -EPROBE_DEFER is ocmem is not available
Date: Sat, 30 May 2026 18:03:25 +0200
Message-ID: <20260530160253.003776169@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit 91b59009c7d48b58dbc50fecb27f2ad20749a05a ]

If OCMEM is declared in DT, it is expected that it is present and
handled by the driver. The GPU driver will ignore -ENODEV error, which
typically means that OCMEM isn't defined in DT. Let ocmem return
-EPROBE_DEFER if it supposed to be used, but it is not probed (yet).

Fixes: 88c1e9404f1d ("soc: qcom: add OCMEM driver")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260323-ocmem-v1-3-ad9bcae44763@oss.qualcomm.com
[bjorn: s/ERR_PTR(dev_err_probe)/dev_err_ptr_probe/
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/ocmem.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/soc/qcom/ocmem.c b/drivers/soc/qcom/ocmem.c
index 35d96feb6b1e3..1ece9780e555e 100644
--- a/drivers/soc/qcom/ocmem.c
+++ b/drivers/soc/qcom/ocmem.c
@@ -209,10 +209,9 @@ struct ocmem *of_get_ocmem(struct device *dev)
 
 	ocmem = platform_get_drvdata(pdev);
 	put_device(&pdev->dev);
-	if (!ocmem) {
-		dev_err(dev, "Cannot get ocmem\n");
-		return ERR_PTR(-ENODEV);
-	}
+	if (!ocmem)
+		return dev_err_ptr_probe(dev, -EPROBE_DEFER, "Cannot get ocmem\n");
+
 	return ocmem;
 }
 EXPORT_SYMBOL(of_get_ocmem);
-- 
2.53.0




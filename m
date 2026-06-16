Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10BDD2EEE68;
	Tue, 16 Jun 2026 15:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624892; cv=none; b=oCVcYXqqMHqyHfFKIQtAVs8Ih81qvoOrXnDKMrSQHACTyulT0GiqFDI44vaCw5ucrUSLqutTZO3XS9/f6V1KufPgtjaS9pZek5+tq8LYC0ZYtvzbSRqHHCbUeivWfRZBKmzx9Ri1SlDNwTF2QFgxzIMPHUgbiLVFvsKywshpWS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624892; c=relaxed/simple;
	bh=3RXR54x5P7dvzk5PmtAmU+LSkPAa0M3BYimzFvZFdgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N+NDHyM66PvnMpjT9QSFrcvKMPtdHEi8AaP7EHpJMz/fB4mS9T/lljdedRhFTkDvZkUBVZGBDKV4MO0Rdqjfst6QxVzk2VYAoSmLJ9Zc5sLx+PArLftppBSeNUwZcek6riAz0bOg48KvM+NLFY5kqDHDg/0hAsAPnXaFcrGWXvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CnZVzfQU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CnZVzfQU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 917A41F000E9;
	Tue, 16 Jun 2026 15:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624890;
	bh=WPUAHUfoFmAGbVZaYjlapZtpOJc0z0uQ7bXTEcQxUhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CnZVzfQUoaNL8HRcN5PXhqZXGP/yPzwfG1u7fBwA13FLFxFAtZiaaEOBBzCTE/1FQ
	 OvxIfB8wK+mK6741RnrnF1g/v4sJWnVtZURV9GM/11E/Irl08m2YVSvVKc28Nc+yFl
	 +rXWDNS0SnRoLAGEuLtUgjJqiLuW0Ki8YrZVNUDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Garg <sumit.garg@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 014/325] soc: qcom: ice: Return -ENODEV if the ICE platform device is not found
Date: Tue, 16 Jun 2026 20:26:50 +0530
Message-ID: <20260616145058.516250656@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

[ Upstream commit 5a4dc805a80e6fe303d6a4748cd451ea15987ffd ]

By the time the consumer driver calls devm_of_qcom_ice_get(), all the
platform devices for ICE nodes would've been created by
of_platform_default_populate().

So for the absence of any platform device, -ENODEV should not returned, not
-EPROBE_DEFER.

Fixes: 2afbf43a4aec ("soc: qcom: Make the Qualcomm UFS/SDCC ICE a dedicated driver")
Tested-by: Sumit Garg <sumit.garg@oss.qualcomm.com> # OP-TEE as TZ
Acked-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260518-qcom-ice-fix-v7-2-2a595382185b@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/ice.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
index 05055e097ff8fb..ba53aea828ba76 100644
--- a/drivers/soc/qcom/ice.c
+++ b/drivers/soc/qcom/ice.c
@@ -622,7 +622,7 @@ static struct qcom_ice *of_qcom_ice_get(struct device *dev)
 	pdev = of_find_device_by_node(node);
 	if (!pdev) {
 		dev_err(dev, "Cannot find device node %s\n", node->name);
-		return ERR_PTR(-EPROBE_DEFER);
+		return ERR_PTR(-ENODEV);
 	}
 
 	ice = platform_get_drvdata(pdev);
-- 
2.53.0



